import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/flavor_config.dart';
import 'config/app_config.dart';
import 'core/utils/logger.dart';
import 'app.dart';

/// 开发环境入口
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化开发环境配置
  await _initializeDevApp();
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

Future<void> _initializeDevApp() async {
  try {
    // 初始化本地存储
    final prefs = await SharedPreferences.getInstance();
    
    // 设置开发环境配置
    FlavorConfig(
      flavor: Flavor.development,
      apiBaseUrl: 'http://localhost:3000/api',  // Environment 类会自动处理 Android 的情况
      appTitle: '营养立方 (开发版)',
    );
    
    // 初始化日志（开发环境开启调试日志）
    AppLogger.init(
      level: LogLevel.debug,
      enableFileLogging: true,
    );
    
  } catch (e, stack) {
    debugPrint('Dev app initialization failed: $e\n$stack');
  }
}