import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule_entity.dart';
import '../repositories/schedule_repository.dart';

class UpdateScheduleParams {
  const UpdateScheduleParams({required this.schedule});

  final ScheduleEntity schedule;
}

class UpdateScheduleUseCase
    implements UseCase<ScheduleEntity, UpdateScheduleParams> {
  const UpdateScheduleUseCase(this.repository);

  final ScheduleRepository repository;

  @override
  Future<Either<Failure, ScheduleEntity>> call(
    UpdateScheduleParams params,
  ) {
    return repository.updateSchedule(params.schedule);
  }
}
