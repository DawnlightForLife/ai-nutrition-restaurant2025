import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 滚轮数字选择器
class WheelNumberPicker extends StatefulWidget {
  final double initialValue;
  final double minValue;
  final double maxValue;
  final double step;
  final String unit;
  final String label;
  final Function(double) onChanged;
  final int decimals;

  const WheelNumberPicker({
    Key? key,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    this.step = 1.0,
    this.unit = '',
    this.label = '',
    this.decimals = 0,
  }) : super(key: key);

  @override
  State<WheelNumberPicker> createState() => _WheelNumberPickerState();
}

class _WheelNumberPickerState extends State<WheelNumberPicker> {
  late double _currentValue;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    final initialIndex = ((widget.initialValue - widget.minValue) / widget.step).round();
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int get itemCount => ((widget.maxValue - widget.minValue) / widget.step).round() + 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.label.isNotEmpty)
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                Text(
                  '${_currentValue.toStringAsFixed(widget.decimals)} ${widget.unit}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Icon(Icons.arrow_drop_down, color: Theme.of(context).hintColor),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('取消'),
                    ),
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentValue = widget.minValue + (_scrollController.selectedItem * widget.step);
                        });
                        widget.onChanged(_currentValue);
                        Navigator.of(context).pop();
                      },
                      child: const Text('确定'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: CupertinoPicker(
                  scrollController: _scrollController,
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    // 实时预览，但不立即应用
                  },
                  children: List<Widget>.generate(itemCount, (int index) {
                    final value = widget.minValue + (index * widget.step);
                    return Center(
                      child: Text(
                        '${value.toStringAsFixed(widget.decimals)} ${widget.unit}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 身高体重选择器组合组件
class HeightWeightPickers extends StatelessWidget {
  final double? initialHeight;
  final double? initialWeight;
  final Function(double?) onHeightChanged;
  final Function(double?) onWeightChanged;
  final String? Function(String?)? heightValidator;
  final String? Function(String?)? weightValidator;

  const HeightWeightPickers({
    Key? key,
    this.initialHeight,
    this.initialWeight,
    required this.onHeightChanged,
    required this.onWeightChanged,
    this.heightValidator,
    this.weightValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FormField<double>(
            initialValue: initialHeight,
            validator: (value) {
              if (value == null) return '请选择身高';
              return heightValidator?.call(value.toString());
            },
            builder: (FormFieldState<double> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WheelNumberPicker(
                    initialValue: initialHeight ?? 170,
                    minValue: 100,
                    maxValue: 250,
                    step: 1,
                    unit: 'cm',
                    label: '身高',
                    onChanged: (value) {
                      state.didChange(value);
                      onHeightChanged(value);
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        state.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: FormField<double>(
            initialValue: initialWeight,
            validator: (value) {
              if (value == null) return '请选择体重';
              return weightValidator?.call(value.toString());
            },
            builder: (FormFieldState<double> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WheelNumberPicker(
                    initialValue: initialWeight ?? 60,
                    minValue: 30,
                    maxValue: 300,
                    step: 0.5,
                    unit: 'kg',
                    label: '体重',
                    decimals: 1,
                    onChanged: (value) {
                      state.didChange(value);
                      onWeightChanged(value);
                    },
                  ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                      child: Text(
                        state.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}