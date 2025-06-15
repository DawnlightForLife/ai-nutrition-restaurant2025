import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../providers/nutrition_profile_list_provider.dart';
import '../../../../routes/app_navigator.dart';

/// 营养档案选择页面 - 用于AI推荐前选择基准档案
class NutritionProfileSelectionPage extends ConsumerStatefulWidget {
  final bool forAIRecommendation;
  
  const NutritionProfileSelectionPage({
    super.key,
    this.forAIRecommendation = true,
  });

  @override
  ConsumerState<NutritionProfileSelectionPage> createState() =>
      _NutritionProfileSelectionPageState();
}

class _NutritionProfileSelectionPageState
    extends ConsumerState<NutritionProfileSelectionPage> {
  String? _selectedProfileId;

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(nutritionProfileListProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forAIRecommendation 
          ? '请选择需要获取推荐的营养档案'
          : '选择营养档案'),
        centerTitle: true,
      ),
      body: () {
        if (profileState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (profileState.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('加载失败: ${profileState.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(nutritionProfileListProvider.notifier).loadProfiles();
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        
        return _buildProfileList(context, profileState.profiles);
      }(),
      bottomNavigationBar: widget.forAIRecommendation ? null : _buildBottomBar(context),
    );
  }

  Widget _buildProfileList(BuildContext context, List<NutritionProfileV2> profiles) {
    if (profiles.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        // 说明卡片
        if (widget.forAIRecommendation) _buildExplanationCard(context),
        
        // 档案列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return _buildProfileCard(context, profile);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '为什么需要选择营养档案？',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'AI将基于您选择的档案，考虑您的健康目标、饮食偏好、过敏原等信息，为您推荐最合适的餐品。\n\n点击档案卡片即可开始。',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, NutritionProfileV2 profile) {
    final theme = Theme.of(context);
    final isSelected = _selectedProfileId == profile.id;
    
    // 计算档案完整度
    final completeness = _calculateProfileCompleteness(profile);
    
    // 解析健康目标
    final healthGoals = _parseHealthGoals(profile);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: widget.forAIRecommendation 
          ? () => _handleProfileSelection(context, profile.id!)
          : () => setState(() => _selectedProfileId = profile.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部信息
              Row(
                children: [
                  // 选中状态
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                        width: 2,
                      ),
                      color: isSelected ? theme.colorScheme.primary : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  
                  // 档案名称
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              profile.profileName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
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
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '主档案',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '完整度 $completeness%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 档案详情
              _buildInfoRow(
                context,
                Icons.flag,
                '健康目标',
                healthGoals.isEmpty ? '未设置' : healthGoals.join('、'),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                Icons.restaurant,
                '饮食偏好',
                profile.dietaryPreferences.isEmpty
                    ? '未设置'
                    : '${profile.dietaryPreferences.length}项偏好',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                context,
                Icons.warning,
                '过敏原',
                profile.allergies.isEmpty
                    ? '无'
                    : '${profile.allergies.length}种过敏原',
                warningColor: profile.allergies.isNotEmpty,
              ),
              
              // 进度条
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: completeness / 100,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  completeness >= 80
                      ? Colors.green
                      : completeness >= 50
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool warningColor = false,
  }) {
    final theme = Theme.of(context);
    final color = warningColor ? theme.colorScheme.error : theme.colorScheme.primary;
    
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '还没有营养档案',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '创建营养档案，让AI更了解您的需求',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => AppNavigator.toNutritionProfileWizard(context),
            icon: const Icon(Icons.add),
            label: const Text('创建档案'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: _selectedProfileId == null
            ? null
            : () => _handleProfileSelection(context),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
        ),
        child: const Text('使用此档案进行推荐'),
      ),
    );
  }

  void _handleProfileSelection(BuildContext context, [String? profileId]) {
    final selectedId = profileId ?? _selectedProfileId;
    if (selectedId == null) return;
    
    // 跳转到AI聊天页面，传递选中的档案ID
    AppNavigator.toAIChat(context, selectedId);
  }

  // 计算档案完整度
  int _calculateProfileCompleteness(NutritionProfileV2 profile) {
    int score = 0;
    int total = 10;
    
    // 基本信息（每项10分）
    if (profile.gender.isNotEmpty) score++;
    if (profile.ageGroup.isNotEmpty) score++;
    if (profile.height > 0) score++;
    if (profile.weight > 0) score++;
    
    // 健康目标（20分）
    if (profile.healthGoalDetails != null && 
        (profile.healthGoalDetails!['goals'] as List?)?.isNotEmpty == true) {
      score += 2;
    }
    
    // 饮食偏好（10分）
    if (profile.dietaryPreferences.isNotEmpty) score++;
    
    // 运动频率（10分）
    if (profile.exerciseFrequency != null && profile.exerciseFrequency!.isNotEmpty) score++;
    
    // 过敏原（10分）
    if (profile.allergies.isNotEmpty) score++;
    
    // 医疗状况（10分）
    if (profile.medicalConditions.isNotEmpty) score++;
    
    return (score * 100 / total).round();
  }

  // 解析健康目标
  List<String> _parseHealthGoals(NutritionProfileV2 profile) {
    if (profile.healthGoalDetails != null) {
      final goals = profile.healthGoalDetails!['goals'] as List?;
      if (goals != null && goals.isNotEmpty) {
        return goals.map((g) => _getGoalDisplayName(g.toString())).toList();
      }
    }
    
    // 兼容旧版本
    if (profile.healthGoal.isNotEmpty) {
      return [_getGoalDisplayName(profile.healthGoal)];
    }
    
    return [];
  }

  String _getGoalDisplayName(String goal) {
    final goalMap = {
      'weight_loss': '减重',
      'muscle_gain': '增肌',
      'blood_sugar_control': '控糖',
      'blood_pressure_control': '控压',
      'immunity_boost': '提升免疫力',
      'sports_performance': '运动表现',
      'gut_health': '肠道健康',
      'energy_boost': '提升能量',
    };
    
    return goalMap[goal] ?? goal;
  }
}