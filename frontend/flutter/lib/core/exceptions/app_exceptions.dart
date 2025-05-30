/// 应用异常基类
/// 
/// 所有应用级别的异常都应该继承此类
/// 用于数据层和基础设施层的错误处理
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppException &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// 网络相关异常
class NetworkException extends AppException {
  const NetworkException(String message, {String? code, Map<String, dynamic>? details})
      : super(message: message, code: code ?? 'NETWORK_ERROR', details: details);
}

/// API调用异常
class ApiException extends AppException {
  final int? statusCode;
  
  const ApiException(
    String message, {
    this.statusCode,
    String? code,
    Map<String, dynamic>? details,
  }) : super(message: message, code: code ?? 'API_ERROR', details: details);
}

/// 验证异常
class ValidationException extends AppException {
  final Map<String, dynamic> errors;
  
  const ValidationException(
    String message,
    this.errors, {
    String? code,
    Map<String, dynamic>? details,
  }) : super(message: message, code: code ?? 'VALIDATION_ERROR', details: details);
}

/// 认证异常
class AuthException extends AppException {
  const AuthException(String message, {String? code, Map<String, dynamic>? details})
      : super(message: message, code: code ?? 'AUTH_ERROR', details: details);
}

/// 缓存异常
class CacheException extends AppException {
  const CacheException(String message, {String? code, Map<String, dynamic>? details})
      : super(message: message, code: code ?? 'CACHE_ERROR', details: details);
}

/// 未知异常
class UnknownException extends AppException {
  const UnknownException(String message, {String? code, Map<String, dynamic>? details})
      : super(message: message, code: code ?? 'UNKNOWN_ERROR', details: details);
}

/// 权限异常
class PermissionException extends AppException {
  const PermissionException(String message, {String? code, Map<String, dynamic>? details})
      : super(message: message, code: code ?? 'PERMISSION_ERROR', details: details);
}

/// 业务逻辑异常
class BusinessException extends AppException {
  const BusinessException(String message, {String? code, Map<String, dynamic>? details})
      : super(message: message, code: code ?? 'BUSINESS_ERROR', details: details);
}

/// 数据格式异常
class DataFormatException extends AppException {
  const DataFormatException(String message, {String? code, Map<String, dynamic>? details})
      : super(message: message, code: code ?? 'DATA_FORMAT_ERROR', details: details);
}

// HTTP状态码相关的特定异常类 (DioClient需要)
class BadRequestException extends ApiException {
  const BadRequestException(String message, {Map<String, dynamic>? details}) 
      : super(message, statusCode: 400, code: 'BAD_REQUEST', details: details);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(String message, {Map<String, dynamic>? details}) 
      : super(message, statusCode: 401, code: 'UNAUTHORIZED', details: details);
}

class ForbiddenException extends ApiException {
  const ForbiddenException(String message, {Map<String, dynamic>? details}) 
      : super(message, statusCode: 403, code: 'FORBIDDEN', details: details);
}

class NotFoundException extends ApiException {
  const NotFoundException(String message, {Map<String, dynamic>? details}) 
      : super(message, statusCode: 404, code: 'NOT_FOUND', details: details);
}

class ServerException extends ApiException {
  const ServerException(String message, {Map<String, dynamic>? details}) 
      : super(message, statusCode: 500, code: 'SERVER_ERROR', details: details);
}