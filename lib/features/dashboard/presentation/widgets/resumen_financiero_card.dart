import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/money/money.dart';
import '../../domain/dashboard_resumen.dart';

/// Tarjetas de resumen financiero mensual y comparación con el mes anterior.
class ResumenFinancieroCard extends StatelessWidget {
  const ResumenFinancieroCard({
    super.key,
    required this.resumen,
  });

  final DashboardResumen resumen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // En tablets amplias se despliegan en fila de 2 bloques: Principal (Disponible) y Desglose (4 métricas)
        final esPantallaAncha = constraints.maxWidth >= 700;

        if (esPantallaAncha) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: _buildTarjetaDisponible(context, theme),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 6,
                  child: _buildGridMetricas(context, theme),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildTarjetaDisponible(context, theme),
            const SizedBox(height: 16),
            _buildGridMetricas(context, theme),
          ],
        );
      },
    );
  }

  /// Tarjeta destacada de Dinero Disponible del Mes con comparativa frente al mes anterior
  Widget _buildTarjetaDisponible(BuildContext context, ThemeData theme) {
    final disp = resumen.disponible;
    final esPositivo = disp.cents >= 0;
    final pctAhorro = (resumen.porcentajeDisponible * 100).toInt();

    // Comparativa mes anterior
    final varPct = resumen.variacionDisponiblePct;
    final deltaDisp = resumen.deltaDisponible;

    return Card(
      elevation: 2,
      color: esPositivo
          ? AppColors.primary
          : theme.colorScheme.errorContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'DISPONIBLE DEL MES',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: esPositivo
                          ? Colors.white.withValues(alpha: 0.85)
                          : theme.colorScheme.onErrorContainer,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$pctAhorro% del ingreso',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                disp.format(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: esPositivo ? Colors.white : theme.colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (resumen.mesAnterior != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      deltaDisp.cents >= 0
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: deltaDisp.cents >= 0
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFFCA5A5),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${deltaDisp.cents >= 0 ? '+' : ''}${deltaDisp.format()}'
                        '${varPct != null ? ' (${(varPct * 100).toStringAsFixed(1)}%)' : ''}'
                        ' vs mes anterior',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                'Primer mes registrado',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Grilla de las 4 métricas clave: Ingresos, Gastos Fijos, Gastos Variables, Aportes a Proyectos
  Widget _buildGridMetricas(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MiniMetricaCard(
                titulo: 'Ingresos Totales',
                monto: resumen.ingresos,
                icono: Icons.arrow_downward_rounded,
                colorIcono: AppColors.income,
                colorFondoIcono: AppColors.income.withValues(alpha: 0.12),
                variacionPct: resumen.variacionIngresosPct,
                esIngreso: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniMetricaCard(
                titulo: 'Gastos Fijos',
                monto: resumen.gastosFijos,
                icono: Icons.calendar_month_rounded,
                colorIcono: AppColors.expense,
                colorFondoIcono: AppColors.expense.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MiniMetricaCard(
                titulo: 'Gastos Variables',
                monto: resumen.gastosVariables,
                icono: Icons.shopping_bag_outlined,
                colorIcono: const Color(0xFFEAB308),
                colorFondoIcono: const Color(0xFFEAB308).withValues(alpha: 0.12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MiniMetricaCard(
                titulo: 'Aportes a Proyectos',
                monto: resumen.aportesProyectos,
                icono: Icons.home_repair_service_outlined,
                colorIcono: const Color(0xFF3B82F6),
                colorFondoIcono: const Color(0xFF3B82F6).withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniMetricaCard extends StatelessWidget {
  const _MiniMetricaCard({
    required this.titulo,
    required this.monto,
    required this.icono,
    required this.colorIcono,
    required this.colorFondoIcono,
    this.variacionPct,
    this.esIngreso = false,
  });

  final String titulo;
  final Money monto;
  final IconData icono;
  final Color colorIcono;
  final Color colorFondoIcono;
  final double? variacionPct;
  final bool esIngreso;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colorFondoIcono,
                  child: Icon(icono, color: colorIcono, size: 20),
                ),
                if (variacionPct != null) ...[
                  _buildVariacionBadge(theme),
                ],
              ],
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                titulo,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                monto.format(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariacionBadge(ThemeData theme) {
    final pct = variacionPct!;
    final esPositivo = pct >= 0;

    // Si es ingreso, subir es bueno (verde). Si es gasto, bajar es bueno (verde).
    final esFavorable = esIngreso ? esPositivo : !esPositivo;
    final colorTexto = esFavorable ? AppColors.income : AppColors.expense;
    final colorFondo = colorTexto.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${esPositivo ? '+' : ''}${(pct * 100).toStringAsFixed(1)}%',
        style: TextStyle(
          color: colorTexto,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}