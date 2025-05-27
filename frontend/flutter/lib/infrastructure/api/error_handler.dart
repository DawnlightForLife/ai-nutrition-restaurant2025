import 'package:dio/dio.dart';

import '../../domain/common/failures/failures.dart';

/// Unified API error handler
class ApiErrorHandler {
  /// Handles DioError and converts it to appropriate AppFailure
  static AppFailure handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is AppFailure) {
      return error;
    } else {
      return UnexpectedFailure(
        message: 'An unexpected error occurred',
        code: 'UNEXPECTED',
      );
    }
  }
  
  static AppFailure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          message: 'Connection timeout',
        );
        
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
        
      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'Request was cancelled',
        );
        
      case DioExceptionType.unknown:
        if (error.error?.toString().contains('SocketException') ?? false) {
          return NetworkFailure(
            message: 'No internet connection',
          );
        }
        return UnexpectedFailure(
          message: 'Connection failed',
          code: 'CONNECTION_FAILED',
        );
        
      default:
        return UnexpectedFailure(
          message: 'An unexpected error occurred',
          code: 'UNKNOWN_ERROR',
        );
    }
  }
  
  static AppFailure _handleBadResponse(Response? response) {
    if (response == null) {
      return ServerFailure(
        message: 'No response from server',
      );
    }
    
    final statusCode = response.statusCode ?? 0;
    final data = response.data;
    
    // Try to extract error message from response
    String message = 'Server error';
    if (data is Map<String, dynamic>) {
      final extractedMessage = data['message'] ?? data['error'];
      if (extractedMessage != null) {
        message = extractedMessage.toString();
      }
    }
    
    switch (statusCode) {
      case 400:
        return ValidationFailureWithErrors(
          message: message,
          errors: _extractValidationErrors(data),
        );
        
      case 401:
        return AuthenticationFailure(
          message: message,
        );
        
      case 403:
        return AuthorizationFailure(
          message: message,
        );
        
      case 404:
        return NotFoundFailure(
          message: message,
        );
        
      case 409:
        return ConflictFailure(
          message: message,
        );
        
      case 422:
        return ValidationFailureWithErrors(
          message: message,
          errors: _extractValidationErrors(data),
        );
        
      case 429:
        return RateLimitFailure(
          message: message,
          retryAfter: _extractRetryAfter(response.headers),
        );
        
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerFailureWithStatus(
          message: 'Server error: $message',
          statusCode: statusCode,
        );
        
      default:
        return ServerFailureWithStatus(
          message: message,
          statusCode: statusCode,
        );
    }
  }
  
  static Map<String, List<String>> _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.map((e) => e.toString()).toList());
          } else {
            return MapEntry(key, [value.toString()]);
          }
        });
      }
    }
    return {};
  }
  
  static Duration? _extractRetryAfter(Headers headers) {
    final retryAfter = headers.value('retry-after');
    if (retryAfter != null) {
      final seconds = int.tryParse(retryAfter);
      if (seconds != null) {
        return Duration(seconds: seconds);
      }
    }
    return null;
  }
}

/// Extension to simplify error handling in repositories
extension DioErrorHandling on Dio {
  /// Wraps a Dio request with error handling
  Future<T> handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (error) {
      throw ApiErrorHandler.handleError(error);
    }
  }
}