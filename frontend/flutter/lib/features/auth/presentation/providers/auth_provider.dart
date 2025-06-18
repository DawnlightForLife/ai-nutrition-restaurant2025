import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/auth_state.dart';
import '../../../main/presentation/providers/navigation_provider.dart';
import '../../../permission/presentation/providers/user_permission_provider.dart';
import '../../../workspace/presentation/providers/workspace_provider.dart';

/// 安全存储Provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// SharedPreferences Provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// 认证状态Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  
  AuthStateNotifier(this._ref) : super(const AuthState()) {
    _init();
  }
  
  /// 初始化，检查登录状态
  Future<void> _init() async {
    try {
      print('=== 开始初始化认证状态 ===');
      
      final secureStorage = _ref.read(secureStorageProvider);
      final token = await secureStorage.read(key: 'auth_token');
      
      print('从存储读取token: ${token != null ? "存在" : "不存在"}');
      
      if (token != null && token.isNotEmpty) {
        try {
          // 获取用户信息
          final authService = _ref.read(authServiceProvider);
          final userInfo = await authService.getUserInfo(token);
          
          print('成功获取用户信息: ${userInfo.name}');
          
          state = AuthState(
            isAuthenticated: true,
            token: token,
            user: userInfo,
          );
          
          print('认证状态已设置为已登录');
        } catch (e) {
          print('获取用户信息失败: $e');
          // Token可能已过期，清除存储
          await secureStorage.delete(key: 'auth_token');
          print('已清除过期token');
        }
      } else {
        print('没有找到token，用户未登录');
      }
    } catch (e) {
      print('初始化认证状态失败: $e');
    } finally {
      print('=== 认证状态初始化完成 ===');
    }
  }
  
  /// 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authService = _ref.read(authServiceProvider);
      final success = await authService.sendVerificationCode(phone);
      
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  /// 发送重置密码验证码
  Future<bool> sendPasswordResetCode(String phone) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authService = _ref.read(authServiceProvider);
      final success = await authService.sendPasswordResetCode(phone);
      
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  /// 验证码登录
  Future<bool> loginWithCode(String phone, String code) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authService = _ref.read(authServiceProvider);
      final response = await authService.loginWithCode(phone, code);
      
      print('=== 验证码登录成功 ===');
      print('响应数据: ${response.keys.toList()}');
      
      // 保存token
      final token = response['token'];
      final secureStorage = _ref.read(secureStorageProvider);
      await secureStorage.write(key: 'auth_token', value: token);
      
      print('✅ Token已保存到安全存储');
      
      // 解析用户信息
      final userInfo = UserInfo.fromJson(response['user']);
      
      print('✅ 用户信息解析成功: ${userInfo.name}');
      
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        token: token,
        user: userInfo,
      );
      
      print('✅ 认证状态已更新为已登录');
      
      // 登录成功后重置导航状态到首页
      _resetNavigationToHome();
      
      // 刷新用户权限和工作台状态
      _refreshUserDependencies();
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  /// 密码登录
  Future<bool> loginWithPassword(String phone, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authService = _ref.read(authServiceProvider);
      final response = await authService.loginWithPassword(phone, password);
      
      // 保存token
      final token = response['token'];
      final secureStorage = _ref.read(secureStorageProvider);
      await secureStorage.write(key: 'auth_token', value: token);
      
      // 解析用户信息
      final userInfo = UserInfo.fromJson(response['user']);
      
      state = AuthState(
        isAuthenticated: true,
        isLoading: false,
        token: token,
        user: userInfo,
      );
      
      // 登录成功后重置导航状态到首页
      _resetNavigationToHome();
      
      // 刷新用户权限和工作台状态
      _refreshUserDependencies();
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  /// 登出
  Future<void> logout() async {
    try {
      final secureStorage = _ref.read(secureStorageProvider);
      await secureStorage.delete(key: 'auth_token');
      
      // 完全重置状态
      state = const AuthState(
        isAuthenticated: false,
        isLoading: false,
        user: null,
        token: null,
        error: null,
      );
    } catch (e) {
      print('登出时发生错误: $e');
      // 即使删除token失败，也要重置状态
      state = const AuthState();
    }
  }
  
  /// 清除所有状态（强制重置）
  void clearState() {
    state = const AuthState();
  }
  
  /// 更新用户信息
  void updateUserInfo(UserInfo userInfo) {
    state = state.copyWith(user: userInfo);
  }
  
  /// 刷新用户信息（从服务器重新获取）
  Future<bool> refreshUserInfo() async {
    try {
      if (!state.isAuthenticated || state.token == null) {
        return false;
      }
      
      state = state.copyWith(isLoading: true, error: null);
      
      final authService = _ref.read(authServiceProvider);
      final userInfo = await authService.getUserInfo(state.token!);
      
      state = state.copyWith(
        isLoading: false,
        user: userInfo,
      );
      
      // 刷新用户权限和工作台状态
      _refreshUserDependencies();
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '刷新用户信息失败: ${e.toString()}',
      );
      return false;
    }
  }
  
  /// 重置密码
  Future<bool> resetPassword(String phone, String code, String newPassword) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authService = _ref.read(authServiceProvider);
      final success = await authService.resetPassword(phone, code, newPassword);
      
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  /// 重置导航状态到首页
  void _resetNavigationToHome() {
    try {
      _ref.read(navigationProvider.notifier).toHome();
    } catch (e) {
      print('重置导航状态失败: $e');
    }
  }
  
  /// 刷新用户相关依赖状态
  void _refreshUserDependencies() {
    try {
      // 刷新用户权限状态
      _ref.invalidate(userPermissionsProvider);
      _ref.invalidate(hasMerchantPermissionProvider);
      _ref.invalidate(hasNutritionistPermissionProvider);
      _ref.invalidate(currentUserHasMerchantPermissionProvider);
      _ref.invalidate(currentUserHasNutritionistPermissionProvider);
      
      // 刷新工作台状态
      _ref.read(workspaceProvider.notifier).refreshWorkspaces();
      
      print('✅ 已刷新用户权限和工作台状态');
    } catch (e) {
      print('刷新用户依赖状态失败: $e');
    }
  }
}