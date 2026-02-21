import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Parameters for CompleteActivityUseCase
class CompleteActivityParams {
  final String activityId;

  CompleteActivityParams({required this.activityId});
}

/// Use case to complete an activity
class CompleteActivityUseCase implements UseCase<ActivityEntity, CompleteActivityParams> {
  final ActivityRepository repository;

  CompleteActivityUseCase(this.repository);

  @override
  Future<Either<Failure, ActivityEntity>> call(CompleteActivityParams params) async {
    return await repository.completeActivity(activityId: params.activityId);
  }
}
