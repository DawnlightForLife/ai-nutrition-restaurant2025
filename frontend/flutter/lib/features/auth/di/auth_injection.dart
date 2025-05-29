/// Auth 模块依赖注入
/// 
/// 管理 Auth 模块的所有依赖注入
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/datasources/auth_api.dart';
import '../data/datasources/auth_local_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/refresh_token_usecase.dart';
import '../application/facades/auth_facade.dart';

/// Auth 模块依赖注入容器
class AuthInjection {
  AuthInjection._();

  // ========== Data Sources ==========
  
  /// Auth API 数据源
  static final authApiProvider = createServiceProvider<AuthApi>((ref) {
    final dio = ref.watch(InjectionContainer.dioClientProvider);
    return AuthApi(dio.dio);
  });

  /// Auth 本地数据源
  static final authLocalDataSourceProvider = createServiceProvider<AuthLocalDataSource>((ref) {
    return AuthLocalDataSourceImpl();
  });

  // ========== Repositories ==========
  
  /// Auth 仓库
  static final authRepositoryProvider = createRepositoryProvider<AuthRepository>((ref) {
    return AuthRepositoryImpl(
      remoteDataSource: ref.watch(authApiProvider),
      localDataSource: ref.watch(authLocalDataSourceProvider),
      networkInfo: ref.watch(InjectionContainer.networkInfoProvider),
    );
  });

  // ========== Use Cases ==========
  
  /// 登录用例
  static final loginUseCaseProvider = createUseCaseProvider<LoginUseCase>((ref) {
    return LoginUseCase(
      repository: ref.watch(authRepositoryProvider),
    );
  });

  /// 登出用例
  static final logoutUseCaseProvider = createUseCaseProvider<LogoutUseCase>((ref) {
    return LogoutUseCase(
      repository: ref.watch(authRepositoryProvider),
    );
  });

  /// 注册用例
  static final registerUseCaseProvider = createUseCaseProvider<RegisterUseCase>((ref) {
    return RegisterUseCase(
      repository: ref.watch(authRepositoryProvider),
    );
  });

  /// 刷新令牌用例
  static final refreshTokenUseCaseProvider = createUseCaseProvider<RefreshTokenUseCase>((ref) {
    return RefreshTokenUseCase(
      repository: ref.watch(authRepositoryProvider),
    );
  });

  // ========== Facades ==========
  
  /// Auth 业务门面
  static final authFacadeProvider = Provider<AuthFacade>((ref) {
    return AuthFacade(
      loginUseCase: ref.watch(loginUseCaseProvider),
      logoutUseCase: ref.watch(logoutUseCaseProvider),
      registerUseCase: ref.watch(registerUseCaseProvider),
      refreshTokenUseCase: ref.watch(refreshTokenUseCaseProvider),
    );
  });
}

// 占位类定义（实际实现时替换）
abstract class AuthLocalDataSource {}
class AuthLocalDataSourceImpl implements AuthLocalDataSource {}
abstract class AuthRepository {}
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApi remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  });
}
abstract class LoginUseCase {
  LoginUseCase({required AuthRepository repository});
}
abstract class LogoutUseCase {
  LogoutUseCase({required AuthRepository repository});
}
abstract class RegisterUseCase {
  RegisterUseCase({required AuthRepository repository});
}
abstract class RefreshTokenUseCase {
  RefreshTokenUseCase({required AuthRepository repository});
}