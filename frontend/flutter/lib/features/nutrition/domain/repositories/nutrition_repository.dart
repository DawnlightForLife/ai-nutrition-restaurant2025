import '../entities/nutrition_profile.dart';

/// 营养档案仓库接口
abstract class NutritionRepository {
  /// 获取用户的所有营养档案
  Future<List<NutritionProfile>> getNutritionProfiles(String userId);

  /// 根据ID获取营养档案
  Future<NutritionProfile?> getNutritionProfile(String profileId);

  /// 创建营养档案
  Future<NutritionProfile> createNutritionProfile(
    NutritionProfile profile,
  );

  /// 更新营养档案
  Future<NutritionProfile> updateNutritionProfile(
    NutritionProfile profile,
  );

  /// 删除营养档案
  Future<void> deleteNutritionProfile(String profileId);

  /// 设置默认档案
  Future<void> setDefaultProfile(String profileId);

  /// 获取用户的默认档案
  Future<NutritionProfile?> getDefaultProfile(String userId);

  /// 获取饮食偏好列表
  Future<List<DietaryPreference>> getAvailableDietaryPreferences();

  /// 获取健康状况列表
  Future<List<HealthCondition>> getAvailableHealthConditions();
}