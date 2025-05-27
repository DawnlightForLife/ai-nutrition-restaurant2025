/// 应用异常基类
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// API 异常
class ApiException extends AppException {
  ApiException(String message, [int? statusCode]) : super(message, statusCode);
}

/// 网络异常
class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

/// 400 Bad Request
class BadRequestException extends ApiException {
  BadRequestException(String message) : super(message, 400);
}

/// 401 Unauthorized
class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

/// 403 Forbidden
class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, 403);
}

/// 404 Not Found
class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);
}

/// 422 Validation Error
class ValidationException extends ApiException {
  final Map<String, dynamic> errors;

  ValidationException(String message, this.errors) : super(message, 422);

  String getFieldError(String field) {
    if (errors.containsKey(field)) {
      final fieldErrors = errors[field];
      if (fieldErrors is List && fieldErrors.isNotEmpty) {
        return fieldErrors.first as String;
      }
      return fieldErrors.toString();
    }
    return '';
  }
}

/// 500 Server Error
class ServerException extends ApiException {
  ServerException(String message) : super(message, 500);
}