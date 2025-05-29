import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_request.freezed.dart';
part 'auth_request.g.dart';

/// 登录请求模型
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    /// 邮箱（与phone二选一）
    String? email,
    
    /// 手机号（与email二选一）
    String? phone,
    
    /// 密码
    required String password,
    
    /// 设备ID
    String? deviceId,
    
    /// 设备名称
    String? deviceName,
    
    /// 登录方式
    @Default('password') String loginType,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// 注册请求模型
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    /// 邮箱
    required String email,
    
    /// 手机号
    required String phone,
    
    /// 密码
    required String password,
    
    /// 确认密码
    required String confirmPassword,
    
    /// 昵称
    required String nickname,
    
    /// 验证码
    String? verificationCode,
    
    /// 邀请码
    String? inviteCode,
    
    /// 同意条款
    @Default(false) bool agreeTerms,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// 发送验证码请求模型
@freezed
class SendCodeRequest with _$SendCodeRequest {
  const factory SendCodeRequest({
    /// 手机号
    required String phone,
    
    /// 验证码类型（login/register/reset等）
    required String type,
    
    /// 图形验证码
    String? captcha,
  }) = _SendCodeRequest;

  factory SendCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$SendCodeRequestFromJson(json);
}

/// 验证码登录请求模型
@freezed
class CodeLoginRequest with _$CodeLoginRequest {
  const factory CodeLoginRequest({
    /// 手机号
    required String phone,
    
    /// 验证码
    required String code,
    
    /// 设备ID
    String? deviceId,
    
    /// 设备名称
    String? deviceName,
  }) = _CodeLoginRequest;

  factory CodeLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$CodeLoginRequestFromJson(json);
}

/// 刷新Token请求模型
@freezed
class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    /// 刷新Token
    required String refreshToken,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

/// 验证Token请求模型
@freezed
class VerifyTokenRequest with _$VerifyTokenRequest {
  const factory VerifyTokenRequest({
    /// 访问Token
    required String accessToken,
  }) = _VerifyTokenRequest;

  factory VerifyTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyTokenRequestFromJson(json);
}

/// 忘记密码请求模型
@freezed
class ForgotPasswordRequest with _$ForgotPasswordRequest {
  const factory ForgotPasswordRequest({
    /// 邮箱或手机号
    required String identifier,
    
    /// 验证码
    String? verificationCode,
  }) = _ForgotPasswordRequest;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);
}

/// 重置密码请求模型
@freezed
class ResetPasswordRequest with _$ResetPasswordRequest {
  const factory ResetPasswordRequest({
    /// 重置Token
    required String resetToken,
    
    /// 新密码
    required String newPassword,
    
    /// 确认新密码
    required String confirmPassword,
  }) = _ResetPasswordRequest;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
}

/// 修改密码请求模型
@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    /// 当前密码
    required String currentPassword,
    
    /// 新密码
    required String newPassword,
    
    /// 确认新密码
    required String confirmPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}

/// 绑定OAuth账号请求模型
@freezed
class BindOAuthRequest with _$BindOAuthRequest {
  const factory BindOAuthRequest({
    /// OAuth提供商（wechat/qq/apple等）
    required String provider,
    
    /// OAuth访问Token
    required String accessToken,
    
    /// OAuth用户ID
    required String oauthUserId,
  }) = _BindOAuthRequest;

  factory BindOAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$BindOAuthRequestFromJson(json);
}