import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../di/injection_container.dart';
import 'app_theme.dart';

/// Theme mode provider (Light/Dark)
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) => ThemeModeNotifier(ref));

class ThemeModeNotifier extends StateNotifier<ThemeMode> {

  ThemeModeNotifier(this.ref) : super(ThemeMode.light) {
    _loadThemeMode();
  }
  final Ref ref;

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final isDark = prefs.getBool(AppConstants.themeKey) ?? false;
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      state = ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setBool(AppConstants.themeKey, mode == ThemeMode.dark);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}

/// Theme data provider
final themeDataProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  return themeMode == ThemeMode.dark
      ? AppTheme.darkTheme
      : AppTheme.lightTheme;
});

/// Dark theme data provider
final darkThemeDataProvider = Provider<ThemeData>((ref) => AppTheme.darkTheme);
