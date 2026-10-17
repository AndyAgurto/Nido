import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

/// Componente visual reutilizable para estados vacíos (Empty States).
/// Diseñado con accesibilidad WCAG (contrastes, Semantics, touch targets >= 48dp)
/// y adaptado para tablets y pantallas móviles.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.actionIcon,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Semantics(
            container: true,
            label: '$title. $description',
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Contenedor suave para el icono
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primaryContainer.withValues(alpha: 0.15)
                        : AppColors.primaryContainer.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withValues(
                        alpha: isDark ? 0.4 : 0.2,
                      ),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: isDark ? AppColors.primaryDark : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),

                // Título
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 8),

                // Descripción
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                // Botón de acción opcional
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(180, 48), // Touch target >= 48dp
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: onAction,
                    icon: actionIcon != null
                        ? Icon(actionIcon, size: 20)
                        : const SizedBox.shrink(),
                    label: Text(
                      actionLabel!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
