import 'dart:async';

/// 域事件基类
abstract class DomainEvent {
  final DateTime timestamp;
  
  DomainEvent() : timestamp = DateTime.now();
}

/// 简单的事件总线实现
class EventBus {
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;
  EventBus._internal();

  final Map<Type, List<StreamController>> _controllers = {};

  /// 发送事件
  void emit<T extends DomainEvent>(T event) {
    final controllers = _controllers[T];
    if (controllers != null) {
      for (final controller in controllers) {
        if (!controller.isClosed) {
          controller.add(event);
        }
      }
    }
  }

  /// 监听事件
  Stream<T> on<T extends DomainEvent>() {
    final controller = StreamController<T>.broadcast();
    
    final controllers = _controllers[T] ??= [];
    controllers.add(controller);
    
    // 当流被取消时清理
    controller.onCancel = () {
      controllers.remove(controller);
      if (controllers.isEmpty) {
        _controllers.remove(T);
      }
    };
    
    return controller.stream;
  }

  /// 清理所有监听器
  void dispose() {
    for (final controllers in _controllers.values) {
      for (final controller in controllers) {
        controller.close();
      }
    }
    _controllers.clear();
  }
}