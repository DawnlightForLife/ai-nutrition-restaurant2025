/**
 * 营养元素定制订餐实体类
 * 定义营养订餐系统的核心实体
 */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_ordering.freezed.dart';
part 'nutrition_ordering.g.dart';

/// 营养元素实体
@freezed
class NutritionElement with _$NutritionElement {
  const factory NutritionElement({
    required String id,
    required String name,
    required String chineseName,
    String? scientificName,
    @Default([]) List<String> aliases,
    required String category,
    String? subCategory,
    required String unit,
    @Default('beneficial') String importance,
    @Default([]) List<String> functions,
    @Default([]) List<String> healthBenefits,
    @Default([]) List<String> deficiencySymptoms,
    @Default([]) List<String> overdoseRisks,
    Map<String, dynamic>? recommendedIntake,
    Map<String, dynamic>? specialConditionNeeds,
    Map<String, dynamic>? absorption,
    @Default([]) List<Map<String, dynamic>> foodSources,
    Map<String, dynamic>? cookingEffects,
    Map<String, dynamic>? interactions,
    bool? isActive,
    DateTime? lastUpdated,
    @Default(1) int version,
  }) = _NutritionElement;

  factory NutritionElement.fromJson(Map<String, dynamic> json) =>
      _$NutritionElementFromJson(json);
}

/// 食材营养信息实体
@freezed
class IngredientNutrition with _$IngredientNutrition {
  const factory IngredientNutrition({
    required String id,
    required String name,
    required String chineseName,
    String? scientificName,
    @Default([]) List<String> commonNames,
    required String category,
    String? subCategory,
    required ServingSize servingSize,
    Map<String, String>? nutritionDensity,
    @Default([]) List<NutritionContent> nutritionContent,
    Map<String, dynamic>? macronutrients,
    Map<String, dynamic>? aminoAcidProfile,
    @Default([]) List<Map<String, dynamic>> fattyAcidProfile,
    @Default([]) List<Map<String, dynamic>> antinutrients,
    @Default([]) List<Map<String, dynamic>> bioactiveCompounds,
    Map<String, dynamic>? glycemicResponse,
    @Default('fresh') String freshnessLevel,
    Map<String, dynamic>? seasonalVariation,
    Map<String, dynamic>? storageConditions,
    Map<String, dynamic>? originInfo,
    Map<String, dynamic>? sustainabilityScore,
    Map<String, dynamic>? allergenInfo,
    bool? isActive,
  }) = _IngredientNutrition;

  factory IngredientNutrition.fromJson(Map<String, dynamic> json) =>
      _$IngredientNutritionFromJson(json);
}

/// 份量信息
@freezed
class ServingSize with _$ServingSize {
  const factory ServingSize({
    required double amount,
    required String unit,
    String? description,
  }) = _ServingSize;

  factory ServingSize.fromJson(Map<String, dynamic> json) =>
      _$ServingSizeFromJson(json);
}

/// 营养成分含量
@freezed
class NutritionContent with _$NutritionContent {
  const factory NutritionContent({
    required String element,
    required double amount,
    required String unit,
    double? dailyValuePercentage,
    @Default(100.0) double bioavailability,
    @Default(false) bool isEstimated,
    DateTime? lastTested,
    String? testMethod,
  }) = _NutritionContent;

  factory NutritionContent.fromJson(Map<String, dynamic> json) =>
      _$NutritionContentFromJson(json);
}

/// 烹饪方式实体
@freezed
class CookingMethod with _$CookingMethod {
  const factory CookingMethod({
    required String id,
    required String name,
    required String chineseName,
    String? description,
    @Default([]) List<String> aliases,
    required String category,
    required String method,
    Map<String, dynamic>? technicalParameters,
    @Default([]) List<NutritionImpact> nutritionImpacts,
    Map<String, dynamic>? overallNutritionRetention,
    @Default([]) List<Map<String, dynamic>> temperatureTimeCurves,
    @Default([]) List<Map<String, dynamic>> ingredientApplicability,
    @Default([]) List<Map<String, dynamic>> nutritionEnhancements,
    @Default([]) List<Map<String, dynamic>> harmfulCompounds,
    Map<String, dynamic>? digestibilityImpact,
    @Default([]) List<Map<String, dynamic>> antinutrientImpact,
    @Default([]) List<Map<String, dynamic>> bioactiveImpact,
    Map<String, dynamic>? equipmentRequirements,
    Map<String, dynamic>? skillRequirements,
    Map<String, dynamic>? efficiency,
    Map<String, dynamic>? researchSupport,
    bool? isActive,
  }) = _CookingMethod;

  factory CookingMethod.fromJson(Map<String, dynamic> json) =>
      _$CookingMethodFromJson(json);
}

/// 营养影响
@freezed
class NutritionImpact with _$NutritionImpact {
  const factory NutritionImpact({
    required String nutrient,
    required String impactType,
    double? retentionRate,
    Map<String, double>? variationRange,
    @Default([]) List<Map<String, dynamic>> influencingFactors,
    String? mechanism,
    @Default(false) bool timeDependent,
    @Default([]) List<Map<String, dynamic>> timeCurve,
  }) = _NutritionImpact;

  factory NutritionImpact.fromJson(Map<String, dynamic> json) =>
      _$NutritionImpactFromJson(json);
}

/// 营养需求分析结果
@freezed
class NutritionNeedsAnalysis with _$NutritionNeedsAnalysis {
  const factory NutritionNeedsAnalysis({
    required String userId,
    required String profileId,
    required double bmr,
    required double tdee,
    required Map<String, dynamic> dailyNeeds,
    DateTime? calculatedAt,
    DateTime? validUntil,
  }) = _NutritionNeedsAnalysis;

  factory NutritionNeedsAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NutritionNeedsAnalysisFromJson(json);
}

/// 订餐选择项
@freezed
class OrderingSelection with _$OrderingSelection {
  const factory OrderingSelection({
    required String ingredientId,
    required String ingredientName,
    required double amount,
    required String unit,
    String? cookingMethod,
    String? cookingMethodName,
    Map<String, dynamic>? nutritionCalculation,
    DateTime? selectedAt,
  }) = _OrderingSelection;

  factory OrderingSelection.fromJson(Map<String, dynamic> json) =>
      _$OrderingSelectionFromJson(json);
}

/// 营养平衡分析
@freezed
class NutritionBalanceAnalysis with _$NutritionBalanceAnalysis {
  const factory NutritionBalanceAnalysis({
    required double overallMatch,
    required Map<String, dynamic> macroMatch,
    required Map<String, dynamic> microMatch,
    @Default([]) List<NutritionGap> gaps,
    @Default([]) List<NutritionExcess> excesses,
    @Default([]) List<String> recommendations,
  }) = _NutritionBalanceAnalysis;

  factory NutritionBalanceAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NutritionBalanceAnalysisFromJson(json);
}

/// 营养缺口
@freezed
class NutritionGap with _$NutritionGap {
  const factory NutritionGap({
    required String element,
    required double currentAmount,
    required double targetAmount,
    required double gapAmount,
    required String unit,
    String? severity,
    @Default([]) List<String> recommendedSources,
  }) = _NutritionGap;

  factory NutritionGap.fromJson(Map<String, dynamic> json) =>
      _$NutritionGapFromJson(json);
}

/// 营养过量
@freezed
class NutritionExcess with _$NutritionExcess {
  const factory NutritionExcess({
    required String element,
    required double currentAmount,
    required double targetAmount,
    required double excessAmount,
    required String unit,
    String? riskLevel,
    @Default([]) List<String> reductionSuggestions,
  }) = _NutritionExcess;

  factory NutritionExcess.fromJson(Map<String, dynamic> json) =>
      _$NutritionExcessFromJson(json);
}

/// 食材推荐
@freezed
class IngredientRecommendation with _$IngredientRecommendation {
  const factory IngredientRecommendation({
    required String nutrient,
    required double gap,
    required String unit,
    @Default([]) List<RecommendedIngredient> recommendedIngredients,
  }) = _IngredientRecommendation;

  factory IngredientRecommendation.fromJson(Map<String, dynamic> json) =>
      _$IngredientRecommendationFromJson(json);
}

/// 推荐食材
@freezed
class RecommendedIngredient with _$RecommendedIngredient {
  const factory RecommendedIngredient({
    required String id,
    required String name,
    required String category,
    required double nutrientContent,
    required String nutritionDensity,
    required ServingSize servingSize,
    required double estimatedServing,
  }) = _RecommendedIngredient;

  factory RecommendedIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecommendedIngredientFromJson(json);
}

/// 营养评分
@freezed
class NutritionScore with _$NutritionScore {
  const factory NutritionScore({
    required double overall,
    required double balance,
    required double adequacy,
    required double moderation,
    required double variety,
    required Map<String, dynamic> details,
  }) = _NutritionScore;

  factory NutritionScore.fromJson(Map<String, dynamic> json) =>
      _$NutritionScoreFromJson(json);
}