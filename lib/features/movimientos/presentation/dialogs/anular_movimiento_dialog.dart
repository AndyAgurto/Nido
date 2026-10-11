import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../app/theme/app_colors.dart';

/// Diálogo modal para solicitar el motivo obligatorio de anulación.
class AnularMovimientoDialog extends ConsumerStatefulWidget {
  const AnularMovimientoDialog({super.key, required this.movimiento});

  final Movimiento movimiento;

  @override
  ConsumerState<AnularMovimientoDialog> createState() =>
      _AnularMovimientoDialogState();
}

class _AnularMovimientoDialogState
    extends ConsumerState<AnularMovimientoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _motivoCtrl;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _motivoCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _motivoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monto = Money.fromCents(widget.movimiento.montoCent);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.cancel_outlined, color: AppColors.expense),
          SizedBox(width: 10),
          Text('Anular Movimiento'),
        ],
      ),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.terracottaContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.onTerracottaContainer),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Al anular "${widget.movimiento.descripcion}" (${monto.format()}), su impacto financiero se excluirá del saldo de la cuenta inmediatamente.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onTerracottaContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Motivo de anulación (Obligatorio):',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _motivoCtrl,
                decoration: const InputDecoration(
                  hintText: 'Ej. Error en monto, transacción duplicada, compra cancelada',
                ),
                maxLines: 3,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Debes ingresar un motivo para auditar la anulación';
                  }
                  if (val.trim().length < 4) {
                    return 'El motivo debe ser más descriptivo';
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
          onPressed: _isProcessing ? null : () => Navigator.pop(context),
          child: const Text('Volver'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.expense,
            foregroundColor: Colors.white,
          ),
          onPressed: _isProcessing ? null : _confirmarAnulacion,
          child: _isProcessing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Confirmar Anulación'),
        ),
      ],
    );
  }

  Future<void> _confirmarAnulacion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final dao = ref.read(movimientosDaoProvider);
      final writer = ref.read(auditedWriterProvider);

      await dao.anularMovimiento(
        widget.movimiento.id,
        motivo: _motivoCtrl.text.trim(),
        writer: writer,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Movimiento anulado correctamente y registrado en auditoría.'),
            backgroundColor: AppColors.expense,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al anular movimiento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}