import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/nutrition/entities/nutrition_profile_v2.dart';
import '../../../domain/user/value_objects/user_id.dart';
import '../../../infrastructure/repositories/nutrition_repository.dart';
import '../../../infrastructure/services/nutrition_api_service.dart';

// 营养档案Repository Provider
final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  // 暂时创建一个新实例，后续可以从依赖注入获取
  return NutritionRepository(NutritionApiService());
});

// 营养档案状态
class NutritionProfileState {
  final NutritionProfileV2? profile;
  final bool isLoading;
  final String? error;

  const NutritionProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  NutritionProfileState copyWith({
    NutritionProfileV2? profile,
    bool? isLoading,
    String? error,
  }) {
    return NutritionProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// 营养档案Provider
final nutritionProfileProvider =
    StateNotifierProvider<NutritionProfileNotifier, NutritionProfileState>(
  (ref) => NutritionProfileNotifier(ref.watch(nutritionRepositoryProvider)),
);

class NutritionProfileNotifier extends StateNotifier<NutritionProfileState> {
  final NutritionRepository _repository;

  NutritionProfileNotifier(this._repository)
      : super(const NutritionProfileState());

  // 加载营养档案
  Future<void> loadProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 调用repository获取营养档案
      // final profile = await _repository.getProfile(userId);
      
      // 模拟数据
      await Future.delayed(const Duration(seconds: 1));
      final profile = NutritionProfileV2.createDefault(
        userId: UserId(userId),
        profileName: '我的营养档案',
      );

      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 创建营养档案
  Future<void> createProfile(NutritionProfileV2 profile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 调用repository创建营养档案
      // final newProfile = await _repository.createProfile(profile);
      
      // 模拟保存
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        profile: profile,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 更新营养档案
  Future<void> updateProfile(NutritionProfileV2 profile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 调用repository更新营养档案
      // final updatedProfile = await _repository.updateProfile(profile);
      
      // 模拟更新
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        profile: profile.copyWith(updatedAt: DateTime.now()),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 删除营养档案
  Future<void> deleteProfile(String profileId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: 调用repository删除营养档案
      // await _repository.deleteProfile(profileId);
      
      // 模拟删除
      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(
        profile: null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 计算推荐热量
  double calculateRecommendedCalories({
    required String gender,
    required String ageGroup,
    required double height,
    required double weight,
    required String healthGoal,
    String? activityLevel,
  }) {
    // 基础代谢率计算（简化版）
    double bmr;
    int estimatedAge = _getEstimatedAge(ageGroup);

    if (gender == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * estimatedAge + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * estimatedAge - 161;
    }

    // 活动系数
    double activityFactor = 1.5; // 默认中等活动水平
    if (activityLevel != null) {
      switch (activityLevel) {
        case 'sedentary':
          activityFactor = 1.2;
          break;
        case 'light':
          activityFactor = 1.375;
          break;
        case 'moderate':
          activityFactor = 1.55;
          break;
        case 'active':
          activityFactor = 1.725;
          break;
        case 'veryActive':
          activityFactor = 1.9;
          break;
      }
    }

    double tdee = bmr * activityFactor;

    // 根据健康目标调整
    switch (healthGoal) {
      case 'loseWeight':
        return tdee * 0.85; // 减少15%
      case 'gainMuscle':
        return tdee * 1.15; // 增加15%
      case 'maintainWeight':
      default:
        return tdee;
    }
  }

  int _getEstimatedAge(String ageGroup) {
    switch (ageGroup) {
      case 'under18':
        return 16;
      case '18to30':
        return 25;
      case '31to45':
        return 38;
      case '46to60':
        return 53;
      case 'over60':
        return 65;
      default:
        return 25;
    }
  }
}

// 营养档案完整度Provider
final nutritionProfileCompletionProvider = Provider<int>((ref) {
  final profileState = ref.watch(nutritionProfileProvider);
  return profileState.profile?.completionPercentage ?? 0;
});

// 是否有营养档案Provider
final hasNutritionProfileProvider = Provider<bool>((ref) {
  final profileState = ref.watch(nutritionProfileProvider);
  return profileState.profile != null;
});

// 营养档案必填项是否完整Provider
final isProfileRequiredFieldsCompleteProvider = Provider<bool>((ref) {
  final profileState = ref.watch(nutritionProfileProvider);
  return profileState.profile?.isRequiredFieldsComplete ?? false;
});