import '../entities/cart_order.dart';
import '../repositories/cart_order_repository.dart';

/// 创建购物车订单用例
class CreateCartOrderUseCase {
  final CartOrderRepository repository;

  CreateCartOrderUseCase(this.repository);

  Future<CartOrder> call(CreateCartOrderParams params) async {
    return await repository.createOrder(params.order);
  }
}

/// 创建订单参数
class CreateCartOrderParams {
  final CartOrder order;

  CreateCartOrderParams({required this.order});
}