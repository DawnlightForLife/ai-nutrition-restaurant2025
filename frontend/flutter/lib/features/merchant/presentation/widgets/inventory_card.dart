import 'package:flutter/material.dart';
import '../../domain/entities/inventory_entity.dart';

class InventoryCard extends StatelessWidget {
  final InventoryEntity inventory;
  final VoidCallback? onTap;
  final VoidCallback? onAddStock;
  final VoidCallback? onConsumeStock;
  final VoidCallback? onRemoveExpired;

  const InventoryCard({
    Key? key,
    required this.inventory,
    this.onTap,
    this.onAddStock,
    this.onConsumeStock,
    this.onRemoveExpired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部信息行
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inventory.ingredientName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '当前库存: ${inventory.availableStock.toStringAsFixed(1)} ${inventory.unit}',
                          style: TextStyle(
                            fontSize: 16,
                            color: _getStockColor(inventory),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 状态指示器
                  Column(
                    children: [
                      if (inventory.isLowStock)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning, size: 16, color: Colors.orange[700]),
                              const SizedBox(width: 4),
                              Text(
                                '库存不足',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      if (inventory.hasExpired)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.dangerous, size: 16, color: Colors.red[700]),
                              const SizedBox(width: 4),
                              Text(
                                '已过期',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (inventory.hasExpiringSoon)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.schedule, size: 16, color: Colors.yellow[700]),
                              const SizedBox(width: 4),
                              Text(
                                '即将过期',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.yellow[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 库存详情
              Row(
                children: [
                  _buildStockInfo('总库存', inventory.totalStock),
                  const SizedBox(width: 16),
                  _buildStockInfo('可用', inventory.availableStock),
                  const SizedBox(width: 16),
                  _buildStockInfo('预留', inventory.reservedStock),
                  const Spacer(),
                  Text(
                    '最低阈值: ${inventory.minThreshold}${inventory.unit}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 批次信息
              if (inventory.stockBatches.isNotEmpty) ...[
                Text(
                  '批次信息 (${inventory.stockBatches.length}个批次)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: inventory.stockBatches.length,
                    itemBuilder: (context, index) {
                      final batch = inventory.stockBatches[index];
                      final isExpiring = batch.expiryDate.difference(DateTime.now()).inDays <= 
                          inventory.alertSettings.expiryWarningDays;
                      final isExpired = batch.expiryDate.isBefore(DateTime.now());
                      
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isExpired 
                              ? Colors.red[50]
                              : isExpiring 
                                  ? Colors.yellow[50]
                                  : Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isExpired 
                                ? Colors.red[200]!
                                : isExpiring 
                                    ? Colors.yellow[200]!
                                    : Colors.green[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${batch.quantity.toStringAsFixed(1)}${inventory.unit}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${batch.expiryDate.month}/${batch.expiryDate.day}到期',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
              ],
              
              // 使用统计
              Row(
                children: [
                  if (inventory.usageStats.averageDailyUsage > 0) ...[
                    Icon(Icons.trending_down, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '日均消耗: ${inventory.usageStats.averageDailyUsage.toStringAsFixed(1)}${inventory.unit}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  
                  if (inventory.daysUntilStockOut < 999) ...[
                    Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '预计${inventory.daysUntilStockOut}天用完',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  
                  const Spacer(),
                  
                  Text(
                    '价值: ￥${inventory.stockValue.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 操作按钮
              Row(
                children: [
                  // 添加库存
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onAddStock,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('添加'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: BorderSide(color: Colors.green[300]!),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // 消耗库存
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: inventory.availableStock > 0 ? onConsumeStock : null,
                      icon: const Icon(Icons.remove, size: 16),
                      label: const Text('消耗'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                        side: BorderSide(color: Colors.orange[300]!),
                      ),
                    ),
                  ),
                  
                  if (onRemoveExpired != null) ...[
                    const SizedBox(width: 8),
                    
                    // 移除过期
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onRemoveExpired,
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('移除过期'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red[300]!),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockInfo(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        Text(
          '${value.toStringAsFixed(1)}${inventory.unit}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStockColor(InventoryEntity inventory) {
    if (inventory.isLowStock) {
      return Colors.orange[700]!;
    } else if (inventory.availableStock == 0) {
      return Colors.red[700]!;
    } else {
      return Colors.green[700]!;
    }
  }
}