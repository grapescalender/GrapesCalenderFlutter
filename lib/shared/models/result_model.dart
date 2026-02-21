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
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';
}

/// Error result
class Error<T> extends Result<T> {
  final Exception exception;

  const Error(this.exception);

  @override
  String toString() => 'Error(exception: $exception)';
}

/// API response wrapper
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final int? statusCode;

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

  Map<String, dynamic> toJson(Object? Function(T)? toJsonT) => {
        'success': success,
        'message': message,
        'data': data != null && toJsonT != null ? toJsonT(data!) : null,
        'statusCode': statusCode,
      };
}

/// Pagination wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;

  PaginatedResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();

  bool get hasNextPage => pageNumber < totalPages;

  bool get hasPreviousPage => pageNumber > 1;
}
