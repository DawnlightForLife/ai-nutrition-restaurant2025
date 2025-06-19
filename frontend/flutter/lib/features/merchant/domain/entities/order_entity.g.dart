// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderEntityImpl _$$OrderEntityImplFromJson(Map<String, dynamic> json) =>
    _$OrderEntityImpl(
      id: json['_id'] as String,
      orderNumber: json['order_number'] as String,
      userId: json['user_id'] as String,
      merchantId: json['merchant_id'] as String,
      storeId: json['store_id'] as String,
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      orderType: $enumDecode(_$OrderTypeEnumMap, json['order_type']),
      totalAmount: (json['total_amount'] as num).toDouble(),
      actualAmount: (json['actual_amount'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus:
          $enumDecode(_$PaymentStatusEnumMap, json['payment_status']),
      paymentMethod: json['payment_method'] as String? ?? '',
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerName: json['customer_name'] as String? ?? '',
      customerPhone: json['customer_phone'] as String? ?? '',
      deliveryAddress: json['delivery_address'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      cancelReason: json['cancel_reason'] as String? ?? '',
      estimatedPrepTime: json['estimated_prep_time'] == null
          ? null
          : DateTime.parse(json['estimated_prep_time'] as String),
      actualPrepTime: json['actual_prep_time'] == null
          ? null
          : DateTime.parse(json['actual_prep_time'] as String),
      estimatedDeliveryTime: json['estimated_delivery_time'] == null
          ? null
          : DateTime.parse(json['estimated_delivery_time'] as String),
      actualDeliveryTime: json['actual_delivery_time'] == null
          ? null
          : DateTime.parse(json['actual_delivery_time'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OrderEntityImplToJson(_$OrderEntityImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'order_number': instance.orderNumber,
      'user_id': instance.userId,
      'merchant_id': instance.merchantId,
      'store_id': instance.storeId,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'order_type': _$OrderTypeEnumMap[instance.orderType]!,
      'total_amount': instance.totalAmount,
      'actual_amount': instance.actualAmount,
      'discount_amount': instance.discountAmount,
      'payment_status': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'payment_method': instance.paymentMethod,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'delivery_address': instance.deliveryAddress,
      'notes': instance.notes,
      'cancel_reason': instance.cancelReason,
      if (instance.estimatedPrepTime?.toIso8601String() case final value?)
        'estimated_prep_time': value,
      if (instance.actualPrepTime?.toIso8601String() case final value?)
        'actual_prep_time': value,
      if (instance.estimatedDeliveryTime?.toIso8601String() case final value?)
        'estimated_delivery_time': value,
      if (instance.actualDeliveryTime?.toIso8601String() case final value?)
        'actual_delivery_time': value,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.delivering: 'delivering',
  OrderStatus.delivered: 'delivered',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

const _$OrderTypeEnumMap = {
  OrderType.dineIn: 'dine_in',
  OrderType.takeout: 'takeout',
  OrderType.delivery: 'delivery',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.failed: 'failed',
};

_$OrderItemEntityImpl _$$OrderItemEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderItemEntityImpl(
      dishId: json['dish_id'] as String,
      dishName: json['dish_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      specialRequests: (json['special_requests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionInfo:
          json['nutrition_info'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$OrderItemEntityImplToJson(
        _$OrderItemEntityImpl instance) =>
    <String, dynamic>{
      'dish_id': instance.dishId,
      'dish_name': instance.dishName,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'special_requests': instance.specialRequests,
      'nutrition_info': instance.nutritionInfo,
    };

_$ProductionQueueEntityImpl _$$ProductionQueueEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductionQueueEntityImpl(
      pendingOrders: (json['pending_orders'] as List<dynamic>)
          .map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      preparingOrders: (json['preparing_orders'] as List<dynamic>)
          .map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      readyOrders: (json['ready_orders'] as List<dynamic>)
          .map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalOrders: (json['total_orders'] as num).toInt(),
      averagePrepTime: (json['average_prep_time'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$ProductionQueueEntityImplToJson(
        _$ProductionQueueEntityImpl instance) =>
    <String, dynamic>{
      'pending_orders': instance.pendingOrders.map((e) => e.toJson()).toList(),
      'preparing_orders':
          instance.preparingOrders.map((e) => e.toJson()).toList(),
      'ready_orders': instance.readyOrders.map((e) => e.toJson()).toList(),
      'total_orders': instance.totalOrders,
      'average_prep_time': instance.averagePrepTime,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };

_$DeliveryManagementEntityImpl _$$DeliveryManagementEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$DeliveryManagementEntityImpl(
      readyForDelivery: (json['ready_for_delivery'] as List<dynamic>)
          .map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      outForDelivery: (json['out_for_delivery'] as List<dynamic>)
          .map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      delivered: (json['delivered'] as List<dynamic>)
          .map((e) => OrderEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDeliveries: (json['total_deliveries'] as num).toInt(),
      averageDeliveryTime: (json['average_delivery_time'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$$DeliveryManagementEntityImplToJson(
        _$DeliveryManagementEntityImpl instance) =>
    <String, dynamic>{
      'ready_for_delivery':
          instance.readyForDelivery.map((e) => e.toJson()).toList(),
      'out_for_delivery':
          instance.outForDelivery.map((e) => e.toJson()).toList(),
      'delivered': instance.delivered.map((e) => e.toJson()).toList(),
      'total_deliveries': instance.totalDeliveries,
      'average_delivery_time': instance.averageDeliveryTime,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };

_$OrderAnalyticsEntityImpl _$$OrderAnalyticsEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderAnalyticsEntityImpl(
      totalOrders: (json['total_orders'] as num).toInt(),
      completedOrders: (json['completed_orders'] as num).toInt(),
      cancelledOrders: (json['cancelled_orders'] as num).toInt(),
      pendingOrders: (json['pending_orders'] as num).toInt(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      averageOrderValue: (json['average_order_value'] as num).toDouble(),
      averagePrepTime: (json['average_prep_time'] as num).toDouble(),
      ordersByStatus: Map<String, int>.from(json['orders_by_status'] as Map),
      revenueByDay: (json['revenue_by_day'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      topDishes: (json['top_dishes'] as List<dynamic>)
          .map((e) => TopDishEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
    );

Map<String, dynamic> _$$OrderAnalyticsEntityImplToJson(
        _$OrderAnalyticsEntityImpl instance) =>
    <String, dynamic>{
      'total_orders': instance.totalOrders,
      'completed_orders': instance.completedOrders,
      'cancelled_orders': instance.cancelledOrders,
      'pending_orders': instance.pendingOrders,
      'total_revenue': instance.totalRevenue,
      'average_order_value': instance.averageOrderValue,
      'average_prep_time': instance.averagePrepTime,
      'orders_by_status': instance.ordersByStatus,
      'revenue_by_day': instance.revenueByDay,
      'top_dishes': instance.topDishes.map((e) => e.toJson()).toList(),
      'period_start': instance.periodStart.toIso8601String(),
      'period_end': instance.periodEnd.toIso8601String(),
    };

_$TopDishEntityImpl _$$TopDishEntityImplFromJson(Map<String, dynamic> json) =>
    _$TopDishEntityImpl(
      dishId: json['dish_id'] as String,
      dishName: json['dish_name'] as String,
      orderCount: (json['order_count'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$$TopDishEntityImplToJson(_$TopDishEntityImpl instance) =>
    <String, dynamic>{
      'dish_id': instance.dishId,
      'dish_name': instance.dishName,
      'order_count': instance.orderCount,
      'revenue': instance.revenue,
    };
