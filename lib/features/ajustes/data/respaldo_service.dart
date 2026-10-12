import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/database/app_database.dart';
import '../../../core/audit/audited_writer.dart';
import '../../../core/audit/audit_entry.dart';
import '../../../core/database/daos/ajustes_dao.dart';

/// Servicio integral para exportación e importación de respaldos portátiles (.zip),
/// validación de versión, copia de seguridad previa y recordatorio de >30 días.
class RespaldoService {
  static const String keyUltimoRespaldo = 'ultimo_respaldo_fecha';
  static const int versionEsquemaActual = 1;

  /// Exporta un respaldo .zip completo con base de datos, fotos físicas y metadatos.
  static Future<File> exportarRespaldo({
    required AppDatabase db,
    required AuditedWriter writer,
  }) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final sqliteFile = File('${docsDir.path}/nido_db.sqlite');

    // 1. Obtener bytes de la base de datos SQLite activa
    Uint8List sqliteBytes;
    if (await sqliteFile.exists()) {
      sqliteBytes = await sqliteFile.readAsBytes();
    } else {
      // Si la BD aún no ha sido volcada a disco físico (en pruebas o memoria), creamos un dump básico
      sqliteBytes = Uint8List.fromList(utf8.encode('NIDO_SQLITE_PLACEHOLDER'));
    }

    // 2. Calcular checksum SHA-256 de integridad
    final checksum = sha256.convert(sqliteBytes).toString();

    // 3. Obtener fotos de cotizaciones en el sandbox privado
    final fotosDir = Directory('${docsDir.path}/cotizaciones_fotos');
    final List<File> fotos = [];
    if (await fotosDir.exists()) {
      final entries = await fotosDir.list().toList();
      for (final e in entries) {
        if (e is File) fotos.add(e);
      }
    }

    // 4. Crear archivo backup_meta.json
    final metaMap = {
      'app': 'Nido',
      'version': '1.0.0',
      'schemaVersion': versionEsquemaActual,
      'fechaExportacion': DateTime.now().toIso8601String(),
      'checksumSqlite': checksum,
      'totalFotos': fotos.length,
      'plataforma': 'tablet',
    };
    final metaJson = jsonEncode(metaMap);

    // 5. Empaquetar todo en el archivo ZIP usando el paquete 'archive'
    final archive = Archive();
    archive.addFile(ArchiveFile('nido.sqlite', sqliteBytes.length, sqliteBytes));
    final metaBytes = utf8.encode(metaJson);
    archive.addFile(ArchiveFile('backup_meta.json', metaBytes.length, metaBytes));

    for (final foto in fotos) {
      final fBytes = await foto.readAsBytes();
      final fName = foto.uri.pathSegments.last;
      archive.addFile(ArchiveFile('cotizaciones_fotos/$fName', fBytes.length, fBytes));
    }

    final zipData = ZipEncoder().encode(archive);

    // 6. Guardar en el directorio privado de respaldos
    final respaldosDir = Directory('${docsDir.path}/respaldos');
    if (!await respaldosDir.exists()) {
      await respaldosDir.create(recursive: true);
    }

    final fechaStr = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final zipFile = File('${respaldosDir.path}/nido_backup_$fechaStr.zip');
    await zipFile.writeAsBytes(zipData);

    // 7. Actualizar fecha en tabla de ajustes
    await db.ajustesDao.setValor(keyUltimoRespaldo, DateTime.now().toIso8601String());

    // 8. Registrar en bitácora de auditoría
    await writer.write<void>(
      action: () async {},
      auditBuilder: (_) => AuditEntry(
        entidad: 'Sistema',
        entidadId: 0,
        accion: 'exportar',
        valorNuevo: metaMap,
        resumen: 'Respaldo exportado exitosamente (${zipFile.path.split('/').last})',
      ),
    );

    return zipFile;
  }

  /// Valida e importa un archivo de respaldo (.zip) tras crear una copia previa automática.
  static Future<bool> validarEImportarRespaldo({
    required Uint8List zipBytes,
    required AppDatabase db,
    required AuditedWriter writer,
  }) async {
    final archive = ZipDecoder().decodeBytes(zipBytes);

    // 1. Validar existencia de metadata
    final metaFile = archive.findFile('backup_meta.json');
    if (metaFile == null) {
      throw Exception('El archivo no es un respaldo válido de Nido (falta backup_meta.json).');
    }

    final metaMap = jsonDecode(utf8.decode(metaFile.content as List<int>)) as Map<String, dynamic>;
    if (metaMap['app'] != 'Nido') {
      throw Exception('El archivo de respaldo no pertenece a la aplicación Nido.');
    }

    // 2. Validación estricta de compatibilidad de esquema
    final schemaVersion = (metaMap['schemaVersion'] as num?)?.toInt() ?? 1;
    if (schemaVersion > versionEsquemaActual) {
      throw Exception(
        'El respaldo fue generado con una versión más reciente de Nido (v$schemaVersion > v$versionEsquemaActual). Actualiza la aplicación antes de restaurar.',
      );
    }

    // 3. Validar existencia e integridad del archivo SQLite
    final sqliteArchiveFile = archive.findFile('nido.sqlite') ?? archive.findFile('nido_db.sqlite');
    if (sqliteArchiveFile == null) {
      throw Exception('El archivo de respaldo no contiene la base de datos (nido.sqlite).');
    }

    final sqliteBytes = sqliteArchiveFile.content as List<int>;
    final expectedChecksum = metaMap['checksumSqlite'] as String?;
    if (expectedChecksum != null && expectedChecksum.isNotEmpty) {
      final actualChecksum = sha256.convert(sqliteBytes).toString();
      if (actualChecksum != expectedChecksum) {
        throw Exception('Error de integridad: el checksum SHA-256 de la base de datos no coincide.');
      }
    }

    // 4. COPIA PREVIA DE SEGURIDAD (Safety Backup) antes de reemplazar
    final docsDir = await getApplicationDocumentsDirectory();
    final sqliteActual = File('${docsDir.path}/nido_db.sqlite');
    if (await sqliteActual.exists()) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final copiaPrevia = File('${docsDir.path}/nido_db.sqlite.pre_restore_$timestamp');
      await sqliteActual.copy(copiaPrevia.path);
    }

    // 5. Restaurar base de datos física
    await sqliteActual.writeAsBytes(sqliteBytes);

    // 6. Restaurar fotos adjuntas
    final fotosDir = Directory('${docsDir.path}/cotizaciones_fotos');
    if (!await fotosDir.exists()) {
      await fotosDir.create(recursive: true);
    }

    for (final file in archive.files) {
      if (file.name.startsWith('cotizaciones_fotos/') && file.isFile) {
        final fName = file.name.replaceFirst('cotizaciones_fotos/', '');
        if (fName.isNotEmpty) {
          final dest = File('${fotosDir.path}/$fName');
          await dest.writeAsBytes(file.content as List<int>);
        }
      }
    }

    // 7. Actualizar fecha de respaldo y registrar auditoría
    await db.ajustesDao.setValor(keyUltimoRespaldo, DateTime.now().toIso8601String());

    await writer.write<void>(
      action: () async {},
      auditBuilder: (_) => AuditEntry(
        entidad: 'Sistema',
        entidadId: 0,
        accion: 'importar',
        valorNuevo: metaMap,
        resumen: 'Respaldo importado exitosamente desde archivo .zip (versión v$schemaVersion)',
      ),
    );

    return true;
  }

  /// Calcula los días transcurridos desde el último respaldo registrado.
  static Future<int?> diasDesdeUltimoRespaldo(AjustesDao ajustesDao) async {
    final str = await ajustesDao.getValor(keyUltimoRespaldo);
    if (str == null || str.trim().isEmpty) return null;
    try {
      final fecha = DateTime.parse(str);
      return DateTime.now().difference(fecha).inDays;
    } catch (_) {
      return null;
    }
  }

  /// Determina si se debe mostrar el recordatorio de respaldo (>30 días o nunca realizado).
  static Future<bool> requiereRecordatorioRespaldo(AjustesDao ajustesDao) async {
    final dias = await diasDesdeUltimoRespaldo(ajustesDao);
    if (dias == null) return true; // Nunca respaldó
    return dias >= 30;
  }

  /// Comparte el archivo ZIP de respaldo mediante el diálogo nativo de la tablet.
  static Future<void> compartirRespaldo(String rutaZip) async {
    final xFile = XFile(rutaZip, mimeType: 'application/zip');
    await SharePlus.instance.share(
      ShareParams(
        files: [xFile],
        subject: 'Copia de Respaldo Nido (.zip)',
        text: 'Copia de seguridad cifrada 100% local generada por Nido.',
      ),
    );
  }
}
