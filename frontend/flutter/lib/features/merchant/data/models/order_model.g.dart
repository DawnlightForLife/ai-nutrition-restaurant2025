// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
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
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
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

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
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

Map<String, dynamic> _$$OrderItemModelImplToJson(
        _$OrderItemModelImpl instance) =>
    <String, dynamic>{
      'dish_id': instance.dishId,
      'dish_name': instance.dishName,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'special_requests': instance.specialRequests,
      'nutrition_info': instance.nutritionInfo,
    };

_$OrderStatusUpdateRequestImpl _$$OrderStatusUpdateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderStatusUpdateRequestImpl(
      newStatus: json['new_status'] as String,
      cancelReason: json['cancel_reason'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$OrderStatusUpdateRequestImplToJson(
        _$OrderStatusUpdateRequestImpl instance) =>
    <String, dynamic>{
      'new_status': instance.newStatus,
      if (instance.cancelReason case final value?) 'cancel_reason': value,
      if (instance.notes case final value?) 'notes': value,
    };

_$BatchOrderStatusUpdateRequestImpl
    _$$BatchOrderStatusUpdateRequestImplFromJson(Map<String, dynamic> json) =>
        _$BatchOrderStatusUpdateRequestImpl(
          orderIds: (json['order_ids'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          newStatus: json['new_status'] as String,
          notes: json['notes'] as String?,
        );

Map<String, dynamic> _$$BatchOrderStatusUpdateRequestImplToJson(
        _$BatchOrderStatusUpdateRequestImpl instance) =>
    <String, dynamic>{
      'order_ids': instance.orderIds,
      'new_status': instance.newStatus,
      if (instance.notes case final value?) 'notes': value,
    };

_$OrderStatusUpdateRequestImpl _$$OrderStatusUpdateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderStatusUpdateRequestImpl(
      newStatus: json['new_status'] as String,
      cancelReason: json['cancel_reason'] as String?,
    );

Map<String, dynamic> _$$OrderStatusUpdateRequestImplToJson(
        _$OrderStatusUpdateRequestImpl instance) =>
    <String, dynamic>{
      'new_status': instance.newStatus,
      if (instance.cancelReason case final value?) 'cancel_reason': value,
    };

_$BatchOrderStatusUpdateRequestImpl
    _$$BatchOrderStatusUpdateRequestImplFromJson(Map<String, dynamic> json) =>
        _$BatchOrderStatusUpdateRequestImpl(
          orderIds: (json['order_ids'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          newStatus: json['new_status'] as String,
        );

Map<String, dynamic> _$$BatchOrderStatusUpdateRequestImplToJson(
        _$BatchOrderStatusUpdateRequestImpl instance) =>
    <String, dynamic>{
      'order_ids': instance.orderIds,
      'new_status': instance.newStatus,
    };
