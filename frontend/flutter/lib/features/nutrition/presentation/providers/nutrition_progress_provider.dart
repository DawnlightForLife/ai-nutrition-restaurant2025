import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/services/nutrition_progress_service.dart';
import 'nutrition_profile_list_provider.dart';

/// 营养立方进度状态
class NutritionProgressState {
  final bool isLoading;
  final String? error;
  final String lastAction;
  
  const NutritionProgressState({
    this.isLoading = false,
    this.error,
    this.lastAction = '',
  });
  
  NutritionProgressState copyWith({
    bool? isLoading,
    String? error,
    String? lastAction,
  }) {
    return NutritionProgressState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}

/// 营养立方进度提供者
class NutritionProgressNotifier extends StateNotifier<NutritionProgressState> {
  final Ref _ref;
  
  NutritionProgressNotifier(this._ref) 
      : super(const NutritionProgressState());
  
  /// 添加能量点数
  Future<void> addEnergyPoints(
    String profileId,
    int points, {
    String? activityType,
    String? description,
  }) async {
    if (points <= 0) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // 获取当前档案
      final profileNotifier = _ref.read(nutritionProfileListProvider.notifier);
      final currentProfile = profileNotifier.getProfileById(profileId);
      if (currentProfile == null) {
        throw Exception('档案不存在');
      }
      
      // 添加能量点数
      final updatedProfile = NutritionProgressService.addEnergyPoints(
        currentProfile,
        points,
        activityType: activityType,
      );
      
      // 保存更新
      await profileNotifier.updateProfile(updatedProfile);
      
      // 刷新档案列表
      _ref.invalidate(nutritionProfileListProvider);
      
      final actionDesc = description ?? activityType ?? '获得能量';
      state = state.copyWith(
        isLoading: false,
        lastAction: '✨ $actionDesc +$points 能量点',
      );
      
      print('🎯 营养立方: $actionDesc +$points 能量点, 总计: ${updatedProfile.totalEnergyPoints}');
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '添加能量点失败: $e',
      );
      print('❌ 添加能量点失败: $e');
    }
  }
  
  /// 记录档案创建活动
  Future<void> recordProfileCreation(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['profile_create']!,
      activityType: 'profile_create',
      description: '创建营养档案',
    );
  }
  
  /// 记录档案完善活动
  Future<void> recordProfileCompletion(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['profile_complete']!,
      activityType: 'profile_complete',
      description: '完善档案信息',
    );
  }

  /// 记录档案克隆活动
  Future<void> recordProfileClone(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['profile_clone']!,
      activityType: 'profile_clone',
      description: '克隆档案',
    );
  }
  
  /// 记录饮食记录活动
  Future<void> recordMealLog(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['meal_log']!,
      activityType: 'meal_log',
      description: '记录饮食',
    );
  }
  
  /// 记录运动记录活动
  Future<void> recordExerciseLog(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['exercise_log']!,
      activityType: 'exercise_log',
      description: '记录运动',
    );
  }
  
  /// 记录体重记录活动
  Future<void> recordWeightLog(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['weight_log']!,
      activityType: 'weight_log',
      description: '记录体重',
    );
  }
  
  /// 记录目标达成活动
  Future<void> recordGoalAchievement(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['goal_achieve']!,
      activityType: 'goal_achieve',
      description: '达成目标',
    );
  }
  
  /// 记录营养咨询活动
  Future<void> recordConsultation(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['consultation']!,
      activityType: 'consultation',
      description: '营养咨询',
    );
  }
  
  /// 记录教育内容阅读活动
  Future<void> recordEducationRead(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['education_read']!,
      activityType: 'education_read',
      description: '学习营养知识',
    );
  }
  
  /// 记录采纳AI建议活动
  Future<void> recordRecommendationFollow(String profileId) async {
    await addEnergyPoints(
      profileId,
      NutritionProgressService.activityPoints['recommendation_follow']!,
      activityType: 'recommendation_follow',
      description: '采纳AI建议',
    );
  }
  
  /// 记录连续活动奖励
  Future<void> recordStreakBonus(String profileId, int streakDays) async {
    final bonusPoints = NutritionProgressService.activityPoints['streak_bonus']! * 
        (streakDays ~/ 7); // 每周连续给额外奖励
    
    if (bonusPoints > 0) {
      await addEnergyPoints(
        profileId,
        bonusPoints,
        activityType: 'streak_bonus',
        description: '连续${streakDays}天奖励',
      );
    }
  }
  
  /// 清除错误状态
  void clearError() {
    state = state.copyWith(error: null);
  }
  
  /// 清除最后操作信息
  void clearLastAction() {
    state = state.copyWith(lastAction: '');
  }
}

/// 营养立方进度提供者
final nutritionProgressProvider = StateNotifierProvider<NutritionProgressNotifier, NutritionProgressState>((ref) {
  return NutritionProgressNotifier(ref);
});

/// 营养档案进度统计提供者
final nutritionProfileStatsProvider = Provider.family<Map<String, dynamic>, NutritionProfileV2>((ref, profile) {
  return {
    'energyLevel': profile.energyLevel,
    'energyLevelName': profile.energyLevelName,
    'energyLevelProgress': profile.energyLevelProgress,
    'totalEnergyPoints': profile.totalEnergyPoints,
    'currentStreak': profile.currentStreak,
    'bestStreak': profile.bestStreak,
    'isStreakActive': profile.isStreakActive,
    'todayPoints': NutritionProgressService.getTodayPoints(profile),
    'weeklyActiveDays': NutritionProgressService.getWeeklyActiveDays(profile),
    'monthlyActiveDays': NutritionProgressService.getMonthlyActiveDays(profile),
    'motivationalMessage': NutritionProgressService.getMotivationalMessage(profile),
    'pointsToNextLevel': NutritionProgressService.getPointsToNextLevel(profile),
  };
});