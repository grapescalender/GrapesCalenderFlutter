import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/schedule_repository.dart';

class DeleteScheduleParams {
  const DeleteScheduleParams({required this.scheduleId});

  final String scheduleId;
}

class DeleteScheduleUseCase implements UseCase<void, DeleteScheduleParams> {
  const DeleteScheduleUseCase(this.repository);

  final ScheduleRepository repository;

  @override
  Future<Either<Failure, void>> call(DeleteScheduleParams params) {
    return repository.deleteSchedule(params.scheduleId);
  }
}
