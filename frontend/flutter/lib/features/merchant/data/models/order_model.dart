import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order_entity.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
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
    required List<OrderItemModel> items,
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
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle backend response structure differences
    final transformedJson = Map<String, dynamic>.from(json);
    
    // Transform price fields
    if (json['priceDetails'] != null) {
      transformedJson['totalAmount'] = json['priceDetails']['total'] ?? 0.0;
      transformedJson['actualAmount'] = json['priceDetails']['total'] ?? 0.0;
      transformedJson['discountAmount'] = json['priceDetails']['discount'] ?? 0.0;
    }
    
    // Transform delivery/customer fields
    if (json['delivery'] != null) {
      transformedJson['customerName'] = json['delivery']['contactName'] ?? '';
      transformedJson['customerPhone'] = json['delivery']['contactPhone'] ?? '';
      transformedJson['deliveryAddress'] = json['delivery']['address'] is Map 
          ? json['delivery']['address']['fullAddress'] ?? ''
          : json['delivery']['address'] ?? '';
    }
    
    // Transform payment fields
    if (json['payment'] != null) {
      transformedJson['paymentStatus'] = json['payment']['status'] ?? 'pending';
      transformedJson['paymentMethod'] = json['payment']['method'] ?? '';
    }
    
    // Transform items
    if (json['items'] != null) {
      transformedJson['items'] = (json['items'] as List).map((item) => {
        'dishId': item['dishId'] ?? '',
        'dishName': item['name'] ?? '',
        'quantity': item['quantity'] ?? 0,
        'unitPrice': item['price'] ?? 0.0,
        'totalPrice': item['itemTotal'] ?? 0.0,
        'specialRequests': item['specialInstructions'] != null 
            ? [item['specialInstructions']] 
            : [],
        'nutritionInfo': item['nutritionInfo'] ?? {},
      }).toList();
    }
    
    return _$OrderModelFromJson(transformedJson);
  }
}

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String dishId,
    required String dishName,
    required int quantity,
    required double unitPrice,
    required double totalPrice,
    @Default([]) List<String> specialRequests,
    @Default({}) Map<String, dynamic> nutritionInfo,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
}

@freezed
class OrderStatusUpdateRequest with _$OrderStatusUpdateRequest {
  const factory OrderStatusUpdateRequest({
    required String newStatus,
    String? cancelReason,
    String? notes,
  }) = _OrderStatusUpdateRequest;

  factory OrderStatusUpdateRequest.fromJson(Map<String, dynamic> json) => 
      _$OrderStatusUpdateRequestFromJson(json);
}

@freezed
class BatchOrderStatusUpdateRequest with _$BatchOrderStatusUpdateRequest {
  const factory BatchOrderStatusUpdateRequest({
    required List<String> orderIds,
    required String newStatus,
    String? notes,
  }) = _BatchOrderStatusUpdateRequest;

  factory BatchOrderStatusUpdateRequest.fromJson(Map<String, dynamic> json) => 
      _$BatchOrderStatusUpdateRequestFromJson(json);
}

// Extension methods to convert between models and entities
extension OrderModelX on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderNumber: orderNumber,
      userId: userId,
      merchantId: merchantId,
      storeId: storeId,
      status: status,
      orderType: orderType,
      totalAmount: totalAmount,
      actualAmount: actualAmount,
      discountAmount: discountAmount,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      items: items.map((item) => item.toEntity()).toList(),
      customerName: customerName,
      customerPhone: customerPhone,
      deliveryAddress: deliveryAddress,
      notes: notes,
      cancelReason: cancelReason,
      estimatedPrepTime: estimatedPrepTime,
      actualPrepTime: actualPrepTime,
      estimatedDeliveryTime: estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension OrderItemModelX on OrderItemModel {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      dishId: dishId,
      dishName: dishName,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      specialRequests: specialRequests,
      nutritionInfo: nutritionInfo,
    );
  }
}