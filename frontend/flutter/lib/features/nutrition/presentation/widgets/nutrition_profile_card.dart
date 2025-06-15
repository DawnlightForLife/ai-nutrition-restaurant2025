import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/constants/nutrition_constants.dart';

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
                    // 基本信息行 - 使用Grid布局防止溢出
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // 如果宽度小于400，使用2x2网格，否则使用1x4
                        if (constraints.maxWidth < 400) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      context,
                                      icon: Icons.cake_outlined,
                                      label: '年龄',
                                      value: _getAgeGroupText(profile.ageGroup),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildInfoItem(
                                      context,
                                      icon: Icons.straighten,
                                      label: '身高',
                                      value: '${profile.height.toStringAsFixed(0)}cm',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      context,
                                      icon: Icons.monitor_weight_outlined,
                                      label: '体重',
                                      value: '${profile.weight.toStringAsFixed(1)}kg',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
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
                            ],
                          );
                        } else {
                          return Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  context,
                                  icon: Icons.cake_outlined,
                                  label: '年龄',
                                  value: _getAgeGroupText(profile.ageGroup),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoItem(
                                  context,
                                  icon: Icons.straighten,
                                  label: '身高',
                                  value: '${profile.height.toStringAsFixed(0)}cm',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildInfoItem(
                                  context,
                                  icon: Icons.monitor_weight_outlined,
                                  label: '体重',
                                  value: '${profile.weight.toStringAsFixed(1)}kg',
                                ),
                              ),
                              const SizedBox(width: 16),
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
                          );
                        }
                      },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary.withOpacity(0.7),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 10,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? theme.colorScheme.onSurface,
            fontSize: 13,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
    // 使用 NutritionConstants 中定义的健康目标选项
    return NutritionConstants.healthGoalOptions[goal] ?? goal;
  }

  String _getAgeGroupText(String ageGroup) {
    // 使用 NutritionConstants 中定义的年龄组选项
    return NutritionConstants.ageGroupOptions[ageGroup] ?? ageGroup;
  }

  String _getDietaryPreferenceText(String pref) {
    // 使用 NutritionConstants 中定义的饮食偏好选项
    return NutritionConstants.dietaryPreferenceOptions[pref] ?? pref;
  }
}