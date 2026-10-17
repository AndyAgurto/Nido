import 'package:nido/core/formatters/money_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../app/theme/app_colors.dart';
import '../presupuesto_providers.dart';

/// Diálogo modal para asignar o actualizar el presupuesto de una categoría.
class AsignarPresupuestoDialog extends ConsumerStatefulWidget {
  const AsignarPresupuestoDialog({
    super.key,
    required this.categoria,
    required this.periodo,
    this.montoActual,
  });

  final Categoria categoria;
  final String periodo;
  final Money? montoActual;

  @override
  ConsumerState<AsignarPresupuestoDialog> createState() =>
      _AsignarPresupuestoDialogState();
}

class _AsignarPresupuestoDialogState
    extends ConsumerState<AsignarPresupuestoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _montoCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final inicial = widget.montoActual != null && !widget.montoActual!.isZero
        ? widget.montoActual!.inSoles.toStringAsFixed(2)
        : '';
    _montoCtrl = TextEditingController(text: inicial);
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.pie_chart_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          const Text('Asignar Presupuesto'),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categoría: ${widget.categoria.nombre}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Periodo: ${widget.periodo}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _montoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Presupuesto Mensual (PEN)',
                  prefixText: 'S/ ',
                  hintText: '0.00',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: const [
                    BcpMoneyInputFormatter(),
                  ],
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Ingresa un monto';
                  }
                  final m = Money.tryParse(val);
                  if (m == null || m.isNegative) {
                    return 'Ingresa un monto válido';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _guardar,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final monto = Money.parse(_montoCtrl.text);
      final dao = ref.read(presupuestosDaoProvider);
      final writer = ref.read(auditedWriterProvider);

      await dao.setPresupuesto(
        periodo: widget.periodo,
        categoriaId: widget.categoria.id,
        montoCent: monto.cents,
        writer: writer,
      );

      // Invalidamos el provider para refrescar la UI
      ref.invalidate(presupuestosItemsProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Presupuesto para "${widget.categoria.nombre}" actualizado a ${monto.format()}.',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar presupuesto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}