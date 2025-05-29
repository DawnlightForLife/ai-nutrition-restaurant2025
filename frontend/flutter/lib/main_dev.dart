import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/flavor_config.dart';
import 'config/app_config.dart';
import 'core/utils/logger.dart';
import 'core/di/module_initializer.dart';
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
    await Hive.initFlutter();
    
    // 设置开发环境配置
    FlavorConfig(
      flavor: Flavor.development,
      apiBaseUrl: 'https://dev-api.yuanqi-nutrition.com',
      appTitle: '元气营养 (开发版)',
    );
    
    // 初始化日志（开发环境开启调试日志）
    AppLogger.init(
      level: LogLevel.debug,
      enableFileLogging: true,
    );
    
    // 初始化所有模块
    await ModuleInitializer.initialize();
    
  } catch (e, stack) {
    debugPrint('Dev app initialization failed: $e\n$stack');
  }
}