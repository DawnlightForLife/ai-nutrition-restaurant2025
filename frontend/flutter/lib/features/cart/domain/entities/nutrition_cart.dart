/**
 * 营养购物车领域实体
 * 基于营养元素的革命性购物车系统
 */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_cart.freezed.dart';
part 'nutrition_cart.g.dart';

/// 营养购物车
@freezed
class NutritionCart with _$NutritionCart {
  const factory NutritionCart({
    required String id,
    required String userId,
    String? profileId, // 关联的营养档案
    @Default([]) List<NutritionCartItem> items,
    @Default({}) Map<String, double> targetNutritionGoals, // 目标营养摄入
    @Default({}) Map<String, double> currentNutritionTotals, // 当前营养总量
    @Default(0.0) double totalPrice,
    @Default(0.0) double totalWeight,
    @Default(0) int totalCalories,
    
    // 营养平衡状态
    @Default('balanced') String nutritionStatus, // balanced, under, over, imbalanced
    @Default([]) List<String> nutritionWarnings,
    @Default([]) List<String> nutritionSuggestions,
    
    // 配送信息
    String? deliveryAddress,
    DateTime? preferredDeliveryTime,
    @Default('delivery') String deliveryMethod, // delivery, pickup
    
    // 商家信息（支持多商家订单）
    @Default({}) Map<String, MerchantCartGroup> merchantGroups,
    
    // 优惠信息
    @Default([]) List<String> appliedCoupons,
    @Default(0.0) double discountAmount,
    
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NutritionCart;

  factory NutritionCart.fromJson(Map<String, dynamic> json) =>
      _$NutritionCartFromJson(json);
}

/// 购物车商家分组
@freezed
class MerchantCartGroup with _$MerchantCartGroup {
  const factory MerchantCartGroup({
    required String merchantId,
    required String merchantName,
    @Default([]) List<NutritionCartItem> items,
    @Default(0.0) double subtotal,
    @Default(0.0) double deliveryFee,
    @Default(0.0) double minimumOrder,
    @Default(true) bool isAvailable,
    String? unavailableReason,
    
    // 营养统计
    @Default({}) Map<String, double> nutritionTotals,
    @Default(0) int totalCalories,
  }) = _MerchantCartGroup;

  factory MerchantCartGroup.fromJson(Map<String, dynamic> json) =>
      _$MerchantCartGroupFromJson(json);
}

/// 营养购物车项目
@freezed
class NutritionCartItem with _$NutritionCartItem {
  const factory NutritionCartItem({
    required String id,
    required String itemType, // ingredient, dish, custom_meal
    required String itemId,
    required String name,
    required String chineseName,
    String? description,
    String? imageUrl,
    
    // 数量和单位
    required double quantity,
    required String unit,
    required double unitPrice,
    @Default(0.0) double totalPrice,
    
    // 商家信息
    required String merchantId,
    required String merchantName,
    
    // 营养信息（按实际重量计算）
    required Map<String, double> nutritionPer100g,
    required Map<String, double> totalNutrition,
    required int totalCalories,
    
    // 烹饪方式（如果适用）
    String? cookingMethodId,
    String? cookingMethodName,
    @Default({}) Map<String, double> cookingAdjustments, // 烹饪对营养的影响
    
    // 定制选项
    @Default([]) List<String> customizations,
    @Default([]) List<String> allergenWarnings,
    @Default([]) List<String> dietaryTags, // vegetarian, vegan, gluten-free等
    
    // 库存状态
    @Default(true) bool isAvailable,
    String? unavailableReason,
    double? maxAvailableQuantity,
    
    // 营养目标匹配度
    @Default(0.0) double nutritionMatchScore, // 0-1，与用户营养目标的匹配度
    @Default([]) List<String> nutritionBenefits,
    
    required DateTime addedAt,
    DateTime? updatedAt,
  }) = _NutritionCartItem;

  factory NutritionCartItem.fromJson(Map<String, dynamic> json) =>
      _$NutritionCartItemFromJson(json);
}

/// 营养平衡分析
@freezed
class NutritionBalanceAnalysis with _$NutritionBalanceAnalysis {
  const factory NutritionBalanceAnalysis({
    required String cartId,
    required DateTime analysisTime,
    
    // 营养元素分析
    required Map<String, NutritionElementAnalysis> elementAnalysis,
    
    // 整体评分
    @Default(0.0) double overallScore, // 0-10
    @Default('neutral') String overallStatus, // excellent, good, fair, poor
    
    // 建议
    @Default([]) List<String> improvements,
    @Default([]) List<String> warnings,
    @Default([]) List<RecommendedItem> recommendations,
    
    // 热量分析
    required CalorieAnalysis calorieAnalysis,
    
    // 膳食平衡
    required MacronutrientBalance macroBalance,
    
    // 微量元素状态
    required MicronutrientStatus microStatus,
  }) = _NutritionBalanceAnalysis;

  factory NutritionBalanceAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NutritionBalanceAnalysisFromJson(json);
}

/// 营养元素分析
@freezed
class NutritionElementAnalysis with _$NutritionElementAnalysis {
  const factory NutritionElementAnalysis({
    required String elementId,
    required String elementName,
    required double targetAmount,
    required double currentAmount,
    required String unit,
    @Default(0.0) double completionRate, // 完成率 0-1+
    required String status, // deficient, adequate, excessive
    String? recommendation,
  }) = _NutritionElementAnalysis;

  factory NutritionElementAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NutritionElementAnalysisFromJson(json);
}

/// 热量分析
@freezed
class CalorieAnalysis with _$CalorieAnalysis {
  const factory CalorieAnalysis({
    required int targetCalories,
    required int currentCalories,
    @Default(0.0) double completionRate,
    required String status, // under, adequate, over
    @Default(0) int recommendedAdjustment,
  }) = _CalorieAnalysis;

  factory CalorieAnalysis.fromJson(Map<String, dynamic> json) =>
      _$CalorieAnalysisFromJson(json);
}

/// 宏量营养素平衡
@freezed
class MacronutrientBalance with _$MacronutrientBalance {
  const factory MacronutrientBalance({
    // 蛋白质
    required double proteinTarget,
    required double proteinCurrent,
    @Default(0.0) double proteinPercentage,
    
    // 碳水化合物
    required double carbTarget,
    required double carbCurrent,
    @Default(0.0) double carbPercentage,
    
    // 脂肪
    required double fatTarget,
    required double fatCurrent,
    @Default(0.0) double fatPercentage,
    
    // 平衡状态
    required String balanceStatus, // balanced, high_protein, high_carb, high_fat
    @Default([]) List<String> adjustmentSuggestions,
  }) = _MacronutrientBalance;

  factory MacronutrientBalance.fromJson(Map<String, dynamic> json) =>
      _$MacronutrientBalanceFromJson(json);
}

/// 微量元素状态
@freezed
class MicronutrientStatus with _$MicronutrientStatus {
  const factory MicronutrientStatus({
    // 维生素状态
    @Default({}) Map<String, String> vitaminStatus, // A, C, D, etc. -> adequate/deficient/excessive
    @Default([]) List<String> vitaminDeficiencies,
    
    // 矿物质状态
    @Default({}) Map<String, String> mineralStatus, // calcium, iron, etc.
    @Default([]) List<String> mineralDeficiencies,
    
    // 膳食纤维
    required double fiberTarget,
    required double fiberCurrent,
    required String fiberStatus,
    
    // 水分
    required double hydrationNeeds,
    @Default(0.0) double estimatedHydration,
  }) = _MicronutrientStatus;

  factory MicronutrientStatus.fromJson(Map<String, dynamic> json) =>
      _$MicronutrientStatusFromJson(json);
}

/// 推荐项目
@freezed
class RecommendedItem with _$RecommendedItem {
  const factory RecommendedItem({
    required String itemId,
    required String itemType, // ingredient, dish
    required String name,
    required String reason,
    @Default(0.0) double quantity,
    String? unit,
    @Default({}) Map<String, double> nutritionBenefit,
    @Default(0.0) double improvementScore,
  }) = _RecommendedItem;

  factory RecommendedItem.fromJson(Map<String, dynamic> json) =>
      _$RecommendedItemFromJson(json);
}

/// 购物车操作记录
@freezed
class CartOperation with _$CartOperation {
  const factory CartOperation({
    required String id,
    required String cartId,
    required String operation, // add, remove, update, clear
    required String itemId,
    Map<String, dynamic>? operationData,
    required DateTime timestamp,
    String? userId,
  }) = _CartOperation;

  factory CartOperation.fromJson(Map<String, dynamic> json) =>
      _$CartOperationFromJson(json);
}

/// 营养目标模板
@freezed
class NutritionGoalTemplate with _$NutritionGoalTemplate {
  const factory NutritionGoalTemplate({
    required String id,
    required String name,
    required String description,
    required String targetGroup, // weight_loss, muscle_gain, health_maintenance等
    required Map<String, double> nutritionTargets,
    required int calorieTarget,
    @Default([]) List<String> recommendedFoods,
    @Default([]) List<String> avoidFoods,
    @Default(false) bool isDefault,
  }) = _NutritionGoalTemplate;

  factory NutritionGoalTemplate.fromJson(Map<String, dynamic> json) =>
      _$NutritionGoalTemplateFromJson(json);
}