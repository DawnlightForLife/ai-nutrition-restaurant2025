/**
 * 营养购物车仓储接口
 * 定义营养购物车的数据访问抽象
 */

import '../entities/nutrition_cart.dart';

abstract class NutritionCartRepository {
  // 购物车基本操作
  Future<NutritionCart?> getCart(String userId);
  Future<void> createCart(NutritionCart cart);
  Future<void> updateCart(NutritionCart cart);
  Future<void> clearCart(String userId);
  
  // 购物车项目管理
  Future<void> addItem(String userId, NutritionCartItem item);
  Future<void> updateItem(String userId, String itemId, NutritionCartItem updatedItem);
  Future<void> removeItem(String userId, String itemId);
  Future<void> updateItemQuantity(String userId, String itemId, double quantity);
  
  // 批量操作
  Future<void> addMultipleItems(String userId, List<NutritionCartItem> items);
  Future<void> removeMultipleItems(String userId, List<String> itemIds);
  
  // 营养分析
  Future<NutritionBalanceAnalysis> analyzeNutritionBalance(String userId);
  Future<NutritionBalanceAnalysis> analyzeCartWithGoals(
    String userId,
    Map<String, double> nutritionGoals,
  );
  
  // 智能推荐
  Future<List<RecommendedItem>> getRecommendations(
    String userId, {
    int? maxRecommendations,
    String? focusNutrient,
  });
  
  Future<List<RecommendedItem>> getBalancingRecommendations(
    String userId,
    NutritionBalanceAnalysis analysis,
  );
  
  // 营养目标管理
  Future<void> setNutritionGoals(String userId, Map<String, double> goals);
  Future<Map<String, double>?> getNutritionGoals(String userId);
  Future<List<NutritionGoalTemplate>> getGoalTemplates();
  Future<void> applyGoalTemplate(String userId, String templateId);
  
  // 商家分组
  Future<Map<String, MerchantCartGroup>> groupByMerchant(String userId);
  Future<void> updateMerchantGroup(String userId, String merchantId, MerchantCartGroup group);
  
  // 库存验证
  Future<List<String>> validateItemAvailability(String userId);
  Future<void> updateItemAvailability(String userId, String itemId, bool isAvailable);
  
  // 价格计算
  Future<double> calculateTotalPrice(String userId);
  Future<Map<String, double>> calculateMerchantSubtotals(String userId);
  Future<double> calculateDeliveryFees(String userId, String deliveryAddress);
  
  // 优惠券
  Future<void> applyCoupon(String userId, String couponCode);
  Future<void> removeCoupon(String userId, String couponCode);
  Future<List<String>> getAvailableCoupons(String userId);
  Future<double> calculateDiscount(String userId);
  
  // 配送选项
  Future<void> setDeliveryInfo(
    String userId,
    String address,
    DateTime preferredTime,
    String method,
  );
  
  Future<List<DateTime>> getAvailableDeliveryTimes(
    String userId,
    String merchantId,
  );
  
  // 购物车历史
  Future<List<CartOperation>> getCartHistory(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  });
  
  Future<void> saveCartOperation(CartOperation operation);
  
  // 购物车同步
  Future<void> syncCart(String userId, NutritionCart localCart);
  Future<NutritionCart?> getCartFromCloud(String userId);
  Future<void> saveCartToCloud(String userId, NutritionCart cart);
  
  // 营养统计
  Future<Map<String, double>> calculateNutritionTotals(String userId);
  Future<int> calculateTotalCalories(String userId);
  Future<double> calculateTotalWeight(String userId);
  
  // AI优化建议
  Future<List<String>> getAIOptimizationSuggestions(String userId);
  Future<NutritionCart> optimizeCartForGoals(
    String userId,
    Map<String, double> priorities,
  );
  
  // 餐次分配
  Future<Map<String, List<NutritionCartItem>>> suggestMealDistribution(
    String userId,
    int numberOfMeals,
  );
  
  // 替代建议
  Future<List<NutritionCartItem>> suggestAlternatives(
    String userId,
    String itemId,
    String reason, // price, nutrition, availability
  );
  
  // 购物车分享
  Future<String> shareCart(String userId);
  Future<NutritionCart?> loadSharedCart(String shareCode);
  
  // 快速重购
  Future<void> reorderFromHistory(String userId, DateTime orderDate);
  Future<List<NutritionCart>> getReorderTemplates(String userId);
  
  // 营养目标达成预测
  Future<Map<String, double>> predictNutritionAchievement(
    String userId,
    int daysAhead,
  );
}