import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/providers/database_providers.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/widgets/master_detail_layout.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import 'cuentas_providers.dart';

/// Pantalla de gestión de Cuentas optimizada para Tablet con Master-Detail.
class CuentasPage extends ConsumerWidget {
  const CuentasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cuentasAsync = ref.watch(cuentasActivasStreamProvider);
    final selectedId = ref.watch(cuentaSeleccionadaIdProvider);
    final dineroTotalAsync = ref.watch(dineroTotalActualProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuentas y Bolsillos'),
        actions: [
          dineroTotalAsync.when(
            data: (total) => Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.savings_outlined, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Dinero Actual: ${total.format()}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          FilledButton.icon(
            onPressed: () => _mostrarDialogoTransferir(context, ref),
            icon: const Icon(Icons.swap_horiz_rounded),
            label: const Text('Transferir'),
          ),
          const SizedBox(width: 8),
          FilledButton.tonalIcon(
            onPressed: () => _mostrarDialogoCrearEditar(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Nueva Cuenta'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: cuentasAsync.when(
        data: (cuentas) {
          if (cuentas.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet_outlined, size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No hay cuentas registradas', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _mostrarDialogoCrearEditar(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Primera Cuenta'),
                  ),
                ],
              ),
            );
          }

          final cuentaActiva = selectedId != null
              ? cuentas.where((c) => c.id == selectedId).firstOrNull ?? cuentas.first
              : cuentas.first;

          return MasterDetailLayout(
            master: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cuentas.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cuenta = cuentas[index];
                final isSelected = cuenta.id == cuentaActiva.id;

                return _CuentaListItem(
                  cuenta: cuenta,
                  isSelected: isSelected,
                  onTap: () => ref.read(cuentaSeleccionadaIdProvider.notifier).state = cuenta.id,
                );
              },
            ),
            detail: _CuentaDetallePanel(cuenta: cuentaActiva),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error al cargar cuentas: $err')),
      ),
    );
  }

  void _mostrarDialogoCrearEditar(BuildContext context, WidgetRef ref, [Cuenta? cuenta]) {
    showDialog(
      context: context,
      builder: (context) => _DialogoCrearEditarCuenta(cuenta: cuenta),
    );
  }

  void _mostrarDialogoTransferir(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const _DialogoTransferirFondos(),
    );
  }
}

class _CuentaListItem extends ConsumerWidget {
  const _CuentaListItem({
    required this.cuenta,
    required this.isSelected,
    required this.onTap,
  });

  final Cuenta cuenta;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saldoAsync = ref.watch(saldoCuentaProvider(cuenta.id));

    return Card(
      elevation: isSelected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryContainer,
          child: Icon(_getIconData(cuenta.icono), color: AppColors.primary),
        ),
        title: Text(
          cuenta.nombre,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          cuenta.tipo.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        trailing: saldoAsync.when(
          data: (saldo) => Text(
            saldo.format(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: saldo.isNegative ? AppColors.expense : AppColors.primary,
            ),
          ),
          loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          error: (_, _) => const Text('---'),
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getIconData(String icono) {
    switch (icono) {
      case 'savings':
        return Icons.savings_rounded;
      case 'credit_card':
        return Icons.credit_card_rounded;
      case 'payments':
        return Icons.payments_rounded;
      default:
        return Icons.account_balance_wallet_rounded;
    }
  }
}

class _CuentaDetallePanel extends ConsumerWidget {
  const _CuentaDetallePanel({required this.cuenta});

  final Cuenta cuenta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final saldoAsync = ref.watch(saldoCuentaProvider(cuenta.id));
    final movsDao = ref.watch(movimientosDaoProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la cuenta
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primaryContainer,
                    child: Icon(Icons.account_balance_wallet_rounded, size: 36, color: AppColors.primary),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cuenta.nombre, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('Tipo: ${cuenta.tipo.toUpperCase()} • Saldo Inicial: ${Money.fromCents(cuenta.saldoInicialCent).format()}'),
                      ],
                    ),
                  ),
                  saldoAsync.when(
                    data: (saldo) => Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('SALDO CALCULADO', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline)),
                        Text(
                          saldo.format(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: saldo.isNegative ? AppColors.expense : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                    error: (_, _) => const Text('Error'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('Movimientos Recientes', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => _DialogoCrearEditarCuenta(cuenta: cuenta),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar Cuenta'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Lista de movimientos filtrada para esta cuenta
          StreamBuilder<List<Movimiento>>(
            stream: movsDao.watchMovimientos(cuentaId: cuenta.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()));
              }
              final movs = snapshot.data ?? [];
              if (movs.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('Sin movimientos registrados en esta cuenta.')),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movs.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final m = movs[index];
                  final isIngreso = m.tipo == 'ingreso' || (m.tipo == 'transferencia' && m.cuentaDestinoId == cuenta.id);
                  final monto = Money.fromCents(m.montoCent);

                  return ListTile(
                    leading: Icon(
                      m.tipo == 'transferencia'
                          ? Icons.swap_horiz_rounded
                          : (isIngreso ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded),
                      color: m.tipo == 'transferencia'
                          ? AppColors.transfer
                          : (isIngreso ? AppColors.income : AppColors.expense),
                    ),
                    title: Text(m.descripcion, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${m.fecha.day.toString().padLeft(2, '0')}/${m.fecha.month.toString().padLeft(2, '0')}/${m.fecha.year}'),
                    trailing: Text(
                      '${isIngreso ? '+' : '-'}${monto.format()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isIngreso ? AppColors.income : AppColors.expense,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// Diálogo para crear o editar cuenta
class _DialogoCrearEditarCuenta extends ConsumerStatefulWidget {
  const _DialogoCrearEditarCuenta({this.cuenta});

  final Cuenta? cuenta;

  @override
  ConsumerState<_DialogoCrearEditarCuenta> createState() => _DialogoCrearEditarCuentaState();
}

class _DialogoCrearEditarCuentaState extends ConsumerState<_DialogoCrearEditarCuenta> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _saldoInicialCtrl;
  String _tipo = 'banco';
  final String _icono = 'account_balance_wallet';

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.cuenta?.nombre ?? '');
    _saldoInicialCtrl = TextEditingController(
      text: widget.cuenta != null ? Money.fromCents(widget.cuenta!.saldoInicialCent).inSoles.toStringAsFixed(2) : '0.00',
    );
    if (widget.cuenta != null) {
      _tipo = widget.cuenta!.tipo;
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _saldoInicialCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cuenta != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Cuenta' : 'Nueva Cuenta'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre de la cuenta (ej. BCP Sueldo, Efectivo)'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _tipo,
                decoration: const InputDecoration(labelText: 'Tipo de cuenta'),
                items: const [
                  DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
                  DropdownMenuItem(value: 'banco', child: Text('Banco / Cuenta Corriente')),
                  DropdownMenuItem(value: 'ahorro', child: Text('Ahorros')),
                  DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta Débito/Crédito')),
                  DropdownMenuItem(value: 'otro', child: Text('Otro')),
                ],
                onChanged: (v) => setState(() => _tipo = v!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _saldoInicialCtrl,
                decoration: const InputDecoration(labelText: 'Saldo Inicial (S/ PEN)', prefixText: 'S/ '),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                enabled: !isEditing,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa un saldo inicial';
                  final parsed = Money.tryParse(v);
                  if (parsed == null) return 'Monto inválido';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: _guardar,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final dao = ref.read(cuentasDaoProvider);
    final writer = ref.read(auditedWriterProvider);

    if (widget.cuenta == null) {
      final saldo = Money.parse(_saldoInicialCtrl.text);
      await dao.insertCuenta(
        CuentasCompanion.insert(
          nombre: _nombreCtrl.text.trim(),
          tipo: _tipo,
          saldoInicialCent: drift.Value(saldo.cents),
          icono: drift.Value(_icono),
        ),
        writer,
      );
    } else {
      await dao.updateCuenta(
        widget.cuenta!,
        CuentasCompanion(
          nombre: drift.Value(_nombreCtrl.text.trim()),
          tipo: drift.Value(_tipo),
          icono: drift.Value(_icono),
        ),
        writer,
      );
    }

    if (mounted) Navigator.pop(context);
  }
}

// Diálogo para transferir fondos
class _DialogoTransferirFondos extends ConsumerStatefulWidget {
  const _DialogoTransferirFondos();

  @override
  ConsumerState<_DialogoTransferirFondos> createState() => _DialogoTransferirFondosState();
}

class _DialogoTransferirFondosState extends ConsumerState<_DialogoTransferirFondos> {
  final _formKey = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();
  final _descCtrl = TextEditingController(text: 'Transferencia entre cuentas');
  int? _cuentaOrigenId;
  int? _cuentaDestinoId;

  @override
  void dispose() {
    _montoCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cuentasAsync = ref.watch(cuentasActivasStreamProvider);

    return AlertDialog(
      title: const Text('Transferir Fondos'),
      content: SizedBox(
        width: 440,
        child: cuentasAsync.when(
          data: (cuentas) {
            if (cuentas.length < 2) {
              return const Text('Necesitas al menos dos cuentas activas para realizar transferencias.');
            }

            _cuentaOrigenId ??= cuentas.first.id;
            _cuentaDestinoId ??= cuentas[1].id;

            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: _cuentaOrigenId,
                    decoration: const InputDecoration(labelText: 'Cuenta de Origen (Descuenta)'),
                    items: cuentas
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                        .toList(),
                    onChanged: (v) => setState(() => _cuentaOrigenId = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: _cuentaDestinoId,
                    decoration: const InputDecoration(labelText: 'Cuenta de Destino (Abona)'),
                    items: cuentas
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                        .toList(),
                    onChanged: (v) => setState(() => _cuentaDestinoId = v),
                    validator: (v) => v == _cuentaOrigenId ? 'Elige una cuenta de destino distinta' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _montoCtrl,
                    decoration: const InputDecoration(labelText: 'Monto a Transferir', prefixText: 'S/ '),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Ingresa un monto';
                      final parsed = Money.tryParse(v);
                      if (parsed == null || parsed.isZero || parsed.isNegative) return 'Monto debe ser mayor a 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'Descripción / Motivo'),
                  ),
                ],
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, _) => Text('Error: $err'),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: _transferir,
          child: const Text('Confirmar Transferencia'),
        ),
      ],
    );
  }

  Future<void> _transferir() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cuentaOrigenId == null || _cuentaDestinoId == null) return;

    final dao = ref.read(movimientosDaoProvider);
    final writer = ref.read(auditedWriterProvider);
    final monto = Money.parse(_montoCtrl.text);

    await dao.registrarMovimiento(
      MovimientosCompanion.insert(
        fecha: DateTime.now(),
        tipo: 'transferencia',
        montoCent: monto.cents,
        cuentaOrigenId: _cuentaOrigenId!,
        cuentaDestinoId: drift.Value(_cuentaDestinoId),
        descripcion: _descCtrl.text.trim().isEmpty ? 'Transferencia' : _descCtrl.text.trim(),
      ),
      writer,
    );

    if (mounted) Navigator.pop(context);
  }
}