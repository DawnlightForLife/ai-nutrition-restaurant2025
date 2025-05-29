/// 订单模块 Provider 统一导出
/// 
/// 提供订单模块相关的所有 Provider 和访问器
/// 避免使用全局 providers_index，实现模块化管理
library;

// 核心控制器
export 'order_controller.dart';
export 'order_provider.dart';

// TODO: 添加其他订单相关的 Provider
// export 'payment_provider.dart';
// export 'order_tracking_provider.dart';
// export 'refund_provider.dart';

/// 订单模块 Provider 访问器
/// 
/// 提供订单模块内部 Provider 的便捷访问方式
/// 遵循模块化设计原则，避免跨模块直接访问
class OrderProviders {
  const OrderProviders._();

  // 订单相关
  // static final orderController = orderControllerProvider;
  // static final orders = ordersProvider;
  
  // TODO: 添加其他订单 Provider 的访问器
  // static final payments = paymentsProvider;
  // static final orderTracking = orderTrackingProvider;
  // static final refunds = refundsProvider;
}