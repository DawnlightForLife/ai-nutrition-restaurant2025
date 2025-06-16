import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/nutrition_profile_v2.dart';

/// 营养数据图表组件
class NutritionChartWidget extends StatelessWidget {
  final NutritionProfileV2 profile;
  final bool showPieChart;

  const NutritionChartWidget({
    super.key,
    required this.profile,
    this.showPieChart = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 280,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withOpacity(0.1),
            theme.colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题区域
          Row(
            children: [
              Icon(
                Icons.pie_chart,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '营养成分分析',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              _buildToggleButton(context),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 图表区域
          Expanded(
            child: showPieChart ? _buildPieChart(context) : _buildBarChart(context),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleItem(
            context,
            icon: Icons.pie_chart,
            isSelected: showPieChart,
            onTap: () {/* TODO: 实现切换功能 */},
          ),
          _buildToggleItem(
            context,
            icon: Icons.bar_chart,
            isSelected: !showPieChart,
            onTap: () {/* TODO: 实现切换功能 */},
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(
    BuildContext context, {
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final nutritionData = _getNutritionData();
    
    return Row(
      children: [
        // 饼状图
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sections: nutritionData.map((data) => PieChartSectionData(
                value: data.value,
                color: data.color,
                title: '${data.percentage.toStringAsFixed(1)}%',
                radius: 60,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              startDegreeOffset: -90,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // 图例
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: nutritionData.map((data) => _buildLegendItem(
              context,
              label: data.label,
              color: data.color,
              value: '${data.value.toStringAsFixed(1)}g',
              percentage: data.percentage,
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final nutritionData = _getNutritionData();
    final maxValue = nutritionData.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.black87,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${nutritionData[group.x].label}\n${rod.toY.toStringAsFixed(1)}g',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < nutritionData.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      nutritionData[index].shortLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}g',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: nutritionData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.value,
                color: data.color,
                width: 24,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required String label,
    required Color color,
    required String value,
    required double percentage,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 获取营养数据
  List<NutritionData> _getNutritionData() {
    // 根据用户的活动水平生成基础数据
    int activityIndex = 1; // 默认中等活动水平
    if (profile.exerciseFrequency != null) {
      switch (profile.exerciseFrequency) {
        case '很少':
          activityIndex = 0;
          break;
        case '轻度':
          activityIndex = 1;
          break;
        case '中度':
          activityIndex = 2;
          break;
        case '高度':
          activityIndex = 3;
          break;
        default:
          activityIndex = 1;
      }
    }
    
    // 根据用户的饮食偏好和健康目标生成模拟数据
    final baseCarbs = 150.0 + (activityIndex * 20.0);
    final baseProtein = 60.0 + (activityIndex * 10.0);
    final baseFat = 50.0 + (activityIndex * 5.0);
    
    // 根据饮食偏好调整比例
    double carbsMultiplier = 1.0;
    double proteinMultiplier = 1.0;
    double fatMultiplier = 1.0;
    
    // 检查健康目标
    if (profile.healthGoal.contains('减肥') || profile.healthGoal.contains('减脂')) {
      carbsMultiplier = 0.7;
      fatMultiplier = 0.8;
      proteinMultiplier = 1.2;
    } else if (profile.healthGoal.contains('增肌') || profile.healthGoal.contains('增重')) {
      proteinMultiplier = 1.5;
      carbsMultiplier = 1.2;
    }
    
    // 检查饮食偏好
    if (profile.dietaryPreferences.contains('低碳水化合物')) {
      carbsMultiplier *= 0.6;
      fatMultiplier *= 1.3;
    }
    if (profile.nutritionPreferences.contains('高蛋白')) {
      proteinMultiplier *= 1.4;
      carbsMultiplier *= 0.9;
    }
    if (profile.nutritionPreferences.contains('低脂肪')) {
      fatMultiplier *= 0.7;
      carbsMultiplier *= 1.2;
    }
    
    final carbs = baseCarbs * carbsMultiplier;
    final protein = baseProtein * proteinMultiplier;
    final fat = baseFat * fatMultiplier;
    final total = carbs + protein + fat;
    
    return [
      NutritionData(
        label: '碳水化合物',
        shortLabel: '碳水',
        value: carbs,
        percentage: (carbs / total) * 100,
        color: Colors.blue,
      ),
      NutritionData(
        label: '蛋白质',
        shortLabel: '蛋白',
        value: protein,
        percentage: (protein / total) * 100,
        color: Colors.red,
      ),
      NutritionData(
        label: '脂肪',
        shortLabel: '脂肪',
        value: fat,
        percentage: (fat / total) * 100,
        color: Colors.orange,
      ),
    ];
  }
}

/// 营养数据模型
class NutritionData {
  final String label;
  final String shortLabel;
  final double value;
  final double percentage;
  final Color color;

  NutritionData({
    required this.label,
    required this.shortLabel,
    required this.value,
    required this.percentage,
    required this.color,
  });
}