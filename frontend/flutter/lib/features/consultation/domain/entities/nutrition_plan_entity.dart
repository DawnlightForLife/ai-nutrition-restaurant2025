import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_plan_entity.freezed.dart';
part 'nutrition_plan_entity.g.dart';

@freezed
class NutritionPlanEntity with _$NutritionPlanEntity {
  const factory NutritionPlanEntity({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required String nutritionistId,
    String? consultationId,
    required String title,
    required String description,
    required PlanStatus status,
    required DateTime startDate,
    required DateTime endDate,
    required NutritionGoals goals,
    required List<DailyPlan> dailyPlans,
    required List<FoodRecommendation> recommendedFoods,
    required List<FoodRestriction> restrictedFoods,
    required MealTiming mealTiming,
    @Default({}) Map<String, dynamic> nutritionTargets,
    @Default([]) List<String> healthConditions,
    @Default([]) List<String> allergies,
    @Default([]) List<String> preferences,
    @Default({}) Map<String, dynamic> progressTracking,
    @Default([]) List<String> notes,
    @Default([]) List<String> attachments,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NutritionPlanEntity;

  factory NutritionPlanEntity.fromJson(Map<String, dynamic> json) =>
      _$NutritionPlanEntityFromJson(json);
}

@freezed
class NutritionGoals with _$NutritionGoals {
  const factory NutritionGoals({
    required GoalType primaryGoal,
    @Default([]) List<GoalType> secondaryGoals,
    double? targetWeight,
    double? targetBodyFat,
    int? targetCalories,
    @Default({}) Map<String, double> macroTargets, // protein, carbs, fat
    @Default({}) Map<String, double> microTargets, // vitamins, minerals
    String? specificTarget,
  }) = _NutritionGoals;

  factory NutritionGoals.fromJson(Map<String, dynamic> json) =>
      _$NutritionGoalsFromJson(json);
}

@freezed
class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    required int dayNumber,
    required DateTime date,
    required List<MealPlan> meals,
    required int totalCalories,
    required Map<String, double> totalMacros,
    @Default([]) List<String> notes,
    @Default(false) bool isCompleted,
    @Default({}) Map<String, dynamic> actualIntake,
  }) = _DailyPlan;

  factory DailyPlan.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanFromJson(json);
}

@freezed
class MealPlan with _$MealPlan {
  const factory MealPlan({
    required MealType mealType,
    required String time,
    required List<FoodItem> foods,
    required int calories,
    required Map<String, double> macros,
    @Default([]) List<String> cookingInstructions,
    @Default([]) List<String> notes,
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _$MealPlanFromJson(json);
}

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String name,
    required double quantity,
    required String unit,
    required int calories,
    required Map<String, double> nutrition,
    @Default('') String preparation,
    @Default([]) List<String> alternatives,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}

@freezed
class FoodRecommendation with _$FoodRecommendation {
  const factory FoodRecommendation({
    required String foodName,
    required String reason,
    required RecommendationFrequency frequency,
    @Default('') String servingSize,
    @Default([]) List<String> benefits,
  }) = _FoodRecommendation;

  factory FoodRecommendation.fromJson(Map<String, dynamic> json) =>
      _$FoodRecommendationFromJson(json);
}

@freezed
class FoodRestriction with _$FoodRestriction {
  const factory FoodRestriction({
    required String foodName,
    required String reason,
    required RestrictionLevel level,
    @Default([]) List<String> alternatives,
  }) = _FoodRestriction;

  factory FoodRestriction.fromJson(Map<String, dynamic> json) =>
      _$FoodRestrictionFromJson(json);
}

@freezed
class MealTiming with _$MealTiming {
  const factory MealTiming({
    required String breakfast,
    required String lunch,
    required String dinner,
    @Default([]) List<String> snacks,
    @Default('') String notes,
  }) = _MealTiming;

  factory MealTiming.fromJson(Map<String, dynamic> json) =>
      _$MealTimingFromJson(json);
}

// 计划状态枚举
enum PlanStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('active')
  active,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

// 目标类型枚举
enum GoalType {
  @JsonValue('weight_loss')
  weightLoss,
  @JsonValue('weight_gain')
  weightGain,
  @JsonValue('muscle_building')
  muscleBuilding,
  @JsonValue('health_improvement')
  healthImprovement,
  @JsonValue('disease_management')
  diseaseManagement,
  @JsonValue('athletic_performance')
  athleticPerformance,
  @JsonValue('general_wellness')
  generalWellness,
}

// 餐食类型枚举
enum MealType {
  @JsonValue('breakfast')
  breakfast,
  @JsonValue('lunch')
  lunch,
  @JsonValue('dinner')
  dinner,
  @JsonValue('morning_snack')
  morningSnack,
  @JsonValue('afternoon_snack')
  afternoonSnack,
  @JsonValue('evening_snack')
  eveningSnack,
}

// 推荐频率枚举
enum RecommendationFrequency {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('occasionally')
  occasionally,
}

// 限制级别枚举
enum RestrictionLevel {
  @JsonValue('avoid')
  avoid,
  @JsonValue('limit')
  limit,
  @JsonValue('forbidden')
  forbidden,
}

// Extension methods
extension PlanStatusX on PlanStatus {
  String get displayName {
    switch (this) {
      case PlanStatus.draft:
        return '草稿';
      case PlanStatus.active:
        return '执行中';
      case PlanStatus.paused:
        return '已暂停';
      case PlanStatus.completed:
        return '已完成';
      case PlanStatus.cancelled:
        return '已取消';
    }
  }
}

extension GoalTypeX on GoalType {
  String get displayName {
    switch (this) {
      case GoalType.weightLoss:
        return '减重';
      case GoalType.weightGain:
        return '增重';
      case GoalType.muscleBuilding:
        return '增肌';
      case GoalType.healthImprovement:
        return '改善健康';
      case GoalType.diseaseManagement:
        return '疾病管理';
      case GoalType.athleticPerformance:
        return '运动表现';
      case GoalType.generalWellness:
        return '整体健康';
    }
  }
}

extension MealTypeX on MealType {
  String get displayName {
    switch (this) {
      case MealType.breakfast:
        return '早餐';
      case MealType.lunch:
        return '午餐';
      case MealType.dinner:
        return '晚餐';
      case MealType.morningSnack:
        return '上午加餐';
      case MealType.afternoonSnack:
        return '下午加餐';
      case MealType.eveningSnack:
        return '夜宵';
    }
  }

  String get icon {
    switch (this) {
      case MealType.breakfast:
        return '🌅';
      case MealType.lunch:
        return '☀️';
      case MealType.dinner:
        return '🌙';
      case MealType.morningSnack:
        return '🥐';
      case MealType.afternoonSnack:
        return '🍎';
      case MealType.eveningSnack:
        return '🥛';
    }
  }
}