import 'dart:io';
import '../flavor_config.dart';

abstract class Environment {
  static String get baseUrl => apiBaseUrl;
  
  static String get apiBaseUrl {
    // 如果已经通过 FlavorConfig 设置了 URL，使用它
    try {
      final configUrl = FlavorConfig.apiBaseUrl;
      // Android 模拟器特殊处理
      if (Platform.isAndroid && configUrl.contains('localhost')) {
        return configUrl.replaceAll('localhost', '10.0.2.2');
      }
      return configUrl;
    } catch (e) {
      // 如果 FlavorConfig 没有初始化，使用默认值
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000/api';
      }
      return 'http://localhost:3000/api';
    }
  }
  
  static int get apiTimeout => 30000;
  static bool get enableLogging => true; // 开发环境启用日志
}