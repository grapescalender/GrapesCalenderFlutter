import '../../domain/entities/schedule_entity.dart';

/// Schedule Filter Utilities
/// Helper functions for filtering schedules by activity and date
class ScheduleFilterUtils {
  /// Get schedules filtered by activity ID and date range
  /// 
  /// Filters schedules where:
  /// - schedule.activityIds contains activityId
  /// - schedule.scheduledDate >= startDate (inclusive)
  /// - schedule.scheduledDate <= endDate (inclusive)
  /// 
  /// Returns filtered list of schedules
  static List<ScheduleEntity> getSchedulesByActivityAndDate({
    required List<ScheduleEntity> allSchedules,
    required String activityId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Normalize dates to compare only date part (ignore time)
    final startDateOnly = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final endDateOnly = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
    );

    final filtered = allSchedules.where((schedule) {
      // Check activity mapping
      final hasActivity = schedule.activityIds.contains(activityId);
      if (!hasActivity) {
        return false;
      }

      // Check date range (inclusive on both ends)
      final scheduleDateOnly = DateTime(
        schedule.scheduledDate.year,
        schedule.scheduledDate.month,
        schedule.scheduledDate.day,
      );

      // Schedule date must be >= startDate AND <= endDate (inclusive)
      // Use compareTo for accurate comparison
      final startComparison = scheduleDateOnly.compareTo(startDateOnly);
      final endComparison = scheduleDateOnly.compareTo(endDateOnly);
      
      // startComparison >= 0 means scheduleDate >= startDate
      // endComparison <= 0 means scheduleDate <= endDate
      return startComparison >= 0 && endComparison <= 0;
    }).toList();

    return filtered;
  }

  /// Debug print schedule filtering information
  static void debugPrintFilterInfo({
    required String activityId,
    required DateTime? startDate,
    required DateTime? endDate,
    required int totalSchedules,
    required int filteredCount,
    List<ScheduleEntity>? allSchedules,
    List<ScheduleEntity>? filteredSchedules,
  }) {
    print('=== Schedule Filter Debug ===');
    print('Activity ID: $activityId');
    print('Start Date: ${startDate?.toString() ?? "null"}');
    print('End Date: ${endDate?.toString() ?? "null"}');
    print('Total Schedules: $totalSchedules');
    print('Filtered Schedules: $filteredCount');
    
    if (allSchedules != null) {
      print('\nAll Schedule Activity IDs:');
      for (final schedule in allSchedules) {
        print('  Schedule ${schedule.id}: activityIds=${schedule.activityIds}, date=${schedule.scheduledDate}');
      }
    }
    
    if (filteredSchedules != null) {
      print('\nFiltered Schedule IDs:');
      for (final schedule in filteredSchedules) {
        print('  Schedule ${schedule.id}: activityIds=${schedule.activityIds}, date=${schedule.scheduledDate}');
      }
    }
    print('=== End Debug ===');
  }
}
