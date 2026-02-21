import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

/// Activity entity - Domain layer representation
class ActivityEntity {
  final String id;
  final String plotId;
  final String plotName;
  final ActivityType type;
  final ActivityStatus status;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActivityEntity({
    required this.id,
    required this.plotId,
    required this.plotName,
    required this.type,
    required this.status,
    this.startedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if activity is active
  bool get isActive => status == ActivityStatus.active;

  /// Check if activity is completed
  bool get isCompleted => status == ActivityStatus.completed;

  /// Check if activity is pending
  bool get isPending => status == ActivityStatus.pending;
}

/// Activity type enum
enum ActivityType {
  cutting,
  flooring,
  formation,
  harvesting,
  dipping;

  String get displayName {
    switch (this) {
      case ActivityType.cutting:
        return 'Cutting';
      case ActivityType.flooring:
        return 'Flooring';
      case ActivityType.formation:
        return 'Formation';
      case ActivityType.harvesting:
        return 'Harvesting';
      case ActivityType.dipping:
        return 'Dipping';
    }
  }

  String get value {
    switch (this) {
      case ActivityType.cutting:
        return 'cutting';
      case ActivityType.flooring:
        return 'flooring';
      case ActivityType.formation:
        return 'formation';
      case ActivityType.harvesting:
        return 'harvesting';
      case ActivityType.dipping:
        return 'dipping';
    }
  }

  IconData get icon {
    switch (this) {
      case ActivityType.cutting:
        return Icons.content_cut;
      case ActivityType.flooring:
        return Icons.landscape;
      case ActivityType.formation:
        return Icons.agriculture;
      case ActivityType.harvesting:
        return Icons.eco;
      case ActivityType.dipping:
        return Icons.water_drop;
    }
  }

  static ActivityType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cutting':
        return ActivityType.cutting;
      case 'flooring':
        return ActivityType.flooring;
      case 'formation':
        return ActivityType.formation;
      case 'harvesting':
        return ActivityType.harvesting;
      case 'dipping':
        return ActivityType.dipping;
      default:
        return ActivityType.cutting;
    }
  }

  /// Get the order of activities (sequential)
  static List<ActivityType> get orderedTypes => [
        ActivityType.cutting,
        ActivityType.flooring,
        ActivityType.formation,
        ActivityType.harvesting,
        ActivityType.dipping,
      ];

  /// Get next activity type
  static ActivityType? getNext(ActivityType current) {
    final ordered = orderedTypes;
    final currentIndex = ordered.indexOf(current);
    if (currentIndex >= 0 && currentIndex < ordered.length - 1) {
      return ordered[currentIndex + 1];
    }
    return null;
  }
}

/// Activity status enum
enum ActivityStatus {
  pending,
  active,
  completed;

  String get value {
    switch (this) {
      case ActivityStatus.pending:
        return 'pending';
      case ActivityStatus.active:
        return 'active';
      case ActivityStatus.completed:
        return 'completed';
    }
  }

  static ActivityStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return ActivityStatus.active;
      case 'completed':
        return ActivityStatus.completed;
      default:
        return ActivityStatus.pending;
    }
  }
}
