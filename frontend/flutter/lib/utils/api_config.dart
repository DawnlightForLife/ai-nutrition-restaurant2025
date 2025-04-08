import 'package:flutter/foundation.dart';
import '../common/constants/api_constants.dart';

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
  static final Map<String, String> apiPaths = {
    'auth': ApiConstants.auth,
    'users': ApiConstants.users,
    'nutritionProfiles': ApiConstants.nutritionProfile,
    'healthData': ApiConstants.healthData,
    'forumPost': ApiConstants.forumPost,
    'forumComment': ApiConstants.forumComment,
    'merchant': ApiConstants.merchant,
    'store': ApiConstants.store,
    'dish': ApiConstants.dish,
    'order': ApiConstants.order,
    'nutritionist': ApiConstants.nutritionist,
    'consult': ApiConstants.consult,
    'recommendation': ApiConstants.recommendation,
    'aiAnalysis': ApiConstants.aiAnalysis,
  };
} 