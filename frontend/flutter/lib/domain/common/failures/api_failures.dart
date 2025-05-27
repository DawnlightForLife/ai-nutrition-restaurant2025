import 'failure.dart';

/// API相关的失败类型扩展
/// 提供额外的HTTP状态码等信息

/// 带状态码的服务器失败
class ServerFailureWithStatus extends ServerFailure {
  final int statusCode;
  
  const ServerFailureWithStatus({
    required super.message,
    required this.statusCode,
    super.code,
  });
  
  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// 带字段错误的验证失败
class ValidationFailureWithErrors extends ValidationFailure {
  final Map<String, List<String>> errors;
  
  const ValidationFailureWithErrors({
    required super.message,
    required this.errors,
    super.code,
  });
  
  /// 获取所有错误消息
  String get allErrorMessages {
    final messages = <String>[];
    errors.forEach((field, fieldErrors) {
      messages.addAll(fieldErrors.map((error) => '$field: $error'));
    });
    return messages.join(', ');
  }
  
  @override
  List<Object?> get props => [...super.props, errors];
}

/// 认证失败（401）
class AuthenticationFailure extends UnauthorizedFailure {
  const AuthenticationFailure({
    String message = '认证失败，请重新登录',
    super.code,
  }) : super(message: message);
}

/// 授权失败（403）
class AuthorizationFailure extends UnauthorizedFailure {
  const AuthorizationFailure({
    String message = '没有权限访问该资源',
    super.code,
  }) : super(message: message);
}

/// 资源冲突失败（409）
class ConflictFailure extends ServerFailure {
  const ConflictFailure({
    required super.message,
    super.code,
  });
}

/// 限流失败（429）
class RateLimitFailure extends ServerFailure {
  final Duration? retryAfter;
  
  const RateLimitFailure({
    required super.message,
    this.retryAfter,
    super.code,
  });
  
  @override
  List<Object?> get props => [...super.props, retryAfter];
}