/**
 * 营养订餐Provider
 * 管理营养元素定制订餐的状态和业务逻辑
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutrition_ordering.dart';
import '../../data/datasources/nutrition_ordering_remote_datasource.dart';
import '../../../../core/network/dio_provider.dart';

part 'nutrition_ordering_provider.freezed.dart';

/// 营养订餐状态
@freezed
class NutritionOrderingState with _$NutritionOrderingState {
  const factory NutritionOrderingState({
    @Default(false) bool isLoading,
    @Default([]) List<NutritionElement> nutritionElements,
    @Default([]) List<IngredientNutrition> ingredients,
    @Default([]) List<CookingMethod> cookingMethods,
    @Default([]) List<OrderingSelection> selections,
    NutritionNeedsAnalysis? nutritionNeeds,
    NutritionBalanceAnalysis? balanceAnalysis,
    @Default([]) List<IngredientRecommendation> recommendations,
    NutritionScore? nutritionScore,
    Map<String, dynamic>? constants,
    String? errorMessage,
    @Default({}) Map<String, List<NutritionElement>> elementsByCategory,
    @Default({}) Map<String, List<IngredientNutrition>> ingredientsByCategory,
    @Default({}) Map<String, List<CookingMethod>> cookingMethodsByCategory,
    @Default({}) Map<String, double> currentNutritionIntake,
    @Default({}) Map<String, double> targetNutritionIntake,
  }) = _NutritionOrderingState;
}

/// 营养订餐Provider
class NutritionOrderingNotifier extends StateNotifier<NutritionOrderingState> {
  final NutritionOrderingRemoteDataSource _dataSource;

  NutritionOrderingNotifier(this._dataSource) : super(const NutritionOrderingState());

  /// 初始化数据
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      // 并行加载基础数据
      final nutritionConstants = await _dataSource.getNutritionConstants();
      final nutritionElements = await _dataSource.getNutritionElements(limit: 100);
      final ingredientNutrition = await _dataSource.getIngredientNutrition(limit: 100);
      final cookingMethods = await _dataSource.getCookingMethods(limit: 100);

      // 数据已经是正确的类型
      final constants = nutritionConstants;
      final elements = nutritionElements;
      final ingredients = ingredientNutrition;
      final cookingMethodsList = cookingMethods;

      // 按类别分组
      final elementsByCategory = _groupElementsByCategory(elements);
      final ingredientsByCategory = _groupIngredientsByCategory(ingredients);
      final cookingMethodsByCategory = _groupCookingMethodsByCategory(cookingMethodsList);

      state = state.copyWith(
        isLoading: false,
        constants: {},  // TODO: Update when constants are properly implemented
        nutritionElements: elements,
        ingredients: ingredients,
        cookingMethods: cookingMethodsList,
        elementsByCategory: elementsByCategory,
        ingredientsByCategory: ingredientsByCategory,
        cookingMethodsByCategory: cookingMethodsByCategory,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 分析营养需求
  Future<void> analyzeNutritionNeeds(String profileId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    try {
      final analysis = await _dataSource.calculatePersonalizedNeeds(
        request: {
          'userId': 'current_user', // TODO: 从用户状态获取
          'profileId': profileId,
        },
      );

      // 设置目标营养摄入量
      final targetIntake = <String, double>{};
      final dailyNeeds = analysis.dailyNeeds;
      if (dailyNeeds != null) {
        dailyNeeds.forEach((key, value) {
          if (value is num) {
            targetIntake[key] = value.toDouble();
          }
        });
      }

      state = state.copyWith(
        isLoading: false,
        nutritionNeeds: analysis,
        targetNutritionIntake: targetIntake,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// 添加食材选择
  Future<void> addIngredientSelection({
    required String ingredientId,
    required String ingredientName,
    required double amount,
    required String unit,
    String? cookingMethod,
    String? cookingMethodName,
  }) async {
    try {
      // 计算该食材的营养成分
      final nutritionCalculation = await _dataSource.calculateIngredientNutrition(
        request: {
          'ingredientId': ingredientId,
          'amount': amount,
          'cookingMethod': cookingMethod ?? 'raw',
        },
      );

      final selection = OrderingSelection(
        ingredientId: ingredientId,
        ingredientName: ingredientName,
        amount: amount,
        unit: unit,
        cookingMethod: cookingMethod,
        cookingMethodName: cookingMethodName,
        nutritionCalculation: nutritionCalculation,
        selectedAt: DateTime.now(),
      );

      final updatedSelections = [...state.selections, selection];
      state = state.copyWith(selections: updatedSelections);

      // 重新计算营养平衡
      await _updateNutritionBalance();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 移除食材选择
  void removeIngredientSelection(int index) {
    final updatedSelections = [...state.selections];
    updatedSelections.removeAt(index);
    state = state.copyWith(selections: updatedSelections);
    
    // 重新计算营养平衡
    _updateNutritionBalance();
  }

  /// 更新食材选择的份量
  Future<void> updateIngredientAmount(int index, double newAmount) async {
    if (index >= state.selections.length) return;

    final selection = state.selections[index];
    
    try {
      // 重新计算营养成分
      final nutritionCalculation = await _dataSource.calculateIngredientNutrition(
        request: {
          'ingredientId': selection.ingredientId,
          'amount': newAmount,
          'cookingMethod': selection.cookingMethod ?? 'raw',
        },
      );

      final updatedSelection = selection.copyWith(
        amount: newAmount,
        nutritionCalculation: nutritionCalculation,
      );

      final updatedSelections = [...state.selections];
      updatedSelections[index] = updatedSelection;
      
      state = state.copyWith(selections: updatedSelections);

      // 重新计算营养平衡
      await _updateNutritionBalance();
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 更新营养平衡分析
  Future<void> _updateNutritionBalance() async {
    if (state.selections.isEmpty || state.targetNutritionIntake.isEmpty) {
      state = state.copyWith(
        balanceAnalysis: null,
        currentNutritionIntake: {},
        nutritionScore: null,
      );
      return;
    }

    try {
      // 计算当前总营养摄入
      final combinedNutrition = await _dataSource.calculateCombinedNutrition(
        request: {
          'ingredients': state.selections.map((s) => {
            'id': s.ingredientId,
            'amount': s.amount,
            'cookingMethod': s.cookingMethod ?? 'raw',
          }).toList(),
        },
      );

      // 提取当前营养摄入量
      final currentIntake = <String, double>{};
      final totalNutrition = combinedNutrition['totalNutrition'] as List? ?? [];
      for (final nutrient in totalNutrition) {
        final element = nutrient['element'] as String;
        final amount = (nutrient['amount'] as num).toDouble();
        currentIntake[element] = amount;
      }

      // 分析营养平衡
      final balanceAnalysis = await _dataSource.analyzeNutritionMatch(
        request: {
          'currentNutrition': currentIntake,
          'targetNeeds': state.targetNutritionIntake,
        },
      );

      // 计算营养评分
      final nutritionScore = await _dataSource.calculateNutritionScore(
        request: {
          'recipeNutrition': currentIntake,
          'targetNeeds': state.targetNutritionIntake,
        },
      );

      state = state.copyWith(
        currentNutritionIntake: currentIntake,
        balanceAnalysis: balanceAnalysis,
        nutritionScore: nutritionScore,
      );

      // 更新食材推荐
      if (balanceAnalysis.gaps.isNotEmpty) {
        await _updateIngredientRecommendations(balanceAnalysis.gaps);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 更新食材推荐
  Future<void> _updateIngredientRecommendations(List<NutritionGap> gaps) async {
    try {
      final recommendations = await _dataSource.recommendIngredients(
        request: {
          'nutritionGaps': gaps.map((gap) => {
            'element': gap.element,
            'amount': gap.gapAmount,
            'unit': gap.unit,
          }).toList(),
          'preferences': {
            'allergens': [], // TODO: 从用户偏好获取
            'dietaryType': 'omnivore', // TODO: 从用户偏好获取
          },
        },
      );

      state = state.copyWith(recommendations: recommendations);
    } catch (e) {
      // 推荐失败不影响主流程
      print('获取食材推荐失败: $e');
    }
  }

  /// 搜索营养元素
  Future<void> searchNutritionElements(String query) async {
    if (query.isEmpty) {
      // 重置为全部元素
      state = state.copyWith(nutritionElements: state.nutritionElements);
      return;
    }

    try {
      final elements = await _dataSource.getNutritionElements(
        search: query,
        limit: 50,
      );

      state = state.copyWith(nutritionElements: elements);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 搜索食材
  Future<void> searchIngredients(String query, {String? category}) async {
    try {
      final ingredients = await _dataSource.getIngredientNutrition(
        search: query.isEmpty ? null : query,
        category: category,
        limit: 50,
      );

      state = state.copyWith(ingredients: ingredients);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  /// 按类别筛选营养元素
  void filterElementsByCategory(String category) {
    final filtered = state.elementsByCategory[category] ?? [];
    state = state.copyWith(nutritionElements: filtered);
  }

  /// 按类别筛选食材
  void filterIngredientsByCategory(String category) {
    final filtered = state.ingredientsByCategory[category] ?? [];
    state = state.copyWith(ingredients: filtered);
  }

  /// 清除所有选择
  void clearAllSelections() {
    state = state.copyWith(
      selections: [],
      currentNutritionIntake: {},
      balanceAnalysis: null,
      nutritionScore: null,
      recommendations: [],
    );
  }

  /// 清除错误信息
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 按类别分组营养元素
  Map<String, List<NutritionElement>> _groupElementsByCategory(
    List<NutritionElement> elements,
  ) {
    final Map<String, List<NutritionElement>> grouped = {};
    for (final element in elements) {
      grouped.putIfAbsent(element.category, () => []).add(element);
    }
    return grouped;
  }

  /// 按类别分组食材
  Map<String, List<IngredientNutrition>> _groupIngredientsByCategory(
    List<IngredientNutrition> ingredients,
  ) {
    final Map<String, List<IngredientNutrition>> grouped = {};
    for (final ingredient in ingredients) {
      grouped.putIfAbsent(ingredient.category, () => []).add(ingredient);
    }
    return grouped;
  }

  /// 按类别分组烹饪方式
  Map<String, List<CookingMethod>> _groupCookingMethodsByCategory(
    List<CookingMethod> methods,
  ) {
    final Map<String, List<CookingMethod>> grouped = {};
    for (final method in methods) {
      grouped.putIfAbsent(method.category, () => []).add(method);
    }
    return grouped;
  }
}

/// 营养订餐Provider
final nutritionOrderingProvider = StateNotifierProvider<NutritionOrderingNotifier, NutritionOrderingState>((ref) {
  final dio = ref.watch(dioProvider);
  final dataSource = NutritionOrderingRemoteDataSource(dio);
  return NutritionOrderingNotifier(dataSource);
});

/// 营养元素常量Provider
final nutritionConstantsProvider = FutureProvider<List<NutritionElement>>((ref) async {
  final dio = ref.watch(dioProvider);
  final dataSource = NutritionOrderingRemoteDataSource(dio);
  return dataSource.getNutritionConstants();
});

/// 按类别分组的营养元素Provider
final nutritionElementsByCategoryProvider = Provider<Map<String, List<NutritionElement>>>((ref) {
  return ref.watch(nutritionOrderingProvider).elementsByCategory;
});

/// 按类别分组的食材Provider
final ingredientsByCategoryProvider = Provider<Map<String, List<IngredientNutrition>>>((ref) {
  return ref.watch(nutritionOrderingProvider).ingredientsByCategory;
});

/// 当前营养平衡分析Provider
final nutritionBalanceProvider = Provider<NutritionBalanceAnalysis?>((ref) {
  return ref.watch(nutritionOrderingProvider).balanceAnalysis;
});

/// 营养评分Provider
final nutritionScoreProvider = Provider<NutritionScore?>((ref) {
  return ref.watch(nutritionOrderingProvider).nutritionScore;
});

/// 食材推荐Provider
final ingredientRecommendationsProvider = Provider<List<IngredientRecommendation>>((ref) {
  return ref.watch(nutritionOrderingProvider).recommendations;
});