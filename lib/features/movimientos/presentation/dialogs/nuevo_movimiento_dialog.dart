import 'package:nido/core/formatters/money_input_formatter.dart';
import '../../../../core/utils/date_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../app/theme/app_colors.dart';
import '../movimientos_providers.dart';

/// Diálogo para registrar un nuevo movimiento (Ingreso, Gasto o Transferencia).
class NuevoMovimientoDialog extends ConsumerStatefulWidget {
  const NuevoMovimientoDialog({super.key});

  @override
  ConsumerState<NuevoMovimientoDialog> createState() =>
      _NuevoMovimientoDialogState();
}

class _NuevoMovimientoDialogState
    extends ConsumerState<NuevoMovimientoDialog> {
  final _formKey = GlobalKey<FormState>();
  String _tipo = 'gasto'; // 'gasto', 'ingreso', 'transferencia'
  late final TextEditingController _montoCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _notasCtrl;

  DateTime _fecha = DateTime.now();
  int? _cuentaOrigenId;
  int? _cuentaDestinoId;
  int? _categoriaId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _montoCtrl = TextEditingController();
    _descCtrl = TextEditingController();
    _notasCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    _descCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cuentasAsync = ref.watch(cuentasActivasStreamProvider);
    final categoriasDao = ref.watch(categoriasDaoProvider);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _tipo == 'ingreso'
                ? Icons.arrow_downward_rounded
                : (_tipo == 'gasto'
                    ? Icons.arrow_upward_rounded
                    : Icons.swap_horiz_rounded),
            color: _tipo == 'ingreso'
                ? AppColors.income
                : (_tipo == 'gasto' ? AppColors.expense : AppColors.transfer),
          ),
          const SizedBox(width: 10),
          const Text('Registrar Movimiento'),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Selector de tipo responsive con pills
                Row(
                  children: [
                    Expanded(
                      child: _buildTipoButton(
                        tipo: 'gasto',
                        label: 'Gasto',
                        icon: Icons.arrow_upward_rounded,
                        color: AppColors.expense,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTipoButton(
                        tipo: 'ingreso',
                        label: 'Ingreso',
                        icon: Icons.arrow_downward_rounded,
                        color: AppColors.income,
                        theme: theme,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTipoButton(
                        tipo: 'transferencia',
                        label: 'Transferir',
                        icon: Icons.swap_horiz_rounded,
                        color: AppColors.transfer,
                        theme: theme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Monto en Soles
                TextFormField(
                  controller: _montoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Monto (PEN)',
                    prefixText: 'S/ ',
                    hintText: '0.00',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: const [
                    BcpMoneyInputFormatter(),
                  ],
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingresa un monto';
                    }
                    final m = Money.tryParse(val);
                    if (m == null || m.isZero || m.isNegative) {
                      return 'El monto debe ser mayor a 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Descripción
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Ej. Compra supermercado, Pago sueldo',
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'La descripción es obligatoria';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Selector de Cuentas
                cuentasAsync.when(
                  data: (cuentas) {
                    if (cuentas.isEmpty) {
                      return const Text(
                        'No hay cuentas activas registradas.',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                    _cuentaOrigenId ??= cuentas.first.id;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<int>(
                          initialValue: _cuentaOrigenId,
                          decoration: InputDecoration(
                            labelText: _tipo == 'transferencia'
                                ? 'Cuenta de Origen'
                                : 'Cuenta',
                          ),
                          items: cuentas.map((c) {
                            return DropdownMenuItem(
                              value: c.id,
                              child: Text(c.nombre),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _cuentaOrigenId = val),
                          validator: (val) =>
                              val == null ? 'Selecciona una cuenta' : null,
                        ),
                        if (_tipo == 'transferencia') ...[
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            initialValue: _cuentaDestinoId,
                            decoration: const InputDecoration(
                              labelText: 'Cuenta de Destino',
                            ),
                            items: cuentas.map((c) {
                              return DropdownMenuItem(
                                value: c.id,
                                child: Text(c.nombre),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _cuentaDestinoId = val),
                            validator: (val) {
                              if (val == null) {
                                return 'Selecciona la cuenta destino';
                              }
                              if (val == _cuentaOrigenId) {
                                return 'Debe ser distinta a la cuenta origen';
                              }
                              return null;
                            },
                          ),
                        ],
                      ],
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Error al cargar cuentas: $e'),
                ),
                const SizedBox(height: 16),

                // Categoría (solo para gasto e ingreso)
                if (_tipo != 'transferencia') ...[
                  StreamBuilder<List<Categoria>>(
                    stream: categoriasDao.watchCategorias(tipo: _tipo),
                    builder: (context, snapshot) {
                      final cats = snapshot.data ?? [];
                      return DropdownButtonFormField<int>(
                        initialValue: _categoriaId,
                        decoration: const InputDecoration(
                          labelText: 'Categoría (Opcional)',
                        ),
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('Sin categoría'),
                          ),
                          ...cats.map((cat) {
                            return DropdownMenuItem<int>(
                              value: cat.id,
                              child: Text(cat.nombre),
                            );
                          }),
                        ],
                        onChanged: (val) => setState(() => _categoriaId = val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Selector de Fecha
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _fecha,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (picked != null) {
                      setState(() {
                        _fecha = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          _fecha.hour,
                          _fecha.minute,
                        );
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha del Movimiento',
                      suffixIcon: Icon(Icons.calendar_today_rounded),
                    ),
                    child: Text(
                      AppDateFormats.formatFechaConDia(_fecha),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notas
                TextFormField(
                  controller: _notasCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Notas adicionales (Opcional)',
                    hintText: 'Detalles, observaciones o comprobante',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _guardarMovimiento,
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

  Future<void> _guardarMovimiento() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cuentaOrigenId == null) return;

    setState(() => _isSaving = true);

    try {
      final monto = Money.parse(_montoCtrl.text);
      final dao = ref.read(movimientosDaoProvider);
      final writer = ref.read(auditedWriterProvider);

      await dao.registrarMovimiento(
        MovimientosCompanion.insert(
          fecha: _fecha,
          tipo: _tipo,
          montoCent: monto.cents,
          cuentaOrigenId: _cuentaOrigenId!,
          cuentaDestinoId: drift.Value(_tipo == 'transferencia' ? _cuentaDestinoId : null),
          categoriaId: drift.Value(_tipo != 'transferencia' ? _categoriaId : null),
          descripcion: _descCtrl.text.trim(),
          notas: drift.Value(_notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim()),
        ),
        writer,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_tipo.toUpperCase()} registrado exitosamente por ${monto.format()}',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar movimiento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
  Widget _buildTipoButton({
    required String tipo,
    required String label,
    required IconData icon,
    required Color color,
    required ThemeData theme,
  }) {
    final isSelected = _tipo == tipo;

    return InkWell(
      onTap: () {
        setState(() {
          _tipo = tipo;
          _categoriaId = null;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
