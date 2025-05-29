/// 集中化事件总线
/// 
/// 统一管理应用中所有的事件通信
/// 替代分散在各个模块中的多个事件总线
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/logger.dart';

/// 集中化事件总线
/// 
/// 提供统一的事件发布、订阅和管理机制
class CentralizedEventBus {
  static CentralizedEventBus? _instance;
  static CentralizedEventBus get instance => _instance ??= CentralizedEventBus._();
  
  CentralizedEventBus._();

  /// 事件流控制器映射表
  final Map<Type, StreamController> _controllers = {};
  
  /// 事件订阅映射表
  final Map<Type, Set<StreamSubscription>> _subscriptions = {};
  
  /// 事件过滤器列表
  final List<EventFilter> _filters = [];
  
  /// 事件中间件列表
  final List<EventMiddleware> _middlewares = [];

  /// 发布事件
  void publish<T extends AppEvent>(T event) {
    // 应用事件过滤器
    for (final filter in _filters) {
      if (!filter.shouldPublish(event)) {
        AppLogger.debug('事件被过滤器拒绝: ${event.runtimeType}');
        return;
      }
    }

    // 应用事件中间件（发布前）
    for (final middleware in _middlewares) {
      middleware.beforePublish(event);
    }

    // 获取或创建事件流控制器
    final controller = _getController<T>();
    
    // 发布事件
    controller.add(event);
    
    AppLogger.debug('事件已发布: ${event.runtimeType}');

    // 应用事件中间件（发布后）
    for (final middleware in _middlewares) {
      middleware.afterPublish(event);
    }
  }

  /// 订阅事件
  StreamSubscription<T> subscribe<T extends AppEvent>(
    void Function(T event) onEvent, {
    bool Function(T event)? where,
  }) {
    final controller = _getController<T>();
    
    Stream<T> stream = controller.stream.cast<T>();
    
    // 应用过滤条件
    if (where != null) {
      stream = stream.where(where);
    }
    
    final subscription = stream.listen(
      (event) {
        // 应用事件中间件（处理前）
        for (final middleware in _middlewares) {
          middleware.beforeHandle(event);
        }
        
        try {
          onEvent(event);
        } catch (e, stack) {
          AppLogger.error(
            '事件处理失败: ${event.runtimeType}',
            error: e,
            stackTrace: stack,
          );
        }
        
        // 应用事件中间件（处理后）
        for (final middleware in _middlewares) {
          middleware.afterHandle(event);
        }
      },
      onError: (error, stack) {
        AppLogger.error(
          '事件流错误: ${T.toString()}',
          error: error,
          stackTrace: stack,
        );
      },
    );

    // 记录订阅
    _subscriptions.putIfAbsent(T, () => <StreamSubscription>{}).add(subscription);
    
    AppLogger.debug('事件订阅添加: ${T.toString()}');
    
    return subscription;
  }

  /// 订阅一次性事件
  StreamSubscription<T> subscribeOnce<T extends AppEvent>(
    void Function(T event) onEvent, {
    bool Function(T event)? where,
  }) {
    late StreamSubscription<T> subscription;
    
    subscription = subscribe<T>(
      (event) {
        onEvent(event);
        subscription.cancel();
      },
      where: where,
    );
    
    return subscription;
  }

  /// 等待特定事件
  Future<T> waitFor<T extends AppEvent>({
    bool Function(T event)? where,
    Duration? timeout,
  }) {
    final completer = Completer<T>();
    late StreamSubscription<T> subscription;
    
    subscription = subscribe<T>(
      (event) {
        if (!completer.isCompleted) {
          completer.complete(event);
          subscription.cancel();
        }
      },
      where: where,
    );
    
    if (timeout != null) {
      Timer(timeout, () {
        if (!completer.isCompleted) {
          subscription.cancel();
          completer.completeError(
            TimeoutException('等待事件超时: ${T.toString()}', timeout),
          );
        }
      });
    }
    
    return completer.future;
  }

  /// 获取事件流
  Stream<T> getStream<T extends AppEvent>() {
    final controller = _getController<T>();
    return controller.stream.cast<T>();
  }

  /// 检查是否有事件订阅者
  bool hasSubscribers<T extends AppEvent>() {
    final subscriptions = _subscriptions[T];
    return subscriptions?.isNotEmpty ?? false;
  }

  /// 获取事件订阅数量
  int getSubscriberCount<T extends AppEvent>() {
    final subscriptions = _subscriptions[T];
    return subscriptions?.length ?? 0;
  }

  /// 取消所有订阅
  void cancelAllSubscriptions<T extends AppEvent>() {
    final subscriptions = _subscriptions[T];
    if (subscriptions != null) {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
      subscriptions.clear();
      AppLogger.debug('已取消所有 ${T.toString()} 事件订阅');
    }
  }

  /// 添加事件过滤器
  void addFilter(EventFilter filter) {
    _filters.add(filter);
  }

  /// 移除事件过滤器
  void removeFilter(EventFilter filter) {
    _filters.remove(filter);
  }

  /// 添加事件中间件
  void addMiddleware(EventMiddleware middleware) {
    _middlewares.add(middleware);
  }

  /// 移除事件中间件
  void removeMiddleware(EventMiddleware middleware) {
    _middlewares.remove(middleware);
  }

  /// 获取或创建流控制器
  StreamController<T> _getController<T extends AppEvent>() {
    return _controllers.putIfAbsent(
      T,
      () => StreamController<T>.broadcast(),
    ) as StreamController<T>;
  }

  /// 清理资源
  void dispose() {
    // 取消所有订阅
    for (final subscriptions in _subscriptions.values) {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    }
    _subscriptions.clear();

    // 关闭所有流控制器
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();

    // 清理过滤器和中间件
    _filters.clear();
    _middlewares.clear();
    
    _instance = null;
    AppLogger.info('CentralizedEventBus 已清理');
  }
}

/// 应用事件基类
abstract class AppEvent {
  const AppEvent({
    required this.timestamp,
    this.source,
    this.metadata,
  });
  
  final DateTime timestamp;
  final String? source;
  final Map<String, dynamic>? metadata;

  @override
  String toString() {
    return '${runtimeType}(timestamp: $timestamp, source: $source)';
  }
}

/// 事件过滤器接口
abstract class EventFilter {
  bool shouldPublish(AppEvent event);
}

/// 事件中间件接口
abstract class EventMiddleware {
  void beforePublish(AppEvent event);
  void afterPublish(AppEvent event);
  void beforeHandle(AppEvent event);
  void afterHandle(AppEvent event);
}

/// 常用事件过滤器

/// 调试模式过滤器
class DebugModeEventFilter implements EventFilter {
  @override
  bool shouldPublish(AppEvent event) {
    // 在生产环境中过滤调试事件
    return !(event is DebugEvent && !kDebugMode);
  }
}

/// 事件类型过滤器
class EventTypeFilter implements EventFilter {
  const EventTypeFilter(this.allowedTypes);
  
  final Set<Type> allowedTypes;
  
  @override
  bool shouldPublish(AppEvent event) {
    return allowedTypes.contains(event.runtimeType);
  }
}

/// 常用事件中间件

/// 事件日志中间件
class EventLoggingMiddleware implements EventMiddleware {
  @override
  void beforePublish(AppEvent event) {
    AppLogger.debug('即将发布事件: ${event.runtimeType}');
  }

  @override
  void afterPublish(AppEvent event) {
    // 可以在这里记录事件发布后的状态
  }

  @override
  void beforeHandle(AppEvent event) {
    // 可以在这里记录事件处理前的状态
  }

  @override
  void afterHandle(AppEvent event) {
    AppLogger.debug('事件处理完成: ${event.runtimeType}');
  }
}

/// 事件性能监控中间件
class EventPerformanceMiddleware implements EventMiddleware {
  final Map<String, DateTime> _startTimes = {};

  @override
  void beforePublish(AppEvent event) {
    _startTimes['publish_${event.hashCode}'] = DateTime.now();
  }

  @override
  void afterPublish(AppEvent event) {
    final startTime = _startTimes.remove('publish_${event.hashCode}');
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      AppLogger.debug('事件发布耗时: ${event.runtimeType} - ${duration.inMilliseconds}ms');
    }
  }

  @override
  void beforeHandle(AppEvent event) {
    _startTimes['handle_${event.hashCode}'] = DateTime.now();
  }

  @override
  void afterHandle(AppEvent event) {
    final startTime = _startTimes.remove('handle_${event.hashCode}');
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      AppLogger.debug('事件处理耗时: ${event.runtimeType} - ${duration.inMilliseconds}ms');
    }
  }
}

/// 常用事件类型

/// 调试事件基类
abstract class DebugEvent extends AppEvent {
  const DebugEvent({
    required super.timestamp,
    super.source,
    super.metadata,
  });
}

/// 业务事件基类
abstract class BusinessEvent extends AppEvent {
  const BusinessEvent({
    required super.timestamp,
    super.source,
    super.metadata,
  });
}

/// 系统事件基类
abstract class SystemEvent extends AppEvent {
  const SystemEvent({
    required super.timestamp,
    super.source,
    super.metadata,
  });
}

/// 超时异常
class TimeoutException implements Exception {
  const TimeoutException(this.message, this.timeout);
  
  final String message;
  final Duration timeout;
  
  @override
  String toString() => 'TimeoutException: $message (timeout: $timeout)';
}