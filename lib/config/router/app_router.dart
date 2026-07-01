import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/entities/onboarding_routing_state.dart';
import '../../features/auth/domain/usecases/onboarding_route_resolver.dart';
import '../../features/auth/presentation/pages/app_launch_page.dart';
import '../../features/auth/presentation/pages/farmer_registration_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/domain/services/auth_service.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/market_page.dart';
import '../../features/home/presentation/pages/plots_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/schedule/presentation/pages/related_schedule_page.dart';
import '../../features/schedule/presentation/pages/schedule_page.dart';
import '../../features/schedule/presentation/pages/view_all_schedule_page.dart';
import '../../features/activity/presentation/pages/activity_page.dart';
import '../../features/activity/presentation/pages/view_all_activities_page.dart';
import '../../features/products/presentation/pages/product_knowledge_page.dart';

/// Route names for navigation
class RouteNames {
  static const String launch = '/launch';
  static const String login = '/login';
  static const String farmerRegistration = '/register/farmer';
  static const String profileSetup = '/onboarding/profile';
  static const String plotSetup = '/onboarding/plots';
  static const String seasonSetup = '/onboarding/season';
  static const String home = '/home';
  static const String plots = '/plots';
  static const String market = '/market';
  static const String schedule = '/schedule';
  static const String viewAllSchedules = '/schedules/all';
  static const String relatedSchedules = '/schedules/related';
  static const String viewAllActivities = '/activities/all';
  static const String activity = '/activity';
  static const String products = '/products';
  static const String profile = '/profile';
  static const String reports = '/reports';
}

/// App Routes - Alias for RouteNames for convenience
class AppRoutes {
  static const String launch = RouteNames.launch;
  static const String login = RouteNames.login;
  static const String farmerRegistration = RouteNames.farmerRegistration;
  static const String home = RouteNames.home;
  static const String plots = RouteNames.plots;
  static const String market = RouteNames.market;
  static const String schedule = RouteNames.schedule;
  static const String viewAllSchedules = RouteNames.viewAllSchedules;
  static const String relatedSchedules = RouteNames.relatedSchedules;
  static const String viewAllActivities = RouteNames.viewAllActivities;
  static const String activity = RouteNames.activity;
  static const String products = RouteNames.products;
  static const String profile = RouteNames.profile;
  static const String reports = RouteNames.reports;
}

/// Go Router configuration
GoRouter createAppRouter(AuthService authService) {
  final onboardingResolver = OnboardingRouteResolver(
    authService: authService,
  );

  return GoRouter(
    initialLocation: RouteNames.launch,
    redirect: (context, state) async {
      final path = state.uri.path;
      final onboardingState = await onboardingResolver.resolve();

      if (onboardingState == OnboardingRoutingState.unauthenticated) {
        return path == RouteNames.login || path == RouteNames.farmerRegistration
            ? null
            : RouteNames.login;
      }

      final requiredPath = switch (onboardingState) {
        OnboardingRoutingState.unauthenticated => RouteNames.login,
        OnboardingRoutingState.profilePending => RouteNames.profileSetup,
        OnboardingRoutingState.plotPending => RouteNames.plotSetup,
        OnboardingRoutingState.seasonPending => RouteNames.seasonSetup,
        OnboardingRoutingState.completed => RouteNames.home,
      };
      final onboardingPaths = {
        RouteNames.farmerRegistration,
        RouteNames.profileSetup,
        RouteNames.plotSetup,
        RouteNames.seasonSetup,
      };

      if (onboardingState != OnboardingRoutingState.completed) {
        return path == requiredPath ? null : requiredPath;
      }

      if (path == RouteNames.launch ||
          path == RouteNames.login ||
          onboardingPaths.contains(path)) {
        return RouteNames.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.launch,
        builder: (context, state) => const AppLaunchPage(),
        name: 'launch',
      ),
      // Authentication routes
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
        name: 'login',
      ),
      GoRoute(
        path: RouteNames.farmerRegistration,
        builder: (context, state) => const FarmerRegistrationPage(),
        name: 'farmerRegistration',
      ),
      GoRoute(
        path: RouteNames.profileSetup,
        builder: (context, state) => const FarmerRegistrationPage(),
        name: 'profileSetup',
      ),
      GoRoute(
        path: RouteNames.plotSetup,
        builder: (context, state) => const FarmerRegistrationPage(),
        name: 'plotSetup',
      ),
      GoRoute(
        path: RouteNames.seasonSetup,
        builder: (context, state) => const FarmerRegistrationPage(),
        name: 'seasonSetup',
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
            path: RouteNames.plots,
            builder: (context, state) => const PlotsPage(),
            name: 'plots',
          ),
          GoRoute(
            path: RouteNames.market,
            builder: (context, state) => const MarketPage(),
            name: 'market',
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
            path: RouteNames.products,
            builder: (context, state) => const ProductKnowledgePage(),
            name: 'products',
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
}

/// Main shell widget with bottom navigation
class MainShell extends StatelessWidget {
  const MainShell({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: child,
        bottomNavigationBar: const _MainBottomNav(),
      );
}

/// Bottom navigation bar widget
/// Separated to avoid context access issues
class _MainBottomNav extends StatelessWidget {
  const _MainBottomNav();

  @override
  Widget build(BuildContext context) {
    var currentLocation = RouteNames.home;
    try {
      final routerState = GoRouterState.of(context);
      currentLocation = routerState.uri.path;
    } catch (e) {
      currentLocation = RouteNames.home;
    }

    final cs = Theme.of(context).colorScheme;

    return NavigationBar(
      key: const ValueKey('main_bottom_nav'),
      selectedIndex: _getSelectedIndex(currentLocation),
      onDestinationSelected: (index) => _onItemTapped(context, index),
      backgroundColor: cs.surface,
      indicatorColor: cs.primaryContainer,
      surfaceTintColor: Colors.transparent,
      elevation: 3,
      height: 64,
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
    if (currentLocation == RouteNames.home) return 0;
    if (currentLocation == RouteNames.plots) return 1;
    if (currentLocation == RouteNames.market) return 2;
    if (currentLocation == RouteNames.products) return 3;
    if (currentLocation == RouteNames.profile) return 4;
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
        router.go(RouteNames.plots);
        break;
      case 2:
        router.go(RouteNames.market);
        break;
      case 3:
        router.go(RouteNames.products);
        break;
      case 4:
        router.go(RouteNames.profile);
        break;
    }
  }
}
