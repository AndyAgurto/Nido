import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../movimientos/presentation/movimientos_providers.dart';

/// Modal para registrar un gasto real desembolsado y vincularlo directamente a una Partida de Proyecto.
class RegistrarGastoPartidaDialog extends ConsumerStatefulWidget {
  const RegistrarGastoPartidaDialog({
    super.key,
    required this.partida,
    required this.proyecto,
  });

  final PartidasProyectoData partida;
  final Proyecto proyecto;

  @override
  ConsumerState<RegistrarGastoPartidaDialog> createState() =>
      _RegistrarGastoPartidaDialogState();
}

class _RegistrarGastoPartidaDialogState
    extends ConsumerState<RegistrarGastoPartidaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _montoCtrl;
  late TextEditingController _descripcionCtrl;
  late TextEditingController _notasCtrl;

  int? _cuentaOrigenId;
  late DateTime _fecha;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _montoCtrl = TextEditingController();
    _descripcionCtrl = TextEditingController(
      text: '${widget.proyecto.nombre}: ${widget.partida.nombre}',
    );
    _notasCtrl = TextEditingController();
    _fecha = DateTime.now();
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    _descripcionCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cuentasAsync = ref.watch(cuentasActivasStreamProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.dialogBorderRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.expense.withValues(alpha: 0.12),
                      child: const Icon(Icons.shopping_bag_outlined, color: AppColors.expense),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registrar Gasto de Partida',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.partida.nombre,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                // Selector de Cuenta de Pago
                cuentasAsync.when(
                  data: (cuentas) {
                    if (cuentas.isEmpty) {
                      return const Text('No tienes cuentas activas registradas.');
                    }
                    _cuentaOrigenId ??= cuentas.first.id;

                    return DropdownButtonFormField<int>(
                      initialValue: _cuentaOrigenId,
                      decoration: const InputDecoration(
                        labelText: 'Cuenta de Pago / Desembolso *',
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                      ),
                      items: cuentas
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text('${c.nombre} (${c.tipo.toUpperCase()})'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _cuentaOrigenId = val);
                      },
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error al cargar cuentas: $e'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _montoCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Monto del Pago *',
                          prefixText: 'S/ ',
                          hintText: '0.00',
                          prefixIcon: Icon(Icons.attach_money_rounded),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingresa el monto a pagar';
                          }
                          final money = Money.tryParse(val);
                          if (money == null || money.cents <= 0) {
                            return 'Monto inválido (> 0)';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: _seleccionarFecha,
                        borderRadius: BorderRadius.circular(10),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Fecha del Desembolso',
                            prefixIcon: Icon(Icons.calendar_today_rounded),
                          ),
                          child: Text(AppDateFormats.formatSimple(_fecha)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Concepto o Detalle *',
                    hintText: 'Ej. Anticipo albañil, Compra 10 bolsas de cemento',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingresa el concepto del gasto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notasCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Notas Adicionales (Opcional)',
                    hintText: 'N° de boleta, comprobante, observaciones...',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _guardando ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.expense,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _guardando ? null : _guardarGasto,
                      icon: _guardando
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check_circle_outline_rounded),
                      label: const Text('Registrar Gasto Vinculado'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _fecha = picked);
    }
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cuentaOrigenId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una cuenta de pago')),
      );
      return;
    }

    setState(() => _guardando = true);
    final movimientosDao = ref.read(movimientosDaoProvider);
    final writer = ref.read(auditedWriterProvider);
    final montoMoney = Money.tryParse(_montoCtrl.text) ?? Money.zero;

    try {
      await movimientosDao.registrarMovimiento(
        MovimientosCompanion.insert(
          tipo: 'gasto',
          montoCent: montoMoney.cents,
          cuentaOrigenId: _cuentaOrigenId!,
          descripcion: _descripcionCtrl.text.trim(),
          fecha: _fecha,
          partidaId: Value(widget.partida.id),
          notas: Value(_notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim()),
        ),
        writer,
      );

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gasto de ${montoMoney.format()} vinculado exitosamente a "${widget.partida.nombre}".',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e'), backgroundColor: AppColors.expense),
        );
      }
    }
  }
}
