import 'package:flutter/material.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';

/// Estructura base nativa para Tablet (diseño primario con NavigationRail lateral)
/// con adaptación responsiva fluida para pantallas móviles (< 720dp).
class TabletScaffold extends StatelessWidget {
  const TabletScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.floatingActionButton,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;
  final Widget? floatingActionButton;

  static const List<_NavDestinationData> _destinos = [
    _NavDestinationData(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
    ),
    _NavDestinationData(
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet_rounded,
      label: 'Cuentas',
    ),
    _NavDestinationData(
      icon: Icons.swap_horiz_outlined,
      selectedIcon: Icons.swap_horiz_rounded,
      label: 'Movimientos',
    ),
    _NavDestinationData(
      icon: Icons.event_repeat_outlined,
      selectedIcon: Icons.event_repeat_rounded,
      label: 'Gastos Fijos',
    ),
    _NavDestinationData(
      icon: Icons.pie_chart_outline_rounded,
      selectedIcon: Icons.pie_chart_rounded,
      label: 'Presupuesto',
    ),
    _NavDestinationData(
      icon: Icons.handyman_outlined,
      selectedIcon: Icons.handyman_rounded,
      label: 'Proyectos',
    ),
    _NavDestinationData(
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart_rounded,
      label: 'Reportes',
    ),
    _NavDestinationData(
      icon: Icons.history_edu_outlined,
      selectedIcon: Icons.history_edu_rounded,
      label: 'Auditoría',
    ),
    _NavDestinationData(
      icon: Icons.category_outlined,
      selectedIcon: Icons.category_rounded,
      label: 'Categorías',
    ),
    _NavDestinationData(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      label: 'Ajustes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 720;
    final isWideTablet = screenWidth >= AppConstants.tabletBreakpoint;

    if (isMobile) {
      return _buildMobileScaffold(context, theme);
    }

    return _buildTabletScaffold(context, theme, isWideTablet);
  }

  /// Vista Nativa Primaria para Tablet con NavigationRail lateral
  Widget _buildTabletScaffold(BuildContext context, ThemeData theme, bool isWideTablet) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: isWideTablet
                ? NavigationRailLabelType.all
                : NavigationRailLabelType.selected,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.home_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Tooltip(
                    message: AppConstants.appPrivacyNotice,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          if (isWideTablet) ...[
                            const SizedBox(width: 4),
                            Text(
                              '100% Local',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            destinations: _destinos
                .map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }

  /// Adaptación Responsiva para Pantallas Móviles (< 720dp)
  Widget _buildMobileScaffold(BuildContext context, ThemeData theme) {
    final activeDestination = _destinos[selectedIndex];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.home_rounded, size: 22, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                activeDestination.label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        actions: [
          Tooltip(
            message: '100% Local - Datos soberanos en tu dispositivo',
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_rounded, size: 13, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Local',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: _buildMobileDrawer(context, theme),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getMobileNavBarIndex(),
        onDestinationSelected: (navIndex) {
          if (navIndex < 4) {
            final targetIndices = [0, 1, 2, 4];
            onDestinationSelected(targetIndices[navIndex]);
          } else {
            // El 5to botón "Más" abre el menú Drawer completo
            Scaffold.of(context).openDrawer();
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Cuentas',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz_rounded),
            label: 'Movimientos',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline_rounded),
            selectedIcon: Icon(Icons.pie_chart_rounded),
            label: 'Presupuesto',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_rounded),
            selectedIcon: Icon(Icons.menu_open_rounded),
            label: 'Más...',
          ),
        ],
      ),
    );
  }

  int _getMobileNavBarIndex() {
    switch (selectedIndex) {
      case 0:
        return 0; // Dashboard
      case 1:
        return 1; // Cuentas
      case 2:
        return 2; // Movimientos
      case 4:
        return 3; // Presupuesto
      default:
        return 4; // "Más" para los otros módulos
    }
  }

  Widget _buildMobileDrawer(BuildContext context, ThemeData theme) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.home_rounded, color: AppColors.primary, size: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        AppConstants.appSlogan,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: _destinos.length,
                itemBuilder: (ctx, idx) {
                  final d = _destinos[idx];
                  final isSelected = selectedIndex == idx;
                  return ListTile(
                    selected: isSelected,
                    leading: Icon(isSelected ? d.selectedIcon : d.icon),
                    title: Text(
                      d.label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      onDestinationSelected(idx);
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nido: 100% Local, Privado y Soberano.',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavDestinationData {
  const _NavDestinationData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
