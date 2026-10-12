import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/utils/date_formatters.dart';

/// Servicio local para generar y compartir reportes financieros en formato CSV (RFC 4180)
/// con codificación UTF-8 BOM para compatibilidad universal con Excel y hojas de cálculo.
class ExportarCsvService {
  /// Genera el contenido CSV estructurado a partir de los datos financieros.
  static String generarCsvMovimientos({
    required String tituloPeriodo,
    required List<Movimiento> movimientos,
    required Map<int, String> mapaCategorias,
    required Map<int, String> mapaCuentas,
  }) {
    final buffer = StringBuffer();

    // UTF-8 BOM para apertura perfecta en Excel en español
    buffer.write('\uFEFF');

    // Encabezados de columnas
    buffer.writeln(
      '"ID","Fecha","Tipo","Categoría","Cuenta Origen","Cuenta Destino","Monto (PEN)","Descripción","Partida ID","Gasto Fijo ID","Notas"',
    );

    for (final m in movimientos) {
      final fechaStr = AppDateFormats.formatSimple(m.fecha);
      final catNombre = mapaCategorias[m.categoriaId] ?? 'Sin Categoría';
      final ctaOrigen = mapaCuentas[m.cuentaOrigenId] ?? 'Desconocida';
      final ctaDestino = m.cuentaDestinoId != null
          ? (mapaCuentas[m.cuentaDestinoId] ?? '')
          : '';
      final montoPen = (m.montoCent / 100).toStringAsFixed(2);
      final partidaStr = m.partidaId != null ? '#${m.partidaId}' : '';
      final gastoFijoStr =
          m.gastoFijoPagoId != null ? '#${m.gastoFijoPagoId}' : '';
      final notasStr = m.notas ?? '';

      buffer.writeln(
        '${m.id},'
        '"$fechaStr",'
        '"${_escaparCsv(m.tipo.toUpperCase())}",'
        '"${_escaparCsv(catNombre)}",'
        '"${_escaparCsv(ctaOrigen)}",'
        '"${_escaparCsv(ctaDestino)}",'
        '$montoPen,'
        '"${_escaparCsv(m.descripcion)}",'
        '"$partidaStr",'
        '"$gastoFijoStr",'
        '"${_escaparCsv(notasStr)}"',
      );
    }

    return buffer.toString();
  }

  /// Guarda el contenido CSV en el directorio privado de reportes y retorna el File.
  static Future<File> guardarArchivoCsv({
    required String nombreArchivo,
    required String contenidoCsv,
  }) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final reportesDir = Directory('${docsDir.path}/reportes');
    if (!await reportesDir.exists()) {
      await reportesDir.create(recursive: true);
    }

    final file = File('${reportesDir.path}/$nombreArchivo');
    await file.writeAsString(contenidoCsv);
    return file;
  }

  /// Abre el diálogo nativo de compartir o guardar el archivo generado.
  static Future<void> compartirArchivo(String rutaArchivo, {String? asunto}) async {
    final xFile = XFile(rutaArchivo);
    await SharePlus.instance.share(
      ShareParams(
        files: [xFile],
        subject: asunto ?? 'Reporte Financiero Nido',
        text: 'Reporte financiero generado por Nido - Tu hogar, en equilibrio.',
      ),
    );
  }

  static String _escaparCsv(String valor) {
    return valor.replaceAll('"', '""');
  }
}