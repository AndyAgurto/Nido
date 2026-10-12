import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/money/money.dart';
import '../dashboard_providers.dart';

/// Tarjeta de avance presupuestario y alertas (80% y 100%) en el Dashboard.
class PresupuestosResumenCard extends StatelessWidget {
  const PresupuestosResumenCard({
    super.key,
    required this.presupuestos,
  });

  final List<DashboardPresupuestoItem> presupuestos;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Presupuesto por Categoría',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${presupuestos.length} asignadas',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (presupuestos.isEmpty) ...[
              Container(
                height: 140,
                alignment: Alignment.center,
                child: Text(
                  'Sin presupuestos asignados para este mes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ] else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: presupuestos.take(5).length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, idx) {
                  final p = presupuestos[idx];
                  final pct = p.porcentajeEjecutado;
                  final pctInt = (pct * 100).toInt();

                  Color colorBarra = AppColors.primary;
                  if (p.esAlerta100) {
                    colorBarra = AppColors.expense;
                  } else if (p.esAlerta80) {
                    colorBarra = const Color(0xFFEAB308);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                p.categoriaNombre,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (p.esAlerta100) ...[
                                const SizedBox(width: 6),
                                _buildChipAlerta(
                                  label: 'SOBREGIRADO',
                                  color: AppColors.expense,
                                ),
                              ] else if (p.esAlerta80) ...[
                                const SizedBox(width: 6),
                                _buildChipAlerta(
                                  label: 'ALERTA 80%',
                                  color: const Color(0xFFEAB308),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '$pctInt%',
                            style: TextStyle(
                              color: colorBarra,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: pct > 1.0 ? 1.0 : pct,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(colorBarra),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gastado: ${Money.fromCents(p.gastadoCent).format()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'Límite: ${Money.fromCents(p.presupuestoCent).format()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChipAlerta({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}