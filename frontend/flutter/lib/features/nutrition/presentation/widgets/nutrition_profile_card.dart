import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/nutrition_profile_v2.dart';

class NutritionProfileCard extends StatelessWidget {
  final NutritionProfileV2 profile;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onPinToggle;

  const NutritionProfileCard({
    super.key,
    required this.profile,
    this.onTap,
    this.onLongPress,
    this.onPinToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy年MM月dd日');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // 顶部区域
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF6366F1).withOpacity(0.1),
                      const Color(0xFF8B5CF6).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    // 档案图标
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // 档案名称和状态
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  profile.profileName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (profile.isPrimary) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber.withOpacity(0.2),
                                        Colors.orange.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber[700],
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '主档案',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.amber[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getHealthGoalText(profile.healthGoal),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 完整度
                    _buildCompletionIndicator(context, profile.completionPercentage),
                  ],
                ),
              ),
              // 基本信息
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // 基本信息行
                    Row(
                      children: [
                        _buildInfoItem(
                          context,
                          icon: Icons.cake_outlined,
                          label: '年龄',
                          value: _getAgeGroupText(profile.ageGroup),
                        ),
                        const SizedBox(width: 24),
                        _buildInfoItem(
                          context,
                          icon: Icons.straighten,
                          label: '身高',
                          value: '${profile.height.toStringAsFixed(0)}cm',
                        ),
                        const SizedBox(width: 24),
                        _buildInfoItem(
                          context,
                          icon: Icons.monitor_weight_outlined,
                          label: '体重',
                          value: '${profile.weight.toStringAsFixed(1)}kg',
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _buildInfoItem(
                            context,
                            icon: Icons.analytics_outlined,
                            label: 'BMI',
                            value: profile.bmi.toStringAsFixed(1),
                            valueColor: _getBMIColor(profile.bmi),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 饮食偏好标签
                    if (profile.dietaryPreferences.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: profile.dietaryPreferences.take(3).map((pref) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF6366F1).withOpacity(0.1),
                                        const Color(0xFF8B5CF6).withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _getDietaryPreferenceText(pref),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                );
                              }).toList()
                                ..addAll(
                                  profile.dietaryPreferences.length > 3
                                      ? [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '+${profile.dietaryPreferences.length - 3}',
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ]
                                      : [],
                                ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // 底部信息
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '更新于 ${dateFormat.format(profile.updatedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    if (onPinToggle != null)
                      InkWell(
                        onTap: onPinToggle,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            profile.isPrimary ? Icons.star : Icons.star_border,
                            size: 20,
                            color: profile.isPrimary ? Colors.amber : Colors.grey,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        Text(
          '$label ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionIndicator(BuildContext context, int percentage) {
    final theme = Theme.of(context);
    final color = _getCompletionColor(percentage);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 4,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$percentage%',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '完整度',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getCompletionColor(int percentage) {
    if (percentage < 60) return Colors.orange;
    if (percentage < 80) return Colors.blue;
    return Colors.green;
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24) return Colors.green;
    if (bmi < 28) return Colors.orange;
    return Colors.red;
  }

  String _getHealthGoalText(String goal) {
    final goals = {
      'loseWeight': '减脂瘦身',
      'gainMuscle': '增肌塑形',
      'maintainWeight': '保持体重',
      'balancedNutrition': '均衡营养',
      'manageDisease': '疾病管理',
      'other': '其他目标',
    };
    return goals[goal] ?? goal;
  }

  String _getAgeGroupText(String ageGroup) {
    final groups = {
      'under18': '<18岁',
      '18to30': '18-30岁',
      '31to45': '31-45岁',
      '46to60': '46-60岁',
      'over60': '>60岁',
    };
    return groups[ageGroup] ?? ageGroup;
  }

  String _getDietaryPreferenceText(String pref) {
    final prefs = {
      'vegetarian': '素食',
      'vegan': '纯素',
      'light': '清淡',
      'noSpicy': '不辣',
      'lowSalt': '低盐',
      'lowFat': '低脂',
      'lowSugar': '低糖',
      'highProtein': '高蛋白',
      'organic': '有机',
      'glutenFree': '无麸质',
      'lactoseFree': '无乳糖',
      'other': '其他',
    };
    return prefs[pref] ?? pref;
  }
}