import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/localization_service.dart';
import '../../core/services/mock_data_service.dart' as mock;
import '../../features/schedule/domain/entities/schedule_entity.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../router/app_router.dart';

/// Localization Service Provider
final localizationServiceProvider =
    FutureProvider<LocalizationService>((ref) async {
  final service = LocalizationService();
  await service.init();
  return service;
});

/// Theme Mode Provider (Light/Dark)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>(
    (ref) => ThemeModeNotifier());

class ThemeModeNotifier extends StateNotifier<bool> {
  ThemeModeNotifier() : super(false) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isDark = prefs.getBool(AppConstants.themeKey) ?? false;
      state = isDark;
    } catch (e) {
      state = false;
    }
  }

  Future<void> toggleTheme() async {
    state = !state;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.themeKey, state);
    } catch (e) {
      // Handle error
    }
  }
}

/// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>(
    (ref) => LanguageNotifier());

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString(AppConstants.languageKey) ?? 'en';
      state = language;
    } catch (e) {
      state = 'en';
    }
  }

  Future<void> setLanguage(String languageCode) async {
    state = languageCode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.languageKey, languageCode);
    } catch (e) {
      // Handle error
    }
  }
}

/// GoRouter Provider
final goRouterProvider = FutureProvider<GoRouter>((ref) async {
  final authService = await ref.watch(authServiceProvider.future);
  return createAppRouter(authService);
});

/// Authentication Token Provider
final authTokenProvider = FutureProvider<String?>((ref) async {
  try {
    final localDataSource = await ref.watch(authLocalDataSourceProvider.future);
    return localDataSource.getToken();
  } catch (e) {
    return null;
  }
});

// ===== PLOT & SCHEDULE PROVIDERS =====
// Note: These are legacy providers. New features should use feature-specific providers.

/// All plots provider (using mock data model)
final allPlotsProvider =
    StateProvider<List<mock.PlotModel>>((ref) => mock.MockData.mockPlots);

/// Selected plot provider
final selectedPlotProvider = StateProvider<mock.PlotModel?>((ref) {
  final plots = ref.watch(allPlotsProvider);
  return plots.isNotEmpty ? plots.first : null;
});

/// Selected schedule type filter provider
final scheduleTypeFilterProvider = StateProvider<ScheduleType?>((ref) {
  return null; // null means all types
});

/// Current User ID Provider
final currentUserIdProvider = FutureProvider<String?>((ref) async {
  try {
    final localDataSource = await ref.watch(authLocalDataSourceProvider.future);
    return localDataSource.getFarmerId();
  } catch (e) {
    return null;
  }
});
