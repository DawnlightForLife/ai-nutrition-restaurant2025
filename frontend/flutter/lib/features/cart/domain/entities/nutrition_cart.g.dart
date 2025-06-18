// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionCartImpl _$$NutritionCartImplFromJson(Map<String, dynamic> json) =>
    _$NutritionCartImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      profileId: json['profile_id'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => NutritionCartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      targetNutritionGoals:
          (json['target_nutrition_goals'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      currentNutritionTotals:
          (json['current_nutrition_totals'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      totalWeight: (json['total_weight'] as num?)?.toDouble() ?? 0.0,
      totalCalories: (json['total_calories'] as num?)?.toInt() ?? 0,
      nutritionStatus: json['nutrition_status'] as String? ?? 'balanced',
      nutritionWarnings: (json['nutrition_warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionSuggestions: (json['nutrition_suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deliveryAddress: json['delivery_address'] as String?,
      preferredDeliveryTime: json['preferred_delivery_time'] == null
          ? null
          : DateTime.parse(json['preferred_delivery_time'] as String),
      deliveryMethod: json['delivery_method'] as String? ?? 'delivery',
      merchantGroups: (json['merchant_groups'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, MerchantCartGroup.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      appliedCoupons: (json['applied_coupons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NutritionCartImplToJson(_$NutritionCartImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      if (instance.profileId case final value?) 'profile_id': value,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'target_nutrition_goals': instance.targetNutritionGoals,
      'current_nutrition_totals': instance.currentNutritionTotals,
      'total_price': instance.totalPrice,
      'total_weight': instance.totalWeight,
      'total_calories': instance.totalCalories,
      'nutrition_status': instance.nutritionStatus,
      'nutrition_warnings': instance.nutritionWarnings,
      'nutrition_suggestions': instance.nutritionSuggestions,
      if (instance.deliveryAddress case final value?) 'delivery_address': value,
      if (instance.preferredDeliveryTime?.toIso8601String() case final value?)
        'preferred_delivery_time': value,
      'delivery_method': instance.deliveryMethod,
      'merchant_groups':
          instance.merchantGroups.map((k, e) => MapEntry(k, e.toJson())),
      'applied_coupons': instance.appliedCoupons,
      'discount_amount': instance.discountAmount,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$MerchantCartGroupImpl _$$MerchantCartGroupImplFromJson(
        Map<String, dynamic> json) =>
    _$MerchantCartGroupImpl(
      merchantId: json['merchant_id'] as String,
      merchantName: json['merchant_name'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => NutritionCartItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      minimumOrder: (json['minimum_order'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] as bool? ?? true,
      unavailableReason: json['unavailable_reason'] as String?,
      nutritionTotals: (json['nutrition_totals'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      totalCalories: (json['total_calories'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MerchantCartGroupImplToJson(
        _$MerchantCartGroupImpl instance) =>
    <String, dynamic>{
      'merchant_id': instance.merchantId,
      'merchant_name': instance.merchantName,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'subtotal': instance.subtotal,
      'delivery_fee': instance.deliveryFee,
      'minimum_order': instance.minimumOrder,
      'is_available': instance.isAvailable,
      if (instance.unavailableReason case final value?)
        'unavailable_reason': value,
      'nutrition_totals': instance.nutritionTotals,
      'total_calories': instance.totalCalories,
    };

_$NutritionCartItemImpl _$$NutritionCartItemImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionCartItemImpl(
      id: json['id'] as String,
      itemType: json['item_type'] as String,
      itemId: json['item_id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      merchantId: json['merchant_id'] as String,
      merchantName: json['merchant_name'] as String,
      nutritionPer100g: (json['nutrition_per100g'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalNutrition: (json['total_nutrition'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalCalories: (json['total_calories'] as num).toInt(),
      cookingMethodId: json['cooking_method_id'] as String?,
      cookingMethodName: json['cooking_method_name'] as String?,
      cookingAdjustments:
          (json['cooking_adjustments'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      customizations: (json['customizations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergenWarnings: (json['allergen_warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryTags: (json['dietary_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAvailable: json['is_available'] as bool? ?? true,
      unavailableReason: json['unavailable_reason'] as String?,
      maxAvailableQuantity:
          (json['max_available_quantity'] as num?)?.toDouble(),
      nutritionMatchScore:
          (json['nutrition_match_score'] as num?)?.toDouble() ?? 0.0,
      nutritionBenefits: (json['nutrition_benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      addedAt: DateTime.parse(json['added_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NutritionCartItemImplToJson(
        _$NutritionCartItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_type': instance.itemType,
      'item_id': instance.itemId,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      if (instance.description case final value?) 'description': value,
      if (instance.imageUrl case final value?) 'image_url': value,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'merchant_id': instance.merchantId,
      'merchant_name': instance.merchantName,
      'nutrition_per100g': instance.nutritionPer100g,
      'total_nutrition': instance.totalNutrition,
      'total_calories': instance.totalCalories,
      if (instance.cookingMethodId case final value?)
        'cooking_method_id': value,
      if (instance.cookingMethodName case final value?)
        'cooking_method_name': value,
      'cooking_adjustments': instance.cookingAdjustments,
      'customizations': instance.customizations,
      'allergen_warnings': instance.allergenWarnings,
      'dietary_tags': instance.dietaryTags,
      'is_available': instance.isAvailable,
      if (instance.unavailableReason case final value?)
        'unavailable_reason': value,
      if (instance.maxAvailableQuantity case final value?)
        'max_available_quantity': value,
      'nutrition_match_score': instance.nutritionMatchScore,
      'nutrition_benefits': instance.nutritionBenefits,
      'added_at': instance.addedAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$NutritionBalanceAnalysisImpl _$$NutritionBalanceAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionBalanceAnalysisImpl(
      cartId: json['cart_id'] as String,
      analysisTime: DateTime.parse(json['analysis_time'] as String),
      elementAnalysis: (json['element_analysis'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, NutritionElementAnalysis.fromJson(e as Map<String, dynamic>)),
      ),
      overallScore: (json['overall_score'] as num?)?.toDouble() ?? 0.0,
      overallStatus: json['overall_status'] as String? ?? 'neutral',
      improvements: (json['improvements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => RecommendedItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      calorieAnalysis: CalorieAnalysis.fromJson(
          json['calorie_analysis'] as Map<String, dynamic>),
      macroBalance: MacronutrientBalance.fromJson(
          json['macro_balance'] as Map<String, dynamic>),
      microStatus: MicronutrientStatus.fromJson(
          json['micro_status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$NutritionBalanceAnalysisImplToJson(
        _$NutritionBalanceAnalysisImpl instance) =>
    <String, dynamic>{
      'cart_id': instance.cartId,
      'analysis_time': instance.analysisTime.toIso8601String(),
      'element_analysis':
          instance.elementAnalysis.map((k, e) => MapEntry(k, e.toJson())),
      'overall_score': instance.overallScore,
      'overall_status': instance.overallStatus,
      'improvements': instance.improvements,
      'warnings': instance.warnings,
      'recommendations':
          instance.recommendations.map((e) => e.toJson()).toList(),
      'calorie_analysis': instance.calorieAnalysis.toJson(),
      'macro_balance': instance.macroBalance.toJson(),
      'micro_status': instance.microStatus.toJson(),
    };

_$NutritionElementAnalysisImpl _$$NutritionElementAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionElementAnalysisImpl(
      elementId: json['element_id'] as String,
      elementName: json['element_name'] as String,
      targetAmount: (json['target_amount'] as num).toDouble(),
      currentAmount: (json['current_amount'] as num).toDouble(),
      unit: json['unit'] as String,
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String,
      recommendation: json['recommendation'] as String?,
    );

Map<String, dynamic> _$$NutritionElementAnalysisImplToJson(
        _$NutritionElementAnalysisImpl instance) =>
    <String, dynamic>{
      'element_id': instance.elementId,
      'element_name': instance.elementName,
      'target_amount': instance.targetAmount,
      'current_amount': instance.currentAmount,
      'unit': instance.unit,
      'completion_rate': instance.completionRate,
      'status': instance.status,
      if (instance.recommendation case final value?) 'recommendation': value,
    };

_$CalorieAnalysisImpl _$$CalorieAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$CalorieAnalysisImpl(
      targetCalories: (json['target_calories'] as num).toInt(),
      currentCalories: (json['current_calories'] as num).toInt(),
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String,
      recommendedAdjustment:
          (json['recommended_adjustment'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CalorieAnalysisImplToJson(
        _$CalorieAnalysisImpl instance) =>
    <String, dynamic>{
      'target_calories': instance.targetCalories,
      'current_calories': instance.currentCalories,
      'completion_rate': instance.completionRate,
      'status': instance.status,
      'recommended_adjustment': instance.recommendedAdjustment,
    };

_$MacronutrientBalanceImpl _$$MacronutrientBalanceImplFromJson(
        Map<String, dynamic> json) =>
    _$MacronutrientBalanceImpl(
      proteinTarget: (json['protein_target'] as num).toDouble(),
      proteinCurrent: (json['protein_current'] as num).toDouble(),
      proteinPercentage:
          (json['protein_percentage'] as num?)?.toDouble() ?? 0.0,
      carbTarget: (json['carb_target'] as num).toDouble(),
      carbCurrent: (json['carb_current'] as num).toDouble(),
      carbPercentage: (json['carb_percentage'] as num?)?.toDouble() ?? 0.0,
      fatTarget: (json['fat_target'] as num).toDouble(),
      fatCurrent: (json['fat_current'] as num).toDouble(),
      fatPercentage: (json['fat_percentage'] as num?)?.toDouble() ?? 0.0,
      balanceStatus: json['balance_status'] as String,
      adjustmentSuggestions: (json['adjustment_suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MacronutrientBalanceImplToJson(
        _$MacronutrientBalanceImpl instance) =>
    <String, dynamic>{
      'protein_target': instance.proteinTarget,
      'protein_current': instance.proteinCurrent,
      'protein_percentage': instance.proteinPercentage,
      'carb_target': instance.carbTarget,
      'carb_current': instance.carbCurrent,
      'carb_percentage': instance.carbPercentage,
      'fat_target': instance.fatTarget,
      'fat_current': instance.fatCurrent,
      'fat_percentage': instance.fatPercentage,
      'balance_status': instance.balanceStatus,
      'adjustment_suggestions': instance.adjustmentSuggestions,
    };

_$MicronutrientStatusImpl _$$MicronutrientStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$MicronutrientStatusImpl(
      vitaminStatus: (json['vitamin_status'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      vitaminDeficiencies: (json['vitamin_deficiencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mineralStatus: (json['mineral_status'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      mineralDeficiencies: (json['mineral_deficiencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fiberTarget: (json['fiber_target'] as num).toDouble(),
      fiberCurrent: (json['fiber_current'] as num).toDouble(),
      fiberStatus: json['fiber_status'] as String,
      hydrationNeeds: (json['hydration_needs'] as num).toDouble(),
      estimatedHydration:
          (json['estimated_hydration'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$MicronutrientStatusImplToJson(
        _$MicronutrientStatusImpl instance) =>
    <String, dynamic>{
      'vitamin_status': instance.vitaminStatus,
      'vitamin_deficiencies': instance.vitaminDeficiencies,
      'mineral_status': instance.mineralStatus,
      'mineral_deficiencies': instance.mineralDeficiencies,
      'fiber_target': instance.fiberTarget,
      'fiber_current': instance.fiberCurrent,
      'fiber_status': instance.fiberStatus,
      'hydration_needs': instance.hydrationNeeds,
      'estimated_hydration': instance.estimatedHydration,
    };

_$RecommendedItemImpl _$$RecommendedItemImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendedItemImpl(
      itemId: json['item_id'] as String,
      itemType: json['item_type'] as String,
      name: json['name'] as String,
      reason: json['reason'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] as String?,
      nutritionBenefit:
          (json['nutrition_benefit'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      improvementScore: (json['improvement_score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$RecommendedItemImplToJson(
        _$RecommendedItemImpl instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'item_type': instance.itemType,
      'name': instance.name,
      'reason': instance.reason,
      'quantity': instance.quantity,
      if (instance.unit case final value?) 'unit': value,
      'nutrition_benefit': instance.nutritionBenefit,
      'improvement_score': instance.improvementScore,
    };

_$CartOperationImpl _$$CartOperationImplFromJson(Map<String, dynamic> json) =>
    _$CartOperationImpl(
      id: json['id'] as String,
      cartId: json['cart_id'] as String,
      operation: json['operation'] as String,
      itemId: json['item_id'] as String,
      operationData: json['operation_data'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$$CartOperationImplToJson(_$CartOperationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cart_id': instance.cartId,
      'operation': instance.operation,
      'item_id': instance.itemId,
      if (instance.operationData case final value?) 'operation_data': value,
      'timestamp': instance.timestamp.toIso8601String(),
      if (instance.userId case final value?) 'user_id': value,
    };

_$NutritionGoalTemplateImpl _$$NutritionGoalTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionGoalTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      targetGroup: json['target_group'] as String,
      nutritionTargets: (json['nutrition_targets'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      calorieTarget: (json['calorie_target'] as num).toInt(),
      recommendedFoods: (json['recommended_foods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      avoidFoods: (json['avoid_foods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$$NutritionGoalTemplateImplToJson(
        _$NutritionGoalTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'target_group': instance.targetGroup,
      'nutrition_targets': instance.nutritionTargets,
      'calorie_target': instance.calorieTarget,
      'recommended_foods': instance.recommendedFoods,
      'avoid_foods': instance.avoidFoods,
      'is_default': instance.isDefault,
    };
