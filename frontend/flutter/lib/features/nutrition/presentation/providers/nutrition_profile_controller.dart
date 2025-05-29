import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/nutrition_profile_model.dart';
import '../../data/datasources/nutrition_api.dart';
import '../../../../core/network/api_client.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';

part 'nutrition_profile_controller.freezed.dart';
part 'nutrition_profile_controller.g.dart';

/// 完成度统计模型
@freezed
class CompletionStats with _$CompletionStats {
  const factory CompletionStats({
    required int completionPercentage,
    required List<String> missingFields,
  }) = _CompletionStats;
}

/// 营养档案状态
@freezed
class NutritionProfileState with _$NutritionProfileState {
  const factory NutritionProfileState({
    NutritionProfile? profile,
    CompletionStats? completionStats,
  }) = _NutritionProfileState;
}

/// 营养档案控制器 - 使用新的 AsyncNotifier 模式
@riverpod
class NutritionProfileController extends _$NutritionProfileController {
  @override
  Future<NutritionProfileState> build() async {
    final nutritionApi = ref.read(nutritionApiProvider);
    final authService = ref.read(authServiceProvider);
    
    final userId = await authService.getUserId();
    if (userId == null) {
      throw Exception('用户未登录');
    }
    
    final response = await nutritionApi.getNutritionProfile(userId);
    
    if (response.response.statusCode == 200) {
      final data = response.data;
      if (data['profiles'] != null && data['profiles'].isNotEmpty) {
        // 获取第一个或主档案
        final profileData = data['profiles'][0];
        final profile = NutritionProfile.fromJson(profileData);
        
        // 计算完成度
        final completionStats = _calculateCompletionStats(profile);
        
        return NutritionProfileState(
          profile: profile,
          completionStats: completionStats,
        );
      } else {
        return const NutritionProfileState();
      }
    } else {
      throw Exception('获取档案失败: ${response.response.statusMessage}');
    }
  }

  /// 创建档案
  Future<bool> createProfile(NutritionProfile profile) async {
    state = const AsyncValue.loading();
    
    try {
      final nutritionApi = ref.read(nutritionApiProvider);
      final authService = ref.read(authServiceProvider);
      
      final userId = await authService.getUserId();
      if (userId == null) {
        throw Exception('用户未登录');
      }
      
      final response = await nutritionApi.updateNutritionProfile(
        userId,
        profile.toJson(),
      );
      
      if (response.response.statusCode == 200 || response.response.statusCode == 201) {
        final profileData = response.data['profile'] ?? response.data;
        final newProfile = NutritionProfile.fromJson(profileData);
        
        // 计算完成度
        final completionStats = _calculateCompletionStats(newProfile);
        
        state = AsyncValue.data(NutritionProfileState(
          profile: newProfile,
          completionStats: completionStats,
        ));
        
        return true;
      } else {
        throw Exception('创建档案失败: ${response.response.statusMessage}');
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// 更新档案
  Future<bool> updateProfile(NutritionProfile profile) async {
    if (profile.id == null) return false;
    
    state = const AsyncValue.loading();
    
    try {
      final nutritionApi = ref.read(nutritionApiProvider);
      final authService = ref.read(authServiceProvider);
      
      final userId = await authService.getUserId();
      if (userId == null) {
        throw Exception('用户未登录');
      }
      
      final response = await nutritionApi.updateNutritionProfile(
        userId,
        profile.toJson(),
      );
      
      if (response.response.statusCode == 200) {
        final profileData = response.data['profile'] ?? response.data;
        final updatedProfile = NutritionProfile.fromJson(profileData);
        
        // 计算完成度
        final completionStats = _calculateCompletionStats(updatedProfile);
        
        state = AsyncValue.data(NutritionProfileState(
          profile: updatedProfile,
          completionStats: completionStats,
        ));
        
        return true;
      } else {
        throw Exception('更新档案失败: ${response.response.statusMessage}');
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// 刷新档案数据
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  /// 本地计算完成度
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
    
    const int totalFields = 11;
    final int completionPercentage = ((completedFields / totalFields) * 100).round();
    
    return CompletionStats(
      completionPercentage: completionPercentage,
      missingFields: missingFields,
    );
  }
}

/// 获取AI推荐数据的单独 Provider
@riverpod
Future<Map<String, dynamic>?> profileForAI(ProfileForAIRef ref) async {
  try {
    final nutritionApi = ref.read(nutritionApiProvider);
    final authService = ref.read(authServiceProvider);
    
    final userId = await authService.getUserId();
    if (userId == null) return null;
    
    final response = await nutritionApi.getNutritionProfile(userId);
    if (response.response.statusCode == 200) {
      return response.data;
    }
    return null;
  } catch (e) {
    return null;
  }
}

/// Providers - 依赖注入
@riverpod
NutritionApi nutritionApi(NutritionApiRef ref) {
  return ApiClient().getClient(NutritionApi);
}

@riverpod
AuthLocalDataSource authService(AuthServiceRef ref) {
  return AuthLocalDataSource();
}

/// 便捷访问器
@riverpod
NutritionProfile? currentProfile(CurrentProfileRef ref) {
  final state = ref.watch(nutritionProfileControllerProvider);
  return state.valueOrNull?.profile;
}

@riverpod
CompletionStats? profileCompletionStats(ProfileCompletionStatsRef ref) {
  final state = ref.watch(nutritionProfileControllerProvider);
  return state.valueOrNull?.completionStats;
}

@riverpod
bool isProfileComplete(IsProfileCompleteRef ref) {
  final stats = ref.watch(profileCompletionStatsProvider);
  return stats?.completionPercentage == 100;
}