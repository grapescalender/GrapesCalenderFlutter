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

  Widget _buildBottomNavigation(BuildContext context, String currentLocation) => BottomNavigationBar(
      currentIndex: _getSelectedIndex(currentLocation),
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Schedule',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );

  int _getSelectedIndex(String currentLocation) {
    switch (currentLocation) {
      case AppRoutes.home:
        return 0;
      case AppRoutes.schedule:
        return 1;
      case AppRoutes.activity:
        return 2;
      case AppRoutes.profile:
        return 3;
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
        context.go(AppRoutes.schedule);
        break;
      case 2:
        context.go(AppRoutes.activity);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}
