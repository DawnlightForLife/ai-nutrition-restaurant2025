import 'package:dartz/dartz.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failures.dart';
import '../usecases/login_usecase.dart';
import '../usecases/register_usecase.dart';
import '../usecases/logout_usecase.dart';
import '../usecases/refresh_token_usecase.dart';

/// 认证业务门面
/// 
/// 聚合认证相关的所有用例，为UI层提供统一的业务接口
class AuthFacade {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;

  const AuthFacade({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required RefreshTokenUseCase refreshTokenUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _refreshTokenUseCase = refreshTokenUseCase;

  /// 执行完整的登录流程
  /// 
  /// 包括验证、登录、获取用户信息
  Future<Either<AuthFailure, AuthUser>> performLogin({
    String? email,
    String? phone,
    required String password,
  }) async {
    // 参数验证
    if ((email == null && phone == null) || password.isEmpty) {
      return Left(AuthFailure.invalidCredentials());
    }

    // 执行登录
    final loginResult = await _loginUseCase(LoginParams(
      email: email,
      phone: phone,
      password: password,
    ));

    return loginResult.fold(
      (failure) => Left(failure),
      (user) => Right(user),
    );
  }

  /// 执行完整的注册流程
  /// 
  /// 包括验证、注册、自动登录
  Future<Either<AuthFailure, AuthUser>> performRegistration({
    required String email,
    required String phone,
    required String password,
    required String nickname,
    String? verificationCode,
  }) async {
    // 执行注册
    final registerResult = await _registerUseCase(RegisterParams(
      email: email,
      phone: phone,
      password: password,
      nickname: nickname,
      verificationCode: verificationCode,
    ));

    return registerResult.fold(
      (failure) => Left(failure),
      (user) => Right(user),
    );
  }

  /// 执行登出流程
  /// 
  /// 包括清理本地数据、通知服务器
  Future<Either<AuthFailure, void>> performLogout() async {
    return await _logoutUseCase(NoParams());
  }

  /// 执行Token刷新
  /// 
  /// 自动处理Token过期情况
  Future<Either<AuthFailure, String>> performTokenRefresh() async {
    return await _refreshTokenUseCase(NoParams());
  }

  /// 验证码登录组合操作
  /// 
  /// 发送验证码 + 验证码登录
  Future<Either<AuthFailure, AuthUser>> performCodeLogin({
    required String phone,
    required String code,
  }) async {
    // 这里可以组合多个用例
    // 1. 验证验证码
    // 2. 执行登录
    // 3. 获取用户信息
    
    // 简化实现，实际应该调用对应的用例
    return await _loginUseCase(LoginParams(
      phone: phone,
      verificationCode: code,
    ));
  }
}

/// UseCase 参数类定义
class LoginParams {
  final String? email;
  final String? phone;
  final String? password;
  final String? verificationCode;

  LoginParams({
    this.email,
    this.phone,
    this.password,
    this.verificationCode,
  });
}

class RegisterParams {
  final String email;
  final String phone;
  final String password;
  final String nickname;
  final String? verificationCode;

  RegisterParams({
    required this.email,
    required this.phone,
    required this.password,
    required this.nickname,
    this.verificationCode,
  });
}

class NoParams {}

/// 认证失败类型（占位）
abstract class AuthFailure {
  static AuthFailure invalidCredentials() => _InvalidCredentials();
  static AuthFailure networkError() => _NetworkError();
  static AuthFailure serverError() => _ServerError();
}

class _InvalidCredentials extends AuthFailure {}
class _NetworkError extends AuthFailure {}
class _ServerError extends AuthFailure {}

/// UseCase 接口定义（占位）
abstract class LoginUseCase {
  Future<Either<AuthFailure, AuthUser>> call(LoginParams params);
}

abstract class RegisterUseCase {
  Future<Either<AuthFailure, AuthUser>> call(RegisterParams params);
}

abstract class LogoutUseCase {
  Future<Either<AuthFailure, void>> call(NoParams params);
}

abstract class RefreshTokenUseCase {
  Future<Either<AuthFailure, String>> call(NoParams params);
}

/// 认证用户实体（占位）
class AuthUser {
  final String id;
  final String email;
  final String nickname;

  AuthUser({
    required this.id,
    required this.email,
    required this.nickname,
  });
}