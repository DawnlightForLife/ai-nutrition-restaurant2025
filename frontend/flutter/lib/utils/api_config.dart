import 'package:flutter/foundation.dart';

class ApiConfig {
  /// 获取适合当前环境的API基础URL
  static String get baseUrl {
    if (kIsWeb) {
      return '/api';  
    } else {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return 'http://10.0.2.2:8080';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        return 'http://localhost:8080';
      } else {
        return 'http://localhost:8080';
      }
    }
  }
  
  /// API请求超时时间（毫秒）
  static const int timeout = 15000;
  
  /// API路径
  static const Map<String, String> apiPaths = {
    'auth': '/api/auth',
    'users': '/api/users',
    'nutritionProfiles': '/api/nutrition-profiles',
  };
} 