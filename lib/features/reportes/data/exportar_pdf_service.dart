import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../dashboard/domain/dashboard_resumen.dart';

/// Servicio local que genera documentos PDF estándar (%PDF-1.4) en Dart puro
/// sin librerías externas para máxima velocidad, portabilidad y cero conflictos de dependencias.
class ExportarPdfService {
  /// Genera los bytes de un documento PDF completo para el reporte mensual.
  static Uint8List generarPdfReporteMensual({
    required String periodo,
    required DashboardResumen resumen,
    required List<CategoriaGastoItem> categorias,
    required List<Movimiento> ultimosMovimientos,
    required Map<int, String> mapaCategorias,
  }) {
    final stream = StringBuffer();

    // 1. Encabezado institucional
    stream.writeln('q');
    // Fondo de cabecera verde Nido (#4B6454 -> 0.294 0.392 0.329)
    stream.writeln('0.294 0.392 0.329 rg');
    stream.writeln('40 760 515 50 re f');

    // Texto de cabecera en blanco
    stream.writeln('1.0 1.0 1.0 rg');
    stream.writeln('BT /F2 18 Tf 55 785 Td (NIDO - Tu hogar, en equilibrio) Tj ET');
    stream.writeln('BT /F1 10 Tf 55 770 Td (Reporte Financiero Mensual - Periodo: $periodo) Tj ET');
    stream.writeln('Q');

    // 2. Tarjeta de Resumen Ejecutivo
    stream.writeln('q');
    stream.writeln('0.95 0.95 0.94 rg');
    stream.writeln('40 645 515 100 re f');
    stream.writeln('0.8 0.8 0.8 RG 1 w 40 645 515 100 re s');

    stream.writeln('0.1 0.1 0.1 rg');
    stream.writeln('BT /F2 12 Tf 55 725 Td (RESUMEN FINANCIERO DEL MES) Tj ET');

    // Columnas de métricas
    final ing = resumen.ingresos.format();
    final gas = resumen.gastosTotales.format();
    final dis = resumen.disponible.format();
    final fijos = resumen.gastosFijos.format();
    final vars = resumen.gastosVariables.format();
    final proy = resumen.aportesProyectos.format();

    stream.writeln('BT /F1 9 Tf 55 700 Td (Total Ingresos:  $ing) Tj ET');
    stream.writeln('BT /F1 9 Tf 55 685 Td (Gastos Fijos:   $fijos) Tj ET');
    stream.writeln('BT /F1 9 Tf 55 670 Td (Gastos Var.:    $vars) Tj ET');

    stream.writeln('BT /F1 9 Tf 240 700 Td (Aportes Proyectos: $proy) Tj ET');
    stream.writeln('BT /F1 9 Tf 240 685 Td (Total Gastado:     $gas) Tj ET');

    // Destacar disponible en negrita
    stream.writeln('BT /F2 11 Tf 240 660 Td (SALDO DISPONIBLE: $dis) Tj ET');
    stream.writeln('Q');

    // 3. Distribución por Categorías
    stream.writeln('q');
    stream.writeln('0.1 0.1 0.1 rg');
    stream.writeln('BT /F2 12 Tf 40 625 Td (DISTRIBUCION DE GASTOS POR CATEGORIA) Tj ET');

    // Tabla de categorías
    double y = 605;
    stream.writeln('0.85 0.85 0.85 rg 40 ${y - 4} 515 16 re f');
    stream.writeln('0.2 0.2 0.2 rg');
    stream.writeln('BT /F2 8 Tf 50 $y Td (Categoria) Tj ET');
    stream.writeln('BT /F2 8 Tf 350 $y Td (Monto) Tj ET');
    stream.writeln('BT /F2 8 Tf 460 $y Td (Porcentaje) Tj ET');

    y -= 16;
    final topCategorias = categorias.take(6).toList();
    if (topCategorias.isEmpty) {
      stream.writeln('BT /F1 9 Tf 50 $y Td (Sin gastos registrados en este periodo) Tj ET');
      y -= 16;
    } else {
      for (final cat in topCategorias) {
        final pctStr = '${(cat.porcentaje * 100).toStringAsFixed(1)}%';
        final montoStr = cat.monto.format();
        final nombreSeguro = _sanearTexto(cat.nombre);

        stream.writeln('0.2 0.2 0.2 rg');
        stream.writeln('BT /F1 8 Tf 50 $y Td ($nombreSeguro) Tj ET');
        stream.writeln('BT /F1 8 Tf 350 $y Td ($montoStr) Tj ET');
        stream.writeln('BT /F1 8 Tf 460 $y Td ($pctStr) Tj ET');

        // Línea divisoria suave
        stream.writeln('0.9 0.9 0.9 RG 0.5 w 40 ${y - 4} m 555 ${y - 4} l s');
        y -= 15;
      }
    }
    stream.writeln('Q');

    // 4. Últimos Movimientos del Periodo
    y -= 15;
    stream.writeln('q');
    stream.writeln('0.1 0.1 0.1 rg');
    stream.writeln('BT /F2 12 Tf 40 $y Td (ULTIMOS MOVIMIENTOS REGISTRADOS) Tj ET');

    y -= 20;
    stream.writeln('0.85 0.85 0.85 rg 40 ${y - 4} 515 16 re f');
    stream.writeln('0.2 0.2 0.2 rg');
    stream.writeln('BT /F2 8 Tf 45 $y Td (Fecha) Tj ET');
    stream.writeln('BT /F2 8 Tf 105 $y Td (Tipo) Tj ET');
    stream.writeln('BT /F2 8 Tf 165 $y Td (Descripcion) Tj ET');
    stream.writeln('BT /F2 8 Tf 370 $y Td (Categoria) Tj ET');
    stream.writeln('BT /F2 8 Tf 480 $y Td (Monto) Tj ET');

    y -= 15;
    final ultimos = ultimosMovimientos.take(10).toList();
    if (ultimos.isEmpty) {
      stream.writeln('BT /F1 8 Tf 45 $y Td (Sin movimientos registrados en este periodo) Tj ET');
      y -= 15;
    } else {
      for (final m in ultimos) {
        final fStr = AppDateFormats.formatSimple(m.fecha);
        final tStr = m.tipo.toUpperCase();
        final descStr = _sanearTexto(m.descripcion.length > 30 ? '${m.descripcion.substring(0, 27)}...' : m.descripcion);
        final catStr = _sanearTexto(mapaCategorias[m.categoriaId] ?? 'General');
        final mStr = Money.fromCents(m.montoCent).format();

        stream.writeln('0.2 0.2 0.2 rg');
        stream.writeln('BT /F1 7.5 Tf 45 $y Td ($fStr) Tj ET');
        stream.writeln('BT /F1 7.5 Tf 105 $y Td ($tStr) Tj ET');
        stream.writeln('BT /F1 7.5 Tf 165 $y Td ($descStr) Tj ET');
        stream.writeln('BT /F1 7.5 Tf 370 $y Td ($catStr) Tj ET');
        stream.writeln('BT /F1 7.5 Tf 480 $y Td ($mStr) Tj ET');

        stream.writeln('0.9 0.9 0.9 RG 0.5 w 40 ${y - 4} m 555 ${y - 4} l s');
        y -= 14;
      }
    }
    stream.writeln('Q');

    // 5. Pie de página institucional y privacidad
    stream.writeln('q');
    stream.writeln('0.5 0.5 0.5 rg');
    stream.writeln('BT /F1 8 Tf 40 40 Td (Nido | 100% Local y Privado | Generado en esta tablet sin internet) Tj ET');
    final ahoraStr = AppDateFormats.formatSimpleHora(DateTime.now());
    stream.writeln('BT /F1 8 Tf 410 40 Td (Emitido: $ahoraStr) Tj ET');
    stream.writeln('Q');

    final contentBytes = latin1.encode(stream.toString());

    // Estructurar el archivo PDF estándar
    return _ensamblarPdf(contentBytes);
  }

  /// Guarda el archivo PDF en el directorio privado de reportes.
  static Future<File> guardarArchivoPdf({
    required String nombreArchivo,
    required Uint8List bytes,
  }) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final reportesDir = Directory('${docsDir.path}/reportes');
    if (!await reportesDir.exists()) {
      await reportesDir.create(recursive: true);
    }

    final file = File('${reportesDir.path}/$nombreArchivo');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Comparte el archivo PDF generado mediante el diálogo nativo de la tablet.
  static Future<void> compartirArchivo(String rutaArchivo, {String? asunto}) async {
    final xFile = XFile(rutaArchivo, mimeType: 'application/pdf');
    await SharePlus.instance.share(
      ShareParams(
        files: [xFile],
        subject: asunto ?? 'Reporte Financiero Nido (PDF)',
        text: 'Reporte financiero en formato PDF generado por Nido.',
      ),
    );
  }

  /// Ensambla los objetos PDF 1.4 con tabla de referencias cruzadas (xref) exacta.
  static Uint8List _ensamblarPdf(Uint8List contentBytes) {
    final buffer = BytesBuilder();

    void writeString(String s) {
      buffer.add(latin1.encode(s));
    }

    writeString('%PDF-1.4\n');
    final offsets = <int>[];

    // Objeto 1: Catalog
    offsets.add(buffer.length);
    writeString('1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n');

    // Objeto 2: Pages
    offsets.add(buffer.length);
    writeString('2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n');

    // Objeto 3: Page (A4: 595 x 842 pt)
    offsets.add(buffer.length);
    writeString(
      '3 0 obj\n'
      '<< /Type /Page /Parent 2 0 R '
      '/MediaBox [0 0 595 842] '
      '/Contents 4 0 R '
      '/Resources << /Font << /F1 5 0 R /F2 6 0 R >> >> '
      '>>\nendobj\n',
    );

    // Objeto 4: Stream de contenido
    offsets.add(buffer.length);
    writeString('4 0 obj\n<< /Length ${contentBytes.length} >>\nstream\n');
    buffer.add(contentBytes);
    writeString('\nendstream\nendobj\n');

    // Objeto 5: Fuente F1 (Helvetica normal)
    offsets.add(buffer.length);
    writeString(
      '5 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n',
    );

    // Objeto 6: Fuente F2 (Helvetica negrita)
    offsets.add(buffer.length);
    writeString(
      '6 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>\nendobj\n',
    );

    // Tabla xref
    final startXref = buffer.length;
    writeString('xref\n0 7\n');
    writeString('0000000000 65535 f \n');
    for (final off in offsets) {
      writeString('${off.toString().padLeft(10, '0')} 00000 n \n');
    }

    // Trailer
    writeString(
      'trailer\n'
      '<< /Size 7 /Root 1 0 R >>\n'
      'startxref\n'
      '$startXref\n'
      '%%EOF\n',
    );

    return buffer.toBytes();
  }

  /// Limpia caracteres especiales para formato de texto de PDF básico.
  static String _sanearTexto(String t) {
    return t
        .replaceAll('(', '\\(')
        .replaceAll(')', '\\)')
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('Á', 'A')
        .replaceAll('É', 'E')
        .replaceAll('Í', 'I')
        .replaceAll('Ó', 'O')
        .replaceAll('Ú', 'U')
        .replaceAll('ñ', 'n')
        .replaceAll('Ñ', 'N');
  }
}