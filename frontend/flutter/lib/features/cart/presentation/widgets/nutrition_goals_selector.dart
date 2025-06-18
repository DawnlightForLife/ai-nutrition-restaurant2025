/**
 * 营养目标选择器组件
 */

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_cart.dart';

class NutritionGoalsSelector extends StatefulWidget {
  final String userId;
  final Map<String, double> currentGoals;
  final List<NutritionGoalTemplate> goalTemplates;
  final Function(Map<String, double>) onGoalsSet;
  final Function(String) onTemplateApplied;

  const NutritionGoalsSelector({
    super.key,
    required this.userId,
    required this.currentGoals,
    required this.goalTemplates,
    required this.onGoalsSet,
    required this.onTemplateApplied,
  });

  @override
  State<NutritionGoalsSelector> createState() => _NutritionGoalsSelectorState();
}

class _NutritionGoalsSelectorState extends State<NutritionGoalsSelector>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Map<String, double> _customGoals = {};
  String? _selectedTemplateId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _customGoals = Map.from(widget.currentGoals);
    
    // 如果当前没有目标，设置默认值
    if (_customGoals.isEmpty) {
      _customGoals = {
        'protein': 80.0,
        'carbohydrate': 250.0,
        'fat': 65.0,
        'fiber': 25.0,
        'vitamin_c': 90.0,
        'calcium': 1000.0,
        'iron': 15.0,
        'calories': 2000.0,
      };
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 标题栏
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '设置营养目标',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 标签栏
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '快速模板'),
              Tab(text: '自定义目标'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 内容区域
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTemplatesView(),
                _buildCustomGoalsView(),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 底部按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('取消'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSave,
                  child: const Text('保存'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesView() {
    return ListView.builder(
      itemCount: widget.goalTemplates.length,
      itemBuilder: (context, index) {
        final template = widget.goalTemplates[index];
        final isSelected = _selectedTemplateId == template.id;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedTemplateId = template.id;
                _customGoals = Map.from(template.nutritionTargets);
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          template.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                        ),
                      if (template.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '推荐',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    template.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildQuickStat('热量', '${template.calorieTarget} 卡'),
                      const SizedBox(width: 16),
                      _buildQuickStat('蛋白质', '${template.nutritionTargets['protein']?.toStringAsFixed(0) ?? 0}g'),
                      const SizedBox(width: 16),
                      _buildQuickStat('碳水', '${template.nutritionTargets['carbohydrate']?.toStringAsFixed(0) ?? 0}g'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomGoalsView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 基础营养素
          _buildSectionHeader('基础营养素'),
          _buildGoalSlider('蛋白质', 'protein', 'g', 30, 150),
          _buildGoalSlider('碳水化合物', 'carbohydrate', 'g', 100, 400),
          _buildGoalSlider('脂肪', 'fat', 'g', 20, 100),
          _buildGoalSlider('膳食纤维', 'fiber', 'g', 15, 50),
          
          const SizedBox(height: 24),
          
          // 维生素
          _buildSectionHeader('维生素'),
          _buildGoalSlider('维生素C', 'vitamin_c', 'mg', 50, 200),
          
          const SizedBox(height: 24),
          
          // 矿物质
          _buildSectionHeader('矿物质'),
          _buildGoalSlider('钙', 'calcium', 'mg', 500, 1500),
          _buildGoalSlider('铁', 'iron', 'mg', 8, 25),
          
          const SizedBox(height: 24),
          
          // 热量
          _buildSectionHeader('热量'),
          _buildGoalSlider('每日热量', 'calories', '卡', 1200, 3000),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGoalSlider(
    String label,
    String key,
    String unit,
    double min,
    double max,
  ) {
    final currentValue = _customGoals[key] ?? min;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${currentValue.toStringAsFixed(0)} $unit',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: currentValue,
              min: min,
              max: max,
              divisions: ((max - min) / (max > 100 ? 10 : 1)).round(),
              onChanged: (value) {
                setState(() {
                  _customGoals[key] = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${min.toStringAsFixed(0)} $unit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '${max.toStringAsFixed(0)} $unit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _handleSave() {
    if (_selectedTemplateId != null) {
      widget.onTemplateApplied(_selectedTemplateId!);
    } else {
      widget.onGoalsSet(_customGoals);
    }
  }
}