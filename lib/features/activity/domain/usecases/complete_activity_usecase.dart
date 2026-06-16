import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Parameters for CompleteActivityUseCase
class CompleteActivityParams {

  CompleteActivityParams({required this.activityId});
  final String activityId;
}

/// Use case to complete an activity
class CompleteActivityUseCase implements UseCase<ActivityEntity, CompleteActivityParams> {

  CompleteActivityUseCase(this.repository);
  final ActivityRepository repository;

  @override
  Future<Either<Failure, ActivityEntity>> call(CompleteActivityParams params) async => await repository.completeActivity(activityId: params.activityId);
}
