import 'dart:io';
import 'environment/environment.dart';

class AppConstants {
  // API 基础 URL - 优先使用Environment配置
  static String get apiBaseUrl {
    try {
      // 优先使用Environment配置
      return Environment.apiBaseUrl;
    } catch (e) {
      // 如果Environment未初始化，使用默认配置
      if (Platform.isAndroid) {
        // Android 模拟器使用 10.0.2.2 访问主机，端口改为8080
        return 'http://10.0.2.2:8080/api';
      } else if (Platform.isIOS) {
        // iOS 模拟器可以使用 localhost
        return 'http://localhost:8080/api';
      } else {
        // macOS 或其他平台
        return 'http://localhost:8080/api';
      }
    }
  }

  static String get serverBaseUrl {
    // 不包含 /api 前缀的基础URL
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    } else if (Platform.isIOS) {
      return 'http://localhost:8080';
    } else {
      return 'http://localhost:8080';
    }
  }
  
  // API 超时时间
  static const int apiTimeout = 30000;
  
  // 应用名称
  static const String appName = '营养立方';
}