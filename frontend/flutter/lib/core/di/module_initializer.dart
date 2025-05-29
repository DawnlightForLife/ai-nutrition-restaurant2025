/// 模块初始化器
/// 
/// 统一管理所有模块的初始化流程
library;

import 'package:flutter/foundation.dart';
import '../utils/logger.dart';
import '../error/centralized_error_handler.dart';
import '../events/centralized_event_bus.dart';
import '../../features/auth/auth_module.dart';
import '../../features/nutrition/nutrition_module.dart';
import 'injection_container.dart';

/// 模块初始化器
class ModuleInitializer {
  ModuleInitializer._();

  /// 应用初始化状态
  static bool _initialized = false;
  
  /// 是否已初始化
  static bool get isInitialized => _initialized;

  /// 初始化所有模块
  static Future<void> initialize() async {
    if (_initialized) {
      AppLogger.warning('ModuleInitializer.initialize() 已经执行过');
      return;
    }

    try {
      AppLogger.info('开始初始化应用模块...');
      
      // 1. 初始化核心基础设施
      await _initializeCoreInfrastructure();
      
      // 2. 初始化依赖注入
      await _initializeDependencyInjection();
      
      // 3. 初始化各功能模块
      await _initializeFeatureModules();
      
      // 4. 初始化第三方服务
      await _initializeThirdPartyServices();
      
      _initialized = true;
      AppLogger.info('应用模块初始化完成');
    } catch (e, stack) {
      AppLogger.error('应用模块初始化失败', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// 初始化核心基础设施
  static Future<void> _initializeCoreInfrastructure() async {
    AppLogger.debug('初始化核心基础设施...');
    
    // 初始化错误处理器
    CentralizedErrorHandler.instance.initialize();
    
    // 添加默认的错误监听器
    if (kDebugMode) {
      CentralizedErrorHandler.instance.addListener(DebugErrorListener());
    }
    
    // 添加默认的事件中间件
    if (kDebugMode) {
      CentralizedEventBus.instance.addMiddleware(EventLoggingMiddleware());
    }
  }

  /// 初始化依赖注入
  static Future<void> _initializeDependencyInjection() async {
    AppLogger.debug('初始化依赖注入...');
    await InjectionContainer.init();
  }

  /// 初始化各功能模块
  static Future<void> _initializeFeatureModules() async {
    AppLogger.debug('初始化功能模块...');
    
    // 按依赖顺序初始化各功能模块
    await AuthModule.initialize();
    // await UserModule.initialize();  // TODO: 创建 UserModule
    await NutritionModule.initialize();
    // await OrderModule.initialize();  // TODO: 创建 OrderModule
    // await RecommendationModule.initialize();  // TODO: 创建 RecommendationModule
  }

  /// 初始化第三方服务
  static Future<void> _initializeThirdPartyServices() async {
    AppLogger.debug('初始化第三方服务...');
    
    // TODO: 初始化第三方服务
    // await FirebaseService.initialize();
    // await AnalyticsService.initialize();
    // await CrashReportingService.initialize();
  }

  /// 清理资源
  static Future<void> dispose() async {
    if (!_initialized) {
      return;
    }

    try {
      AppLogger.info('开始清理应用资源...');
      
      // 清理事件总线
      CentralizedEventBus.instance.dispose();
      
      // 清理错误处理器
      CentralizedErrorHandler.instance.dispose();
      
      // TODO: 清理其他资源
      
      _initialized = false;
      AppLogger.info('应用资源清理完成');
    } catch (e, stack) {
      AppLogger.error('应用资源清理失败', error: e, stackTrace: stack);
    }
  }
}

/// 调试错误监听器
class DebugErrorListener implements ErrorListener {
  @override
  void onError(ErrorInfo errorInfo) {
    if (kDebugMode) {
      print('🐛 [${errorInfo.type.name}] ${errorInfo.error}');
      if (errorInfo.module != null) {
        print('   模块: ${errorInfo.module}');
      }
      if (errorInfo.operation != null) {
        print('   操作: ${errorInfo.operation}');
      }
    }
  }
}