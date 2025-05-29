import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_user.dart';
import '../../../domain/abstractions/repositories/i_auth_repository.dart';

part 'auth_controller.freezed.dart';
part 'auth_controller.g.dart';

/// 认证状态
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    AuthUser? currentUser,
    String? errorMessage,
  }) = _AuthState;
}

/// 认证控制器 - 使用新的 AsyncNotifier 模式
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    // 在 build 方法中执行初始化逻辑
    final authRepository = ref.read(authRepositoryProvider);
    
    final result = await authRepository.getSignedInUser();
    
    return result.fold(
      (failure) => const AuthState(isAuthenticated: false),
      (user) => AuthState(
        isAuthenticated: user != null,
        currentUser: user,
      ),
    );
  }

  /// 登录
  Future<void> signIn({
    String? email,
    String? phone,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    
    final authRepository = ref.read(authRepositoryProvider);
    final result = email != null
        ? await authRepository.signInWithEmailAndPassword(
            email: email,
            password: password,
          )
        : await authRepository.signInWithPhoneAndPassword(
            phone: phone!,
            password: password,
          );
    
    state = await AsyncValue.guard(() async {
      return result.fold(
        (failure) => throw Exception(failure.message),
        (user) => AuthState(
          isAuthenticated: true,
          currentUser: user,
        ),
      );
    });
  }

  /// 手机验证码登录
  Future<void> signInWithPhoneCode({
    required String phone,
    required String code,
  }) async {
    state = const AsyncValue.loading();
    
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signInWithPhoneAndCode(
      phone: phone,
      code: code,
    );
    
    state = await AsyncValue.guard(() async {
      return result.fold(
        (failure) => throw Exception(failure.message),
        (user) => AuthState(
          isAuthenticated: true,
          currentUser: user,
        ),
      );
    });
  }

  /// 注册
  Future<void> signUp({
    required String email,
    required String phone,
    required String password,
    required String nickname,
  }) async {
    state = const AsyncValue.loading();
    
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signUp(
      email: email,
      phone: phone,
      password: password,
      nickname: nickname,
    );
    
    state = await AsyncValue.guard(() async {
      return result.fold(
        (failure) => throw Exception(failure.message),
        (user) => AuthState(
          isAuthenticated: true,
          currentUser: user,
        ),
      );
    });
  }

  /// 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.sendVerificationCode(phone);
    
    return result.fold(
      (failure) => false,
      (_) => true,
    );
  }

  /// 登出
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.signOut();
    
    state = await AsyncValue.guard(() async {
      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) => const AuthState(isAuthenticated: false),
      );
    });
  }

  /// 清除错误状态
  void clearError() {
    if (state.hasError) {
      final currentData = state.valueOrNull;
      if (currentData != null) {
        state = AsyncValue.data(currentData);
      } else {
        state = const AsyncValue.data(AuthState());
      }
    }
  }
}

/// 认证仓储 Provider（需要实现）
@riverpod
IAuthRepository authRepository(AuthRepositoryRef ref) {
  throw UnimplementedError('需要实现 IAuthRepository 的具体实现');
}

/// 便捷的认证状态访问器
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.valueOrNull?.isAuthenticated ?? false;
}

@riverpod
AuthUser? currentUser(CurrentUserRef ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.valueOrNull?.currentUser;
}