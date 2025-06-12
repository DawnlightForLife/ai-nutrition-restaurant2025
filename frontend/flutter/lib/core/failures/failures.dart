import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;
  
  const Failure({
    required this.message,
    this.code,
    this.details,
  });
  
  @override
  List<Object?> get props => [message, code, details];
}

// General failures
class ServerFailure extends Failure {
  final int? statusCode;
  
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });
  
  @override
  List<Object?> get props => [message, code, details, statusCode];
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;
  
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
    this.errors,
  });
  
  @override
  List<Object?> get props => [message, code, details, errors];
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    required super.message,
    super.code,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    required super.message,
    super.code,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// 认证失败
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// 权限失败
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// 业务失败
class BusinessFailure extends Failure {
  const BusinessFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// 数据格式失败
class DataFormatFailure extends Failure {
  const DataFormatFailure({
    required super.message,
    super.code,
    super.details,
  });
}