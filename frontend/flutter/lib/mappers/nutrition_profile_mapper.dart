import '../domain/nutrition/entities/nutrition_profile_v2.dart';
import '../domain/user/value_objects/user_id.dart';
import '../models/nutrition_profile_model.dart';

class NutritionProfileMapper {
  // 将API模型转换为领域实体
  static NutritionProfileV2 toDomain(NutritionProfile model) {
    // 将营养目标映射到健康目标
    String healthGoal = 'balancedNutrition'; // 默认值
    if (model.nutritionGoals.contains('loseWeight')) {
      healthGoal = 'loseWeight';
    } else if (model.nutritionGoals.contains('gainMuscle')) {
      healthGoal = 'gainMuscle';
    } else if (model.nutritionGoals.contains('improveHealth')) {
      healthGoal = 'improveHealth';
    }

    // 将活动水平映射
    String? exerciseFrequency;
    if (model.activityLevel == 'sedentary') {
      exerciseFrequency = 'rarely';
    } else if (model.activityLevel == 'light') {
      exerciseFrequency = 'moderate';
    } else if (model.activityLevel == 'moderate') {
      exerciseFrequency = 'active';
    } else if (model.activityLevel == 'active' || model.activityLevel == 'veryActive') {
      exerciseFrequency = 'veryActive';
    }

    // 合并饮食偏好
    final dietaryPreferences = <String>{};
    if (model.dietaryPreferences != null) {
      if (model.dietaryPreferences!.tastePreference?.contains('light') == true) {
        dietaryPreferences.add('light');
      }
      if (model.dietaryPreferences!.tastePreference?.contains('spicy') == true) {
        dietaryPreferences.add('spicy');
      }
      if (model.dietaryPreferences!.cuisineType?.contains('organic') == true) {
        dietaryPreferences.add('organic');
      }
      if (model.dietaryPreferences!.cuisineType?.contains('vegetarian') == true) {
        dietaryPreferences.add('vegetarian');
      }
    }

    return NutritionProfileV2(
      id: model.id,
      userId: UserId(model.userId),
      gender: model.gender,
      ageGroup: model.ageGroup ?? '18to30',
      height: model.height ?? 0,
      weight: model.weight ?? 0,
      healthGoal: healthGoal,
      targetCalories: model.dailyCalorieTarget?.toInt() ?? 2000,
      dietaryPreferences: dietaryPreferences.toList(),
      medicalConditions: model.medicalConditions ?? [],
      exerciseFrequency: exerciseFrequency,
      nutritionPreferences: model.nutritionGoals,
      specialStatus: [],
      forbiddenIngredients: model.dietaryPreferences?.taboos ?? [],
      allergies: model.dietaryPreferences?.allergies ?? [],
      profileName: model.profileName,
      isPrimary: model.isPrimary,
      createdAt: model.createdAt ?? DateTime.now(),
      updatedAt: model.updatedAt ?? DateTime.now(),
    );
  }

  // 将领域实体转换为API模型
  static NutritionProfile toModel(NutritionProfileV2 domain) {
    // 将健康目标映射到营养目标
    final nutritionGoals = <String>[];
    switch (domain.healthGoal) {
      case 'loseWeight':
        nutritionGoals.add('loseWeight');
        break;
      case 'gainMuscle':
        nutritionGoals.add('gainMuscle');
        break;
      case 'improveHealth':
        nutritionGoals.add('improveHealth');
        break;
      default:
        nutritionGoals.add('balancedNutrition');
    }

    // 将运动频率映射到活动水平
    String activityLevel = 'moderate'; // 默认值
    switch (domain.exerciseFrequency) {
      case 'rarely':
        activityLevel = 'sedentary';
        break;
      case 'moderate':
        activityLevel = 'light';
        break;
      case 'active':
        activityLevel = 'moderate';
        break;
      case 'veryActive':
        activityLevel = 'active';
        break;
    }

    // 构建饮食偏好
    final tastePreferences = <String>[];
    final cuisineTypes = <String>[];
    
    for (final pref in domain.dietaryPreferences) {
      switch (pref) {
        case 'light':
          tastePreferences.add('light');
          break;
        case 'spicy':
          tastePreferences.add('spicy');
          break;
        case 'organic':
          cuisineTypes.add('organic');
          break;
        case 'vegetarian':
          cuisineTypes.add('vegetarian');
          break;
      }
    }

    return NutritionProfile(
      id: domain.id,
      userId: domain.userId.value,
      profileName: domain.profileName,
      gender: domain.gender,
      ageGroup: domain.ageGroup,
      height: domain.height.toDouble(),
      weight: domain.weight.toDouble(),
      activityLevel: activityLevel,
      nutritionGoals: nutritionGoals,
      targetWeight: domain.weight.toDouble(), // 使用当前体重作为目标体重
      dailyCalorieTarget: domain.targetCalories.toDouble(),
      hydrationGoal: 2000, // 默认饮水目标
      dietaryPreferences: DietaryPreferences(
        allergies: domain.allergies,
        taboos: domain.forbiddenIngredients,
        tastePreference: tastePreferences,
        cuisineType: cuisineTypes,
      ),
      medicalConditions: domain.medicalConditions,
      isPrimary: domain.isPrimary,
      createdAt: domain.createdAt,
      updatedAt: domain.updatedAt,
    );
  }
}