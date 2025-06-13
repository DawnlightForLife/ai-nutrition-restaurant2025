import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 用户状态
class UserState {
  /// 用户ID
  final String? userId;
  
  /// 用户名
  final String? username;
  
  /// 手机号
  final String? phone;
  
  /// 头像
  final String? avatar;
  
  /// 是否已登录
  final bool isLoggedIn;
  
  /// 是否加载中
  final bool isLoading;
  
  /// 错误信息
  final String? error;

  /// 构造函数
  const UserState({
    this.userId,
    this.username,
    this.phone,
    this.avatar,
    this.isLoggedIn = false,
    this.isLoading = false,
    this.error,
  });

  /// 复制构造函数
  UserState copyWith({
    String? userId,
    String? username,
    String? phone,
    String? avatar,
    bool? isLoggedIn,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// 用户Notifier
class UserNotifier extends StateNotifier<UserState> {
  /// 构造函数
  UserNotifier() : super(const UserState());

  /// 登录
  Future<void> login(String phone, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: 实现登录逻辑
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        userId: '123456',
        username: '测试用户',
        phone: phone,
        avatar: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 退出登录
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: 实现退出登录逻辑
      await Future.delayed(const Duration(seconds: 1));
      
      state = const UserState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 修改密码
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // TODO: 实现修改密码逻辑
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
}

/// 用户Provider
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
}); 