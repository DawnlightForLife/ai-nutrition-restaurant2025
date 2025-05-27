import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/dtos/nutrition_profile_model.dart';
import '../../infrastructure/services/nutrition_profile_api_service.dart';

// 营养档案状态
class NutritionProfileState {
  final bool isLoading;
  final NutritionProfile? profile;
  final CompletionStats? completionStats;
  final String? error;
  
  NutritionProfileState({
    this.isLoading = false,
    this.profile,
    this.completionStats,
    this.error,
  });
  
  NutritionProfileState copyWith({
    bool? isLoading,
    NutritionProfile? profile,
    CompletionStats? completionStats,
    String? error,
  }) {
    return NutritionProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      completionStats: completionStats ?? this.completionStats,
      error: error,
    );
  }
}

// 营养档案状态管理器
class NutritionProfileNotifier extends StateNotifier<NutritionProfileState> {
  final NutritionProfileApiService _apiService;
  
  NutritionProfileNotifier(this._apiService) : super(NutritionProfileState()) {
    loadProfile();
  }
  
  // 加载用户档案
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final profile = await _apiService.getUserProfile();
      
      if (profile != null) {
        final completionStats = await _apiService.getCompletionStats();
        state = state.copyWith(
          isLoading: false,
          profile: profile,
          completionStats: completionStats,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          profile: null,
          completionStats: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  // 创建档案
  Future<bool> createProfile(NutritionProfile profile) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _apiService.createProfile(profile);
      
      if (response.success && response.profile != null) {
        state = state.copyWith(
          isLoading: false,
          profile: response.profile,
        );
        
        // 重新加载完成度统计
        await loadCompletionStats();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? '创建档案失败',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  // 更新档案
  Future<bool> updateProfile(NutritionProfile profile) async {
    if (profile.id == null) return false;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _apiService.updateProfile(profile.id!, profile);
      
      if (response.success && response.profile != null) {
        state = state.copyWith(
          isLoading: false,
          profile: response.profile,
        );
        
        // 重新加载完成度统计
        await loadCompletionStats();
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? '更新档案失败',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }
  
  // 加载完成度统计
  Future<void> loadCompletionStats() async {
    try {
      final completionStats = await _apiService.getCompletionStats();
      state = state.copyWith(completionStats: completionStats);
    } catch (e) {
      print('加载完成度统计失败: $e');
    }
  }
  
  // 验证档案数据
  Future<Map<String, dynamic>> validateProfile(NutritionProfile profile) async {
    try {
      return await _apiService.validateProfile(profile);
    } catch (e) {
      return {
        'success': false,
        'isValid': false,
        'errors': [e.toString()]
      };
    }
  }
  
  // 获取AI推荐数据
  Future<Map<String, dynamic>?> getProfileForAI() async {
    try {
      return await _apiService.getProfileForAI();
    } catch (e) {
      print('获取AI推荐数据失败: $e');
      return null;
    }
  }
  
  // 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final nutritionProfileApiServiceProvider = Provider((ref) => NutritionProfileApiService());

final nutritionProfileProvider = StateNotifierProvider<NutritionProfileNotifier, NutritionProfileState>((ref) {
  final apiService = ref.watch(nutritionProfileApiServiceProvider);
  return NutritionProfileNotifier(apiService);
});