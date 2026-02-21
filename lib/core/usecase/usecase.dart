import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base use case interface
/// T - Return type
/// P - Parameters
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

/// Use case with no parameters
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// Use case with stream return type
abstract class StreamUseCase<T, P> {
  Stream<Either<Failure, T>> call(P params);
}
