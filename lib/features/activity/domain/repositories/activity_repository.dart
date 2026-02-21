import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/activity_entity.dart';

/// Activity repository interface
abstract class ActivityRepository {
  /// Get activities for a plot
  Future<Either<Failure, List<ActivityEntity>>> getActivities({
    required String plotId,
  });

  /// Start an activity
  Future<Either<Failure, ActivityEntity>> startActivity({
    required String plotId,
    required ActivityType type,
  });

  /// Complete an activity
  Future<Either<Failure, ActivityEntity>> completeActivity({
    required String activityId,
  });

  /// Get current active activity for a plot
  Future<Either<Failure, ActivityEntity?>> getActiveActivity({
    required String plotId,
  });
}
