import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/fotos_cotizaciones_service.dart';

/// Diálogo modal con zoom y paneo para visualizar la fotografía física de una cotización.
class FotoViewerDialog extends StatefulWidget {
  const FotoViewerDialog({
    super.key,
    required this.rutaRelativa,
    required this.proveedor,
  });

  final String rutaRelativa;
  final String proveedor;

  @override
  State<FotoViewerDialog> createState() => _FotoViewerDialogState();
}

class _FotoViewerDialogState extends State<FotoViewerDialog> {
  File? _archivo;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final file = await FotosCotizacionesService.resolverArchivo(widget.rutaRelativa);
    if (mounted) {
      setState(() {
        _archivo = file;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 750),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_rounded, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Cotización: ${widget.proveedor}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Expanded(
              child: _cargando
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _archivo != null
                      ? InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Center(
                            child: Image.file(_archivo!),
                          ),
                        )
                      : const Center(
                          child: Text(
                            'No se pudo encontrar la imagen en el almacenamiento local.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
