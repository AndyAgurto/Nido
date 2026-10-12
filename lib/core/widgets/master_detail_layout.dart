import 'package:flutter/material.dart';
import '../../app/constants/app_constants.dart';

/// Layout adaptable de dos paneles (Maestro - Detalle).
/// - En Tablet (>= 840dp): Muestra ambos paneles en paralelo con división vertical.
/// - En Móvil (< 840dp): Muestra el panel maestro con selector segmentado para alternar a detalle.
class MasterDetailLayout extends StatefulWidget {
  const MasterDetailLayout({
    super.key,
    required this.master,
    required this.detail,
    this.masterWidth = 380.0,
    this.breakpoint = AppConstants.tabletBreakpoint,
    this.emptyDetailPlaceholder,
  });

  /// Widget que contiene la lista o panel maestro
  final Widget master;

  /// Widget que contiene el detalle del elemento seleccionado
  final Widget? detail;

  /// Ancho fijo para el panel maestro cuando ambos paneles están visibles
  final double masterWidth;

  /// Breakpoint para conmutar entre modo dos paneles y panel individual
  final double breakpoint;

  /// Placeholder visual cuando no hay elemento seleccionado en el panel de detalle
  final Widget? emptyDetailPlaceholder;

  @override
  State<MasterDetailLayout> createState() => _MasterDetailLayoutState();
}

class _MasterDetailLayoutState extends State<MasterDetailLayout> {
  int _compactViewIndex = 0; // 0 = Lista / Maestro, 1 = Detalle

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDualPane = constraints.maxWidth >= widget.breakpoint;

        if (isDualPane) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: widget.masterWidth,
                child: widget.master,
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: widget.detail ??
                    widget.emptyDetailPlaceholder ??
                    _DefaultEmptyDetailPlaceholder(),
              ),
            ],
          );
        }

        // Modo responsivo para móvil / pantalla angosta (< 840dp)
        final effectiveDetail = widget.detail ??
            widget.emptyDetailPlaceholder ??
            _DefaultEmptyDetailPlaceholder();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 0,
                    icon: Icon(Icons.list_alt_rounded, size: 18),
                    label: Text('Lista'),
                  ),
                  ButtonSegment<int>(
                    value: 1,
                    icon: Icon(Icons.info_outline_rounded, size: 18),
                    label: Text('Detalle'),
                  ),
                ],
                selected: {_compactViewIndex},
                onSelectionChanged: (newSet) {
                  setState(() {
                    _compactViewIndex = newSet.first;
                  });
                },
              ),
            ),
            Expanded(
              child: _compactViewIndex == 0 ? widget.master : effectiveDetail,
            ),
          ],
        );
      },
    );
  }
}

class _DefaultEmptyDetailPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.touch_app_outlined,
            size: 56,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Selecciona un elemento para ver el detalle',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
