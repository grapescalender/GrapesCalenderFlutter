import '../../domain/entities/activity_entity.dart';
import '../models/activity_model.dart';

/// Remote data source interface for activities
abstract class ActivityRemoteDataSource {
  /// Get activities for a plot
  Future<List<ActivityModel>> getActivities({
    required String plotId,
  });

  /// Start an activity
  Future<ActivityModel> startActivity({
    required String plotId,
    required ActivityType type,
  });

  /// Complete an activity
  Future<ActivityModel> completeActivity({
    required String activityId,
  });
}

/// Implementation of ActivityRemoteDataSource
class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  @override
  Future<List<ActivityModel>> getActivities({
    required String plotId,
  }) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - return activities for the plot
    final now = DateTime.now();
    final orderedTypes = ActivityType.orderedTypes;

    // Generate activities based on plot state
    // For demo: assume first activity is active, previous ones completed
    final activities = <ActivityModel>[];

    // Find which activity should be active (mock logic)
    // In real app, this would come from backend
    var activeIndex = 1; // Flooring is active

    for (var i = 0; i < orderedTypes.length; i++) {
      final type = orderedTypes[i];
      ActivityStatus status;
      DateTime? startedAt;
      DateTime? completedAt;

      if (i < activeIndex) {
        // Completed activities
        status = ActivityStatus.completed;
        startedAt = now.subtract(Duration(days: (activeIndex - i) * 7));
        completedAt = now.subtract(Duration(days: (activeIndex - i) * 7 - 3));
      } else if (i == activeIndex) {
        // Active activity
        status = ActivityStatus.active;
        startedAt = now.subtract(const Duration(days: 3));
      } else {
        // Pending activities
        status = ActivityStatus.pending;
      }

      activities.add(ActivityModel(
        id: 'activity_${plotId}_${type.value}',
        plotId: plotId,
        plotName: 'Plot Name', // Will be set by repository
        type: type.value,
        status: status.value,
        startedAt: startedAt,
        completedAt: completedAt,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ));
    }

    return activities;
  }

  @override
  Future<ActivityModel> startActivity({
    required String plotId,
    required ActivityType type,
  }) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    return ActivityModel(
      id: 'activity_${plotId}_${type.value}_${now.millisecondsSinceEpoch}',
      plotId: plotId,
      plotName: 'Plot Name',
      type: type.value,
      status: ActivityStatus.active.value,
      startedAt: now,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<ActivityModel> completeActivity({
    required String activityId,
  }) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));

    // In real app, fetch existing activity and update
    final now = DateTime.now();
    return ActivityModel(
      id: activityId,
      plotId: 'plot_id',
      plotName: 'Plot Name',
      type: ActivityType.cutting.value,
      status: ActivityStatus.completed.value,
      startedAt: now.subtract(const Duration(days: 3)),
      completedAt: now,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );
  }
}
