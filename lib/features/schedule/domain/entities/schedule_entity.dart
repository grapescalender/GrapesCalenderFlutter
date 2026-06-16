/// Schedule entity - Domain layer representation
class ScheduleEntity {

  const ScheduleEntity({
    required this.id,
    required this.plotId,
    required this.plotName,
    required this.type,
    required this.title,
    required this.scheduledDate,
    this.description,
    this.isCompleted = false,
    List<String> activityIds = const [], // 1-2 activity IDs
    required this.createdAt,
    required this.updatedAt,
  }) : activityIds = activityIds;
  final String id;
  final String plotId;
  final String plotName; // Added for display
  final ScheduleType type;
  final String title;
  final DateTime scheduledDate;
  final String? description;
  final bool isCompleted;
  final List<String> activityIds; // 1-2 activity IDs
  final DateTime createdAt;
  final DateTime updatedAt;
}

/// Schedule type enum
enum ScheduleType {
  spray,
  nutrition,
  work,
  all; // For filtering

  String get displayName {
    switch (this) {
      case ScheduleType.spray:
        return 'Spray';
      case ScheduleType.nutrition:
        return 'Nutrition';
      case ScheduleType.work:
        return 'Work';
      case ScheduleType.all:
        return 'All';
    }
  }

  String get value {
    switch (this) {
      case ScheduleType.spray:
        return 'spray';
      case ScheduleType.nutrition:
        return 'nutrition';
      case ScheduleType.work:
        return 'work';
      case ScheduleType.all:
        return 'all';
    }
  }

  static ScheduleType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'spray':
        return ScheduleType.spray;
      case 'nutrition':
        return ScheduleType.nutrition;
      case 'work':
        return ScheduleType.work;
      default:
        return ScheduleType.all;
    }
  }
}
