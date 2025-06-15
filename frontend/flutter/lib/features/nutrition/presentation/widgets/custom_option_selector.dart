import 'package:flutter/material.dart';

/// 支持自定义选项的选择器组件
class CustomOptionSelector extends StatefulWidget {
  final String title;
  final Map<String, String> predefinedOptions;
  final Set<String> selectedValues;
  final Function(Set<String>) onChanged;
  final bool allowMultiple;
  final String? hintText;

  const CustomOptionSelector({
    Key? key,
    required this.title,
    required this.predefinedOptions,
    required this.selectedValues,
    required this.onChanged,
    this.allowMultiple = true,
    this.hintText,
  }) : super(key: key);

  @override
  State<CustomOptionSelector> createState() => _CustomOptionSelectorState();
}

class _CustomOptionSelectorState extends State<CustomOptionSelector> {
  final TextEditingController _customController = TextEditingController();
  final Set<String> _customOptions = {};
  bool _showCustomInput = false;

  @override
  void initState() {
    super.initState();
    // 识别已选择的自定义选项
    for (final value in widget.selectedValues) {
      if (!widget.predefinedOptions.containsKey(value)) {
        _customOptions.add(value);
      }
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _addCustomOption() {
    final customValue = _customController.text.trim();
    if (customValue.isNotEmpty) {
      setState(() {
        _customOptions.add(customValue);
        final newValues = Set<String>.from(widget.selectedValues);
        newValues.add(customValue);
        widget.onChanged(newValues);
        _customController.clear();
        _showCustomInput = false;
      });
    }
  }

  void _removeCustomOption(String option) {
    setState(() {
      _customOptions.remove(option);
      final newValues = Set<String>.from(widget.selectedValues);
      newValues.remove(option);
      widget.onChanged(newValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: Icon(
                _showCustomInput ? Icons.close : Icons.add_circle_outline,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _showCustomInput = !_showCustomInput;
                  if (!_showCustomInput) {
                    _customController.clear();
                  }
                });
              },
              tooltip: '添加自定义选项',
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // 预定义选项
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...widget.predefinedOptions.entries.map((entry) {
              final isSelected = widget.selectedValues.contains(entry.key);
              return widget.allowMultiple
                  ? FilterChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (selected) {
                        final newValues = Set<String>.from(widget.selectedValues);
                        if (selected) {
                          newValues.add(entry.key);
                        } else {
                          newValues.remove(entry.key);
                        }
                        widget.onChanged(newValues);
                      },
                    )
                  : ChoiceChip(
                      label: Text(entry.value),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          widget.onChanged({entry.key});
                        }
                      },
                    );
            }),
            
            // 自定义选项
            ..._customOptions.map((option) {
              return Chip(
                label: Text(option),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => _removeCustomOption(option),
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              );
            }),
          ],
        ),
        
        // 自定义输入框
        if (_showCustomInput) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customController,
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? '输入自定义选项',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: (_) => _addCustomOption(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addCustomOption,
                child: const Text('添加'),
              ),
            ],
          ),
        ],
      ],
    );
  }
}