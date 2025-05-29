/// 应用级依赖注入统一注册
/// 
/// 所有模块的依赖在此集中注册，避免分散管理
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'injection_container.dart';

// 导入各模块的内部注入配置
import '../../features/auth/data/injection.dart';
import '../../features/nutrition/data/injection.dart';
import '../../features/order/data/injection.dart';
import '../../features/recommendation/data/injection.dart';
import '../../features/user/data/injection.dart';

/// 应用依赖注入注册中心
class AppInjection {
  AppInjection._();

  static bool _initialized = false;

  /// 初始化所有依赖注入
  static Future<void> initialize() async {
    if (_initialized) return;

    // 1. 初始化基础设施
    await InjectionContainer.init();

    // 2. 注册各模块依赖（集中管理）
    _registerAuthDependencies();
    _registerNutritionDependencies();
    _registerOrderDependencies();
    _registerRecommendationDependencies();
    _registerUserDependencies();

    _initialized = true;
  }

  /// 注册认证模块依赖
  static void _registerAuthDependencies() {
    AuthModuleInjection.register();
  }

  /// 注册营养模块依赖
  static void _registerNutritionDependencies() {
    NutritionModuleInjection.register();
  }

  /// 注册订单模块依赖
  static void _registerOrderDependencies() {
    OrderModuleInjection.register();
  }

  /// 注册推荐模块依赖
  static void _registerRecommendationDependencies() {
    RecommendationModuleInjection.register();
  }

  /// 注册用户模块依赖
  static void _registerUserDependencies() {
    UserModuleInjection.register();
  }
}

// 模块内部注入接口
abstract class ModuleInjection {
  static void register();
}