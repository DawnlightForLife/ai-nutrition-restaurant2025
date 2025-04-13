import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API工具类
/// 提供API调用的辅助功能
class ApiUtils {
  /// 获取授权令牌
  static Future<String?> getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('authToken');
    } catch (e) {
      debugPrint('获取授权令牌失败: $e');
      return null;
    }
  }

  /// 保存授权令牌
  static Future<void> saveAuthToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
    } catch (e) {
      debugPrint('保存授权令牌失败: $e');
    }
  }

  /// 清除授权令牌
  static Future<void> clearAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
    } catch (e) {
      debugPrint('清除授权令牌失败: $e');
    }
  }

  /// 获取当前用户ID
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('userId');
    } catch (e) {
      debugPrint('获取用户ID失败: $e');
      return null;
    }
  }

  /// 保存当前用户ID
  static Future<void> saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);
    } catch (e) {
      debugPrint('保存用户ID失败: $e');
    }
  }

  /// 缓存API响应
  static Future<void> cacheApiResponse(
      String key, Map<String, dynamic> response,
      {Duration expiration = const Duration(hours: 1)}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expirationTime =
          DateTime.now().add(expiration).millisecondsSinceEpoch;

      final cacheData = {
        'data': response,
        'expiration': expirationTime,
      };

      await prefs.setString('apiCache_$key', jsonEncode(cacheData));
    } catch (e) {
      debugPrint('缓存API响应失败: $e');
    }
  }

  /// 获取缓存的API响应
  static Future<Map<String, dynamic>?> getCachedApiResponse(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheJson = prefs.getString('apiCache_$key');

      if (cacheJson == null) {
        return null;
      }

      final cacheData = jsonDecode(cacheJson) as Map<String, dynamic>;
      final expiration = cacheData['expiration'] as int;

      // 检查缓存是否过期
      if (DateTime.now().millisecondsSinceEpoch > expiration) {
        await prefs.remove('apiCache_$key');
        return null;
      }

      return cacheData['data'] as Map<String, dynamic>;
    } catch (e) {
      debugPrint('获取缓存的API响应失败: $e');
      return null;
    }
  }

  /// 清除API缓存
  static Future<void> clearApiCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('apiCache_$key');
    } catch (e) {
      debugPrint('清除API缓存失败: $e');
    }
  }

  /// 清除所有API缓存
  static Future<void> clearAllApiCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith('apiCache_')) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      debugPrint('清除所有API缓存失败: $e');
    }
  }

  /// 格式化查询参数
  static String? formatQueryParameters(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) {
      return null;
    }

    return params.entries
        .where((entry) => entry.value != null)
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
  }

  /// 构建完整URL
  static String buildUrl(
      String baseUrl, String path, Map<String, dynamic>? queryParams) {
    final url = baseUrl + path;
    final queryString = formatQueryParameters(queryParams);

    if (queryString != null && queryString.isNotEmpty) {
      return '$url?$queryString';
    }

    return url;
  }
}
