import '../entities/cart_order.dart';

/// 购物车订单仓储接口
abstract class CartOrderRepository {
  /// 创建订单
  Future<CartOrder> createOrder(CartOrder order);
  
  /// 获取订单详情
  Future<CartOrder> getOrder(String orderId);
  
  /// 获取用户订单列表
  Future<List<CartOrder>> getUserOrders(String userId);
  
  /// 更新订单状态
  Future<CartOrder> updateOrderStatus(String orderId, String status);
  
  /// 取消订单
  Future<void> cancelOrder(String orderId);
  
  /// 获取订单状态更新
  Stream<CartOrder> watchOrderStatus(String orderId);
}