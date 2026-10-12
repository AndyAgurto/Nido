// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:nido/core/audit/audit_entry.dart';
import 'package:nido/core/audit/audit_service.dart';
import 'package:nido/core/audit/audited_writer.dart';
import 'package:nido/core/database/app_database.dart';
import 'package:nido/core/providers/database_providers.dart';
import 'package:nido/core/security/seguridad_providers.dart';
import 'package:nido/core/security/seguridad_service.dart';
import 'package:nido/features/ajustes/data/respaldo_service.dart';
import 'package:nido/features/auditoria/presentation/auditoria_page.dart';
import 'package:nido/features/auditoria/presentation/widgets/auditoria_diff_viewer.dart';
import 'package:nido/features/seguridad/presentation/pin_lock_screen.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  FakePathProviderPlatform(this.tempPath);
  final String tempPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => tempPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late AppDatabase db;
  late AuditedWriter writer;
  late AuditService auditService;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('nido_fase6_test_');
    PathProviderPlatform.instance = FakePathProviderPlatform(tempDir.path);
    FlutterSecureStorage.setMockInitialValues({});

    db = AppDatabase(NativeDatabase.memory());
    writer = AuditedWriter(db);
    auditService = AuditService(db);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Fase 6 - Auditoría: Pantalla de Solo Lectura y Visor de Diferencias (Diff)', () {
    testWidgets('AuditoriaDiffViewer compara valor anterior y nuevo con resaltado', (tester) async {
      final anterior = {
        'nombre': 'Almuerzo de Trabajo',
        'montoCentimos': 3500,
        'anulado': false,
      };
      final nuevo = {
        'nombre': 'Almuerzo de Trabajo (Corregido)',
        'montoCentimos': 4200,
        'anulado': false,
      };

      final registro = AuditoriaData(
        id: 1,
        entidad: 'Movimientos',
        entidadId: 10,
        accion: 'modificar',
        valorAnteriorJson: jsonEncode(anterior),
        valorNuevoJson: jsonEncode(nuevo),
        resumen: 'Ajuste de precio en almuerzo',
        fechaHora: DateTime.now(),
        creadoEn: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: AuditoriaDiffViewer(
                registro: registro,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Detalle de Cambios (Diff Antes / Después)'), findsOneWidget);
      expect(find.text('Registro inmutable de auditoría (Solo lectura)'), findsOneWidget);
      expect(find.textContaining('Almuerzo de Trabajo (Corregido)'), findsWidgets);
      expect(find.textContaining('4200'), findsWidgets);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets('AuditoriaPage es 100% de solo lectura y renderiza layout en tablet', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      // Insertar un registro de auditoría en la BD en memoria
      await writer.write<void>(
        action: () async {},
        auditBuilder: (_) => const AuditEntry(
          entidad: 'Cuentas',
          entidadId: 1,
          accion: 'crear',
          valorNuevo: {'nombre': 'Billetera Principal', 'saldo': 15000},
          resumen: 'Creación de cuenta de prueba',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
          ],
          child: const MaterialApp(
            home: AuditoriaPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bitácora de Auditoría'), findsOneWidget);
      expect(find.text('100% INMUTABLE'), findsOneWidget);
      expect(find.textContaining('Billetera Principal'), findsWidgets);

      // Desmontar el árbol para liberar timers de Drift
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  });

  group('Fase 6 - Seguridad Local: Hashing SHA-256 con Sal de 32 bytes y PIN Lock', () {
    test('SeguridadService guarda PIN con sal criptográfica y valida correctamente', () async {
      final service = SeguridadService();

      expect(await service.tienePinConfigurado(), isFalse);

      // Guardar PIN
      await service.guardarPin('1234');
      expect(await service.tienePinConfigurado(), isTrue);

      // Validar PIN correcto
      final ok = await service.validarPin('1234');
      expect(ok, isTrue);

      // Validar PIN incorrecto
      final fail = await service.validarPin('9999');
      expect(fail, isFalse);

      // Desactivar PIN
      await service.desactivarPin();
      expect(await service.tienePinConfigurado(), isFalse);
      expect(await service.validarPin('1234'), isFalse);
    });

    testWidgets('PinLockScreen permite ingresar PIN de 4 dígitos y desbloquear', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final service = SeguridadService();
      await service.guardarPin('1234');

      var desbloqueado = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            seguridadServiceProvider.overrideWithValue(service),
          ],
          child: MaterialApp(
            home: PinLockScreen(
              onDesbloqueado: () {
                desbloqueado = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nido Protegido'), findsOneWidget);

      // Presionar 1, 2, 3, 4 en el teclado numérico
      await tester.tap(find.widgetWithText(InkWell, '1'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(InkWell, '2'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(InkWell, '3'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(InkWell, '4'));
      await tester.pumpAndSettle();

      expect(desbloqueado, isTrue);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });
  });

  group('Fase 6 - Respaldo Portable ZIP: Exportar, Integridad SHA-256, Versión y Copia Previa', () {
    test('Exportar Respaldo genera .zip válido con metadata, checksum SHA-256 y auditoría', () async {
      // Crear archivo nido_db.sqlite ficticio en la carpeta simulada
      final sqliteFile = File('${tempDir.path}/nido_db.sqlite');
      await sqliteFile.writeAsString('SQLITE_DATA_CONTENIDO_PRUEBA');

      final zipFile = await RespaldoService.exportarRespaldo(db: db, writer: writer);

      expect(await zipFile.exists(), isTrue);
      expect(zipFile.path.endsWith('.zip'), isTrue);

      // Descomprimir y verificar contenido
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final metaFile = archive.findFile('backup_meta.json');
      expect(metaFile, isNotNull);

      final metaMap = jsonDecode(utf8.decode(metaFile!.content as List<int>)) as Map<String, dynamic>;
      expect(metaMap['app'], equals('Nido'));
      expect(metaMap['schemaVersion'], equals(1));
      expect(metaMap['checksumSqlite'], isNotEmpty);

      // Verificar que se registró en la auditoría
      final auditList = await auditService.getAuditoria(limit: 10);
      expect(auditList.any((a) => a.accion == 'exportar' && a.entidad == 'Sistema'), isTrue);
    });

    test('Validar e Importar Respaldo crea copia de seguridad previa y reemplaza datos', () async {
      final sqliteFile = File('${tempDir.path}/nido_db.sqlite');
      await sqliteFile.writeAsString('BASE_ACTIVA_ORIGINAL');

      // Crear archivo ZIP de respaldo válido en memoria
      final sqliteData = utf8.encode('BASE_RESTAURADA_DESDE_BACKUP');
      final checksum = sha256.convert(sqliteData).toString();

      final metaMap = {
        'app': 'Nido',
        'schemaVersion': 1,
        'checksumSqlite': checksum,
      };

      final archive = Archive();
      archive.addFile(ArchiveFile('nido.sqlite', sqliteData.length, sqliteData));
      archive.addFile(ArchiveFile('backup_meta.json', utf8.encode(jsonEncode(metaMap)).length, utf8.encode(jsonEncode(metaMap))));

      final zipBytes = ZipEncoder().encode(archive);

      final exito = await RespaldoService.validarEImportarRespaldo(
        zipBytes: Uint8List.fromList(zipBytes),
        db: db,
        writer: writer,
      );

      expect(exito, isTrue);

      // 1. Verificar que la base física fue actualizada
      final contenidoNuevo = await sqliteFile.readAsString();
      expect(contenidoNuevo, equals('BASE_RESTAURADA_DESDE_BACKUP'));

      // 2. Verificar que se creó la COPIA PREVIA de seguridad (Safety Copy)
      final archivosEnTemp = await tempDir.list().toList();
      final tieneCopiaPrevia = archivosEnTemp.any(
        (e) => e.path.contains('nido_db.sqlite.pre_restore_'),
      );
      expect(tieneCopiaPrevia, isTrue);
    });

    test('Validar e Importar rechaza versión de esquema incompatible (v2 > v1)', () async {
      final sqliteData = utf8.encode('BASE_FUTURA');
      final checksum = sha256.convert(sqliteData).toString();

      final metaMap = {
        'app': 'Nido',
        'schemaVersion': 2, // Versión futura incompatible
        'checksumSqlite': checksum,
      };

      final archive = Archive();
      archive.addFile(ArchiveFile('nido.sqlite', sqliteData.length, sqliteData));
      archive.addFile(ArchiveFile('backup_meta.json', utf8.encode(jsonEncode(metaMap)).length, utf8.encode(jsonEncode(metaMap))));

      final zipBytes = ZipEncoder().encode(archive);

      expect(
        () async => await RespaldoService.validarEImportarRespaldo(
          zipBytes: Uint8List.fromList(zipBytes),
          db: db,
          writer: writer,
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('v2 > v1'),
        )),
      );
    });

    test('Validar e Importar rechaza respaldo con checksum SHA-256 alterado', () async {
      final sqliteData = utf8.encode('BASE_CORRUPTA');
      const checksumInvalido = 'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890';

      final metaMap = {
        'app': 'Nido',
        'schemaVersion': 1,
        'checksumSqlite': checksumInvalido,
      };

      final archive = Archive();
      archive.addFile(ArchiveFile('nido.sqlite', sqliteData.length, sqliteData));
      archive.addFile(ArchiveFile('backup_meta.json', utf8.encode(jsonEncode(metaMap)).length, utf8.encode(jsonEncode(metaMap))));

      final zipBytes = ZipEncoder().encode(archive);

      expect(
        () async => await RespaldoService.validarEImportarRespaldo(
          zipBytes: Uint8List.fromList(zipBytes),
          db: db,
          writer: writer,
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('checksum SHA-256'),
        )),
      );
    });

    test('Recordatorio de Respaldo (>30 días o nunca)', () async {
      // 1. Sin respaldos previos registrados -> requiere recordatorio
      expect(await RespaldoService.requiereRecordatorioRespaldo(db.ajustesDao), isTrue);

      // 2. Respaldo reciente (hace 5 días) -> NO requiere recordatorio
      final hace5Dias = DateTime.now().subtract(const Duration(days: 5));
      await db.ajustesDao.setValor(RespaldoService.keyUltimoRespaldo, hace5Dias.toIso8601String());
      expect(await RespaldoService.requiereRecordatorioRespaldo(db.ajustesDao), isFalse);

      // 3. Respaldo antiguo (hace 35 días) -> SÍ requiere recordatorio (>30 días)
      final hace35Dias = DateTime.now().subtract(const Duration(days: 35));
      await db.ajustesDao.setValor(RespaldoService.keyUltimoRespaldo, hace35Dias.toIso8601String());
      expect(await RespaldoService.requiereRecordatorioRespaldo(db.ajustesDao), isTrue);
    });
  });
}
