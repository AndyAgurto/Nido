import 'package:nido/core/formatters/money_input_formatter.dart';
import '../../../../core/utils/date_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../app/theme/app_colors.dart';

/// Diálogo para registrar el pago de un gasto fijo mensual.
class MarcarPagadoDialog extends ConsumerStatefulWidget {
  const MarcarPagadoDialog({
    super.key,
    required this.pago,
    required this.plantilla,
  });

  final GastosFijosPago pago;
  final GastosFijo plantilla;

  @override
  ConsumerState<MarcarPagadoDialog> createState() =>
      _MarcarPagadoDialogState();
}

class _MarcarPagadoDialogState extends ConsumerState<MarcarPagadoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _montoRealCtrl;
  int? _cuentaId;
  DateTime _fechaPago = DateTime.now();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final montoEsperado = Money.fromCents(widget.pago.montoEsperadoCent);
    _montoRealCtrl = TextEditingController(
      text: montoEsperado.inSoles.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _montoRealCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cuentasDao = ref.watch(cuentasDaoProvider);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.income),
          const SizedBox(width: 10),
          const Text('Marcar Gasto como Pagado'),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plantilla.nombre,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Periodo: ${widget.pago.periodo} • Vencimiento: ${DateFormat('dd/MM/yyyy').format(widget.pago.fechaVencimiento)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Monto Real Pagado
              TextFormField(
                controller: _montoRealCtrl,
                decoration: const InputDecoration(
                  labelText: 'Monto Real Pagado',
                  prefixText: 'S/ ',
                  hintText: '0.00',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: const [
                    BcpMoneyInputFormatter(),
                  ],
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Ingresa el monto';
                  final m = Money.tryParse(val);
                  if (m == null || m.isNegative || m.isZero) {
                    return 'Monto debe ser mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Cuenta de pago
              StreamBuilder<List<Cuenta>>(
                stream: cuentasDao.watchCuentasActivas(),
                builder: (context, snapshot) {
                  final cuentas = snapshot.data ?? [];
                  if (cuentas.isEmpty) {
                    return const Text(
                      'No hay cuentas disponibles para realizar el pago.',
                      style: TextStyle(color: Colors.red),
                    );
                  }
                  _cuentaId ??= cuentas.first.id;

                  return DropdownButtonFormField<int>(
                    initialValue: _cuentaId,
                    decoration: const InputDecoration(
                      labelText: 'Cuenta desde la que se pagó (Descuenta saldo)',
                    ),
                    items: cuentas
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => _cuentaId = val),
                    validator: (val) =>
                        val == null ? 'Selecciona una cuenta' : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Selector de Fecha de Pago
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _fechaPago,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) {
                    setState(() => _fechaPago = picked);
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha del Pago Realizado',
                    suffixIcon: Icon(Icons.calendar_today_rounded),
                  ),
                  child: Text(
                    AppDateFormats.formatFechaConDia(_fechaPago),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isProcessing ? null : _confirmarPago,
          child: _isProcessing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirmar Pago'),
        ),
      ],
    );
  }

  Future<void> _confirmarPago() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cuentaId == null) return;

    setState(() => _isProcessing = true);

    try {
      final monto = Money.parse(_montoRealCtrl.text);
      final dao = ref.read(gastosFijosDaoProvider);
      final writer = ref.read(auditedWriterProvider);

      await dao.marcarGastoFijoPagado(
        pagoId: widget.pago.id,
        cuentaId: _cuentaId!,
        montoRealCent: monto.cents,
        fechaPago: _fechaPago,
        writer: writer,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Pago registrado! Se vinculó el movimiento de gasto por ${monto.format()}.',
            ),
            backgroundColor: AppColors.income,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al procesar pago: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}