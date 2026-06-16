import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Localization service for managing translations
class LocalizationService {
  static const String _supportedLanguages = 'en,mr,hi';
  
  static const Map<String, Locale> supportedLocales = {
    'en': Locale('en', 'US'),
    'mr': Locale('mr', 'IN'),
    'hi': Locale('hi', 'IN'),
  };

  static const Map<String, String> languageNames = {
    'en': 'English',
    'mr': 'मराठी',
    'hi': 'हिंदी',
  };

  late Map<String, Map<String, String>> _translations;
  late SharedPreferences _preferences;
  late String _currentLanguage;

  /// Initialize localization service
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _currentLanguage = _preferences.getString(AppConstants.languageKey) ?? 'en';
    
    // Load all language files
    _translations = {
      'en': await _loadLanguage('en'),
      'mr': await _loadLanguage('mr'),
      'hi': await _loadLanguage('hi'),
    };
  }

  /// Load language translations from JSON file
  Future<Map<String, String>> _loadLanguage(String languageCode) async {
    final jsonString = await rootBundle.loadString('assets/i18n/$languageCode.json');
    final dynamic jsonData = json.decode(jsonString);
    final jsonMap = Map<String, dynamic>.from(jsonData as Map);
    
    return jsonMap.cast<String, String>();
  }

  /// Get current language code
  String get currentLanguage => _currentLanguage;

  /// Get current locale
  Locale get currentLocale => supportedLocales[_currentLanguage] ?? supportedLocales['en']!;

  /// Get supported locales list
  List<Locale> get locales => supportedLocales.values.toList();

  /// Change language
  Future<void> setLanguage(String languageCode) async {
    if (supportedLocales.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      await _preferences.setString(AppConstants.languageKey, languageCode);
    }
  }

  /// Get translated string
  String translate(String key) => _translations[_currentLanguage]?[key] ?? key;

  /// Get translated string with plural support
  String translatePlural(String key, int count) {
    final translated = translate(key);
    return translated.replaceAll('{count}', count.toString());
  }

  /// Get translated string with replacements
  String translateWithArgs(String key, Map<String, String> args) {
    var translated = translate(key);
    args.forEach((argKey, argValue) {
      translated = translated.replaceAll('{$argKey}', argValue);
    });
    return translated;
  }
}

/// Localization service provider using Riverpod
// Note: This is a reference for how it would be used with Riverpod
// The actual provider will be implemented in features/auth/presentation/providers
