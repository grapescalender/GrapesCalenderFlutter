/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final Object? originalError;

  const AppException(this.message, [this.originalError]);

  @override
  String toString() => message;
}

/// Network exceptions
class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException(
    super.message,
    this.statusCode, [
    super.originalError,
  ]);
}

/// Server exceptions
class ServerException extends AppException {
  final int? statusCode;

  const ServerException(
    super.message,
    this.statusCode, [
    super.originalError,
  ]);
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException(super.message, [super.originalError]);
}

/// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException(super.message, [super.originalError]);
}

/// Authorization exceptions
class AuthorizationException extends AppException {
  const AuthorizationException(super.message, [super.originalError]);
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException(
    super.message,
    this.errors, [
    super.originalError,
  ]);
}
