/**
 * 商家库存管理仓储接口
 * 定义营养元素驱动的库存管理数据访问抽象
 */

import '../entities/merchant_inventory.dart';

abstract class MerchantInventoryRepository {
  // 商家信息管理
  Future<MerchantInfo?> getMerchantInfo(String merchantId);
  Future<void> updateMerchantInfo(MerchantInfo merchantInfo);
  Future<List<MerchantInfo>> searchMerchants({
    String? keyword,
    List<String>? cuisineTypes,
    bool? hasNutritionCertification,
    String? status,
  });

  // 食材库存管理
  Future<List<IngredientInventoryItem>> getIngredientInventory(
    String merchantId, {
    String? category,
    bool? availableOnly,
    bool? lowStockOnly,
  });
  
  Future<IngredientInventoryItem?> getIngredientInventoryItem(
    String merchantId,
    String ingredientId,
  );
  
  Future<void> updateIngredientInventory(
    String merchantId,
    IngredientInventoryItem item,
  );
  
  Future<void> batchUpdateIngredientInventory(
    String merchantId,
    List<IngredientInventoryItem> items,
  );
  
  Future<void> addIngredientToInventory(
    String merchantId,
    IngredientInventoryItem item,
  );
  
  Future<void> removeIngredientFromInventory(
    String merchantId,
    String ingredientId,
  );

  // 库存操作记录
  Future<void> recordInventoryTransaction(
    String merchantId,
    InventoryTransaction transaction,
  );
  
  Future<List<InventoryTransaction>> getInventoryTransactions(
    String merchantId, {
    String? ingredientId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });

  // 烹饪方法配置
  Future<List<CookingMethodConfig>> getCookingMethodConfigs(
    String merchantId,
  );
  
  Future<void> updateCookingMethodConfig(
    String merchantId,
    CookingMethodConfig config,
  );
  
  Future<void> addCookingMethodConfig(
    String merchantId,
    CookingMethodConfig config,
  );

  // 营养菜品管理
  Future<List<NutritionBasedDish>> getNutritionBasedDishes(
    String merchantId, {
    List<String>? targetNutritionGoals,
    bool? availableOnly,
  });
  
  Future<NutritionBasedDish?> getNutritionBasedDish(
    String merchantId,
    String dishId,
  );
  
  Future<void> createNutritionBasedDish(
    String merchantId,
    NutritionBasedDish dish,
  );
  
  Future<void> updateNutritionBasedDish(
    String merchantId,
    NutritionBasedDish dish,
  );
  
  Future<void> deleteNutritionBasedDish(
    String merchantId,
    String dishId,
  );

  // 库存预警管理
  Future<List<InventoryAlert>> getInventoryAlerts(
    String merchantId, {
    bool? unresolvedOnly,
    String? severity,
  });
  
  Future<void> createInventoryAlert(
    String merchantId,
    InventoryAlert alert,
  );
  
  Future<void> resolveInventoryAlert(
    String merchantId,
    String alertId,
    String resolvedBy,
  );

  // 营养菜单分析
  Future<NutritionMenuAnalysis> generateNutritionMenuAnalysis(
    String merchantId,
  );
  
  Future<NutritionMenuAnalysis?> getLatestNutritionMenuAnalysis(
    String merchantId,
  );

  // 库存自动化
  Future<void> checkAndUpdateStockLevels(String merchantId);
  Future<void> generateRestockSuggestions(String merchantId);
  Future<void> optimizeIngredientMix(String merchantId);
  
  // AI驱动的库存优化
  Future<List<String>> getAIRestockRecommendations(
    String merchantId,
    Map<String, double> targetNutritionRatios,
  );
  
  Future<Map<String, double>> calculateOptimalPricing(
    String merchantId,
    String dishId,
  );
  
  Future<List<DishIngredient>> suggestIngredientSubstitutions(
    String merchantId,
    String dishId,
    List<String> unavailableIngredients,
  );
}