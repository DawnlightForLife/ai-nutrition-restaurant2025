import 'package:json_annotation/json_annotation.dart';

part 'nutrition_profile_model.g.dart';

@JsonSerializable()
class DietaryPreferences {
  final bool isVegetarian;
  final List<String> tastePreference;
  final List<String> taboos;
  final String cuisine;
  final List<String> allergies;

  DietaryPreferences({
    this.isVegetarian = false,
    this.tastePreference = const ['light'],
    this.taboos = const [],
    this.cuisine = 'chinese',
    this.allergies = const [],
  });

  factory DietaryPreferences.fromJson(Map<String, dynamic> json) =>
      _$DietaryPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$DietaryPreferencesToJson(this);
}

@JsonSerializable()
class Lifestyle {
  final bool smoking;
  final bool drinking;
  final int sleepDuration;
  final String exerciseFrequency;

  Lifestyle({
    this.smoking = false,
    this.drinking = false,
    this.sleepDuration = 7,
    this.exerciseFrequency = 'occasional',
  });

  factory Lifestyle.fromJson(Map<String, dynamic> json) =>
      _$LifestyleFromJson(json);
  Map<String, dynamic> toJson() => _$LifestyleToJson(this);
}

@JsonSerializable()
class Region {
  final String province;
  final String city;

  Region({
    this.province = '',
    this.city = '',
  });

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  Map<String, dynamic> toJson() => _$RegionToJson(this);
}

@JsonSerializable()
class NutritionProfile {
  @JsonKey(name: '_id')
  final String? id;
  
  final String userId;
  final String profileName;
  final String gender;
  final String ageGroup;
  final double height;
  final double weight;
  final String activityLevel;
  final double? dailyCalorieTarget;
  final double? bodyFatPercentage;
  final double? hydrationGoal;
  final int mealFrequency;
  final List<String> preferredMealTimes;
  final List<String> medicalConditions;
  final double? targetWeight;
  final int? cookingTimeBudget;
  final Region region;
  final String occupation;
  final DietaryPreferences dietaryPreferences;
  final Lifestyle lifestyle;
  final List<String> nutritionGoals;
  final bool isPrimary;
  final bool archived;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // BMI虚拟字段
  double? get bmi {
    if (height <= 0 || weight <= 0) return null;
    final heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  NutritionProfile({
    this.id,
    required this.userId,
    required this.profileName,
    this.gender = 'other',
    this.ageGroup = '18to30',
    this.height = 170,
    this.weight = 60,
    this.activityLevel = 'moderate',
    this.dailyCalorieTarget,
    this.bodyFatPercentage,
    this.hydrationGoal,
    this.mealFrequency = 3,
    this.preferredMealTimes = const [],
    this.medicalConditions = const [],
    this.targetWeight,
    this.cookingTimeBudget,
    required this.region,
    this.occupation = 'other',
    required this.dietaryPreferences,
    required this.lifestyle,
    this.nutritionGoals = const ['generalHealth'],
    this.isPrimary = false,
    this.archived = false,
    this.createdAt,
    this.updatedAt,
  });

  factory NutritionProfile.fromJson(Map<String, dynamic> json) =>
      _$NutritionProfileFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionProfileToJson(this);

  // 创建默认档案
  factory NutritionProfile.createDefault(String userId) {
    return NutritionProfile(
      userId: userId,
      profileName: '我的营养档案',
      region: Region(),
      dietaryPreferences: DietaryPreferences(),
      lifestyle: Lifestyle(),
      isPrimary: true,
    );
  }

  // 复制并修改
  NutritionProfile copyWith({
    String? id,
    String? userId,
    String? profileName,
    String? gender,
    String? ageGroup,
    double? height,
    double? weight,
    String? activityLevel,
    double? dailyCalorieTarget,
    double? bodyFatPercentage,
    double? hydrationGoal,
    int? mealFrequency,
    List<String>? preferredMealTimes,
    List<String>? medicalConditions,
    double? targetWeight,
    int? cookingTimeBudget,
    Region? region,
    String? occupation,
    DietaryPreferences? dietaryPreferences,
    Lifestyle? lifestyle,
    List<String>? nutritionGoals,
    bool? isPrimary,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NutritionProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileName: profileName ?? this.profileName,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      hydrationGoal: hydrationGoal ?? this.hydrationGoal,
      mealFrequency: mealFrequency ?? this.mealFrequency,
      preferredMealTimes: preferredMealTimes ?? this.preferredMealTimes,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      targetWeight: targetWeight ?? this.targetWeight,
      cookingTimeBudget: cookingTimeBudget ?? this.cookingTimeBudget,
      region: region ?? this.region,
      occupation: occupation ?? this.occupation,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      lifestyle: lifestyle ?? this.lifestyle,
      nutritionGoals: nutritionGoals ?? this.nutritionGoals,
      isPrimary: isPrimary ?? this.isPrimary,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class NutritionProfileResponse {
  final bool success;
  final String? message;
  final NutritionProfile? profile;
  final int? completionPercentage;

  NutritionProfileResponse({
    required this.success,
    this.message,
    this.profile,
    this.completionPercentage,
  });

  factory NutritionProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$NutritionProfileResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NutritionProfileResponseToJson(this);
}

@JsonSerializable()
class CompletionStatsResponse {
  final bool success;
  final String? message;
  final CompletionStats? data;

  CompletionStatsResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory CompletionStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$CompletionStatsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CompletionStatsResponseToJson(this);
}

@JsonSerializable()
class CompletionStats {
  final int completionPercentage;
  final List<String> missingInfo;
  final String profileId;
  final DateTime lastUpdated;

  CompletionStats({
    required this.completionPercentage,
    required this.missingInfo,
    required this.profileId,
    required this.lastUpdated,
  });

  factory CompletionStats.fromJson(Map<String, dynamic> json) =>
      _$CompletionStatsFromJson(json);
  Map<String, dynamic> toJson() => _$CompletionStatsToJson(this);
}