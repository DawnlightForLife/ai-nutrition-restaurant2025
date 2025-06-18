// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_inventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MerchantInfoImpl _$$MerchantInfoImplFromJson(Map<String, dynamic> json) =>
    _$MerchantInfoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      businessLicense: json['business_license'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      status: json['status'] as String? ?? 'pending',
      supportedCuisineTypes: (json['supported_cuisine_types'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      certifications: (json['certifications'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      hasNutritionCertification:
          json['has_nutrition_certification'] as bool? ?? false,
      nutritionistId: json['nutritionist_id'] as String?,
      nutritionSpecializations:
          (json['nutrition_specializations'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      totalReviews: (json['total_reviews'] as num?)?.toInt() ?? 0,
      allowNutritionOrdering: json['allow_nutrition_ordering'] as bool? ?? true,
      supportedNutritionElements:
          (json['supported_nutrition_elements'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      ingredientPricingMultipliers:
          (json['ingredient_pricing_multipliers'] as Map<String, dynamic>?)
                  ?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
    );

Map<String, dynamic> _$$MerchantInfoImplToJson(_$MerchantInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      'business_license': instance.businessLicense,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'status': instance.status,
      'supported_cuisine_types': instance.supportedCuisineTypes,
      'certifications': instance.certifications,
      'specialties': instance.specialties,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      'has_nutrition_certification': instance.hasNutritionCertification,
      if (instance.nutritionistId case final value?) 'nutritionist_id': value,
      'nutrition_specializations': instance.nutritionSpecializations,
      'average_rating': instance.averageRating,
      'total_orders': instance.totalOrders,
      'total_reviews': instance.totalReviews,
      'allow_nutrition_ordering': instance.allowNutritionOrdering,
      'supported_nutrition_elements': instance.supportedNutritionElements,
      'ingredient_pricing_multipliers': instance.ingredientPricingMultipliers,
    };

_$IngredientInventoryItemImpl _$$IngredientInventoryItemImplFromJson(
        Map<String, dynamic> json) =>
    _$IngredientInventoryItemImpl(
      id: json['id'] as String,
      ingredientId: json['ingredient_id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      category: json['category'] as String,
      unit: json['unit'] as String,
      currentStock: (json['current_stock'] as num).toDouble(),
      minThreshold: (json['min_threshold'] as num).toDouble(),
      maxCapacity: (json['max_capacity'] as num).toDouble(),
      reservedStock: (json['reserved_stock'] as num?)?.toDouble() ?? 0.0,
      availableStock: (json['available_stock'] as num?)?.toDouble() ?? 0.0,
      costPerUnit: (json['cost_per_unit'] as num).toDouble(),
      sellingPricePerUnit: (json['selling_price_per_unit'] as num).toDouble(),
      profitMargin: (json['profit_margin'] as num?)?.toDouble() ?? 1.0,
      nutritionPer100g: (json['nutrition_per100g'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      supplierId: json['supplier_id'] as String?,
      supplierName: json['supplier_name'] as String?,
      lastRestockDate: json['last_restock_date'] == null
          ? null
          : DateTime.parse(json['last_restock_date'] as String),
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      qualityStatus: json['quality_status'] as String? ?? 'fresh',
      isAvailableForOrdering:
          json['is_available_for_ordering'] as bool? ?? true,
      restrictedCookingMethods:
          (json['restricted_cooking_methods'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      allergenWarnings: (json['allergen_warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$IngredientInventoryItemImplToJson(
        _$IngredientInventoryItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ingredient_id': instance.ingredientId,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      'category': instance.category,
      'unit': instance.unit,
      'current_stock': instance.currentStock,
      'min_threshold': instance.minThreshold,
      'max_capacity': instance.maxCapacity,
      'reserved_stock': instance.reservedStock,
      'available_stock': instance.availableStock,
      'cost_per_unit': instance.costPerUnit,
      'selling_price_per_unit': instance.sellingPricePerUnit,
      'profit_margin': instance.profitMargin,
      'nutrition_per100g': instance.nutritionPer100g,
      if (instance.supplierId case final value?) 'supplier_id': value,
      if (instance.supplierName case final value?) 'supplier_name': value,
      if (instance.lastRestockDate?.toIso8601String() case final value?)
        'last_restock_date': value,
      if (instance.expiryDate?.toIso8601String() case final value?)
        'expiry_date': value,
      'quality_status': instance.qualityStatus,
      'is_available_for_ordering': instance.isAvailableForOrdering,
      'restricted_cooking_methods': instance.restrictedCookingMethods,
      'allergen_warnings': instance.allergenWarnings,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$CookingMethodConfigImpl _$$CookingMethodConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$CookingMethodConfigImpl(
      id: json['id'] as String,
      cookingMethodId: json['cooking_method_id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      preparationTimeMinutes: (json['preparation_time_minutes'] as num).toInt(),
      cookingTimeMinutes: (json['cooking_time_minutes'] as num).toInt(),
      requiredEquipment: (json['required_equipment'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      skillLevelRequired: (json['skill_level_required'] as num?)?.toInt() ?? 1,
      laborCostMultiplier:
          (json['labor_cost_multiplier'] as num?)?.toDouble() ?? 1.0,
      nutritionRetentionRates:
          (json['nutrition_retention_rates'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      nutritionEnhancements:
          (json['nutrition_enhancements'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      preparationCostMultiplier:
          (json['preparation_cost_multiplier'] as num?)?.toDouble() ?? 1.0,
      additionalFixedCost:
          (json['additional_fixed_cost'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] as bool? ?? true,
      compatibleIngredientCategories:
          (json['compatible_ingredient_categories'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      incompatibleIngredients:
          (json['incompatible_ingredients'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CookingMethodConfigImplToJson(
        _$CookingMethodConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cooking_method_id': instance.cookingMethodId,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      'preparation_time_minutes': instance.preparationTimeMinutes,
      'cooking_time_minutes': instance.cookingTimeMinutes,
      'required_equipment': instance.requiredEquipment,
      'skill_level_required': instance.skillLevelRequired,
      'labor_cost_multiplier': instance.laborCostMultiplier,
      'nutrition_retention_rates': instance.nutritionRetentionRates,
      'nutrition_enhancements': instance.nutritionEnhancements,
      'preparation_cost_multiplier': instance.preparationCostMultiplier,
      'additional_fixed_cost': instance.additionalFixedCost,
      'is_available': instance.isAvailable,
      'compatible_ingredient_categories':
          instance.compatibleIngredientCategories,
      'incompatible_ingredients': instance.incompatibleIngredients,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$NutritionBasedDishImpl _$$NutritionBasedDishImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionBasedDishImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      description: json['description'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => DishIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      cookingMethods: (json['cooking_methods'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalNutritionPer100g:
          (json['total_nutrition_per100g'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalCaloriesPer100g: (json['total_calories_per100g'] as num).toDouble(),
      recommendedServingSize:
          (json['recommended_serving_size'] as num).toDouble(),
      basePrice: (json['base_price'] as num).toDouble(),
      calculatedCost: (json['calculated_cost'] as num).toDouble(),
      profitMargin: (json['profit_margin'] as num?)?.toDouble() ?? 0.3,
      targetNutritionGoals: (json['target_nutrition_goals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      suitableForConditions: (json['suitable_for_conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergenWarnings: (json['allergen_warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      preparationTimeMinutes:
          (json['preparation_time_minutes'] as num?)?.toInt() ?? 0,
      difficultyLevel: (json['difficulty_level'] as num?)?.toInt() ?? 1,
      isAvailable: json['is_available'] as bool? ?? true,
      popularityScore: (json['popularity_score'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NutritionBasedDishImplToJson(
        _$NutritionBasedDishImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      if (instance.description case final value?) 'description': value,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'cooking_methods': instance.cookingMethods,
      'total_nutrition_per100g': instance.totalNutritionPer100g,
      'total_calories_per100g': instance.totalCaloriesPer100g,
      'recommended_serving_size': instance.recommendedServingSize,
      'base_price': instance.basePrice,
      'calculated_cost': instance.calculatedCost,
      'profit_margin': instance.profitMargin,
      'target_nutrition_goals': instance.targetNutritionGoals,
      'suitable_for_conditions': instance.suitableForConditions,
      'allergen_warnings': instance.allergenWarnings,
      'preparation_time_minutes': instance.preparationTimeMinutes,
      'difficulty_level': instance.difficultyLevel,
      'is_available': instance.isAvailable,
      'popularity_score': instance.popularityScore,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$DishIngredientImpl _$$DishIngredientImplFromJson(Map<String, dynamic> json) =>
    _$DishIngredientImpl(
      ingredientId: json['ingredient_id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      cookingMethodId: json['cooking_method_id'] as String,
      isOptional: json['is_optional'] as bool? ?? false,
      substitutes: (json['substitutes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DishIngredientImplToJson(
        _$DishIngredientImpl instance) =>
    <String, dynamic>{
      'ingredient_id': instance.ingredientId,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'cooking_method_id': instance.cookingMethodId,
      'is_optional': instance.isOptional,
      'substitutes': instance.substitutes,
    };

_$InventoryTransactionImpl _$$InventoryTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryTransactionImpl(
      id: json['id'] as String,
      ingredientId: json['ingredient_id'] as String,
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      reason: json['reason'] as String?,
      orderId: json['order_id'] as String?,
      supplierId: json['supplier_id'] as String?,
      costPerUnit: (json['cost_per_unit'] as num).toDouble(),
      operatorId: json['operator_id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      stockBefore: (json['stock_before'] as num).toDouble(),
      stockAfter: (json['stock_after'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$InventoryTransactionImplToJson(
        _$InventoryTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ingredient_id': instance.ingredientId,
      'type': instance.type,
      'quantity': instance.quantity,
      'unit': instance.unit,
      if (instance.reason case final value?) 'reason': value,
      if (instance.orderId case final value?) 'order_id': value,
      if (instance.supplierId case final value?) 'supplier_id': value,
      'cost_per_unit': instance.costPerUnit,
      'operator_id': instance.operatorId,
      'timestamp': instance.timestamp.toIso8601String(),
      'stock_before': instance.stockBefore,
      'stock_after': instance.stockAfter,
      if (instance.metadata case final value?) 'metadata': value,
    };

_$InventoryAlertImpl _$$InventoryAlertImplFromJson(Map<String, dynamic> json) =>
    _$InventoryAlertImpl(
      id: json['id'] as String,
      ingredientId: json['ingredient_id'] as String,
      ingredientName: json['ingredient_name'] as String,
      alertType: json['alert_type'] as String,
      severity: json['severity'] as String,
      message: json['message'] as String,
      isResolved: json['is_resolved'] as bool? ?? false,
      resolvedBy: json['resolved_by'] as String?,
      resolvedAt: json['resolved_at'] == null
          ? null
          : DateTime.parse(json['resolved_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      currentStock: (json['current_stock'] as num?)?.toDouble(),
      threshold: (json['threshold'] as num?)?.toDouble(),
      expiryDate: json['expiry_date'] == null
          ? null
          : DateTime.parse(json['expiry_date'] as String),
      qualityStatus: json['quality_status'] as String?,
    );

Map<String, dynamic> _$$InventoryAlertImplToJson(
        _$InventoryAlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ingredient_id': instance.ingredientId,
      'ingredient_name': instance.ingredientName,
      'alert_type': instance.alertType,
      'severity': instance.severity,
      'message': instance.message,
      'is_resolved': instance.isResolved,
      if (instance.resolvedBy case final value?) 'resolved_by': value,
      if (instance.resolvedAt?.toIso8601String() case final value?)
        'resolved_at': value,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.currentStock case final value?) 'current_stock': value,
      if (instance.threshold case final value?) 'threshold': value,
      if (instance.expiryDate?.toIso8601String() case final value?)
        'expiry_date': value,
      if (instance.qualityStatus case final value?) 'quality_status': value,
    };

_$NutritionMenuAnalysisImpl _$$NutritionMenuAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionMenuAnalysisImpl(
      merchantId: json['merchant_id'] as String,
      analysisDate: DateTime.parse(json['analysis_date'] as String),
      nutritionElementCoverage:
          (json['nutrition_element_coverage'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      missingNutritionElements:
          (json['missing_nutrition_elements'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      overrepresentedElements:
          (json['overrepresented_elements'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      averageCostPerCalorie:
          (json['average_cost_per_calorie'] as num).toDouble(),
      averageCostPerProteinGram:
          (json['average_cost_per_protein_gram'] as num).toDouble(),
      costEfficiencyByCategory:
          (json['cost_efficiency_by_category'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      recommendedIngredients: (json['recommended_ingredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      costOptimizationSuggestions:
          (json['cost_optimization_suggestions'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      nutritionBalanceSuggestions:
          (json['nutrition_balance_suggestions'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      competitivenessScore:
          (json['competitiveness_score'] as num?)?.toDouble() ?? 0.0,
      marketOpportunities: (json['market_opportunities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$NutritionMenuAnalysisImplToJson(
        _$NutritionMenuAnalysisImpl instance) =>
    <String, dynamic>{
      'merchant_id': instance.merchantId,
      'analysis_date': instance.analysisDate.toIso8601String(),
      'nutrition_element_coverage': instance.nutritionElementCoverage,
      'missing_nutrition_elements': instance.missingNutritionElements,
      'overrepresented_elements': instance.overrepresentedElements,
      'average_cost_per_calorie': instance.averageCostPerCalorie,
      'average_cost_per_protein_gram': instance.averageCostPerProteinGram,
      'cost_efficiency_by_category': instance.costEfficiencyByCategory,
      'recommended_ingredients': instance.recommendedIngredients,
      'cost_optimization_suggestions': instance.costOptimizationSuggestions,
      'nutrition_balance_suggestions': instance.nutritionBalanceSuggestions,
      'competitiveness_score': instance.competitivenessScore,
      'market_opportunities': instance.marketOpportunities,
    };
