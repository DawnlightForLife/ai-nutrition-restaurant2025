// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_ordering.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionElementImpl _$$NutritionElementImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionElementImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      scientificName: json['scientific_name'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      category: json['category'] as String,
      subCategory: json['sub_category'] as String?,
      unit: json['unit'] as String,
      importance: json['importance'] as String? ?? 'beneficial',
      functions: (json['functions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      healthBenefits: (json['health_benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deficiencySymptoms: (json['deficiency_symptoms'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      overdoseRisks: (json['overdose_risks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendedIntake: json['recommended_intake'] as Map<String, dynamic>?,
      specialConditionNeeds:
          json['special_condition_needs'] as Map<String, dynamic>?,
      absorption: json['absorption'] as Map<String, dynamic>?,
      foodSources: (json['food_sources'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      cookingEffects: json['cooking_effects'] as Map<String, dynamic>?,
      interactions: json['interactions'] as Map<String, dynamic>?,
      isActive: json['is_active'] as bool?,
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      version: (json['version'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$NutritionElementImplToJson(
        _$NutritionElementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      if (instance.scientificName case final value?) 'scientific_name': value,
      'aliases': instance.aliases,
      'category': instance.category,
      if (instance.subCategory case final value?) 'sub_category': value,
      'unit': instance.unit,
      'importance': instance.importance,
      'functions': instance.functions,
      'health_benefits': instance.healthBenefits,
      'deficiency_symptoms': instance.deficiencySymptoms,
      'overdose_risks': instance.overdoseRisks,
      if (instance.recommendedIntake case final value?)
        'recommended_intake': value,
      if (instance.specialConditionNeeds case final value?)
        'special_condition_needs': value,
      if (instance.absorption case final value?) 'absorption': value,
      'food_sources': instance.foodSources,
      if (instance.cookingEffects case final value?) 'cooking_effects': value,
      if (instance.interactions case final value?) 'interactions': value,
      if (instance.isActive case final value?) 'is_active': value,
      if (instance.lastUpdated?.toIso8601String() case final value?)
        'last_updated': value,
      'version': instance.version,
    };

_$IngredientNutritionImpl _$$IngredientNutritionImplFromJson(
        Map<String, dynamic> json) =>
    _$IngredientNutritionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      scientificName: json['scientific_name'] as String?,
      commonNames: (json['common_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      category: json['category'] as String,
      subCategory: json['sub_category'] as String?,
      servingSize:
          ServingSize.fromJson(json['serving_size'] as Map<String, dynamic>),
      nutritionDensity:
          (json['nutrition_density'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      nutritionContent: (json['nutrition_content'] as List<dynamic>?)
              ?.map((e) => NutritionContent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      macronutrients: json['macronutrients'] as Map<String, dynamic>?,
      aminoAcidProfile: json['amino_acid_profile'] as Map<String, dynamic>?,
      fattyAcidProfile: (json['fatty_acid_profile'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      antinutrients: (json['antinutrients'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      bioactiveCompounds: (json['bioactive_compounds'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      glycemicResponse: json['glycemic_response'] as Map<String, dynamic>?,
      freshnessLevel: json['freshness_level'] as String? ?? 'fresh',
      seasonalVariation: json['seasonal_variation'] as Map<String, dynamic>?,
      storageConditions: json['storage_conditions'] as Map<String, dynamic>?,
      originInfo: json['origin_info'] as Map<String, dynamic>?,
      sustainabilityScore:
          json['sustainability_score'] as Map<String, dynamic>?,
      allergenInfo: json['allergen_info'] as Map<String, dynamic>?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$IngredientNutritionImplToJson(
        _$IngredientNutritionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      if (instance.scientificName case final value?) 'scientific_name': value,
      'common_names': instance.commonNames,
      'category': instance.category,
      if (instance.subCategory case final value?) 'sub_category': value,
      'serving_size': instance.servingSize.toJson(),
      if (instance.nutritionDensity case final value?)
        'nutrition_density': value,
      'nutrition_content':
          instance.nutritionContent.map((e) => e.toJson()).toList(),
      if (instance.macronutrients case final value?) 'macronutrients': value,
      if (instance.aminoAcidProfile case final value?)
        'amino_acid_profile': value,
      'fatty_acid_profile': instance.fattyAcidProfile,
      'antinutrients': instance.antinutrients,
      'bioactive_compounds': instance.bioactiveCompounds,
      if (instance.glycemicResponse case final value?)
        'glycemic_response': value,
      'freshness_level': instance.freshnessLevel,
      if (instance.seasonalVariation case final value?)
        'seasonal_variation': value,
      if (instance.storageConditions case final value?)
        'storage_conditions': value,
      if (instance.originInfo case final value?) 'origin_info': value,
      if (instance.sustainabilityScore case final value?)
        'sustainability_score': value,
      if (instance.allergenInfo case final value?) 'allergen_info': value,
      if (instance.isActive case final value?) 'is_active': value,
    };

_$ServingSizeImpl _$$ServingSizeImplFromJson(Map<String, dynamic> json) =>
    _$ServingSizeImpl(
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ServingSizeImplToJson(_$ServingSizeImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'unit': instance.unit,
      if (instance.description case final value?) 'description': value,
    };

_$NutritionContentImpl _$$NutritionContentImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionContentImpl(
      element: json['element'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      dailyValuePercentage:
          (json['daily_value_percentage'] as num?)?.toDouble(),
      bioavailability: (json['bioavailability'] as num?)?.toDouble() ?? 100.0,
      isEstimated: json['is_estimated'] as bool? ?? false,
      lastTested: json['last_tested'] == null
          ? null
          : DateTime.parse(json['last_tested'] as String),
      testMethod: json['test_method'] as String?,
    );

Map<String, dynamic> _$$NutritionContentImplToJson(
        _$NutritionContentImpl instance) =>
    <String, dynamic>{
      'element': instance.element,
      'amount': instance.amount,
      'unit': instance.unit,
      if (instance.dailyValuePercentage case final value?)
        'daily_value_percentage': value,
      'bioavailability': instance.bioavailability,
      'is_estimated': instance.isEstimated,
      if (instance.lastTested?.toIso8601String() case final value?)
        'last_tested': value,
      if (instance.testMethod case final value?) 'test_method': value,
    };

_$CookingMethodImpl _$$CookingMethodImplFromJson(Map<String, dynamic> json) =>
    _$CookingMethodImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      description: json['description'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      category: json['category'] as String,
      method: json['method'] as String,
      technicalParameters:
          json['technical_parameters'] as Map<String, dynamic>?,
      nutritionImpacts: (json['nutrition_impacts'] as List<dynamic>?)
              ?.map((e) => NutritionImpact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      overallNutritionRetention:
          json['overall_nutrition_retention'] as Map<String, dynamic>?,
      temperatureTimeCurves: (json['temperature_time_curves'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      ingredientApplicability:
          (json['ingredient_applicability'] as List<dynamic>?)
                  ?.map((e) => e as Map<String, dynamic>)
                  .toList() ??
              const [],
      nutritionEnhancements: (json['nutrition_enhancements'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      harmfulCompounds: (json['harmful_compounds'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      digestibilityImpact:
          json['digestibility_impact'] as Map<String, dynamic>?,
      antinutrientImpact: (json['antinutrient_impact'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      bioactiveImpact: (json['bioactive_impact'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      equipmentRequirements:
          json['equipment_requirements'] as Map<String, dynamic>?,
      skillRequirements: json['skill_requirements'] as Map<String, dynamic>?,
      efficiency: json['efficiency'] as Map<String, dynamic>?,
      researchSupport: json['research_support'] as Map<String, dynamic>?,
      isActive: json['is_active'] as bool?,
    );

Map<String, dynamic> _$$CookingMethodImplToJson(_$CookingMethodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      if (instance.description case final value?) 'description': value,
      'aliases': instance.aliases,
      'category': instance.category,
      'method': instance.method,
      if (instance.technicalParameters case final value?)
        'technical_parameters': value,
      'nutrition_impacts':
          instance.nutritionImpacts.map((e) => e.toJson()).toList(),
      if (instance.overallNutritionRetention case final value?)
        'overall_nutrition_retention': value,
      'temperature_time_curves': instance.temperatureTimeCurves,
      'ingredient_applicability': instance.ingredientApplicability,
      'nutrition_enhancements': instance.nutritionEnhancements,
      'harmful_compounds': instance.harmfulCompounds,
      if (instance.digestibilityImpact case final value?)
        'digestibility_impact': value,
      'antinutrient_impact': instance.antinutrientImpact,
      'bioactive_impact': instance.bioactiveImpact,
      if (instance.equipmentRequirements case final value?)
        'equipment_requirements': value,
      if (instance.skillRequirements case final value?)
        'skill_requirements': value,
      if (instance.efficiency case final value?) 'efficiency': value,
      if (instance.researchSupport case final value?) 'research_support': value,
      if (instance.isActive case final value?) 'is_active': value,
    };

_$NutritionImpactImpl _$$NutritionImpactImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionImpactImpl(
      nutrient: json['nutrient'] as String,
      impactType: json['impact_type'] as String,
      retentionRate: (json['retention_rate'] as num?)?.toDouble(),
      variationRange: (json['variation_range'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      influencingFactors: (json['influencing_factors'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      mechanism: json['mechanism'] as String?,
      timeDependent: json['time_dependent'] as bool? ?? false,
      timeCurve: (json['time_curve'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NutritionImpactImplToJson(
        _$NutritionImpactImpl instance) =>
    <String, dynamic>{
      'nutrient': instance.nutrient,
      'impact_type': instance.impactType,
      if (instance.retentionRate case final value?) 'retention_rate': value,
      if (instance.variationRange case final value?) 'variation_range': value,
      'influencing_factors': instance.influencingFactors,
      if (instance.mechanism case final value?) 'mechanism': value,
      'time_dependent': instance.timeDependent,
      'time_curve': instance.timeCurve,
    };

_$NutritionNeedsAnalysisImpl _$$NutritionNeedsAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionNeedsAnalysisImpl(
      userId: json['user_id'] as String,
      profileId: json['profile_id'] as String,
      bmr: (json['bmr'] as num).toDouble(),
      tdee: (json['tdee'] as num).toDouble(),
      dailyNeeds: json['daily_needs'] as Map<String, dynamic>,
      calculatedAt: json['calculated_at'] == null
          ? null
          : DateTime.parse(json['calculated_at'] as String),
      validUntil: json['valid_until'] == null
          ? null
          : DateTime.parse(json['valid_until'] as String),
    );

Map<String, dynamic> _$$NutritionNeedsAnalysisImplToJson(
        _$NutritionNeedsAnalysisImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'profile_id': instance.profileId,
      'bmr': instance.bmr,
      'tdee': instance.tdee,
      'daily_needs': instance.dailyNeeds,
      if (instance.calculatedAt?.toIso8601String() case final value?)
        'calculated_at': value,
      if (instance.validUntil?.toIso8601String() case final value?)
        'valid_until': value,
    };

_$OrderingSelectionImpl _$$OrderingSelectionImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderingSelectionImpl(
      ingredientId: json['ingredient_id'] as String,
      ingredientName: json['ingredient_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      unit: json['unit'] as String,
      cookingMethod: json['cooking_method'] as String?,
      cookingMethodName: json['cooking_method_name'] as String?,
      nutritionCalculation:
          json['nutrition_calculation'] as Map<String, dynamic>?,
      selectedAt: json['selected_at'] == null
          ? null
          : DateTime.parse(json['selected_at'] as String),
    );

Map<String, dynamic> _$$OrderingSelectionImplToJson(
        _$OrderingSelectionImpl instance) =>
    <String, dynamic>{
      'ingredient_id': instance.ingredientId,
      'ingredient_name': instance.ingredientName,
      'amount': instance.amount,
      'unit': instance.unit,
      if (instance.cookingMethod case final value?) 'cooking_method': value,
      if (instance.cookingMethodName case final value?)
        'cooking_method_name': value,
      if (instance.nutritionCalculation case final value?)
        'nutrition_calculation': value,
      if (instance.selectedAt?.toIso8601String() case final value?)
        'selected_at': value,
    };

_$NutritionBalanceAnalysisImpl _$$NutritionBalanceAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionBalanceAnalysisImpl(
      overallMatch: (json['overall_match'] as num).toDouble(),
      macroMatch: json['macro_match'] as Map<String, dynamic>,
      microMatch: json['micro_match'] as Map<String, dynamic>,
      gaps: (json['gaps'] as List<dynamic>?)
              ?.map((e) => NutritionGap.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      excesses: (json['excesses'] as List<dynamic>?)
              ?.map((e) => NutritionExcess.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NutritionBalanceAnalysisImplToJson(
        _$NutritionBalanceAnalysisImpl instance) =>
    <String, dynamic>{
      'overall_match': instance.overallMatch,
      'macro_match': instance.macroMatch,
      'micro_match': instance.microMatch,
      'gaps': instance.gaps.map((e) => e.toJson()).toList(),
      'excesses': instance.excesses.map((e) => e.toJson()).toList(),
      'recommendations': instance.recommendations,
    };

_$NutritionGapImpl _$$NutritionGapImplFromJson(Map<String, dynamic> json) =>
    _$NutritionGapImpl(
      element: json['element'] as String,
      currentAmount: (json['current_amount'] as num).toDouble(),
      targetAmount: (json['target_amount'] as num).toDouble(),
      gapAmount: (json['gap_amount'] as num).toDouble(),
      unit: json['unit'] as String,
      severity: json['severity'] as String?,
      recommendedSources: (json['recommended_sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NutritionGapImplToJson(_$NutritionGapImpl instance) =>
    <String, dynamic>{
      'element': instance.element,
      'current_amount': instance.currentAmount,
      'target_amount': instance.targetAmount,
      'gap_amount': instance.gapAmount,
      'unit': instance.unit,
      if (instance.severity case final value?) 'severity': value,
      'recommended_sources': instance.recommendedSources,
    };

_$NutritionExcessImpl _$$NutritionExcessImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionExcessImpl(
      element: json['element'] as String,
      currentAmount: (json['current_amount'] as num).toDouble(),
      targetAmount: (json['target_amount'] as num).toDouble(),
      excessAmount: (json['excess_amount'] as num).toDouble(),
      unit: json['unit'] as String,
      riskLevel: json['risk_level'] as String?,
      reductionSuggestions: (json['reduction_suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$NutritionExcessImplToJson(
        _$NutritionExcessImpl instance) =>
    <String, dynamic>{
      'element': instance.element,
      'current_amount': instance.currentAmount,
      'target_amount': instance.targetAmount,
      'excess_amount': instance.excessAmount,
      'unit': instance.unit,
      if (instance.riskLevel case final value?) 'risk_level': value,
      'reduction_suggestions': instance.reductionSuggestions,
    };

_$IngredientRecommendationImpl _$$IngredientRecommendationImplFromJson(
        Map<String, dynamic> json) =>
    _$IngredientRecommendationImpl(
      nutrient: json['nutrient'] as String,
      gap: (json['gap'] as num).toDouble(),
      unit: json['unit'] as String,
      recommendedIngredients:
          (json['recommended_ingredients'] as List<dynamic>?)
                  ?.map((e) =>
                      RecommendedIngredient.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
    );

Map<String, dynamic> _$$IngredientRecommendationImplToJson(
        _$IngredientRecommendationImpl instance) =>
    <String, dynamic>{
      'nutrient': instance.nutrient,
      'gap': instance.gap,
      'unit': instance.unit,
      'recommended_ingredients':
          instance.recommendedIngredients.map((e) => e.toJson()).toList(),
    };

_$RecommendedIngredientImpl _$$RecommendedIngredientImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendedIngredientImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      nutrientContent: (json['nutrient_content'] as num).toDouble(),
      nutritionDensity: json['nutrition_density'] as String,
      servingSize:
          ServingSize.fromJson(json['serving_size'] as Map<String, dynamic>),
      estimatedServing: (json['estimated_serving'] as num).toDouble(),
    );

Map<String, dynamic> _$$RecommendedIngredientImplToJson(
        _$RecommendedIngredientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'nutrient_content': instance.nutrientContent,
      'nutrition_density': instance.nutritionDensity,
      'serving_size': instance.servingSize.toJson(),
      'estimated_serving': instance.estimatedServing,
    };

_$NutritionScoreImpl _$$NutritionScoreImplFromJson(Map<String, dynamic> json) =>
    _$NutritionScoreImpl(
      overall: (json['overall'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      adequacy: (json['adequacy'] as num).toDouble(),
      moderation: (json['moderation'] as num).toDouble(),
      variety: (json['variety'] as num).toDouble(),
      details: json['details'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$NutritionScoreImplToJson(
        _$NutritionScoreImpl instance) =>
    <String, dynamic>{
      'overall': instance.overall,
      'balance': instance.balance,
      'adequacy': instance.adequacy,
      'moderation': instance.moderation,
      'variety': instance.variety,
      'details': instance.details,
    };
