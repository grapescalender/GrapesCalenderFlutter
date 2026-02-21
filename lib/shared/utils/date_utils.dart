/// Date utility functions for activity day calculations
class ActivityDateUtils {
  /// Calculate day count from pruning date to target date
  /// Returns the number of days between pruningDate and targetDate
  /// Returns null if pruningDate is null
  static int? calculateDay(DateTime? pruningDate, DateTime targetDate) {
    if (pruningDate == null) return null;
    
    final pruneDate = DateTime(
      pruningDate.year,
      pruningDate.month,
      pruningDate.day,
    );
    final target = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    
    final difference = target.difference(pruneDate).inDays;
    return difference >= 0 ? difference : null;
  }

  /// Format date with day count
  /// Format: "Date (Day X)" or "Date" if day count is null
  static String formatDateWithDay(
    DateTime date,
    int? dayCount,
  ) {
    final formattedDate = _formatDate(date);
    if (dayCount != null) {
      return '$formattedDate (Day $dayCount)';
    }
    return formattedDate;
  }

  /// Format date to full readable string
  static String formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format date to readable string
  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final difference = dateOnly.difference(today).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0 && difference <= 7) {
      return 'In $difference days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
