/// Constants used throughout the application
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://api.drakshsetu.com/v1';
  static const int apiTimeoutSeconds = 30;
  static const int retryAttempts = 3;

  // Local Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String farmerIdKey = 'farmer_id';

  // App Configuration
  static const String appName = 'Drakshsetu';
  static const String appVersion = '1.0.0';

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 300);
  static const Duration normalAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);

  // Validation
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;
}

class ScheduleTypeConstants {
  static const String spray = 'spray';
  static const String nutrition = 'nutrition';
  static const String work = 'work';

  static List<String> getAllTypes() => [spray, nutrition, work];
}

class ActivityConstants {
  static const String pruning = 'pruning';
  static const String shootFormation = 'shoot_formation';
  static const String flowering = 'flowering';
  static const String berryFormation = 'berry_formation';
  static const String harvesting = 'harvesting';
  static const String dipping = 'dipping';

  static List<String> getActivitySequence() => [
        pruning,
        shootFormation,
        flowering,
        berryFormation,
        harvesting,
        dipping,
      ];

  static int getSequenceOrder(String activity) {
    return getActivitySequence().indexOf(activity);
  }
}
