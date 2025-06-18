// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionOrderImpl _$$NutritionOrderImplFromJson(Map<String, dynamic> json) =>
    _$NutritionOrderImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      profileId: json['profile_id'] as String?,
      cartId: json['cart_id'] as String?,
      orderNumber: json['order_number'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      estimatedDeliveryTime: json['estimated_delivery_time'] == null
          ? null
          : DateTime.parse(json['estimated_delivery_time'] as String),
      actualDeliveryTime: json['actual_delivery_time'] == null
          ? null
          : DateTime.parse(json['actual_delivery_time'] as String),
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      cancellationReason: json['cancellation_reason'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => NutritionOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalNutrition: (json['total_nutrition'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalCalories: (json['total_calories'] as num).toInt(),
      totalWeight: (json['total_weight'] as num).toDouble(),
      nutritionAnalysis: NutritionOrderAnalysis.fromJson(
          json['nutrition_analysis'] as Map<String, dynamic>),
      merchantGroups: (json['merchant_groups'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, MerchantOrderGroup.fromJson(e as Map<String, dynamic>)),
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      appliedCoupons: (json['applied_coupons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deliveryMethod: json['delivery_method'] as String,
      deliveryAddress: json['delivery_address'] as String,
      deliveryContact: json['delivery_contact'] as String?,
      deliveryPhone: json['delivery_phone'] as String?,
      deliveryNotes: json['delivery_notes'] as String?,
      deliveryLocation:
          (json['delivery_location'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      paymentMethod: json['payment_method'] as String?,
      paymentId: json['payment_id'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      nutritionGoals: (json['nutrition_goals'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      nutritionMatchScore:
          (json['nutrition_match_score'] as num?)?.toDouble() ?? 0.0,
      nutritionWarnings: (json['nutrition_warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionBenefits: (json['nutrition_benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryRequirements: (json['dietary_requirements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergenAlerts: (json['allergen_alerts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      specialInstructions: json['special_instructions'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      review: json['review'] as String?,
      reviewedAt: json['reviewed_at'] == null
          ? null
          : DateTime.parse(json['reviewed_at'] as String),
      nutritionFeedback:
          (json['nutrition_feedback'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      assignedDeliveryDriver: json['assigned_delivery_driver'] as String?,
      trackingId: json['tracking_id'] as String?,
      statusHistory: (json['status_history'] as List<dynamic>?)
              ?.map(
                  (e) => OrderStatusUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NutritionOrderImplToJson(
        _$NutritionOrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      if (instance.profileId case final value?) 'profile_id': value,
      if (instance.cartId case final value?) 'cart_id': value,
      'order_number': instance.orderNumber,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.confirmedAt?.toIso8601String() case final value?)
        'confirmed_at': value,
      if (instance.estimatedDeliveryTime?.toIso8601String() case final value?)
        'estimated_delivery_time': value,
      if (instance.actualDeliveryTime?.toIso8601String() case final value?)
        'actual_delivery_time': value,
      if (instance.cancelledAt?.toIso8601String() case final value?)
        'cancelled_at': value,
      if (instance.cancellationReason case final value?)
        'cancellation_reason': value,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total_nutrition': instance.totalNutrition,
      'total_calories': instance.totalCalories,
      'total_weight': instance.totalWeight,
      'nutrition_analysis': instance.nutritionAnalysis.toJson(),
      'merchant_groups':
          instance.merchantGroups.map((k, e) => MapEntry(k, e.toJson())),
      'subtotal': instance.subtotal,
      'delivery_fee': instance.deliveryFee,
      'discount_amount': instance.discountAmount,
      'tax_amount': instance.taxAmount,
      'total_amount': instance.totalAmount,
      'applied_coupons': instance.appliedCoupons,
      'delivery_method': instance.deliveryMethod,
      'delivery_address': instance.deliveryAddress,
      if (instance.deliveryContact case final value?) 'delivery_contact': value,
      if (instance.deliveryPhone case final value?) 'delivery_phone': value,
      if (instance.deliveryNotes case final value?) 'delivery_notes': value,
      'delivery_location': instance.deliveryLocation,
      if (instance.paymentMethod case final value?) 'payment_method': value,
      if (instance.paymentId case final value?) 'payment_id': value,
      if (instance.paymentStatus case final value?) 'payment_status': value,
      if (instance.paidAt?.toIso8601String() case final value?)
        'paid_at': value,
      'nutrition_goals': instance.nutritionGoals,
      'nutrition_match_score': instance.nutritionMatchScore,
      'nutrition_warnings': instance.nutritionWarnings,
      'nutrition_benefits': instance.nutritionBenefits,
      'dietary_requirements': instance.dietaryRequirements,
      'allergen_alerts': instance.allergenAlerts,
      if (instance.specialInstructions case final value?)
        'special_instructions': value,
      if (instance.rating case final value?) 'rating': value,
      if (instance.review case final value?) 'review': value,
      if (instance.reviewedAt?.toIso8601String() case final value?)
        'reviewed_at': value,
      'nutrition_feedback': instance.nutritionFeedback,
      if (instance.assignedDeliveryDriver case final value?)
        'assigned_delivery_driver': value,
      if (instance.trackingId case final value?) 'tracking_id': value,
      'status_history': instance.statusHistory.map((e) => e.toJson()).toList(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

_$NutritionOrderItemImpl _$$NutritionOrderItemImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionOrderItemImpl(
      id: json['id'] as String,
      itemType: json['item_type'] as String,
      itemId: json['item_id'] as String,
      name: json['name'] as String,
      chineseName: json['chinese_name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      merchantId: json['merchant_id'] as String,
      merchantName: json['merchant_name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
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
      cookingInstructions: json['cooking_instructions'] as String?,
      cookingLevel: json['cooking_level'] as String? ?? 'standard',
      customizations: (json['customizations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      addOns: (json['add_ons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      removedIngredients: (json['removed_ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionTags: (json['nutrition_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dietaryTags: (json['dietary_tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      allergenWarnings: (json['allergen_warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: json['status'] as String,
      preparedAt: json['prepared_at'] == null
          ? null
          : DateTime.parse(json['prepared_at'] as String),
      preparationNotes: json['preparation_notes'] as String?,
      nutritionMatchScore:
          (json['nutrition_match_score'] as num?)?.toDouble() ?? 0.0,
      nutritionBenefits: (json['nutrition_benefits'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      addedAt: DateTime.parse(json['added_at'] as String),
    );

Map<String, dynamic> _$$NutritionOrderItemImplToJson(
        _$NutritionOrderItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_type': instance.itemType,
      'item_id': instance.itemId,
      'name': instance.name,
      'chinese_name': instance.chineseName,
      if (instance.description case final value?) 'description': value,
      if (instance.imageUrl case final value?) 'image_url': value,
      'merchant_id': instance.merchantId,
      'merchant_name': instance.merchantName,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'nutrition_per100g': instance.nutritionPer100g,
      'total_nutrition': instance.totalNutrition,
      'total_calories': instance.totalCalories,
      if (instance.cookingMethodId case final value?)
        'cooking_method_id': value,
      if (instance.cookingMethodName case final value?)
        'cooking_method_name': value,
      'cooking_adjustments': instance.cookingAdjustments,
      if (instance.cookingInstructions case final value?)
        'cooking_instructions': value,
      'cooking_level': instance.cookingLevel,
      'customizations': instance.customizations,
      'add_ons': instance.addOns,
      'removed_ingredients': instance.removedIngredients,
      'nutrition_tags': instance.nutritionTags,
      'dietary_tags': instance.dietaryTags,
      'allergen_warnings': instance.allergenWarnings,
      'status': instance.status,
      if (instance.preparedAt?.toIso8601String() case final value?)
        'prepared_at': value,
      if (instance.preparationNotes case final value?)
        'preparation_notes': value,
      'nutrition_match_score': instance.nutritionMatchScore,
      'nutrition_benefits': instance.nutritionBenefits,
      'added_at': instance.addedAt.toIso8601String(),
    };

_$MerchantOrderGroupImpl _$$MerchantOrderGroupImplFromJson(
        Map<String, dynamic> json) =>
    _$MerchantOrderGroupImpl(
      merchantId: json['merchant_id'] as String,
      merchantName: json['merchant_name'] as String,
      merchantPhone: json['merchant_phone'] as String?,
      merchantAddress: json['merchant_address'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((e) => NutritionOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      merchantDiscount: (json['merchant_discount'] as num).toDouble(),
      estimatedPrepTime: (json['estimated_prep_time'] as num).toInt(),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
      readyAt: json['ready_at'] == null
          ? null
          : DateTime.parse(json['ready_at'] as String),
      status: json['status'] as String,
      statusNotes: (json['status_notes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionTotals: (json['nutrition_totals'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      totalCalories: (json['total_calories'] as num).toInt(),
      merchantNotes: (json['merchant_notes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      kitchenInstructions: json['kitchen_instructions'] as String?,
    );

Map<String, dynamic> _$$MerchantOrderGroupImplToJson(
        _$MerchantOrderGroupImpl instance) =>
    <String, dynamic>{
      'merchant_id': instance.merchantId,
      'merchant_name': instance.merchantName,
      if (instance.merchantPhone case final value?) 'merchant_phone': value,
      if (instance.merchantAddress case final value?) 'merchant_address': value,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'subtotal': instance.subtotal,
      'delivery_fee': instance.deliveryFee,
      'merchant_discount': instance.merchantDiscount,
      'estimated_prep_time': instance.estimatedPrepTime,
      if (instance.confirmedAt?.toIso8601String() case final value?)
        'confirmed_at': value,
      if (instance.readyAt?.toIso8601String() case final value?)
        'ready_at': value,
      'status': instance.status,
      'status_notes': instance.statusNotes,
      'nutrition_totals': instance.nutritionTotals,
      'total_calories': instance.totalCalories,
      'merchant_notes': instance.merchantNotes,
      if (instance.kitchenInstructions case final value?)
        'kitchen_instructions': value,
    };

_$NutritionOrderAnalysisImpl _$$NutritionOrderAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionOrderAnalysisImpl(
      orderId: json['order_id'] as String,
      analysisTime: DateTime.parse(json['analysis_time'] as String),
      elementAnalysis: (json['element_analysis'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k, NutritionElementAnalysis.fromJson(e as Map<String, dynamic>)),
      ),
      overallNutritionScore:
          (json['overall_nutrition_score'] as num?)?.toDouble() ?? 0.0,
      nutritionStatus: json['nutrition_status'] as String? ?? 'neutral',
      mealType: json['meal_type'] as String,
      mealAppropriatenessScore:
          (json['meal_appropriateness_score'] as num?)?.toDouble() ?? 0.0,
      mealRecommendations: (json['meal_recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      calorieAnalysis: CalorieAnalysis.fromJson(
          json['calorie_analysis'] as Map<String, dynamic>),
      macroAnalysis: MacronutrientAnalysis.fromJson(
          json['macro_analysis'] as Map<String, dynamic>),
      microAnalysis: MicronutrientAnalysis.fromJson(
          json['micro_analysis'] as Map<String, dynamic>),
      balanceScore: (json['balance_score'] as num?)?.toDouble() ?? 0.0,
      balanceWarnings: (json['balance_warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      balanceStrengths: (json['balance_strengths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      healthSuggestions: (json['health_suggestions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nextMealRecommendations:
          (json['next_meal_recommendations'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      longTermNutritionImpact:
          (json['long_term_nutrition_impact'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
    );

Map<String, dynamic> _$$NutritionOrderAnalysisImplToJson(
        _$NutritionOrderAnalysisImpl instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'analysis_time': instance.analysisTime.toIso8601String(),
      'element_analysis':
          instance.elementAnalysis.map((k, e) => MapEntry(k, e.toJson())),
      'overall_nutrition_score': instance.overallNutritionScore,
      'nutrition_status': instance.nutritionStatus,
      'meal_type': instance.mealType,
      'meal_appropriateness_score': instance.mealAppropriatenessScore,
      'meal_recommendations': instance.mealRecommendations,
      'calorie_analysis': instance.calorieAnalysis.toJson(),
      'macro_analysis': instance.macroAnalysis.toJson(),
      'micro_analysis': instance.microAnalysis.toJson(),
      'balance_score': instance.balanceScore,
      'balance_warnings': instance.balanceWarnings,
      'balance_strengths': instance.balanceStrengths,
      'health_suggestions': instance.healthSuggestions,
      'next_meal_recommendations': instance.nextMealRecommendations,
      'long_term_nutrition_impact': instance.longTermNutritionImpact,
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
      mealTypeSuitability: json['meal_type_suitability'] as String? ?? '',
    );

Map<String, dynamic> _$$CalorieAnalysisImplToJson(
        _$CalorieAnalysisImpl instance) =>
    <String, dynamic>{
      'target_calories': instance.targetCalories,
      'current_calories': instance.currentCalories,
      'completion_rate': instance.completionRate,
      'status': instance.status,
      'recommended_adjustment': instance.recommendedAdjustment,
      'meal_type_suitability': instance.mealTypeSuitability,
    };

_$MacronutrientAnalysisImpl _$$MacronutrientAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$MacronutrientAnalysisImpl(
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
      balanceScore: (json['balance_score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$MacronutrientAnalysisImplToJson(
        _$MacronutrientAnalysisImpl instance) =>
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
      'balance_score': instance.balanceScore,
    };

_$MicronutrientAnalysisImpl _$$MicronutrientAnalysisImplFromJson(
        Map<String, dynamic> json) =>
    _$MicronutrientAnalysisImpl(
      vitaminStatus: (json['vitamin_status'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      vitaminDeficiencies: (json['vitamin_deficiencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      vitaminExcesses: (json['vitamin_excesses'] as List<dynamic>?)
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
      mineralExcesses: (json['mineral_excesses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      fiberTarget: (json['fiber_target'] as num).toDouble(),
      fiberCurrent: (json['fiber_current'] as num).toDouble(),
      fiberStatus: json['fiber_status'] as String,
      antioxidantScore: (json['antioxidant_score'] as num?)?.toDouble() ?? 0.0,
      antioxidantSources: (json['antioxidant_sources'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      micronutrientScore:
          (json['micronutrient_score'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$MicronutrientAnalysisImplToJson(
        _$MicronutrientAnalysisImpl instance) =>
    <String, dynamic>{
      'vitamin_status': instance.vitaminStatus,
      'vitamin_deficiencies': instance.vitaminDeficiencies,
      'vitamin_excesses': instance.vitaminExcesses,
      'mineral_status': instance.mineralStatus,
      'mineral_deficiencies': instance.mineralDeficiencies,
      'mineral_excesses': instance.mineralExcesses,
      'fiber_target': instance.fiberTarget,
      'fiber_current': instance.fiberCurrent,
      'fiber_status': instance.fiberStatus,
      'antioxidant_score': instance.antioxidantScore,
      'antioxidant_sources': instance.antioxidantSources,
      'micronutrient_score': instance.micronutrientScore,
    };

_$OrderStatusUpdateImpl _$$OrderStatusUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$OrderStatusUpdateImpl(
      id: json['id'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      operatorId: json['operator_id'] as String?,
      operatorName: json['operator_name'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$OrderStatusUpdateImplToJson(
        _$OrderStatusUpdateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      if (instance.operatorId case final value?) 'operator_id': value,
      if (instance.operatorName case final value?) 'operator_name': value,
      'metadata': instance.metadata,
    };

_$DeliveryInfoImpl _$$DeliveryInfoImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryInfoImpl(
      orderId: json['order_id'] as String,
      method: json['method'] as String,
      address: json['address'] as String,
      location: (json['location'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      contact: json['contact'] as String?,
      phone: json['phone'] as String?,
      notes: json['notes'] as String?,
      estimatedTime: json['estimated_time'] == null
          ? null
          : DateTime.parse(json['estimated_time'] as String),
      actualTime: json['actual_time'] == null
          ? null
          : DateTime.parse(json['actual_time'] as String),
      estimatedDuration: (json['estimated_duration'] as num?)?.toInt() ?? 0,
      driverId: json['driver_id'] as String?,
      driverName: json['driver_name'] as String?,
      driverPhone: json['driver_phone'] as String?,
      vehicleInfo: json['vehicle_info'] as String?,
      status: json['status'] as String,
      statusHistory: (json['status_history'] as List<dynamic>?)
              ?.map((e) =>
                  DeliveryStatusUpdate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      tip: (json['tip'] as num?)?.toDouble() ?? 0.0,
      deliveryInstructions: (json['delivery_instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      accessCode: json['access_code'] as String?,
      buildingInfo: json['building_info'] as String?,
    );

Map<String, dynamic> _$$DeliveryInfoImplToJson(_$DeliveryInfoImpl instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'method': instance.method,
      'address': instance.address,
      'location': instance.location,
      if (instance.contact case final value?) 'contact': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.notes case final value?) 'notes': value,
      if (instance.estimatedTime?.toIso8601String() case final value?)
        'estimated_time': value,
      if (instance.actualTime?.toIso8601String() case final value?)
        'actual_time': value,
      'estimated_duration': instance.estimatedDuration,
      if (instance.driverId case final value?) 'driver_id': value,
      if (instance.driverName case final value?) 'driver_name': value,
      if (instance.driverPhone case final value?) 'driver_phone': value,
      if (instance.vehicleInfo case final value?) 'vehicle_info': value,
      'status': instance.status,
      'status_history': instance.statusHistory.map((e) => e.toJson()).toList(),
      'delivery_fee': instance.deliveryFee,
      'tip': instance.tip,
      'delivery_instructions': instance.deliveryInstructions,
      if (instance.accessCode case final value?) 'access_code': value,
      if (instance.buildingInfo case final value?) 'building_info': value,
    };

_$DeliveryStatusUpdateImpl _$$DeliveryStatusUpdateImplFromJson(
        Map<String, dynamic> json) =>
    _$DeliveryStatusUpdateImpl(
      id: json['id'] as String,
      status: json['status'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      location: (json['location'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      message: json['message'] as String?,
      photoUrl: json['photo_url'] as String?,
    );

Map<String, dynamic> _$$DeliveryStatusUpdateImplToJson(
        _$DeliveryStatusUpdateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'timestamp': instance.timestamp.toIso8601String(),
      'location': instance.location,
      if (instance.message case final value?) 'message': value,
      if (instance.photoUrl case final value?) 'photo_url': value,
    };

_$PaymentInfoImpl _$$PaymentInfoImplFromJson(Map<String, dynamic> json) =>
    _$PaymentInfoImpl(
      orderId: json['order_id'] as String,
      paymentId: json['payment_id'] as String,
      method: json['method'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      refundedAmount: (json['refunded_amount'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      refundedAt: json['refunded_at'] == null
          ? null
          : DateTime.parse(json['refunded_at'] as String),
      transactionId: json['transaction_id'] as String?,
      platformPaymentId: json['platform_payment_id'] as String?,
      platformResponse:
          json['platform_response'] as Map<String, dynamic>? ?? const {},
      refundReason: json['refund_reason'] as String?,
      refundHistory: (json['refund_history'] as List<dynamic>?)
              ?.map((e) => RefundRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      needInvoice: json['need_invoice'] as bool?,
      invoiceTitle: json['invoice_title'] as String?,
      invoiceType: json['invoice_type'] as String?,
      invoiceTaxId: json['invoice_tax_id'] as String?,
      invoiceEmail: json['invoice_email'] as String?,
    );

Map<String, dynamic> _$$PaymentInfoImplToJson(_$PaymentInfoImpl instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'payment_id': instance.paymentId,
      'method': instance.method,
      'status': instance.status,
      'amount': instance.amount,
      'currency': instance.currency,
      'refunded_amount': instance.refundedAmount,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.paidAt?.toIso8601String() case final value?)
        'paid_at': value,
      if (instance.refundedAt?.toIso8601String() case final value?)
        'refunded_at': value,
      if (instance.transactionId case final value?) 'transaction_id': value,
      if (instance.platformPaymentId case final value?)
        'platform_payment_id': value,
      'platform_response': instance.platformResponse,
      if (instance.refundReason case final value?) 'refund_reason': value,
      'refund_history': instance.refundHistory.map((e) => e.toJson()).toList(),
      if (instance.needInvoice case final value?) 'need_invoice': value,
      if (instance.invoiceTitle case final value?) 'invoice_title': value,
      if (instance.invoiceType case final value?) 'invoice_type': value,
      if (instance.invoiceTaxId case final value?) 'invoice_tax_id': value,
      if (instance.invoiceEmail case final value?) 'invoice_email': value,
    };

_$RefundRecordImpl _$$RefundRecordImplFromJson(Map<String, dynamic> json) =>
    _$RefundRecordImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
      operatorId: json['operator_id'] as String?,
      platformRefundId: json['platform_refund_id'] as String?,
    );

Map<String, dynamic> _$$RefundRecordImplToJson(_$RefundRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'reason': instance.reason,
      'timestamp': instance.timestamp.toIso8601String(),
      'status': instance.status,
      if (instance.operatorId case final value?) 'operator_id': value,
      if (instance.platformRefundId case final value?)
        'platform_refund_id': value,
    };

_$OrderReviewImpl _$$OrderReviewImplFromJson(Map<String, dynamic> json) =>
    _$OrderReviewImpl(
      orderId: json['order_id'] as String,
      userId: json['user_id'] as String,
      overallRating: (json['overall_rating'] as num).toDouble(),
      foodQualityRating: (json['food_quality_rating'] as num).toDouble(),
      deliveryRating: (json['delivery_rating'] as num).toDouble(),
      serviceRating: (json['service_rating'] as num).toDouble(),
      nutritionSatisfactionRating:
          (json['nutrition_satisfaction_rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionFeedback:
          (json['nutrition_feedback'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toDouble()),
              ) ??
              const {},
      nutritionComments: (json['nutrition_comments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      achievedNutritionGoals: json['achieved_nutrition_goals'] as bool?,
      merchantRatings: (json['merchant_ratings'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      merchantComments:
          (json['merchant_comments'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as String),
              ) ??
              const {},
      improvementSuggestions:
          (json['improvement_suggestions'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
      wouldRecommendReasons: (json['would_recommend_reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isVerified: json['is_verified'] as bool? ?? false,
      isPublic: json['is_public'] as bool? ?? false,
      helpfulVotes: (json['helpful_votes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$OrderReviewImplToJson(_$OrderReviewImpl instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'user_id': instance.userId,
      'overall_rating': instance.overallRating,
      'food_quality_rating': instance.foodQualityRating,
      'delivery_rating': instance.deliveryRating,
      'service_rating': instance.serviceRating,
      'nutrition_satisfaction_rating': instance.nutritionSatisfactionRating,
      if (instance.comment case final value?) 'comment': value,
      'tags': instance.tags,
      'photos': instance.photos,
      'nutrition_feedback': instance.nutritionFeedback,
      'nutrition_comments': instance.nutritionComments,
      if (instance.achievedNutritionGoals case final value?)
        'achieved_nutrition_goals': value,
      'merchant_ratings': instance.merchantRatings,
      'merchant_comments': instance.merchantComments,
      'improvement_suggestions': instance.improvementSuggestions,
      'would_recommend_reasons': instance.wouldRecommendReasons,
      'created_at': instance.createdAt.toIso8601String(),
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
      'is_verified': instance.isVerified,
      'is_public': instance.isPublic,
      'helpful_votes': instance.helpfulVotes,
    };
