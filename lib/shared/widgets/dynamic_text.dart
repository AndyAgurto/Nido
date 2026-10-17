import 'package:flutter/material.dart';

/// Widget que permite visualizar textos largos (títulos, descripciones o identificadores)
/// de forma dinámica sin truncados molestos ni desbordes (RenderFlex overflow).
/// Si el texto sobrepasa el ancho, permite scroll horizontal fluido y sutil.
class DynamicScrollText extends StatelessWidget {
  const DynamicScrollText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.autoScale = false,
    this.physics = const BouncingScrollPhysics(),
  });

  final String text;
  final TextStyle? style;
  final int maxLines;
  final bool autoScale;
  final ScrollPhysics physics;

  @override
  Widget build(BuildContext context) {
    if (autoScale) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(text, style: style, maxLines: maxLines),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: physics,
      child: Text(
        text,
        style: style,
        maxLines: maxLines,
      ),
    );
  }
}

/// Título dinámico que escala hacia abajo si es necesario y permite scroll horizontal
/// si la descripción o nombre sobrepasa el espacio disponible.
class DynamicTitle extends StatelessWidget {
  const DynamicTitle(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Text(
              text,
              style: style,
              maxLines: maxLines,
            ),
          ),
        );
      },
    );
  }
}

/// Botón con texto dinámico adaptable para evitar desbordes en móviles y tablets.
class DynamicButton extends StatelessWidget {
  const DynamicButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isFilled = true,
    this.isTonal = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isFilled;
  final bool isTonal;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label),
          ),
        ),
      ],
    );

    if (!isFilled) {
      return OutlinedButton(
        onPressed: onPressed,
        child: child,
      );
    }

    if (isTonal) {
      return FilledButton.tonal(
        onPressed: onPressed,
        child: child,
      );
    }

    return FilledButton(
      onPressed: onPressed,
      child: child,
    );
  }
}

/// Campo de búsqueda dinámico adaptable para pantallas móviles y tablets.
/// Maneja scroll horizontal nativo del texto, botón de limpieza rápida y altura compacta.
class DynamicSearchField extends StatelessWidget {
  const DynamicSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Buscar...',
    this.prefixIcon = Icons.search_rounded,
    this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final IconData prefixIcon;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;

        return TextField(
          controller: controller,
          onChanged: onChanged,
          scrollPhysics: const BouncingScrollPhysics(),
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            prefixIcon: Icon(prefixIcon, size: 20),
            suffixIcon: hasText
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    tooltip: 'Limpiar búsqueda',
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                      onClear?.call();
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
    );
  }
}
