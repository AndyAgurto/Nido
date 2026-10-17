import '../../../shared/widgets/dynamic_text.dart';
import '../../../core/utils/date_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/master_detail_layout.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import 'movimientos_providers.dart';
import 'dialogs/nuevo_movimiento_dialog.dart';
import 'dialogs/anular_movimiento_dialog.dart';

/// Pantalla de Movimientos financieros para Tablet con Master-Detail y auditoría.
class MovimientosPage extends ConsumerWidget {
  const MovimientosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final movimientosAsync = ref.watch(movimientosFiltradosStreamProvider);
    final selectedId = ref.watch(movimientoSeleccionadoIdProvider);
    final filtros = ref.watch(movimientosFiltrosProvider);
    final cuentasMap = ref.watch(cuentasMapProvider).value ?? {};
    final categoriasMap = ref.watch(categoriasMapProvider).value ?? {};

    final isMobile = MediaQuery.of(context).size.width < 720;

    return Scaffold(
      appBar: isMobile
          ? null
          : AppBar(
              title: const Text('Movimientos'),
              actions: [
                FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const NuevoMovimientoDialog(),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Nuevo Movimiento'),
                ),
                const SizedBox(width: 16),
              ],
            ),
      floatingActionButton: isMobile
          ? FloatingActionButton.small(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const NuevoMovimientoDialog(),
                );
              },
              tooltip: 'Nuevo Movimiento',
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: Column(
        children: [
          _FiltrosBar(filtros: filtros),
          const Divider(height: 1),
          Expanded(
            child: movimientosAsync.when(
              data: (movimientos) {
                if (movimientos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay movimientos para este periodo o filtro',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonalIcon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const NuevoMovimientoDialog(),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Registrar Primer Movimiento'),
                        ),
                      ],
                    ),
                  );
                }

                final selectedMov = selectedId != null
                    ? movimientos
                            .where((m) => m.id == selectedId)
                            .firstOrNull ??
                        movimientos.first
                    : movimientos.first;

                return MasterDetailLayout(
                  master: Column(
                    children: [
                      _TotalesMesCard(movimientos: movimientos),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: MediaQuery.paddingOf(context).bottom + 88,
                          ),
                          itemCount: movimientos.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final m = movimientos[index];
                            final isSelected = m.id == selectedMov.id;
                            final categoria = m.categoriaId != null
                                ? categoriasMap[m.categoriaId]
                                : null;
                            final cuentaOrigen = cuentasMap[m.cuentaOrigenId];
                            final cuentaDestino = m.cuentaDestinoId != null
                                ? cuentasMap[m.cuentaDestinoId]
                                : null;

                            return _MovimientoListItem(
                              movimiento: m,
                              categoria: categoria,
                              cuentaOrigen: cuentaOrigen,
                              cuentaDestino: cuentaDestino,
                              isSelected: isSelected,
                              onTap: () {
                                ref
                                    .read(movimientoSeleccionadoIdProvider.notifier)
                                    .state = m.id;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  detail: _MovimientoDetallePanel(
                    movimiento: selectedMov,
                    categoria: selectedMov.categoriaId != null
                        ? categoriasMap[selectedMov.categoriaId]
                        : null,
                    cuentaOrigen: cuentasMap[selectedMov.cuentaOrigenId],
                    cuentaDestino: selectedMov.cuentaDestinoId != null
                        ? cuentasMap[selectedMov.cuentaDestinoId]
                        : null,
                  ),
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
}
/// Barra de filtros con selector de mes, buscador y filtros rápidos.
class _FiltrosBar extends ConsumerWidget {
  const _FiltrosBar({required this.filtros});

  final MovimientosFiltroState filtros;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(movimientosFiltrosProvider.notifier);
    final cuentas = ref.watch(cuentasActivasStreamProvider).value ?? [];
    final monthName = AppDateFormats.formatMesAnio(filtros.mes);

    return Container(
      color: theme.colorScheme.surfaceContainerLowest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 650;

          final monthSelector = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () => notifier.retrocederMes(),
                tooltip: 'Mes anterior',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                onPressed: () => notifier.avanzarMes(),
                tooltip: 'Mes siguiente',
              ),
            ],
          );

          final searchWidget = TextField(
            scrollPhysics: const BouncingScrollPhysics(),
            decoration: InputDecoration(
              hintText: 'Buscar descripción o notas...',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              suffixIcon: filtros.busqueda.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => notifier.setBusqueda(''),
                    )
                  : null,
            ),
            onChanged: (val) => notifier.setBusqueda(val),
          );

          final cuentasDropdown = Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                isExpanded: isCompact,
                value: filtros.cuentaId,
                isDense: true,
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Todas las cuentas', overflow: TextOverflow.ellipsis),
                  ),
                  ...cuentas.map(
                    (c) => DropdownMenuItem<int?>(
                      value: c.id,
                      child: Text(c.nombre, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (val) => notifier.setCuenta(val),
              ),
            ),
          );

          final switchAnulados = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Anulados',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Switch(
                value: filtros.incluirAnulados,
                onChanged: (_) => notifier.toggleIncluirAnulados(),
              ),
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isCompact) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    monthSelector,
                    switchAnulados,
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(flex: 3, child: searchWidget),
                    const SizedBox(width: 8),
                    Expanded(flex: 2, child: cuentasDropdown),
                  ],
                ),
              ] else ...[
                Row(
                  children: [
                    monthSelector,
                    const SizedBox(width: 16),
                    Expanded(child: searchWidget),
                    const SizedBox(width: 16),
                    cuentasDropdown,
                    const SizedBox(width: 16),
                    switchAnulados,
                  ],
                ),
              ],
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Todos'),
                      selected: filtros.tipo == null,
                      onSelected: (_) => notifier.setTipo(null),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Ingresos'),
                      avatar: const Icon(Icons.arrow_downward_rounded, size: 16, color: AppColors.income),
                      selected: filtros.tipo == 'ingreso',
                      onSelected: (_) => notifier.setTipo('ingreso'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Gastos'),
                      avatar: const Icon(Icons.arrow_upward_rounded, size: 16, color: AppColors.expense),
                      selected: filtros.tipo == 'gasto',
                      onSelected: (_) => notifier.setTipo('gasto'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Transferencias'),
                      avatar: const Icon(Icons.swap_horiz_rounded, size: 16, color: AppColors.transfer),
                      selected: filtros.tipo == 'transferencia',
                      onSelected: (_) => notifier.setTipo('transferencia'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TotalesMesCard extends StatelessWidget {
  const _TotalesMesCard({required this.movimientos});

  final List<Movimiento> movimientos;

  @override
  Widget build(BuildContext context) {
    int totalIngresos = 0;
    int totalGastos = 0;

    for (final m in movimientos) {
      if (m.anulado) continue;
      if (m.tipo == 'ingreso') totalIngresos += m.montoCent;
      if (m.tipo == 'gasto') totalGastos += m.montoCent;
    }

    final neto = totalIngresos - totalGastos;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: _TotalItem(
              titulo: 'Ingresos',
              monto: Money.fromCents(totalIngresos),
              color: AppColors.income,
              icon: Icons.arrow_downward_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TotalItem(
              titulo: 'Gastos',
              monto: Money.fromCents(totalGastos),
              color: AppColors.expense,
              icon: Icons.arrow_upward_rounded,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TotalItem(
              titulo: 'Balance Neto',
              monto: Money.fromCents(neto),
              color: neto >= 0 ? AppColors.primary : AppColors.expense,
              icon: Icons.account_balance_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalItem extends StatelessWidget {
  const _TotalItem({
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    monto.format(),
                    style: theme.textTheme.labelLarge?.copyWith(
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
    );
  }
}
/// Elemento individual en la lista maestra de movimientos.
class _MovimientoListItem extends StatelessWidget {
  const _MovimientoListItem({
    required this.movimiento,
    this.categoria,
    this.cuentaOrigen,
    this.cuentaDestino,
    required this.isSelected,
    required this.onTap,
  });

  final Movimiento movimiento;
  final Categoria? categoria;
  final Cuenta? cuentaOrigen;
  final Cuenta? cuentaDestino;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIngreso = movimiento.tipo == 'ingreso';
    final isTransferencia = movimiento.tipo == 'transferencia';
    final monto = Money.fromCents(movimiento.montoCent);

    final color = isTransferencia
        ? AppColors.transfer
        : (isIngreso ? AppColors.income : AppColors.expense);

    final icon = isTransferencia
        ? Icons.swap_horiz_rounded
        : (isIngreso ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded);

    return Card(
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : (movimiento.anulado
                  ? AppColors.expense.withValues(alpha: 0.3)
                  : theme.colorScheme.outlineVariant),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Row(
          children: [
            Expanded(
              child: DynamicScrollText(
                movimiento.descripcion,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: movimiento.anulado
                      ? TextDecoration.lineThrough
                      : null,
                  color: movimiento.anulado
                      ? theme.colorScheme.outline
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (movimiento.anulado)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.terracottaContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ANULADO',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onTerracottaContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              AppDateFormats.formatSimple(movimiento.fecha),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            if (categoria != null) ...[
              const Text(' • '),
              Text(
                categoria!.nombre,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (cuentaOrigen != null) ...[
              const Text(' • '),
              Text(
                isTransferencia
                    ? '${cuentaOrigen!.nombre} → ${cuentaDestino?.nombre ?? ""}'
                    : cuentaOrigen!.nombre,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
        trailing: Text(
          '${isIngreso ? "+" : (isTransferencia ? "" : "-")}${monto.format()}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: movimiento.anulado ? theme.colorScheme.outline : color,
            decoration: movimiento.anulado ? TextDecoration.lineThrough : null,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

/// Panel de detalle con trazabilidad, estado y acciones de anulación/restauración.
class _MovimientoDetallePanel extends ConsumerWidget {
  const _MovimientoDetallePanel({
    required this.movimiento,
    this.categoria,
    this.cuentaOrigen,
    this.cuentaDestino,
  });

  final Movimiento movimiento;
  final Categoria? categoria;
  final Cuenta? cuentaOrigen;
  final Cuenta? cuentaDestino;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final monto = Money.fromCents(movimiento.montoCent);
    final isIngreso = movimiento.tipo == 'ingreso';
    final isTransferencia = movimiento.tipo == 'transferencia';

    final color = isTransferencia
        ? AppColors.transfer
        : (isIngreso ? AppColors.income : AppColors.expense);

    return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            movimiento.tipo.toUpperCase(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                        if (movimiento.anulado)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.terracottaContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.cancel, size: 16, color: AppColors.onTerracottaContainer),
                                const SizedBox(width: 6),
                                Text(
                                  'ANULADO',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onTerracottaContainer,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'ACTIVO',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      movimiento.descripcion,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: movimiento.anulado
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${isIngreso ? "+" : (isTransferencia ? "" : "-")}${monto.format()}',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: movimiento.anulado ? theme.colorScheme.outline : color,
                        decoration: movimiento.anulado
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (movimiento.anulado) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.terracottaContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.expense.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.onTerracottaContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Detalles de la Anulación',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.onTerracottaContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Motivo: ${movimiento.motivoAnulacion ?? "Sin motivo especificado"}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onTerracottaContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (movimiento.anuladoEn != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Fecha: ${AppDateFormats.formatSimpleSegundos(movimiento.anuladoEn!)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onTerracottaContainer.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'Fecha y Hora',
                      valor: AppDateFormats.formatFechaHoraCompleta(movimiento.fecha),
                    ),
                    const Divider(height: 24),
                    _InfoRow(
                      icon: Icons.account_balance_wallet_rounded,
                      label: isTransferencia ? 'Cuenta Origen' : 'Cuenta',
                      valor: cuentaOrigen?.nombre ?? 'Cuenta #${movimiento.cuentaOrigenId}',
                    ),
                    if (isTransferencia) ...[
                      const Divider(height: 24),
                      _InfoRow(
                        icon: Icons.account_balance_rounded,
                        label: 'Cuenta Destino',
                        valor: cuentaDestino?.nombre ?? 'Cuenta #${movimiento.cuentaDestinoId}',
                      ),
                    ],
                    if (categoria != null) ...[
                      const Divider(height: 24),
                      _InfoRow(
                        icon: Icons.category_rounded,
                        label: 'Categoría',
                        valor: categoria!.nombre,
                      ),
                    ],
                    if (movimiento.notas != null && movimiento.notas!.isNotEmpty) ...[
                      const Divider(height: 24),
                      _InfoRow(
                        icon: Icons.notes_rounded,
                        label: 'Notas Adicionales',
                        valor: movimiento.notas!,
                      ),
                    ],
                    const Divider(height: 24),
                    _InfoRow(
                      icon: Icons.fingerprint_rounded,
                      label: 'ID de Auditoría',
                      valor: '#${movimiento.id} (Registrado: ${AppDateFormats.formatSimpleHora(movimiento.creadoEn)})',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (!movimiento.anulado)
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.terracottaContainer,
                  foregroundColor: AppColors.onTerracottaContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        AnularMovimientoDialog(movimiento: movimiento),
                  );
                },
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Anular Movimiento (Auditable)'),
              )
            else
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _restaurarMovimiento(context, ref),
                icon: const Icon(Icons.restore_rounded),
                label: const Text('Restaurar Movimiento'),
              ),
          ],
        ),
      );
  }

  Future<void> _restaurarMovimiento(BuildContext context, WidgetRef ref) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Restaurar Movimiento?'),
        content: Text(
          'Esta acción revertirá la anulación de "${movimiento.descripcion}" y reintegrará su valor en el saldo de la cuenta de forma inmediata.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final dao = ref.read(movimientosDaoProvider);
    final writer = ref.read(auditedWriterProvider);

    await dao.restaurarMovimiento(movimiento.id, writer: writer);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Movimiento restaurado correctamente.'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.valor,
  });

  final IconData icon;
  final String label;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}