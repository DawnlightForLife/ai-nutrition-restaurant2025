import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile.dart';
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
        if (data['profiles'] != null && (data['profiles'] as List).isNotEmpty) {
          // 获取第一个或主档案
          final profileData = (data['profiles'] as List)[0] as Map<String, dynamic>;
          final profileModel = NutritionProfileModel.fromJson(profileData);
          final profile = _modelToEntity(profileModel);
          
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
      
      final profileModel = _entityToModel(profile);
      final response = await _nutritionApi.updateNutritionProfile(
        userId,
        profileModel.toJson(),
      );
      
      if (response.response.statusCode == 200 || response.response.statusCode == 201) {
        final profileData = (response.data['profile'] ?? response.data) as Map<String, dynamic>;
        final newProfileModel = NutritionProfileModel.fromJson(profileData);
        final newProfile = _modelToEntity(newProfileModel);
        
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
    if (profile.id.isEmpty) return false;
    
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
      
      final profileModel = _entityToModel(profile);
      final response = await _nutritionApi.updateNutritionProfile(
        userId,
        profileModel.toJson(),
      );
      
      if (response.response.statusCode == 200) {
        final profileData = (response.data['profile'] ?? response.data) as Map<String, dynamic>;
        final updatedProfileModel = NutritionProfileModel.fromJson(profileData);
        final updatedProfile = _modelToEntity(updatedProfileModel);
        
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
      'name': '档案名称',
      'age': '年龄',
      'gender': '性别',
      'height': '身高',
      'weight': '体重',
      'activityLevel': '活动水平',
      'dietaryPreferences': '饮食偏好',
      'healthConditions': '健康状况',
    };
    
    if (profile.name.isNotEmpty) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['name']!);
    }
    
    if (profile.basicInfo.age > 0) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['age']!);
    }
    
    completedFields++; // gender is always set
    
    if (profile.basicInfo.height > 0) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['height']!);
    }
    
    if (profile.basicInfo.weight > 0) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['weight']!);
    }
    
    completedFields++; // activityLevel is always set
    
    if (profile.dietaryPreferences.isNotEmpty) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['dietaryPreferences']!);
    }
    
    if (profile.healthConditions.isNotEmpty) {
      completedFields++;
    } else {
      missingFields.add(fieldNames['healthConditions']!);
    }
    
    final int totalFields = 8;
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
        return response.data as Map<String, dynamic>;
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

  // 模型转实体
  NutritionProfile _modelToEntity(NutritionProfileModel model) {
    // 创建基本信息
    final basicInfo = BasicInfo(
      age: 25, // 默认值，因为model使用ageGroup
      gender: model.gender == 'male' ? Gender.male : Gender.female,
      height: model.height ?? 170.0,
      weight: model.weight ?? 60.0,
      activityLevel: _parseActivityLevel(model.activityLevel),
    );

    // 创建饮食偏好列表（简化）
    final dietaryPreferences = <DietaryPreference>[];
    
    // 创建健康状况列表（简化）
    final healthConditions = <HealthCondition>[];

    // 创建生活习惯（使用默认值）
    const lifestyleHabits = LifestyleHabits(
      sleepPattern: SleepPattern.regular,
      exerciseFrequency: ExerciseFrequency.sometimes,
      dailyWaterIntake: 2000,
      smokingStatus: false,
      alcoholConsumption: AlcoholConsumption.occasionally,
    );

    return NutritionProfile(
      id: model.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: model.userId,
      name: model.profileName,
      basicInfo: basicInfo,
      dietaryPreferences: dietaryPreferences,
      healthConditions: healthConditions,
      lifestyleHabits: lifestyleHabits,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // 实体转模型
  NutritionProfileModel _entityToModel(NutritionProfile entity) {
    return NutritionProfileModel(
      id: entity.id,
      userId: entity.userId,
      profileName: entity.name,
      gender: entity.basicInfo.gender.name,
      height: entity.basicInfo.height,
      weight: entity.basicInfo.weight,
      activityLevel: entity.basicInfo.activityLevel.name,
      nutritionGoals: const [], // 简化
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // 解析活动水平
  ActivityLevel _parseActivityLevel(String? level) {
    switch (level) {
      case 'sedentary': return ActivityLevel.sedentary;
      case 'light': return ActivityLevel.light;
      case 'moderate': return ActivityLevel.moderate;
      case 'active': return ActivityLevel.active;
      case 'very_active': return ActivityLevel.veryActive;
      default: return ActivityLevel.moderate;
    }
  }
}

// Providers
final nutritionApiProvider = Provider<NutritionApi>((ref) => ApiClient().getClient(NutritionApi));
final authServiceProvider = Provider<AuthLocalDataSource>((ref) => AuthLocalDataSource());

final nutritionProfileProvider = StateNotifierProvider<NutritionProfileNotifier, NutritionProfileState>((ref) {
  final nutritionApi = ref.watch(nutritionApiProvider);
  final authService = ref.watch(authServiceProvider);
  return NutritionProfileNotifier(nutritionApi, authService);
});