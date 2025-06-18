/**
 * 营养购物车状态提供者
 * 使用Riverpod管理营养购物车状态
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutrition_cart.dart';
import '../../domain/repositories/nutrition_cart_repository.dart';
import '../../data/repositories/nutrition_cart_repository_impl.dart';
import '../../data/datasources/nutrition_cart_api.dart';
import 'package:dio/dio.dart';

part 'nutrition_cart_provider.freezed.dart';

// Repository provider
final nutritionCartRepositoryProvider = Provider<NutritionCartRepository>((ref) {
  // TODO: 从全局Dio provider获取实例
  final dio = Dio(); // 临时创建，后续需要从依赖注入获取
  final api = NutritionCartApi(dio);
  return NutritionCartRepositoryImpl(api);
});

// 营养购物车状态
@freezed
class NutritionCartState with _$NutritionCartState {
  const factory NutritionCartState({
    @Default(false) bool isLoading,
    @Default(false) bool isAnalyzing,
    @Default(false) bool isUpdating,
    NutritionCart? cart,
    NutritionBalanceAnalysis? analysis,
    @Default([]) List<RecommendedItem> recommendations,
    @Default([]) List<NutritionGoalTemplate> goalTemplates,
    @Default([]) List<String> availableCoupons,
    String? error,
    
    // UI状态
    @Default(false) bool showNutritionPanel,
    @Default(false) bool showRecommendations,
    @Default('cart') String currentView, // cart, nutrition, recommendations
    String? selectedMerchantId,
    
    // 分析结果缓存
    DateTime? lastAnalysisTime,
    @Default({}) Map<String, double> nutritionGoals,
    
    // 操作状态
    @Default({}) Map<String, bool> itemUpdatingStatus,
    @Default([]) List<String> unavailableItems,
  }) = _NutritionCartState;
}

// 营养购物车管理提供者
class NutritionCartNotifier extends StateNotifier<NutritionCartState> {
  final NutritionCartRepository _repository;
  final String userId;

  NutritionCartNotifier(this._repository, this.userId) 
      : super(const NutritionCartState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      loadCart(),
      loadGoalTemplates(),
      loadAvailableCoupons(),
    ]);
  }

  // 加载购物车
  Future<void> loadCart() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final cart = await _repository.getCart(userId);
      
      if (cart != null) {
        state = state.copyWith(cart: cart, isLoading: false);
        // 自动分析营养平衡
        await analyzeNutritionBalance();
      } else {
        // 创建新购物车
        await _createEmptyCart();
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> _createEmptyCart() async {
    final newCart = NutritionCart(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      createdAt: DateTime.now(),
    );
    
    await _repository.createCart(newCart);
    state = state.copyWith(cart: newCart, isLoading: false);
  }

  // 添加商品到购物车
  Future<void> addItem(NutritionCartItem item) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.addItem(userId, item);
      
      // 重新加载购物车
      await loadCart();
      state = state.copyWith(isUpdating: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 更新商品数量
  Future<void> updateItemQuantity(String itemId, double quantity) async {
    try {
      // 设置该商品的更新状态
      final updatingStatus = Map<String, bool>.from(state.itemUpdatingStatus);
      updatingStatus[itemId] = true;
      state = state.copyWith(itemUpdatingStatus: updatingStatus);

      await _repository.updateItemQuantity(userId, itemId, quantity);
      
      // 重新加载购物车
      await loadCart();
      
      // 清除更新状态
      updatingStatus.remove(itemId);
      state = state.copyWith(itemUpdatingStatus: updatingStatus);
    } catch (e) {
      final updatingStatus = Map<String, bool>.from(state.itemUpdatingStatus);
      updatingStatus.remove(itemId);
      state = state.copyWith(
        error: e.toString(),
        itemUpdatingStatus: updatingStatus,
      );
    }
  }

  // 移除商品
  Future<void> removeItem(String itemId) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.removeItem(userId, itemId);
      
      // 重新加载购物车
      await loadCart();
      state = state.copyWith(isUpdating: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 清空购物车
  Future<void> clearCart() async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      await _repository.clearCart(userId);
      
      // 创建新的空购物车
      await _createEmptyCart();
      state = state.copyWith(isUpdating: false, analysis: null);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }

  // 分析营养平衡
  Future<void> analyzeNutritionBalance() async {
    try {
      state = state.copyWith(isAnalyzing: true, error: null);
      
      final analysis = state.nutritionGoals.isNotEmpty
          ? await _repository.analyzeCartWithGoals(userId, state.nutritionGoals)
          : await _repository.analyzeNutritionBalance(userId);
      
      state = state.copyWith(
        analysis: analysis,
        isAnalyzing: false,
        lastAnalysisTime: DateTime.now(),
      );
      
      // 如果营养不平衡，自动获取推荐
      if (analysis.overallScore < 7.0) {
        await loadRecommendations();
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isAnalyzing: false);
    }
  }

  // 加载推荐商品
  Future<void> loadRecommendations() async {
    try {
      final recommendations = await _repository.getRecommendations(userId);
      state = state.copyWith(recommendations: recommendations);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 加载营养目标模板
  Future<void> loadGoalTemplates() async {
    try {
      final templates = await _repository.getGoalTemplates();
      state = state.copyWith(goalTemplates: templates);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 设置营养目标
  Future<void> setNutritionGoals(Map<String, double> goals) async {
    try {
      await _repository.setNutritionGoals(userId, goals);
      state = state.copyWith(nutritionGoals: goals);
      
      // 重新分析营养平衡
      await analyzeNutritionBalance();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 应用营养目标模板
  Future<void> applyGoalTemplate(String templateId) async {
    try {
      await _repository.applyGoalTemplate(userId, templateId);
      
      // 重新加载营养目标
      final goals = await _repository.getNutritionGoals(userId);
      if (goals != null) {
        state = state.copyWith(nutritionGoals: goals);
        await analyzeNutritionBalance();
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 加载可用优惠券
  Future<void> loadAvailableCoupons() async {
    try {
      final coupons = await _repository.getAvailableCoupons(userId);
      state = state.copyWith(availableCoupons: coupons);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 应用优惠券
  Future<void> applyCoupon(String couponCode) async {
    try {
      await _repository.applyCoupon(userId, couponCode);
      await loadCart(); // 重新加载以更新价格
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 设置配送信息
  Future<void> setDeliveryInfo(
    String address,
    DateTime preferredTime,
    String method,
  ) async {
    try {
      await _repository.setDeliveryInfo(userId, address, preferredTime, method);
      await loadCart(); // 重新加载以更新配送费
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 验证商品可用性
  Future<void> validateItemAvailability() async {
    try {
      final unavailableItems = await _repository.validateItemAvailability(userId);
      state = state.copyWith(unavailableItems: unavailableItems);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // UI状态管理
  void toggleNutritionPanel() {
    state = state.copyWith(showNutritionPanel: !state.showNutritionPanel);
  }

  void toggleRecommendations() {
    state = state.copyWith(showRecommendations: !state.showRecommendations);
  }

  void setCurrentView(String view) {
    state = state.copyWith(currentView: view);
  }

  void selectMerchant(String? merchantId) {
    state = state.copyWith(selectedMerchantId: merchantId);
  }

  // 获取按商家分组的商品
  Map<String, List<NutritionCartItem>> get itemsByMerchant {
    if (state.cart == null) return {};
    
    final Map<String, List<NutritionCartItem>> grouped = {};
    for (final item in state.cart!.items) {
      grouped.putIfAbsent(item.merchantId, () => []).add(item);
    }
    return grouped;
  }

  // 获取购物车统计
  Map<String, dynamic> get cartStatistics {
    final cart = state.cart;
    if (cart == null) return {};
    
    return {
      'totalItems': cart.items.length,
      'totalPrice': cart.totalPrice,
      'totalCalories': cart.totalCalories,
      'totalWeight': cart.totalWeight,
      'merchantCount': itemsByMerchant.length,
      'nutritionScore': state.analysis?.overallScore ?? 0.0,
    };
  }

  // 检查是否需要重新分析
  bool get needsReanalysis {
    if (state.lastAnalysisTime == null) return true;
    final timeSinceAnalysis = DateTime.now().difference(state.lastAnalysisTime!);
    return timeSinceAnalysis.inMinutes > 5; // 5分钟后重新分析
  }

  // 获取营养缺失项
  List<String> get nutritionDeficiencies {
    final analysis = state.analysis;
    if (analysis == null) return [];
    
    return analysis.elementAnalysis.entries
        .where((entry) => entry.value.status == 'deficient')
        .map((entry) => entry.value.elementName)
        .toList();
  }

  // 获取营养过量项
  List<String> get nutritionExcesses {
    final analysis = state.analysis;
    if (analysis == null) return [];
    
    return analysis.elementAnalysis.entries
        .where((entry) => entry.value.status == 'excessive')
        .map((entry) => entry.value.elementName)
        .toList();
  }

  // 智能购物车优化
  Future<void> optimizeCart(Map<String, double> priorities) async {
    try {
      state = state.copyWith(isUpdating: true, error: null);
      final optimizedCart = await _repository.optimizeCartForGoals(userId, priorities);
      
      state = state.copyWith(cart: optimizedCart, isUpdating: false);
      await analyzeNutritionBalance();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isUpdating: false);
    }
  }
}

// Provider instances
final nutritionCartProvider = StateNotifierProvider.family<
    NutritionCartNotifier, NutritionCartState, String>(
  (ref, userId) {
    final repository = ref.read(nutritionCartRepositoryProvider);
    return NutritionCartNotifier(repository, userId);
  },
);