/**
 * 营养购物车仓储实现
 * 基于Retrofit的RESTful API客户端实现
 */

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/nutrition_cart.dart';
import '../../domain/repositories/nutrition_cart_repository.dart';
import '../datasources/nutrition_cart_api.dart';

class NutritionCartRepositoryImpl implements NutritionCartRepository {
  final NutritionCartApi _api;

  NutritionCartRepositoryImpl(this._api);

  @override
  Future<NutritionCart?> getCart(String userId) async {
    try {
      final response = await _api.getCart(userId);
      return response.success ? response.data : null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> createCart(NutritionCart cart) async {
    try {
      await _api.createCart(cart);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateCart(NutritionCart cart) async {
    try {
      await _api.updateCart(cart.userId, cart);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> clearCart(String userId) async {
    try {
      await _api.clearCart(userId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addItem(String userId, NutritionCartItem item) async {
    try {
      await _api.addItem(userId, item);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateItem(String userId, String itemId, NutritionCartItem updatedItem) async {
    try {
      await _api.updateItem(userId, itemId, updatedItem);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> removeItem(String userId, String itemId) async {
    try {
      await _api.removeItem(userId, itemId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateItemQuantity(String userId, String itemId, double quantity) async {
    try {
      await _api.updateItemQuantity(userId, itemId, {'quantity': quantity});
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addMultipleItems(String userId, List<NutritionCartItem> items) async {
    try {
      await _api.addMultipleItems(userId, items);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> removeMultipleItems(String userId, List<String> itemIds) async {
    try {
      await _api.removeMultipleItems(userId, itemIds);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionBalanceAnalysis> analyzeNutritionBalance(String userId) async {
    try {
      final response = await _api.analyzeNutritionBalance(userId);
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw Exception('Failed to analyze nutrition balance');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionBalanceAnalysis> analyzeCartWithGoals(
    String userId,
    Map<String, double> nutritionGoals,
  ) async {
    try {
      final response = await _api.analyzeCartWithGoals(userId, nutritionGoals);
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw Exception('Failed to analyze cart with goals');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<RecommendedItem>> getRecommendations(
    String userId, {
    int? maxRecommendations,
    String? focusNutrient,
  }) async {
    try {
      final response = await _api.getRecommendations(
        userId,
        maxRecommendations: maxRecommendations,
        focusNutrient: focusNutrient,
      );
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<RecommendedItem>> getBalancingRecommendations(
    String userId,
    NutritionBalanceAnalysis analysis,
  ) async {
    try {
      final response = await _api.getBalancingRecommendations(userId, analysis);
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> setNutritionGoals(String userId, Map<String, double> goals) async {
    try {
      await _api.setNutritionGoals(userId, goals);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, double>?> getNutritionGoals(String userId) async {
    try {
      final response = await _api.getNutritionGoals(userId);
      return response.success ? response.data : null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NutritionGoalTemplate>> getGoalTemplates() async {
    try {
      final response = await _api.getGoalTemplates();
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> applyGoalTemplate(String userId, String templateId) async {
    try {
      await _api.applyGoalTemplate(userId, templateId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, MerchantCartGroup>> groupByMerchant(String userId) async {
    try {
      final response = await _api.groupByMerchant(userId);
      return response.success ? response.data ?? {} : {};
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateMerchantGroup(String userId, String merchantId, MerchantCartGroup group) async {
    try {
      await _api.updateMerchantGroup(userId, merchantId, group);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<String>> validateItemAvailability(String userId) async {
    try {
      final response = await _api.validateItemAvailability(userId);
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateItemAvailability(String userId, String itemId, bool isAvailable) async {
    try {
      await _api.updateItemAvailability(userId, itemId, {'isAvailable': isAvailable});
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<double> calculateTotalPrice(String userId) async {
    try {
      final response = await _api.calculateTotalPrice(userId);
      return response.success ? response.data ?? 0.0 : 0.0;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, double>> calculateMerchantSubtotals(String userId) async {
    try {
      final response = await _api.calculateMerchantSubtotals(userId);
      return response.success ? response.data ?? {} : {};
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<double> calculateDeliveryFees(String userId, String deliveryAddress) async {
    try {
      final response = await _api.calculateDeliveryFees(userId, {
        'deliveryAddress': deliveryAddress,
      });
      return response.success ? response.data ?? 0.0 : 0.0;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> applyCoupon(String userId, String couponCode) async {
    try {
      await _api.applyCoupon(userId, couponCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> removeCoupon(String userId, String couponCode) async {
    try {
      await _api.removeCoupon(userId, couponCode);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<String>> getAvailableCoupons(String userId) async {
    try {
      final response = await _api.getAvailableCoupons(userId);
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<double> calculateDiscount(String userId) async {
    try {
      final response = await _api.calculateDiscount(userId);
      return response.success ? response.data ?? 0.0 : 0.0;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> setDeliveryInfo(
    String userId,
    String address,
    DateTime preferredTime,
    String method,
  ) async {
    try {
      await _api.setDeliveryInfo(userId, {
        'address': address,
        'preferredTime': preferredTime.toIso8601String(),
        'method': method,
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<DateTime>> getAvailableDeliveryTimes(
    String userId,
    String merchantId,
  ) async {
    try {
      final response = await _api.getAvailableDeliveryTimes(userId, merchantId);
      if (response.success && response.data != null) {
        return response.data!
            .map((timeStr) => DateTime.parse(timeStr))
            .toList();
      }
      return [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<CartOperation>> getCartHistory(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final response = await _api.getCartHistory(
        userId,
        startDate: startDate?.toIso8601String(),
        endDate: endDate?.toIso8601String(),
        limit: limit,
      );
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> saveCartOperation(CartOperation operation) async {
    try {
      await _api.saveCartOperation(operation.cartId, operation);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> syncCart(String userId, NutritionCart localCart) async {
    try {
      await _api.syncCart(userId, localCart);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionCart?> getCartFromCloud(String userId) async {
    try {
      final response = await _api.getCartFromCloud(userId);
      return response.success ? response.data : null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> saveCartToCloud(String userId, NutritionCart cart) async {
    try {
      await _api.saveCartToCloud(userId, cart);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, double>> calculateNutritionTotals(String userId) async {
    try {
      final response = await _api.calculateNutritionTotals(userId);
      return response.success ? response.data ?? {} : {};
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<int> calculateTotalCalories(String userId) async {
    try {
      final response = await _api.calculateTotalCalories(userId);
      return response.success ? response.data ?? 0 : 0;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<double> calculateTotalWeight(String userId) async {
    try {
      final response = await _api.calculateTotalWeight(userId);
      return response.success ? response.data ?? 0.0 : 0.0;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<String>> getAIOptimizationSuggestions(String userId) async {
    try {
      final response = await _api.getAIOptimizationSuggestions(userId);
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionCart> optimizeCartForGoals(
    String userId,
    Map<String, double> priorities,
  ) async {
    try {
      final response = await _api.optimizeCartForGoals(userId, priorities);
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw Exception('Failed to optimize cart');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, List<NutritionCartItem>>> suggestMealDistribution(
    String userId,
    int numberOfMeals,
  ) async {
    try {
      final response = await _api.suggestMealDistribution(userId, {
        'numberOfMeals': numberOfMeals,
      });
      return response.success ? response.data ?? {} : {};
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NutritionCartItem>> suggestAlternatives(
    String userId,
    String itemId,
    String reason,
  ) async {
    try {
      final response = await _api.suggestAlternatives(userId, itemId, {
        'reason': reason,
      });
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<String> shareCart(String userId) async {
    try {
      final response = await _api.shareCart(userId);
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw Exception('Failed to share cart');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionCart?> loadSharedCart(String shareCode) async {
    try {
      final response = await _api.loadSharedCart(shareCode);
      return response.success ? response.data : null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> reorderFromHistory(String userId, DateTime orderDate) async {
    try {
      await _api.reorderFromHistory(userId, {
        'orderDate': orderDate.toIso8601String(),
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NutritionCart>> getReorderTemplates(String userId) async {
    try {
      final response = await _api.getReorderTemplates(userId);
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, double>> predictNutritionAchievement(
    String userId,
    int daysAhead,
  ) async {
    try {
      final response = await _api.predictNutritionAchievement(userId, {
        'daysAhead': daysAhead,
      });
      return response.success ? response.data ?? {} : {};
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is Exception) {
      return error;
    }
    return Exception('Unknown error: $error');
  }
}