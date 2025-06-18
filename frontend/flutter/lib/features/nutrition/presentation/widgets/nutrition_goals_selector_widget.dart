/**
 * 营养目标选择器组件
 * 允许用户设置和调整营养目标
 */

import 'package:flutter/material.dart';

class NutritionGoalsSelectorWidget extends StatefulWidget {
  final String? profileId;
  final VoidCallback? onGoalsUpdated;

  const NutritionGoalsSelectorWidget({
    super.key,
    this.profileId,
    this.onGoalsUpdated,
  });

  @override
  State<NutritionGoalsSelectorWidget> createState() => _NutritionGoalsSelectorWidgetState();
}

class _NutritionGoalsSelectorWidgetState extends State<NutritionGoalsSelectorWidget> {
  final List<String> _selectedGoals = [];
  
  final List<Map<String, dynamic>> _availableGoals = [
    {
      'id': 'weight_loss',
      'name': '减重瘦身',
      'description': '科学控制热量，健康减重',
      'icon': Icons.trending_down,
      'color': Colors.red,
    },
    {
      'id': 'muscle_gain',
      'name': '增肌塑形',
      'description': '增加蛋白质摄入，促进肌肉生长',
      'icon': Icons.fitness_center,
      'color': Colors.orange,
    },
    {
      'id': 'health_maintain',
      'name': '健康维持',
      'description': '均衡营养，保持健康状态',
      'icon': Icons.favorite,
      'color': Colors.green,
    },
    {
      'id': 'blood_sugar_control',
      'name': '血糖控制',
      'description': '稳定血糖，预防糖尿病',
      'icon': Icons.water_drop,
      'color': Colors.blue,
    },
    {
      'id': 'blood_pressure_control',
      'name': '血压管理',
      'description': '控制钠摄入，维护心血管健康',
      'icon': Icons.monitor_heart,
      'color': Colors.purple,
    },
    {
      'id': 'cholesterol_management',
      'name': '血脂调节',
      'description': '优化脂肪摄入，改善血脂水平',
      'icon': Icons.timeline,
      'color': Colors.teal,
    },
    {
      'id': 'digestive_health',
      'name': '消化健康',
      'description': '增加膳食纤维，促进肠道健康',
      'icon': Icons.eco,
      'color': Colors.lightGreen,
    },
    {
      'id': 'immunity_boost',
      'name': '免疫增强',
      'description': '补充维生素，提高免疫力',
      'icon': Icons.shield,
      'color': Colors.amber,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildGoalsGrid(),
            if (_selectedGoals.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSelectedGoalsSummary(),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flag_outlined,
              color: Colors.green.shade600,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              '营养目标设置',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '选择您的健康目标，AI将为您量身定制营养方案（可多选）',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _availableGoals.length,
      itemBuilder: (context, index) {
        final goal = _availableGoals[index];
        final isSelected = _selectedGoals.contains(goal['id']);
        
        return _buildGoalCard(goal, isSelected);
      },
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal, bool isSelected) {
    final color = goal['color'] as Color;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGoals.remove(goal['id']);
          } else {
            _selectedGoals.add(goal['id']);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 图标和选中指示器
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.2) : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      goal['icon'] as IconData,
                      color: isSelected ? color : Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // 目标名称
              Text(
                goal['name'] as String,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 4),
              
              // 描述
              Text(
                goal['description'] as String,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? color.withOpacity(0.8) : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedGoalsSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist,
                color: Colors.green.shade600,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '已选择目标 (${_selectedGoals.length})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _selectedGoals.map((goalId) {
              final goal = _availableGoals.firstWhere((g) => g['id'] == goalId);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  goal['name'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _selectedGoals.clear();
              });
            },
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('清空选择'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade300),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: 保存营养目标
              widget.onGoalsUpdated?.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('营养目标已更新')),
              );
            },
            icon: const Icon(Icons.save, size: 16),
            label: const Text('保存目标'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}