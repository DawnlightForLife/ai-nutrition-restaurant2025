import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../nutrition_cart/presentation/widgets/nutrition_cart_management_bar.dart';

/// Compatibility wrapper for CartManagementBar
/// Redirects to the new nutrition cart system
class CartManagementBar extends ConsumerWidget {
  const CartManagementBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the new nutrition cart management bar
    return const NutritionCartManagementBar(
      userId: 'current_user',
    );
  }
}

