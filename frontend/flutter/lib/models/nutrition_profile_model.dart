import 'package:json_annotation/json_annotation.dart';

part 'nutrition_profile_model.g.dart';

@JsonSerializable()
class NutritionProfile {
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
  final DietaryPreferences? dietaryPreferences;
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

  NutritionProfile({
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

  factory NutritionProfile.fromJson(Map<String, dynamic> json) =>
      _$NutritionProfileFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionProfileToJson(this);

  // 计算完成度
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

  NutritionProfile copyWith({
    String? id,
    String? userId,
    String? profileName,
    String? gender,
    String? ageGroup,
    double? height,
    double? weight,
    double? bmi,
    String? activityLevel,
    List<String>? nutritionGoals,
    double? targetWeight,
    double? dailyCalorieTarget,
    double? hydrationGoal,
    DietaryPreferences? dietaryPreferences,
    List<String>? medicalConditions,
    List<String>? preferredMealTimes,
    String? mealFrequency,
    String? cookingTimeBudget,
    String? region,
    Map<String, dynamic>? lifestyle,
    Map<String, dynamic>? nutritionStatus,
    List<String>? relatedHealthRecords,
    bool? isPrimary,
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
      bmi: bmi ?? this.bmi,
      activityLevel: activityLevel ?? this.activityLevel,
      nutritionGoals: nutritionGoals ?? this.nutritionGoals,
      targetWeight: targetWeight ?? this.targetWeight,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      hydrationGoal: hydrationGoal ?? this.hydrationGoal,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      preferredMealTimes: preferredMealTimes ?? this.preferredMealTimes,
      mealFrequency: mealFrequency ?? this.mealFrequency,
      cookingTimeBudget: cookingTimeBudget ?? this.cookingTimeBudget,
      region: region ?? this.region,
      lifestyle: lifestyle ?? this.lifestyle,
      nutritionStatus: nutritionStatus ?? this.nutritionStatus,
      relatedHealthRecords: relatedHealthRecords ?? this.relatedHealthRecords,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class DietaryPreferences {
  final List<String>? allergies;
  final List<String>? taboos;
  final List<String>? tastePreference;
  final List<String>? cuisineType;
  final List<String>? cookingMethod;

  DietaryPreferences({
    this.allergies,
    this.taboos,
    this.tastePreference,
    this.cuisineType,
    this.cookingMethod,
  });

  factory DietaryPreferences.fromJson(Map<String, dynamic> json) =>
      _$DietaryPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$DietaryPreferencesToJson(this);
}