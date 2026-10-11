import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';

/// Modal para crear o editar una Partida presupuestaria dentro de un Proyecto.
class NuevaPartidaDialog extends ConsumerStatefulWidget {
  const NuevaPartidaDialog({
    super.key,
    required this.proyectoId,
    this.partida,
  });

  final int proyectoId;
  final PartidasProyectoData? partida;

  @override
  ConsumerState<NuevaPartidaDialog> createState() => _NuevaPartidaDialogState();
}

class _NuevaPartidaDialogState extends ConsumerState<NuevaPartidaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _presupuestoCtrl;
  late TextEditingController _descripcionCtrl;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final p = widget.partida;
    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _presupuestoCtrl = TextEditingController(
      text: p != null ? (p.presupuestoCent / 100).toStringAsFixed(2) : '',
    );
    _descripcionCtrl = TextEditingController(text: p?.descripcion ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _presupuestoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final esEdicion = widget.partida != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.dialogBorderRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
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
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      child: const Icon(Icons.assignment_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        esEdicion ? 'Editar Partida' : 'Nueva Partida Presupuestaria',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
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
                TextFormField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la Partida / Rubro *',
                    hintText: 'Ej. Mano de obra pintura, Porcelanato, Grifería',
                    prefixIcon: Icon(Icons.label_outline_rounded),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingresa el nombre de la partida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _presupuestoCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Presupuesto Estimado *',
                    prefixText: 'S/ ',
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingresa el monto presupuestado';
                    }
                    final money = Money.tryParse(val);
                    if (money == null || money.cents <= 0) {
                      return 'Ingresa un monto válido mayor a 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripcionCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descripción o Especificaciones',
                    hintText: 'Metrado, marca sugerida o detalles...',
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
                      onPressed: _guardando ? null : _guardar,
                      icon: _guardando
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(esEdicion ? 'Actualizar' : 'Guardar Partida'),
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

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final dao = ref.read(proyectosDaoProvider);
    final writer = ref.read(auditedWriterProvider);
    final montoMoney = Money.tryParse(_presupuestoCtrl.text) ?? Money.zero;

    try {
      if (widget.partida == null) {
        await dao.insertPartida(
          PartidasProyectoCompanion.insert(
            proyectoId: widget.proyectoId,
            nombre: _nombreCtrl.text.trim(),
            presupuestoCent: montoMoney.cents,
            descripcion: Value(_descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim()),
          ),
          writer,
        );
      } else {
        await dao.updatePartida(
          PartidasProyectoCompanion(
            id: Value(widget.partida!.id),
            nombre: Value(_nombreCtrl.text.trim()),
            presupuestoCent: Value(montoMoney.cents),
            descripcion: Value(_descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim()),
          ),
          writer,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.partida == null
                  ? 'Partida agregada correctamente.'
                  : 'Partida actualizada correctamente.',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e'), backgroundColor: AppColors.expense),
        );
      }
    }
  }
}
