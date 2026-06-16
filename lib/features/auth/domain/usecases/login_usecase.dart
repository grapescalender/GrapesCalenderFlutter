import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Login use case parameters
class LoginParams {

  LoginParams({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;
}

/// Login use case
class LoginUseCase implements UseCase<UserEntity, LoginParams> {

  LoginUseCase(this.repository);
  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async => await repository.login(
      username: params.username,
      password: params.password,
    );
}
