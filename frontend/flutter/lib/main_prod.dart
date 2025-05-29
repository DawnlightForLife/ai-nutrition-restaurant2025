import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/flavor_config.dart';
import 'config/app_config.dart';
import 'core/utils/logger.dart';
import 'core/di/module_initializer.dart';
import 'app.dart';

/// 生产环境入口
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化生产环境配置
  await _initializeProdApp();
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

Future<void> _initializeProdApp() async {
  try {
    // 初始化本地存储
    await Hive.initFlutter();
    
    // 设置生产环境配置
    FlavorConfig(
      flavor: Flavor.production,
      apiBaseUrl: AppConfig.productionApiUrl,
      appTitle: '元气营养',
    );
    
    // 初始化日志（生产环境只记录错误）
    AppLogger.init(
      level: LogLevel.error,
      enableFileLogging: false,
    );
    
    // 初始化所有模块
    await ModuleInitializer.initialize();
    
  } catch (e, stack) {
    // 生产环境静默处理错误
    debugPrint('Production app initialization failed: $e');
  }
}