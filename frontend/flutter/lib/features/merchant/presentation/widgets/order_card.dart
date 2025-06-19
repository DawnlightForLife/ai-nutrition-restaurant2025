import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;
  final Function(OrderStatus)? onStatusUpdate;
  final Function(bool)? onBatchSelect;
  final bool isSelectable;
  final bool isSelected;

  const OrderCard({
    Key? key,
    required this.order,
    this.onTap,
    this.onStatusUpdate,
    this.onBatchSelect,
    this.isSelectable = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // 订单头部
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: order.status.color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  if (isSelectable)
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) => onBatchSelect?.call(value ?? false),
                    ),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '订单号: ${order.orderNumber}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: order.status.color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order.status.displayName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              order.orderType.icon,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order.orderType.displayName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              _formatDateTime(order.createdAt),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // 金额
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '￥${order.actualAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      if (order.discountAmount > 0)
                        Text(
                          '优惠 ￥${order.discountAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 订单内容
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 客户信息
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        order.customerName.isNotEmpty ? order.customerName : '未知客户',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        order.customerPhone.isNotEmpty ? order.customerPhone : '未提供',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // 订单项目
                  ...order.items.take(3).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.dishName} x${item.quantity}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          '￥${item.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  )),
                  
                  if (order.items.length > 3)
                    Text(
                      '...还有${order.items.length - 3}个商品',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  
                  // 支付状态
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.paymentStatus.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: order.paymentStatus.color),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.payment,
                              size: 14,
                              color: order.paymentStatus.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order.paymentStatus.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                color: order.paymentStatus.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      if (order.paymentMethod.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          order.paymentMethod,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      
                      const Spacer(),
                      
                      // 预计制作时间
                      if (order.estimatedPrepTime != null) ...[
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '预计${_formatTime(order.estimatedPrepTime!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  // 备注
                  if (order.notes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.note, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.notes,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // 操作按钮
            if (onStatusUpdate != null && _getAvailableActions(order.status).isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: _getAvailableActions(order.status).map((action) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ElevatedButton(
                        onPressed: () => onStatusUpdate!(action['status'] as OrderStatus),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (action['status'] as OrderStatus).color,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(action['label'] as String),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAvailableActions(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return [
          {'status': OrderStatus.confirmed, 'label': '确认订单'},
          {'status': OrderStatus.cancelled, 'label': '取消'},
        ];
      case OrderStatus.confirmed:
        return [
          {'status': OrderStatus.preparing, 'label': '开始制作'},
          {'status': OrderStatus.cancelled, 'label': '取消'},
        ];
      case OrderStatus.preparing:
        return [
          {'status': OrderStatus.ready, 'label': '制作完成'},
        ];
      case OrderStatus.ready:
        if (order.orderType == OrderType.delivery) {
          return [
            {'status': OrderStatus.delivering, 'label': '开始配送'},
          ];
        } else {
          return [
            {'status': OrderStatus.completed, 'label': '完成订单'},
          ];
        }
      case OrderStatus.delivering:
        return [
          {'status': OrderStatus.delivered, 'label': '已送达'},
        ];
      case OrderStatus.delivered:
        return [
          {'status': OrderStatus.completed, 'label': '完成订单'},
        ];
      default:
        return [];
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}