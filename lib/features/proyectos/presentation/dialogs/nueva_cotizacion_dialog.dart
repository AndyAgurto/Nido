import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/money/money.dart';
import '../../../../core/utils/date_formatters.dart';
import '../../../../app/constants/app_constants.dart';
import '../../../../app/theme/app_colors.dart';
import '../../data/fotos_cotizaciones_service.dart';

/// Modal para registrar o editar una Cotización de proveedor, incluyendo fotografía física.
class NuevaCotizacionDialog extends ConsumerStatefulWidget {
  const NuevaCotizacionDialog({
    super.key,
    required this.partidaId,
    this.cotizacion,
  });

  final int partidaId;
  final Cotizacione? cotizacion;

  @override
  ConsumerState<NuevaCotizacionDialog> createState() => _NuevaCotizacionDialogState();
}

class _NuevaCotizacionDialogState extends ConsumerState<NuevaCotizacionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _proveedorCtrl;
  late TextEditingController _contactoCtrl;
  late TextEditingController _montoCtrl;
  late TextEditingController _notasCtrl;

  late DateTime _fecha;
  DateTime? _vigenteHasta;
  XFile? _fotoSeleccionada;
  File? _fotoGuardadaArchivo;
  String? _fotoRutaRelativaActual;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final c = widget.cotizacion;
    _proveedorCtrl = TextEditingController(text: c?.proveedor ?? '');
    _contactoCtrl = TextEditingController(text: c?.contacto ?? '');
    _montoCtrl = TextEditingController(
      text: c != null ? (c.montoCent / 100).toStringAsFixed(2) : '',
    );
    _notasCtrl = TextEditingController(text: c?.notas ?? '');
    _fecha = c?.fecha ?? DateTime.now();
    _vigenteHasta = c?.vigenteHasta;
    _fotoRutaRelativaActual = c?.fotoRutaRelativa;

    if (_fotoRutaRelativaActual != null) {
      _cargarArchivoFotoGuardada(_fotoRutaRelativaActual!);
    }
  }

  Future<void> _cargarArchivoFotoGuardada(String ruta) async {
    final file = await FotosCotizacionesService.resolverArchivo(ruta);
    if (mounted && file != null) {
      setState(() => _fotoGuardadaArchivo = file);
    }
  }

  @override
  void dispose() {
    _proveedorCtrl.dispose();
    _contactoCtrl.dispose();
    _montoCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final esEdicion = widget.cotizacion != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.dialogBorderRadius),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 750),
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
                      backgroundColor: AppColors.income.withValues(alpha: 0.12),
                      child: const Icon(Icons.request_quote_rounded, color: AppColors.income),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        esEdicion ? 'Editar Cotización' : 'Nueva Cotización de Proveedor',
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
                          controller: _proveedorCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Proveedor o Empresa *',
                            hintText: 'Ej. Maestro Homecenter, Sodimac, Carpintería Juan',
                            prefixIcon: Icon(Icons.store_rounded),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Ingresa el nombre del proveedor';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _montoCtrl,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Monto Cotizado *',
                                  prefixText: 'S/ ',
                                  hintText: '0.00',
                                  prefixIcon: Icon(Icons.attach_money_rounded),
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Ingresa el monto cotizado';
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
                              child: TextFormField(
                                controller: _contactoCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Contacto / Teléfono',
                                  hintText: 'Ej. 998 123 456',
                                  prefixIcon: Icon(Icons.phone_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: _seleccionarFechaCotizacion,
                                borderRadius: BorderRadius.circular(10),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Fecha de Cotización',
                                    prefixIcon: Icon(Icons.calendar_today_rounded),
                                  ),
                                  child: Text(AppDateFormats.formatSimple(_fecha)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: _seleccionarVigencia,
                                borderRadius: BorderRadius.circular(10),
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'Válida Hasta',
                                    prefixIcon: Icon(Icons.event_available_rounded),
                                  ),
                                  child: Text(
                                    _vigenteHasta != null
                                        ? AppDateFormats.formatSimple(_vigenteHasta!)
                                        : 'Sin vencimiento',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notasCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Notas / Condiciones',
                            hintText: 'Incluye flete, IGV, tiempo de entrega, garantía...',
                            prefixIcon: Icon(Icons.notes_rounded),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Sección de Fotografía Física
                        Text(
                          'Foto del Presupuesto o Boleta (100% Local)',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildFotoSection(theme),
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
                      label: Text(esEdicion ? 'Actualizar' : 'Guardar Cotización'),
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

  Widget _buildFotoSection(ThemeData theme) {
    final tieneFoto = _fotoSeleccionada != null || _fotoGuardadaArchivo != null;

    if (tieneFoto) {
      return Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox.expand(
                child: _fotoSeleccionada != null
                    ? Image.file(
                        File(_fotoSeleccionada!.path),
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _fotoGuardadaArchivo!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
                tooltip: 'Eliminar foto',
                onPressed: () {
                  setState(() {
                    _fotoSeleccionada = null;
                    _fotoGuardadaArchivo = null;
                    _fotoRutaRelativaActual = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            onPressed: () => _tomarFoto(ImageSource.camera),
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Tomar Foto'),
          ),
          const SizedBox(width: 16),
          FilledButton.tonalIcon(
            onPressed: () => _tomarFoto(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_rounded),
            label: const Text('Galería'),
          ),
        ],
      ),
    );
  }

  Future<void> _tomarFoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() {
          _fotoSeleccionada = picked;
          _fotoGuardadaArchivo = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo obtener la imagen: $e')),
        );
      }
    }
  }

  Future<void> _seleccionarFechaCotizacion() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _fecha = picked);
    }
  }

  Future<void> _seleccionarVigencia() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _vigenteHasta ?? _fecha.add(const Duration(days: 15)),
      firstDate: _fecha,
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _vigenteHasta = picked);
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final dao = ref.read(proyectosDaoProvider);
    final writer = ref.read(auditedWriterProvider);
    final montoMoney = Money.tryParse(_montoCtrl.text) ?? Money.zero;

    try {
      String? rutaRelativa = _fotoRutaRelativaActual;

      // Si se seleccionó una nueva foto, copiarla al sandbox privado
      if (_fotoSeleccionada != null) {
        rutaRelativa = await FotosCotizacionesService.guardarFoto(
          partidaId: widget.partidaId,
          archivo: _fotoSeleccionada!,
        );
      }

      if (widget.cotizacion == null) {
        // Nueva cotización
        await dao.insertCotizacion(
          CotizacionesCompanion.insert(
            partidaId: widget.partidaId,
            proveedor: _proveedorCtrl.text.trim(),
            contacto: Value(_contactoCtrl.text.trim().isEmpty ? null : _contactoCtrl.text.trim()),
            montoCent: montoMoney.cents,
            fecha: _fecha,
            vigenteHasta: Value(_vigenteHasta),
            notas: Value(_notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim()),
            fotoRutaRelativa: Value(rutaRelativa),
          ),
          writer,
        );
      } else {
        // Actualizar cotización
        await dao.updateCotizacion(
          CotizacionesCompanion(
            id: Value(widget.cotizacion!.id),
            proveedor: Value(_proveedorCtrl.text.trim()),
            contacto: Value(_contactoCtrl.text.trim().isEmpty ? null : _contactoCtrl.text.trim()),
            montoCent: Value(montoMoney.cents),
            fecha: Value(_fecha),
            vigenteHasta: Value(_vigenteHasta),
            notas: Value(_notasCtrl.text.trim().isEmpty ? null : _notasCtrl.text.trim()),
            fotoRutaRelativa: Value(rutaRelativa),
          ),
          writer,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.cotizacion == null
                  ? 'Cotización registrada con éxito.'
                  : 'Cotización actualizada con éxito.',
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
