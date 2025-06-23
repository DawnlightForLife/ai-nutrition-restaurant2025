// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
