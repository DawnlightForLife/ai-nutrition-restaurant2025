import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cart_order.dart';

part 'cart_order_model.freezed.dart';
part 'cart_order_model.g.dart';

/// 购物车订单项模型
@freezed
class CartOrderItemModel with _$CartOrderItemModel {
  const factory CartOrderItemModel({
    required String dishId,
    required String name,
    required double price,
    required int quantity,
    required double itemTotal,
    String? specifications,
    String? imageUrl,
  }) = _CartOrderItemModel;

  factory CartOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartOrderItemModelFromJson(json);
      
  const CartOrderItemModel._();

  /// 转换为实体
  CartOrderItem toEntity() => CartOrderItem(
    dishId: dishId,
    name: name,
    price: price,
    quantity: quantity,
    itemTotal: itemTotal,
    specifications: specifications,
    imageUrl: imageUrl,
  );

  /// 从实体创建
  factory CartOrderItemModel.fromEntity(CartOrderItem entity) => CartOrderItemModel(
    dishId: entity.dishId,
    name: entity.name,
    price: entity.price,
    quantity: entity.quantity,
    itemTotal: entity.itemTotal,
    specifications: entity.specifications,
    imageUrl: entity.imageUrl,
  );
}

/// 订单价格详情模型
@freezed
class OrderPriceDetailsModel with _$OrderPriceDetailsModel {
  const factory OrderPriceDetailsModel({
    required double subtotal,
    required double serviceCharge,
    required double tax,
    required double total,
    double? discount,
    String? couponCode,
  }) = _OrderPriceDetailsModel;

  factory OrderPriceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$OrderPriceDetailsModelFromJson(json);
      
  const OrderPriceDetailsModel._();

  /// 转换为实体
  OrderPriceDetails toEntity() => OrderPriceDetails(
    subtotal: subtotal,
    serviceCharge: serviceCharge,
    tax: tax,
    total: total,
    discount: discount,
    couponCode: couponCode,
  );

  /// 从实体创建
  factory OrderPriceDetailsModel.fromEntity(OrderPriceDetails entity) => OrderPriceDetailsModel(
    subtotal: entity.subtotal,
    serviceCharge: entity.serviceCharge,
    tax: entity.tax,
    total: entity.total,
    discount: entity.discount,
    couponCode: entity.couponCode,
  );
}

/// 支付信息模型
@freezed
class OrderPaymentModel with _$OrderPaymentModel {
  const factory OrderPaymentModel({
    required String method,
    required String status,
    String? transactionId,
    DateTime? paidAt,
  }) = _OrderPaymentModel;

  factory OrderPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentModelFromJson(json);
      
  const OrderPaymentModel._();

  /// 转换为实体
  OrderPayment toEntity() => OrderPayment(
    method: method,
    status: status,
    transactionId: transactionId,
    paidAt: paidAt,
  );

  /// 从实体创建
  factory OrderPaymentModel.fromEntity(OrderPayment entity) => OrderPaymentModel(
    method: entity.method,
    status: entity.status,
    transactionId: entity.transactionId,
    paidAt: entity.paidAt,
  );
}

/// 购物车订单模型
@freezed
class CartOrderModel with _$CartOrderModel {
  const factory CartOrderModel({
    String? id,
    String? orderNumber,
    required String userId,
    required String merchantId,
    required List<CartOrderItemModel> items,
    required OrderPriceDetailsModel priceDetails,
    required OrderPaymentModel payment,
    required String orderType,
    String? tableNumber,
    String? specialNotes,
    required String status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? estimatedTime,
  }) = _CartOrderModel;

  factory CartOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CartOrderModelFromJson(json);
      
  const CartOrderModel._();

  /// 转换为实体
  CartOrder toEntity() => CartOrder(
    id: id,
    orderNumber: orderNumber,
    userId: userId,
    merchantId: merchantId,
    items: items.map((item) => item.toEntity()).toList(),
    priceDetails: priceDetails.toEntity(),
    payment: payment.toEntity(),
    orderType: orderType,
    tableNumber: tableNumber,
    specialNotes: specialNotes,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
    estimatedTime: estimatedTime,
  );

  /// 从实体创建
  factory CartOrderModel.fromEntity(CartOrder entity) => CartOrderModel(
    id: entity.id,
    orderNumber: entity.orderNumber,
    userId: entity.userId,
    merchantId: entity.merchantId,
    items: entity.items.map((item) => CartOrderItemModel.fromEntity(item)).toList(),
    priceDetails: OrderPriceDetailsModel.fromEntity(entity.priceDetails),
    payment: OrderPaymentModel.fromEntity(entity.payment),
    orderType: entity.orderType,
    tableNumber: entity.tableNumber,
    specialNotes: entity.specialNotes,
    status: entity.status,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    estimatedTime: entity.estimatedTime,
  );
}