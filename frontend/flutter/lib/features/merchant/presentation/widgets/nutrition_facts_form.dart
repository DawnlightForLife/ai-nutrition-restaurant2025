import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NutritionFactsForm extends StatefulWidget {
  final Map<String, dynamic>? initialValues;
  final Function(Map<String, dynamic>) onNutritionChanged;

  const NutritionFactsForm({
    Key? key,
    this.initialValues,
    required this.onNutritionChanged,
  }) : super(key: key);

  @override
  State<NutritionFactsForm> createState() => _NutritionFactsFormState();
}

class _NutritionFactsFormState extends State<NutritionFactsForm> {
  late Map<String, TextEditingController> _controllers;
  late Map<String, dynamic> _nutritionValues;

  // 营养成分列表
  final List<NutritionItem> _nutritionItems = [
    NutritionItem('calories', '热量', 'kcal', isRequired: true),
    NutritionItem('protein', '蛋白质', 'g', isRequired: true),
    NutritionItem('fat', '脂肪', 'g', isRequired: true),
    NutritionItem('saturatedFat', '饱和脂肪', 'g'),
    NutritionItem('transFat', '反式脂肪', 'g'),
    NutritionItem('carbohydrates', '碳水化合物', 'g', isRequired: true),
    NutritionItem('fiber', '膳食纤维', 'g'),
    NutritionItem('sugar', '糖分', 'g'),
    NutritionItem('sodium', '钠', 'mg'),
    NutritionItem('cholesterol', '胆固醇', 'mg'),
    NutritionItem('calcium', '钙', 'mg'),
    NutritionItem('iron', '铁', 'mg'),
    NutritionItem('vitaminA', '维生素A', 'μg'),
    NutritionItem('vitaminC', '维生素C', 'mg'),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _nutritionValues = widget.initialValues ?? {};
    
    // 初始化控制器
    for (var item in _nutritionItems) {
      final value = _nutritionValues[item.key]?.toString() ?? '';
      _controllers[item.key] = TextEditingController(text: value);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateNutritionValue(String key, String value) {
    final numValue = double.tryParse(value);
    if (numValue != null || value.isEmpty) {
      setState(() {
        if (value.isEmpty) {
          _nutritionValues.remove(key);
        } else {
          _nutritionValues[key] = numValue;
        }
      });
      widget.onNutritionChanged(_nutritionValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '每100g营养成分',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        
        // 主要营养成分（必填）
        _buildSection(
          '主要营养成分',
          _nutritionItems.where((item) => item.isRequired).toList(),
        ),
        
        const SizedBox(height: 20),
        
        // 其他营养成分（选填）
        ExpansionTile(
          title: const Text('其他营养成分（选填）'),
          initiallyExpanded: false,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildSection(
                null,
                _nutritionItems.where((item) => !item.isRequired).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSection(String? title, List<NutritionItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildNutritionField(item);
          },
        ),
      ],
    );
  }

  Widget _buildNutritionField(NutritionItem item) {
    return TextFormField(
      controller: _controllers[item.key],
      decoration: InputDecoration(
        labelText: '${item.name}${item.isRequired ? ' *' : ''}',
        suffixText: item.unit,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      validator: item.isRequired
          ? (value) {
              if (value == null || value.isEmpty) {
                return '请输入${item.name}';
              }
              return null;
            }
          : null,
      onChanged: (value) => _updateNutritionValue(item.key, value),
    );
  }
}

class NutritionItem {
  final String key;
  final String name;
  final String unit;
  final bool isRequired;

  NutritionItem(
    this.key,
    this.name,
    this.unit, {
    this.isRequired = false,
  });
}