import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/services/nutrition_progress_service.dart';
import '../providers/nutrition_progress_provider.dart';

/// 营养立方进度卡片
/// 
/// 显示用户的营养立方能量进度、等级、连续天数等信息
/// 提供正反馈机制，增强用户粘性
class NutritionCubeProgressCard extends ConsumerWidget {
  final NutritionProfileV2 profile;
  final VoidCallback? onTap;

  const NutritionCubeProgressCard({
    Key? key,
    required this.profile,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stats = ref.watch(nutritionProfileStatsProvider(profile));
    
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: _getGradientForLevel(stats['energyLevel']),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconForLevel(stats['energyLevel']),
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '营养立方',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            stats['energyLevelName'],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${stats['totalEnergyPoints']}能量',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 进度条
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '等级进度',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        Text(
                          '${stats['pointsToNextLevel'] > 0 ? "还需${stats['pointsToNextLevel']}能量升级" : "已满级"}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: stats['energyLevelProgress'],
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // 统计信息
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.local_fire_department,
                        label: '连续天数',
                        value: '${stats['currentStreak']}天',
                        subtitle: _getStreakLevelName(stats['currentStreak']),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.emoji_events,
                        label: '最佳记录',
                        value: '${stats['bestStreak']}天',
                        subtitle: '历史最高',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        context,
                        icon: Icons.trending_up,
                        label: '活跃状态',
                        value: stats['isStreakActive'] ? '活跃' : '休眠',
                        subtitle: _getLastActiveText(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientForLevel(String level) {
    switch (level) {
      case 'starter':
        return const LinearGradient(
          colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'bronze':
        return const LinearGradient(
          colors: [Color(0xFFD7CCC8), Color(0xFFBCAAA4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'silver':
        return const LinearGradient(
          colors: [Color(0xFFE0E0E0), Color(0xFFBDBDBD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'gold':
        return const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'platinum':
        return const LinearGradient(
          colors: [Color(0xFFB39DDB), Color(0xFF9575CD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'diamond':
        return const LinearGradient(
          colors: [Color(0xFF80CBC4), Color(0xFF4DB6AC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getIconForLevel(String level) {
    switch (level) {
      case 'starter':
        return Icons.rocket_launch;
      case 'bronze':
        return Icons.military_tech;
      case 'silver':
        return Icons.workspace_premium;
      case 'gold':
        return Icons.emoji_events;
      case 'platinum':
        return Icons.diamond;
      case 'diamond':
        return Icons.auto_awesome;
      default:
        return Icons.view_in_ar;
    }
  }

  String _getStreakLevelName(int streak) {
    if (streak >= 30) return '大师级';
    if (streak >= 14) return '专家级';
    if (streak >= 7) return '进阶级';
    if (streak >= 3) return '入门级';
    return '新手';
  }

  String _getLastActiveText() {
    if (profile.lastActiveDate == null) return '从未';
    final now = DateTime.now();
    final diff = now.difference(profile.lastActiveDate!);
    
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '刚刚';
      }
      return '${diff.inHours}小时前';
    } else if (diff.inDays == 1) {
      return '昨天';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '一周前';
    }
  }
}