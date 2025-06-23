import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutrition_plan_entity.dart';

part 'nutrition_plan_model.freezed.dart';
part 'nutrition_plan_model.g.dart';

@freezed
class NutritionPlanModel with _$NutritionPlanModel {
  const factory NutritionPlanModel({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required String nutritionistId,
    String? consultationId,
    required String title,
    required String description,
    required PlanStatus status,
    required DateTime startDate,
    required DateTime endDate,
    required NutritionGoalsModel goals,
    required List<DailyPlanModel> dailyPlans,
    required List<FoodRecommendationModel> recommendedFoods,
    required List<FoodRestrictionModel> restrictedFoods,
    required MealTimingModel mealTiming,
    @Default({}) Map<String, dynamic> nutritionTargets,
    @Default([]) List<String> healthConditions,
    @Default([]) List<String> allergies,
    @Default([]) List<String> preferences,
    @Default({}) Map<String, dynamic> progressTracking,
    @Default([]) List<String> notes,
    @Default([]) List<String> attachments,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NutritionPlanModel;

  factory NutritionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionPlanModelFromJson(json);
}

@freezed
class NutritionGoalsModel with _$NutritionGoalsModel {
  const factory NutritionGoalsModel({
    required GoalType primaryGoal,
    @Default([]) List<GoalType> secondaryGoals,
    double? targetWeight,
    double? targetBodyFat,
    int? targetCalories,
    @Default({}) Map<String, double> macroTargets,
    @Default({}) Map<String, double> microTargets,
    String? specificTarget,
  }) = _NutritionGoalsModel;

  factory NutritionGoalsModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionGoalsModelFromJson(json);
}

@freezed
class DailyPlanModel with _$DailyPlanModel {
  const factory DailyPlanModel({
    required int dayNumber,
    required DateTime date,
    required List<MealPlanModel> meals,
    required int totalCalories,
    required Map<String, double> totalMacros,
    @Default([]) List<String> notes,
    @Default(false) bool isCompleted,
    @Default({}) Map<String, dynamic> actualIntake,
  }) = _DailyPlanModel;

  factory DailyPlanModel.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanModelFromJson(json);
}

@freezed
class MealPlanModel with _$MealPlanModel {
  const factory MealPlanModel({
    required MealType mealType,
    required String time,
    required List<FoodItemModel> foods,
    required int calories,
    required Map<String, double> macros,
    @Default([]) List<String> cookingInstructions,
    @Default([]) List<String> notes,
  }) = _MealPlanModel;

  factory MealPlanModel.fromJson(Map<String, dynamic> json) =>
      _$MealPlanModelFromJson(json);
}

@freezed
class FoodItemModel with _$FoodItemModel {
  const factory FoodItemModel({
    required String name,
    required double quantity,
    required String unit,
    required int calories,
    required Map<String, double> nutrition,
    @Default('') String preparation,
    @Default([]) List<String> alternatives,
  }) = _FoodItemModel;

  factory FoodItemModel.fromJson(Map<String, dynamic> json) =>
      _$FoodItemModelFromJson(json);
}

@freezed
class FoodRecommendationModel with _$FoodRecommendationModel {
  const factory FoodRecommendationModel({
    required String foodName,
    required String reason,
    required RecommendationFrequency frequency,
    @Default('') String servingSize,
    @Default([]) List<String> benefits,
  }) = _FoodRecommendationModel;

  factory FoodRecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$FoodRecommendationModelFromJson(json);
}

@freezed
class FoodRestrictionModel with _$FoodRestrictionModel {
  const factory FoodRestrictionModel({
    required String foodName,
    required String reason,
    required RestrictionLevel level,
    @Default([]) List<String> alternatives,
  }) = _FoodRestrictionModel;

  factory FoodRestrictionModel.fromJson(Map<String, dynamic> json) =>
      _$FoodRestrictionModelFromJson(json);
}

@freezed
class MealTimingModel with _$MealTimingModel {
  const factory MealTimingModel({
    required String breakfast,
    required String lunch,
    required String dinner,
    @Default([]) List<String> snacks,
    @Default('') String notes,
  }) = _MealTimingModel;

  factory MealTimingModel.fromJson(Map<String, dynamic> json) =>
      _$MealTimingModelFromJson(json);
}

// Extension methods to convert between models and entities
extension NutritionPlanModelX on NutritionPlanModel {
  NutritionPlanEntity toEntity() {
    return NutritionPlanEntity(
      id: id,
      userId: userId,
      nutritionistId: nutritionistId,
      consultationId: consultationId,
      title: title,
      description: description,
      status: status,
      startDate: startDate,
      endDate: endDate,
      goals: goals.toEntity(),
      dailyPlans: dailyPlans.map((p) => p.toEntity()).toList(),
      recommendedFoods: recommendedFoods.map((f) => f.toEntity()).toList(),
      restrictedFoods: restrictedFoods.map((f) => f.toEntity()).toList(),
      mealTiming: mealTiming.toEntity(),
      nutritionTargets: nutritionTargets,
      healthConditions: healthConditions,
      allergies: allergies,
      preferences: preferences,
      progressTracking: progressTracking,
      notes: notes,
      attachments: attachments,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension NutritionGoalsModelX on NutritionGoalsModel {
  NutritionGoals toEntity() {
    return NutritionGoals(
      primaryGoal: primaryGoal,
      secondaryGoals: secondaryGoals,
      targetWeight: targetWeight,
      targetBodyFat: targetBodyFat,
      targetCalories: targetCalories,
      macroTargets: macroTargets,
      microTargets: microTargets,
      specificTarget: specificTarget,
    );
  }
}

extension DailyPlanModelX on DailyPlanModel {
  DailyPlan toEntity() {
    return DailyPlan(
      dayNumber: dayNumber,
      date: date,
      meals: meals.map((m) => m.toEntity()).toList(),
      totalCalories: totalCalories,
      totalMacros: totalMacros,
      notes: notes,
      isCompleted: isCompleted,
      actualIntake: actualIntake,
    );
  }
}

extension MealPlanModelX on MealPlanModel {
  MealPlan toEntity() {
    return MealPlan(
      mealType: mealType,
      time: time,
      foods: foods.map((f) => f.toEntity()).toList(),
      calories: calories,
      macros: macros,
      cookingInstructions: cookingInstructions,
      notes: notes,
    );
  }
}

extension FoodItemModelX on FoodItemModel {
  FoodItem toEntity() {
    return FoodItem(
      name: name,
      quantity: quantity,
      unit: unit,
      calories: calories,
      nutrition: nutrition,
      preparation: preparation,
      alternatives: alternatives,
    );
  }
}

extension FoodRecommendationModelX on FoodRecommendationModel {
  FoodRecommendation toEntity() {
    return FoodRecommendation(
      foodName: foodName,
      reason: reason,
      frequency: frequency,
      servingSize: servingSize,
      benefits: benefits,
    );
  }
}

extension FoodRestrictionModelX on FoodRestrictionModel {
  FoodRestriction toEntity() {
    return FoodRestriction(
      foodName: foodName,
      reason: reason,
      level: level,
      alternatives: alternatives,
    );
  }
}

extension MealTimingModelX on MealTimingModel {
  MealTiming toEntity() {
    return MealTiming(
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      snacks: snacks,
      notes: notes,
    );
  }
}