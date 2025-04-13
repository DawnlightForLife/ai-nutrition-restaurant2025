import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/core/auth_service.dart';
import 'dart:async';

/**
 * 身份验证状态管理提供者
 * 
 * 负责管理用户的登录状态和身份验证信息，提供以下功能：
 * 1. 登录/注册/登出功能
 * 2. Token的存储和验证
 * 3. 用户基本信息的存储和读取
 * 4. 记住登录状态的持久化
 * 5. 密码重置流程
 * 
 * 该类使用ChangeNotifier实现，可以通过Provider在整个应用中共享认证状态
 */
class AuthProvider with ChangeNotifier {
  /// 本地存储键名常量，用于SharedPreferences
  /// 这些键用于在设备本地持久化存储用户的认证信息
  static const String _tokenKey = 'auth_token'; // 存储认证令牌的键
  static const String _userIdKey = 'userId'; // 存储用户ID的键
  static const String _userPhoneKey = 'user_phone'; // 存储用户手机号的键
  static const String _usernameKey = 'username'; // 存储用户名的键
  static const String _nicknameKey = 'nickname'; // 存储用户昵称的键
  static const String _userAvatarKey = 'user_avatar'; // 存储用户头像URL的键

  /// 用户认证信息
  /// 这些变量存储当前登录用户的核心信息，用于验证身份和个性化功能
  String? _token; // 认证令牌，用于API请求认证
  String? _userId; // 用户ID，系统内部唯一标识符
  String? _phone; // 用户手机号，用于登录和找回密码
  String? _username; // 用户名，可用于登录的用户标识
  String? _nickname; // 用户昵称，用于显示和社交功能
  String? _avatar; // 用户头像URL，用于UI显示

  /// 状态标志
  /// 这些变量跟踪认证过程中的各种状态
  bool _isCodeLogin = true; // 登录方式标志：true=验证码登录，false=密码登录
  bool _isInitialized = false; // 是否已完成初始化，从本地存储加载完成用户状态
  bool _isLoading = false; // 是否正在加载中，如正在请求API或处理认证
  bool _isResetting = false; // 是否正在重设密码，标识密码重置流程的状态

  /**
   * 获取当前认证令牌
   * 
   * token是与服务器通信的凭证，所有需要认证的API请求都需要携带
   * 
   * @return 认证令牌，未登录时为null
   */
  String? get token => _token;

  /**
   * 获取当前登录用户ID
   * 
   * 用户ID是系统内唯一标识用户的标识符，用于关联用户数据
   * 
   * @return 用户ID，未登录时为null
   */
  String? get userId => _userId;

  /**
   * 获取用户手机号
   * 
   * 手机号是用户的主要登录凭证之一，也用于找回密码
   * 
   * @return 用户手机号，未登录时为null
   */
  String? get phone => _phone;

  /**
   * 获取用户名
   * 
   * 用户名是用户在系统中的标识，可用于登录
   * 
   * @return 用户名，未设置或未登录时为null
   */
  String? get username => _username;

  /**
   * 获取用户昵称
   * 
   * 昵称用于在UI中显示，通常是用户的可读标识
   * 
   * @return 用户昵称，未设置或未登录时为null
   */
  String? get nickname => _nickname;

  /**
   * 获取用户头像URL
   * 
   * 头像URL指向用户的头像图片，用于UI中显示
   * 
   * @return 头像URL，未设置或未登录时为null
   */
  String? get avatar => _avatar;

  /**
   * 判断用户是否已登录
   * 
   * 通过检查token是否存在来确定用户是否已登录
   * 这是一个便捷方法，用于UI和路由决策
   * 
   * @return 如果用户已登录(token不为null)则返回true，否则返回false
   */
  bool get isAuthenticated => _token != null;

  /**
   * 判断认证提供者是否已初始化
   * 
   * 初始化过程包括从本地存储加载用户登录状态
   * 在应用启动时需等待初始化完成后再决定导航逻辑
   * 
   * @return 如果已初始化则返回true，否则返回false
   */
  bool get isInitialized => _isInitialized;

  /**
   * 判断是否有认证相关操作正在进行中
   * 
   * 用于控制UI中加载状态的显示
   * 
   * @return 如果正在加载中则返回true，否则返回false
   */
  bool get isLoading => _isLoading;

  /**
   * 判断是否正在进行密码重设操作
   * 
   * 用于跟踪密码重置流程的状态
   * 
   * @return 如果正在重设密码则返回true，否则返回false
   */
  bool get isResetting => _isResetting;

  /**
   * 获取当前选择的登录方式
   * 
   * 用于UI显示不同的登录表单（密码输入框或验证码输入框）
   * 
   * @return true表示使用验证码登录，false表示使用密码登录
   */
  bool get isCodeLogin => _isCodeLogin;

  /**
   * 设置登录方式
   * 
   * 切换验证码登录和密码登录两种方式
   * 由登录页面中的切换按钮触发
   * 
   * @param isCodeLogin true表示使用验证码登录，false表示使用密码登录
   */
  void setLoginMethod(bool isCodeLogin) {
    _isCodeLogin = isCodeLogin;
    notifyListeners(); // 通知UI状态已更新
  }

  /**
   * 用户登录
   * 
   * 保存token和用户信息到内存和本地存储，并通知监听者状态变化
   * 这个方法在用户成功进行账号验证后调用
   * 
   * @param token     认证令牌，必须提供
   * @param userId    用户ID，可选
   * @param phone     用户手机号，可选
   * @param username  用户名，可选
   * @param nickname  用户昵称，可选 
   * @param avatar    用户头像URL，可选
   */
  Future<void> login(String token,
      {String? userId,
      String? phone,
      String? username,
      String? nickname,
      String? avatar}) async {
    _setLoading(true);

    try {
      _token = token;

      // 如果提供了其他用户信息，也一并保存
      if (userId != null && userId.isNotEmpty) _userId = userId;
      if (phone != null && phone.isNotEmpty) _phone = phone;
      if (username != null) _username = username;
      if (nickname != null) _nickname = nickname;
      if (avatar != null) _avatar = avatar;

      // 保存信息到本地存储，实现记住登录状态
      await _saveToPrefs();

      _setLoading(false);
      notifyListeners(); // 通知UI用户已登录
    } catch (e) {
      _setLoading(false);
      rethrow; // 抛出异常便于上层处理
    }
  }

  /**
   * 注册并自动登录
   * 
   * 调用注册接口，成功后自动进行登录，简化用户注册后的登录流程
   * 整合了注册和登录的过程，提供更流畅的用户体验
   * 
   * @param authService 认证服务实例，用于调用注册接口
   * @param phone       用户手机号
   * @param password    密码
   * @param code        验证码
   * @param nickname    用户昵称，可选
   * @param context     构建上下文，用于显示错误信息，可选
   */
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
      // 调用认证服务进行注册
      final token = await authService.register(
        phone: phone,
        password: password,
        code: code,
        nickname: nickname,
        context: context,
      );

      // 注册成功后自动登录，复用登录逻辑
      await login(token, phone: phone, nickname: nickname);

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      rethrow; // 抛出异常便于上层处理
    }
  }

  /**
   * 发送重置密码验证码
   * 
   * 向指定手机号发送重置密码的验证码
   * 
   * @param authService 认证服务实例，用于调用发送验证码接口
   * @param phone       接收验证码的手机号
   * @param context     构建上下文，用于显示错误或成功消息，可选
   * @return 发送成功返回true，如果处于冷却期则返回false
   */
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
      rethrow; // 抛出异常便于上层处理
    }
  }

  /**
   * 重置密码
   * 
   * 使用验证码验证身份并设置新密码
   * 
   * @param authService 认证服务实例，用于调用重置密码接口
   * @param phone       用户手机号
   * @param code        收到的验证码
   * @param newPassword 新的密码
   * @param context     构建上下文，用于显示错误或成功消息，可选
   * @return 重置成功返回true，否则返回false
   */
  Future<bool> resetPassword({
    required AuthService authService,
    required String phone,
    required String code,
    required String newPassword,
    BuildContext? context,
  }) async {
    _setResetting(true);

    try {
      final result = await authService.resetPassword(phone, code, newPassword,
          context: context);
      _setResetting(false);
      return result;
    } catch (e) {
      _setResetting(false);
      rethrow; // 抛出异常便于上层处理
    }
  }

  /**
   * 用户登出
   * 
   * 清除内存和本地存储中的token和用户信息，并通知监听者状态变化
   */
  Future<void> logout() async {
    _setLoading(true);

    try {
      // 清除内存中的用户信息
      _token = null;
      _userId = null;
      _phone = null;
      _username = null;
      _nickname = null;
      _avatar = null;

      // 从本地存储删除信息，确保下次启动时不会自动登录
      await _clearPrefs();

      _setLoading(false);
      notifyListeners(); // 通知UI用户已登出
    } catch (e) {
      _setLoading(false);
      rethrow; // 抛出异常便于上层处理
    }
  }

  /**
   * 检查身份验证状态
   * 
   * 应用启动时从本地存储读取token和用户信息，实现记住登录状态的功能
   * 如果提供了认证服务实例，还会验证token的有效性，并在无效时尝试刷新
   * 
   * @param authService 认证服务实例，用于验证token有效性，可选
   * @return 用户已登录且token有效返回true，否则返回false
   */
  Future<bool> checkAuth({AuthService? authService}) async {
    // 如果已初始化，直接返回当前登录状态
    if (_isInitialized) return isAuthenticated;

    _setLoading(true);

    try {
      // 从本地存储读取用户信息和token
      await _loadFromPrefs();
      _isInitialized = true;

      // 如果没有找到token，直接返回未认证状态
      if (_token == null) {
        _setLoading(false);
        return false;
      }

      // 如果提供了authService，验证token有效性
      if (authService != null) {
        final isValid = await authService.validateToken(_token ?? "");

        if (!isValid) {
          try {
            // 尝试刷新token
            debugPrint('Token无效，尝试刷新...');
            if (_token != null) {
              final newToken = await authService.refreshToken(_token!);

              if (newToken != null) {
                // 刷新成功，更新token
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
            }
          } catch (e) {
            // 刷新token出错，使用当前token继续
            debugPrint('刷新Token时出错: $e，继续使用当前token');
            // 仍然保持登录状态，这样用户可以继续使用，直到服务器明确拒绝请求
          }
        }
      }

      _setLoading(false);
      notifyListeners(); // 通知UI登录状态可能已改变
      return isAuthenticated;
    } catch (e) {
      debugPrint('检查认证状态失败: $e');
      _setLoading(false);
      return false;
    }
  }

  /**
   * 更新用户信息
   * 
   * 允许在不重新登录的情况下更新用户的基本信息
   * 只有当信息发生变化时才会进行更新和通知
   * 
   * @param userId   用户ID，可选
   * @param phone    用户手机号，可选
   * @param username 用户名，可选
   * @param nickname 用户昵称，可选
   * @param avatar   用户头像URL，可选
   */
  Future<void> updateUserInfo(
      {String? userId,
      String? phone,
      String? username,
      String? nickname,
      String? avatar}) async {
    bool hasChanges = false;

    // 检查每个字段是否有变化
    if (userId != null && userId != _userId) {
      _userId = userId;
      hasChanges = true;
    }

    if (phone != null && phone != _phone) {
      _phone = phone;
      hasChanges = true;
    }

    if (username != null && username != _username) {
      _username = username;
      hasChanges = true;
    }

    if (nickname != null && nickname != _nickname) {
      _nickname = nickname;
      hasChanges = true;
    }

    if (avatar != null && avatar != _avatar) {
      _avatar = avatar;
      hasChanges = true;
    }

    // 只有在信息有变化时才保存和通知
    if (hasChanges) {
      await _saveToPrefs();
      notifyListeners(); // 通知UI用户信息已更新
    }
  }

  /**
   * 设置加载状态
   * 
   * 内部方法，用于更新加载状态并通知UI
   * 
   * @param loading 新的加载状态
   */
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); // 通知UI加载状态已更改
  }

  /**
   * 设置重设密码状态
   * 
   * 内部方法，用于更新重设密码状态并通知UI
   * 
   * @param resetting 新的重设密码状态
   */
  void _setResetting(bool resetting) {
    _isResetting = resetting;
    notifyListeners(); // 通知UI重设密码状态已更改
  }

  /**
   * 保存所有用户信息到本地存储
   * 
   * 内部方法，将当前内存中的用户信息保存到SharedPreferences
   */
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // 只保存非空值
    if (_token != null) await prefs.setString(_tokenKey, _token!);
    if (_userId != null) await prefs.setString(_userIdKey, _userId!);
    if (_phone != null) await prefs.setString(_userPhoneKey, _phone!);
    if (_username != null) await prefs.setString(_usernameKey, _username!);
    if (_nickname != null) await prefs.setString(_nicknameKey, _nickname!);
    if (_avatar != null) await prefs.setString(_userAvatarKey, _avatar!);
  }

  /**
   * 仅保存token到本地存储
   * 
   * 内部方法，当只需要更新token时使用，避免读取其他信息的开销
   * 
   * @param token 要保存的认证令牌
   */
  Future<void> _saveTokenToPrefs(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /**
   * 从本地存储清除所有用户信息
   * 
   * 内部方法，用于登出时清除SharedPreferences中的用户数据
   */
  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // 移除所有与用户相关的存储项
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_nicknameKey);
    await prefs.remove(_userAvatarKey);
  }

  /**
   * 从本地存储加载用户信息
   * 
   * 内部方法，用于应用启动时从SharedPreferences读取用户数据
   */
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // 读取所有用户相关的存储项
    _token = prefs.getString(_tokenKey);
    _userId = prefs.getString(_userIdKey);
    _phone = prefs.getString(_userPhoneKey);
    _username = prefs.getString(_usernameKey);
    _nickname = prefs.getString(_nicknameKey);
    _avatar = prefs.getString(_userAvatarKey);
  }
}
