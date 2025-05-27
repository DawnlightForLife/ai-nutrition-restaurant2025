import '../../domain/nutrition/entities/nutrition_profile_v2.dart';
import '../../infrastructure/dtos/nutrition_profile_model.dart';
import 'base_mapper.dart';

/// 营养档案映射器
/// 负责领域模型和DTO之间的转换
class NutritionProfileMapper implements BaseMapper<NutritionProfileV2, NutritionProfile> {
  const NutritionProfileMapper();
  
  /// 将JSON数据转换为DTO模型
  static NutritionProfile fromJson(Map<String, dynamic> json) {
    try {
      return NutritionProfile.fromJson(json);
    } catch (e) {
      print('营养档案JSON转换错误: $e');
      // 返回空对象而不是抛出异常，以增强健壮性
      return NutritionProfile(
        id: json['id'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        profileName: '默认档案',
        gender: '',
        ageGroup: '',
        height: 0,
        weight: 0,
        activityLevel: '',
        dailyCalorieTarget: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
  
  /// 将DTO模型转换为JSON数据
  static Map<String, dynamic> toJson(NutritionProfileV2 profile) {
    final Map<String, dynamic> json = {};
    
    // 基本信息
    if (profile.id != null) {
      json['id'] = profile.id.toString();
    }
    json['userId'] = profile.userId.toString();
    json['profileName'] = profile.profileName ?? '默认档案';
    
    // 身体信息
    json['gender'] = profile.gender ?? '';
    json['height'] = profile.height ?? 0.0;
    json['weight'] = profile.weight ?? 0.0;
    
    // 活动水平和目标
    json['activityLevel'] = profile.activityLevel ?? '';
    json['dailyCalorieTarget'] = profile.dailyCalorieTarget ?? 0;
    
    // 其他可选字段
    if (profile.targetWeight != null) {
      json['targetWeight'] = profile.targetWeight;
    }
    
    // 饮食偏好
    if (profile.dietaryPreferences != null && profile.dietaryPreferences!.isNotEmpty) {
      json['dietaryPreferences'] = profile.dietaryPreferences;
    }
    
    // 医疗条件
    if (profile.medicalConditions != null && profile.medicalConditions!.isNotEmpty) {
      json['medicalConditions'] = profile.medicalConditions;
    }
    
    return json;
  }
  
  @override
  NutritionProfile toDto(NutritionProfileV2 domain) {
    return NutritionProfile(
      id: domain.id?.toString() ?? '',
      userId: domain.userId.toString(),
      profileName: domain.profileName ?? '默认档案',
      gender: domain.gender ?? '',
      ageGroup: domain.ageGroup ?? '',
      height: domain.height?.toDouble() ?? 0.0,
      weight: domain.weight?.toDouble() ?? 0.0,
      activityLevel: domain.activityLevel ?? '',
      dailyCalorieTarget: domain.dailyCalorieTarget?.toInt() ?? 2000,
      targetWeight: domain.targetWeight?.toDouble(),
      bodyFatPercentage: domain.bodyFatPercentage?.toDouble(),
      hydrationGoal: domain.hydrationGoal?.toInt(),
      medicalConditions: domain.medicalConditions?.toList() ?? [],
      dietaryPreferences: domain.dietaryPreferences ?? {},
      nutritionGoals: domain.nutritionGoals ?? {},
      isPrimary: domain.isPrimary ?? false,
      createdAt: domain.createdAt ?? DateTime.now(),
      updatedAt: domain.updatedAt ?? DateTime.now(),
    );
  }
  
  @override
  NutritionProfileV2 toDomain(NutritionProfile dto) {
    try {
      return NutritionProfileV2(
        id: dto.id.isNotEmpty ? dto.id : null,
        userId: dto.userId,
        profileName: dto.profileName,
        gender: dto.gender,
        ageGroup: dto.ageGroup,
        height: dto.height,
        weight: dto.weight,
        activityLevel: dto.activityLevel,
        dailyCalorieTarget: dto.dailyCalorieTarget,
        targetWeight: dto.targetWeight,
        bodyFatPercentage: dto.bodyFatPercentage,
        hydrationGoal: dto.hydrationGoal,
        medicalConditions: dto.medicalConditions,
        dietaryPreferences: dto.dietaryPreferences,
        nutritionGoals: dto.nutritionGoals,
        isPrimary: dto.isPrimary,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );
    } catch (e) {
      print('营养档案DTO转领域模型错误: $e');
      // 返回最小有效的领域模型
      return NutritionProfileV2(
        userId: dto.userId,
        profileName: '默认档案',
        gender: '',
        height: 0,
        weight: 0,
        activityLevel: '',
        dailyCalorieTarget: 2000,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
} 