import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile.dart';
import '../providers/nutrition_profile_provider.dart';
import 'nutrition_profile_editor.dart';

/// 营养档案详情页
class NutritionProfileDetailPage extends ConsumerWidget {
  final String profileId;
  
  const NutritionProfileDetailPage({
    super.key,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(nutritionProfileProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养档案详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(context, ref),
          ),
        ],
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('加载失败: ${profileState.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(nutritionProfileProvider),
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : profileState.profile != null
                  ? _buildProfileContent(context, ref, profileState.profile!)
                  : const Center(child: Text('档案未找到')),
      floatingActionButton: profileState.profile != null
          ? FloatingActionButton.extended(
              onPressed: () => _generateAIRecommendation(context, ref, profileState.profile!),
              icon: const Icon(Icons.psychology),
              label: const Text('获取AI推荐'),
            )
          : null,
    );
  }

  Widget _buildProfileContent(BuildContext context, WidgetRef ref, NutritionProfile profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BasicInfoSection(profile: profile),
          const SizedBox(height: 24),
          _DietaryPreferencesSection(profile: profile),
          const SizedBox(height: 24),
          _HealthConditionSection(profile: profile),
          const SizedBox(height: 24),
          _LifestyleSection(profile: profile),
          const SizedBox(height: 24),
          _RecommendationHistorySection(profileId: profileId),
        ],
      ),
    );
  }

  void _editProfile(BuildContext context, WidgetRef ref) async {
    final profileState = ref.read(nutritionProfileProvider);
    
    if (profileState.profile != null) {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => NutritionProfileEditor(profile: profileState.profile),
        ),
      );
      
      if (result == true) {
        // 刷新档案数据
        ref.refresh(nutritionProfileProvider);
      }
    }
  }

  void _generateAIRecommendation(BuildContext context, WidgetRef ref, NutritionProfile profile) async {
    // 暂时显示开发中提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI推荐功能开发中...')),
    );
  }
}

class _BasicInfoSection extends StatelessWidget {
  final NutritionProfile profile;
  const _BasicInfoSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '基本信息',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('年龄', '${profile.basicInfo.age}岁'),
            _buildInfoRow('性别', profile.basicInfo.gender == Gender.male ? '男' : '女'),
            _buildInfoRow('身高', '${profile.basicInfo.height}cm'),
            _buildInfoRow('体重', '${profile.basicInfo.weight}kg'),
            _buildInfoRow('BMI', _calculateBMI()),
            _buildInfoRow('活动水平', _getActivityLevelText()),
          ],
        ),
      ),
    );
  }

  String _calculateBMI() {
    final bmi = profile.basicInfo.bmi;
    String category;
    if (bmi < 18.5) category = '偏瘦';
    else if (bmi < 24) category = '正常';
    else if (bmi < 28) category = '偏胖';
    else category = '肥胖';
    return '${bmi.toStringAsFixed(1)} ($category)';
  }
  
  String _getActivityLevelText() {
    switch (profile.basicInfo.activityLevel) {
      case ActivityLevel.sedentary: return '久坐不动';
      case ActivityLevel.light: return '轻度活动';
      case ActivityLevel.moderate: return '中度活动';
      case ActivityLevel.active: return '活跃';
      case ActivityLevel.veryActive: return '非常活跃';
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _DietaryPreferencesSection extends StatelessWidget {
  final NutritionProfile profile;
  const _DietaryPreferencesSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '饮食偏好',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            profile.dietaryPreferences.isNotEmpty
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.dietaryPreferences
                        .map((pref) => _buildTag(pref.name))
                        .toList(),
                  )
                : const Text('未设置饮食偏好', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.blue.withOpacity(0.1),
    );
  }
}

class _HealthConditionSection extends StatelessWidget {
  final NutritionProfile profile;
  const _HealthConditionSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '健康状况',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (profile.healthConditions.isNotEmpty) ...[
              ...profile.healthConditions.map((condition) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('• ${condition.name}'),
              )).toList(),
            ] else
              const Text('无特殊疾病史', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('无过敏史', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _LifestyleSection extends StatelessWidget {
  final NutritionProfile profile;
  const _LifestyleSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '生活习惯',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('活动水平：${_getActivityLevelText()}'),
            Text('睡眠模式：${_getSleepPatternText()}'),
            Text('运动频率：${_getExerciseFrequencyText()}'),
            Text('饮水量：${profile.lifestyleHabits.dailyWaterIntake}ml/天'),
            Text('档案创建：${_formatDate(profile.createdAt)}'),
            Text('最后更新：${_formatDate(profile.updatedAt)}'),
          ],
        ),
      ),
    );
  }

  String _getActivityLevelText() {
    switch (profile.basicInfo.activityLevel) {
      case ActivityLevel.sedentary: return '久坐不动';
      case ActivityLevel.light: return '轻度活动';
      case ActivityLevel.moderate: return '中度活动';
      case ActivityLevel.active: return '活跃';
      case ActivityLevel.veryActive: return '非常活跃';
    }
  }

  String _getSleepPatternText() {
    switch (profile.lifestyleHabits.sleepPattern) {
      case SleepPattern.regular: return '规律';
      case SleepPattern.irregular: return '不规律';
      case SleepPattern.insufficient: return '睡眠不足';
    }
  }

  String _getExerciseFrequencyText() {
    switch (profile.lifestyleHabits.exerciseFrequency) {
      case ExerciseFrequency.never: return '从不';
      case ExerciseFrequency.rarely: return '很少';
      case ExerciseFrequency.sometimes: return '偶尔';
      case ExerciseFrequency.often: return '经常';
      case ExerciseFrequency.daily: return '每天';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _RecommendationHistorySection extends StatelessWidget {
  final String profileId;
  const _RecommendationHistorySection({required this.profileId});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '推荐记录',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.restaurant),
              title: const Text('今日营养推荐'),
              subtitle: const Text('2024-01-15'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: 查看推荐详情
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.restaurant),
              title: const Text('本周营养计划'),
              subtitle: const Text('2024-01-08'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: 查看推荐详情
              },
            ),
          ],
        ),
      ),
    );
  }
}