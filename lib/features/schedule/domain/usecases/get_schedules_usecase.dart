import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/schedule_entity.dart';
import '../repositories/schedule_repository.dart';

/// Get schedules use case parameters
class GetSchedulesParams {
  final String plotId;
  final ScheduleType? filterType;
  final int? limit;

  GetSchedulesParams({
    required this.plotId,
    this.filterType,
    this.limit,
  });
}

/// Get schedules use case
class GetSchedulesUseCase implements UseCase<List<ScheduleEntity>, GetSchedulesParams> {
  final ScheduleRepository repository;

  GetSchedulesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ScheduleEntity>>> call(GetSchedulesParams params) async {
    return await repository.getSchedules(
      plotId: params.plotId,
      filterType: params.filterType,
      limit: params.limit,
    );
  }
}
