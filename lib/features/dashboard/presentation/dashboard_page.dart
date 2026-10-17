import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/date_formatters.dart';
import 'dashboard_providers.dart';
import 'widgets/resumen_financiero_card.dart';
import 'widgets/gastos_categoria_pie_chart.dart';
import 'widgets/tendencia_fl_chart.dart';
import 'widgets/vencimientos_resumen_card.dart';
import 'widgets/presupuestos_resumen_card.dart';
import 'widgets/proyectos_resumen_card.dart';
import '../../reportes/presentation/dialogs/exportar_reporte_dialog.dart';

/// Pantalla de Dashboard Mensual optimizada para Tablet.
/// Presenta tarjetas de resumen financiero, comparación con mes anterior, gráfico de categorías,
/// tendencia con fl_chart, próximos vencimientos, presupuestos y proyectos.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 720;
    final periodo = ref.watch(dashboardPeriodoSeleccionadoProvider);

    final resumenAsync = ref.watch(dashboardResumenStreamProvider);
    final categoriasAsync = ref.watch(dashboardGastosCategoriasStreamProvider);
    final tendenciaAsync = ref.watch(dashboardTendenciaStreamProvider);
    final vencimientosAsync = ref.watch(dashboardVencimientosStreamProvider);
    final presupuestosAsync = ref.watch(dashboardPresupuestosStreamProvider);
    final proyectosAsync = ref.watch(dashboardProyectosActivosStreamProvider);

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
        title: const Text('Dashboard'),
        actions: [
          if (isMobile)
            IconButton.filledTonal(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const ExportarReporteDialog(),
                );
              },
              icon: const Icon(Icons.file_download_outlined),
              tooltip: 'Exportar Reporte',
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Barra de cabecera con selector de mes y botón de exportar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(isMobile ? 12 : 24, 12, isMobile ? 12 : 24, 12),
              child: _buildHeader(context, ref, periodo, theme),
            ),
          ),

          // Contenido principal del dashboard
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 24),
            sliver: SliverToBoxAdapter(
              child: resumenAsync.when(
                data: (resumen) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Tarjetas de Resumen Financiero y Comparativa
                      ResumenFinancieroCard(resumen: resumen),
                      const SizedBox(height: 20),

                      // 2. Gráficos y Desgloses en 2 Columnas para Tablet
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final esTabletAncha = constraints.maxWidth >= 840;

                          if (esTabletAncha) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Columna Izquierda: Gráficos fl_chart
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    children: [
                                      categoriasAsync.when(
                                        data: (cats) =>
                                            GastosCategoriaPieChart(
                                                categorias: cats),
                                        loading: () => const _LoadingCard(
                                            height: 260),
                                        error: (_, _) => const SizedBox.shrink(),
                                      ),
                                      const SizedBox(height: 20),
                                      tendenciaAsync.when(
                                        data: (tend) =>
                                            TendenciaFlChart(tendencia: tend),
                                        loading: () => const _LoadingCard(
                                            height: 280),
                                        error: (_, _) => const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),

                                // Columna Derecha: Vencimientos, Presupuestos y Proyectos
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      vencimientosAsync.when(
                                        data: (pagos) =>
                                            VencimientosResumenCard(
                                                pagos: pagos),
                                        loading: () => const _LoadingCard(
                                            height: 200),
                                        error: (_, _) => const SizedBox.shrink(),
                                      ),
                                      const SizedBox(height: 20),
                                      presupuestosAsync.when(
                                        data: (pres) =>
                                            PresupuestosResumenCard(
                                                presupuestos: pres),
                                        loading: () => const _LoadingCard(
                                            height: 220),
                                        error: (_, _) => const SizedBox.shrink(),
                                      ),
                                      const SizedBox(height: 20),
                                      proyectosAsync.when(
                                        data: (proys) =>
                                            ProyectosResumenCard(
                                                proyectos: proys),
                                        loading: () => const _LoadingCard(
                                            height: 180),
                                        error: (_, _) => const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }

                          // Layout vertical para pantallas menores a 840dp
                          return Column(
                            children: [
                              categoriasAsync.when(
                                data: (cats) =>
                                    GastosCategoriaPieChart(categorias: cats),
                                loading: () => const _LoadingCard(height: 260),
                                error: (_, _) => const SizedBox.shrink(),
                              ),
                              const SizedBox(height: 20),
                              tendenciaAsync.when(
                                data: (tend) =>
                                    TendenciaFlChart(tendencia: tend),
                                loading: () => const _LoadingCard(height: 280),
                                error: (_, _) => const SizedBox.shrink(),
                              ),
                              const SizedBox(height: 20),
                              vencimientosAsync.when(
                                data: (pagos) =>
                                    VencimientosResumenCard(pagos: pagos),
                                loading: () => const _LoadingCard(height: 200),
                                error: (_, _) => const SizedBox.shrink(),
                              ),
                              const SizedBox(height: 20),
                              presupuestosAsync.when(
                                data: (pres) =>
                                    PresupuestosResumenCard(presupuestos: pres),
                                loading: () => const _LoadingCard(height: 220),
                                error: (_, _) => const SizedBox.shrink(),
                              ),
                              const SizedBox(height: 20),
                              proyectosAsync.when(
                                data: (proys) =>
                                    ProyectosResumenCard(proyectos: proys),
                                loading: () => const _LoadingCard(height: 180),
                                error: (_, _) => const SizedBox.shrink(),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (err, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text('Error al cargar datos del dashboard: $err'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    String periodo,
    ThemeData theme,
  ) {
    final parts = periodo.split('-');
    final anio = int.parse(parts[0]);
    final mes = int.parse(parts[1]);
    final fechaActual = DateTime(anio, mes, 1);
    final mesNombre = AppDateFormats.formatMesAnio(fechaActual);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Selector de Periodo Mensual con navegación
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              tooltip: 'Mes anterior',
              onPressed: () {
                final prev = DateTime(anio, mes - 1, 1);
                ref.read(dashboardPeriodoSeleccionadoProvider.notifier).state =
                    '${prev.year}-${prev.month.toString().padLeft(2, '0')}';
              },
            ),
            const SizedBox(width: 4),
            Text(
              mesNombre,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              tooltip: 'Mes siguiente',
              onPressed: () {
                final next = DateTime(anio, mes + 1, 1);
                ref.read(dashboardPeriodoSeleccionadoProvider.notifier).state =
                    '${next.year}-${next.month.toString().padLeft(2, '0')}';
              },
            ),
          ],
        ),

        // Botón de Exportar Reporte (visible solo en tablet)
        if (MediaQuery.of(context).size.width >= 720)
          FilledButton.tonalIcon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const ExportarReporteDialog(),
              );
            },
            icon: const Icon(Icons.file_download_outlined, size: 20),
            label: const Text('Exportar Reporte'),
          ),
      ],
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
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}