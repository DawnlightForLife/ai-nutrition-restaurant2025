/**
 * 商家库存管理状态提供者
 * 使用Riverpod管理营养元素驱动的库存状态
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/merchant_inventory.dart';
import '../../domain/repositories/merchant_inventory_repository.dart';
import '../../data/repositories/merchant_inventory_repository_impl.dart';
import '../../data/datasources/merchant_inventory_api.dart';
import '../../../../core/network/dio_provider.dart';

part 'merchant_inventory_provider.freezed.dart';

// Repository provider
final merchantInventoryRepositoryProvider = Provider<MerchantInventoryRepository>((ref) {
  final dio = ref.read(dioClientProvider);
  final api = MerchantInventoryApi(dio);
  return MerchantInventoryRepositoryImpl(api);
});

// 商家库存状态
@freezed
class MerchantInventoryState with _$MerchantInventoryState {
  const factory MerchantInventoryState({
    @Default(false) bool isLoading,
    @Default(false) bool isUpdating,
    @Default([]) List<IngredientInventoryItem> ingredients,
    @Default([]) List<CookingMethodConfig> cookingMethods,
    @Default([]) List<NutritionBasedDish> nutritionDishes,
    @Default([]) List<InventoryAlert> alerts,
    @Default([]) List<InventoryTransaction> transactions,
    NutritionMenuAnalysis? nutritionAnalysis,
    MerchantInfo? merchantInfo,
    String? error,
    
    // 筛选和搜索状态
    @Default('') String searchQuery,
    String? selectedCategory,
    @Default(false) bool showLowStockOnly,
    @Default(false) bool showAvailableOnly,
    
    // 选中的项目
    @Default([]) List<String> selectedIngredientIds,
    String? selectedDishId,
  }) = _MerchantInventoryState;
}

// 商家库存管理提供者
class MerchantInventoryNotifier extends StateNotifier<MerchantInventoryState> {
  final MerchantInventoryRepository _repository;
  final String merchantId;

  MerchantInventoryNotifier(this._repository, this.merchantId) 
      : super(const MerchantInventoryState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      loadMerchantInfo(),
      loadIngredientInventory(),
      loadCookingMethods(),
      loadNutritionDishes(),
      loadInventoryAlerts(),
    ]);
  }

  // 加载商家信息
  Future<void> loadMerchantInfo() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final merchantInfo = await _repository.getMerchantInfo(merchantId);
      state = state.copyWith(merchantInfo: merchantInfo, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 加载食材库存
  Future<void> loadIngredientInventory({
    String? category,
    bool? availableOnly,
    bool? lowStockOnly,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final ingredients = await _repository.getIngredientInventory(
        merchantId,
        category: category ?? state.selectedCategory,
        availableOnly: availableOnly ?? state.showAvailableOnly,
        lowStockOnly: lowStockOnly ?? state.showLowStockOnly,
      );
      state = state.copyWith(ingredients: ingredients, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 更新食材库存
  Future<void> updateIngredientInventory(IngredientInventoryItem item) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.updateIngredientInventory(merchantId, item);
      
      // 更新本地状态
      final updatedIngredients = state.ingredients.map((ingredient) {
        return ingredient.id == item.id ? item : ingredient;
      }).toList();
      
      state = state.copyWith(
        ingredients: updatedIngredients,
        isUpdating: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 批量更新食材库存
  Future<void> batchUpdateIngredients(List<IngredientInventoryItem> items) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.batchUpdateIngredientInventory(merchantId, items);
      await loadIngredientInventory(); // 重新加载
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 添加食材到库存
  Future<void> addIngredientToInventory(IngredientInventoryItem item) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.addIngredientToInventory(merchantId, item);
      
      // 添加到本地状态
      final updatedIngredients = [...state.ingredients, item];
      state = state.copyWith(
        ingredients: updatedIngredients,
        isUpdating: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 移除食材库存
  Future<void> removeIngredientInventory(String ingredientId) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.removeIngredientFromInventory(merchantId, ingredientId);
      
      // 从本地状态移除
      final updatedIngredients = state.ingredients
          .where((ingredient) => ingredient.id != ingredientId)
          .toList();
      
      state = state.copyWith(
        ingredients: updatedIngredients,
        isUpdating: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 记录库存操作
  Future<void> recordInventoryTransaction(InventoryTransaction transaction) async {
    try {
      await _repository.recordInventoryTransaction(merchantId, transaction);
      // 重新加载相关数据
      await loadIngredientInventory();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 加载烹饪方法配置
  Future<void> loadCookingMethods() async {
    try {
      final cookingMethods = await _repository.getCookingMethodConfigs(merchantId);
      state = state.copyWith(cookingMethods: cookingMethods);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 加载营养菜品
  Future<void> loadNutritionDishes({
    List<String>? targetNutritionGoals,
    bool? availableOnly,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final dishes = await _repository.getNutritionBasedDishes(
        merchantId,
        targetNutritionGoals: targetNutritionGoals,
        availableOnly: availableOnly,
      );
      state = state.copyWith(nutritionDishes: dishes, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // 创建营养菜品
  Future<void> createNutritionDish(NutritionBasedDish dish) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.createNutritionBasedDish(merchantId, dish);
      
      // 添加到本地状态
      final updatedDishes = [...state.nutritionDishes, dish];
      state = state.copyWith(
        nutritionDishes: updatedDishes,
        isUpdating: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 更新营养菜品
  Future<void> updateNutritionDish(NutritionBasedDish dish) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.updateNutritionBasedDish(merchantId, dish);
      
      // 更新本地状态
      final updatedDishes = state.nutritionDishes.map((d) {
        return d.id == dish.id ? dish : d;
      }).toList();
      
      state = state.copyWith(
        nutritionDishes: updatedDishes,
        isUpdating: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 加载库存预警
  Future<void> loadInventoryAlerts({
    bool? unresolvedOnly,
    String? severity,
  }) async {
    try {
      final alerts = await _repository.getInventoryAlerts(
        merchantId,
        unresolvedOnly: unresolvedOnly ?? true,
        severity: severity,
      );
      state = state.copyWith(alerts: alerts);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 解决库存预警
  Future<void> resolveInventoryAlert(String alertId, String resolvedBy) async {
    try {
      await _repository.resolveInventoryAlert(merchantId, alertId, resolvedBy);
      
      // 更新本地状态
      final updatedAlerts = state.alerts.map((alert) {
        if (alert.id == alertId) {
          return alert.copyWith(
            isResolved: true,
            resolvedBy: resolvedBy,
            resolvedAt: DateTime.now(),
          );
        }
        return alert;
      }).toList();
      
      state = state.copyWith(alerts: updatedAlerts);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 生成营养菜单分析
  Future<void> generateNutritionAnalysis() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final analysis = await _repository.generateNutritionMenuAnalysis(merchantId);
      state = state.copyWith(nutritionAnalysis: analysis, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // AI优化功能
  Future<List<String>> getAIRestockRecommendations(
    Map<String, double> targetNutritionRatios,
  ) async {
    try {
      return await _repository.getAIRestockRecommendations(
        merchantId,
        targetNutritionRatios,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }

  // 筛选和搜索
  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateCategoryFilter(String? category) {
    state = state.copyWith(selectedCategory: category);
    loadIngredientInventory();
  }

  void toggleLowStockFilter() {
    state = state.copyWith(showLowStockOnly: !state.showLowStockOnly);
    loadIngredientInventory();
  }

  void toggleAvailableFilter() {
    state = state.copyWith(showAvailableOnly: !state.showAvailableOnly);
    loadIngredientInventory();
  }

  // 选择管理
  void toggleIngredientSelection(String ingredientId) {
    final selectedIds = state.selectedIngredientIds;
    if (selectedIds.contains(ingredientId)) {
      state = state.copyWith(
        selectedIngredientIds: selectedIds.where((id) => id != ingredientId).toList(),
      );
    } else {
      state = state.copyWith(
        selectedIngredientIds: [...selectedIds, ingredientId],
      );
    }
  }

  void clearSelection() {
    state = state.copyWith(selectedIngredientIds: []);
  }

  void selectAllIngredients() {
    final allIds = state.ingredients.map((ingredient) => ingredient.id).toList();
    state = state.copyWith(selectedIngredientIds: allIds);
  }

  // 获取筛选后的食材列表
  List<IngredientInventoryItem> get filteredIngredients {
    var ingredients = state.ingredients;
    
    if (state.searchQuery.isNotEmpty) {
      ingredients = ingredients.where((ingredient) {
        return ingredient.name.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
               ingredient.chineseName.contains(state.searchQuery);
      }).toList();
    }
    
    return ingredients;
  }

  // 获取库存统计
  Map<String, dynamic> get inventoryStats {
    final ingredients = state.ingredients;
    final totalIngredients = ingredients.length;
    final lowStockCount = ingredients.where((i) => i.currentStock <= i.minThreshold).length;
    final outOfStockCount = ingredients.where((i) => i.currentStock <= 0).length;
    final totalValue = ingredients.fold<double>(
      0.0,
      (sum, ingredient) => sum + (ingredient.currentStock * ingredient.costPerUnit),
    );
    
    return {
      'totalIngredients': totalIngredients,
      'lowStockCount': lowStockCount,
      'outOfStockCount': outOfStockCount,
      'totalValue': totalValue,
      'averageValue': totalIngredients > 0 ? totalValue / totalIngredients : 0.0,
    };
  }
}

// Provider instances
final merchantInventoryProvider = StateNotifierProvider.family<
    MerchantInventoryNotifier, MerchantInventoryState, String>(
  (ref, merchantId) {
    final repository = ref.read(merchantInventoryRepositoryProvider);
    return MerchantInventoryNotifier(repository, merchantId);
  },
);