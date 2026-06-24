import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/schedule_entity.dart';

/// Schedule repository interface
abstract class ScheduleRepository {
  /// Get schedules for a plot with optional filter
  Future<Either<Failure, List<ScheduleEntity>>> getSchedules({
    required String plotId,
    ScheduleType? filterType,
    int? limit,
  });

  /// Create a new schedule
  Future<Either<Failure, ScheduleEntity>> createSchedule({
    required String plotId,
    required ScheduleType type,
    required String title,
    required DateTime scheduledDate,
    String? description,
    List<String> activityIds = const [],
    bool isCompleted = false,
  });

  /// Update schedule
  Future<Either<Failure, ScheduleEntity>> updateSchedule(
      ScheduleEntity schedule);

  /// Delete schedule
  Future<Either<Failure, void>> deleteSchedule(String scheduleId);
}
