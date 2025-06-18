/// 食材详情对话框
/// 显示食材详细信息和选择界面

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_ordering.dart';

class IngredientDetailDialog extends StatefulWidget {
  final IngredientNutrition ingredient;
  final Function(double amount, String? cookingMethod, String? cookingMethodName) onAddToSelection;

  const IngredientDetailDialog({
    super.key,
    required this.ingredient,
    required this.onAddToSelection,
  });

  @override
  State<IngredientDetailDialog> createState() => _IngredientDetailDialogState();
}

class _IngredientDetailDialogState extends State<IngredientDetailDialog> {
  double _amount = 100.0;
  String? _selectedCookingMethod;
  String? _selectedCookingMethodName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildAmountSelector(),
            const SizedBox(height: 16),
            _buildCookingMethodSelector(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          widget.ingredient.chineseName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          widget.ingredient.name,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildAmountSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('选择分量', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Slider(
          value: _amount,
          min: 10,
          max: 500,
          divisions: 49,
          label: '${_amount.toInt()}g',
          onChanged: (value) => setState(() => _amount = value),
        ),
        Text('${_amount.toInt()}g'),
      ],
    );
  }

  Widget _buildCookingMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('烹饪方式', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['生食', '蒸制', '水煮', '炒制', '烤制'].map((method) {
            final isSelected = _selectedCookingMethodName == method;
            return FilterChip(
              label: Text(method),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCookingMethodName = selected ? method : null;
                  _selectedCookingMethod = selected ? method.toLowerCase() : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              widget.onAddToSelection(_amount, _selectedCookingMethod, _selectedCookingMethodName);
              Navigator.of(context).pop();
            },
            child: const Text('添加'),
          ),
        ),
      ],
    );
  }
}