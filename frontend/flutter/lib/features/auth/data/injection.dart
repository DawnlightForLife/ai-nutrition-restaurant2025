/// Auth 模块内部依赖注入
/// 
/// 模块私有的依赖注入配置，不对外暴露
/// 由 core/di/app_injection.dart 统一调用
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/di/app_injection.dart';
import 'datasources/auth_api.dart';
import 'datasources/auth_local_datasource.dart';
import '../application/facades/auth_facade.dart';

/// Auth 模块依赖注入
class AuthModuleInjection implements ModuleInjection {
  static void register() {
    // ========== Data Sources ==========
    
    // Auth API 数据源
    final authApiProvider = createServiceProvider<AuthApi>((ref) {
      final dio = ref.watch(InjectionContainer.dioClientProvider);
      return AuthApi(dio.dio);
    });

    // Auth 本地数据源
    final authLocalDataSourceProvider = createServiceProvider<AuthLocalDataSource>((ref) {
      return AuthLocalDataSourceImpl();
    });

    // ========== Repositories ==========
    
    // Auth 仓库
    final authRepositoryProvider = createRepositoryProvider<AuthRepository>((ref) {
      return AuthRepositoryImpl(
        remoteDataSource: ref.watch(authApiProvider),
        localDataSource: ref.watch(authLocalDataSourceProvider),
        networkInfo: ref.watch(InjectionContainer.networkInfoProvider),
      );
    });

    // ========== Use Cases ==========
    
    // 登录用例
    final loginUseCaseProvider = createUseCaseProvider<LoginUseCase>((ref) {
      return LoginUseCase(
        repository: ref.watch(authRepositoryProvider),
      );
    });

    // 登出用例
    final logoutUseCaseProvider = createUseCaseProvider<LogoutUseCase>((ref) {
      return LogoutUseCase(
        repository: ref.watch(authRepositoryProvider),
      );
    });

    // 注册用例
    final registerUseCaseProvider = createUseCaseProvider<RegisterUseCase>((ref) {
      return RegisterUseCase(
        repository: ref.watch(authRepositoryProvider),
      );
    });

    // 刷新令牌用例
    final refreshTokenUseCaseProvider = createUseCaseProvider<RefreshTokenUseCase>((ref) {
      return RefreshTokenUseCase(
        repository: ref.watch(authRepositoryProvider),
      );
    });

    // ========== Facades ==========
    
    // Auth 业务门面
    final authFacadeProvider = Provider<AuthFacade>((ref) {
      return AuthFacade(
        loginUseCase: ref.watch(loginUseCaseProvider),
        logoutUseCase: ref.watch(logoutUseCaseProvider),
        registerUseCase: ref.watch(registerUseCaseProvider),
        refreshTokenUseCase: ref.watch(refreshTokenUseCaseProvider),
      );
    });
  }
}