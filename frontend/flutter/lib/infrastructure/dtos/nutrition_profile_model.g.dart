// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietaryPreferences _$DietaryPreferencesFromJson(Map<String, dynamic> json) =>
    DietaryPreferences(
      isVegetarian: json['is_vegetarian'] as bool? ?? false,
      tastePreference: (json['taste_preference'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['light'],
      taboos: (json['taboos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      cuisine: json['cuisine'] as String? ?? 'chinese',
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$DietaryPreferencesToJson(DietaryPreferences instance) =>
    <String, dynamic>{
      'is_vegetarian': instance.isVegetarian,
      'taste_preference': instance.tastePreference,
      'taboos': instance.taboos,
      'cuisine': instance.cuisine,
      'allergies': instance.allergies,
    };

Lifestyle _$LifestyleFromJson(Map<String, dynamic> json) => Lifestyle(
      smoking: json['smoking'] as bool? ?? false,
      drinking: json['drinking'] as bool? ?? false,
      sleepDuration: (json['sleep_duration'] as num?)?.toInt() ?? 7,
      exerciseFrequency: json['exercise_frequency'] as String? ?? 'occasional',
    );

Map<String, dynamic> _$LifestyleToJson(Lifestyle instance) => <String, dynamic>{
      'smoking': instance.smoking,
      'drinking': instance.drinking,
      'sleep_duration': instance.sleepDuration,
      'exercise_frequency': instance.exerciseFrequency,
    };

Region _$RegionFromJson(Map<String, dynamic> json) => Region(
      province: json['province'] as String? ?? '',
      city: json['city'] as String? ?? '',
    );

Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      'province': instance.province,
      'city': instance.city,
    };

NutritionProfile _$NutritionProfileFromJson(Map<String, dynamic> json) =>
    NutritionProfile(
      id: json['_id'] as String?,
      userId: json['user_id'] as String,
      profileName: json['profile_name'] as String,
      gender: json['gender'] as String? ?? 'other',
      ageGroup: json['age_group'] as String? ?? '18to30',
      height: (json['height'] as num?)?.toDouble() ?? 170,
      weight: (json['weight'] as num?)?.toDouble() ?? 60,
      activityLevel: json['activity_level'] as String? ?? 'moderate',
      dailyCalorieTarget: (json['daily_calorie_target'] as num?)?.toDouble(),
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      hydrationGoal: (json['hydration_goal'] as num?)?.toDouble(),
      mealFrequency: (json['meal_frequency'] as num?)?.toInt() ?? 3,
      preferredMealTimes: (json['preferred_meal_times'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      medicalConditions: (json['medical_conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      cookingTimeBudget: (json['cooking_time_budget'] as num?)?.toInt(),
      region: Region.fromJson(json['region'] as Map<String, dynamic>),
      occupation: json['occupation'] as String? ?? 'other',
      dietaryPreferences: DietaryPreferences.fromJson(
          json['dietary_preferences'] as Map<String, dynamic>),
      lifestyle: Lifestyle.fromJson(json['lifestyle'] as Map<String, dynamic>),
      nutritionGoals: (json['nutrition_goals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['generalHealth'],
      isPrimary: json['is_primary'] as bool? ?? false,
      archived: json['archived'] as bool? ?? false,
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
  val['age_group'] = instance.ageGroup;
  val['height'] = instance.height;
  val['weight'] = instance.weight;
  val['activity_level'] = instance.activityLevel;
  writeNotNull('daily_calorie_target', instance.dailyCalorieTarget);
  writeNotNull('body_fat_percentage', instance.bodyFatPercentage);
  writeNotNull('hydration_goal', instance.hydrationGoal);
  val['meal_frequency'] = instance.mealFrequency;
  val['preferred_meal_times'] = instance.preferredMealTimes;
  val['medical_conditions'] = instance.medicalConditions;
  writeNotNull('target_weight', instance.targetWeight);
  writeNotNull('cooking_time_budget', instance.cookingTimeBudget);
  val['region'] = instance.region.toJson();
  val['occupation'] = instance.occupation;
  val['dietary_preferences'] = instance.dietaryPreferences.toJson();
  val['lifestyle'] = instance.lifestyle.toJson();
  val['nutrition_goals'] = instance.nutritionGoals;
  val['is_primary'] = instance.isPrimary;
  val['archived'] = instance.archived;
  writeNotNull('created_at', instance.createdAt?.toIso8601String());
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

NutritionProfileResponse _$NutritionProfileResponseFromJson(
        Map<String, dynamic> json) =>
    NutritionProfileResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      profile: json['profile'] == null
          ? null
          : NutritionProfile.fromJson(json['profile'] as Map<String, dynamic>),
      completionPercentage: (json['completion_percentage'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NutritionProfileResponseToJson(
    NutritionProfileResponse instance) {
  final val = <String, dynamic>{
    'success': instance.success,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  writeNotNull('profile', instance.profile?.toJson());
  writeNotNull('completion_percentage', instance.completionPercentage);
  return val;
}

CompletionStatsResponse _$CompletionStatsResponseFromJson(
        Map<String, dynamic> json) =>
    CompletionStatsResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : CompletionStats.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CompletionStatsResponseToJson(
    CompletionStatsResponse instance) {
  final val = <String, dynamic>{
    'success': instance.success,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  writeNotNull('data', instance.data?.toJson());
  return val;
}

CompletionStats _$CompletionStatsFromJson(Map<String, dynamic> json) =>
    CompletionStats(
      completionPercentage: (json['completion_percentage'] as num).toInt(),
      missingInfo: (json['missing_info'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      profileId: json['profile_id'] as String,
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$CompletionStatsToJson(CompletionStats instance) =>
    <String, dynamic>{
      'completion_percentage': instance.completionPercentage,
      'missing_info': instance.missingInfo,
      'profile_id': instance.profileId,
      'last_updated': instance.lastUpdated.toIso8601String(),
    };
