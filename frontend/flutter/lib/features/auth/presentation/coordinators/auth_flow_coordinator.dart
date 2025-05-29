import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/coordinators/base_coordinator.dart';
import '../../../../core/coordinators/coordinator_result.dart';
import '../../../../features/nutrition/presentation/router/nutrition_router.dart';
import '../../../../features/user/presentation/router/user_router.dart';
import '../../domain/entities/auth_user.dart';
import '../providers/auth_provider.dart';
import '../router/auth_router.dart';

/// 认证流程协调器
/// 处理登录、注册、资料完善等认证相关的业务流程
class AuthFlowCoordinator extends BaseCoordinator {
  AuthFlowCoordinator(super.ref);
  
  @override
  Future<void> start() async {
    // 检查认证状态并导航到合适的页面
    final authState = ref.read(authProvider);
    
    if (authState.isAuthenticated) {
      await router.navigateTo(UserRouter.homePath);
    } else {
      await router.navigateTo(AuthRouter.loginPath);
    }
  }
  
  /// 处理登录成功后的流程
  Future<CoordinatorResult<void>> handleLoginSuccess(AuthUser user) async {
    try {
      // 1. 检查用户资料是否完善
      final isProfileComplete = await _checkProfileCompletion(user.id);
      
      if (!isProfileComplete) {
        // 导航到资料完善页面
        await router.navigateTo(AuthRouter.profileCompletionPath);
        return const CoordinatorResult.success(data: null);
      }
      
      // 2. 检查是否有营养档案
      final hasNutritionProfile = await _checkNutritionProfile(user.id);
      
      if (!hasNutritionProfile) {
        // 导航到营养档案创建页面
        await router.navigateTo(
          NutritionRouter.profileManagementPathWithId('new'),
        );
        return const CoordinatorResult.success(data: null);
      }
      
      // 3. 导航到主页
      await router.navigateToAndClearStack(UserRouter.homePath);
      return const CoordinatorResult.success(data: null);
      
    } catch (e) {
      return CoordinatorResult.failure(
        error: '登录流程处理失败',
        code: 'LOGIN_FLOW_ERROR',
      );
    }
  }
  
  /// 处理注册成功后的流程
  Future<CoordinatorResult<void>> handleRegisterSuccess(AuthUser user) async {
    try {
      // 1. 导航到资料完善页面
      await router.navigateTo(AuthRouter.profileCompletionPath);
      
      return const CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(
        error: '注册流程处理失败',
        code: 'REGISTER_FLOW_ERROR',
      );
    }
  }
  
  /// 处理资料完善完成后的流程
  Future<CoordinatorResult<void>> handleProfileCompletionSuccess(String userId) async {
    try {
      // 导航到创建营养档案页面
      await router.replaceTo(
        NutritionRouter.profileManagementPathWithId('new'),
      );
      
      return const CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(
        error: '资料完善流程处理失败',
        code: 'PROFILE_COMPLETION_ERROR',
      );
    }
  }
  
  /// 处理登出流程
  Future<CoordinatorResult<void>> handleLogout() async {
    try {
      // 1. 清除本地数据
      await _clearLocalData();
      
      // 2. 导航到登录页面
      await router.navigateToAndClearStack(AuthRouter.loginPath);
      
      return const CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(
        error: '登出流程处理失败',
        code: 'LOGOUT_ERROR',
      );
    }
  }
  
  /// 检查用户资料是否完善
  Future<bool> _checkProfileCompletion(String userId) async {
    // TODO: 实现检查逻辑
    // 这里应该调用 UserRepository 检查用户资料
    return true; // 暂时返回 true
  }
  
  /// 检查是否有营养档案
  Future<bool> _checkNutritionProfile(String userId) async {
    // TODO: 实现检查逻辑
    // 这里应该调用 NutritionRepository 检查营养档案
    return false; // 暂时返回 false
  }
  
  /// 清除本地数据
  Future<void> _clearLocalData() async {
    // TODO: 清除缓存、持久化数据等
  }
}

/// Provider
final authFlowCoordinatorProvider = Provider((ref) {
  return AuthFlowCoordinator(ref);
});