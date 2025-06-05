import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/auth_state.dart';

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
      final secureStorage = _ref.read(secureStorageProvider);
      final token = await secureStorage.read(key: 'auth_token');
      
      if (token != null && token.isNotEmpty) {
        // 获取用户信息
        final authService = _ref.read(authServiceProvider);
        final userInfo = await authService.getUserInfo(token);
        
        state = AuthState(
          isAuthenticated: true,
          token: token,
          user: userInfo,
        );
      }
    } catch (e) {
      print('初始化认证状态失败: $e');
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
  
  /// 验证码登录
  Future<bool> loginWithCode(String phone, String code) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authService = _ref.read(authServiceProvider);
      final response = await authService.loginWithCode(phone, code);
      
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
}