import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/nutrition/entities/nutrition_profile_v2.dart';
import '../../../domain/user/value_objects/user_id.dart';
import '../../../infrastructure/repositories/nutrition_repository.dart';
import '../../../core/di/injection.dart';
import 'nutrition_profile_provider.dart';
import '../../../providers/repository_providers.dart';
import '../../../mappers/nutrition_profile_mapper.dart';
import '../../../services/auth_service.dart';

// 营养档案列表状态
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

// 营养档案列表Provider
final nutritionProfileListProvider =
    StateNotifierProvider<NutritionProfileListNotifier, NutritionProfileListState>(
  (ref) => NutritionProfileListNotifier(ref),
);

class NutritionProfileListNotifier extends StateNotifier<NutritionProfileListState> {
  final Ref _ref;

  NutritionProfileListNotifier(this._ref)
      : super(const NutritionProfileListState());

  // 加载档案列表
  Future<void> loadProfiles() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = _ref.read(nutritionRepositoryProvider);
      final result = await repository.getUserProfilesV2();
      
      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (profiles) {
          // 根据isPrimary和updatedAt排序
          profiles.sort((a, b) {
            if (a.isPrimary && !b.isPrimary) return -1;
            if (!a.isPrimary && b.isPrimary) return 1;
            return b.updatedAt.compareTo(a.updatedAt);
          });

          state = state.copyWith(
            profiles: profiles,
            isLoading: false,
            activeProfile: profiles.isNotEmpty 
                ? profiles.firstWhere((p) => p.isPrimary, orElse: () => profiles.first)
                : null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 创建新档案
  Future<void> createProfile(NutritionProfileV2 profile) async {
    try {
      final repository = _ref.read(nutritionRepositoryProvider);
      
      // 如果是第一个档案，设置为主档案
      final profileToCreate = state.profiles.isEmpty
          ? profile.copyWith(isPrimary: true)
          : profile;
      
      final result = await repository.createNutritionProfileV2(profileToCreate);
      
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.message);
        },
        (createdProfile) {
          final updatedProfiles = [...state.profiles, createdProfile];
          
          // 重新排序
          updatedProfiles.sort((a, b) {
            if (a.isPrimary && !b.isPrimary) return -1;
            if (!a.isPrimary && b.isPrimary) return 1;
            return b.updatedAt.compareTo(a.updatedAt);
          });

          state = state.copyWith(profiles: updatedProfiles);
        },
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 更新档案
  Future<void> updateProfile(NutritionProfileV2 profile) async {
    try {
      final repository = _ref.read(nutritionRepositoryProvider);
      final result = await repository.updateNutritionProfileV2(profile);
      
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.message);
        },
        (updatedProfile) {
          final updatedProfiles = state.profiles.map((p) {
            return p.id == profile.id ? updatedProfile : p;
          }).toList();

          // 重新排序
          updatedProfiles.sort((a, b) {
            if (a.isPrimary && !b.isPrimary) return -1;
            if (!a.isPrimary && b.isPrimary) return 1;
            return b.updatedAt.compareTo(a.updatedAt);
          });

          state = state.copyWith(profiles: updatedProfiles);
        },
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 删除档案
  Future<void> deleteProfile(String profileId) async {
    try {
      // 不能删除最后一个档案
      if (state.profiles.length <= 1) {
        state = state.copyWith(error: '至少需要保留一个营养档案');
        return;
      }

      final repository = _ref.read(nutritionRepositoryProvider);
      final result = await repository.deleteNutritionProfileV2(profileId);
      
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.message);
        },
        (_) {
          final profileToDelete = state.profiles.firstWhere((p) => p.id == profileId);
          final updatedProfiles = state.profiles.where((p) => p.id != profileId).toList();

          // 如果删除的是主档案，将第一个档案设为主档案
          if (profileToDelete.isPrimary && updatedProfiles.isNotEmpty) {
            updatedProfiles[0] = updatedProfiles[0].copyWith(isPrimary: true);
          }

          state = state.copyWith(
            profiles: updatedProfiles,
            activeProfile: updatedProfiles.isNotEmpty 
                ? updatedProfiles.firstWhere((p) => p.isPrimary, orElse: () => updatedProfiles.first)
                : null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 切换主档案
  Future<void> togglePrimary(String profileId) async {
    try {
      final repository = _ref.read(nutritionRepositoryProvider);
      
      // 调用API设置主档案
      final result = await repository.setPrimaryProfileV2(profileId);
      
      result.fold(
        (failure) {
          state = state.copyWith(error: failure.message);
        },
        (_) {
      
      final updatedProfiles = state.profiles.map((p) {
        if (p.id == profileId) {
          return p.copyWith(isPrimary: !p.isPrimary);
        } else if (p.isPrimary) {
          // 如果设置新的主档案，取消其他档案的主档案状态
          return p.copyWith(isPrimary: false);
        }
        return p;
      }).toList();

      // 确保至少有一个主档案
      if (!updatedProfiles.any((p) => p.isPrimary)) {
        updatedProfiles[0] = updatedProfiles[0].copyWith(isPrimary: true);
      }

      // 重新排序
      updatedProfiles.sort((a, b) {
        if (a.isPrimary && !b.isPrimary) return -1;
        if (!a.isPrimary && b.isPrimary) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });

          state = state.copyWith(
            profiles: updatedProfiles,
            activeProfile: updatedProfiles.firstWhere((p) => p.isPrimary),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 设置活动档案
  void setActiveProfile(NutritionProfileV2 profile) {
    state = state.copyWith(activeProfile: profile);
    // 同时更新单个档案provider
    _ref.read(nutritionProfileProvider.notifier).state = 
        _ref.read(nutritionProfileProvider).copyWith(profile: profile);
  }

  // 根据ID获取档案
  NutritionProfileV2? getProfileById(String profileId) {
    try {
      return state.profiles.firstWhere((p) => p.id == profileId);
    } catch (_) {
      return null;
    }
  }
}

// 活动档案Provider
final activeNutritionProfileProvider = Provider<NutritionProfileV2?>((ref) {
  final listState = ref.watch(nutritionProfileListProvider);
  return listState.activeProfile;
});

// 主档案Provider
final primaryNutritionProfileProvider = Provider<NutritionProfileV2?>((ref) {
  final listState = ref.watch(nutritionProfileListProvider);
  try {
    return listState.profiles.firstWhere((p) => p.isPrimary);
  } catch (_) {
    return listState.profiles.firstOrNull;
  }
});