class AppConfig {
  // API配置
  static const String developmentApiUrl = 'http://localhost:3002';
  static const String stagingApiUrl = 'https://staging-api.yuanqi-nutrition.com';
  static const String productionApiUrl = 'https://api.yuanqi-nutrition.com';
  
  // API超时时间
  static const Duration timeout = Duration(seconds: 30);
  
  // 重试次数
  static const int maxRetries = 3;
  
  // 分页配置
  static const int pageSize = 20;
  
  // 缓存配置
  static const Duration cacheMaxAge = Duration(hours: 24);
  static const int cacheMaxSize = 100; // MB
  
  // 文件上传配置
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  
  // 功能开关
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
}

// 保持向后兼容
class ApiConfig {
  static String get baseUrl => AppConfig.developmentApiUrl;
  static Duration get timeout => AppConfig.timeout;
  static int get maxRetries => AppConfig.maxRetries;
}