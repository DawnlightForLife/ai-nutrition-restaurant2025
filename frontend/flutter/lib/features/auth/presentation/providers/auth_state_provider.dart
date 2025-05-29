import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dtos/user_model.dart';
import '../data/services/auth_api_service.dart';

// 认证状态
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserModel? user;
  final String? token;
  final String? error;
  
  AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.token,
    this.error,
  });
  
  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserModel? user,
    String? token,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error,
    );
  }
}

// 认证状态提供者
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthApiService _authService;
  final SharedPreferences _prefs;
  
  AuthStateNotifier(this._authService, this._prefs) : super(AuthState()) {
    _checkAuthStatus();
  }
  
  // 检查认证状态
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    
    final token = _prefs.getString('auth_token');
    if (token != null) {
      try {
        final isValid = await _authService.verifyToken(token);
        if (isValid) {
          // 获取用户信息
          final user = await _authService.getCurrentUser(token);
          state = state.copyWith(
            isAuthenticated: true,
            isLoading: false,
            user: user,
            token: token,
            error: null,
          );
        } else {
          await _clearAuth();
        }
      } catch (e) {
        print('Token验证失败: $e');
        await _clearAuth();
      }
    } else {
      state = state.copyWith(isLoading: false);
    }
  }
  
  // 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _authService.sendVerificationCode(phone);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // 抛出异常，让调用方处理
    }
  }
  
  // 验证码登录
  Future<bool> loginWithCode(String phone, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.loginWithCode(phone, code);
      
      // 保存token
      await _prefs.setString('auth_token', response.token);
      await _prefs.setString('user_phone', phone);
      
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: response.user,
        token: response.token,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // 抛出异常，让调用方处理
    }
  }
  
  // 密码登录
  Future<bool> loginWithPassword(String phone, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.loginWithPassword(phone, password);
      
      // 保存token
      await _prefs.setString('auth_token', response.token);
      await _prefs.setString('user_phone', phone);
      
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: response.user,
        token: response.token,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow; // 抛出异常，让调用方处理
    }
  }
  
  // 退出登录
  Future<void> logout() async {
    await _clearAuth();
  }
  
  // 清除认证信息
  Future<void> _clearAuth() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('user_phone');
    state = AuthState(isLoading: false);
  }
  
  // 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authApiServiceProvider = Provider((ref) => AuthApiService());

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(authApiServiceProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthStateNotifier(authService, prefs);
});