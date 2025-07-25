import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/flavor_config.dart';
import 'config/app_config.dart';
import 'core/utils/logger.dart';
import 'app.dart';

/// 主入口 - 根据编译时的 flavor 自动配置
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 获取 flavor
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  
  // 根据 flavor 初始化配置
  await _initializeApp(flavor);
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

Future<void> _initializeApp(String flavor) async {
  try {
    // 初始化本地存储
    final prefs = await SharedPreferences.getInstance();
    
    // 根据 flavor 设置不同的配置
    switch (flavor) {
      case 'dev':
        FlavorConfig(
          flavor: Flavor.development,
          apiBaseUrl: 'http://localhost:8080/api',  // Environment 类会自动处理 Android 的情况
          appTitle: '营养立方 (开发版)',
        );
        
        // 初始化日志（开发环境开启调试日志）
        AppLogger.init(
          level: LogLevel.debug,
          enableFileLogging: true,
        );
        break;
        
      case 'staging':
        FlavorConfig(
          flavor: Flavor.staging,
          apiBaseUrl: 'https://staging-api.nutrition-cube.com/api',
          appTitle: '营养立方 (测试版)',
        );
        
        AppLogger.init(
          level: LogLevel.info,
          enableFileLogging: true,
        );
        break;
        
      case 'prod':
      default:
        FlavorConfig(
          flavor: Flavor.production,
          apiBaseUrl: 'https://api.nutrition-cube.com/api',
          appTitle: '营养立方',
        );
        
        AppLogger.init(
          level: LogLevel.error,
          enableFileLogging: false,
        );
        break;
    }
    
  } catch (e, stack) {
    debugPrint('App initialization failed: $e\n$stack');
  }
}