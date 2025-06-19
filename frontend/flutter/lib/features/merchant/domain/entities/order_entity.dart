import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_entity.freezed.dart';
part 'order_entity.g.dart';

@freezed
class OrderEntity with _$OrderEntity {
  const factory OrderEntity({
    @JsonKey(name: '_id') required String id,
    required String orderNumber,
    required String userId,
    required String merchantId,
    required String storeId,
    required OrderStatus status,
    required OrderType orderType,
    required double totalAmount,
    required double actualAmount,
    @Default(0.0) double discountAmount,
    required PaymentStatus paymentStatus,
    @Default('') String paymentMethod,
    required List<OrderItemEntity> items,
    @Default('') String customerName,
    @Default('') String customerPhone,
    @Default('') String deliveryAddress,
    @Default('') String notes,
    @Default('') String cancelReason,
    DateTime? estimatedPrepTime,
    DateTime? actualPrepTime,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _OrderEntity;

  factory OrderEntity.fromJson(Map<String, dynamic> json) => _$OrderEntityFromJson(json);
}

@freezed
class OrderItemEntity with _$OrderItemEntity {
  const factory OrderItemEntity({
    required String dishId,
    required String dishName,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    @Default([]) List<String> specialRequests,
    @Default({}) Map<String, dynamic> nutritionInfo,
  }) = _OrderItemEntity;

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) => _$OrderItemEntityFromJson(json);
}

@freezed
class ProductionQueueEntity with _$ProductionQueueEntity {
  const factory ProductionQueueEntity({
    required List<OrderEntity> pendingOrders,
    required List<OrderEntity> preparingOrders,
    required List<OrderEntity> readyOrders,
    required int totalOrders,
    required double averagePrepTime,
    required DateTime lastUpdated,
  }) = _ProductionQueueEntity;

  factory ProductionQueueEntity.fromJson(Map<String, dynamic> json) => _$ProductionQueueEntityFromJson(json);
}

@freezed
class DeliveryManagementEntity with _$DeliveryManagementEntity {
  const factory DeliveryManagementEntity({
    required List<OrderEntity> readyForDelivery,
    required List<OrderEntity> outForDelivery,
    required List<OrderEntity> delivered,
    required int totalDeliveries,
    required double averageDeliveryTime,
    required DateTime lastUpdated,
  }) = _DeliveryManagementEntity;

  factory DeliveryManagementEntity.fromJson(Map<String, dynamic> json) => _$DeliveryManagementEntityFromJson(json);
}

@freezed
class OrderAnalyticsEntity with _$OrderAnalyticsEntity {
  const factory OrderAnalyticsEntity({
    required int totalOrders,
    required int completedOrders,
    required int cancelledOrders,
    required int pendingOrders,
    required double totalRevenue,
    required double averageOrderValue,
    required double averagePrepTime,
    required Map<String, int> ordersByStatus,
    required Map<String, double> revenueByDay,
    required List<TopDishEntity> topDishes,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) = _OrderAnalyticsEntity;

  factory OrderAnalyticsEntity.fromJson(Map<String, dynamic> json) => _$OrderAnalyticsEntityFromJson(json);
}

@freezed
class TopDishEntity with _$TopDishEntity {
  const factory TopDishEntity({
    required String dishId,
    required String dishName,
    required int orderCount,
    required double revenue,
  }) = _TopDishEntity;

  factory TopDishEntity.fromJson(Map<String, dynamic> json) => _$TopDishEntityFromJson(json);
}

// 订单状态枚举
enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('preparing')
  preparing,
  @JsonValue('ready')
  ready,
  @JsonValue('delivering')
  delivering,
  @JsonValue('delivered')
  delivered,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

// 订单类型枚举
enum OrderType {
  @JsonValue('dine_in')
  dineIn,
  @JsonValue('takeout')
  takeout,
  @JsonValue('delivery')
  delivery,
}

// 支付状态枚举
enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('paid')
  paid,
  @JsonValue('refunded')
  refunded,
  @JsonValue('failed')
  failed,
}

// Extension methods for enums
extension OrderStatusX on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return '待确认';
      case OrderStatus.confirmed:
        return '已确认';
      case OrderStatus.preparing:
        return '制作中';
      case OrderStatus.ready:
        return '已完成';
      case OrderStatus.delivering:
        return '配送中';
      case OrderStatus.delivered:
        return '已送达';
      case OrderStatus.completed:
        return '已完成';
      case OrderStatus.cancelled:
        return '已取消';
    }
  }

  String get value {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.confirmed:
        return 'confirmed';
      case OrderStatus.preparing:
        return 'preparing';
      case OrderStatus.ready:
        return 'ready';
      case OrderStatus.delivering:
        return 'delivering';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.completed:
        return 'completed';
      case OrderStatus.cancelled:
        return 'cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFFFFA726); // Orange
      case OrderStatus.confirmed:
        return const Color(0xFF42A5F5); // Blue
      case OrderStatus.preparing:
        return const Color(0xFF66BB6A); // Green
      case OrderStatus.ready:
        return const Color(0xFF26A69A); // Teal
      case OrderStatus.delivering:
        return const Color(0xFF5C6BC0); // Indigo
      case OrderStatus.delivered:
        return const Color(0xFF4CAF50); // Green
      case OrderStatus.completed:
        return const Color(0xFF4CAF50); // Green
      case OrderStatus.cancelled:
        return const Color(0xFFEF5350); // Red
    }
  }
}

extension OrderTypeX on OrderType {
  String get displayName {
    switch (this) {
      case OrderType.dineIn:
        return '堂食';
      case OrderType.takeout:
        return '外带';
      case OrderType.delivery:
        return '外送';
    }
  }

  String get value {
    switch (this) {
      case OrderType.dineIn:
        return 'dine_in';
      case OrderType.takeout:
        return 'takeout';
      case OrderType.delivery:
        return 'delivery';
    }
  }

  IconData get icon {
    switch (this) {
      case OrderType.dineIn:
        return Icons.restaurant;
      case OrderType.takeout:
        return Icons.shopping_bag;
      case OrderType.delivery:
        return Icons.delivery_dining;
    }
  }
}

extension PaymentStatusX on PaymentStatus {
  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return '待支付';
      case PaymentStatus.paid:
        return '已支付';
      case PaymentStatus.refunded:
        return '已退款';
      case PaymentStatus.failed:
        return '支付失败';
    }
  }

  Color get color {
    switch (this) {
      case PaymentStatus.pending:
        return const Color(0xFFFFA726); // Orange
      case PaymentStatus.paid:
        return const Color(0xFF4CAF50); // Green
      case PaymentStatus.refunded:
        return const Color(0xFF9E9E9E); // Grey
      case PaymentStatus.failed:
        return const Color(0xFFEF5350); // Red
    }
  }
}

