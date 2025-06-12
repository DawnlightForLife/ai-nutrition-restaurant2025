// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutritionProfileModel _$NutritionProfileModelFromJson(
        Map<String, dynamic> json) =>
    NutritionProfileModel(
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
          : DietaryPreferencesModel.fromJson(
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

Map<String, dynamic> _$NutritionProfileModelToJson(
        NutritionProfileModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      'user_id': instance.userId,
      'profile_name': instance.profileName,
      'gender': instance.gender,
      if (instance.ageGroup case final value?) 'age_group': value,
      if (instance.height case final value?) 'height': value,
      if (instance.weight case final value?) 'weight': value,
      if (instance.bmi case final value?) 'bmi': value,
      if (instance.activityLevel case final value?) 'activity_level': value,
      'nutrition_goals': instance.nutritionGoals,
      if (instance.targetWeight case final value?) 'target_weight': value,
      if (instance.dailyCalorieTarget case final value?)
        'daily_calorie_target': value,
      if (instance.hydrationGoal case final value?) 'hydration_goal': value,
      if (instance.dietaryPreferences?.toJson() case final value?)
        'dietary_preferences': value,
      if (instance.medicalConditions case final value?)
        'medical_conditions': value,
      if (instance.preferredMealTimes case final value?)
        'preferred_meal_times': value,
      if (instance.mealFrequency case final value?) 'meal_frequency': value,
      if (instance.cookingTimeBudget case final value?)
        'cooking_time_budget': value,
      if (instance.region case final value?) 'region': value,
      if (instance.lifestyle case final value?) 'lifestyle': value,
      if (instance.nutritionStatus case final value?) 'nutrition_status': value,
      if (instance.relatedHealthRecords case final value?)
        'related_health_records': value,
      'is_primary': instance.isPrimary,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

DietaryPreferencesModel _$DietaryPreferencesModelFromJson(
        Map<String, dynamic> json) =>
    DietaryPreferencesModel(
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

Map<String, dynamic> _$DietaryPreferencesModelToJson(
        DietaryPreferencesModel instance) =>
    <String, dynamic>{
      if (instance.allergies case final value?) 'allergies': value,
      if (instance.taboos case final value?) 'taboos': value,
      if (instance.tastePreference case final value?) 'taste_preference': value,
      if (instance.cuisineType case final value?) 'cuisine_type': value,
      if (instance.cookingMethod case final value?) 'cooking_method': value,
    };
