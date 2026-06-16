import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Parameters for StartActivityUseCase
class StartActivityParams {

  StartActivityParams({
    required this.plotId,
    required this.type,
  });
  final String plotId;
  final ActivityType type;
}

/// Use case to start an activity
class StartActivityUseCase implements UseCase<ActivityEntity, StartActivityParams> {

  StartActivityUseCase(this.repository);
  final ActivityRepository repository;

  @override
  Future<Either<Failure, ActivityEntity>> call(StartActivityParams params) async => await repository.startActivity(
      plotId: params.plotId,
      type: params.type,
    );
}
