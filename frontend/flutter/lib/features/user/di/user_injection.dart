/// User 模块依赖注入
/// 
/// 管理 User 模块的所有依赖注入
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/datasources/user_remote_datasource.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/get_user_profile_usecase.dart';
import '../domain/usecases/update_user_profile_usecase.dart';
import '../application/facades/user_facade.dart';

/// User 模块依赖注入容器
class UserInjection {
  UserInjection._();

  // ========== Data Sources ==========
  
  /// User 远程数据源
  static final userRemoteDataSourceProvider = 
      createServiceProvider<UserRemoteDataSource>((ref) {
    final dio = ref.watch(InjectionContainer.dioClientProvider);
    return UserRemoteDataSourceImpl(dio);
  });

  // ========== Repositories ==========
  
  /// User 仓库
  static final userRepositoryProvider = createRepositoryProvider<UserRepository>((ref) {
    return UserRepositoryImpl(
      remoteDataSource: ref.watch(userRemoteDataSourceProvider),
      networkInfo: ref.watch(InjectionContainer.networkInfoProvider),
    );
  });

  // ========== Use Cases ==========
  
  /// 获取用户档案用例
  static final getUserProfileUseCaseProvider = 
      createUseCaseProvider<GetUserProfileUseCase>((ref) {
    return GetUserProfileUseCase(
      repository: ref.watch(userRepositoryProvider),
    );
  });

  /// 更新用户档案用例
  static final updateUserProfileUseCaseProvider = 
      createUseCaseProvider<UpdateUserProfileUseCase>((ref) {
    return UpdateUserProfileUseCase(
      repository: ref.watch(userRepositoryProvider),
    );
  });

  // TODO: 添加其他用户相关用例
  // static final uploadAvatarUseCaseProvider = ...
  // static final updatePreferencesUseCaseProvider = ...
  // static final deleteAccountUseCaseProvider = ...

  // ========== Facades ==========
  
  /// User 业务门面
  static final userFacadeProvider = Provider<UserFacade>((ref) {
    return UserFacade(
      getUserProfileUseCase: ref.watch(getUserProfileUseCaseProvider),
      updateUserProfileUseCase: ref.watch(updateUserProfileUseCaseProvider),
      // TODO: 添加其他用例依赖
    );
  });
}

// 占位实现（实际开发时替换）
abstract class UserRemoteDataSource {}
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl(DioClient dio);
}