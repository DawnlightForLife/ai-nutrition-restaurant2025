import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../nutrition_cart/presentation/widgets/nutrition_cart_bottom_bar.dart';

/// Compatibility wrapper for CartBottomBar
/// Redirects to the new nutrition cart system
class CartBottomBar extends ConsumerWidget {
  const CartBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the new nutrition cart bottom bar
    return const NutritionCartBottomBar(
      userId: 'current_user',
    );
  }
}

