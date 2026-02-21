import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../di/injection_container.dart';

/// Supported locales
class AppLocales {
  static const Locale english = Locale('en', 'US');
  static const Locale marathi = Locale('mr', 'IN');
  static const Locale hindi = Locale('hi', 'IN');

  static const List<Locale> supportedLocales = [
    english,
    marathi,
    hindi,
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'mr': 'मराठी',
    'hi': 'हिंदी',
  };
}

/// Localization service provider
final localizationServiceProvider =
    StateNotifierProvider<LocalizationNotifier, Locale>((ref) {
  return LocalizationNotifier(ref);
});

class LocalizationNotifier extends StateNotifier<Locale> {
  final Ref ref;
  Map<String, Map<String, String>> _translations = {};

  LocalizationNotifier(this.ref) : super(AppLocales.english) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadTranslations();
    await _loadSavedLocale();
  }

  Future<void> _loadTranslations() async {
    for (final locale in AppLocales.supportedLocales) {
      final languageCode = locale.languageCode;
      try {
        final jsonString =
            await rootBundle.loadString('assets/i18n/$languageCode.json');
        final dynamic jsonData = json.decode(jsonString);
        _translations[languageCode] = Map<String, String>.from(jsonData as Map);
      } catch (e) {
        // Handle error - fallback to empty map
        _translations[languageCode] = {};
      }
    }
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final languageCode = prefs.getString(AppConstants.languageKey) ?? 'en';
      final locale = AppLocales.supportedLocales.firstWhere(
        (locale) => locale.languageCode == languageCode,
        orElse: () => AppLocales.english,
      );
      state = locale;
    } catch (e) {
      state = AppLocales.english;
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (AppLocales.supportedLocales.contains(locale)) {
      state = locale;
      try {
        final prefs = await ref.read(sharedPreferencesProvider.future);
        await prefs.setString(AppConstants.languageKey, locale.languageCode);
      } catch (e) {
        // Handle error silently
      }
    }
  }

  String translate(String key) {
    final languageCode = state.languageCode;
    return _translations[languageCode]?[key] ?? key;
  }

  String translateWithArgs(String key, Map<String, String> args) {
    var translated = translate(key);
    args.forEach((argKey, argValue) {
      translated = translated.replaceAll('{$argKey}', argValue);
    });
    return translated;
  }
}

/// Extension to easily access translations in widgets
extension LocalizationExtension on BuildContext {
  String tr(String key) {
    final notifier = ProviderScope.containerOf(this)
        .read(localizationServiceProvider.notifier);
    return notifier.translate(key);
  }

  String trArgs(String key, Map<String, String> args) {
    final notifier = ProviderScope.containerOf(this)
        .read(localizationServiceProvider.notifier);
    return notifier.translateWithArgs(key, args);
  }
}
