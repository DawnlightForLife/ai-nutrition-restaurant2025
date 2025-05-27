class ApiConfig {
  // 开发环境配置
  static const String _devBaseUrl = 'http://localhost:3002';
  
  // 生产环境配置
  static const String _prodBaseUrl = 'https://api.nutrition-restaurant.com';
  
  // 当前环境
  static const bool isProduction = false;
  
  // 获取当前环境的基础URL
  static String get baseUrl => isProduction ? _prodBaseUrl : _devBaseUrl;
  
  // API超时时间
  static const Duration timeout = Duration(seconds: 30);
  
  // 重试次数
  static const int maxRetries = 3;
}