import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_remote_datasource.dart';
import '../mappers/activity_mapper.dart';

/// Implementation of ActivityRepository
class ActivityRepositoryImpl implements ActivityRepository {

  ActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  final ActivityRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivities({
    required String plotId,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(Failure.network(message: 'No internet connection'));
      }

      final activityModels = await remoteDataSource.getActivities(plotId: plotId);

      final activityEntities = activityModels
          .map(ActivityMapper.toEntity)
          .toList();

      return Right(activityEntities);
    } on NetworkException catch (e) {
      return Left(Failure.network(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to get activities: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, ActivityEntity>> startActivity({
    required String plotId,
    required ActivityType type,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(Failure.network(message: 'No internet connection'));
      }

      final activityModel = await remoteDataSource.startActivity(
        plotId: plotId,
        type: type,
      );

      final activityEntity = ActivityMapper.toEntity(activityModel);

      return Right(activityEntity);
    } on NetworkException catch (e) {
      return Left(Failure.network(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to start activity: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, ActivityEntity>> completeActivity({
    required String activityId,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(Failure.network(message: 'No internet connection'));
      }

      final activityModel = await remoteDataSource.completeActivity(
        activityId: activityId,
      );

      final activityEntity = ActivityMapper.toEntity(activityModel);

      return Right(activityEntity);
    } on NetworkException catch (e) {
      return Left(Failure.network(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } on ServerException catch (e) {
      return Left(Failure.server(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to complete activity: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, ActivityEntity?>> getActiveActivity({
    required String plotId,
  }) async {
    try {
      final activitiesResult = await getActivities(plotId: plotId);
      return activitiesResult.fold(
        Left.new,
        (activities) {
          final activeActivity = activities.firstWhere(
            (activity) => activity.isActive,
            orElse: () => activities.firstWhere(
              (activity) => activity.isPending,
              orElse: () => activities.first,
            ),
          );
          return Right(activeActivity);
        },
      );
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to get active activity: ${e.toString()}',
        error: e,
      ));
    }
  }
}
