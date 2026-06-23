import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule_entity.dart';
import '../repositories/schedule_repository.dart';

class CompleteScheduleParams {
  const CompleteScheduleParams({required this.schedule});

  final ScheduleEntity schedule;
}

class CompleteScheduleUseCase
    implements UseCase<ScheduleEntity, CompleteScheduleParams> {
  const CompleteScheduleUseCase(this.repository);

  final ScheduleRepository repository;

  @override
  Future<Either<Failure, ScheduleEntity>> call(
    CompleteScheduleParams params,
  ) {
    final schedule = params.schedule;
    return repository.updateSchedule(
      ScheduleEntity(
        id: schedule.id,
        plotId: schedule.plotId,
        plotName: schedule.plotName,
        type: schedule.type,
        title: schedule.title,
        scheduledDate: schedule.scheduledDate,
        description: schedule.description,
        isCompleted: true,
        activityIds: schedule.activityIds,
        createdAt: schedule.createdAt,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
