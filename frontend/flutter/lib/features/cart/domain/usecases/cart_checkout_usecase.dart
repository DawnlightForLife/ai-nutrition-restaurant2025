/**
 * 购物车结账用例
 * 兼容性文件，实际功能已转移到营养订单系统
 */

import '../entities/cart.dart';

/// 结账验证结果
class CheckoutValidation {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final double totalAmount;
  final double deliveryFee;
  final double discount;
  
  const CheckoutValidation({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.totalAmount,
    required this.deliveryFee,
    required this.discount,
  });
}

/// 购物车结账用例
class CartCheckoutUseCase {
  /// 验证结账
  Future<CheckoutValidation> validateCheckout(String userId) async {
    // 实际实现应该委托给营养订单系统
    return const CheckoutValidation(
      isValid: false,
      errors: ['请使用营养订单系统进行结账'],
      warnings: [],
      totalAmount: 0.0,
      deliveryFee: 0.0,
      discount: 0.0,
    );
  }

  /// 创建订单
  Future<String> createOrder(String userId, Map<String, dynamic> orderData) async {
    throw UnimplementedError('请使用营养订单系统 (NutritionOrderProvider)');
  }

  /// 计算总价
  Future<double> calculateTotal(String userId) async {
    throw UnimplementedError('请使用营养购物车系统 (NutritionCartProvider)');
  }

  /// 应用优惠券
  Future<double> applyCoupon(String userId, String couponCode) async {
    throw UnimplementedError('请使用营养购物车系统 (NutritionCartProvider)');
  }
}