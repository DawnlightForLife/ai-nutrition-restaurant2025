/// 用户模块 Provider 统一导出
/// 
/// 提供用户模块相关的所有 Provider 和访问器
/// 避免使用全局 providers_index，实现模块化管理
library;

// 核心控制器
export 'user_profile_controller.dart';
export 'user_profile_provider.dart';

// TODO: 添加其他用户相关的 Provider
// export 'user_preferences_provider.dart';
// export 'user_health_data_provider.dart';
// export 'user_activity_provider.dart';

/// 用户模块 Provider 访问器
/// 
/// 提供用户模块内部 Provider 的便捷访问方式
/// 遵循模块化设计原则，避免跨模块直接访问
class UserProviders {
  const UserProviders._();

  // 用户档案相关
  // static final userProfileController = userProfileControllerProvider;
  // static final userProfile = userProfileProvider;
  
  // TODO: 添加其他用户 Provider 的访问器
  // static final userPreferences = userPreferencesProvider;
  // static final userHealthData = userHealthDataProvider;
  // static final userActivity = userActivityProvider;
}