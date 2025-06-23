import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure(String message, {String? code})
      : super(message: message, code: code);
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure(String message, {String? code})
      : super(message: message, code: code);
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure(String message, {String? code})
      : super(message: message, code: code);
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure(String message, {String? code})
      : super(message: message, code: code);
}

/// Authentication failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message, {String? code})
      : super(message: message, code: code);
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure(String message, {String? code})
      : super(message: message, code: code);
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure(String message, {String? code})
      : super(message: message, code: code);
}