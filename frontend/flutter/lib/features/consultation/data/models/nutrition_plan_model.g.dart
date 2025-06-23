// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionPlanModelImpl _$$NutritionPlanModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionPlanModelImpl(
      id: json['_id'] as String,
      userId: json['user_id'] as String,
      nutritionistId: json['nutritionist_id'] as String,
      consultationId: json['consultation_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      status: $enumDecode(_$PlanStatusEnumMap, json['status']),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      goals:
          NutritionGoalsModel.fromJson(json['goals'] as Map<String, dynamic>),
      dailyPlans: (json['daily_plans'] as List<dynamic>)
          .map((e) => DailyPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendedFoods: (json['recommended_foods'] as List<dynamic>)
          .map((e) =>
              FoodRecommendationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      restrictedFoods: (json['restricted_foods'] as List<dynamic>)
          .map((e) => FoodRestrictionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      mealTiming:
          MealTimingModel.fromJson(json['meal_timing'] as Map<String, dynamic>),
      nutritionTargets:
          json['nutrition_targets'] as Map<String, dynamic>? ?? const {},
      healthConditions: (json['health_conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preferences: (json['preferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      progressTracking:
          json['progress_tracking'] as Map<String, dynamic>? ?? const {},
      notes:
          (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NutritionPlanModelImplToJson(
        _$NutritionPlanModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user_id': instance.userId,
      'nutritionist_id': instance.nutritionistId,
      if (instance.consultationId case final value?) 'consultation_id': value,
      'title': instance.title,
      'description': instance.description,
      'status': _$PlanStatusEnumMap[instance.status]!,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'goals': instance.goals.toJson(),
      'daily_plans': instance.dailyPlans.map((e) => e.toJson()).toList(),
      'recommended_foods':
          instance.recommendedFoods.map((e) => e.toJson()).toList(),
      'restricted_foods':
          instance.restrictedFoods.map((e) => e.toJson()).toList(),
      'meal_timing': instance.mealTiming.toJson(),
      'nutrition_targets': instance.nutritionTargets,
      'health_conditions': instance.healthConditions,
      'allergies': instance.allergies,
      'preferences': instance.preferences,
      'progress_tracking': instance.progressTracking,
      'notes': instance.notes,
      'attachments': instance.attachments,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

const _$PlanStatusEnumMap = {
  PlanStatus.draft: 'draft',
  PlanStatus.active: 'active',
  PlanStatus.paused: 'paused',
  PlanStatus.completed: 'completed',
  PlanStatus.cancelled: 'cancelled',
};

_$NutritionGoalsModelImpl _$$NutritionGoalsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionGoalsModelImpl(
      primaryGoal: $enumDecode(_$GoalTypeEnumMap, json['primary_goal']),
      secondaryGoals: (json['secondary_goals'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$GoalTypeEnumMap, e))
              .toList() ??
          const [],
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      targetBodyFat: (json['target_body_fat'] as num?)?.toDouble(),
      targetCalories: (json['target_calories'] as num?)?.toInt(),
      macroTargets: (json['macro_targets'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      microTargets: (json['micro_targets'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      specificTarget: json['specific_target'] as String?,
    );

Map<String, dynamic> _$$NutritionGoalsModelImplToJson(
        _$NutritionGoalsModelImpl instance) =>
    <String, dynamic>{
      'primary_goal': _$GoalTypeEnumMap[instance.primaryGoal]!,
      'secondary_goals':
          instance.secondaryGoals.map((e) => _$GoalTypeEnumMap[e]!).toList(),
      if (instance.targetWeight case final value?) 'target_weight': value,
      if (instance.targetBodyFat case final value?) 'target_body_fat': value,
      if (instance.targetCalories case final value?) 'target_calories': value,
      'macro_targets': instance.macroTargets,
      'micro_targets': instance.microTargets,
      if (instance.specificTarget case final value?) 'specific_target': value,
    };

const _$GoalTypeEnumMap = {
  GoalType.weightLoss: 'weight_loss',
  GoalType.weightGain: 'weight_gain',
  GoalType.muscleBuilding: 'muscle_building',
  GoalType.healthImprovement: 'health_improvement',
  GoalType.diseaseManagement: 'disease_management',
  GoalType.athleticPerformance: 'athletic_performance',
  GoalType.generalWellness: 'general_wellness',
};

_$DailyPlanModelImpl _$$DailyPlanModelImplFromJson(Map<String, dynamic> json) =>
    _$DailyPlanModelImpl(
      dayNumber: (json['day_number'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      meals: (json['meals'] as List<dynamic>)
          .map((e) => MealPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['total_calories'] as num).toInt(),
      totalMacros: (json['total_macros'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      notes:
          (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isCompleted: json['is_completed'] as bool? ?? false,
      actualIntake: json['actual_intake'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$DailyPlanModelImplToJson(
        _$DailyPlanModelImpl instance) =>
    <String, dynamic>{
      'day_number': instance.dayNumber,
      'date': instance.date.toIso8601String(),
      'meals': instance.meals.map((e) => e.toJson()).toList(),
      'total_calories': instance.totalCalories,
      'total_macros': instance.totalMacros,
      'notes': instance.notes,
      'is_completed': instance.isCompleted,
      'actual_intake': instance.actualIntake,
    };

_$MealPlanModelImpl _$$MealPlanModelImplFromJson(Map<String, dynamic> json) =>
    _$MealPlanModelImpl(
      mealType: $enumDecode(_$MealTypeEnumMap, json['meal_type']),
      time: json['time'] as String,
      foods: (json['foods'] as List<dynamic>)
          .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      calories: (json['calories'] as num).toInt(),
      macros: (json['macros'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      cookingInstructions: (json['cooking_instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes:
          (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$MealPlanModelImplToJson(_$MealPlanModelImpl instance) =>
    <String, dynamic>{
      'meal_type': _$MealTypeEnumMap[instance.mealType]!,
      'time': instance.time,
      'foods': instance.foods.map((e) => e.toJson()).toList(),
      'calories': instance.calories,
      'macros': instance.macros,
      'cooking_instructions': instance.cookingInstructions,
      'notes': instance.notes,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.morningSnack: 'morning_snack',
  MealType.afternoonSnack: 'afternoon_snack',
  MealType.eveningSnack: 'evening_snack',
};

_$FoodItemModelImpl _$$FoodItemModelImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemModelImpl(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      calories: (json['calories'] as num).toInt(),
      nutrition: (json['nutrition'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      preparation: json['preparation'] as String? ?? '',
      alternatives: (json['alternatives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FoodItemModelImplToJson(_$FoodItemModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'calories': instance.calories,
      'nutrition': instance.nutrition,
      'preparation': instance.preparation,
      'alternatives': instance.alternatives,
    };

_$FoodRecommendationModelImpl _$$FoodRecommendationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FoodRecommendationModelImpl(
      foodName: json['food_name'] as String,
      reason: json['reason'] as String,
      frequency:
          $enumDecode(_$RecommendationFrequencyEnumMap, json['frequency']),
      servingSize: json['serving_size'] as String? ?? '',
      benefits: (json['benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FoodRecommendationModelImplToJson(
        _$FoodRecommendationModelImpl instance) =>
    <String, dynamic>{
      'food_name': instance.foodName,
      'reason': instance.reason,
      'frequency': _$RecommendationFrequencyEnumMap[instance.frequency]!,
      'serving_size': instance.servingSize,
      'benefits': instance.benefits,
    };

const _$RecommendationFrequencyEnumMap = {
  RecommendationFrequency.daily: 'daily',
  RecommendationFrequency.weekly: 'weekly',
  RecommendationFrequency.occasionally: 'occasionally',
};

_$FoodRestrictionModelImpl _$$FoodRestrictionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FoodRestrictionModelImpl(
      foodName: json['food_name'] as String,
      reason: json['reason'] as String,
      level: $enumDecode(_$RestrictionLevelEnumMap, json['level']),
      alternatives: (json['alternatives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FoodRestrictionModelImplToJson(
        _$FoodRestrictionModelImpl instance) =>
    <String, dynamic>{
      'food_name': instance.foodName,
      'reason': instance.reason,
      'level': _$RestrictionLevelEnumMap[instance.level]!,
      'alternatives': instance.alternatives,
    };

const _$RestrictionLevelEnumMap = {
  RestrictionLevel.avoid: 'avoid',
  RestrictionLevel.limit: 'limit',
  RestrictionLevel.forbidden: 'forbidden',
};

_$MealTimingModelImpl _$$MealTimingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MealTimingModelImpl(
      breakfast: json['breakfast'] as String,
      lunch: json['lunch'] as String,
      dinner: json['dinner'] as String,
      snacks: (json['snacks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$$MealTimingModelImplToJson(
        _$MealTimingModelImpl instance) =>
    <String, dynamic>{
      'breakfast': instance.breakfast,
      'lunch': instance.lunch,
      'dinner': instance.dinner,
      'snacks': instance.snacks,
      'notes': instance.notes,
    };
