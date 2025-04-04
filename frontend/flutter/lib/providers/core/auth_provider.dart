import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/core/auth_service.dart';
import 'dart:async';

/// 身份验证提供者
///
/// 管理用户的登录状态和身份验证令牌
class AuthProvider with ChangeNotifier {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userPhoneKey = 'user_phone';
  static const String _usernameKey = 'username';  // 用户名
  static const String _nicknameKey = 'nickname';  // 用户昵称
  static const String _userAvatarKey = 'user_avatar';
  
  String? _token;
  String? _userId;
  String? _phone;
  String? _username;  // 用户名
  String? _nickname;  // 用户昵称
  String? _avatar;
  bool _isCodeLogin = true; // 默认使用验证码登录
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _isResetting = false; // 是否正在重设密码

  /// 获取当前token
  String? get token => _token;
  
  /// 获取用户ID
  String? get userId => _userId;
  
  /// 获取用户手机号
  String? get phone => _phone;
  
  /// 获取用户名
  String? get username => _username;  // 用户名
  
  /// 获取用户昵称
  String? get nickname => _nickname;  // 用户昵称
  
  /// 获取用户头像
  String? get avatar => _avatar;

  /// 判断用户是否已登录
  bool get isAuthenticated => _token != null;
  
  /// 获取是否已初始化
  bool get isInitialized => _isInitialized;
  
  /// 获取是否正在加载中
  bool get isLoading => _isLoading;
  
  /// 获取是否正在重设密码
  bool get isResetting => _isResetting;

  /// 获取当前登录方式是否为验证码登录
  bool get isCodeLogin => _isCodeLogin;

  /// 设置登录方式
  void setLoginMethod(bool isCodeLogin) {
    _isCodeLogin = isCodeLogin;
    notifyListeners();
  }

  /// 用户登录
  ///
  /// 保存token和用户信息并通知监听者状态变化
  Future<void> login(String token, {
    String? userId, 
    String? phone, 
    String? username,  // 用户名
    String? nickname,  // 用户昵称
    String? avatar
  }) async {
    _setLoading(true);
    
    try {
      _token = token;
      
      // 如果提供了其他用户信息，也一并保存
      if (userId != null && userId.isNotEmpty) _userId = userId;
      if (phone != null && phone.isNotEmpty) _phone = phone;
      if (username != null) _username = username;  // 用户名
      if (nickname != null) _nickname = nickname;  // 用户昵称
      if (avatar != null) _avatar = avatar;
      
      // 保存信息到本地存储
      await _saveToPrefs();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }
  
  /// 注册并自动登录
  ///
  /// 注册成功后自动登录并通知监听者状态变化
  Future<void> registerAndLogin({
    required AuthService authService,
    required String phone,
    required String password,
    required String code,
    String? nickname,
    BuildContext? context,
  }) async {
    _setLoading(true);
    
    try {
      // 调用注册接口
      final token = await authService.register(
        phone: phone,
        password: password,
        code: code,
        nickname: nickname,
        context: context,
      );
      
      // 注册成功后自动登录
      await login(token, phone: phone, nickname: nickname);
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }
  
  /// 发送重置密码验证码
  ///
  /// 成功返回true，冷却中返回false
  Future<bool> sendResetCode({
    required AuthService authService,
    required String phone,
    BuildContext? context,
  }) async {
    _setLoading(true);
    
    try {
      final result = await authService.sendResetCode(phone, context: context);
      _setLoading(false);
      return result;
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }
  
  /// 重置密码
  ///
  /// 成功返回true
  Future<bool> resetPassword({
    required AuthService authService,
    required String phone,
    required String code,
    required String newPassword,
    BuildContext? context,
  }) async {
    _setResetting(true);
    
    try {
      final result = await authService.resetPassword(
        phone, 
        code, 
        newPassword, 
        context: context
      );
      _setResetting(false);
      return result;
    } catch (e) {
      _setResetting(false);
      rethrow;
    }
  }

  /// 用户登出
  ///
  /// 清除token和用户信息并通知监听者状态变化
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      _token = null;
      _userId = null;
      _phone = null;
      _username = null;
      _nickname = null;
      _avatar = null;
      
      // 从本地存储删除信息
      await _clearPrefs();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  /// 检查身份验证状态
  ///
  /// 应用启动时从本地存储读取token和用户信息
  Future<bool> checkAuth({AuthService? authService}) async {
    if (_isInitialized) return isAuthenticated;
    
    _setLoading(true);
    
    try {
      // 从本地存储读取信息
      await _loadFromPrefs();
      _isInitialized = true;
      
      // 如果没有token，直接返回未认证状态
      if (_token == null) {
        _setLoading(false);
        return false;
      }
      
      // 如果提供了authService，验证token有效性
      if (authService != null) {
        final isValid = await authService.validateToken();
        
        if (!isValid) {
          try {
            // 尝试刷新token
            debugPrint('Token无效，尝试刷新...');
            final newToken = await authService.refreshToken(_token);
            
            if (newToken != null) {
              // 更新token
              debugPrint('Token刷新成功，新token长度: ${newToken.length}');
              _token = newToken;
              await _saveToPrefs();
            } else {
              // token刷新失败，清除登录状态
              debugPrint('Token刷新失败，清除登录状态');
              await logout();
              _setLoading(false);
              return false;
            }
          } catch (e) {
            // 刷新token出错，使用当前token继续
            debugPrint('刷新Token时出错: $e，继续使用当前token');
            // 仍然保持登录状态，这样用户可以继续使用，直到服务器明确拒绝请求
          }
        }
      }
      
      _setLoading(false);
      notifyListeners();
      return isAuthenticated;
    } catch (e) {
      debugPrint('检查认证状态失败: $e');
      _setLoading(false);
      return false;
    }
  }
  
  /// 更新用户信息
  Future<void> updateUserInfo({String? userId, String? phone, String? username, String? nickname, String? avatar}) async {
    bool hasChanges = false;
    
    if (userId != null && userId != _userId) {
      _userId = userId;
      hasChanges = true;
    }
    
    if (phone != null && phone != _phone) {
      _phone = phone;
      hasChanges = true;
    }
    
    if (username != null && username != _username) {
      _username = username;  // 用户名
      hasChanges = true;
    }
    
    if (nickname != null && nickname != _nickname) {
      _nickname = nickname;  // 用户昵称
      hasChanges = true;
    }
    
    if (avatar != null && avatar != _avatar) {
      _avatar = avatar;
      hasChanges = true;
    }
    
    if (hasChanges) {
      await _saveToPrefs();
      notifyListeners();
    }
  }
  
  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  /// 设置重设密码状态
  void _setResetting(bool resetting) {
    _isResetting = resetting;
    notifyListeners();
  }
  
  /// 保存所有信息到本地存储
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_token != null) await prefs.setString(_tokenKey, _token!);
    if (_userId != null) await prefs.setString(_userIdKey, _userId!);
    if (_phone != null) await prefs.setString(_userPhoneKey, _phone!);
    if (_username != null) await prefs.setString(_usernameKey, _username!);  // 用户名
    if (_nickname != null) await prefs.setString(_nicknameKey, _nickname!);  // 用户昵称
    if (_avatar != null) await prefs.setString(_userAvatarKey, _avatar!);
  }
  
  /// 仅保存token到本地存储
  Future<void> _saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }
  
  /// 从本地存储清除所有信息
  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_nicknameKey);
    await prefs.remove(_userAvatarKey);
  }

  /// 从本地存储加载信息
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    _token = prefs.getString(_tokenKey);
    _userId = prefs.getString(_userIdKey);
    _phone = prefs.getString(_userPhoneKey);
    _username = prefs.getString(_usernameKey);  // 用户名
    _nickname = prefs.getString(_nicknameKey);  // 用户昵称
    _avatar = prefs.getString(_userAvatarKey);
  }
}
