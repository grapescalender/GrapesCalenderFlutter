import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Parameters for StartActivityUseCase
class StartActivityParams {
  final String plotId;
  final ActivityType type;

  StartActivityParams({
    required this.plotId,
    required this.type,
  });
}

/// Use case to start an activity
class StartActivityUseCase implements UseCase<ActivityEntity, StartActivityParams> {
  final ActivityRepository repository;

  StartActivityUseCase(this.repository);

  @override
  Future<Either<Failure, ActivityEntity>> call(StartActivityParams params) async {
    return await repository.startActivity(
      plotId: params.plotId,
      type: params.type,
    );
  }
}
