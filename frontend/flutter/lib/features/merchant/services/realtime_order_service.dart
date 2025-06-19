import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/order_entity.dart';
import '../data/repositories/order_repository.dart';
import '../../../core/network/api_client.dart';
import '../presentation/providers/order_provider.dart';

/// 实时订单服务提供者
final realtimeOrderServiceProvider = Provider.family<RealtimeOrderService, String>(
  (ref, storeId) => RealtimeOrderService(
    storeId: storeId,
    orderRepository: ref.watch(orderRepositoryProvider),
    onOrderUpdate: (order) {
      // 通知相关的provider更新
      ref.invalidate(productionQueueProvider(storeId));
      ref.invalidate(orderListProvider);
    },
  ),
);

/// 实时订单服务
/// 使用轮询机制实现准实时更新（后续可升级为WebSocket）
class RealtimeOrderService {
  final String storeId;
  final OrderRepository orderRepository;
  final Function(OrderEntity)? onOrderUpdate;
  
  Timer? _pollingTimer;
  StreamController<OrderUpdateEvent>? _eventController;
  DateTime? _lastUpdateTime;
  bool _isActive = false;
  
  // 轮询间隔（毫秒）
  static const int _pollingInterval = 5000; // 5秒
  static const int _fastPollingInterval = 2000; // 2秒（高频模式）
  
  RealtimeOrderService({
    required this.storeId,
    required this.orderRepository,
    this.onOrderUpdate,
  });
  
  /// 获取订单更新事件流
  Stream<OrderUpdateEvent> get orderUpdateStream {
    _eventController ??= StreamController<OrderUpdateEvent>.broadcast();
    return _eventController!.stream;
  }
  
  /// 启动实时监听
  void startListening({bool highFrequency = false}) {
    if (_isActive) return;
    
    _isActive = true;
    _lastUpdateTime = DateTime.now();
    
    // 设置轮询间隔
    final interval = highFrequency ? _fastPollingInterval : _pollingInterval;
    
    // 立即执行一次检查
    _checkForUpdates();
    
    // 设置定时器
    _pollingTimer = Timer.periodic(
      Duration(milliseconds: interval),
      (_) => _checkForUpdates(),
    );
  }
  
  /// 停止实时监听
  void stopListening() {
    _isActive = false;
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
  
  /// 检查订单更新
  Future<void> _checkForUpdates() async {
    if (!_isActive) return;
    
    try {
      // 获取最新订单列表
      final result = await orderRepository.getOrderList(
        storeId: storeId,
        // 只获取最近更新的订单
        startDate: _lastUpdateTime?.subtract(const Duration(seconds: 10)),
      );
      
      result.fold(
        (failure) {
          // 发送错误事件
          _eventController?.add(OrderUpdateEvent.error(failure.message));
        },
        (orders) {
          // 检查是否有新订单或状态变化
          for (final order in orders) {
            if (order.updatedAt.isAfter(_lastUpdateTime ?? DateTime(2000))) {
              // 发送订单更新事件
              _eventController?.add(OrderUpdateEvent.orderUpdated(order));
              
              // 调用回调
              onOrderUpdate?.call(order);
            }
          }
          
          // 更新最后检查时间
          _lastUpdateTime = DateTime.now();
        },
      );
    } catch (e) {
      _eventController?.add(OrderUpdateEvent.error(e.toString()));
    }
  }
  
  /// 手动触发刷新
  Future<void> refresh() async {
    await _checkForUpdates();
  }
  
  /// 释放资源
  void dispose() {
    stopListening();
    _eventController?.close();
    _eventController = null;
  }
}

/// 订单更新事件
class OrderUpdateEvent {
  final OrderUpdateEventType type;
  final OrderEntity? order;
  final String? error;
  final DateTime timestamp;
  
  OrderUpdateEvent._({
    required this.type,
    this.order,
    this.error,
  }) : timestamp = DateTime.now();
  
  factory OrderUpdateEvent.orderUpdated(OrderEntity order) {
    return OrderUpdateEvent._(
      type: OrderUpdateEventType.orderUpdated,
      order: order,
    );
  }
  
  factory OrderUpdateEvent.newOrder(OrderEntity order) {
    return OrderUpdateEvent._(
      type: OrderUpdateEventType.newOrder,
      order: order,
    );
  }
  
  factory OrderUpdateEvent.error(String error) {
    return OrderUpdateEvent._(
      type: OrderUpdateEventType.error,
      error: error,
    );
  }
}

/// 订单更新事件类型
enum OrderUpdateEventType {
  newOrder,       // 新订单
  orderUpdated,   // 订单更新
  error,          // 错误
}

/// WebSocket实现（预留接口）
abstract class OrderWebSocketService {
  /// 连接WebSocket
  Future<void> connect(String storeId);
  
  /// 断开连接
  Future<void> disconnect();
  
  /// 订阅订单更新
  Stream<OrderUpdateEvent> subscribeToOrderUpdates();
  
  /// 发送心跳
  void sendHeartbeat();
  
  /// 重连逻辑
  Future<void> reconnect();
}

/// 订单声音提醒服务
class OrderSoundAlertService {
  static final OrderSoundAlertService _instance = OrderSoundAlertService._internal();
  
  factory OrderSoundAlertService() => _instance;
  
  OrderSoundAlertService._internal();
  
  /// 播放新订单提醒音
  Future<void> playNewOrderSound() async {
    // TODO: 实现声音播放
    // 可以使用 audioplayers 或 just_audio 包
  }
  
  /// 播放订单完成提醒音
  Future<void> playOrderCompleteSound() async {
    // TODO: 实现声音播放
  }
  
  /// 设置声音开关
  void setSoundEnabled(bool enabled) {
    // TODO: 保存设置到本地存储
  }
  
  /// 获取声音开关状态
  bool get isSoundEnabled {
    // TODO: 从本地存储读取
    return true;
  }
}