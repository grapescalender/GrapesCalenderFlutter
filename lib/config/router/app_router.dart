import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/schedule/presentation/pages/related_schedule_page.dart';
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../features/schedule/presentation/pages/view_all_schedule_page.dart';
import '../../features/activity/presentation/pages/activity_page.dart';
import '../../features/activity/presentation/pages/view_all_activities_page.dart';

/// Route names for navigation
class RouteNames {
  static const String login = '/login';
  static const String home = '/home';
  static const String schedule = '/schedule';
  static const String viewAllSchedules = '/schedules/all';
  static const String relatedSchedules = '/schedules/related';
  static const String viewAllActivities = '/activities/all';
  static const String activity = '/activity';
  static const String profile = '/profile';
  static const String reports = '/reports';
}

/// App Routes - Alias for RouteNames for convenience
class AppRoutes {
  static const String login = RouteNames.login;
  static const String home = RouteNames.home;
  static const String schedule = RouteNames.schedule;
  static const String viewAllSchedules = RouteNames.viewAllSchedules;
  static const String relatedSchedules = RouteNames.relatedSchedules;
  static const String viewAllActivities = RouteNames.viewAllActivities;
  static const String activity = RouteNames.activity;
  static const String profile = RouteNames.profile;
  static const String reports = RouteNames.reports;
}

/// Go Router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    // Authentication routes
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
      name: 'login',
    ),

    // Main app routes with shell navigation
    ShellRoute(
      builder: (context, state, child) {
        // This will be the bottom navigation shell
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) => const HomePage(),
          name: 'home',
        ),
        GoRoute(
          path: RouteNames.schedule,
          builder: (context, state) => const SchedulePage(),
          name: 'schedule',
        ),
        GoRoute(
          path: RouteNames.viewAllSchedules,
          builder: (context, state) => const ViewAllSchedulePage(),
          name: 'viewAllSchedules',
        ),
        GoRoute(
          path: RouteNames.relatedSchedules,
          builder: (context, state) => const RelatedSchedulePage(),
          name: 'relatedSchedules',
        ),
        GoRoute(
          path: RouteNames.viewAllActivities,
          builder: (context, state) => const ViewAllActivitiesPage(),
          name: 'viewAllActivities',
        ),
        GoRoute(
          path: RouteNames.activity,
          builder: (context, state) => const ActivityPage(),
          name: 'activity',
        ),
        GoRoute(
          path: RouteNames.profile,
          builder: (context, state) => const ProfilePage(),
          name: 'profile',
        ),
      ],
    ),
  ],
);

/// Main shell widget with bottom navigation
class MainShell extends StatelessWidget {

  const MainShell({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
      body: child,
      bottomNavigationBar: _MainBottomNav(),
    );
}

/// Bottom navigation bar widget
/// Separated to avoid context access issues
class _MainBottomNav extends StatelessWidget {
  const _MainBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // Use GoRouterState to get current location safely
    // Wrap in try-catch to handle any router state access issues
    var currentLocation = RouteNames.home;
    try {
      final routerState = GoRouterState.of(context);
      currentLocation = routerState.uri.path;
    } catch (e) {
      // Fallback to home if router state is not available
      currentLocation = RouteNames.home;
    }

    return BottomNavigationBar(
      key: const ValueKey('main_bottom_nav'),
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
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment),
          label: 'Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getSelectedIndex(String currentLocation) {
    if (currentLocation == RouteNames.home) return 0;
    if (currentLocation == RouteNames.schedule) return 1;
    if (currentLocation == RouteNames.activity) return 2;
    if (currentLocation == RouteNames.profile) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    if (!context.mounted) return;
    
    final router = GoRouter.of(context);
    switch (index) {
      case 0:
        router.go(RouteNames.home);
        break;
      case 1:
        router.go(RouteNames.schedule);
        break;
      case 2:
        router.go(RouteNames.activity);
        break;
      case 3:
        router.go(RouteNames.profile);
        break;
    }
  }
}
