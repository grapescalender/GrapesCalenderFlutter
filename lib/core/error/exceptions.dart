/// Base exception class
abstract class AppException implements Exception {

  const AppException(this.message, [this.originalError]);
  final String message;
  final Object? originalError;

  @override
  String toString() => message;
}

/// Network exceptions
class NetworkException extends AppException {

  const NetworkException(
    super.message,
    this.statusCode, [
    super.originalError,
  ]);
  final int? statusCode;
}

/// Server exceptions
class ServerException extends AppException {

  const ServerException(
    super.message,
    this.statusCode, [
    super.originalError,
  ]);
  final int? statusCode;
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

  const ValidationException(
    super.message,
    this.errors, [
    super.originalError,
  ]);
  final Map<String, List<String>>? errors;
}
