import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Parameters for GetActiveActivityUseCase
class GetActiveActivityParams {
  final String plotId;

  GetActiveActivityParams({required this.plotId});
}

/// Use case to get active activity for a plot
class GetActiveActivityUseCase implements UseCase<ActivityEntity?, GetActiveActivityParams> {
  final ActivityRepository repository;

  GetActiveActivityUseCase(this.repository);

  @override
  Future<Either<Failure, ActivityEntity?>> call(GetActiveActivityParams params) async {
    return await repository.getActiveActivity(plotId: params.plotId);
  }
}
