import 'package:freezed_annotation/freezed_annotation.dart';
import 'nutrition_profile_model.dart';

part 'nutrition_template_model.freezed.dart';
part 'nutrition_template_model.g.dart';

/// 营养档案模板模型
@freezed
class NutritionTemplateModel with _$NutritionTemplateModel {
  const factory NutritionTemplateModel({
    required String key,
    required String name,
    required NutritionProfileModel data,
    String? description,
    @JsonKey(name: 'icon_name') String? iconName,
    @JsonKey(name: 'recommended_for') List<String>? recommendedFor,
  }) = _NutritionTemplateModel;

  factory NutritionTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionTemplateModelFromJson(json);
}

/// 健康目标验证结果模型
@freezed
class HealthGoalValidationResult with _$HealthGoalValidationResult {
  const factory HealthGoalValidationResult({
    required bool success,
    required String message,
    String? field,
  }) = _HealthGoalValidationResult;

  factory HealthGoalValidationResult.fromJson(Map<String, dynamic> json) =>
      _$HealthGoalValidationResultFromJson(json);
}

/// 冲突检测结果模型
@freezed
class ConflictDetectionResult with _$ConflictDetectionResult {
  const factory ConflictDetectionResult({
    required bool success,
    @JsonKey(name: 'has_conflicts') required bool hasConflicts,
    required List<ProfileConflict> conflicts,
  }) = _ConflictDetectionResult;

  factory ConflictDetectionResult.fromJson(Map<String, dynamic> json) =>
      _$ConflictDetectionResultFromJson(json);
}

/// 档案冲突模型
@freezed
class ProfileConflict with _$ProfileConflict {
  const factory ProfileConflict({
    required String type,
    required String message,
    String? field,
    ConflictSeverity? severity,
    List<String>? suggestions,
  }) = _ProfileConflict;

  factory ProfileConflict.fromJson(Map<String, dynamic> json) =>
      _$ProfileConflictFromJson(json);
}

/// 冲突严重程度枚举
enum ConflictSeverity {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
}

/// 营养建议模型
@freezed
class NutritionSuggestions with _$NutritionSuggestions {
  const factory NutritionSuggestions({
    required bool success,
    required SuggestionsData suggestions,
  }) = _NutritionSuggestions;

  factory NutritionSuggestions.fromJson(Map<String, dynamic> json) =>
      _$NutritionSuggestionsFromJson(json);
}

/// 建议数据模型
@freezed
class SuggestionsData with _$SuggestionsData {
  const factory SuggestionsData({
    @JsonKey(name: 'dietary_type') List<String>? dietaryType,
    @JsonKey(name: 'taste_preferences') Map<String, int>? tastePreferences,
    @JsonKey(name: 'daily_calorie_target') int? dailyCalorieTarget,
    @JsonKey(name: 'macro_ratios') MacroRatios? macroRatios,
    @JsonKey(name: 'hydration_goal') int? hydrationGoal,
    @JsonKey(name: 'meal_frequency') int? mealFrequency,
    @JsonKey(name: 'exercise_types') List<String>? exerciseTypes,
    @JsonKey(name: 'supplement_recommendations') List<String>? supplementRecommendations,
  }) = _SuggestionsData;

  factory SuggestionsData.fromJson(Map<String, dynamic> json) =>
      _$SuggestionsDataFromJson(json);
}

/// 宏量营养素比例模型
@freezed
class MacroRatios with _$MacroRatios {
  const factory MacroRatios({
    required double protein,
    required double fat,
    required double carbs,
  }) = _MacroRatios;

  factory MacroRatios.fromJson(Map<String, dynamic> json) =>
      _$MacroRatiosFromJson(json);
}