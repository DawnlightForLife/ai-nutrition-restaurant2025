import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../data/repositories/nutrition_profile_repository.dart';
import '../../domain/services/error_handling_service.dart';
import '../../domain/services/retry_service.dart';
import '../../../user/domain/value_objects/user_id.dart';
import '../../../user/presentation/providers/user_provider.dart';
import 'loading_state_provider.dart';

/// 营养档案列表状态
class NutritionProfileListState {
  final List<NutritionProfileV2> profiles;
  final bool isLoading;
  final String? error;
  final NutritionProfileV2? activeProfile;
  final bool canRetry;
  final int retryAttempts;
  final DateTime? lastUpdated;

  const NutritionProfileListState({
    this.profiles = const [],
    this.isLoading = false,
    this.error,
    this.activeProfile,
    this.canRetry = false,
    this.retryAttempts = 0,
    this.lastUpdated,
  });

  NutritionProfileListState copyWith({
    List<NutritionProfileV2>? profiles,
    bool? isLoading,
    String? error,
    NutritionProfileV2? activeProfile,
    bool? canRetry,
    int? retryAttempts,
    DateTime? lastUpdated,
  }) {
    return NutritionProfileListState(
      profiles: profiles ?? this.profiles,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      activeProfile: activeProfile ?? this.activeProfile,
      canRetry: canRetry ?? this.canRetry,
      retryAttempts: retryAttempts ?? this.retryAttempts,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
  
  /// 是否有数据
  bool get hasData => profiles.isNotEmpty;
  
  /// 是否为空状态
  bool get isEmpty => !isLoading && profiles.isEmpty && error == null;
  
  /// 是否有错误
  bool get hasError => error != null;
  
  /// 获取主要档案
  NutritionProfileV2? get primaryProfile {
    return profiles.firstWhereOrNull((p) => p.isPrimary) ?? 
           (profiles.isNotEmpty ? profiles.first : null);
  }
}

/// 营养档案列表状态管理器
class NutritionProfileListNotifier extends StateNotifier<NutritionProfileListState> {
  final NutritionProfileRepository _repository;
  final UserId _userId;

  NutritionProfileListNotifier(this._repository, this._userId)
      : super(const NutritionProfileListState());

  /// 加载档案列表
  Future<void> loadProfiles({bool showLoading = true}) async {
    if (showLoading) {
      state = state.copyWith(
        isLoading: true, 
        error: null,
        retryAttempts: 0,
      );
    }

    try {
      final profiles = await RetryService.execute(
        () => _repository.getProfilesByUserId(_userId.value),
        config: RetryConfig.network,
        onRetry: (attempt, error) {
          print('🔄 重试加载档案列表，第 $attempt 次: $error');
          state = state.copyWith(retryAttempts: attempt);
        },
      );
      
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
        error: null,
        canRetry: false,
        lastUpdated: DateTime.now(),
      );
      
      print('✅ 档案列表加载成功，共 ${profiles.length} 个档案');
    } catch (e) {
      final errorMessage = NutritionErrorHandlingService.getErrorMessage(e);
      final canRetry = NutritionErrorHandlingService.canRetry(e);
      
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        canRetry: canRetry,
      );
      
      print('❌ 档案列表加载失败: $errorMessage');
    }
  }

  /// 重试加载档案列表
  Future<void> retryLoadProfiles() async {
    if (state.canRetry) {
      await loadProfiles();
    }
  }

  /// 创建新档案
  Future<NutritionProfileV2?> createProfile(NutritionProfileV2 profile) async {
    try {
      final newProfile = await RetryService.execute(
        () => _repository.createProfile(profile),
        config: RetryConfig.data,
        onRetry: (attempt, error) {
          print('🔄 重试创建档案，第 $attempt 次: $error');
        },
      );
      
      final updatedProfiles = [...state.profiles, newProfile];
      
      state = state.copyWith(
        profiles: updatedProfiles,
        activeProfile: state.activeProfile ?? newProfile,
        lastUpdated: DateTime.now(),
      );
      
      print('✅ 档案创建成功: ${newProfile.profileName}');
      return newProfile;
    } catch (e) {
      final errorMessage = NutritionErrorHandlingService.getErrorMessage(e);
      state = state.copyWith(error: errorMessage);
      print('❌ 档案创建失败: $errorMessage');
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

  /// 克隆档案
  Future<NutritionProfileV2?> cloneProfile(
    String sourceProfileId, {
    String? newName,
    String cloneMode = 'quick',
  }) async {
    try {
      // 查找源档案
      final sourceProfile = state.profiles.firstWhereOrNull(
        (profile) => profile.id == sourceProfileId,
      );
      
      if (sourceProfile == null) {
        throw Exception('源档案不存在');
      }

      // 创建克隆档案
      final clonedProfile = sourceProfile.copyWith(
        id: null, // 新档案没有ID
        profileName: newName ?? '${sourceProfile.profileName} 副本',
        isPrimary: false, // 克隆的档案不是主要档案
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        // 重置进度数据
        totalEnergyPoints: 0,
        currentStreak: 0,
        bestStreak: 0,
        lastActiveDate: null,
        nutritionProgress: null,
      );
      
      // 创建新档案
      final newProfile = await _repository.createProfile(clonedProfile);
      final updatedProfiles = [...state.profiles, newProfile];
      
      state = state.copyWith(profiles: updatedProfiles);
      
      print('🎯 档案克隆成功: ${sourceProfile.profileName} -> ${newProfile.profileName}');
      return newProfile;
      
    } catch (e) {
      state = state.copyWith(error: e.toString());
      print('❌ 档案克隆失败: $e');
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
  // 从用户状态获取真实的用户ID
  final userState = ref.watch(userProvider);
  final userId = UserId(userState.userId ?? 'guest_user');
  final repository = ref.watch(nutritionProfileRepositoryProvider);
  
  return NutritionProfileListNotifier(repository, userId);
});

/// 营养档案仓库Provider
final nutritionProfileRepositoryProvider = Provider<NutritionProfileRepository>((ref) {
  // TODO: 实现真实的仓库依赖注入
  return NutritionProfileRepositoryImpl();
});