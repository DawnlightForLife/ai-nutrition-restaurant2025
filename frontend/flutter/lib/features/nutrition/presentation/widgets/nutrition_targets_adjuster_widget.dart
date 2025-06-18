/**
 * 营养目标调整器组件
 * 精确调整营养素目标摄入量
 */

import 'package:flutter/material.dart';

class NutritionTargetsAdjusterWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Map<String, double> targetIntake;
  final Function(String element, double target) onTargetChanged;

  const NutritionTargetsAdjusterWidget({
    super.key,
    required this.scrollController,
    required this.targetIntake,
    required this.onTargetChanged,
  });

  @override
  State<NutritionTargetsAdjusterWidget> createState() => _NutritionTargetsAdjusterWidgetState();
}

class _NutritionTargetsAdjusterWidgetState extends State<NutritionTargetsAdjusterWidget> {
  late Map<String, double> _currentTargets;

  @override
  void initState() {
    super.initState();
    _currentTargets = Map.from(widget.targetIntake);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              children: [
                _buildNutrientAdjusters(),
              ],
            ),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Spacer(),
        Text(
          '精确调整营养目标',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildNutrientAdjusters() {
    final nutrients = [
      {'key': 'protein', 'name': '蛋白质', 'unit': 'g', 'min': 50.0, 'max': 200.0},
      {'key': 'carbohydrates', 'name': '碳水化合物', 'unit': 'g', 'min': 100.0, 'max': 500.0},
      {'key': 'fat', 'name': '脂肪', 'unit': 'g', 'min': 20.0, 'max': 150.0},
      {'key': 'fiber', 'name': '膳食纤维', 'unit': 'g', 'min': 15.0, 'max': 60.0},
      {'key': 'vitamin_c', 'name': '维生素C', 'unit': 'mg', 'min': 50.0, 'max': 2000.0},
      {'key': 'calcium', 'name': '钙', 'unit': 'mg', 'min': 500.0, 'max': 2500.0},
      {'key': 'iron', 'name': '铁', 'unit': 'mg', 'min': 5.0, 'max': 50.0},
    ];

    return Column(
      children: nutrients.map((nutrient) => 
        _buildNutrientAdjuster(nutrient)
      ).toList(),
    );
  }

  Widget _buildNutrientAdjuster(Map<String, dynamic> nutrient) {
    final key = nutrient['key'] as String;
    final currentValue = _currentTargets[key] ?? 0.0;
    final minValue = nutrient['min'] as double;
    final maxValue = nutrient['max'] as double;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  nutrient['name'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    '${currentValue.toStringAsFixed(1)} ${nutrient['unit']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.green.shade400,
                inactiveTrackColor: Colors.grey.shade300,
                thumbColor: Colors.green.shade600,
                overlayColor: Colors.green.shade100,
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              ),
              child: Slider(
                value: currentValue.clamp(minValue, maxValue),
                min: minValue,
                max: maxValue,
                divisions: ((maxValue - minValue) / _getStepSize(maxValue - minValue)).round(),
                onChanged: (value) {
                  setState(() {
                    _currentTargets[key] = value;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${minValue.toStringAsFixed(0)} ${nutrient['unit']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  '${maxValue.toStringAsFixed(0)} ${nutrient['unit']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // 重置为原始值
                setState(() {
                  _currentTargets = Map.from(widget.targetIntake);
                });
              },
              icon: const Icon(Icons.restore),
              label: const Text('重置'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade700,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                // 应用更改
                _currentTargets.forEach((key, value) {
                  widget.onTargetChanged(key, value);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('营养目标已更新')),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('应用更改'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getStepSize(double range) {
    if (range <= 100) return 1.0;
    if (range <= 1000) return 5.0;
    return 10.0;
  }
}