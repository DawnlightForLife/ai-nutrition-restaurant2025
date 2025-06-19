import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/merchant_inventory.dart';
import '../providers/merchant_inventory_provider.dart';

// 库存更新类型
enum StockUpdateType { set, increase, decrease }

class BatchUpdateDialog extends ConsumerStatefulWidget {
  final String merchantId;
  final List<String> selectedIngredientIds;
  final List<IngredientInventoryItem> allIngredients;
  
  const BatchUpdateDialog({
    Key? key,
    required this.merchantId,
    required this.selectedIngredientIds,
    required this.allIngredients,
  }) : super(key: key);

  @override
  ConsumerState<BatchUpdateDialog> createState() => _BatchUpdateDialogState();
}

class _BatchUpdateDialogState extends ConsumerState<BatchUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // 更新选项
  bool _updateStock = false;
  bool _updatePrice = false;
  bool _updateAlertThreshold = false;
  bool _updateStatus = false;
  
  // 更新值
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  final _alertThresholdController = TextEditingController();
  bool _newStatus = true;
  
  StockUpdateType _stockUpdateType = StockUpdateType.set;
  
  @override
  void dispose() {
    _stockController.dispose();
    _priceController.dispose();
    _alertThresholdController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final selectedIngredients = widget.allIngredients
        .where((item) => widget.selectedIngredientIds.contains(item.id))
        .toList();
    
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('批量更新食材'),
          const SizedBox(height: 8),
          Text(
            '已选择 ${widget.selectedIngredientIds.length} 个食材',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 库存更新
              _buildUpdateSection(
                title: '库存更新',
                enabled: _updateStock,
                onChanged: (value) => setState(() => _updateStock = value!),
                child: Column(
                  children: [
                    SegmentedButton<StockUpdateType>(
                      segments: const [
                        ButtonSegment(
                          value: StockUpdateType.set,
                          label: Text('设置为'),
                        ),
                        ButtonSegment(
                          value: StockUpdateType.increase,
                          label: Text('增加'),
                        ),
                        ButtonSegment(
                          value: StockUpdateType.decrease,
                          label: Text('减少'),
                        ),
                      ],
                      selected: {_stockUpdateType},
                      onSelectionChanged: (Set<StockUpdateType> selection) {
                        setState(() {
                          _stockUpdateType = selection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _stockController,
                      decoration: InputDecoration(
                        labelText: _getStockInputLabel(),
                        suffixText: _getStockUnit(selectedIngredients),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      validator: _updateStock ? (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入数值';
                        }
                        final num = double.tryParse(value);
                        if (num == null || num < 0) {
                          return '请输入有效数值';
                        }
                        return null;
                      } : null,
                      enabled: _updateStock,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 价格更新
              _buildUpdateSection(
                title: '单价更新',
                enabled: _updatePrice,
                onChanged: (value) => setState(() => _updatePrice = value!),
                child: TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: '新单价',
                    prefixText: '¥ ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: _updatePrice ? (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入价格';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return '请输入有效价格';
                    }
                    return null;
                  } : null,
                  enabled: _updatePrice,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 预警阈值更新
              _buildUpdateSection(
                title: '预警阈值更新',
                enabled: _updateAlertThreshold,
                onChanged: (value) => setState(() => _updateAlertThreshold = value!),
                child: TextFormField(
                  controller: _alertThresholdController,
                  decoration: InputDecoration(
                    labelText: '新预警阈值',
                    suffixText: _getStockUnit(selectedIngredients),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: _updateAlertThreshold ? (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入阈值';
                    }
                    final threshold = double.tryParse(value);
                    if (threshold == null || threshold < 0) {
                      return '请输入有效阈值';
                    }
                    return null;
                  } : null,
                  enabled: _updateAlertThreshold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 状态更新
              _buildUpdateSection(
                title: '状态更新',
                enabled: _updateStatus,
                onChanged: (value) => setState(() => _updateStatus = value!),
                child: DropdownButtonFormField<bool>(
                  value: _newStatus,
                  decoration: const InputDecoration(
                    labelText: '新状态',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: true,
                      child: Text('可用'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('停用'),
                    ),
                  ],
                  onChanged: _updateStatus ? (value) {
                    if (value != null) {
                      setState(() => _newStatus = value);
                    }
                  } : null,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 警告信息
              if (_hasAnyUpdateSelected())
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '此操作将更新所有选中的食材，请谨慎操作',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _hasAnyUpdateSelected() ? _performBatchUpdate : null,
          child: const Text('确认更新'),
        ),
      ],
    );
  }
  
  Widget _buildUpdateSection({
    required String title,
    required bool enabled,
    required ValueChanged<bool?> onChanged,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: Text(title),
          value: enabled,
          onChanged: onChanged,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (enabled) child,
      ],
    );
  }
  
  String _getStockInputLabel() {
    switch (_stockUpdateType) {
      case StockUpdateType.set:
        return '设置库存为';
      case StockUpdateType.increase:
        return '增加库存';
      case StockUpdateType.decrease:
        return '减少库存';
    }
  }
  
  String _getStockUnit(List<IngredientInventoryItem> ingredients) {
    if (ingredients.isEmpty) return '';
    
    // 检查是否所有选中的食材单位相同
    final units = ingredients.map((e) => e.unit).toSet();
    if (units.length == 1) {
      return units.first;
    }
    return '(单位不同)';
  }
  
  bool _hasAnyUpdateSelected() {
    return _updateStock || _updatePrice || _updateAlertThreshold || _updateStatus;
  }
  
  void _performBatchUpdate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final inventoryNotifier = ref.read(
      merchantInventoryProvider(widget.merchantId).notifier
    );
    
    final selectedIngredients = widget.allIngredients
        .where((item) => widget.selectedIngredientIds.contains(item.id))
        .toList();
    
    // 执行批量更新
    for (final ingredient in selectedIngredients) {
      var updatedIngredient = ingredient;
      
      // 更新库存
      if (_updateStock) {
        final stockValue = double.parse(_stockController.text);
        double newStock;
        
        switch (_stockUpdateType) {
          case StockUpdateType.set:
            newStock = stockValue;
            break;
          case StockUpdateType.increase:
            newStock = ingredient.currentStock + stockValue;
            break;
          case StockUpdateType.decrease:
            newStock = (ingredient.currentStock - stockValue).clamp(0, double.infinity);
            break;
        }
        
        updatedIngredient = updatedIngredient.copyWith(
          currentStock: newStock,
          availableStock: newStock - ingredient.reservedStock,
        );
        
        // 记录库存变动
        final transaction = InventoryTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          ingredientId: ingredient.id,
          type: _stockUpdateType == StockUpdateType.increase ? 'restock' : 'adjustment',
          quantity: stockValue,
          unit: ingredient.unit,
          reason: '批量更新',
          costPerUnit: ingredient.costPerUnit,
          operatorId: 'current_user', // TODO: 从用户状态获取
          timestamp: DateTime.now(),
          stockBefore: ingredient.currentStock,
          stockAfter: newStock,
        );
        
        inventoryNotifier.recordInventoryTransaction(transaction);
      }
      
      // 更新价格
      if (_updatePrice) {
        final newPrice = double.parse(_priceController.text);
        updatedIngredient = updatedIngredient.copyWith(
          costPerUnit: newPrice,
        );
      }
      
      // 更新预警阈值
      if (_updateAlertThreshold) {
        final newThreshold = double.parse(_alertThresholdController.text);
        updatedIngredient = updatedIngredient.copyWith(
          alertThreshold: newThreshold,
        );
      }
      
      // 更新状态
      if (_updateStatus) {
        updatedIngredient = updatedIngredient.copyWith(
          isActive: _newStatus,
        );
      }
      
      // 应用更新
      inventoryNotifier.updateIngredientInventory(updatedIngredient);
    }
    
    // 清除选择
    inventoryNotifier.clearSelection();
    
    // 关闭对话框
    Navigator.of(context).pop(true);
    
    // 显示成功消息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已成功更新 ${selectedIngredients.length} 个食材'),
        backgroundColor: Colors.green,
      ),
    );
  }
}