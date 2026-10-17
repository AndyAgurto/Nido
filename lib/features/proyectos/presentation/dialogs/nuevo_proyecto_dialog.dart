import 'package:nido/core/formatters/money_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';

/// Modal para crear o editar un Proyecto del Hogar con auditoría completa.
class NuevoProyectoDialog extends ConsumerStatefulWidget {
  const NuevoProyectoDialog({super.key, this.proyecto});

  final Proyecto? proyecto;

  @override
  ConsumerState<NuevoProyectoDialog> createState() => _NuevoProyectoDialogState();
}

class _NuevoProyectoDialogState extends ConsumerState<NuevoProyectoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _descripcionCtrl;
  late TextEditingController _presupuestoCtrl;

  late String _tipo;
  late String _estado;
  late String _prioridad;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;
  bool _guardando = false;

  final Map<String, String> _tiposMap = {
    'decoracion': 'Decoración',
    'construccion': 'Construcción / Obra',
    'arreglo': 'Reparación / Mantenimiento',
    'mobiliario': 'Mobiliario y Equipamiento',
    'otro': 'Otro',
  };

  final Map<String, String> _estadosMap = {
    'idea': 'En Idea',
    'cotizando': 'Cotizando',
    'aprobado': 'Aprobado',
    'enEjecucion': 'En Ejecución',
    'terminado': 'Terminado',
    'cancelado': 'Cancelado',
  };

  @override
  void initState() {
    super.initState();
    final p = widget.proyecto;
    _nombreCtrl = TextEditingController(text: p?.nombre ?? '');
    _descripcionCtrl = TextEditingController(text: p?.descripcion ?? '');
    _presupuestoCtrl = TextEditingController(
      text: p != null ? (p.presupuestoObjetivoCent / 100).toStringAsFixed(2) : '',
    );
    _tipo = p?.tipo ?? 'decoracion';
    _estado = p?.estado ?? 'idea';
    _prioridad = p?.prioridad ?? 'media';
    _fechaInicio = p?.fechaInicioEstimada;
    _fechaFin = p?.fechaFinEstimada;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _presupuestoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final esEdicion = widget.proyecto != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.dialogBorderRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      child: const Icon(Icons.handyman_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        esEdicion ? 'Editar Proyecto' : 'Nuevo Proyecto del Hogar',
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nombreCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del Proyecto *',
                            hintText: 'Ej. Remodelación Cocina, Pintura Fachada',
                            prefixIcon: Icon(Icons.edit_outlined),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Ingresa el nombre del proyecto';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        StreamBuilder<List<Categoria>>(
                          stream: ref.watch(categoriasDaoProvider).watchCategorias(tipo: 'proyecto'),
                          builder: (context, snapshot) {
                            final catsProy = snapshot.data ?? [];
                            final Map<String, String> mergedTipos = Map.from(_tiposMap);
                            for (final c in catsProy) {
                              mergedTipos[c.nombre.toLowerCase().replaceAll(' ', '_')] = c.nombre;
                            }

                            final effectiveTipo = mergedTipos.containsKey(_tipo)
                                ? _tipo
                                : (mergedTipos.keys.firstOrNull ?? 'decoracion');

                            return DropdownButtonFormField<String>(
                              initialValue: effectiveTipo,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Tipo de Proyecto',
                                prefixIcon: Icon(Icons.category_outlined),
                              ),
                              items: mergedTipos.entries
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.key,
                                      child: Text(e.value, maxLines: 1, // Limita a una sola línea (o las que necesites)
                                        overflow: TextOverflow.ellipsis),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => _tipo = v);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _estado,
                          decoration: const InputDecoration(
                            labelText: 'Estado Inicial',
                            prefixIcon: Icon(Icons.flag_outlined),
                          ),
                          items: _estadosMap.entries
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.key,
                                  child: Text(e.value),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _estado = v);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _presupuestoCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: const [
                    BcpMoneyInputFormatter(),
                  ],
                          decoration: const InputDecoration(
                            labelText: 'Presupuesto Objetivo *',
                            prefixText: 'S/ ',

                            hintText: '0.00',
                            prefixIcon: Icon(Icons.attach_money_rounded),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Ingresa el presupuesto objetivo';
                            }
                            final money = Money.tryParse(val);
                            if (money == null || money.cents <= 0) {
                              return 'Ingresa un monto válido mayor a 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Prioridad',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPrioridadPill('baja', 'Baja', Icons.keyboard_double_arrow_down_rounded, theme),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildPrioridadPill('media', 'Media', Icons.remove_rounded, theme),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildPrioridadPill('alta', 'Alta', Icons.keyboard_double_arrow_up_rounded, theme),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                                onTap: _seleccionarFechaInicio,
                                borderRadius: BorderRadius.circular(10),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Inicio Estimado',
                                    prefixIcon: Icon(Icons.calendar_today_rounded),
                                  ),
                                  child: Text(
                                    _fechaInicio != null
                                        ? AppDateFormats.formatSimple(_fechaInicio!)
                                        : 'Sin fecha',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: _seleccionarFechaFin,
                                borderRadius: BorderRadius.circular(10),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Fin Estimado',
                                    prefixIcon: Icon(Icons.event_available_rounded),
                                  ),
                                  child: Text(
                                    _fechaFin != null
                                        ? AppDateFormats.formatSimple(_fechaFin!)
                                        : 'Sin fecha',
                                  ),
                                ),
                              ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descripcionCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Notas del Proyecto',
                            hintText: 'Detalles, objetivos, medidas,etc.',
                            prefixIcon: Icon(Icons.notes_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                      label: Text(esEdicion ? 'Actualizar' : 'Crear Proyecto'),
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

  Future<void> _seleccionarFechaInicio() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _fechaInicio = picked);
    }
  }

  Future<void> _seleccionarFechaFin() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaFin ?? (_fechaInicio ?? DateTime.now()),
      firstDate: _fechaInicio ?? DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _fechaFin = picked);
    }
  }

  Widget _buildPrioridadPill(String valor, String label, IconData icon, ThemeData theme) {
    final isSelected = _prioridad == valor;
    final color = valor == 'alta'
        ? AppColors.expense
        : (valor == 'media' ? const Color(0xFFEAB308) : Colors.blue);

    return InkWell(
      onTap: () => setState(() => _prioridad = valor),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? color : theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? color : theme.colorScheme.onSurfaceVariant,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
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
      int? nuevoId;
      if (widget.proyecto == null) {
        // Crear
        nuevoId = await dao.insertProyecto(
          ProyectosCompanion.insert(
            nombre: _nombreCtrl.text.trim(),
            descripcion: Value(_descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim()),
            tipo: _tipo,
            estado: Value(_estado),
            presupuestoObjetivoCent: montoMoney.cents,
            fechaInicioEstimada: Value(_fechaInicio),
            fechaFinEstimada: Value(_fechaFin),
            prioridad: Value(_prioridad),
          ),
          writer,
        );
      } else {
        // Editar
        await dao.updateProyecto(
          ProyectosCompanion(
            id: Value(widget.proyecto!.id),
            nombre: Value(_nombreCtrl.text.trim()),
            descripcion: Value(_descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim()),
            tipo: Value(_tipo),
            estado: Value(_estado),
            presupuestoObjetivoCent: Value(montoMoney.cents),
            fechaInicioEstimada: Value(_fechaInicio),
            fechaFinEstimada: Value(_fechaFin),
            prioridad: Value(_prioridad),
          ),
          writer,
        );
      }

      if (mounted) {
        Navigator.pop(context, widget.proyecto == null ? nuevoId : widget.proyecto!.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.proyecto == null
                  ? 'Proyecto creado correctamente.'
                  : 'Proyecto actualizado correctamente.',
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
