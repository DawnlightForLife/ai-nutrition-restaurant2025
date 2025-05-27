import 'domain_event.dart';

/// 订单完成事件
class OrderCompletedEvent extends DomainEvent {
  final String orderId;
  final String userId;
  final double totalAmount;
  final List<String> dishIds;

  OrderCompletedEvent({
    required this.orderId,
    required this.userId,
    required this.totalAmount,
    required this.dishIds,
  }) : super();

  @override
  List<Object?> get props => [...super.props, orderId, userId, totalAmount, dishIds];
}

/// 用餐完成事件
class MealConsumedEvent extends DomainEvent {
  final String orderId;
  final String userId;
  final List<String> consumedDishIds;
  final DateTime consumedAt;

  MealConsumedEvent({
    required this.orderId,
    required this.userId,
    required this.consumedDishIds,
    required this.consumedAt,
  }) : super();

  @override
  List<Object?> get props => [...super.props, orderId, userId, consumedDishIds, consumedAt];
} 