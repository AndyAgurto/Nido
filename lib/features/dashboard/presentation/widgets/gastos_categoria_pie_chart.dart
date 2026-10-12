import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/dashboard_resumen.dart';

/// Gráfico de distribución de gastos por categoría utilizando fl_chart.
class GastosCategoriaPieChart extends StatefulWidget {
  const GastosCategoriaPieChart({
    super.key,
    required this.categorias,
  });

  final List<CategoriaGastoItem> categorias;

  @override
  State<GastosCategoriaPieChart> createState() =>
      _GastosCategoriaPieChartState();
}

class _GastosCategoriaPieChartState extends State<GastosCategoriaPieChart> {
  int _touchedIndex = -1;

  static const List<Color> _palette = [
    Color(0xFF4B6454), // Verde Salvia Nido
    Color(0xFFEAB308), // Ámbar Cálido
    Color(0xFF3B82F6), // Azul Pizarra
    Color(0xFFB84A28), // Terracota
    Color(0xFF10B981), // Esmeralda
    Color(0xFF8B5CF6), // Violeta
    Color(0xFFEC4899), // Rosa
    Color(0xFF64748B), // Acero
  ];

  Color _getColor(int idx, String? colorHex) {
    if (colorHex != null && colorHex.startsWith('#') && colorHex.length == 7) {
      try {
        final hex = colorHex.substring(1);
        return Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }
    return _palette[idx % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                const Icon(Icons.pie_chart_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Gastos por Categoría',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (widget.categorias.isEmpty) ...[
              Container(
                height: 220,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sin gastos registrados en este mes',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              SizedBox(
                height: 220,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  _touchedIndex = -1;
                                  return;
                                }
                                _touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 3,
                          centerSpaceRadius: 42,
                          sections: _buildSections(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 5,
                      child: _buildLeyenda(theme),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return List.generate(widget.categorias.length, (i) {
      final isTouched = i == _touchedIndex;
      final cat = widget.categorias[i];
      final color = _getColor(i, cat.color);
      final radius = isTouched ? 54.0 : 46.0;
      final pct = (cat.porcentaje * 100).toInt();

      return PieChartSectionData(
        color: color,
        value: cat.monto.cents.toDouble(),
        title: pct >= 5 ? '$pct%' : '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14.0 : 11.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(color: Colors.black45, blurRadius: 2),
          ],
        ),
      );
    });
  }

  Widget _buildLeyenda(ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.categorias.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, idx) {
        final cat = widget.categorias[idx];
        final color = _getColor(idx, cat.color);
        final isSelected = idx == _touchedIndex;

        return Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                cat.nombre,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              cat.monto.format(),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}