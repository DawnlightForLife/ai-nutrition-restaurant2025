import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/dtos/user_model.dart';
import '../../../../shared/enums/user_role.dart';

part 'auth_controller.freezed.dart';
part 'auth_controller.g.dart';

/// 简化的 Auth 状态类
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    UserModel? user,
    String? token,
    String? error,
  }) = _AuthState;
}

/// 简化的 Auth 控制器
@riverpod
class AuthController extends _$AuthController {
  late final SharedPreferences _prefs;
  
  @override
  Future<AuthState> build() async {
    _prefs = await SharedPreferences.getInstance();
    
    // 检查是否有保存的登录状态
    final token = _prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      // TODO: 验证 token 并获取用户信息
      return AuthState(
        isAuthenticated: true,
        token: token,
        user: UserModel(
          id: '1',
          phone: '13800138000',
          nickname: '测试用户',
          role: UserRole.user,
        ),
      );
    }
    
    return const AuthState();
  }
  
  /// 模拟登录
  Future<void> mockLogin() async {
    state = const AsyncValue.loading();
    
    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(seconds: 1));
      
      final user = UserModel(
        id: '1',
        phone: '13800138000',
        nickname: '测试用户',
        role: UserRole.user,
        isProfileCompleted: true,
        createdAt: DateTime.now(),
      );
      
      const token = 'mock_token_123456';
      
      // 保存登录信息
      await _prefs.setString('auth_token', token);
      
      state = AsyncValue.data(AuthState(
        isAuthenticated: true,
        user: user,
        token: token,
      ));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// 登出
  Future<void> logout() async {
    await _prefs.remove('auth_token');
    state = const AsyncValue.data(AuthState());
  }
}