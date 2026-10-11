import 'package:flutter/material.dart';
import '../../app/constants/app_constants.dart';

/// Layout adaptable de dos paneles (Maestro - Detalle) optimizado para Tablet.
/// Si el ancho disponible es >= 840dp se muestran ambos paneles lado a lado.
/// Si es menor, se muestra el panel seleccionado con transición responsiva.
class MasterDetailLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDualPane = constraints.maxWidth >= breakpoint;

        if (isDualPane) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: masterWidth,
                child: master,
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: detail ??
                    emptyDetailPlaceholder ??
                    _DefaultEmptyDetailPlaceholder(),
              ),
            ],
          );
        }

        // Modo pantalla angosta / teléfono o split reducido:
        // Si hay detalle se muestra el detalle, si no, el maestro.
        return detail ?? master;
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
