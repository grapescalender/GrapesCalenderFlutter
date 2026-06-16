import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';

/// Dio HTTP client with interceptors for token management and error handling
class DioClient {

  DioClient({
    Dio? dio,
    FlutterSecureStorage? secureStorage,
    Logger? logger,
  })  : _dio = dio ?? Dio(),
        _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _logger = logger ?? Logger();
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final Logger _logger;

  void init() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
      receiveTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors
    _dio.interceptors.add(_TokenInterceptor(_secureStorage, _logger));
    _dio.interceptors.add(_ErrorHandlingInterceptor(_logger));
    _dio.interceptors.add(_LoggingInterceptor(_logger));
  }

  Dio get client => _dio;
}

/// Interceptor for handling JWT token attachment and refresh
class _TokenInterceptor extends Interceptor {

  _TokenInterceptor(this._secureStorage, this._logger);
  final FlutterSecureStorage _secureStorage;
  final Logger _logger;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _secureStorage.read(key: AppConstants.tokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      _logger.e('Error reading token: $e');
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token expired
    if (err.response?.statusCode == 401) {
      _logger.w('Token expired, attempting refresh');
      // TODO: Implement token refresh logic
      // For now, we'll just pass the error
    }
    return handler.next(err);
  }
}

/// Interceptor for centralized error handling
class _ErrorHandlingInterceptor extends Interceptor {

  _ErrorHandlingInterceptor(this._logger);
  final Logger _logger;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    _logger.e('API Error: ${err.message}', error: err.error, stackTrace: err.stackTrace);
    return handler.next(err);
  }
}

/// Interceptor for logging API requests and responses
class _LoggingInterceptor extends Interceptor {

  _LoggingInterceptor(this._logger);
  final Logger _logger;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _logger.d('→ ${options.method} ${options.path}');
    _logger.d('Headers: ${options.headers}');
    if (options.data != null) {
      _logger.d('Request Body: ${options.data}');
    }
    return handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    _logger.d('← ${response.statusCode} ${response.requestOptions.path}');
    _logger.d('Response: ${response.data}');
    return handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    _logger.e('✗ Error: ${err.message}');
    _logger.e('Response: ${err.response?.data}');
    return handler.next(err);
  }
}

/// Custom exception for API errors
class ApiException implements Exception {

  ApiException({
    required this.message,
    this.statusCode,
    this.originalException,
  });
  final String message;
  final int? statusCode;
  final dynamic originalException;

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
