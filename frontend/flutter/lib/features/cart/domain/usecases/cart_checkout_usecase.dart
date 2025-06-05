import '../../../../core/base/use_case.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// 购物车结算用例
class CartCheckoutUseCase {
  final CartRepository _repository;
  
  const CartCheckoutUseCase(this._repository);
  
  /// 预结算检查
  Future<CheckoutValidation> validateCheckout(String userId) async {
    final cart = await _repository.getCart(userId);
    
    // 检查购物车是否为空
    if (cart.isEmpty) {
      return CheckoutValidation(
        isValid: false,
        message: '购物车为空，请先添加商品',
      );
    }
    
    // 检查是否有失效商品
    if (cart.hasInvalidItems) {
      return CheckoutValidation(
        isValid: false,
        message: '购物车中有失效商品，请清理后再下单',
        hasInvalidItems: true,
      );
    }
    
    // 检查起送金额
    final merchantGroups = cart.merchantGroups;
    final unmetGroups = merchantGroups
        .where((group) => !group.isMinOrderAmountMet)
        .toList();
    
    if (unmetGroups.isNotEmpty) {
      final firstUnmet = unmetGroups.first;
      return CheckoutValidation(
        isValid: false,
        message: '${firstUnmet.merchantName} 还差 ¥${firstUnmet.amountToMinOrder.toStringAsFixed(2)} 起送',
        minOrderNotMet: true,
      );
    }
    
    // 验证库存
    final dishIds = cart.validItems.map((item) => item.dishId).toList();
    final stockStatus = await _repository.checkStock(dishIds);
    final outOfStockItems = cart.validItems
        .where((item) => stockStatus[item.dishId] != true)
        .toList();
    
    if (outOfStockItems.isNotEmpty) {
      return CheckoutValidation(
        isValid: false,
        message: '${outOfStockItems.first.name} 等商品库存不足',
        outOfStockItems: outOfStockItems.map((item) => item.id).toList(),
      );
    }
    
    return CheckoutValidation(
      isValid: true,
      message: '可以结算',
      cart: cart,
    );
  }
  
  /// 应用优惠券
  Future<Cart> applyCoupon(String userId, String couponId) async {
    return await _repository.applyCoupon(userId, couponId);
  }
  
  /// 移除优惠券
  Future<Cart> removeCoupon(String userId, String couponId) async {
    return await _repository.removeCoupon(userId, couponId);
  }
  
  /// 预估配送
  Future<DeliveryEstimate> estimateDelivery(String userId, String addressId) async {
    final result = await _repository.estimateDelivery(userId, addressId);
    
    return DeliveryEstimate(
      deliveryFee: result['deliveryFee']?.toDouble() ?? 0.0,
      estimatedTime: result['estimatedTime'] ?? '约30分钟',
      isAvailable: result['isAvailable'] ?? true,
      message: result['message'],
    );
  }
}

/// 结算验证结果
class CheckoutValidation {
  final bool isValid;
  final String message;
  final Cart? cart;
  final bool hasInvalidItems;
  final bool minOrderNotMet;
  final List<String> outOfStockItems;
  
  const CheckoutValidation({
    required this.isValid,
    required this.message,
    this.cart,
    this.hasInvalidItems = false,
    this.minOrderNotMet = false,
    this.outOfStockItems = const [],
  });
}

/// 配送预估
class DeliveryEstimate {
  final double deliveryFee;
  final String estimatedTime;
  final bool isAvailable;
  final String? message;
  
  const DeliveryEstimate({
    required this.deliveryFee,
    required this.estimatedTime,
    required this.isAvailable,
    this.message,
  });
}