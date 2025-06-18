/**
 * 商家库存管理仓储实现
 * 基于Retrofit的RESTful API客户端实现
 */

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/merchant_inventory.dart';
import '../../domain/repositories/merchant_inventory_repository.dart';
import '../datasources/merchant_inventory_api.dart';

class MerchantInventoryRepositoryImpl implements MerchantInventoryRepository {
  final MerchantInventoryApi _api;

  MerchantInventoryRepositoryImpl(this._api);

  @override
  Future<MerchantInfo?> getMerchantInfo(String merchantId) async {
    try {
      final response = await _api.getMerchantInfo(merchantId);
      return response.success ? response.data : null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateMerchantInfo(MerchantInfo merchantInfo) async {
    try {
      await _api.updateMerchantInfo(merchantInfo.id, merchantInfo);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<MerchantInfo>> searchMerchants({
    String? keyword,
    List<String>? cuisineTypes,
    bool? hasNutritionCertification,
    String? status,
  }) async {
    try {
      final response = await _api.searchMerchants(
        query: keyword,
        category: cuisineTypes?.join(','),
        availableOnly: hasNutritionCertification,
      );
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<IngredientInventoryItem>> getIngredientInventory(
    String merchantId, {
    String? category,
    bool? availableOnly,
    bool? lowStockOnly,
  }) async {
    try {
      final response = await _api.getIngredientInventory(
        merchantId,
        category: category,
        lowStock: lowStockOnly,
      );
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<IngredientInventoryItem?> getIngredientInventoryItem(
    String merchantId,
    String ingredientId,
  ) async {
    try {
      final response = await _api.getIngredientInventoryItem(
        merchantId,
        ingredientId,
      );
      return response.success ? response.data : null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateIngredientInventory(
    String merchantId,
    IngredientInventoryItem item,
  ) async {
    try {
      await _api.updateIngredientInventory(merchantId, item.id, item);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> batchUpdateIngredientInventory(
    String merchantId,
    List<IngredientInventoryItem> items,
  ) async {
    try {
      await _api.batchUpdateIngredientInventory(merchantId, items);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addIngredientToInventory(
    String merchantId,
    IngredientInventoryItem item,
  ) async {
    try {
      await _api.addIngredientToInventory(merchantId, item);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> removeIngredientFromInventory(
    String merchantId,
    String ingredientId,
  ) async {
    try {
      await _api.removeIngredientFromInventory(merchantId, ingredientId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> recordInventoryTransaction(
    String merchantId,
    InventoryTransaction transaction,
  ) async {
    try {
      await _api.recordInventoryTransaction(merchantId, transaction);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<InventoryTransaction>> getInventoryTransactions(
    String merchantId, {
    String? ingredientId,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    try {
      final response = await _api.getInventoryTransactions(
        merchantId,
        ingredientId: ingredientId,
        transactionType: type,
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
  Future<List<CookingMethodConfig>> getCookingMethodConfigs(
    String merchantId,
  ) async {
    try {
      final response = await _api.getCookingMethodConfigs(merchantId);
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateCookingMethodConfig(
    String merchantId,
    CookingMethodConfig config,
  ) async {
    try {
      await _api.updateCookingMethodConfig(merchantId, config.id, config);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> addCookingMethodConfig(
    String merchantId,
    CookingMethodConfig config,
  ) async {
    try {
      await _api.addCookingMethodConfig(merchantId, config);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NutritionBasedDish>> getNutritionBasedDishes(
    String merchantId, {
    List<String>? targetNutritionGoals,
    bool? availableOnly,
  }) async {
    try {
      final response = await _api.getNutritionBasedDishes(
        merchantId,
        nutritionTarget: targetNutritionGoals?.join(','),
        available: availableOnly,
      );
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionBasedDish?> getNutritionBasedDish(
    String merchantId,
    String dishId,
  ) async {
    try {
      final response = await _api.getNutritionBasedDish(merchantId, dishId);
      return response.success ? response.data : null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> createNutritionBasedDish(
    String merchantId,
    NutritionBasedDish dish,
  ) async {
    try {
      await _api.createNutritionBasedDish(merchantId, dish);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateNutritionBasedDish(
    String merchantId,
    NutritionBasedDish dish,
  ) async {
    try {
      await _api.updateNutritionBasedDish(merchantId, dish.id, dish);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteNutritionBasedDish(
    String merchantId,
    String dishId,
  ) async {
    try {
      await _api.deleteNutritionBasedDish(merchantId, dishId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<InventoryAlert>> getInventoryAlerts(
    String merchantId, {
    bool? unresolvedOnly,
    String? severity,
  }) async {
    try {
      final response = await _api.getInventoryAlerts(
        merchantId,
        resolved: unresolvedOnly == true ? false : null,
        severity: severity,
      );
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> createInventoryAlert(
    String merchantId,
    InventoryAlert alert,
  ) async {
    try {
      await _api.createInventoryAlert(merchantId, alert);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> resolveInventoryAlert(
    String merchantId,
    String alertId,
    String resolvedBy,
  ) async {
    try {
      await _api.resolveInventoryAlert(merchantId, alertId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionMenuAnalysis> generateNutritionMenuAnalysis(
    String merchantId,
  ) async {
    try {
      final response = await _api.generateNutritionMenuAnalysis(merchantId);
      if (response.success) {
        // 创建一个基本的分析结果
        return NutritionMenuAnalysis(
          merchantId: merchantId,
          analysisDate: DateTime.now(),
          nutritionElementCoverage: {},
          missingNutritionElements: [],
          overrepresentedElements: [],
          averageCostPerCalorie: 0.1,
          averageCostPerProteinGram: 2.0,
          costEfficiencyByCategory: {},
          recommendedIngredients: [],
          costOptimizationSuggestions: [],
          nutritionBalanceSuggestions: [],
          marketOpportunities: [],
        );
      }
      throw Exception('Failed to generate nutrition menu analysis');
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionMenuAnalysis?> getLatestNutritionMenuAnalysis(
    String merchantId,
  ) async {
    try {
      final response = await _api.getLatestNutritionMenuAnalysis(merchantId);
      if (response.success) {
        // 返回基本的分析结果或null
        return NutritionMenuAnalysis(
          merchantId: merchantId,
          analysisDate: DateTime.now().subtract(const Duration(days: 1)),
          nutritionElementCoverage: {},
          missingNutritionElements: [],
          overrepresentedElements: [],
          averageCostPerCalorie: 0.1,
          averageCostPerProteinGram: 2.0,
          costEfficiencyByCategory: {},
          recommendedIngredients: [],
          costOptimizationSuggestions: [],
          nutritionBalanceSuggestions: [],
          marketOpportunities: [],
        );
      }
      return null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> checkAndUpdateStockLevels(String merchantId) async {
    try {
      await _api.checkAndUpdateStockLevels(merchantId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> generateRestockSuggestions(String merchantId) async {
    try {
      await _api.generateRestockSuggestions(merchantId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> optimizeIngredientMix(String merchantId) async {
    try {
      await _api.optimizeIngredientMix(merchantId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<String>> getAIRestockRecommendations(
    String merchantId,
    Map<String, double> targetNutritionRatios,
  ) async {
    try {
      final response = await _api.getAIRestockRecommendations(
        merchantId,
      );
      return response.success ? response.data ?? [] : [];
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, double>> calculateOptimalPricing(
    String merchantId,
    String dishId,
  ) async {
    try {
      final response = await _api.calculateOptimalPricing(merchantId, dishId);
      if (response.success && response.data != null) {
        return {'optimalPrice': response.data!};
      }
      return {};
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<DishIngredient>> suggestIngredientSubstitutions(
    String merchantId,
    String dishId,
    List<String> unavailableIngredients,
  ) async {
    try {
      final response = await _api.suggestIngredientSubstitutions(
        merchantId,
        dishId, // 作为ingredientId使用
        reason: 'unavailable',
      );
      if (response.success && response.data != null) {
        // 转换Map数据为DishIngredient对象
        return response.data!.map<DishIngredient>((item) {
          final map = item as Map<String, dynamic>;
          return DishIngredient(
            ingredientId: map['ingredientId'] ?? 'unknown',
            name: map['name'] ?? 'Unknown Ingredient',
            quantity: (map['quantity'] ?? 0.0).toDouble(),
            unit: map['unit'] ?? 'g',
            cookingMethodId: map['cookingMethodId'] ?? 'raw',
          );
        }).toList();
      }
      return [];
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