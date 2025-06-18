import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'nutrition_cart_page.dart';

/// 购物车页面 - 兼容性重定向
/// 实际功能已迁移到营养购物车系统
class CartPage extends ConsumerWidget {
  const CartPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 重定向到新的营养购物车页面
    return const NutritionCartPage(
      userId: 'current_user', // TODO: 从用户状态获取实际用户ID
    );
  }
}