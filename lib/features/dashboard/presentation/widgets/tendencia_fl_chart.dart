import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/money/money.dart';
import '../../domain/dashboard_resumen.dart';
import '../dashboard_providers.dart';

/// Gráfico interactivo de tendencia financiera a 6 y 12 meses utilizando fl_chart.
class TendenciaFlChart extends ConsumerWidget {
  const TendenciaFlChart({
    super.key,
    required this.tendencia,
  });

  final List<TendenciaMesItem> tendencia;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mesesSeleccionados = ref.watch(dashboardMesesTendenciaFiltroProvider);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con título, leyenda y selector 6/12 meses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.show_chart_rounded, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Tendencia Histórica',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 6, label: Text('6 Meses')),
                    ButtonSegment(value: 12, label: Text('12 Meses')),
                  ],
                  selected: {mesesSeleccionados},
                  onSelectionChanged: (newVal) {
                    ref
                        .read(dashboardMesesTendenciaFiltroProvider.notifier)
                        .state = newVal.first;
                  },
                  style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Leyenda de colores
            Row(
              children: [
                _buildIndicador(
                  color: AppColors.income,
                  label: 'Ingresos',
                  theme: theme,
                ),
                const SizedBox(width: 16),
                _buildIndicador(
                  color: AppColors.expense,
                  label: 'Gastos',
                  theme: theme,
                ),
                const SizedBox(width: 16),
                _buildIndicador(
                  color: const Color(0xFF2563EB),
                  label: 'Disponible / Ahorro',
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Gráfico fl_chart
            if (tendencia.isEmpty) ...[
              const SizedBox(
                height: 220,
                child: Center(
                  child: Text('Sin datos históricos suficientes'),
                ),
              ),
            ] else ...[
              SizedBox(
                height: 240,
                child: LineChart(
                  _buildChartData(theme),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndicador({
    required Color color,
    required String label,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  LineChartData _buildChartData(ThemeData theme) {
    double maxY = 0;
    for (final m in tendencia) {
      final yIng = m.ingresos.cents / 100.0;
      final yGas = m.gastos.cents / 100.0;
      final yDis = m.disponible.cents / 100.0;
      maxY = max(maxY, max(yIng, max(yGas, yDis)));
    }
    if (maxY == 0) maxY = 100;
    maxY = maxY * 1.15; // 15% de margen superior

    final spotsIngresos = <FlSpot>[];
    final spotsGastos = <FlSpot>[];
    final spotsDisponible = <FlSpot>[];

    for (int i = 0; i < tendencia.length; i++) {
      final item = tendencia[i];
      spotsIngresos.add(FlSpot(i.toDouble(), item.ingresos.cents / 100.0));
      spotsGastos.add(FlSpot(i.toDouble(), item.gastos.cents / 100.0));
      spotsDisponible.add(FlSpot(i.toDouble(), item.disponible.cents / 100.0));
    }

    return LineChartData(
      minX: 0,
      maxX: (tendencia.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 4,
        getDrawingHorizontalLine: (val) => FlLine(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 52,
            getTitlesWidget: (val, meta) {
              if (val == 0) return const SizedBox.shrink();
              return Text(
                'S/ ${(val >= 1000 ? "${(val / 1000).toStringAsFixed(1)}k" : val.toInt().toString())}',
                style: TextStyle(
                  fontSize: 10,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: (val, meta) {
              final idx = val.toInt();
              if (idx >= 0 && idx < tendencia.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    tendencia[idx].etiqueta,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final idx = spot.spotIndex;
              final item = tendencia[idx];

              String label = 'Disponible';
              Color color = const Color(0xFF2563EB);
              if (spot.barIndex == 0) {
                label = 'Ingresos';
                color = AppColors.income;
              } else if (spot.barIndex == 1) {
                label = 'Gastos';
                color = AppColors.expense;
              }

              final monto = Money.fromCents((spot.y * 100).round()).format();
              return LineTooltipItem(
                '${item.etiqueta} | $label\n$monto',
                TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        // Línea Ingresos (Verde)
        LineChartBarData(
          spots: spotsIngresos,
          isCurved: true,
          color: AppColors.income,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
        // Línea Gastos (Terracota)
        LineChartBarData(
          spots: spotsGastos,
          isCurved: true,
          color: AppColors.expense,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
        ),
        // Línea Disponible (Azul)
        LineChartBarData(
          spots: spotsDisponible,
          isCurved: true,
          color: const Color(0xFF2563EB),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF2563EB).withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}