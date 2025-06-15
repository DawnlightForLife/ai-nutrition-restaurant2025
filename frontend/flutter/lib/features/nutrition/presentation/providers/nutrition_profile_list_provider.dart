import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../data/repositories/nutrition_profile_repository.dart';
import '../../../user/domain/value_objects/user_id.dart';

/// 营养档案列表状态
class NutritionProfileListState {
  final List<NutritionProfileV2> profiles;
  final bool isLoading;
  final String? error;
  final NutritionProfileV2? activeProfile;

  const NutritionProfileListState({
    this.profiles = const [],
    this.isLoading = false,
    this.error,
    this.activeProfile,
  });

  NutritionProfileListState copyWith({
    List<NutritionProfileV2>? profiles,
    bool? isLoading,
    String? error,
    NutritionProfileV2? activeProfile,
  }) {
    return NutritionProfileListState(
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      activeProfile: activeProfile ?? this.activeProfile,
    );
  }
}

/// 营养档案列表状态管理器
class NutritionProfileListNotifier extends StateNotifier<NutritionProfileListState> {
  final NutritionProfileRepository _repository;
  final UserId _userId;

  NutritionProfileListNotifier(this._repository, this._userId)
      : super(const NutritionProfileListState());

  /// 加载档案列表
  Future<void> loadProfiles() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profiles = await _repository.getProfilesByUserId(_userId.value);
      
      // 设置默认激活档案（优先选择primary档案）
      NutritionProfileV2? activeProfile;
      if (profiles.isNotEmpty) {
        activeProfile = state.activeProfile ?? 
            profiles.where((p) => p.isPrimary).firstOrNull ?? 
            profiles.first;
      }
      
      state = state.copyWith(
        profiles: profiles,
        isLoading: false,
        activeProfile: activeProfile,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 创建新档案
  Future<void> createProfile(NutritionProfileV2 profile) async {
    try {
      final newProfile = await _repository.createProfile(profile);
      final updatedProfiles = [...state.profiles, newProfile];
      
      state = state.copyWith(
        profiles: updatedProfiles,
        activeProfile: state.activeProfile ?? newProfile,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 更新档案
  Future<void> updateProfile(NutritionProfileV2 profile) async {
    try {
      final updatedProfile = await _repository.updateProfile(profile);
      final updatedProfiles = state.profiles.map((p) {
        return p.id == updatedProfile.id ? updatedProfile : p;
      }).toList();
      
      state = state.copyWith(
        profiles: updatedProfiles,
        activeProfile: state.activeProfile?.id == updatedProfile.id 
            ? updatedProfile 
            : state.activeProfile,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 删除档案
  Future<void> deleteProfile(String profileId) async {
    try {
      await _repository.deleteProfile(profileId);
      final updatedProfiles = state.profiles.where((p) => p.id != profileId).toList();
      
      // 如果删除的是当前激活档案，重新选择一个
      NutritionProfileV2? newActiveProfile;
      if (state.activeProfile?.id == profileId && updatedProfiles.isNotEmpty) {
        newActiveProfile = updatedProfiles.firstWhere(
          (p) => p.isPrimary,
          orElse: () => updatedProfiles.first,
        );
      } else {
        newActiveProfile = state.activeProfile;
      }
      
      state = state.copyWith(
        profiles: updatedProfiles,
        activeProfile: newActiveProfile,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 切换主要档案
  Future<void> togglePrimary(String profileId) async {
    try {
      // 先将所有档案设为非主要
      final updatedProfiles = state.profiles.map((p) {
        if (p.id == profileId) {
          return p.copyWith(isPrimary: true);
        } else {
          return p.copyWith(isPrimary: false);
        }
      }).toList();
      
      // 更新主要档案
      final primaryProfile = updatedProfiles.where((p) => p.id == profileId).firstOrNull;
      if (primaryProfile != null) {
        await _repository.updateProfile(primaryProfile);
      }
      
      state = state.copyWith(profiles: updatedProfiles);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  /// 设置激活档案
  void setActiveProfile(NutritionProfileV2 profile) {
    state = state.copyWith(activeProfile: profile);
  }

  /// 根据ID获取档案
  NutritionProfileV2? getProfileById(String profileId) {
    return state.profiles.where((p) => p.id == profileId).firstOrNull;
  }
}

/// 营养档案列表Provider
final nutritionProfileListProvider = 
    StateNotifierProvider<NutritionProfileListNotifier, NutritionProfileListState>((ref) {
  // TODO: 从用户状态获取真实的用户ID
  final userId = UserId('user1');
  final repository = ref.watch(nutritionProfileRepositoryProvider);
  
  return NutritionProfileListNotifier(repository, userId);
});

/// 营养档案仓库Provider
final nutritionProfileRepositoryProvider = Provider<NutritionProfileRepository>((ref) {
  // TODO: 实现真实的仓库依赖注入
  return NutritionProfileRepositoryImpl();
});