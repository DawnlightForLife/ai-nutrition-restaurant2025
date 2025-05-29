import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/flavor_config.dart';
import 'config/app_config.dart';
import 'core/utils/logger.dart';
import 'core/di/module_initializer.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化配置
  await _initializeApp();
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

Future<void> _initializeApp() async {
  try {
    // 初始化本地存储
    await Hive.initFlutter();
    
    // 设置生产环境配置
    FlavorConfig(
      flavor: Flavor.production,
      apiBaseUrl: AppConfig.productionApiUrl,
      appTitle: '元气营养',
    );
    
    // 初始化日志
    AppLogger.init();
    
    // 初始化所有模块（新增）
    await ModuleInitializer.initialize();
    
  } catch (e, stack) {
    // 初始化失败处理
    debugPrint('App initialization failed: $e\n$stack');
  }
}