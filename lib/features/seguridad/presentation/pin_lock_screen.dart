import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/security/seguridad_providers.dart';

/// Pantalla de desbloqueo exclusivo mediante PIN (4 a 6 dígitos).
/// Mobile-First, altamente accesible (touch targets >= 48dp) y sin biometría.
class PinLockScreen extends ConsumerStatefulWidget {
  const PinLockScreen({
    super.key,
    this.onDesbloqueado,
  });

  final VoidCallback? onDesbloqueado;

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen>
    with SingleTickerProviderStateMixin {
  String _pin = '';
  String? _errorMensaje;
  bool _estaValidando = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumeroPresionado(String digito) {
    if (_estaValidando || _pin.length >= 6) return;

    setState(() {
      _errorMensaje = null;
      _pin += digito;
    });

    HapticFeedback.lightImpact();

    // Verificación inteligente: si tiene entre 4 y 6 dígitos, probamos si coincide
    if (_pin.length >= 4) {
      _verificarPin(silencioso: _pin.length < 6);
    }
  }

  void _onBorrarPresionado() {
    if (_pin.isEmpty || _estaValidando) return;
    setState(() {
      _errorMensaje = null;
      _pin = _pin.substring(0, _pin.length - 1);
    });
    HapticFeedback.selectionClick();
  }

  Future<void> _verificarPin({bool silencioso = false}) async {
    if (_pin.length < 4) {
      if (!silencioso) {
        setState(() {
          _errorMensaje = 'El PIN debe tener al menos 4 dígitos.';
        });
      }
      return;
    }

    setState(() {
      _estaValidando = true;
    });

    final service = ref.read(seguridadServiceProvider);
    final esValido = await service.validarPin(_pin);

    if (!mounted) return;

    if (esValido) {
      _desbloquear();
    } else {
      if (silencioso && _pin.length < 6) {
        // Permitir seguir escribiendo sin mostrar error aún
        setState(() {
          _estaValidando = false;
        });
        return;
      }

      HapticFeedback.heavyImpact();
      _shakeController.forward(from: 0);
      setState(() {
        _errorMensaje = 'PIN incorrecto. Inténtalo de nuevo.';
        _pin = '';
        _estaValidando = false;
      });
    }
  }

  void _desbloquear() {
    HapticFeedback.mediumImpact();
    ref.read(estaBloqueadoProvider.notifier).state = false;
    widget.onDesbloqueado?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo oficial de Nido
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.lock_rounded,
                          color: AppColors.primary,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Nido Protegido',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      'Ingresa tu PIN de seguridad (4 a 6 dígitos)',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Indicadores visuales de dígitos con animación shake (hasta 6 círculos)
                    AnimatedBuilder(
                      animation: _shakeController,
                      builder: (context, child) {
                        final offset = (_shakeController.value > 0)
                            ? (1 - _shakeController.value) *
                                10 *
                                ((_shakeController.value * 20 % 2 == 0) ? 1 : -1)
                            : 0.0;
                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          final estaLleno = index < _pin.length;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: estaLleno
                                  ? AppColors.primary
                                  : theme.colorScheme.surfaceContainerHighest,
                              border: Border.all(
                                color: estaLleno
                                    ? AppColors.primary
                                    : theme.colorScheme.outline.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Mensaje de error
                    if (_errorMensaje != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Text(
                          _errorMensaje!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 20),

                    // Teclado numérico 3x4 accesible
                    _buildTecladoNumerico(theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTecladoNumerico(ThemeData theme) {
    final puedeConfirmar = _pin.length >= 4;

    return Column(
      children: [
        for (var row = 0; row < 3; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var col = 1; col <= 3; col++)
                  _buildBotonKeypad(
                    texto: '${row * 3 + col}',
                    onTap: () => _onNumeroPresionado('${row * 3 + col}'),
                    theme: theme,
                  ),
              ],
            ),
          ),
        // Fila inferior: Confirmar / 0 / Borrar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Botón de confirmar PIN
              _buildBotonEspecial(
                icono: Icons.check_circle_rounded,
                tooltip: 'Desbloquear',
                onTap: puedeConfirmar ? () => _verificarPin(silencioso: false) : null,
                colorIcono: puedeConfirmar ? AppColors.primary : theme.colorScheme.outlineVariant,
                theme: theme,
              ),
              _buildBotonKeypad(
                texto: '0',
                onTap: () => _onNumeroPresionado('0'),
                theme: theme,
              ),
              _buildBotonEspecial(
                icono: Icons.backspace_outlined,
                tooltip: 'Borrar',
                onTap: _onBorrarPresionado,
                theme: theme,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBotonKeypad({
    required String texto,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              texto,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBotonEspecial({
    required IconData icono,
    required String tooltip,
    required VoidCallback? onTap,
    Color? colorIcono,
    required ThemeData theme,
  }) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Icon(
                icono,
                size: 30,
                color: colorIcono ?? theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
