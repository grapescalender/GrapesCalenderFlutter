import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base failure class for all errors in the application
@freezed
class Failure with _$Failure {
  /// Network-related failures
  const factory Failure.network({
    required String message,
    @Default(500) int? statusCode,
  }) = NetworkFailure;

  /// Server-related failures
  const factory Failure.server({
    required String message,
    @Default(500) int? statusCode,
  }) = ServerFailure;

  /// Cache-related failures
  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  /// Authentication failures
  const factory Failure.authentication({
    required String message,
  }) = AuthenticationFailure;

  /// Authorization failures
  const factory Failure.authorization({
    required String message,
  }) = AuthorizationFailure;

  /// Validation failures
  const factory Failure.validation({
    required String message,
    Map<String, List<String>>? errors,
  }) = ValidationFailure;

  /// Unknown/unexpected failures
  const factory Failure.unknown({
    required String message,
    Object? error,
  }) = UnknownFailure;
}
