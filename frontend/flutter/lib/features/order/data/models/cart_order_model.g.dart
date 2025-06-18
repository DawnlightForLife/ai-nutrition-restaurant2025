// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartOrderItemModelImpl _$$CartOrderItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CartOrderItemModelImpl(
      dishId: json['dish_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      itemTotal: (json['item_total'] as num).toDouble(),
      specifications: json['specifications'] as String?,
      imageUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$$CartOrderItemModelImplToJson(
        _$CartOrderItemModelImpl instance) =>
    <String, dynamic>{
      'dish_id': instance.dishId,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'item_total': instance.itemTotal,
      if (instance.specifications case final value?) 'specifications': value,
      if (instance.imageUrl case final value?) 'image_url': value,
    };

_$OrderPriceDetailsModelImpl _$$OrderPriceDetailsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderPriceDetailsModelImpl(
      subtotal: (json['subtotal'] as num).toDouble(),
      serviceCharge: (json['service_charge'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      couponCode: json['coupon_code'] as String?,
    );

Map<String, dynamic> _$$OrderPriceDetailsModelImplToJson(
        _$OrderPriceDetailsModelImpl instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'service_charge': instance.serviceCharge,
      'tax': instance.tax,
      'total': instance.total,
      if (instance.discount case final value?) 'discount': value,
      if (instance.couponCode case final value?) 'coupon_code': value,
    };

_$OrderPaymentModelImpl _$$OrderPaymentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderPaymentModelImpl(
      method: json['method'] as String,
      status: json['status'] as String,
      transactionId: json['transaction_id'] as String?,
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
    );

Map<String, dynamic> _$$OrderPaymentModelImplToJson(
        _$OrderPaymentModelImpl instance) =>
    <String, dynamic>{
      'method': instance.method,
      'status': instance.status,
      if (instance.transactionId case final value?) 'transaction_id': value,
      if (instance.paidAt?.toIso8601String() case final value?)
        'paid_at': value,
    };

_$CartOrderModelImpl _$$CartOrderModelImplFromJson(Map<String, dynamic> json) =>
    _$CartOrderModelImpl(
      id: json['id'] as String?,
      orderNumber: json['order_number'] as String?,
      userId: json['user_id'] as String,
      merchantId: json['merchant_id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartOrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceDetails: OrderPriceDetailsModel.fromJson(
          json['price_details'] as Map<String, dynamic>),
      payment:
          OrderPaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
      orderType: json['order_type'] as String,
      tableNumber: json['table_number'] as String?,
      specialNotes: json['special_notes'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      estimatedTime: json['estimated_time'] as String?,
    );

Map<String, dynamic> _$$CartOrderModelImplToJson(
        _$CartOrderModelImpl instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.orderNumber case final value?) 'order_number': value,
      'user_id': instance.userId,
      'merchant_id': instance.merchantId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'price_details': instance.priceDetails.toJson(),
      'payment': instance.payment.toJson(),
      'order_type': instance.orderType,
      if (instance.tableNumber case final value?) 'table_number': value,
      if (instance.specialNotes case final value?) 'special_notes': value,
      'status': instance.status,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      if (instance.estimatedTime case final value?) 'estimated_time': value,
    };
