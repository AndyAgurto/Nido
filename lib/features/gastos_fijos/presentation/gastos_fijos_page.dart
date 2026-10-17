import '../../../core/utils/date_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';

import '../../../app/theme/app_colors.dart';
import 'gastos_fijos_providers.dart';
import 'dialogs/nueva_plantilla_dialog.dart';
import 'dialogs/marcar_pagado_dialog.dart';

/// Pantalla de Gestión de Gastos e Ingresos Fijos, control mensual y vencimientos.
class GastosFijosPage extends ConsumerStatefulWidget {
  const GastosFijosPage({super.key});

  @override
  ConsumerState<GastosFijosPage> createState() => _GastosFijosPageState();
}

class _GastosFijosPageState extends ConsumerState<GastosFijosPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final periodo = ref.watch(periodoGastosFijosProvider);

    final isMobile = MediaQuery.of(context).size.width < 720;

    return Scaffold(
      appBar: isMobile
          ? null
          : AppBar(
              title: const Text('Gastos Fijos'),
              actions: [
                FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const NuevaPlantillaDialog(),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Nueva Plantilla'),
                ),
                const SizedBox(width: 16),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(icon: Icon(Icons.calendar_month_rounded), text: 'Vencimientos del Mes'),
                  Tab(icon: Icon(Icons.format_list_bulleted_rounded), text: 'Plantillas Fijas'),
                ],
              ),
            ),
      floatingActionButton: isMobile
          ? FloatingActionButton.small(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const NuevaPlantillaDialog(),
                );
              },
              tooltip: 'Nueva Plantilla',
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: Column(
        children: [
          if (isMobile)
            Container(
              color: theme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(icon: Icon(Icons.calendar_month_rounded), text: 'Vencimientos del Mes'),
                  Tab(icon: Icon(Icons.format_list_bulleted_rounded), text: 'Plantillas Fijas'),
                ],
              ),
            ),
          Expanded(
            child: TabBarView(
        controller: _tabController,
        children: [
          _ControlMensualTab(
            periodo: periodo,
            isGenerating: _isGenerating,
            onGenerar: () => _generarInstancias(periodo),
          ),
          const _PlantillasTab(),
        ],
      ),
    ),
    ],
    ),
    );
  }

  Future<void> _generarInstancias(String periodo) async {
    setState(() => _isGenerating = true);
    try {
      final dao = ref.read(gastosFijosDaoProvider);
      final writer = ref.read(auditedWriterProvider);

      final generados = await dao.generarInstanciasMensuales(periodo, writer);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              generados > 0
                  ? '¡Listo! Se generaron $generados pagos/cobros para el periodo $periodo.'
                  : 'Todas las instancias para $periodo ya estaban generadas.',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar instancias: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}
/// Tab 1: Control mensual con vencimientos y botón de pago.
class _ControlMensualTab extends ConsumerWidget {
  const _ControlMensualTab({
    required this.periodo,
    required this.isGenerating,
    required this.onGenerar,
  });

  final String periodo;
  final bool isGenerating;
  final VoidCallback onGenerar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pagosAsync = ref.watch(pagosPeriodoStreamProvider);
    final plantillasMap = ref.watch(plantillasGastosMapProvider).value ?? {};

    final parts = periodo.split('-');
    final anio = int.parse(parts[0]);
    final mes = int.parse(parts[1]);
    final fechaPeriodo = DateTime(anio, mes);
    final monthName =
        AppDateFormats.formatMesAnio(fechaPeriodo);

    return Column(
      children: [
        // Selector de mes y acción de generar adaptativo
        Container(
          color: theme.colorScheme.surfaceContainerLowest,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 650;

              final monthNav = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: () {
                      final anterior = DateTime(anio, mes - 1);
                      ref.read(periodoGastosFijosProvider.notifier).state =
                          DateFormat('yyyy-MM').format(anterior);
                    },
                    tooltip: 'Mes anterior',
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      monthName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: () {
                      final siguiente = DateTime(anio, mes + 1);
                      ref.read(periodoGastosFijosProvider.notifier).state =
                          DateFormat('yyyy-MM').format(siguiente);
                    },
                    tooltip: 'Mes siguiente',
                  ),
                ],
              );

              final generateBtn = FilledButton.tonalIcon(
                onPressed: isGenerating ? null : onGenerar,
                icon: isGenerating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_mode_rounded, size: 18),
                label: const Text('Generar Cuotas del Mes'),
              );

              if (isMobile) {
                return Column(
                  children: [
                    monthNav,
                    const SizedBox(height: 8),
                    SizedBox(width: double.infinity, child: generateBtn),
                  ],
                );
              }

              return Row(
                children: [
                  monthNav,
                  const Spacer(),
                  generateBtn,
                ],
              );
            },
          ),
        ),
        const Divider(height: 1),

        // Lista de pagos
        Expanded(
          child: pagosAsync.when(
            data: (pagos) {
              if (pagos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.event_busy_rounded,
                        size: 64,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay pagos generados para $monthName',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Genera las instancias automáticamente a partir de tus plantillas activas.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: isGenerating ? null : onGenerar,
                        icon: const Icon(Icons.auto_mode_rounded),
                        label: const Text('Generar Instancias Ahora'),
                      ),
                    ],
                  ),
                );
              }

              // Métricas resumen
              int totalEsperado = 0;
              int totalPagado = 0;
              int totalPendiente = 0;
              int totalVencido = 0;
              final hoy = DateTime.now();

              for (final p in pagos) {
                totalEsperado += p.montoEsperadoCent;
                if (p.estado == 'pagado') {
                  totalPagado += p.montoEsperadoCent;
                } else {
                  totalPendiente += p.montoEsperadoCent;
                  if (p.fechaVencimiento.isBefore(DateTime(hoy.year, hoy.month, hoy.day))) {
                    totalVencido += p.montoEsperadoCent;
                  }
                }
              }

              return ListView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.paddingOf(context).bottom + 88,
                ),
                children: [
                  // Tarjetas de métricas responsivas (Cuadrícula 2x2 en móvil para máxima legibilidad)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 650;
                      if (isCompact) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _MetricaFijosCard(
                                    titulo: 'Total Esperado',
                                    monto: Money.fromCents(totalEsperado),
                                    color: AppColors.primary,
                                    icon: Icons.calendar_month_rounded,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _MetricaFijosCard(
                                    titulo: 'Pagado',
                                    monto: Money.fromCents(totalPagado),
                                    color: AppColors.income,
                                    icon: Icons.check_circle_outline_rounded,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _MetricaFijosCard(
                                    titulo: 'Pendiente',
                                    monto: Money.fromCents(totalPendiente),
                                    color: AppColors.warning,
                                    icon: Icons.hourglass_top_rounded,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _MetricaFijosCard(
                                    titulo: 'Vencido',
                                    monto: Money.fromCents(totalVencido),
                                    color: AppColors.expense,
                                    icon: Icons.warning_amber_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: _MetricaFijosCard(
                              titulo: 'Total Esperado',
                              monto: Money.fromCents(totalEsperado),
                              color: AppColors.primary,
                              icon: Icons.calendar_month_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricaFijosCard(
                              titulo: 'Pagado',
                              monto: Money.fromCents(totalPagado),
                              color: AppColors.income,
                              icon: Icons.check_circle_outline_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricaFijosCard(
                              titulo: 'Pendiente',
                              monto: Money.fromCents(totalPendiente),
                              color: AppColors.warning,
                              icon: Icons.hourglass_top_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MetricaFijosCard(
                              titulo: 'Vencido',
                              monto: Money.fromCents(totalVencido),
                              color: AppColors.expense,
                              icon: Icons.warning_amber_rounded,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Lista de pagos
                  Text(
                    'Vencimientos y Pagos del Mes (${pagos.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...pagos.map((pago) {
                    final plantilla = plantillasMap[pago.gastoFijoId];
                    return _PagoItemCard(
                      pago: pago,
                      plantilla: plantilla,
                    );
                  }),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
class _MetricaFijosCard extends StatelessWidget {
  const _MetricaFijosCard({
    required this.titulo,
    required this.monto,
    required this.color,
    required this.icon,
  });

  final String titulo;
  final Money monto;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      monto.format(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PagoItemCard extends StatelessWidget {
  const _PagoItemCard({
    required this.pago,
    this.plantilla,
  });

  final GastosFijosPago pago;
  final GastosFijo? plantilla;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monto = Money.fromCents(pago.montoEsperadoCent);
    final isPagado = pago.estado == 'pagado';

    // Cálculo de días restantes y vencimiento
    final hoy = DateTime.now();
    final hoySinHora = DateTime(hoy.year, hoy.month, hoy.day);
    final vencSinHora = DateTime(
      pago.fechaVencimiento.year,
      pago.fechaVencimiento.month,
      pago.fechaVencimiento.day,
    );
    final diasDiferencia = vencSinHora.difference(hoySinHora).inDays;

    Widget badgeVencimiento;
    if (isPagado) {
      badgeVencimiento = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.income.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, size: 14, color: AppColors.income),
            SizedBox(width: 4),
            Text(
              'PAGADO',
              style: TextStyle(
                color: AppColors.income,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    } else if (diasDiferencia < 0) {
      badgeVencimiento = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.terracottaContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.onTerracottaContainer),
            const SizedBox(width: 4),
            Text(
              'VENCIDO (hace ${-diasDiferencia} d)',
              style: const TextStyle(
                color: AppColors.onTerracottaContainer,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    } else if (diasDiferencia == 0) {
      badgeVencimiento = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.alarm_rounded, size: 14, color: Colors.amber.shade900),
            const SizedBox(width: 4),
            Text(
              'VENCE HOY',
              style: TextStyle(
                color: Colors.amber.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    } else if (diasDiferencia <= 3) {
      badgeVencimiento = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'En $diasDiferencia días',
          style: TextStyle(
            color: Colors.amber.shade900,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      );
    } else {
      badgeVencimiento = Text(
        'Vence ${DateFormat('dd/MM').format(pago.fechaVencimiento)}',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila 1: Ícono + Nombre (Ancho completo, nunca vertical) + Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isPagado
                      ? AppColors.income.withValues(alpha: 0.12)
                      : (diasDiferencia < 0
                          ? AppColors.expense.withValues(alpha: 0.12)
                          : theme.colorScheme.surfaceContainerHighest),
                  child: Icon(
                    isPagado
                        ? Icons.check_circle_outline_rounded
                        : (diasDiferencia < 0
                            ? Icons.warning_amber_rounded
                            : Icons.event_repeat_rounded),
                    size: 20,
                    color: isPagado
                        ? AppColors.income
                        : (diasDiferencia < 0 ? AppColors.expense : AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    plantilla?.nombre ?? 'Gasto Fijo #${pago.gastoFijoId}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                badgeVencimiento,
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            // Fila 2: Fecha a la izquierda, Monto y Acción a la derecha
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Vence: ${DateFormat('dd/MM/yyyy').format(pago.fechaVencimiento)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  monto.format(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isPagado ? AppColors.income : AppColors.expense,
                  ),
                ),
                if (!isPagado && plantilla != null) ...[
                  const SizedBox(width: 12),
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => MarcarPagadoDialog(
                          pago: pago,
                          plantilla: plantilla!,
                        ),
                      );
                    },
                    child: const Text('Marcar Pagado'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab 2: Lista de plantillas fijas maestras.
class _PlantillasTab extends ConsumerWidget {
  const _PlantillasTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gastosFijosAsync = ref.watch(plantillasGastosFijosStreamProvider);
    final ingresosFijosAsync = ref.watch(plantillasIngresosFijosStreamProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.paddingOf(context).bottom + 88,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plantillas de Gastos Fijos',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
IconButton.filledTonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        const NuevaPlantillaDialog(esGasto: true),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Nuevo Gasto Fijo',
              ),
            ],
          ),
          const SizedBox(height: 12),
          gastosFijosAsync.when(
            data: (gastos) {
              if (gastos.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('No hay plantillas de gastos fijos configuradas.'),
                    ),
                  ),
                );
              }
              return Column(
                children: gastos.map((g) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.primaryContainer,
                        child: Icon(Icons.event_repeat_rounded, color: AppColors.primary),
                      ),
                      title: Text(g.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Día de vencimiento: ${g.diaVencimiento} de cada mes'),
                      trailing: Text(
                        Money.fromCents(g.montoEstimadoCent).format(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.expense),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plantillas de Ingresos Fijos',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
IconButton.filledTonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        const NuevaPlantillaDialog(esGasto: false),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                tooltip: 'Nuevo Ingreso Fijo',
              ),
            ],
          ),
          const SizedBox(height: 12),
          ingresosFijosAsync.when(
            data: (ingresos) {
              if (ingresos.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('No hay plantillas de ingresos fijos configuradas.'),
                    ),
                  ),
                );
              }
              return Column(
                children: ingresos.map((ing) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.income.withValues(alpha: 0.15),
                        child: const Icon(Icons.monetization_on_outlined, color: AppColors.income),
                      ),
                      title: Text(ing.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Día de cobro: ${ing.diaCobro} de cada mes'),
                      trailing: Text(
                        Money.fromCents(ing.montoEstimadoCent).format(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.income),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}