import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/providers/database_providers.dart';
import '../data/demo_data_service.dart';
import 'onboarding_providers.dart';

/// Flujo guiado de bienvenida (Onboarding) en 3 pasos.
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({
    super.key,
    this.onCompletado,
  });

  final VoidCallback? onCompletado;

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _pasoActual = 0;
  bool _estaCargandoDemo = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finalizarOnboarding() async {
    final db = ref.read(databaseProvider);
    await db.ajustesDao.setValor('onboarding_completado', 'true');
    ref.invalidate(onboardingCompletadoProvider);

    widget.onCompletado?.call();
  }

  Future<void> _cargarDemoYFinalizar() async {
    setState(() => _estaCargandoDemo = true);
    try {
      final db = ref.read(databaseProvider);
      final writer = ref.read(auditedWriterProvider);

      await DemoDataService.cargarDatosDemo(db: db, writer: writer);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Datos familiares de prueba cargados con éxito!'),
          backgroundColor: AppColors.income,
        ),
      );

      await _finalizarOnboarding();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar datos demo: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _estaCargandoDemo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 720;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 20.0 : 40.0,
                vertical: 24.0,
              ),
              child: Column(
                children: [
                  // Barra superior: Indicador de pasos y botón Saltar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indicadores de puntos
                      Row(
                        children: List.generate(3, (index) {
                          final activo = index == _pasoActual;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 8),
                            width: activo ? 28 : 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: activo
                                  ? AppColors.primary
                                  : theme.colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          );
                        }),
                      ),
                      if (_pasoActual < 2)
                        TextButton(
                          onPressed: _finalizarOnboarding,
                          child: const Text('Saltar introducción'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contenido deslizable de los 3 pasos
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (idx) => setState(() => _pasoActual = idx),
                      children: [
                        _buildPaso1(theme, isCompact),
                        _buildPaso2(theme, isCompact),
                        _buildPaso3(theme, isCompact),
                      ],
                    ),
                  ),

                  // Barra inferior: Navegación Anterior / Siguiente
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_pasoActual > 0)
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(120, 48),
                            ),
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text('Anterior'),
                          )
                        else
                          const SizedBox(width: 120),

                        FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(140, 48),
                          ),
                          onPressed: _estaCargandoDemo
                              ? null
                              : () {
                                  if (_pasoActual < 2) {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    _finalizarOnboarding();
                                  }
                                },
                          child: Text(
                            _pasoActual == 2 ? 'Comenzar' : 'Siguiente',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaso1(ThemeData theme, bool isCompact) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: isCompact ? 96 : 120,
            height: isCompact ? 96 : 120,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(
                Icons.home_rounded,
                size: 64,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            AppConstants.appName,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '¡Bienvenido a tu hogar financiero!',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            AppConstants.appSlogan,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Una plataforma de finanzas del hogar profesional, concebida para la tablet familiar. Privada, soberana y 100% local.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          _buildTarjetaPilar(
            icon: Icons.shield_outlined,
            title: '100% Local y Confidencial',
            description: 'Tus datos nunca viajan por internet. Sin servidores, sin publicidad ni telemetría.',
            theme: theme,
          ),
          const SizedBox(height: 12),

          _buildTarjetaPilar(
            icon: Icons.currency_exchange_rounded,
            title: 'Moneda Peruana (PEN)',
            description: 'Contabilidad rigurosa en Soles con manejo exacto de céntimos en enteros.',
            theme: theme,
          ),
          const SizedBox(height: 12),

          _buildTarjetaPilar(
            icon: Icons.table_restaurant_rounded,
            title: 'Diseño para Tablet y Móvil',
            description: 'Navegación nativa Master-Detail para tablets y experiencia adaptativa en teléfonos.',
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildPaso2(ThemeData theme, bool isCompact) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 54,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Comienza a tu ritmo',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Puedes iniciar con una base limpia o cargar datos de prueba para explorar los gráficos y módulos de inmediato.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),

          // Opción 1: Datos Demo
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.dataset_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cargar Datos Familiares (Recomendado)',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Incluye cuentas bancarias (BCP, Interbank, Yape), sueldos, servicios del hogar, presupuestos y un proyecto de remodelación.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: _estaCargandoDemo ? null : _cargarDemoYFinalizar,
                    icon: _estaCargandoDemo
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.flash_on_rounded),
                    label: Text(_estaCargandoDemo ? 'Cargando datos...' : 'Cargar Datos Demo y Comenzar'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Opción 2: Base limpia
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.note_add_outlined),
              ),
              title: const Text('Empezar con Base Limpia'),
              subtitle: const Text('Configura tus cuentas y presupuestos desde cero sin datos precargados.'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaso3(ThemeData theme, bool isCompact) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.income.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_person_rounded,
              size: 54,
              color: AppColors.income,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Tu seguridad está en tus manos',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Nido cuenta con herramientas integradas de protección y respaldo seguro.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),

          _buildTarjetaPilar(
            icon: Icons.pin_drop_rounded,
            title: 'PIN y Biometría Local',
            description: 'Protege la app con código numérico y sensor de huella. Al salir a segundo plano, Nido se bloquea automáticamente.',
            theme: theme,
          ),
          const SizedBox(height: 12),

          _buildTarjetaPilar(
            icon: Icons.archive_outlined,
            title: 'Respaldos Portátiles en ZIP',
            description: 'Exporta toda tu información (base de datos y fotos) en un paquete .zip cuando quieras para llevarlo a un pendrive o tarjeta SD.',
            theme: theme,
          ),
          const SizedBox(height: 12),

          _buildTarjetaPilar(
            icon: Icons.history_edu_rounded,
            title: 'Bitácora Inmutable de Auditoría',
            description: 'Cada ingreso, gasto o transferencia queda registrado con visor antes/después para máxima transparencia familiar.',
            theme: theme,
          ),
          const SizedBox(height: 24),

          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: _finalizarOnboarding,
            icon: const Icon(Icons.check_circle_rounded),
            label: const Text(
              '¡Todo Listo! Entrar a Nido',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaPilar({
    required IconData icon,
    required String title,
    required String description,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
