import 'package:flutter/material.dart';

/// 订单状态展示组件
class OrderStatusWidget extends StatelessWidget {
  final OrderStatus status;
  final bool showIcon;
  final bool compact;
  
  const OrderStatusWidget({
    super.key,
    required this.status,
    this.showIcon = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    
    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: config.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          config.label,
          style: TextStyle(
            color: config.color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: config.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              config.icon,
              color: config.color,
              size: 16,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return _StatusConfig(
          label: '待支付',
          color: Colors.orange,
          icon: Icons.payment,
        );
      case OrderStatus.paid:
        return _StatusConfig(
          label: '已支付',
          color: Colors.blue,
          icon: Icons.check_circle_outline,
        );
      case OrderStatus.preparing:
        return _StatusConfig(
          label: '备餐中',
          color: Colors.purple,
          icon: Icons.restaurant,
        );
      case OrderStatus.ready:
        return _StatusConfig(
          label: '待取餐',
          color: Colors.green,
          icon: Icons.inventory,
        );
      case OrderStatus.delivering:
        return _StatusConfig(
          label: '配送中',
          color: Colors.blue,
          icon: Icons.delivery_dining,
        );
      case OrderStatus.completed:
        return _StatusConfig(
          label: '已完成',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      case OrderStatus.cancelled:
        return _StatusConfig(
          label: '已取消',
          color: Colors.grey,
          icon: Icons.cancel_outlined,
        );
      case OrderStatus.refunded:
        return _StatusConfig(
          label: '已退款',
          color: Colors.red,
          icon: Icons.currency_yen,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;
  
  const _StatusConfig({
    required this.label,
    required this.color,
    required this.icon,
  });
}

/// 订单状态枚举
enum OrderStatus {
  pending,    // 待支付
  paid,       // 已支付
  preparing,  // 备餐中
  ready,      // 待取餐
  delivering, // 配送中
  completed,  // 已完成
  cancelled,  // 已取消
  refunded,   // 已退款
}