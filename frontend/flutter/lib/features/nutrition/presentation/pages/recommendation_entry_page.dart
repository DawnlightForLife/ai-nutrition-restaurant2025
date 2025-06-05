import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../routes/app_navigator.dart';
import '../../domain/constants/nutrition_constants.dart';
import '../providers/nutrition_provider.dart';

class RecommendationEntryPage extends ConsumerStatefulWidget {
  const RecommendationEntryPage({super.key});

  @override
  ConsumerState<RecommendationEntryPage> createState() =>
      _RecommendationEntryPageState();
}

class _RecommendationEntryPageState
    extends ConsumerState<RecommendationEntryPage> {
  @override
  void initState() {
    super.initState();
    // 页面初始化时检查营养档案
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkNutritionProfile();
    });
  }

  Future<void> _checkNutritionProfile() async {
    // TODO: 检查用户是否有营养档案
    // 如果没有，引导创建
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('元气 AI'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部说明卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '元气智能助手',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '嗨！我是元气，您的智能营养助手。我可以根据您的健康状况为您推荐最合适的美食！',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 营养档案状态卡片
            _buildProfileStatusCard(context),
            const SizedBox(height: 16),

            // 推荐选项
            _buildRecommendationOptions(context),
            const SizedBox(height: 24),

            // 开始推荐按钮
            FilledButton.icon(
              onPressed: _handleStartRecommendation,
              icon: const Icon(Icons.restaurant),
              label: const Text('和元气聊聊'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStatusCard(BuildContext context) {
    final theme = Theme.of(context);
    
    // TODO: 从provider获取实际的档案状态
    final hasProfile = true;
    final completionPercentage = 85;

    return Card(
      child: InkWell(
        onTap: () {
          // 跳转到营养档案管理页
          AppNavigator.toNutritionProfiles(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: hasProfile
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '营养档案',
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (hasProfile) ...[
                    Text(
                      '$completionPercentage%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ] else
                    Chip(
                      label: const Text('未创建'),
                      backgroundColor: theme.colorScheme.error.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (hasProfile) ...[
                LinearProgressIndicator(
                  value: completionPercentage / 100,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                ),
                const SizedBox(height: 8),
                Text(
                  '档案完整度 $completionPercentage%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ] else
                Text(
                  '创建营养档案，获得更精准的推荐',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationOptions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '推荐偏好',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildOptionTile(
                context,
                icon: Icons.location_on,
                title: '推荐范围',
                subtitle: '附近3公里',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: 选择推荐范围
                },
              ),
              const Divider(height: 1),
              _buildOptionTile(
                context,
                icon: Icons.restaurant_menu,
                title: '餐品类型',
                subtitle: '不限',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: 选择餐品类型
                },
              ),
              const Divider(height: 1),
              _buildOptionTile(
                context,
                icon: Icons.schedule,
                title: '用餐时段',
                subtitle: _getMealTimeText(),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: 选择用餐时段
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  String _getMealTimeText() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 10) return '早餐';
    if (hour >= 10 && hour < 14) return '午餐';
    if (hour >= 14 && hour < 17) return '下午茶';
    if (hour >= 17 && hour < 21) return '晚餐';
    return '夜宵';
  }

  void _handleStartRecommendation() {
    // TODO: 检查营养档案是否存在
    final hasProfile = true;

    if (!hasProfile) {
      // 提示创建营养档案
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('需要创建营养档案'),
          content: const Text('为了提供个性化的营养推荐，请先创建您的营养档案。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                AppNavigator.toNutritionProfiles(context);
              },
              child: const Text('去创建'),
            ),
          ],
        ),
      );
    } else {
      // 跳转到AI推荐聊天页
      AppNavigator.toAIChat(context, 'default_profile_id');
    }
  }
}