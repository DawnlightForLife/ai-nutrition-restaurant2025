/// Nutrition 模块初始化
/// 
/// 负责 Nutrition 模块的初始化和配置
library;

import '../../core/utils/logger.dart';
import '../../core/events/centralized_event_bus.dart';
import 'di/nutrition_injection.dart';

/// Nutrition 模块
class NutritionModule {
  NutritionModule._();

  /// 初始化 Nutrition 模块
  static Future<void> initialize() async {
    AppLogger.debug('初始化 Nutrition 模块...');
    
    try {
      // 1. 注册事件监听器
      _registerEventListeners();
      
      // 2. 初始化缓存
      await _initializeCache();
      
      // 3. 预加载常用数据
      await _preloadData();
      
      AppLogger.debug('Nutrition 模块初始化完成');
    } catch (e, stack) {
      AppLogger.error('Nutrition 模块初始化失败', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// 注册事件监听器
  static void _registerEventListeners() {
    // 监听用户登录事件，加载营养档案
    CentralizedEventBus.instance.subscribe<UserLoggedInEvent>((event) {
      AppLogger.debug('用户登录，加载营养档案: ${event.userId}');
      // TODO: 加载用户的营养档案
    });

    // 监听档案更新事件
    CentralizedEventBus.instance.subscribe<NutritionProfileUpdatedEvent>((event) {
      AppLogger.debug('营养档案已更新: ${event.profileId}');
      // TODO: 更新缓存和 UI
    });
  }

  /// 初始化缓存
  static Future<void> _initializeCache() async {
    // TODO: 初始化营养数据缓存
    // await CacheManager.instance.createCache('nutrition_profiles');
  }

  /// 预加载常用数据
  static Future<void> _preloadData() async {
    // TODO: 预加载常用的营养数据
    // 例如：食物数据库、营养成分表等
  }

  /// 清理模块资源
  static Future<void> dispose() async {
    AppLogger.debug('清理 Nutrition 模块资源...');
    // TODO: 清理缓存和其他资源
  }
}

/// 用户登录事件
class UserLoggedInEvent extends BusinessEvent {
  const UserLoggedInEvent({
    required this.userId,
    DateTime? timestamp,
  }) : super(
    timestamp: timestamp ?? DateTime.now(),
    source: 'AuthModule',
  );

  final String userId;
}

/// 营养档案更新事件
class NutritionProfileUpdatedEvent extends BusinessEvent {
  const NutritionProfileUpdatedEvent({
    required this.profileId,
    required this.userId,
    DateTime? timestamp,
  }) : super(
    timestamp: timestamp ?? DateTime.now(),
    source: 'NutritionModule',
  );

  final String profileId;
  final String userId;
}