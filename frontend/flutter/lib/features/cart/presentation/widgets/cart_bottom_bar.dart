import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/cart.dart';
import '../providers/cart_provider.dart';

class CartBottomBar extends ConsumerWidget {
  const CartBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return _CartBottomBarContent(cart: cart);
  }
}

class _CartBottomBarContent extends ConsumerWidget {
  final Cart cart;

  const _CartBottomBarContent({required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasValidItems = cart.items.any((item) => item.isValid);
    final canCheckout = hasValidItems && _canAllGroupsCheckout(cart);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!canCheckout && hasValidItems) _buildMinOrderWarning(context),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPriceBreakdown(context),
                        const SizedBox(height: 4),
                        _buildTotalPrice(context),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildCheckoutButton(context, canCheckout),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinOrderWarning(BuildContext context) {
    final problematicGroups = cart.merchantGroups
        .where((group) => 
            group.minOrderAmount > 0 && 
            group.subtotal < group.minOrderAmount)
        .toList();

    if (problematicGroups.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              problematicGroups.length == 1
                  ? '${problematicGroups.first.merchantName} 还差¥${(problematicGroups.first.minOrderAmount - problematicGroups.first.subtotal).toStringAsFixed(2)}起送'
                  : '有${problematicGroups.length}家商户未达起送标准',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown(BuildContext context) {
    final discountAmount = cart.totalAmount - cart.finalAmount;
    
    if (discountAmount <= 0) return const SizedBox.shrink();

    return Row(
      children: [
        Text(
          '已优惠',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(width: 4),
        Text(
          '¥${discountAmount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(width: 8),
        if (cart.totalDeliveryFee > 0) ...[
          Text(
            '配送费¥${cart.totalDeliveryFee.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildTotalPrice(BuildContext context) {
    return Row(
      children: [
        Text(
          '合计：',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          '¥${cart.finalAmount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context, bool canCheckout) {
    return SizedBox(
      width: 120,
      height: 48,
      child: ElevatedButton(
        onPressed: canCheckout ? () => _handleCheckout(context) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canCheckout
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          foregroundColor: canCheckout
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          canCheckout ? '去结算' : '无法结算',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  bool _canAllGroupsCheckout(Cart cart) {
    return cart.merchantGroups.every((group) =>
        group.minOrderAmount == 0 || group.subtotal >= group.minOrderAmount);
  }

  void _handleCheckout(BuildContext context) {
    // TODO: 导航到结算页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('即将跳转到结算页面'),
        duration: Duration(seconds: 1),
      ),
    );
    
    // TODO: 实现结算逻辑
    // Navigator.of(context).pushNamed('/checkout');
  }
}

class _LoadingBottomBar extends StatelessWidget {
  const _LoadingBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ShimmerBox(width: 80, height: 16),
                    SizedBox(height: 4),
                    _ShimmerBox(width: 120, height: 20),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 120,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBottomBar extends StatelessWidget {
  const _ErrorBottomBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '加载失败，请刷新页面',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                height: 48,
                child: OutlinedButton(
                  onPressed: null,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('无法结算'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerBox({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}