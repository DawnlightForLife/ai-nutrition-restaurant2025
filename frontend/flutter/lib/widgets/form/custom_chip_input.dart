import 'package:flutter/material.dart';

class CustomChipInput extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> selectedValues;
  final Function(List<String>) onChanged;
  final String Function(String)? getDisplayText;
  final bool allowCustom;

  const CustomChipInput({
    Key? key,
    required this.label,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.getDisplayText,
    this.allowCustom = false,
  }) : super(key: key);

  @override
  State<CustomChipInput> createState() => _CustomChipInputState();
}

class _CustomChipInputState extends State<CustomChipInput> {
  final TextEditingController _textController = TextEditingController();
  List<String> _selectedValues = [];

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.selectedValues);
  }

  @override
  void didUpdateWidget(CustomChipInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValues != widget.selectedValues) {
      _selectedValues = List.from(widget.selectedValues);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addCustomValue(String value) {
    if (value.isNotEmpty && !_selectedValues.contains(value)) {
      setState(() {
        _selectedValues.add(value);
        widget.onChanged(_selectedValues);
        _textController.clear();
      });
    }
  }

  void _toggleValue(String value) {
    setState(() {
      if (_selectedValues.contains(value)) {
        _selectedValues.remove(value);
      } else {
        _selectedValues.add(value);
      }
      widget.onChanged(_selectedValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (widget.allowCustom) ...[
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: '输入自定义选项',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addCustomValue(_textController.text),
              ),
            ),
            onSubmitted: _addCustomValue,
          ),
          const SizedBox(height: 8),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...widget.options.map((option) {
              final isSelected = _selectedValues.contains(option);
              return FilterChip(
                label: Text(
                  widget.getDisplayText?.call(option) ?? option,
                ),
                selected: isSelected,
                onSelected: (_) => _toggleValue(option),
              );
            }),
            ..._selectedValues
                .where((value) => !widget.options.contains(value))
                .map((value) {
              return FilterChip(
                label: Text(value),
                selected: true,
                onSelected: (_) => _toggleValue(value),
              );
            }),
          ],
        ),
      ],
    );
  }
} 