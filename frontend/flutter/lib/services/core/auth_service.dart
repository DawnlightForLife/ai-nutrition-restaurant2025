import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../services/api_service.dart';
import '../../utils/global_error_handler.dart';
import 'package:flutter/material.dart';
import '../../providers/core/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;
import 'dart:convert';
import 'dart:typed_data';

/**
 * 身份验证服务
 * 
 * 负责处理应用中所有与身份验证相关的网络请求和本地存储操作，包括：
 * 1. 用户登录（验证码和密码两种方式）
 * 2. 用户注册
 * 3. 发送验证码
 * 4. 密码重置
 * 5. Token管理（获取、验证、刷新）
 * 6. 用户信息获取
 * 
 * 该服务与后端API通信，同时管理本地的Token存储，确保用户会话的持续性。
 */
class AuthService {
  /// API服务，用于向后端发送HTTP请求
  final ApiService _apiService;
  
  /// 全局错误处理器，用于统一处理和显示认证相关错误
  final GlobalErrorHandler _errorHandler = GlobalErrorHandler();
  
  /// 本地存储，用于持久化保存Token等认证信息
  prefs.SharedPreferences? _prefs;
  
  /// 本地存储键名常量
  /// 用于存取认证相关的持久化数据
  static const String _tokenKey = 'auth_token';         // 访问令牌键名
  static const String _refreshTokenKey = 'refresh_token'; // 刷新令牌键名
  
  /// 防止重复发送验证码的冷却时间管理
  /// 记录上次发送时间，确保用户不能频繁请求验证码
  DateTime? _lastSentTime;           // 上次发送登录/注册验证码的时间
  DateTime? _lastResetCodeSentTime;  // 上次发送重置密码验证码的时间
  static const int _codeCooldownSeconds = 60;  // 验证码冷却时间（秒）
  
  /**
   * 构造函数
   * 
   * 创建一个身份验证服务实例，需要提供API服务
   * 可选提供一个预先初始化的SharedPreferences实例
   * 
   * @param _apiService API服务实例，用于发送HTTP请求
   * @param _prefs 可选的SharedPreferences实例，用于本地存储
   */
  AuthService(this._apiService, [this._prefs]);
  
  /**
   * 初始化服务
   * 
   * 如果没有提供SharedPreferences实例，则尝试初始化一个
   * 该方法在使用涉及本地存储的功能之前应该被调用
   * 初始化成功后才能进行Token的读取和存储操作
   */
  Future<void> init() async {
    if (_prefs == null) {
      try {
        _prefs = await prefs.SharedPreferences.getInstance();
        debugPrint('AuthService.init: SharedPreferences初始化成功');
      } catch (e) {
        debugPrint('AuthService.init: 初始化SharedPreferences失败 - $e');
      }
    }
  }
  
  /**
   * 使用验证码登录
   * 
   * 通过手机号和验证码进行登录，成功后返回包含用户信息的Map
   * 这是一种无需密码的登录方式，用户通过手机收到的验证码完成身份验证
   * 登录成功时会自动保存Token到本地存储
   * 
   * @param phone 用户手机号，用于识别用户身份
   * @param code 接收到的验证码，用于验证用户身份
   * @param context 可选的构建上下文，用于显示错误消息
   * @return 包含用户信息和Token的Map
   * @throws Exception 登录失败时抛出异常，包含错误信息
   */
  Future<Map<String, dynamic>> loginWithCode(String phone, String code, {BuildContext? context}) async {
    try {
      // 发送验证码登录请求
      final response = await _apiService.post(
        '/api/users/login/code',
        data: {
          'phone': phone,
          'code': code,
        },
      );
      
      debugPrint('登录响应: $response');  // 添加调试日志
      
      // 检查登录是否成功
      if (response['success'] == true && response['token'] != null) {
        // 立即保存token到本地存储
        await setToken(response['token']);
        
        // 提取用户信息，如果某些字段不存在则使用默认值
        final user = response['user'] ?? {};
        return {
          'token': response['token'],
          'userId': user['userId'] ?? '',
          'phone': user['phone'] ?? phone,
          'username': user['username'] ?? '',
          'nickname': user['nickname'] ?? '',
          'avatar': user['avatar'] ?? '',
        };
      } else {
        // 登录失败，抛出异常
        final message = response['message'] ?? '登录失败：未获取到有效的token';
        throw Exception(message);
      }
    } catch (e) {
      // 记录错误并显示给用户
      debugPrint('登录失败: $e');
      if (context != null) {
        _errorHandler.handleAuthError(context, e);
      }
      rethrow;  // 抛出原始错误，而不是包装成新的异常
    }
  }
  
  /**
   * 使用密码登录
   * 
   * 通过手机号和密码进行登录，成功后返回包含用户信息的Map
   * 这是传统的账号密码登录方式，用户凭借手机号和设置的密码完成身份验证
   * 登录成功时会自动保存Token到本地存储
   * 
   * @param phone 用户手机号，用作账号标识
   * @param password 用户密码，用于身份验证
   * @param context 可选的构建上下文，用于显示错误消息
   * @return 包含用户信息和Token的Map
   * @throws Exception 登录失败时抛出异常，包含错误信息
   */
  Future<Map<String, dynamic>> loginWithPassword(String phone, String password, {BuildContext? context}) async {
    try {
      // 发送密码登录请求
      final response = await _apiService.post(
        '/api/users/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );
      
      debugPrint('登录响应: $response');  // 添加调试日志
      
      // 检查登录是否成功
      if (response['success'] == true && response['token'] != null) {
        // 立即保存token到本地存储
        await setToken(response['token']);
        
        // 提取用户信息，如果某些字段不存在则使用默认值
        final user = response['user'] ?? {};
        return {
          'token': response['token'],
          'userId': user['userId'] ?? '',
          'phone': user['phone'] ?? phone,
          'username': user['username'] ?? '',
          'nickname': user['nickname'] ?? '',
          'avatar': user['avatar'] ?? '',
        };
      } else {
        // 登录失败，抛出异常
        final message = response['message'] ?? '登录失败：未获取到有效的token';
        throw Exception(message);
      }
    } catch (e) {
      // 记录错误并显示给用户
      debugPrint('登录失败: $e');
      if (context != null) {
        _errorHandler.handleAuthError(context, e);
      }
      rethrow;  // 抛出原始错误，而不是包装成新的异常
    }
  }

  /**
   * 注册新用户
   * 
   * 使用手机号、密码和验证码注册新账户，成功后返回Token
   * 完成注册的同时完成登录，无需用户注册后再单独登录
   * 必须先调用sendCode获取验证码才能注册
   * 
   * @param phone 用户手机号，将作为主要的登录凭证
   * @param password 用户密码，用于后续的密码登录
   * @param code 验证码，验证手机号所有权
   * @param username 可选的用户名，用于显示和登录
   * @param nickname 可选的用户昵称，用于显示
   * @param context 可选的构建上下文，用于显示错误消息
   * @return 注册成功后的Token字符串
   * @throws Exception 注册失败时抛出异常，包含错误信息
   */
  Future<String> register({
    required String phone, 
    required String password, 
    required String code, 
    String? username,
    String? nickname,
    BuildContext? context
  }) async {
    try {
      // 准备注册数据
      final data = {
        'phone': phone,
        'password': password,
        'code': code,
      };
      
      // 添加可选的用户名
      if (username != null && username.isNotEmpty) {
        data['username'] = username;
      }
      
      // 添加可选的昵称
      if (nickname != null && nickname.isNotEmpty) {
        data['nickname'] = nickname;
      }
      
      // 发送注册请求
      final response = await _apiService.post(
        '/api/users/register',
        data: data,
      );
      
      // 检查注册是否成功
      if (response.containsKey('token')) {
        return response['token'];
      } else if (response.containsKey('message')) {
        throw Exception('注册失败：${response['message']}');
      } else {
        throw Exception('注册失败：未获取到有效的token');
      }
    } catch (e) {
      // 记录错误并显示给用户
      debugPrint('注册失败: $e');
      if (context != null) {
        _errorHandler.handleAuthError(context, e, operation: '注册');
      }
      throw Exception('注册失败：${e.toString()}');
    }
  }

  /**
   * 发送手机验证码（用于登录和注册）
   * 
   * 向指定手机号发送验证码，有冷却时间限制
   * 
   * @param phone 接收验证码的手机号
   * @param context 可选的构建上下文，用于显示错误消息
   * @return 发送成功返回true，如果在冷却期内则返回false
   * @throws Exception 发送失败时抛出异常
   */
  Future<bool> sendVerificationCode(String phone, {BuildContext? context}) async {
    // 检查是否在冷却期内
    if (_lastSentTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_lastSentTime!).inSeconds;
      
      if (difference < _codeCooldownSeconds) {
        return false; // 仍在冷却期内，不发送新验证码
      }
    }
    
    try {
      // 发送获取验证码请求
      await _apiService.post(
        '/api/users/send-code',
        data: {'phone': phone},
      );
      
      // 记录发送时间，用于冷却期判断
      _lastSentTime = DateTime.now();
      return true;
    } catch (e) {
      // 记录错误并显示给用户
      debugPrint('发送验证码失败: $e');
      if (context != null) {
        _errorHandler.handleNetworkError(context, e, operation: '发送验证码');
      }
      throw Exception('发送验证码失败：${e.toString()}');
    }
  }
  
  /**
   * 发送重置密码验证码
   * 
   * 向指定手机号发送用于重置密码的验证码，有冷却时间限制
   * 
   * @param phone 接收验证码的手机号
   * @param context 可选的构建上下文，用于显示错误消息
   * @return 发送成功返回true，如果在冷却期内则返回false
   * @throws Exception 发送失败时抛出异常
   */
  Future<bool> sendResetCode(String phone, {BuildContext? context}) async {
    // 检查是否在冷却期内
    if (_lastResetCodeSentTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_lastResetCodeSentTime!).inSeconds;
      
      if (difference < _codeCooldownSeconds) {
        return false; // 仍在冷却期内，不发送新验证码
      }
    }
    
    try {
      // 发送重置密码验证码请求
      await _apiService.post(
        '/api/users/send-reset-code',
        data: {'phone': phone},
      );
      
      // 记录发送时间，用于冷却期判断
      _lastResetCodeSentTime = DateTime.now();
      return true;
    } catch (e) {
      // 记录错误并显示给用户
      debugPrint('发送重置密码验证码失败: $e');
      if (context != null) {
        _errorHandler.handleNetworkError(context, e, operation: '发送重置验证码');
      }
      throw Exception('发送重置密码验证码失败：${e.toString()}');
    }
  }
  
  /**
   * 重置密码
   * 
   * 使用手机号、验证码和新密码来重置用户密码
   * 
   * @param phone 用户手机号
   * @param code 验证码
   * @param newPassword 新密码
   * @param context 可选的构建上下文，用于显示错误消息
   * @return 重置成功返回true
   * @throws Exception 重置失败时抛出异常
   */
  Future<bool> resetPassword(String phone, String code, String newPassword, {BuildContext? context}) async {
    try {
      // 发送重置密码请求
      final response = await _apiService.post(
        '/api/users/reset-password', // 使用正确的API端点
        data: {
          'phone': phone,
          'code': code,
          'newPassword': newPassword,
        },
      );
      
      // 处理后端返回的响应
      if (response.containsKey('success') && response['success'] == true) {
        return true;
      } else if (response.containsKey('message')) {
        throw Exception('重置密码失败：${response['message']}');
      } else {
        throw Exception('重置密码失败：未知错误');
      }
    } catch (e) {
      // 记录错误并显示给用户
      debugPrint('重置密码失败: $e');
      if (context != null) {
        _errorHandler.handleAuthError(context, e, operation: '重置密码');
      }
      // 抛出异常，不应该返回true表示成功
      throw Exception('重置密码失败：${e.toString()}'); 
    }
  }
  
  /**
   * 获取验证码剩余冷却时间（秒）
   * 
   * 计算登录/注册验证码的剩余冷却时间
   * 
   * @return 剩余冷却时间（秒），如果不在冷却期则返回0
   */
  int getRemainingCooldownSeconds() {
    if (_lastSentTime == null) {
      return 0;
    }
    
    final now = DateTime.now();
    final difference = now.difference(_lastSentTime!).inSeconds;
    final remaining = _codeCooldownSeconds - difference;
    
    return remaining > 0 ? remaining : 0;
  }

  /**
   * 获取重置密码验证码剩余冷却时间（秒）
   * 
   * 计算重置密码验证码的剩余冷却时间
   * 
   * @return 剩余冷却时间（秒），如果不在冷却期则返回0
   */
  int getResetCodeRemainingCooldownSeconds() {
    if (_lastResetCodeSentTime == null) {
      return 0;
    }
    
    final now = DateTime.now();
    final difference = now.difference(_lastResetCodeSentTime!).inSeconds;
    final remaining = _codeCooldownSeconds - difference;
    
    return remaining > 0 ? remaining : 0;
  }
  
  /**
   * 退出登录
   * 
   * 清除用户登录状态，包括本地存储的Token和Provider中的状态
   * 
   * @param context 构建上下文，用于访问Provider和显示错误消息
   * @throws Exception 退出失败时抛出异常
   */
  Future<void> logout(BuildContext context) async {
    try {
      // 这里可以添加实际的退出登录API调用，例如：
      // await _apiService.post('/api/auth/logout');
      
      // 通过AuthProvider清除本地token和登录状态
      await Provider.of<AuthProvider>(context, listen: false).logout();
      
    } catch (e) {
      debugPrint('退出登录失败: $e');
      _errorHandler.handleNetworkError(context, e, operation: '退出登录');
      throw Exception('退出登录失败：${e.toString()}');
    }
  }
  
  /**
   * 获取当前用户Token（内存中）
   * 
   * 用于快速获取Token，不访问本地存储
   * 
   * @return 当前Token，如果SharedPreferences未初始化则返回null
   */
  String? getCurrentToken() {
    // 在没有SharedPreferences时直接返回null
    return null;
  }

  /**
   * 从本地存储获取Token
   * 
   * 从SharedPreferences中读取存储的Token
   * 
   * @return 存储的Token，如果不存在则返回null
   */
  Future<String?> getToken() async {
    if (_prefs == null) {
      debugPrint('AuthService.getToken: SharedPreferences未初始化');
      // 尝试初始化
      await init();
      if (_prefs == null) {
        return null;
      }
    }
    
    final token = _prefs!.getString(_tokenKey);
    debugPrint('AuthService.getToken: ${token != null ? "Token已获取" : "Token为空"}');
    return token;
  }

  /**
   * 保存Token到本地存储
   * 
   * 将Token保存到SharedPreferences中
   * 
   * @param token 要保存的Token
   */
  Future<void> setToken(String token) async {
    if (_prefs == null) return;
    await _prefs!.setString(_tokenKey, token);
  }

  /**
   * 从本地存储获取刷新Token
   * 
   * 从SharedPreferences中读取存储的刷新Token
   * 
   * @return 存储的刷新Token，如果不存在则返回null
   */
  Future<String?> getRefreshToken() async {
    if (_prefs == null) return null;
    return _prefs!.getString(_refreshTokenKey);
  }

  /**
   * 保存刷新Token到本地存储
   * 
   * 将刷新Token保存到SharedPreferences中
   * 
   * @param token 要保存的刷新Token
   */
  Future<void> setRefreshToken(String token) async {
    if (_prefs == null) return;
    await _prefs!.setString(_refreshTokenKey, token);
  }

  /**
   * 验证令牌是否有效
   * 
   * 通过API调用验证当前Token是否仍然有效
   * 
   * @param token 可选的Token，如果不提供则从本地存储读取
   * @return Token有效返回true，否则返回false
   */
  Future<bool> validateToken([String? token]) async {
    try {
      // 如果没有提供token，尝试从本地存储获取
      token ??= await getToken();
      if (token == null) return false;

      debugPrint('验证Token: ${token.length > 10 ? token.substring(0, 10) + '...' : token}');
      
      // 调用验证Token的API
      final response = await _apiService.get(
        '/api/auth/validate',  // 正确的API路径
        token: token,
      );
      
      debugPrint('Token验证响应: $response');
      
      // 根据响应判断Token是否有效
      if (response['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Token验证失败: $e');
      return false;
    }
  }
  
  /**
   * 刷新令牌
   * 
   * 当访问令牌过期时，尝试获取新的访问令牌
   * 
   * @param oldToken 过期的旧Token
   * @return 新的Token，如果刷新失败则返回null
   */
  Future<String?> refreshToken(String? oldToken) async {
    if (oldToken == null || oldToken.isEmpty) {
      debugPrint('无法刷新令牌：未提供旧令牌');
      return null;
    }
    
    try {
      // 调用刷新Token的API
      debugPrint('尝试刷新Token...');
      
      final response = await _apiService.post(
        '/api/auth/refresh',  // 正确的API路径
        data: {
          'token': oldToken
        },
      );
      
      debugPrint('刷新Token响应: $response');
      
      // 处理刷新结果
      if (response['success'] == true && response['token'] != null) {
        final newToken = response['token'] as String;
        debugPrint('Token刷新成功，长度: ${newToken.length}');
        
        // 保存新令牌到本地存储
        await setToken(newToken);
        
        return newToken;
      } else {
        debugPrint('Token刷新失败: ${response['message'] ?? '未知错误'}');
        return null;
      }
    } catch (e) {
      debugPrint('Token刷新失败: $e');
      return null;
    }
  }

  /**
   * 从令牌中解析用户ID
   * 
   * 解析JWT令牌的payload部分，提取用户ID
   * 
   * @return 用户ID，如果解析失败则返回null
   */
  Future<String?> getUserIdFromToken() async {
    try {
      // 从本地存储获取Token
      final token = await getToken();
      if (token == null || token.isEmpty) {
        debugPrint('未找到有效令牌，无法解析用户ID');
        return null;
      }
      
      // 如果是JWT令牌，尝试解析payload部分
      final parts = token.split('.');
      if (parts.length != 3) {
        debugPrint('令牌格式不是有效的JWT');
        return null;
      }
      
      // 解码payload部分（base64解码）
      String normalizedPayload = parts[1];
      // 修正base64字符串长度，确保能够正确解码
      while (normalizedPayload.length % 4 != 0) {
        normalizedPayload += '=';
      }
      
      // 执行base64解码并转换为JSON
      final payloadBytes = base64Url.decode(normalizedPayload);
      final payloadString = utf8.decode(payloadBytes);
      final payload = json.decode(payloadString) as Map<String, dynamic>;
      
      // 提取用户ID
      final userId = payload['userId'] as String?;
      debugPrint('从令牌中解析到用户ID: $userId');
      return userId;
    } catch (e) {
      debugPrint('解析令牌出错: $e');
      return null;
    }
  }
  
  /**
   * 获取当前用户信息
   * 
   * 通过API获取当前登录用户的详细信息
   * 
   * @return 包含用户信息的Map，如果获取失败则返回空Map
   */
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      // 获取Token
      final token = await getToken();
      if (token == null) {
        throw Exception('未登录，无法获取用户信息');
      }
      
      // 调用获取用户信息的API
      final response = await _apiService.get(
        '/api/users/profile',
        token: token,
      );
      
      // 检查响应是否成功
      if (response['success'] != true) {
        throw Exception(response['message'] ?? '获取用户信息失败');
      }
      
      // 提取用户数据，兼容不同的响应格式
      final userData = response['data'] ?? response['user'] ?? {};
      debugPrint('获取到用户信息: $userData');
      return userData;
    } catch (e) {
      debugPrint('获取用户信息失败: $e');
      return {};
    }
  }
}
