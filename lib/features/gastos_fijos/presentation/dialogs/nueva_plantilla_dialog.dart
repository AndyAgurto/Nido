import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../app/theme/app_colors.dart';

/// Diálogo para crear una nueva plantilla de gasto o ingreso fijo.
class NuevaPlantillaDialog extends ConsumerStatefulWidget {
  const NuevaPlantillaDialog({super.key, this.esGasto = true});

  final bool esGasto;

  @override
  ConsumerState<NuevaPlantillaDialog> createState() =>
      _NuevaPlantillaDialogState();
}

class _NuevaPlantillaDialogState
    extends ConsumerState<NuevaPlantillaDialog> {
  final _formKey = GlobalKey<FormState>();
  late bool _esGasto;
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _montoCtrl;
  late final TextEditingController _diaCtrl;
  int? _categoriaId;
  int? _cuentaId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _esGasto = widget.esGasto;
    _nombreCtrl = TextEditingController();
    _montoCtrl = TextEditingController();
    _diaCtrl = TextEditingController(text: '15');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _montoCtrl.dispose();
    _diaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriasDao = ref.watch(categoriasDaoProvider);
    final cuentasDao = ref.watch(cuentasDaoProvider);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _esGasto ? Icons.event_repeat_rounded : Icons.monetization_on_outlined,
            color: _esGasto ? AppColors.expense : AppColors.income,
          ),
          const SizedBox(width: 10),
          Text(_esGasto ? 'Nueva Plantilla de Gasto Fijo' : 'Nueva Plantilla de Ingreso Fijo'),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: true,
                      label: Text('Gasto Fijo'),
                      icon: Icon(Icons.arrow_upward_rounded),
                    ),
                    ButtonSegment(
                      value: false,
                      label: Text('Ingreso Fijo'),
                      icon: Icon(Icons.arrow_downward_rounded),
                    ),
                  ],
                  selected: {_esGasto},
                  onSelectionChanged: (val) {
                    setState(() {
                      _esGasto = val.first;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nombreCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nombre del servicio o concepto',
                    hintText: _esGasto ? 'Ej. Alquiler, Internet Fibra, Luz Enel' : 'Ej. Sueldo Principal, Renta',
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Ingresa un nombre' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _montoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Monto Estimado (PEN)',
                          prefixText: 'S/ ',
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Ingresa el monto';
                          final m = Money.tryParse(v);
                          if (m == null || m.isNegative || m.isZero) {
                            return 'Monto mayor a 0';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _diaCtrl,
                        decoration: InputDecoration(
                          labelText: _esGasto ? 'Día vencimiento' : 'Día cobro',
                          hintText: '1 - 31',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Día requerido';
                          final d = int.tryParse(v);
                          if (d == null || d < 1 || d > 31) {
                            return 'Entre 1 y 31';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Selector de cuenta habitual de pago / abono
                StreamBuilder<List<Cuenta>>(
                  stream: cuentasDao.watchCuentasActivas(),
                  builder: (context, snapshot) {
                    final cuentas = snapshot.data ?? [];
                    if (cuentas.isNotEmpty && _cuentaId == null) {
                      _cuentaId = cuentas.first.id;
                    }
                    return DropdownButtonFormField<int>(
                      initialValue: _cuentaId,
                      decoration: InputDecoration(
                        labelText: _esGasto
                            ? 'Cuenta habitual de pago'
                            : 'Cuenta habitual de abono',
                      ),
                      items: cuentas
                          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                          .toList(),
                      onChanged: (v) => setState(() => _cuentaId = v),
                      validator: (v) => v == null ? 'Selecciona una cuenta' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (_esGasto) ...[
                  StreamBuilder<List<Categoria>>(
                    stream: categoriasDao.watchCategorias(tipo: 'gasto'),
                    builder: (context, snapshot) {
                      final cats = snapshot.data ?? [];
                      if (cats.isNotEmpty && _categoriaId == null) {
                        _categoriaId = cats.first.id;
                      }
                      return DropdownButtonFormField<int>(
                        initialValue: _categoriaId,
                        decoration: const InputDecoration(
                          labelText: 'Categoría asignada',
                        ),
                        items: cats
                            .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                            .toList(),
                        onChanged: (v) => setState(() => _categoriaId = v),
                        validator: (v) => v == null ? 'Selecciona una categoría' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
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
          onPressed: _isSaving ? null : _guardar,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Crear Plantilla'),
        ),
      ],
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cuentaId == null) return;
    if (_esGasto && _categoriaId == null) return;

    setState(() => _isSaving = true);

    try {
      final monto = Money.parse(_montoCtrl.text);
      final dia = int.parse(_diaCtrl.text.trim());
      final dao = ref.read(gastosFijosDaoProvider);
      final writer = ref.read(auditedWriterProvider);

      if (_esGasto) {
        await dao.insertGastoFijo(
          GastosFijosCompanion.insert(
            nombre: _nombreCtrl.text.trim(),
            montoEstimadoCent: monto.cents,
            diaVencimiento: dia,
            cuentaPagoId: _cuentaId!,
            categoriaId: _categoriaId!,
            fechaInicio: DateTime.now(),
          ),
          writer,
        );
      } else {
        await dao.insertIngresoFijo(
          IngresosFijosCompanion.insert(
            nombre: _nombreCtrl.text.trim(),
            montoEstimadoCent: monto.cents,
            cuentaId: _cuentaId!,
            diaCobro: dia,
          ),
          writer,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Plantilla "${_nombreCtrl.text.trim()}" guardada exitosamente.',
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear plantilla: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}