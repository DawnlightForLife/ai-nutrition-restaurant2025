// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutritionProfile _$NutritionProfileFromJson(Map<String, dynamic> json) =>
    NutritionProfile(
      id: json['_id'] as String?,
      userId: json['user_id'] as String,
      profileName: json['profile_name'] as String,
      gender: json['gender'] as String,
      ageGroup: json['age_group'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      bmi: (json['bmi'] as num?)?.toDouble(),
      activityLevel: json['activity_level'] as String?,
      nutritionGoals: (json['nutrition_goals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      dailyCalorieTarget: (json['daily_calorie_target'] as num?)?.toDouble(),
      hydrationGoal: (json['hydration_goal'] as num?)?.toDouble(),
      dietaryPreferences: json['dietary_preferences'] == null
          ? null
          : DietaryPreferences.fromJson(
              json['dietary_preferences'] as Map<String, dynamic>),
      medicalConditions: (json['medical_conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preferredMealTimes: (json['preferred_meal_times'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mealFrequency: json['meal_frequency'] as String?,
      cookingTimeBudget: json['cooking_time_budget'] as String?,
      region: json['region'] as String?,
      lifestyle: json['lifestyle'] as Map<String, dynamic>?,
      nutritionStatus: json['nutrition_status'] as Map<String, dynamic>?,
      relatedHealthRecords: (json['related_health_records'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isPrimary: json['is_primary'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$NutritionProfileToJson(NutritionProfile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', instance.id);
  val['user_id'] = instance.userId;
  val['profile_name'] = instance.profileName;
  val['gender'] = instance.gender;
  writeNotNull('age_group', instance.ageGroup);
  writeNotNull('height', instance.height);
  writeNotNull('weight', instance.weight);
  writeNotNull('bmi', instance.bmi);
  writeNotNull('activity_level', instance.activityLevel);
  val['nutrition_goals'] = instance.nutritionGoals;
  writeNotNull('target_weight', instance.targetWeight);
  writeNotNull('daily_calorie_target', instance.dailyCalorieTarget);
  writeNotNull('hydration_goal', instance.hydrationGoal);
  writeNotNull('dietary_preferences', instance.dietaryPreferences?.toJson());
  writeNotNull('medical_conditions', instance.medicalConditions);
  writeNotNull('preferred_meal_times', instance.preferredMealTimes);
  writeNotNull('meal_frequency', instance.mealFrequency);
  writeNotNull('cooking_time_budget', instance.cookingTimeBudget);
  writeNotNull('region', instance.region);
  writeNotNull('lifestyle', instance.lifestyle);
  writeNotNull('nutrition_status', instance.nutritionStatus);
  writeNotNull('related_health_records', instance.relatedHealthRecords);
  val['is_primary'] = instance.isPrimary;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

DietaryPreferences _$DietaryPreferencesFromJson(Map<String, dynamic> json) =>
    DietaryPreferences(
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      taboos:
          (json['taboos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      tastePreference: (json['taste_preference'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cuisineType: (json['cuisine_type'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cookingMethod: (json['cooking_method'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DietaryPreferencesToJson(DietaryPreferences instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('allergies', instance.allergies);
  writeNotNull('taboos', instance.taboos);
  writeNotNull('taste_preference', instance.tastePreference);
  writeNotNull('cuisine_type', instance.cuisineType);
  writeNotNull('cooking_method', instance.cookingMethod);
  return val;
}
