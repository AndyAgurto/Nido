import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../core/utils/date_formatters.dart';

/// Tarjeta de próximos vencimientos de gastos fijos del mes en el Dashboard.
class VencimientosResumenCard extends StatelessWidget {
  const VencimientosResumenCard({
    super.key,
    required this.pagos,
  });

  final List<GastosFijosPago> pagos;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pendientes = pagos.where((p) => p.estado != 'pagado').toList();

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
                      const Icon(Icons.alarm_on_rounded, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Vencimientos del Mes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: pendientes.isEmpty
                        ? AppColors.income.withValues(alpha: 0.15)
                        : AppColors.expense.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pendientes.isEmpty
                        ? 'Todo al día'
                        : '${pendientes.length} pendientes',
                    style: TextStyle(
                      color: pendientes.isEmpty
                          ? AppColors.income
                          : AppColors.expense,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (pagos.isEmpty) ...[
              Container(
                height: 140,
                alignment: Alignment.center,
                child: Text(
                  'No hay pagos fijos programados para este mes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ] else ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pagos.take(5).length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, idx) {
                  final p = pagos[idx];
                  final esPagado = p.estado == 'pagado';
                  final hoy = DateTime.now();
                  final esVencido = !esPagado &&
                      p.fechaVencimiento.isBefore(
                          DateTime(hoy.year, hoy.month, hoy.day));

                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: esPagado
                          ? AppColors.income.withValues(alpha: 0.12)
                          : (esVencido
                              ? AppColors.expense.withValues(alpha: 0.12)
                              : Colors.orange.withValues(alpha: 0.12)),
                      child: Icon(
                        esPagado
                            ? Icons.check_circle_outline_rounded
                            : (esVencido
                                ? Icons.warning_amber_rounded
                                : Icons.schedule_rounded),
                        size: 18,
                        color: esPagado
                            ? AppColors.income
                            : (esVencido ? AppColors.expense : Colors.orange),
                      ),
                    ),
                    title: Text(
                      'Cuota #${p.id} - ${AppDateFormats.formatSimple(p.fechaVencimiento)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: esPagado ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      esPagado
                          ? 'PAGADO'
                          : (esVencido ? 'VENCIDO' : 'Por vencer'),
                      style: TextStyle(
                        fontSize: 11,
                        color: esPagado
                            ? AppColors.income
                            : (esVencido ? AppColors.expense : Colors.orange),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Text(
                      Money.fromCents(p.montoEsperadoCent).format(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: esPagado
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}