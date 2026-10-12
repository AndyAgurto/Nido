import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/security/seguridad_providers.dart';

/// Pantalla de desbloqueo mediante PIN y Biometría.
/// Cumple con las pautas de accesibilidad para tablets (touch targets >= 48dp).
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

    // Intentar autenticación biométrica automática al mostrar la pantalla si está habilitada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _intentarBiometriaAutomatica();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _intentarBiometriaAutomatica() async {
    final biometriaActiva = await ref.read(biometriaActivaProvider.future);
    if (!mounted || !biometriaActiva) return;

    final exito = await ref.read(seguridadServiceProvider).autenticarBiometrico();
    if (exito && mounted) {
      _desbloquear();
    }
  }

  void _onNumeroPresionado(String digito) {
    if (_estaValidando || _pin.length >= 6) return;

    setState(() {
      _errorMensaje = null;
      _pin += digito;
    });

    HapticFeedback.lightImpact();

    // Si alcanza 4 a 6 dígitos, permitimos validar automáticamente si llega a 6,
    // o el usuario puede presionar enter/validar. Por defecto, validamos al ingresar 4 o 6.
    if (_pin.length == 4 || _pin.length == 6) {
      _verificarPin();
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

  Future<void> _verificarPin() async {
    if (_pin.isEmpty) return;

    setState(() {
      _estaValidando = true;
    });

    final service = ref.read(seguridadServiceProvider);
    final esValido = await service.validarPin(_pin);

    if (!mounted) return;

    if (esValido) {
      _desbloquear();
    } else {
      // Si con 4 falló pero aún no llegó a 6, permitimos continuar escribiendo
      if (_pin.length == 4) {
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
    ref.read(estaBloqueadoProvider.notifier).state = false;
    widget.onDesbloqueado?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final biometriaActivaAsync = ref.watch(biometriaActivaProvider);
    final biometriaActiva = biometriaActivaAsync.value ?? false;

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
                  // Logo de Nido con borde
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
                    'Ingresa tu PIN de seguridad local para desbloquear',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Indicadores visuales de dígitos con animación shake
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
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: estaLleno
                                ? AppColors.primary
                                : theme.colorScheme.surfaceContainerHighest,
                            border: Border.all(
                              color: estaLleno
                                  ? AppColors.primary
                                  : theme.colorScheme.outline.withValues(alpha: 0.5),
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

                  // Teclado numérico 3x4
                  _buildTecladoNumerico(theme, biometriaActiva),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildTecladoNumerico(ThemeData theme, bool biometriaActiva) {
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
        // Fila inferior: Biometría / 0 / Borrar
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (biometriaActiva)
                _buildBotonEspecial(
                  icono: Icons.fingerprint_rounded,
                  tooltip: 'Autenticación Biométrica',
                  onTap: _intentarBiometriaAutomatica,
                  theme: theme,
                )
              else
                const SizedBox(width: 72, height: 72),
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
    required VoidCallback onTap,
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
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}