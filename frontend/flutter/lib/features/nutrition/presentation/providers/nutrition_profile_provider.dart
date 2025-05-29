import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/nutrition_profile_model.dart';
import '../../data/datasources/nutrition_api.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';

// 完成度统计模型
class CompletionStats {
  final int completionPercentage;
  final List<String> missingFields;

  CompletionStats({
    required this.completionPercentage,
    required this.missingFields,
  });
}

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
  final NutritionApi _nutritionApi;
  final AuthLocalDataSource _authService;
  
  NutritionProfileNotifier(this._nutritionApi, this._authService) 
      : super(NutritionProfileState()) {
    loadProfile();
  }
  
  // 加载用户档案
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final userId = await _authService.getUserId();
      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          error: '用户未登录',
        );
        return;
      }
      
      final response = await _nutritionApi.getNutritionProfile(userId);
      
      if (response.response.statusCode == 200) {
        final data = response.data;
        if (data['profiles'] != null && data['profiles'].isNotEmpty) {
          // 获取第一个或主档案
          final profileData = data['profiles'][0];
          final profile = NutritionProfile.fromJson(profileData);
          
          // 计算完成度
          final completionStats = _calculateCompletionStats(profile);
          
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
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '获取档案失败: ${response.response.statusMessage}',
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
      final userId = await _authService.getUserId();
      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          error: '用户未登录',
        );
        return false;
      }
      
      final response = await _nutritionApi.updateNutritionProfile(
        userId,
        profile.toJson(),
      );
      
      if (response.response.statusCode == 200 || response.response.statusCode == 201) {
        final profileData = response.data['profile'] ?? response.data;
        final newProfile = NutritionProfile.fromJson(profileData);
        
        state = state.copyWith(
          isLoading: false,
          profile: newProfile,
        );
        
        // 重新计算完成度
        final completionStats = _calculateCompletionStats(newProfile);
        state = state.copyWith(completionStats: completionStats);
        
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '创建档案失败: ${response.response.statusMessage}',
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
      final userId = await _authService.getUserId();
      if (userId == null) {
        state = state.copyWith(
          isLoading: false,
          error: '用户未登录',
        );
        return false;
      }
      
      final response = await _nutritionApi.updateNutritionProfile(
        userId,
        profile.toJson(),
      );
      
      if (response.response.statusCode == 200) {
        final profileData = response.data['profile'] ?? response.data;
        final updatedProfile = NutritionProfile.fromJson(profileData);
        
        state = state.copyWith(
          isLoading: false,
          profile: updatedProfile,
        );
        
        // 重新计算完成度
        final completionStats = _calculateCompletionStats(updatedProfile);
        state = state.copyWith(completionStats: completionStats);
        
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '更新档案失败: ${response.response.statusMessage}',
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
  
  // 本地计算完成度
  CompletionStats _calculateCompletionStats(NutritionProfile profile) {
    int completedFields = 0;
    List<String> missingFields = [];
    final Map<String, String> fieldNames = {
      'profileName': '档案名称',
      'gender': '性别',
      'height': '身高',
      'weight': '体重',
      'activityLevel': '活动水平',
      'nutritionGoals': '营养目标',
      'targetWeight': '目标体重',
      'allergies': '过敏源',
      'medicalConditions': '健康状况',
      'dailyCalorieTarget': '每日卡路里目标',
      'hydrationGoal': '水分摄入目标',
    };
    
    if (profile.profileName.isNotEmpty) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['profileName']!);
    }
    
    if (profile.gender != null) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['gender']!);
    }
    
    if (profile.height != null && profile.height! > 0) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['height']!);
    }
    
    if (profile.weight != null && profile.weight! > 0) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['weight']!);
    }
    
    if (profile.activityLevel != null) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['activityLevel']!);
    }
    
    if (profile.nutritionGoals.isNotEmpty) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['nutritionGoals']!);
    }
    
    if (profile.targetWeight != null && profile.targetWeight! > 0) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['targetWeight']!);
    }
    
    if (profile.dietaryPreferences?.allergies?.isNotEmpty == true) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['allergies']!);
    }
    
    if (profile.medicalConditions?.isNotEmpty == true) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['medicalConditions']!);
    }
    
    if (profile.dailyCalorieTarget != null && profile.dailyCalorieTarget! > 0) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['dailyCalorieTarget']!);
    }
    
    if (profile.hydrationGoal != null && profile.hydrationGoal! > 0) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['hydrationGoal']!);
    }
    
    final int totalFields = 11;
    final int completionPercentage = ((completedFields / totalFields) * 100).round();
    
    return CompletionStats(
      completionPercentage: completionPercentage,
      missingFields: missingFields,
    );
  }
  
  // 获取AI推荐数据
  Future<Map<String, dynamic>?> getProfileForAI() async {
    try {
      final userId = await _authService.getUserId();
      if (userId == null) return null;
      
      final response = await _nutritionApi.getNutritionProfile(userId);
      if (response.response.statusCode == 200) {
        return response.data;
      }
      return null;
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
final nutritionApiProvider = Provider((ref) => ApiClient().getClient(NutritionApi));
final authServiceProvider = Provider((ref) => AuthLocalDataSource());

final nutritionProfileProvider = StateNotifierProvider<NutritionProfileNotifier, NutritionProfileState>((ref) {
  final nutritionApi = ref.watch(nutritionApiProvider);
  final authService = ref.watch(authServiceProvider);
  return NutritionProfileNotifier(nutritionApi, authService);
});