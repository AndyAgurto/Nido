import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/money/money.dart';
import '../../dashboard/presentation/dashboard_providers.dart';
import '../../dashboard/presentation/widgets/tendencia_fl_chart.dart';
import '../../dashboard/presentation/widgets/gastos_categoria_pie_chart.dart';
import 'dialogs/exportar_reporte_dialog.dart';

/// Pantalla dedicada a Reportes Financieros, análisis histórico y exportación de datos.
class ReportesPage extends ConsumerWidget {
  const ReportesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 720;
    final tendenciaAsync = ref.watch(dashboardTendenciaStreamProvider);
    final categoriasAsync = ref.watch(dashboardGastosCategoriasStreamProvider);

    return Scaffold(
      appBar: isMobile ? null : AppBar(
        leading: isMobile
            ? Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  tooltip: 'Menú',
                  onPressed: () => ctx.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer(),
                ),
              )
            : null,
        title: const Text('Reportes Financieros'),
        actions: [
          if (isMobile)
            IconButton.filled(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const ExportarReporteDialog(),
                );
              },
              icon: const Icon(Icons.download_rounded),
              tooltip: 'Exportar CSV / PDF',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 16.0,
          bottom: MediaQuery.paddingOf(context).bottom + 88,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera de la sección
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reportes Financieros',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Análisis de tendencias, distribución de gastos y exportación 100% local',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (!isMobile)
                  FilledButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ExportarReporteDialog(),
                      );
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Exportar CSV / PDF'),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // 1. Gráfico de Tendencia Histórica
            tendenciaAsync.when(
              data: (tend) => TendenciaFlChart(tendencia: tend),
              loading: () => const _LoadingCard(height: 280),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
            const SizedBox(height: 24),

            // 2. Gráfico de distribución de gastos del periodo
            categoriasAsync.when(
              data: (cats) => GastosCategoriaPieChart(categorias: cats),
              loading: () => const _LoadingCard(height: 240),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
            const SizedBox(height: 24),

            // 3. Tabla de Evolución Mensual
            tendenciaAsync.when(
              data: (tend) => _buildTablaEvolucion(tend, theme),
              loading: () => const _LoadingCard(height: 200),
              error: (err, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTablaEvolucion(List<dynamic> tendencia, ThemeData theme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.table_rows_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Evolución Mensual Detallada',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                ),
                columns: const [
                  DataColumn(label: Text('Periodo')),
                  DataColumn(label: Text('Ingresos')),
                  DataColumn(label: Text('Gastos')),
                  DataColumn(label: Text('Disponible')),
                  DataColumn(label: Text('Tasa Ahorro')),
                ],
                rows: tendencia.reversed.map((t) {
                  final ing = t.ingresos as Money;
                  final gas = t.gastos as Money;
                  final dis = t.disponible as Money;
                  final tasa = ing.cents > 0 ? (dis.cents / ing.cents) : 0.0;
                  final esPositivo = dis.cents >= 0;

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          t.periodo.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataCell(
                        Text(
                          ing.format(),
                          style: const TextStyle(color: AppColors.income),
                        ),
                      ),
                      DataCell(
                        Text(
                          gas.format(),
                          style: const TextStyle(color: AppColors.expense),
                        ),
                      ),
                      DataCell(
                        Text(
                          dis.format(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: esPositivo
                                ? AppColors.primary
                                : AppColors.expense,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${(tasa * 100).toInt()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: esPositivo
                                ? AppColors.income
                                : AppColors.expense,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.height});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}