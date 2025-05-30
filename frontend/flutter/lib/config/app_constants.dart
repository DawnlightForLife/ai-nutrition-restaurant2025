import 'dart:io';

class AppConstants {
  // API 基础 URL - 根据平台自动选择
  static String get apiBaseUrl {
    // 后端在 Docker 容器中运行，映射到主机的 8080 端口
    // 后端路由都在 /api 前缀下
    if (Platform.isAndroid) {
      // Android 模拟器使用 10.0.2.2 访问主机
      return 'http://10.0.2.2:8080/api';
    } else if (Platform.isIOS) {
      // iOS 模拟器可以使用 localhost
      return 'http://localhost:8080/api';
    } else {
      // macOS 或其他平台
      return 'http://localhost:8080/api';
    }
  }
  
  // API 超时时间
  static const int apiTimeout = 30000;
  
  // 应用名称
  static const String appName = '营养立方';
}