import 'dart:io';
import '../flavor_config.dart';

abstract class Environment {
  static String get baseUrl => apiBaseUrl;
  
  static String get apiBaseUrl {
    // 如果已经通过 FlavorConfig 设置了 URL，使用它
    try {
      final configUrl = FlavorConfig.apiBaseUrl;
      print('FlavorConfig.apiBaseUrl: $configUrl');
      // Android 模拟器特殊处理
      if (Platform.isAndroid && configUrl.contains('localhost')) {
        final result = configUrl.replaceAll('localhost', '10.0.2.2');
        print('Android模拟器URL转换: $configUrl -> $result');
        return result;
      }
      print('使用原始URL: $configUrl');
      return configUrl;
    } catch (e) {
      print('FlavorConfig未初始化，使用默认值: $e');
      // 如果 FlavorConfig 没有初始化，使用默认值
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8080/api';
      }
      return 'http://localhost:8080/api';
    }
  }
  
  static int get apiTimeout => 30000;
  static bool get enableLogging => true; // 开发环境启用日志
}