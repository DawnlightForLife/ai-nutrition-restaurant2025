// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String,
      deviceId: json['device_id'] as String?,
      deviceName: json['device_name'] as String?,
      loginType: json['login_type'] as String? ?? 'password',
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{
      if (instance.email case final value?) 'email': value,
      if (instance.phone case final value?) 'phone': value,
      'password': instance.password,
      if (instance.deviceId case final value?) 'device_id': value,
      if (instance.deviceName case final value?) 'device_name': value,
      'login_type': instance.loginType,
    };

_$RegisterRequestImpl _$$RegisterRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RegisterRequestImpl(
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      confirmPassword: json['confirm_password'] as String,
      nickname: json['nickname'] as String,
      verificationCode: json['verification_code'] as String?,
      inviteCode: json['invite_code'] as String?,
      agreeTerms: json['agree_terms'] as bool? ?? false,
    );

Map<String, dynamic> _$$RegisterRequestImplToJson(
        _$RegisterRequestImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'confirm_password': instance.confirmPassword,
      'nickname': instance.nickname,
      if (instance.verificationCode case final value?)
        'verification_code': value,
      if (instance.inviteCode case final value?) 'invite_code': value,
      'agree_terms': instance.agreeTerms,
    };

_$SendCodeRequestImpl _$$SendCodeRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SendCodeRequestImpl(
      phone: json['phone'] as String,
      type: json['type'] as String,
      captcha: json['captcha'] as String?,
    );

Map<String, dynamic> _$$SendCodeRequestImplToJson(
        _$SendCodeRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'type': instance.type,
      if (instance.captcha case final value?) 'captcha': value,
    };

_$CodeLoginRequestImpl _$$CodeLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CodeLoginRequestImpl(
      phone: json['phone'] as String,
      code: json['code'] as String,
      deviceId: json['device_id'] as String?,
      deviceName: json['device_name'] as String?,
    );

Map<String, dynamic> _$$CodeLoginRequestImplToJson(
        _$CodeLoginRequestImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'code': instance.code,
      if (instance.deviceId case final value?) 'device_id': value,
      if (instance.deviceName case final value?) 'device_name': value,
    };

_$RefreshTokenRequestImpl _$$RefreshTokenRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RefreshTokenRequestImpl(
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$$RefreshTokenRequestImplToJson(
        _$RefreshTokenRequestImpl instance) =>
    <String, dynamic>{
      'refresh_token': instance.refreshToken,
    };

_$VerifyTokenRequestImpl _$$VerifyTokenRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyTokenRequestImpl(
      accessToken: json['access_token'] as String,
    );

Map<String, dynamic> _$$VerifyTokenRequestImplToJson(
        _$VerifyTokenRequestImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
    };

_$ForgotPasswordRequestImpl _$$ForgotPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ForgotPasswordRequestImpl(
      identifier: json['identifier'] as String,
      verificationCode: json['verification_code'] as String?,
    );

Map<String, dynamic> _$$ForgotPasswordRequestImplToJson(
        _$ForgotPasswordRequestImpl instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      if (instance.verificationCode case final value?)
        'verification_code': value,
    };

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ResetPasswordRequestImpl(
      resetToken: json['reset_token'] as String,
      newPassword: json['new_password'] as String,
      confirmPassword: json['confirm_password'] as String,
    );

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
        _$ResetPasswordRequestImpl instance) =>
    <String, dynamic>{
      'reset_token': instance.resetToken,
      'new_password': instance.newPassword,
      'confirm_password': instance.confirmPassword,
    };

_$ChangePasswordRequestImpl _$$ChangePasswordRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ChangePasswordRequestImpl(
      currentPassword: json['current_password'] as String,
      newPassword: json['new_password'] as String,
      confirmPassword: json['confirm_password'] as String,
    );

Map<String, dynamic> _$$ChangePasswordRequestImplToJson(
        _$ChangePasswordRequestImpl instance) =>
    <String, dynamic>{
      'current_password': instance.currentPassword,
      'new_password': instance.newPassword,
      'confirm_password': instance.confirmPassword,
    };

_$BindOAuthRequestImpl _$$BindOAuthRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$BindOAuthRequestImpl(
      provider: json['provider'] as String,
      accessToken: json['access_token'] as String,
      oauthUserId: json['oauth_user_id'] as String,
    );

Map<String, dynamic> _$$BindOAuthRequestImplToJson(
        _$BindOAuthRequestImpl instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'access_token': instance.accessToken,
      'oauth_user_id': instance.oauthUserId,
    };
