import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// 认证用户实体 - 仅包含认证相关信息
@freezed
class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String phone,
    String? email,
    required String accessToken,
    required String refreshToken,
    DateTime? tokenExpiresAt,
  }) = _AuthUser;
  
  const AuthUser._();
}