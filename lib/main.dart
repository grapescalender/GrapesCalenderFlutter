import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants/app_constants.dart';
import 'core/localization/app_localizations.dart';
import 'core/design_system/theme/app_theme_provider.dart';
import 'config/providers/app_providers.dart' show goRouterProvider;
import 'features/auth/presentation/pages/app_launch_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize any required services here
  // e.g., Isar database, Firebase, etc.

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final themeData = ref.watch(themeDataProvider);
    final darkThemeData = ref.watch(darkThemeDataProvider);
    final locale = ref.watch(localizationServiceProvider);
    final router = ref.watch(goRouterProvider);

    return router.when(
      data: (routerConfig) => MaterialApp.router(
        title: 'Smart Farm Pruning Manager',
        debugShowCheckedModeBanner: false,
        themeAnimationDuration: AppConstants.normalAnimationDuration,
        themeAnimationCurve: Curves.easeInOutCubic,

        // Theme configuration
        theme: themeData,
        darkTheme: darkThemeData,
        themeMode: themeMode,

        // Localization configuration
        locale: locale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocales.supportedLocales,

        // Router configuration
        routerConfig: routerConfig,
      ),
      loading: () => MaterialApp(
        title: 'Smart Farm Pruning Manager',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        darkTheme: darkThemeData,
        themeMode: themeMode,
        locale: locale,
        supportedLocales: AppLocales.supportedLocales,
        home: const AppLaunchPage(),
      ),
      error: (_, __) => MaterialApp(
        title: 'Smart Farm Pruning Manager',
        debugShowCheckedModeBanner: false,
        theme: themeData,
        darkTheme: darkThemeData,
        themeMode: themeMode,
        locale: locale,
        supportedLocales: AppLocales.supportedLocales,
        home: const AppLaunchPage(),
      ),
    );
  }
}
