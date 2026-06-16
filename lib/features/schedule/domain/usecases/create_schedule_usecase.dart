import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule_entity.dart';
import '../repositories/schedule_repository.dart';

/// Create schedule use case parameters
class CreateScheduleParams { // 1-2 activity IDs

  CreateScheduleParams({
    required this.plotId,
    required this.type,
    required this.title,
    required this.scheduledDate,
    this.description,
    this.activityIds = const [],
  });
  final String plotId;
  final ScheduleType type;
  final String title;
  final DateTime scheduledDate;
  final String? description;
  final List<String> activityIds;
}

/// Create schedule use case
class CreateScheduleUseCase implements UseCase<ScheduleEntity, CreateScheduleParams> {

  CreateScheduleUseCase(this.repository);
  final ScheduleRepository repository;

  @override
  Future<Either<Failure, ScheduleEntity>> call(CreateScheduleParams params) async => await repository.createSchedule(
      plotId: params.plotId,
      type: params.type,
      title: params.title,
      scheduledDate: params.scheduledDate,
      description: params.description,
      activityIds: params.activityIds,
    );
}
