/// 烹饪方式选择器组件
/// 选择和展示烹饪方式

import 'package:flutter/material.dart';

class CookingMethodSelectorWidget extends StatelessWidget {
  final String? selectedMethod;
  final Function(String method) onMethodSelected;
  final List<String> availableMethods;

  const CookingMethodSelectorWidget({
    super.key,
    this.selectedMethod,
    required this.onMethodSelected,
    this.availableMethods = const ['生食', '蒸制', '水煮', '炒制', '烤制'],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '烹饪方式',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableMethods.map((method) {
            final isSelected = selectedMethod == method;
            return FilterChip(
              label: Text(method),
              selected: isSelected,
              onSelected: (_) => onMethodSelected(method),
              backgroundColor: Colors.grey.shade100,
              selectedColor: Colors.green.shade100,
            );
          }).toList(),
        ),
      ],
    );
  }
}