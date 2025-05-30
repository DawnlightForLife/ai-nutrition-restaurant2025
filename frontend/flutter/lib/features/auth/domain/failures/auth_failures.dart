import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failures.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.invalidCredentials() = _InvalidCredentials;
  const factory AuthFailure.userNotFound() = _UserNotFound;
  const factory AuthFailure.emailAlreadyExists() = _EmailAlreadyExists;
  const factory AuthFailure.weakPassword() = _WeakPassword;
  const factory AuthFailure.networkError() = _NetworkError;
  const factory AuthFailure.serverError() = _ServerError;
  const factory AuthFailure.unknown() = _Unknown;
}