import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import '../../utils/global_error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;

/**
 * OAuth认证服务
 * 
 * 负责处理应用程序中与第三方OAuth认证相关的所有操作，包括：
 * 1. 第三方登录（微信、QQ、微博等）
 * 2. 获取第三方授权
 * 3. 管理OAuth令牌
 * 4. 刷新OAuth令牌
 * 5. 链接/解除链接第三方账号
 * 
 * 该服务与OAuth提供商和后端API进行通信，同时管理本地的OAuth令牌存储。
 */
class OAuthService {
  /// API服务，用于向后端发送HTTP请求
  final ApiService _apiService;
  
  /// 全局错误处理器，用于统一处理和显示OAuth相关错误
  final GlobalErrorHandler _errorHandler = GlobalErrorHandler();
  
  /// 本地存储，用于持久化保存OAuth相关信息
  prefs.SharedPreferences? _prefs;
  
  /// 本地存储键名常量前缀
  /// 用于存取OAuth相关的持久化数据
  static const String _oauthTokenPrefix = 'oauth_token_';  // OAuth令牌前缀
  static const String _linkedAccountsKey = 'linked_oauth_accounts';  // 关联账号信息
  
  /**
   * 构造函数
   * 
   * 创建一个OAuth认证服务实例，需要提供API服务
   * 可选提供一个预先初始化的SharedPreferences实例
   * 
   * @param _apiService API服务实例，用于发送HTTP请求
   * @param _prefs 可选的SharedPreferences实例，用于本地存储
   */
  OAuthService(this._apiService, [this._prefs]);
  
  /**
   * 初始化服务
   * 
   * 如果没有提供SharedPreferences实例，则尝试初始化一个
   * 该方法在使用涉及本地存储的功能之前应该被调用
   */
  Future<void> init() async {
    if (_prefs == null) {
      try {
        _prefs = await prefs.SharedPreferences.getInstance();
        debugPrint('OAuthService.init: SharedPreferences初始化成功');
      } catch (e) {
        debugPrint('OAuthService.init: 初始化SharedPreferences失败 - $e');
      }
    }
  }
  
  /**
   * 使用第三方OAuth进行登录
   * 
   * 通过指定的OAuth提供商（如微信、QQ等）进行登录
   * 
   * @param provider OAuth提供商名称（例如：'wechat', 'qq', 'weibo'等）
   * @param oauthCode 从OAuth提供商处获取的授权码
   * @return 包含用户信息和Token的Map
   * @throws Exception 登录失败时抛出异常
   */
  Future<Map<String, dynamic>> loginWithOAuth(String provider, String oauthCode) async {
    try {
      // 发送OAuth登录请求
      final response = await _apiService.post(
        '/api/auth/oauth/login',
        data: {
          'provider': provider,
          'code': oauthCode,
        },
      );
      
      debugPrint('OAuth登录响应: $response');
      
      // 检查登录是否成功
      if (response['success'] == true && response['token'] != null) {
        // 保存OAuth提供商信息
        await saveOAuthProviderInfo(provider, response);
        
        // 提取用户信息和token
        final user = response['user'] ?? {};
        return {
          'token': response['token'],
          'userId': user['userId'] ?? '',
          'username': user['username'] ?? '',
          'nickname': user['nickname'] ?? '',
          'avatar': user['avatar'] ?? '',
          'provider': provider,
        };
      } else {
        // 登录失败，抛出异常
        final message = response['message'] ?? 'OAuth登录失败：未获取到有效的token';
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('OAuth登录失败: $e');
      rethrow;
    }
  }
  
  /**
   * 保存OAuth提供商信息
   * 
   * 将OAuth提供商的令牌和相关信息保存到本地存储
   * 
   * @param provider OAuth提供商名称
   * @param data 包含OAuth信息的数据
   */
  Future<void> saveOAuthProviderInfo(String provider, Map<String, dynamic> data) async {
    if (_prefs == null) await init();
    if (_prefs == null) return;
    
    // 保存OAuth令牌
    if (data['oauthToken'] != null) {
      await _prefs!.setString('${_oauthTokenPrefix}$provider', data['oauthToken']);
    }
    
    // 更新关联账号列表
    List<String> linkedAccounts = _prefs!.getStringList(_linkedAccountsKey) ?? [];
    if (!linkedAccounts.contains(provider)) {
      linkedAccounts.add(provider);
      await _prefs!.setStringList(_linkedAccountsKey, linkedAccounts);
    }
  }
  
  /**
   * 获取OAuth令牌
   * 
   * 获取指定OAuth提供商的令牌
   * 
   * @param provider OAuth提供商名称
   * @return OAuth令牌，如果不存在则返回null
   */
  Future<String?> getOAuthToken(String provider) async {
    if (_prefs == null) await init();
    if (_prefs == null) return null;
    
    return _prefs!.getString('${_oauthTokenPrefix}$provider');
  }
  
  /**
   * 获取已关联的OAuth账号列表
   * 
   * 获取用户已关联的所有第三方OAuth账号
   * 
   * @return 已关联的OAuth提供商列表
   */
  Future<List<String>> getLinkedOAuthAccounts() async {
    if (_prefs == null) await init();
    if (_prefs == null) return [];
    
    return _prefs!.getStringList(_linkedAccountsKey) ?? [];
  }
  
  /**
   * 关联OAuth账号到现有账号
   * 
   * 将第三方OAuth账号与用户的主账号关联
   * 
   * @param provider OAuth提供商名称
   * @param oauthCode 从OAuth提供商处获取的授权码
   * @param userToken 用户的访问令牌
   * @return 关联成功返回true
   * @throws Exception 关联失败时抛出异常
   */
  Future<bool> linkOAuthAccount(String provider, String oauthCode, String userToken) async {
    try {
      // 发送关联账号请求
      final response = await _apiService.post(
        '/api/auth/oauth/link',
        data: {
          'provider': provider,
          'code': oauthCode,
        },
        token: userToken,
      );
      
      debugPrint('关联OAuth账号响应: $response');
      
      // 检查关联是否成功
      if (response['success'] == true) {
        // 保存OAuth提供商信息
        await saveOAuthProviderInfo(provider, response);
        return true;
      } else {
        // 关联失败，抛出异常
        final message = response['message'] ?? '关联OAuth账号失败';
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('关联OAuth账号失败: $e');
      rethrow;
    }
  }
  
  /**
   * 解除关联OAuth账号
   * 
   * 解除用户主账号与第三方OAuth账号的关联
   * 
   * @param provider OAuth提供商名称
   * @param userToken 用户的访问令牌
   * @return 解除关联成功返回true
   * @throws Exception 解除关联失败时抛出异常
   */
  Future<bool> unlinkOAuthAccount(String provider, String userToken) async {
    try {
      // 发送解除关联请求
      final response = await _apiService.post(
        '/api/auth/oauth/unlink',
        data: {
          'provider': provider,
        },
        token: userToken,
      );
      
      debugPrint('解除关联OAuth账号响应: $response');
      
      // 检查解除关联是否成功
      if (response['success'] == true) {
        // 更新本地存储
        if (_prefs != null) {
          // 删除OAuth令牌
          await _prefs!.remove('${_oauthTokenPrefix}$provider');
          
          // 更新关联账号列表
          List<String> linkedAccounts = _prefs!.getStringList(_linkedAccountsKey) ?? [];
          linkedAccounts.remove(provider);
          await _prefs!.setStringList(_linkedAccountsKey, linkedAccounts);
        }
        return true;
      } else {
        // 解除关联失败，抛出异常
        final message = response['message'] ?? '解除关联OAuth账号失败';
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('解除关联OAuth账号失败: $e');
      rethrow;
    }
  }
  
  /**
   * 获取OAuth提供商配置
   * 
   * 获取应用支持的OAuth提供商及其配置信息
   * 
   * @return 包含OAuth提供商配置的Map
   * @throws Exception 获取配置失败时抛出异常
   */
  Future<Map<String, dynamic>> getOAuthProviders() async {
    try {
      // 发送获取OAuth提供商配置请求
      final response = await _apiService.get(
        '/api/auth/oauth/providers',
      );
      
      // 检查响应是否成功
      if (response['success'] == true) {
        return response['providers'] ?? {};
      } else {
        // 获取失败，抛出异常
        final message = response['message'] ?? '获取OAuth提供商配置失败';
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('获取OAuth提供商配置失败: $e');
      return {};
    }
  }
  
  /**
   * 清除所有OAuth令牌和信息
   * 
   * 清除本地存储中的所有OAuth相关数据
   */
  Future<void> clearOAuthData() async {
    if (_prefs == null) await init();
    if (_prefs == null) return;
    
    // 获取已关联的账号列表
    List<String> linkedAccounts = _prefs!.getStringList(_linkedAccountsKey) ?? [];
    
    // 删除每个提供商的令牌
    for (String provider in linkedAccounts) {
      await _prefs!.remove('${_oauthTokenPrefix}$provider');
    }
    
    // 清除关联账号列表
    await _prefs!.remove(_linkedAccountsKey);
  }
}
