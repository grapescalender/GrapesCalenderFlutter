/// Result wrapper for handling success and error states
sealed class Result<T> {
  const Result();

  /// Map success result
  R map<R>({
    required R Function(T data) onSuccess,
    required R Function(Exception error) onError,
  }) {
    if (this is Success) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onError((this as Error<T>).exception);
    }
  }

  /// Get data or null
  T? getDataOrNull() {
    if (this is Success) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Get error or null
  Exception? getErrorOrNull() {
    if (this is Error) {
      return (this as Error<T>).exception;
    }
    return null;
  }
}

/// Success result
class Success<T> extends Result<T> {

  const Success(this.data);
  final T data;

  @override
  String toString() => 'Success(data: $data)';
}

/// Error result
class Error<T> extends Result<T> {

  const Error(this.exception);
  final Exception exception;

  @override
  String toString() => 'Error(exception: $exception)';
}

/// API response wrapper
class ApiResponse<T> {

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      success: (json['success'] as bool?) ?? false,
      message: json['message'] as String?,
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
      statusCode: json['statusCode'] as int?,
    );
  }
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

  Map<String, dynamic> toJson(Object? Function(T)? toJsonT) => {
        'success': success,
        'message': message,
        'data': data != null && toJsonT != null ? toJsonT(data as T) : null,
        'statusCode': statusCode,
      };
}

/// Pagination wrapper
class PaginatedResponse<T> {

  PaginatedResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });
  final List<T> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  int get totalPages => (totalCount / pageSize).ceil();

  bool get hasNextPage => pageNumber < totalPages;

  bool get hasPreviousPage => pageNumber > 1;
}
