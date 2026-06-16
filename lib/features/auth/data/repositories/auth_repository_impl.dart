import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../mappers/user_mapper.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(Failure.network(message: 'No internet connection'));
      }

      final userModel = await remoteDataSource.login(
        username: username,
        password: password,
      );

      // Cache user locally
      await localDataSource.cacheUser(userModel);
      // Store ids securely (used across features)
      await localDataSource.saveUserId(userModel.id);
      await localDataSource.saveFarmerId('1'); // TODO: Replace with backend farmer id

      // Convert model to entity
      final userEntity = UserMapper.toEntity(userModel);

      return Right(userEntity);
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
    } on AuthenticationException catch (e) {
      return Left(Failure.authentication(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'An unexpected error occurred: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
      await localDataSource.clearToken();
      await localDataSource.clearIds();
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to logout: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(UserMapper.toEntity(cachedUser));
      }

      // If not in cache, try to fetch from remote
      final isConnected = await networkInfo.isConnected;
      if (isConnected) {
        final userModel = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(userModel);
        return Right(UserMapper.toEntity(userModel));
      }

      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to get current user: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to check authentication: ${e.toString()}',
        error: e,
      ));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(Failure.network(message: 'No internet connection'));
      }

      final newToken = await remoteDataSource.refreshToken();
      await localDataSource.saveToken(newToken);
      return Right(newToken);
    } on NetworkException catch (e) {
      return Left(Failure.network(
        message: e.message,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      return Left(Failure.unknown(
        message: 'Failed to refresh token: ${e.toString()}',
        error: e,
      ));
    }
  }
}
