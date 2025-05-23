import 'package:flutter/foundation.dart';
import '../../../domain/user/entities/user.dart';
import '../../../domain/abstractions/repositories/i_auth_repository.dart';

/// 认证状态
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// 认证Provider
class AuthProvider extends ChangeNotifier {
  final IAuthRepository _authRepository;
  
  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _errorMessage;
  
  AuthProvider({
    required IAuthRepository authRepository,
  }) : _authRepository = authRepository {
    _checkAuthStatus();
  }
  
  // Getters
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;
  
  /// 检查认证状态
  Future<void> _checkAuthStatus() async {
    _setStatus(AuthStatus.loading);
    
    final result = await _authRepository.getSignedInUser();
    
    result.fold(
      (failure) {
        _setStatus(AuthStatus.unauthenticated);
      },
      (user) {
        if (user != null) {
          _currentUser = user;
          _setStatus(AuthStatus.authenticated);
        } else {
          _setStatus(AuthStatus.unauthenticated);
        }
      },
    );
  }
  
  /// 登录
  Future<void> signIn({
    String? email,
    String? phone,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;
    
    final result = email != null
        ? await _authRepository.signInWithEmailAndPassword(
            email: email,
            password: password,
          )
        : await _authRepository.signInWithPhoneAndPassword(
            phone: phone!,
            password: password,
          );
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setStatus(AuthStatus.error);
      },
      (user) {
        _currentUser = user;
        _setStatus(AuthStatus.authenticated);
      },
    );
  }
  
  /// 手机验证码登录
  Future<void> signInWithPhoneCode({
    required String phone,
    required String code,
  }) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;
    
    final result = await _authRepository.signInWithPhoneAndCode(
      phone: phone,
      code: code,
    );
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setStatus(AuthStatus.error);
      },
      (user) {
        _currentUser = user;
        _setStatus(AuthStatus.authenticated);
      },
    );
  }
  
  /// 注册
  Future<void> signUp({
    required String email,
    required String phone,
    required String password,
    required String nickname,
  }) async {
    _setStatus(AuthStatus.loading);
    _errorMessage = null;
    
    final result = await _authRepository.signUp(
      email: email,
      phone: phone,
      password: password,
      nickname: nickname,
    );
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setStatus(AuthStatus.error);
      },
      (user) {
        _currentUser = user;
        _setStatus(AuthStatus.authenticated);
      },
    );
  }
  
  /// 发送验证码
  Future<bool> sendVerificationCode(String phone) async {
    final result = await _authRepository.sendVerificationCode(phone);
    
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) => true,
    );
  }
  
  /// 登出
  Future<void> signOut() async {
    _setStatus(AuthStatus.loading);
    
    final result = await _authRepository.signOut();
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _setStatus(AuthStatus.error);
      },
      (_) {
        _currentUser = null;
        _setStatus(AuthStatus.unauthenticated);
      },
    );
  }
  
  /// 清除错误信息
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _setStatus(
        _currentUser != null 
            ? AuthStatus.authenticated 
            : AuthStatus.unauthenticated,
      );
    }
  }
  
  /// 设置状态
  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }
}