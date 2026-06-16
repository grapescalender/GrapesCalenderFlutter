import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Parameters for GetActiveActivityUseCase
class GetActiveActivityParams {

  GetActiveActivityParams({required this.plotId});
  final String plotId;
}

/// Use case to get active activity for a plot
class GetActiveActivityUseCase implements UseCase<ActivityEntity?, GetActiveActivityParams> {

  GetActiveActivityUseCase(this.repository);
  final ActivityRepository repository;

  @override
  Future<Either<Failure, ActivityEntity?>> call(GetActiveActivityParams params) async => await repository.getActiveActivity(plotId: params.plotId);
}
