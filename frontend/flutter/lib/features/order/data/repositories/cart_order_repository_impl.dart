import '../../domain/entities/cart_order.dart';
import '../../domain/repositories/cart_order_repository.dart';
import '../datasources/cart_order_remote_datasource.dart';
import '../models/cart_order_model.dart';

/// 购物车订单仓储实现
class CartOrderRepositoryImpl implements CartOrderRepository {
  final CartOrderRemoteDataSource remoteDataSource;

  CartOrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<CartOrder> createOrder(CartOrder order) async {
    final orderModel = CartOrderModel.fromEntity(order);
    final result = await remoteDataSource.createOrder(orderModel);
    return result.toEntity();
  }

  @override
  Future<CartOrder> getOrder(String orderId) async {
    final result = await remoteDataSource.getOrder(orderId);
    return result.toEntity();
  }

  @override
  Future<List<CartOrder>> getUserOrders(String userId) async {
    final result = await remoteDataSource.getUserOrders(userId);
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<CartOrder> updateOrderStatus(String orderId, String status) async {
    final result = await remoteDataSource.updateOrderStatus(orderId, status);
    return result.toEntity();
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await remoteDataSource.cancelOrder(orderId);
  }

  @override
  Stream<CartOrder> watchOrderStatus(String orderId) {
    // TODO(dev): 实现WebSocket或SSE订单状态实时更新
    throw UnimplementedError('订单状态实时监听功能暂未实现');
  }
}