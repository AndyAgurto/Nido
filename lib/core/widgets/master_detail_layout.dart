import 'package:flutter/material.dart';
import '../../app/constants/app_constants.dart';

/// Layout responsivo Mobile-First con adaptación dual para tablets (Maestro - Detalle).
/// - En Móvil (< 840dp): Prioriza la navegación fluida con lista y detalle individuales,
///   con selector segmentado y botón rápido "Volver a la lista" para navegación a una sola mano.
/// - En Tablet (>= 840dp): Muestra ambos paneles en paralelo con división vertical sutil.
class MasterDetailLayout extends StatefulWidget {
  const MasterDetailLayout({
    super.key,
    required this.master,
    required this.detail,
    this.masterWidth = 380.0,
    this.breakpoint = AppConstants.tabletBreakpoint,
    this.emptyDetailPlaceholder,
    this.initialMobileIndex = 0,
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

  /// Índice inicial en vista móvil (0 = Lista, 1 = Detalle)
  final int initialMobileIndex;

  @override
  State<MasterDetailLayout> createState() => _MasterDetailLayoutState();
}

class _MasterDetailLayoutState extends State<MasterDetailLayout> {
  late int _compactViewIndex;

  @override
  void initState() {
    super.initState();
    _compactViewIndex = widget.initialMobileIndex;
  }

  void setCompactIndex(int index) {
    if (mounted && _compactViewIndex != index) {
      setState(() => _compactViewIndex = index);
    }
  }

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

        // ==========================================
        // MODO PRIORITARIO MÓVIL (< 840dp)
        // ==========================================
        final effectiveDetail = widget.detail ??
            widget.emptyDetailPlaceholder ??
            _DefaultEmptyDetailPlaceholder();

        return Column(
          children: [
            // Barra de alternancia móvil accesible
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
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
            ),

            // Botón de retorno móvil cuando se está viendo el detalle
            if (_compactViewIndex == 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  onPressed: () => setState(() => _compactViewIndex = 0),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text(
                    'Volver a la lista',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _compactViewIndex == 0
                    ? KeyedSubtree(
                        key: const ValueKey('master_view'),
                        child: widget.master,
                      )
                    : KeyedSubtree(
                        key: const ValueKey('detail_view'),
                        child: effectiveDetail,
                      ),
              ),
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
