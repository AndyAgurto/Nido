import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/app_constants.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import '../core/security/seguridad_providers.dart';
import '../core/widgets/tablet_scaffold.dart';
import '../features/ajustes/presentation/ajustes_page.dart';
import '../features/categorias/presentation/categorias_page.dart';
import '../features/auditoria/presentation/auditoria_page.dart';
import '../features/cuentas/presentation/cuentas_page.dart';
import '../features/dashboard/presentation/dashboard_page.dart';
import '../features/gastos_fijos/presentation/gastos_fijos_page.dart';
import '../features/movimientos/presentation/movimientos_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/onboarding/presentation/onboarding_providers.dart';
import '../features/presupuesto/presentation/presupuesto_page.dart';
import '../features/proyectos/presentation/proyectos_page.dart';
import '../features/reportes/presentation/reportes_page.dart';
import '../features/seguridad/presentation/pin_lock_screen.dart';

/// Widget principal de Nido con soporte para Onboarding, Bloqueo de PIN y Modo Oscuro.
class NidoApp extends ConsumerStatefulWidget {
  const NidoApp({super.key});

  @override
  ConsumerState<NidoApp> createState() => _NidoAppState();
}

class _NidoAppState extends ConsumerState<NidoApp> with WidgetsBindingObserver {
  int _currentNavIndex = 0; // Inicia por defecto en Dashboard
  bool _fueASegundoPlano = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Al arrancar la aplicación, si tiene PIN configurado, bloqueamos por seguridad
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tienePin = await ref.read(tienePinConfiguradoProvider.future);
      if (tienePin && mounted) {
        ref.read(estaBloqueadoProvider.notifier).state = true;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _fueASegundoPlano = true;
    } else if (state == AppLifecycleState.resumed && _fueASegundoPlano) {
      _fueASegundoPlano = false;
      final tienePin = ref.read(tienePinConfiguradoProvider).value ?? false;
      if (tienePin) {
        ref.read(estaBloqueadoProvider.notifier).state = true;
      }
    }
  }

  static const List<String> _sectionTitles = [
    'Dashboard',
    'Cuentas y Bolsillos',
    'Movimientos',
    'Gastos e Ingresos Fijos',
    'Presupuesto Mensual',
    'Proyectos del Hogar',
    'Reportes Financieros',
    'Bitácora de Auditoría',
    'Categorías del Hogar',
    'Ajustes del Sistema',
  ];

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 0:
        return const DashboardPage();
      case 1:
        return const CuentasPage();
      case 2:
        return const MovimientosPage();
      case 3:
        return const GastosFijosPage();
      case 4:
        return const PresupuestoPage();
      case 5:
        return const ProyectosPage();
      case 6:
        return const ReportesPage();
      case 7:
        return const AuditoriaPage();
      case 8:
        return const CategoriasPage();
      case 9:
        return const AjustesPage();
      default:
        return _BaseTabletContent(
          title: _sectionTitles[_currentNavIndex],
          sectionIndex: _currentNavIndex,
        );
    }
  }

  Widget _buildHome(bool estaBloqueado, bool onboardingCompletado) {
    if (!onboardingCompletado) {
      return OnboardingPage(
        onCompletado: () {
          ref.invalidate(onboardingCompletadoProvider);
        },
      );
    }

    if (estaBloqueado) {
      return const PinLockScreen();
    }

    return TabletScaffold(
      selectedIndex: _currentNavIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentNavIndex = index;
        });
      },
      body: _buildBody(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estaBloqueado = ref.watch(estaBloqueadoProvider);
    final onboardingAsync = ref.watch(onboardingCompletadoProvider);
    final themeMode = ref.watch(themeModeProvider);

    // Si aún está resolviendo el futuro o es true, asumimos completado para evitar flash
    final onboardingCompletado = onboardingAsync.value ?? true;

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        // Evita que la configuración de fuentes gigantes del sistema deforme botones y textos
        final clampedScaler = mediaQuery.textScaler.clamp(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.0,
        );
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedScaler),
          child: child!,
        );
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'PE'),
        Locale('es'),
      ],
      locale: const Locale('es', 'PE'),
      home: _buildHome(estaBloqueado, onboardingCompletado),
    );
  }
}

class _BaseTabletContent extends StatelessWidget {
  const _BaseTabletContent({
    required this.title,
    required this.sectionIndex,
  });

  final String title;
  final int sectionIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Sección "$title"',
          style: theme.textTheme.bodyLarge,
        ),
      ),
    );
  }
}
