import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

/// Authentication repository interface
/// This defines the contract for authentication operations
abstract class AuthRepository {
  /// Login with username and password
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current authenticated user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Check if user is authenticated
  Future<Either<Failure, bool>> isAuthenticated();

  /// Refresh authentication token
  Future<Either<Failure, String>> refreshToken();
}
