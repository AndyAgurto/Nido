import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../dashboard/presentation/dashboard_providers.dart';
import '../../data/exportar_csv_service.dart';
import '../../data/exportar_pdf_service.dart';

/// Modal para seleccionar formato (CSV o PDF) y exportar reportes financieros localmente.
class ExportarReporteDialog extends ConsumerStatefulWidget {
  const ExportarReporteDialog({super.key});

  @override
  ConsumerState<ExportarReporteDialog> createState() =>
      _ExportarReporteDialogState();
}

class _ExportarReporteDialogState extends ConsumerState<ExportarReporteDialog> {
  String _formato = 'pdf'; // 'pdf' o 'csv'
  bool _generando = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periodo = ref.watch(dashboardPeriodoSeleccionadoProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.dialogBorderRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: const Icon(Icons.file_download_outlined,
                        color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exportar Reporte',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Periodo: $periodo (100% local)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Selecciona el formato de exportación:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Opciones de formato
              Row(
                children: [
                  Expanded(
                    child: _buildFormatoCard(
                      valor: 'pdf',
                      titulo: 'Documento PDF',
                      descripcion: 'Resumen ejecutivo con tablas y diseño formal',
                      icono: Icons.picture_as_pdf_outlined,
                      color: const Color(0xFFDC2626),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFormatoCard(
                      valor: 'csv',
                      titulo: 'Archivo CSV',
                      descripcion: 'Datos brutos compatibles con Excel / Sheets',
                      icono: Icons.table_chart_outlined,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined,
                        size: 20, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Los archivos se guardan en el sandbox privado de tu tablet sin pasar por servidores externos.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _generando ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: _generando ? null : _ejecutarExportacion,
                    icon: _generando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.share_outlined),
                    label: Text(_generando ? 'Generando...' : 'Exportar y Compartir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatoCard({
    required String valor,
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Color color,
  }) {
    final seleccionado = _formato == valor;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => setState(() => _formato = valor),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: seleccionado
              ? color.withValues(alpha: 0.08)
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: seleccionado ? color : theme.colorScheme.outlineVariant,
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icono, color: color, size: 28),
                if (seleccionado)
                  Icon(Icons.check_circle_rounded, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              titulo,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              descripcion,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ejecutarExportacion() async {
    setState(() => _generando = true);
    final periodo = ref.read(dashboardPeriodoSeleccionadoProvider);

    try {
      final movsDao = ref.read(movimientosDaoProvider);
      final catsDao = ref.read(categoriasDaoProvider);
      final cuentasDao = ref.read(cuentasDaoProvider);

      // Cargar datos
      final parts = periodo.split('-');
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final inicio = DateTime(y, m, 1);
      final fin = DateTime(y, m + 1, 0, 23, 59, 59, 999);

      final movs = await movsDao
          .watchMovimientos(desde: inicio, hasta: fin, incluirAnulados: false)
          .first;
      final categorias = await catsDao.getCategorias();
      final catMap = {for (final c in categorias) c.id: c.nombre};

      final cuentas = await cuentasDao.getAllCuentas();
      final cuentasMap = {for (final c in cuentas) c.id: c.nombre};

      if (_formato == 'csv') {
        final csvContent = ExportarCsvService.generarCsvMovimientos(
          tituloPeriodo: periodo,
          movimientos: movs,
          mapaCategorias: catMap,
          mapaCuentas: cuentasMap,
        );
        final file = await ExportarCsvService.guardarArchivoCsv(
          nombreArchivo: 'nido_reporte_$periodo.csv',
          contenidoCsv: csvContent,
        );
        if (mounted) {
          Navigator.pop(context);
          await ExportarCsvService.compartirArchivo(file.path);
        }
      } else {
        final resumen = await movsDao.calcularResumenMensual(periodo);
        final catsDesglose = await movsDao.obtenerGastosPorCategoria(periodo);

        final pdfBytes = ExportarPdfService.generarPdfReporteMensual(
          periodo: periodo,
          resumen: resumen,
          categorias: catsDesglose,
          ultimosMovimientos: movs,
          mapaCategorias: catMap,
        );

        final file = await ExportarPdfService.guardarArchivoPdf(
          nombreArchivo: 'nido_reporte_$periodo.pdf',
          bytes: pdfBytes,
        );

        if (mounted) {
          Navigator.pop(context);
          await ExportarPdfService.compartirArchivo(file.path);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _generando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar: $e'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    }
  }
}