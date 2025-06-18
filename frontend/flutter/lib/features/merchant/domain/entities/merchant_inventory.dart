/**
 * 商家库存管理领域实体
 * 基于营养元素的革命性库存管理系统
 */

import 'package:freezed_annotation/freezed_annotation.dart';

part 'merchant_inventory.freezed.dart';
part 'merchant_inventory.g.dart';

/// 商家信息
@freezed
class MerchantInfo with _$MerchantInfo {
  const factory MerchantInfo({
    required String id,
    required String name,
    required String chineseName,
    required String businessLicense,
    required String address,
    required String phone,
    required String email,
    @Default('pending') String status, // pending, approved, rejected, suspended
    required List<String> supportedCuisineTypes,
    required List<String> certifications,
    @Default([]) List<String> specialties,
    required DateTime createdAt,
    DateTime? updatedAt,
    
    // 营养管理资质
    @Default(false) bool hasNutritionCertification,
    String? nutritionistId,
    @Default([]) List<String> nutritionSpecializations,
    
    // 业务数据
    @Default(0.0) double averageRating,
    @Default(0) int totalOrders,
    @Default(0) int totalReviews,
    
    // 营养菜单设置
    @Default(true) bool allowNutritionOrdering,
    @Default([]) List<String> supportedNutritionElements,
    @Default({}) Map<String, double> ingredientPricingMultipliers,
  }) = _MerchantInfo;

  factory MerchantInfo.fromJson(Map<String, dynamic> json) =>
      _$MerchantInfoFromJson(json);
}

/// 食材库存项
@freezed
class IngredientInventoryItem with _$IngredientInventoryItem {
  const factory IngredientInventoryItem({
    required String id,
    required String ingredientId,
    required String name,
    required String chineseName,
    required String category,
    required String unit,
    
    // 库存信息
    required double currentStock,
    required double minThreshold,
    required double maxCapacity,
    @Default(0.0) double reservedStock,
    @Default(0.0) double availableStock,
    
    // 定价信息
    required double costPerUnit,
    required double sellingPricePerUnit,
    @Default(1.0) double profitMargin,
    
    // 营养数据（每100g/ml）
    required Map<String, double> nutritionPer100g,
    
    // 采购信息
    String? supplierId,
    String? supplierName,
    DateTime? lastRestockDate,
    DateTime? expiryDate,
    @Default('fresh') String qualityStatus, // fresh, good, fair, expired
    
    // 菜单可用性
    @Default(true) bool isAvailableForOrdering,
    @Default([]) List<String> restrictedCookingMethods,
    @Default([]) List<String> allergenWarnings,
    
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _IngredientInventoryItem;

  factory IngredientInventoryItem.fromJson(Map<String, dynamic> json) =>
      _$IngredientInventoryItemFromJson(json);
}

/// 烹饪方法配置
@freezed
class CookingMethodConfig with _$CookingMethodConfig {
  const factory CookingMethodConfig({
    required String id,
    required String cookingMethodId,
    required String name,
    required String chineseName,
    required int preparationTimeMinutes,
    required int cookingTimeMinutes,
    
    // 设备要求
    required List<String> requiredEquipment,
    @Default(1) int skillLevelRequired, // 1-5
    @Default(1.0) double laborCostMultiplier,
    
    // 营养影响
    required Map<String, double> nutritionRetentionRates,
    @Default({}) Map<String, double> nutritionEnhancements,
    
    // 成本影响
    @Default(1.0) double preparationCostMultiplier,
    @Default(0.0) double additionalFixedCost,
    
    // 可用性
    @Default(true) bool isAvailable,
    @Default([]) List<String> compatibleIngredientCategories,
    @Default([]) List<String> incompatibleIngredients,
    
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CookingMethodConfig;

  factory CookingMethodConfig.fromJson(Map<String, dynamic> json) =>
      _$CookingMethodConfigFromJson(json);
}

/// 预制菜品（基于营养目标的组合）
@freezed
class NutritionBasedDish with _$NutritionBasedDish {
  const factory NutritionBasedDish({
    required String id,
    required String name,
    required String chineseName,
    String? description,
    
    // 食材配方
    required List<DishIngredient> ingredients,
    required List<String> cookingMethods,
    
    // 营养信息（计算得出）
    required Map<String, double> totalNutritionPer100g,
    required double totalCaloriesPer100g,
    required double recommendedServingSize,
    
    // 定价
    required double basePrice,
    required double calculatedCost,
    @Default(0.3) double profitMargin,
    
    // 目标营养人群
    @Default([]) List<String> targetNutritionGoals,
    @Default([]) List<String> suitableForConditions,
    @Default([]) List<String> allergenWarnings,
    
    // 商业信息
    @Default(0) int preparationTimeMinutes,
    @Default(1) int difficultyLevel,
    @Default(true) bool isAvailable,
    @Default(0) int popularityScore,
    
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _NutritionBasedDish;

  factory NutritionBasedDish.fromJson(Map<String, dynamic> json) =>
      _$NutritionBasedDishFromJson(json);
}

/// 菜品食材组成
@freezed
class DishIngredient with _$DishIngredient {
  const factory DishIngredient({
    required String ingredientId,
    required String name,
    required double quantity,
    required String unit,
    required String cookingMethodId,
    @Default(false) bool isOptional,
    @Default([]) List<String> substitutes,
  }) = _DishIngredient;

  factory DishIngredient.fromJson(Map<String, dynamic> json) =>
      _$DishIngredientFromJson(json);
}

/// 库存操作记录
@freezed
class InventoryTransaction with _$InventoryTransaction {
  const factory InventoryTransaction({
    required String id,
    required String ingredientId,
    required String type, // restock, usage, waste, adjustment
    required double quantity,
    required String unit,
    String? reason,
    String? orderId,
    String? supplierId,
    required double costPerUnit,
    required String operatorId,
    required DateTime timestamp,
    
    // 库存快照
    required double stockBefore,
    required double stockAfter,
    
    // 附加信息
    Map<String, dynamic>? metadata,
  }) = _InventoryTransaction;

  factory InventoryTransaction.fromJson(Map<String, dynamic> json) =>
      _$InventoryTransactionFromJson(json);
}

/// 库存预警
@freezed
class InventoryAlert with _$InventoryAlert {
  const factory InventoryAlert({
    required String id,
    required String ingredientId,
    required String ingredientName,
    required String alertType, // low_stock, expired, quality_issue
    required String severity, // low, medium, high, critical
    required String message,
    @Default(false) bool isResolved,
    String? resolvedBy,
    DateTime? resolvedAt,
    required DateTime createdAt,
    
    // 预警数据
    double? currentStock,
    double? threshold,
    DateTime? expiryDate,
    String? qualityStatus,
  }) = _InventoryAlert;

  factory InventoryAlert.fromJson(Map<String, dynamic> json) =>
      _$InventoryAlertFromJson(json);
}

/// 营养菜单分析
@freezed
class NutritionMenuAnalysis with _$NutritionMenuAnalysis {
  const factory NutritionMenuAnalysis({
    required String merchantId,
    required DateTime analysisDate,
    
    // 营养覆盖度分析
    required Map<String, double> nutritionElementCoverage,
    required List<String> missingNutritionElements,
    required List<String> overrepresentedElements,
    
    // 成本效益分析
    required double averageCostPerCalorie,
    required double averageCostPerProteinGram,
    required Map<String, double> costEfficiencyByCategory,
    
    // 菜单建议
    required List<String> recommendedIngredients,
    required List<String> costOptimizationSuggestions,
    required List<String> nutritionBalanceSuggestions,
    
    // 市场分析
    @Default(0.0) double competitivenessScore,
    required List<String> marketOpportunities,
  }) = _NutritionMenuAnalysis;

  factory NutritionMenuAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NutritionMenuAnalysisFromJson(json);
}