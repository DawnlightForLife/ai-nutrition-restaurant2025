import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/dtos/user_model.dart';
import '../../data/services/auth_api_service.dart';

part 'auth_controller.freezed.dart';
part 'auth_controller.g.dart';

/// Auth 状态类
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    UserModel? user,
    String? token,
    String? error,
    @Default(false) bool isVerifyingCode,
    @Default(false) bool isCheckingAuth,
    DateTime? tokenExpiry,
    @Default({}) Map<String, dynamic> userPermissions,
  }) = _AuthState;

  const AuthState._();

  /// 是否处于初始状态
  bool get isInitial => !isAuthenticated && !isLoading && user == null;

  /// 是否已登录
  bool get isLoggedIn => isAuthenticated && user != null && token != null;

  /// Token 是否已过期
  bool get isTokenExpired {
    if (tokenExpiry == null) return false;
    return DateTime.now().isAfter(tokenExpiry!);
  }

  /// 检查用户权限
  bool hasPermission(String permission) {
    return userPermissions[permission] == true;
  }

  /// 获取用户角色
  String? get userRole => user?.role;

  /// 是否是管理员
  bool get isAdmin => userRole == 'admin' || userRole == 'super_admin';

  /// 是否是营养师
  bool get isNutritionist => userRole == 'nutritionist';

  /// 是否是商家
  bool get isMerchant => userRole == 'merchant';
}

/// Auth 控制器
@riverpod
class AuthController extends _$AuthController {
  late final AuthApiService _authService;
  late final SharedPreferences _prefs;

  @override
  FutureOr<AuthState> build() async {
    _authService = ref.watch(authApiServiceProvider);
    _prefs = await ref.watch(sharedPreferencesProvider.future);
    
    // 检查认证状态
    await _checkAuthStatus();
    
    return state.valueOrNull ?? const AuthState();
  }

  /// 检查认证状态
  Future<void> _checkAuthStatus() async {
    state = const AsyncValue.loading();
    
    final token = _prefs.getString('auth_token');
    if (token != null) {
      try {
        final isValid = await _authService.verifyToken(token);
        if (isValid) {
          // 获取用户信息
          final user = await _authService.getCurrentUser(token);
          // 加载用户权限
          final permissions = await _loadUserPermissions(user.id);
          
          state = AsyncValue.data(AuthState(
            isAuthenticated: true,
            user: user,
            token: token,
            userPermissions: permissions,
            tokenExpiry: _getTokenExpiry(),
          ));
        } else {
          await _clearAuth();
        }
      } catch (e) {
        print('Token验证失败: $e');
        await _clearAuth();
      }
    } else {
      state = const AsyncValue.data(AuthState());
    }
  }

  /// 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    state = state.whenData((data) => data.copyWith(isLoading: true, error: null));
    
    try {
      final success = await _authService.sendVerificationCode(phone);
      state = state.whenData((data) => data.copyWith(isLoading: false));
      return success;
    } catch (e) {
      state = state.whenData((data) => data.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      return false;
    }
  }

  /// 验证码登录
  Future<bool> loginWithCode(String phone, String code) async {
    state = state.whenData((data) => data.copyWith(
      isLoading: true,
      isVerifyingCode: true,
      error: null,
    ));
    
    try {
      final response = await _authService.loginWithCode(phone, code);
      
      // 保存token和用户信息
      await _saveAuthData(response.token, phone);
      
      // 加载用户权限
      final permissions = await _loadUserPermissions(response.user.id);
      
      state = AsyncValue.data(AuthState(
        isAuthenticated: true,
        user: response.user,
        token: response.token,
        userPermissions: permissions,
        tokenExpiry: _getTokenExpiry(),
      ));
      
      return true;
    } catch (e) {
      state = state.whenData((data) => data.copyWith(
        isLoading: false,
        isVerifyingCode: false,
        error: e.toString(),
      ));
      return false;
    }
  }

  /// 密码登录
  Future<bool> loginWithPassword(String phone, String password) async {
    state = state.whenData((data) => data.copyWith(isLoading: true, error: null));
    
    try {
      final response = await _authService.loginWithPassword(phone, password);
      
      // 保存token和用户信息
      await _saveAuthData(response.token, phone);
      
      // 加载用户权限
      final permissions = await _loadUserPermissions(response.user.id);
      
      state = AsyncValue.data(AuthState(
        isAuthenticated: true,
        user: response.user,
        token: response.token,
        userPermissions: permissions,
        tokenExpiry: _getTokenExpiry(),
      ));
      
      return true;
    } catch (e) {
      state = state.whenData((data) => data.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      return false;
    }
  }

  /// 第三方登录（微信、QQ等）
  Future<bool> loginWithThirdParty(String provider, String accessToken) async {
    state = state.whenData((data) => data.copyWith(isLoading: true, error: null));
    
    try {
      // TODO: 实现第三方登录逻辑
      throw UnimplementedError('第三方登录尚未实现');
    } catch (e) {
      state = state.whenData((data) => data.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      return false;
    }
  }

  /// 退出登录
  Future<void> logout() async {
    state = state.whenData((data) => data.copyWith(isLoading: true));
    
    try {
      // 调用退出登录接口
      final token = state.valueOrNull?.token;
      if (token != null) {
        await _authService.logout(token);
      }
    } catch (e) {
      print('退出登录失败: $e');
    } finally {
      await _clearAuth();
    }
  }

  /// 刷新Token
  Future<bool> refreshToken() async {
    final currentToken = state.valueOrNull?.token;
    if (currentToken == null) return false;
    
    try {
      final newToken = await _authService.refreshToken(currentToken);
      await _prefs.setString('auth_token', newToken);
      
      state = state.whenData((data) => data.copyWith(
        token: newToken,
        tokenExpiry: _getTokenExpiry(),
      ));
      
      return true;
    } catch (e) {
      print('刷新Token失败: $e');
      return false;
    }
  }

  /// 更新用户信息
  Future<void> updateUserInfo(UserModel user) async {
    state = state.whenData((data) => data.copyWith(user: user));
  }

  /// 保存认证数据
  Future<void> _saveAuthData(String token, String phone) async {
    await _prefs.setString('auth_token', token);
    await _prefs.setString('user_phone', phone);
    await _prefs.setInt('token_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  /// 清除认证信息
  Future<void> _clearAuth() async {
    await _prefs.remove('auth_token');
    await _prefs.remove('user_phone');
    await _prefs.remove('token_timestamp');
    state = const AsyncValue.data(AuthState());
  }

  /// 加载用户权限
  Future<Map<String, dynamic>> _loadUserPermissions(String userId) async {
    try {
      // TODO: 从服务器加载用户权限
      return {
        'view_profile': true,
        'edit_profile': true,
        'view_orders': true,
        'create_order': true,
      };
    } catch (e) {
      print('加载用户权限失败: $e');
      return {};
    }
  }

  /// 获取Token过期时间
  DateTime? _getTokenExpiry() {
    final timestamp = _prefs.getInt('token_timestamp');
    if (timestamp == null) return null;
    
    // 假设Token有效期为7天
    return DateTime.fromMillisecondsSinceEpoch(timestamp).add(const Duration(days: 7));
  }

  /// 清除错误
  void clearError() {
    state = state.whenData((data) => data.copyWith(error: null));
  }

  /// 检查并刷新Token（如果需要）
  Future<bool> checkAndRefreshToken() async {
    final currentState = state.valueOrNull;
    if (currentState == null || !currentState.isAuthenticated) return false;
    
    if (currentState.isTokenExpired) {
      return await refreshToken();
    }
    
    return true;
  }
}

/// API Service Provider
@riverpod
AuthApiService authApiService(AuthApiServiceRef ref) {
  return AuthApiService();
}

/// SharedPreferences Provider
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

// ===== 便捷访问器 =====

/// 是否已认证
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isAuthenticated ?? false;
}

/// 是否正在加载
@riverpod
bool authIsLoading(AuthIsLoadingRef ref) {
  return ref.watch(authControllerProvider).isLoading ||
      (ref.watch(authControllerProvider).valueOrNull?.isLoading ?? false);
}

/// 当前用户
@riverpod
UserModel? currentUser(CurrentUserRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.user;
}

/// 认证Token
@riverpod
String? authToken(AuthTokenRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.token;
}

/// 错误信息
@riverpod
String? authError(AuthErrorRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.error;
}

/// 用户角色
@riverpod
String? userRole(UserRoleRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.userRole;
}

/// 是否是管理员
@riverpod
bool isAdmin(IsAdminRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isAdmin ?? false;
}

/// 是否是营养师
@riverpod
bool isNutritionist(IsNutritionistRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isNutritionist ?? false;
}

/// 是否是商家
@riverpod
bool isMerchant(IsMerchantRef ref) {
  return ref.watch(authControllerProvider).valueOrNull?.isMerchant ?? false;
}

/// 检查权限
@riverpod
bool hasPermission(HasPermissionRef ref, String permission) {
  return ref.watch(authControllerProvider).valueOrNull?.hasPermission(permission) ?? false;
}

// ===== 兼容旧接口 =====

/// 旧的 Provider 兼容层
final authStateProvider = Provider<AsyncValue<AuthState>>((ref) {
  return ref.watch(authControllerProvider);
});