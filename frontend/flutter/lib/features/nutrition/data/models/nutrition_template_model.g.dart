// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionTemplateModelImpl _$$NutritionTemplateModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionTemplateModelImpl(
      key: json['key'] as String,
      name: json['name'] as String,
      data:
          NutritionProfileModel.fromJson(json['data'] as Map<String, dynamic>),
      description: json['description'] as String?,
      iconName: json['icon_name'] as String?,
      recommendedFor: (json['recommended_for'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$NutritionTemplateModelImplToJson(
        _$NutritionTemplateModelImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'data': instance.data.toJson(),
      if (instance.description case final value?) 'description': value,
      if (instance.iconName case final value?) 'icon_name': value,
      if (instance.recommendedFor case final value?) 'recommended_for': value,
    };

_$HealthGoalValidationResultImpl _$$HealthGoalValidationResultImplFromJson(
        Map<String, dynamic> json) =>
    _$HealthGoalValidationResultImpl(
      success: json['success'] as bool,
      message: json['message'] as String,
      field: json['field'] as String?,
    );

Map<String, dynamic> _$$HealthGoalValidationResultImplToJson(
        _$HealthGoalValidationResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      if (instance.field case final value?) 'field': value,
    };

_$ConflictDetectionResultImpl _$$ConflictDetectionResultImplFromJson(
        Map<String, dynamic> json) =>
    _$ConflictDetectionResultImpl(
      success: json['success'] as bool,
      hasConflicts: json['has_conflicts'] as bool,
      conflicts: (json['conflicts'] as List<dynamic>)
          .map((e) => ProfileConflict.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ConflictDetectionResultImplToJson(
        _$ConflictDetectionResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'has_conflicts': instance.hasConflicts,
      'conflicts': instance.conflicts.map((e) => e.toJson()).toList(),
    };

_$ProfileConflictImpl _$$ProfileConflictImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileConflictImpl(
      type: json['type'] as String,
      message: json['message'] as String,
      field: json['field'] as String?,
      severity:
          $enumDecodeNullable(_$ConflictSeverityEnumMap, json['severity']),
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ProfileConflictImplToJson(
        _$ProfileConflictImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
      if (instance.field case final value?) 'field': value,
      if (_$ConflictSeverityEnumMap[instance.severity] case final value?)
        'severity': value,
      if (instance.suggestions case final value?) 'suggestions': value,
    };

const _$ConflictSeverityEnumMap = {
  ConflictSeverity.low: 'low',
  ConflictSeverity.medium: 'medium',
  ConflictSeverity.high: 'high',
};

_$NutritionSuggestionsImpl _$$NutritionSuggestionsImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionSuggestionsImpl(
      success: json['success'] as bool,
      suggestions:
          SuggestionsData.fromJson(json['suggestions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NutritionSuggestionsImplToJson(
        _$NutritionSuggestionsImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'suggestions': instance.suggestions.toJson(),
    };

_$SuggestionsDataImpl _$$SuggestionsDataImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestionsDataImpl(
      dietaryType: (json['dietary_type'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      tastePreferences:
          (json['taste_preferences'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      dailyCalorieTarget: (json['daily_calorie_target'] as num?)?.toInt(),
      macroRatios: json['macro_ratios'] == null
          ? null
          : MacroRatios.fromJson(json['macro_ratios'] as Map<String, dynamic>),
      hydrationGoal: (json['hydration_goal'] as num?)?.toInt(),
      mealFrequency: (json['meal_frequency'] as num?)?.toInt(),
      exerciseTypes: (json['exercise_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      supplementRecommendations:
          (json['supplement_recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$$SuggestionsDataImplToJson(
        _$SuggestionsDataImpl instance) =>
    <String, dynamic>{
      if (instance.dietaryType case final value?) 'dietary_type': value,
      if (instance.tastePreferences case final value?)
        'taste_preferences': value,
      if (instance.dailyCalorieTarget case final value?)
        'daily_calorie_target': value,
      if (instance.macroRatios?.toJson() case final value?)
        'macro_ratios': value,
      if (instance.hydrationGoal case final value?) 'hydration_goal': value,
      if (instance.mealFrequency case final value?) 'meal_frequency': value,
      if (instance.exerciseTypes case final value?) 'exercise_types': value,
      if (instance.supplementRecommendations case final value?)
        'supplement_recommendations': value,
    };

_$MacroRatiosImpl _$$MacroRatiosImplFromJson(Map<String, dynamic> json) =>
    _$MacroRatiosImpl(
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
    );

Map<String, dynamic> _$$MacroRatiosImplToJson(_$MacroRatiosImpl instance) =>
    <String, dynamic>{
      'protein': instance.protein,
      'fat': instance.fat,
      'carbs': instance.carbs,
    };
