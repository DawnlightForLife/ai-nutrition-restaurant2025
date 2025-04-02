/// 应用基础异常类，所有其他异常类的父类
abstract class AppException implements Exception {
  final String message;
  final String? prefix;
  final String? code;
  final String? details;

  AppException(this.message, [this.prefix, this.code, this.details]);

  @override
  String toString() {
    return "$prefix: $message${code != null ? ' (Code: $code)' : ''}${details != null ? '\nDetails: $details' : ''}";
  }
}

/// API异常基类
abstract class ApiException extends AppException {
  ApiException(String message, [String? prefix, String? code, String? details])
      : super(message, prefix, code, details);
}

/// 网络连接异常（如网络不可用）
class ConnectionException extends ApiException {
  ConnectionException([String? message, String? details])
      : super(message ?? "网络连接失败", "连接错误", null, details);
}

/// 请求格式错误（HTTP 400）
class BadRequestException extends ApiException {
  BadRequestException([String? message, String? details])
      : super(message ?? "无效请求", "请求错误", "400", details);
}

/// 认证失败异常（HTTP 401/403）
class UnauthorizedException extends ApiException {
  UnauthorizedException([String? message, String? details])
      : super(message ?? "用户未认证或认证已过期", "认证错误", "401", details);
}

/// 资源不存在异常（HTTP 404）
class NotFoundException extends ApiException {
  NotFoundException([String? message, String? details])
      : super(message ?? "请求的资源不存在", "资源错误", "404", details);
}

/// 服务器错误异常（HTTP 500等）
class ServerException extends ApiException {
  ServerException([String? message, String? code, String? details])
      : super(message ?? "服务器内部错误", "服务器错误", code ?? "500", details);
}

/// 解析异常（JSON解析错误等）
class ParseException extends AppException {
  ParseException([String? message, String? details])
      : super(message ?? "数据解析错误", "解析错误", null, details);
}

/// 业务逻辑异常
class BusinessException extends AppException {
  final String businessCode;

  BusinessException(this.businessCode, [String? message, String? details])
      : super(message ?? "业务处理失败", "业务错误", businessCode, details);
}

/// 表单验证异常
class ValidationException extends AppException {
  final Map<String, List<String>>? validationErrors;

  ValidationException([String? message, this.validationErrors, String? details])
      : super(message ?? "表单验证失败", "验证错误", null, details);

  @override
  String toString() {
    if (validationErrors != null && validationErrors!.isNotEmpty) {
      final errorDetails = validationErrors!.entries
          .map((e) => "${e.key}: ${e.value.join(', ')}")
          .join('\n');
      return super.toString() + "\nValidation errors:\n$errorDetails";
    }
    return super.toString();
  }
} 