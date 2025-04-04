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

/// 身份验证服务
///
/// 提供登录、注册、验证码等身份验证相关功能
class AuthService {
  final ApiService _apiService;
  final GlobalErrorHandler _errorHandler = GlobalErrorHandler();
  prefs.SharedPreferences? _prefs; // 移除final关键字，允许动态初始化
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  // 防止重复发送验证码
  DateTime? _lastSentTime;
  DateTime? _lastResetCodeSentTime;
  static const int _codeCooldownSeconds = 60;
  
  AuthService(this._apiService, [this._prefs]);
  
  /// 初始化，加载SharedPreferences
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
  
  /// 使用验证码登录
  ///
  /// 返回登录成功后的用户信息Map
  Future<Map<String, dynamic>> loginWithCode(String phone, String code, {BuildContext? context}) async {
    try {
      final response = await _apiService.post(
        '/api/users/login/code',
        data: {
          'phone': phone,
          'code': code,
        },
      );
      
      debugPrint('登录响应: $response');  // 添加调试日志
      
      if (response['success'] == true && response['token'] != null) {
        // 立即保存token到本地存储
        await setToken(response['token']);
        
        final user = response['user'] ?? {};
        return {
          'token': response['token'],
          'userId': user['userId'] ?? '',
          'phone': user['phone'] ?? phone,
          'username': user['username'] ?? '',  // 用户名
          'nickname': user['nickname'] ?? '',  // 用户昵称
          'avatar': user['avatar'] ?? '',
        };
      } else {
        final message = response['message'] ?? '登录失败：未获取到有效的token';
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('登录失败: $e');
      if (context != null) {
        _errorHandler.handleAuthError(context, e);
      }
      rethrow;  // 抛出原始错误，而不是包装成新的异常
    }
  }
  
  /// 使用密码登录
  ///
  /// 返回登录成功后的用户信息Map
  Future<Map<String, dynamic>> loginWithPassword(String phone, String password, {BuildContext? context}) async {
    try {
      final response = await _apiService.post(
        '/api/users/login',
        data: {
          'phone': phone,
          'password': password,
        },
      );
      
      debugPrint('登录响应: $response');  // 添加调试日志
      
      if (response['success'] == true && response['token'] != null) {
        // 立即保存token到本地存储
        await setToken(response['token']);
        
        final user = response['user'] ?? {};
        return {
          'token': response['token'],
          'userId': user['userId'] ?? '',
          'phone': user['phone'] ?? phone,
          'username': user['username'] ?? '',  // 用户名
          'nickname': user['nickname'] ?? '',  // 用户昵称
          'avatar': user['avatar'] ?? '',
        };
      } else {
        final message = response['message'] ?? '登录失败：未获取到有效的token';
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('登录失败: $e');
      if (context != null) {
        _errorHandler.handleAuthError(context, e);
      }
      rethrow;  // 抛出原始错误，而不是包装成新的异常
    }
  }

  /// 注册新用户
  ///
  /// 返回注册成功后的token
  Future<String> register({
    required String phone, 
    required String password, 
    required String code, 
    String? username,  // 用户名
    String? nickname,  // 用户昵称
    BuildContext? context
  }) async {
    try {
      final data = {
        'phone': phone,
        'password': password,
        'code': code,
      };
      
      // 可选用户名
      if (username != null && username.isNotEmpty) {
        data['username'] = username;
      }
      
      // 可选昵称
      if (nickname != null && nickname.isNotEmpty) {
        data['nickname'] = nickname;
      }
      
      final response = await _apiService.post(
        '/api/users/register',
        data: data,
      );
      
      if (response.containsKey('token')) {
        return response['token'];
      } else if (response.containsKey('message')) {
        throw Exception('注册失败：${response['message']}');
      } else {
        throw Exception('注册失败：未获取到有效的token');
      }
    } catch (e) {
      debugPrint('注册失败: $e');
      if (context != null) {
        _errorHandler.handleAuthError(context, e, operation: '注册');
      }
      throw Exception('注册失败：${e.toString()}');
    }
  }

  /// 发送手机验证码
  ///
  /// 成功返回true，冷却中返回false
  Future<bool> sendVerificationCode(String phone, {BuildContext? context}) async {
    // 检查是否在冷却期内
    if (_lastSentTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_lastSentTime!).inSeconds;
      
      if (difference < _codeCooldownSeconds) {
        return false; // 仍在冷却期
      }
    }
    
    try {
      await _apiService.post(
        '/api/users/send-code',
        data: {'phone': phone},
      );
      
      // 记录发送时间
      _lastSentTime = DateTime.now();
      return true;
    } catch (e) {
      debugPrint('发送验证码失败: $e');
      if (context != null) {
        _errorHandler.handleNetworkError(context, e, operation: '发送验证码');
      }
      throw Exception('发送验证码失败：${e.toString()}');
    }
  }
  
  /// 发送重置密码验证码
  ///
  /// 成功返回true，冷却中返回false
  Future<bool> sendResetCode(String phone, {BuildContext? context}) async {
    // 检查是否在冷却期内
    if (_lastResetCodeSentTime != null) {
      final now = DateTime.now();
      final difference = now.difference(_lastResetCodeSentTime!).inSeconds;
      
      if (difference < _codeCooldownSeconds) {
        return false; // 仍在冷却期
      }
    }
    
    try {
      await _apiService.post(
        '/api/users/send-reset-code',
        data: {'phone': phone},
      );
      
      // 记录发送时间
      _lastResetCodeSentTime = DateTime.now();
      return true;
    } catch (e) {
      debugPrint('发送重置密码验证码失败: $e');
      if (context != null) {
        _errorHandler.handleNetworkError(context, e, operation: '发送重置验证码');
      }
      throw Exception('发送重置密码验证码失败：${e.toString()}');
    }
  }
  
  /// 重置密码
  ///
  /// 成功返回true
  Future<bool> resetPassword(String phone, String code, String newPassword, {BuildContext? context}) async {
    try {
      final response = await _apiService.post(
        '/api/users/reset-password', // 使用正确的API端点
        data: {
          'phone': phone,
          'code': code,
          'newPassword': newPassword,
        },
      );
      
      // 处理后端返回的真实响应
      if (response.containsKey('success') && response['success'] == true) {
        return true;
      } else if (response.containsKey('message')) {
        throw Exception('重置密码失败：${response['message']}');
      } else {
        throw Exception('重置密码失败：未知错误');
      }
    } catch (e) {
      debugPrint('重置密码失败: $e');
      if (context != null) {
        _errorHandler.handleAuthError(context, e, operation: '重置密码');
      }
      // 这里应该抛出异常，而不是返回true
      throw Exception('重置密码失败：${e.toString()}'); 
    }
  }
  
  /// 获取验证码剩余冷却时间（秒）
  int getRemainingCooldownSeconds() {
    if (_lastSentTime == null) {
      return 0;
    }
    
    final now = DateTime.now();
    final difference = now.difference(_lastSentTime!).inSeconds;
    final remaining = _codeCooldownSeconds - difference;
    
    return remaining > 0 ? remaining : 0;
  }

  /// 获取重置密码验证码剩余冷却时间（秒）
  int getResetCodeRemainingCooldownSeconds() {
    if (_lastResetCodeSentTime == null) {
      return 0;
    }
    
    final now = DateTime.now();
    final difference = now.difference(_lastResetCodeSentTime!).inSeconds;
    final remaining = _codeCooldownSeconds - difference;
    
    return remaining > 0 ? remaining : 0;
  }
  
  /// 退出登录
  Future<void> logout(BuildContext context) async {
    try {
      // 可以添加实际的退出登录API调用
      // await _apiService.post('/api/auth/logout');
      
      // 清除本地token
      await Provider.of<AuthProvider>(context, listen: false).logout();
      
    } catch (e) {
      debugPrint('退出登录失败: $e');
      _errorHandler.handleNetworkError(context, e, operation: '退出登录');
      throw Exception('退出登录失败：${e.toString()}');
    }
  }
  
  /// 获取当前用户token
  String? getCurrentToken() {
    // 在没有SharedPreferences时直接返回null
    return null;
  }

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

  Future<void> setToken(String token) async {
    if (_prefs == null) return;
    await _prefs!.setString(_tokenKey, token);
  }

  Future<String?> getRefreshToken() async {
    if (_prefs == null) return null;
    return _prefs!.getString(_refreshTokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    if (_prefs == null) return;
    await _prefs!.setString(_refreshTokenKey, token);
  }

  /// 验证令牌是否有效
  ///
  /// 返回token是否有效
  Future<bool> validateToken([String? token]) async {
    try {
      token ??= await getToken();
      if (token == null) return false;

      debugPrint('验证Token: ${token.length > 10 ? token.substring(0, 10) + '...' : token}');
      
      final response = await _apiService.get(
        '/api/auth/validate',  // 正确的API路径
        token: token,
      );
      
      debugPrint('Token验证响应: $response');
      
      if (response['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Token验证失败: $e');
      return false;
    }
  }
  
  /// 刷新令牌
  /// 
  /// 当令牌过期时，使用刷新令牌获取新的访问令牌
  Future<String?> refreshToken(String? oldToken) async {
    if (oldToken == null || oldToken.isEmpty) {
      debugPrint('无法刷新令牌：未提供旧令牌');
      return null;
    }
    
    try {
      // 在正式环境中，这里需要使用刷新令牌来获取新的访问令牌
      debugPrint('尝试刷新Token...');
      
      final response = await _apiService.post(
        '/api/auth/refresh',  // 正确的API路径
        data: {
          'token': oldToken
        },
      );
      
      debugPrint('刷新Token响应: $response');
      
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

  /// 从令牌中解析用户ID
  Future<String?> getUserIdFromToken() async {
    try {
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
      // 修正base64字符串长度
      while (normalizedPayload.length % 4 != 0) {
        normalizedPayload += '=';
      }
      
      final payloadBytes = base64Url.decode(normalizedPayload);
      final payloadString = utf8.decode(payloadBytes);
      final payload = json.decode(payloadString) as Map<String, dynamic>;
      
      final userId = payload['userId'] as String?;
      debugPrint('从令牌中解析到用户ID: $userId');
      return userId;
    } catch (e) {
      debugPrint('解析令牌出错: $e');
      return null;
    }
  }
  
  /// 获取当前用户信息
  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('未登录，无法获取用户信息');
      }
      
      final response = await _apiService.get(
        '/api/users/profile',
        token: token,
      );
      
      if (response['success'] != true) {
        throw Exception(response['message'] ?? '获取用户信息失败');
      }
      
      final userData = response['data'] ?? response['user'] ?? {};
      debugPrint('获取到用户信息: $userData');
      return userData;
    } catch (e) {
      debugPrint('获取用户信息失败: $e');
      return {};
    }
  }
}
