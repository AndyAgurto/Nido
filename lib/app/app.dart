import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constants/app_constants.dart';
import 'theme/app_theme.dart';
import '../core/widgets/tablet_scaffold.dart';
import '../features/cuentas/presentation/cuentas_page.dart';
import '../features/movimientos/presentation/movimientos_page.dart';
import '../features/gastos_fijos/presentation/gastos_fijos_page.dart';
import '../features/presupuesto/presentation/presupuesto_page.dart';
import '../features/proyectos/presentation/proyectos_page.dart';

/// Widget principal de Nido.
class NidoApp extends StatefulWidget {
  const NidoApp({super.key});

  @override
  State<NidoApp> createState() => _NidoAppState();
}

class _NidoAppState extends State<NidoApp> {
  int _currentNavIndex = 0; // Inicia por defecto en Cuentas (Fase 2)

  static const List<String> _sectionTitles = [
    'Dashboard',
    'Cuentas y Bolsillos',
    'Movimientos',
    'Gastos e Ingresos Fijos',
    'Presupuesto Mensual',
    'Proyectos del Hogar',
    'Reportes Financieros',
    'Bitácora de Auditoría',
    'Ajustes del Sistema',
  ];

  Widget _buildBody() {
    switch (_currentNavIndex) {
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
      default:
        return _BaseTabletContent(
          title: _sectionTitles[_currentNavIndex],
          sectionIndex: _currentNavIndex,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
      home: TabletScaffold(
        selectedIndex: _currentNavIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        body: _buildBody(),
      ),
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 16,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  'Modo 100% Local',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.foundation_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppConstants.appSlogan,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Sección "$title": Módulo preparado para próximas fases',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}