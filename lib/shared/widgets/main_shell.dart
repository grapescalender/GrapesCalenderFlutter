import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/router/app_router.dart';

/// Main shell widget that provides bottom navigation
class MainShell extends StatelessWidget {
  const MainShell({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigation(context, currentLocation),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, String currentLocation) {
    final cs = Theme.of(context).colorScheme;
    return NavigationBar(
      selectedIndex: _getSelectedIndex(currentLocation),
      onDestinationSelected: (index) => _onItemTapped(context, index),
      backgroundColor: cs.surface,
      indicatorColor: cs.primaryContainer,
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.agriculture_outlined),
          selectedIcon: Icon(Icons.agriculture_rounded),
          label: 'Plots',
        ),
        NavigationDestination(
          icon: Icon(Icons.trending_up_outlined),
          selectedIcon: Icon(Icons.trending_up_rounded),
          label: 'Market',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2_rounded),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getSelectedIndex(String currentLocation) {
    switch (currentLocation) {
      case AppRoutes.home:
        return 0;
      case AppRoutes.plots:
        return 1;
      case AppRoutes.market:
        return 2;
      case AppRoutes.products:
        return 3;
      case AppRoutes.profile:
        return 4;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.plots);
        break;
      case 2:
        context.go(AppRoutes.market);
        break;
      case 3:
        context.go(AppRoutes.products);
        break;
      case 4:
        context.go(AppRoutes.profile);
        break;
    }
  }
}
