import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_order.freezed.dart';

/// 购物车订单项
@freezed
class CartOrderItem with _$CartOrderItem {
  const factory CartOrderItem({
    required String dishId,
    required String name,
    required double price,
    required int quantity,
    required double itemTotal,
    String? specifications,
    String? imageUrl,
  }) = _CartOrderItem;
}

/// 订单价格详情
@freezed
class OrderPriceDetails with _$OrderPriceDetails {
  const factory OrderPriceDetails({
    required double subtotal,
    required double serviceCharge,
    required double tax,
    required double total,
    double? discount,
    String? couponCode,
  }) = _OrderPriceDetails;
}

/// 支付信息
@freezed
class OrderPayment with _$OrderPayment {
  const factory OrderPayment({
    required String method, // 'cash', 'wechat', 'alipay'
    required String status, // 'pending', 'paid', 'failed'
    String? transactionId,
    DateTime? paidAt,
  }) = _OrderPayment;
}

/// 购物车订单实体
@freezed
class CartOrder with _$CartOrder {
  const factory CartOrder({
    String? id,
    String? orderNumber,
    required String userId,
    required String merchantId,
    required List<CartOrderItem> items,
    required OrderPriceDetails priceDetails,
    required OrderPayment payment,
    required String orderType, // 'dine_in', 'takeaway'
    String? tableNumber,
    String? specialNotes,
    required String status, // 'pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled'
    DateTime? createdAt,
    DateTime? updatedAt,
    String? estimatedTime,
  }) = _CartOrder;

  const CartOrder._();

  /// 计算总商品数量
  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  /// 检查是否为堂食订单
  bool get isDineIn => orderType == 'dine_in';

  /// 检查是否为外卖订单
  bool get isTakeaway => orderType == 'takeaway';

  /// 检查是否已支付
  bool get isPaid => payment.status == 'paid';

  /// 检查是否可以取消
  bool get canCancel => status == 'pending' || status == 'confirmed';

  /// 获取状态显示文本
  String get statusDisplayText {
    switch (status) {
      case 'pending':
        return '待确认';
      case 'confirmed':
        return '已确认';
      case 'preparing':
        return '制作中';
      case 'ready':
        return '待取餐';
      case 'completed':
        return '已完成';
      case 'cancelled':
        return '已取消';
      default:
        return '未知状态';
    }
  }

  /// 获取支付方式显示文本
  String get paymentMethodDisplayText {
    switch (payment.method) {
      case 'cash':
        return '现金支付';
      case 'wechat':
        return '微信支付';
      case 'alipay':
        return '支付宝';
      default:
        return '未知支付方式';
    }
  }
}