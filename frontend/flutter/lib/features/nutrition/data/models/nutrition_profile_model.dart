import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/nutrition_profile.dart' as domain;

part 'nutrition_profile_model.g.dart';

@JsonSerializable()
class NutritionProfileModel {
  @JsonKey(name: '_id')
  final String? id;
  
  final String userId;
  final String profileName;
  final String gender;
  final String? ageGroup;
  final double? height;
  final double? weight;
  final double? bmi;
  final String? activityLevel;
  final List<String> nutritionGoals;
  final double? targetWeight;
  final double? dailyCalorieTarget;
  final double? hydrationGoal;
  final DietaryPreferencesModel? dietaryPreferences;
  final List<String>? medicalConditions;
  final List<String>? preferredMealTimes;
  final String? mealFrequency;
  final String? cookingTimeBudget;
  final String? region;
  final Map<String, dynamic>? lifestyle;
  final Map<String, dynamic>? nutritionStatus;
  final List<String>? relatedHealthRecords;
  final bool isPrimary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NutritionProfileModel({
    this.id,
    required this.userId,
    required this.profileName,
    required this.gender,
    this.ageGroup,
    this.height,
    this.weight,
    this.bmi,
    this.activityLevel,
    this.nutritionGoals = const [],
    this.targetWeight,
    this.dailyCalorieTarget,
    this.hydrationGoal,
    this.dietaryPreferences,
    this.medicalConditions,
    this.preferredMealTimes,
    this.mealFrequency,
    this.cookingTimeBudget,
    this.region,
    this.lifestyle,
    this.nutritionStatus,
    this.relatedHealthRecords,
    this.isPrimary = false,
    this.createdAt,
    this.updatedAt,
  });

  factory NutritionProfileModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionProfileModelToJson(this);

  /// 转换为Domain实体
  domain.NutritionProfile toEntity() {
    // 解析年龄（从ageGroup中提取）
    int age = 25; // 默认值
    if (ageGroup != null) {
      final ageMatch = RegExp(r'\d+').firstMatch(ageGroup!);
      if (ageMatch != null) {
        age = int.tryParse(ageMatch.group(0)!) ?? 25;
      }
    }

    // 转换性别
    domain.Gender genderEnum = domain.Gender.other;
    switch (gender.toLowerCase()) {
      case 'male':
      case '男':
        genderEnum = domain.Gender.male;
        break;
      case 'female':
      case '女':
        genderEnum = domain.Gender.female;
        break;
    }

    // 转换活动水平
    domain.ActivityLevel activityLevelEnum = domain.ActivityLevel.moderate;
    switch (activityLevel?.toLowerCase()) {
      case 'sedentary':
      case '久坐':
        activityLevelEnum = domain.ActivityLevel.sedentary;
        break;
      case 'light':
      case '轻度':
        activityLevelEnum = domain.ActivityLevel.light;
        break;
      case 'moderate':
      case '中度':
        activityLevelEnum = domain.ActivityLevel.moderate;
        break;
      case 'active':
      case '活跃':
        activityLevelEnum = domain.ActivityLevel.active;
        break;
      case 'very_active':
      case '非常活跃':
        activityLevelEnum = domain.ActivityLevel.veryActive;
        break;
    }

    // 转换饮食偏好
    final dietaryPreferencesList = <domain.DietaryPreference>[];
    if (dietaryPreferences != null) {
      // 转换过敏信息
      if (dietaryPreferences!.allergies != null) {
        dietaryPreferencesList.addAll(
          dietaryPreferences!.allergies!.map((allergy) => domain.DietaryPreference(
            id: allergy,
            name: allergy,
            description: '过敏：$allergy',
          )),
        );
      }
      // 转换禁忌
      if (dietaryPreferences!.taboos != null) {
        dietaryPreferencesList.addAll(
          dietaryPreferences!.taboos!.map((taboo) => domain.DietaryPreference(
            id: taboo,
            name: taboo,
            description: '禁忌：$taboo',
          )),
        );
      }
    }

    // 转换健康状况
    final healthConditionsList = <domain.HealthCondition>[];
    if (medicalConditions != null) {
      healthConditionsList.addAll(
        medicalConditions!.map((condition) => domain.HealthCondition(
          id: condition,
          name: condition,
          description: condition,
          severity: domain.ConditionSeverity.moderate,
        )),
      );
    }

    // 构建生活习惯
    final lifestyleHabits = domain.LifestyleHabits(
      sleepPattern: domain.SleepPattern.regular,
      exerciseFrequency: _getExerciseFrequency(activityLevelEnum),
      dailyWaterIntake: hydrationGoal?.toInt() ?? 2000,
      smokingStatus: false,
      alcoholConsumption: domain.AlcoholConsumption.never,
    );

    return domain.NutritionProfile(
      id: id ?? '',
      userId: userId,
      name: profileName,
      basicInfo: domain.BasicInfo(
        age: age,
        gender: genderEnum,
        height: height ?? 170,
        weight: weight ?? 60,
        targetWeight: targetWeight,
        activityLevel: activityLevelEnum,
      ),
      dietaryPreferences: dietaryPreferencesList,
      healthConditions: healthConditionsList,
      lifestyleHabits: lifestyleHabits,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// 从Domain实体创建Model
  factory NutritionProfileModel.fromEntity(domain.NutritionProfile entity) {
    // 转换性别
    String gender = 'other';
    switch (entity.basicInfo.gender) {
      case domain.Gender.male:
        gender = 'male';
        break;
      case domain.Gender.female:
        gender = 'female';
        break;
      case domain.Gender.other:
        gender = 'other';
        break;
    }

    // 转换活动水平
    String activityLevel = 'moderate';
    switch (entity.basicInfo.activityLevel) {
      case domain.ActivityLevel.sedentary:
        activityLevel = 'sedentary';
        break;
      case domain.ActivityLevel.light:
        activityLevel = 'light';
        break;
      case domain.ActivityLevel.moderate:
        activityLevel = 'moderate';
        break;
      case domain.ActivityLevel.active:
        activityLevel = 'active';
        break;
      case domain.ActivityLevel.veryActive:
        activityLevel = 'very_active';
        break;
    }

    // 提取过敏和禁忌
    final allergies = <String>[];
    final taboos = <String>[];
    for (final pref in entity.dietaryPreferences) {
      if (pref.description.contains('过敏')) {
        allergies.add(pref.name);
      } else if (pref.description.contains('禁忌')) {
        taboos.add(pref.name);
      }
    }

    // 提取健康状况
    final medicalConditions = entity.healthConditions
        .map((condition) => condition.name)
        .toList();

    return NutritionProfileModel(
      id: entity.id,
      userId: entity.userId,
      profileName: entity.name,
      gender: gender,
      ageGroup: '${entity.basicInfo.age}岁',
      height: entity.basicInfo.height,
      weight: entity.basicInfo.weight,
      bmi: entity.basicInfo.bmi,
      activityLevel: activityLevel,
      nutritionGoals: [],
      targetWeight: entity.basicInfo.targetWeight,
      dailyCalorieTarget: null,
      hydrationGoal: entity.lifestyleHabits.dailyWaterIntake.toDouble(),
      dietaryPreferences: DietaryPreferencesModel(
        allergies: allergies,
        taboos: taboos,
      ),
      medicalConditions: medicalConditions,
      isPrimary: true,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  domain.ExerciseFrequency _getExerciseFrequency(domain.ActivityLevel level) {
    switch (level) {
      case domain.ActivityLevel.sedentary:
        return domain.ExerciseFrequency.never;
      case domain.ActivityLevel.light:
        return domain.ExerciseFrequency.rarely;
      case domain.ActivityLevel.moderate:
        return domain.ExerciseFrequency.sometimes;
      case domain.ActivityLevel.active:
        return domain.ExerciseFrequency.often;
      case domain.ActivityLevel.veryActive:
        return domain.ExerciseFrequency.daily;
    }
  }

  // 保留原有的计算完成度方法
  int get completionPercentage {
    int completedFields = 0;
    int totalFields = 11;

    if (profileName.isNotEmpty) completedFields++;
    if (gender.isNotEmpty) completedFields++;
    if (height != null && height! > 0) completedFields++;
    if (weight != null && weight! > 0) completedFields++;
    if (activityLevel != null && activityLevel!.isNotEmpty) completedFields++;
    if (nutritionGoals.isNotEmpty) completedFields++;
    if (targetWeight != null && targetWeight! > 0) completedFields++;
    if (dietaryPreferences?.allergies?.isNotEmpty == true) completedFields++;
    if (medicalConditions?.isNotEmpty == true) completedFields++;
    if (dailyCalorieTarget != null && dailyCalorieTarget! > 0) completedFields++;
    if (hydrationGoal != null && hydrationGoal! > 0) completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }
}

@JsonSerializable()
class DietaryPreferencesModel {
  final List<String>? allergies;
  final List<String>? taboos;
  final List<String>? tastePreference;
  final List<String>? cuisineType;
  final List<String>? cookingMethod;

  DietaryPreferencesModel({
    this.allergies,
    this.taboos,
    this.tastePreference,
    this.cuisineType,
    this.cookingMethod,
  });

  factory DietaryPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$DietaryPreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$DietaryPreferencesModelToJson(this);
}