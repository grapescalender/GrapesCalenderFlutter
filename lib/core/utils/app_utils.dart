import 'package:intl/intl.dart';

/// Date and time utilities
class DateTimeUtils {
  /// Format date as dd/MM/yyyy
  static String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  /// Format date and time as dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime dateTime) => DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

  /// Get difference in days between two dates
  static int getDaysDifference(DateTime from, DateTime to) => to.difference(from).inDays;

  /// Get running days from pruning date to today
  static int getRunningDays(DateTime pruningDate) => DateTime.now().difference(pruningDate).inDays;

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Get formatted date with running days
  static String formatDateWithRunningDays(DateTime pruningDate) {
    final runningDays = getRunningDays(pruningDate);
    return '${formatDate(pruningDate)} (Day $runningDays)';
  }

  /// Parse date from string
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateString);
    } catch (e) {
      return null;
    }
  }
}

/// String validation utilities
class ValidationUtils {
  /// Validate email format
  static bool isValidEmail(String email) => RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);

  /// Validate username (alphanumeric and underscore only)
  static bool isValidUsername(String username) => RegExp(r'^[a-zA-Z0-9_]{3,}$').hasMatch(username);

  /// Validate password strength
  static bool isValidPassword(String password) => password.length >= 8;

  /// Validate phone number (10 digits)
  static bool isValidPhoneNumber(String phone) => RegExp(r'^\d{10}$').hasMatch(phone.replaceAll(' ', ''));

  /// Validate field is not empty
  static bool isNotEmpty(String value) => value.trim().isNotEmpty;
}

/// Responsive design utilities
class ResponsiveUtils {
  /// Check if device is in portrait mode
  static bool isPortrait(double width, double height) => height > width;

  /// Check if device is a tablet
  static bool isTablet(double width) => width >= 600;

  /// Check if device is a large tablet
  static bool isLargeTablet(double width) => width >= 900;

  /// Get column count based on screen width
  static int getColumnCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 2;
    return 1;
  }

  /// Get responsive font size
  static double getResponsiveFontSize(double baseSize, double width) {
    if (width >= 900) return baseSize * 1.2;
    if (width >= 600) return baseSize * 1.1;
    return baseSize;
  }

  /// Get responsive padding
  static double getResponsivePadding(double basePadding, double width) {
    if (width >= 900) return basePadding * 1.5;
    if (width >= 600) return basePadding * 1.25;
    return basePadding;
  }
}

/// String extension methods
extension StringExtension on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Convert snake_case to Title Case
  String toTitleCase() => split('_').map((e) => e.capitalize()).join(' ');

  /// Truncate string with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }
}

/// List extension methods
extension ListExtension<T> on List<T> {
  /// Safely get element at index
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}
