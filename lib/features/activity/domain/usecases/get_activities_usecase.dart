import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Parameters for GetActivitiesUseCase
class GetActivitiesParams {
  final String plotId;

  GetActivitiesParams({required this.plotId});
}

/// Use case to get activities for a plot
class GetActivitiesUseCase implements UseCase<List<ActivityEntity>, GetActivitiesParams> {
  final ActivityRepository repository;

  GetActivitiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ActivityEntity>>> call(GetActivitiesParams params) async {
    return await repository.getActivities(plotId: params.plotId);
  }
}
