import 'package:flutter/foundation.dart';
import '../../../domain/abstractions/repositories/i_order_repository.dart';

/// 订单Provider
class OrderProvider extends ChangeNotifier {
  final IOrderRepository _orderRepository;
  final String _userId;
  
  OrderProvider({
    required IOrderRepository orderRepository,
    required String userId,
  }) : _orderRepository = orderRepository,
       _userId = userId;
  
  // TODO(dev): 实现订单相关功能
}