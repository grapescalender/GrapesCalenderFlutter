import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Parameters for GetActivitiesUseCase
class GetActivitiesParams {

  GetActivitiesParams({required this.plotId});
  final String plotId;
}

/// Use case to get activities for a plot
class GetActivitiesUseCase implements UseCase<List<ActivityEntity>, GetActivitiesParams> {

  GetActivitiesUseCase(this.repository);
  final ActivityRepository repository;

  @override
  Future<Either<Failure, List<ActivityEntity>>> call(GetActivitiesParams params) async => await repository.getActivities(plotId: params.plotId);
}
