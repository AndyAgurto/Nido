import '../../../core/utils/date_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/money/money.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import 'presupuesto_providers.dart';
import 'dialogs/asignar_presupuesto_dialog.dart';

/// Pantalla de Presupuesto Mensual por Categoría con barras de progreso y alertas 80%/100%.
class PresupuestoPage extends ConsumerWidget {
  const PresupuestoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final periodo = ref.watch(periodoPresupuestoProvider);
    final itemsAsync = ref.watch(presupuestosItemsProvider);

    final parts = periodo.split('-');
    final anio = int.parse(parts[0]);
    final mes = int.parse(parts[1]);
    final fechaPeriodo = DateTime(anio, mes);
    final monthName =
        AppDateFormats.formatMesAnio(fechaPeriodo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Presupuesto Mensual'),
        actions: [
          FilledButton.tonalIcon(
            onPressed: () => _copiarMesAnterior(context, ref, periodo),
            icon: const Icon(Icons.content_copy_rounded),
            label: const Text('Copiar del Mes Anterior'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Selector de Mes Superior
          Container(
            color: theme.colorScheme.surfaceContainerLowest,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: () {
                    final anterior = DateTime(anio, mes - 1);
                    ref.read(periodoPresupuestoProvider.notifier).state =
                        DateFormat('yyyy-MM').format(anterior);
                  },
                  tooltip: 'Mes anterior',
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    monthName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: () {
                    final siguiente = DateTime(anio, mes + 1);
                    ref.read(periodoPresupuestoProvider.notifier).state =
                        DateFormat('yyyy-MM').format(siguiente);
                  },
                  tooltip: 'Mes siguiente',
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Contenido principal
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                // Cálculo de totales
                int totalPresupuestadoCent = 0;
                int totalGastadoCent = 0;

                for (final it in items) {
                  totalPresupuestadoCent += it.presupuestado.cents;
                  totalGastadoCent += it.gastado.cents;
                }

                final totalPresupuestado = Money.fromCents(totalPresupuestadoCent);
                final totalGastado = Money.fromCents(totalGastadoCent);
                final totalRestante = totalPresupuestado - totalGastado;
                final ratioGlobal = totalPresupuestadoCent > 0
                    ? totalGastadoCent / totalPresupuestadoCent
                    : 0.0;

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Banner de Resumen Global
                    _ResumenPresupuestoCard(
                      presupuestado: totalPresupuestado,
                      gastado: totalGastado,
                      restante: totalRestante,
                      ratioGlobal: ratioGlobal,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Categorías de Gasto (${items.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Lista de tarjetas por categoría
                    ...items.map(
                      (item) => _CategoriaPresupuestoCard(
                        item: item,
                        periodo: periodo,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copiarMesAnterior(
    BuildContext context,
    WidgetRef ref,
    String periodoActual,
  ) async {
    final parts = periodoActual.split('-');
    final anio = int.parse(parts[0]);
    final mes = int.parse(parts[1]);
    final periodoAnterior =
        DateFormat('yyyy-MM').format(DateTime(anio, mes - 1));

    final dao = ref.read(presupuestosDaoProvider);
    final writer = ref.read(auditedWriterProvider);

    final copiados = await dao.copiarPresupuestosDelMesAnterior(
      periodoOrigen: periodoAnterior,
      periodoDestino: periodoActual,
      writer: writer,
    );

    ref.invalidate(presupuestosItemsProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            copiados > 0
                ? '¡Éxito! Se copiaron $copiados presupuestos desde $periodoAnterior.'
                : 'No había nuevos presupuestos en $periodoAnterior para copiar.',
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }
}
/// Banner de Resumen Global de Ejecución Presupuestaria
class _ResumenPresupuestoCard extends StatelessWidget {
  const _ResumenPresupuestoCard({
    required this.presupuestado,
    required this.gastado,
    required this.restante,
    required this.ratioGlobal,
  });

  final Money presupuestado;
  final Money gastado;
  final Money restante;
  final double ratioGlobal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final porcentajeEntero = (ratioGlobal * 100).toInt();

    Color barraColor = AppColors.primary;
    if (ratioGlobal >= 1.0) {
      barraColor = AppColors.expense;
    } else if (ratioGlobal >= 0.8) {
      barraColor = AppColors.warning;
    }

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ejecución Global del Presupuesto',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: barraColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$porcentajeEntero% ejecutado',
                    style: TextStyle(
                      color: barraColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratioGlobal.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(barraColor),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MiniTotalItem(
                    label: 'Presupuestado',
                    valor: presupuestado.format(),
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: _MiniTotalItem(
                    label: 'Gastado Real',
                    valor: gastado.format(),
                    color: AppColors.expense,
                  ),
                ),
                Expanded(
                  child: _MiniTotalItem(
                    label: restante.isNegative ? 'Sobrepasado' : 'Disponible',
                    valor: restante.format(),
                    color: restante.isNegative
                        ? AppColors.expense
                        : AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTotalItem extends StatelessWidget {
  const _MiniTotalItem({
    required this.label,
    required this.valor,
    required this.color,
  });

  final String label;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Tarjeta individual por categoría con barra de progreso y badges 80%/100%.
class _CategoriaPresupuestoCard extends StatelessWidget {
  const _CategoriaPresupuestoCard({
    required this.item,
    required this.periodo,
  });

  final CategoriaPresupuestoItem item;
  final String periodo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final porcentajeInt = (item.porcentaje * 100).toInt();

    Color colorBarra = AppColors.primary;
    Widget? badgeAlerta;

    if (item.alerta100) {
      colorBarra = AppColors.expense;
      badgeAlerta = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.terracottaContainer,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          '¡EXCEDIDO 100%!',
          style: TextStyle(
            color: AppColors.onTerracottaContainer,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    } else if (item.alerta80) {
      colorBarra = AppColors.warning;
      badgeAlerta = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'ALERTA 80%',
          style: TextStyle(
            color: Colors.amber.shade900,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: item.alerta100
              ? AppColors.expense.withValues(alpha: 0.4)
              : (item.alerta80
                  ? Colors.amber.shade400
                  : theme.colorScheme.outlineVariant),
          width: item.alerta100 || item.alerta80 ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorBarra.withValues(alpha: 0.12),
                  child: Icon(Icons.category_rounded, color: colorBarra, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.categoria.nombre,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (badgeAlerta != null) ...[
                            const SizedBox(width: 8),
                            badgeAlerta,
                          ],
                        ],
                      ),
                      Text(
                        item.tienePresupuesto
                            ? 'Límite: ${item.presupuestado.format()}'
                            : 'Sin presupuesto asignado',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AsignarPresupuestoDialog(
                        categoria: item.categoria,
                        periodo: periodo,
                        montoActual: item.presupuestado,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: Text(
                    item.tienePresupuesto ? 'Modificar' : 'Asignar',
                  ),
                ),
              ],
            ),
            if (item.tienePresupuesto) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: item.porcentaje.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(colorBarra),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gastado: ${item.gastado.format()} ($porcentajeInt%)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: item.alerta100 ? AppColors.expense : null,
                    ),
                  ),
                  Text(
                    item.restante.isNegative
                        ? 'Excedido por: ${(item.gastado - item.presupuestado).format()}'
                        : 'Disponible: ${item.restante.format()}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: item.restante.isNegative
                          ? AppColors.expense
                          : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}