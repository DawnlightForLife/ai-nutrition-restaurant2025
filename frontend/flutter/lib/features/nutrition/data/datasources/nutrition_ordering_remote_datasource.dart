/**
 * 营养订餐远程数据源
 * 负责与后端API交互，获取营养元素、食材和烹饪方式数据
 */

import 'package:dio/dio.dart';
import '../../domain/entities/nutrition_ordering.dart';

abstract class NutritionOrderingRemoteDataSource {
  factory NutritionOrderingRemoteDataSource(Dio dio, {String baseUrl}) = NutritionOrderingRemoteDataSourceImpl;

  /// 获取营养元素常量
  Future<List<NutritionElement>> getNutritionConstants();

  /// 获取营养元素列表
  Future<List<NutritionElement>> getNutritionElements({
    int? page,
    int? limit,
    String? category,
    String? importance,
    String? functions,
    String? search,
    String? sortBy,
    String? sortOrder,
  });

  /// 根据ID获取营养元素详情
  Future<NutritionElement> getNutritionElementById(String id);

  /// 按类别获取营养元素
  Future<List<NutritionElement>> getNutritionElementsByCategory(String category);

  /// 按功能获取营养元素
  Future<List<NutritionElement>> getNutritionElementsByFunction(String functionCategory);

  /// 获取推荐摄入量
  Future<Map<String, dynamic>> getRecommendedIntake(
    String id, {
    required String gender,
    required String ageGroup,
    String? condition,
  });

  /// 获取食材营养信息列表
  Future<List<IngredientNutrition>> getIngredientNutrition({
    int? page,
    int? limit,
    String? category,
    String? nutritionDensity,
    String? search,
    String? allergenFree,
    String? sortBy,
    String? sortOrder,
  });

  /// 根据ID获取食材营养信息
  Future<IngredientNutrition> getIngredientNutritionById(String id);

  /// 按类别获取食材
  Future<List<IngredientNutrition>> getIngredientsByCategory(String category);

  /// 查找富含特定营养素的食材
  Future<List<IngredientNutrition>> getIngredientsRichIn(
    String nutrient, {
    double? minAmount,
  });

  /// 查找无过敏原食材
  Future<List<IngredientNutrition>> getAllergenFreeIngredients(String allergens);

  /// 获取烹饪方式列表
  Future<List<CookingMethod>> getCookingMethods({
    int? page,
    int? limit,
    String? category,
    String? nutritionEfficiency,
    String? difficulty,
    String? search,
  });

  /// 根据ID获取烹饪方式详情
  Future<CookingMethod> getCookingMethodById(String id);

  /// 按类别获取烹饪方式
  Future<List<CookingMethod>> getCookingMethodsByCategory(String category);

  /// 获取最佳营养保留烹饪方式
  Future<List<CookingMethod>> getBestNutritionMethods({
    double? minRetention,
  });

  /// 按难度获取烹饪方式
  Future<List<CookingMethod>> getCookingMethodsByDifficulty(String difficulty);

  /// 计算食材营养成分
  Future<Map<String, dynamic>> calculateIngredientNutrition({
    required Map<String, dynamic> request,
  });

  /// 计算食材组合营养
  Future<Map<String, dynamic>> calculateCombinedNutrition({
    required Map<String, dynamic> request,
  });

  /// 计算个性化营养需求
  Future<NutritionNeedsAnalysis> calculatePersonalizedNeeds({
    required Map<String, dynamic> request,
  });

  /// 营养目标匹配分析
  Future<NutritionBalanceAnalysis> analyzeNutritionMatch({
    required Map<String, dynamic> request,
  });

  /// 智能食材推荐
  Future<List<IngredientRecommendation>> recommendIngredients({
    required Map<String, dynamic> request,
  });

  /// 计算营养评分
  Future<NutritionScore> calculateNutritionScore({
    required Map<String, dynamic> request,
  });
}

/// 营养订餐数据源实现类
class NutritionOrderingRemoteDataSourceImpl implements NutritionOrderingRemoteDataSource {
  final Dio _dio;
  final String _baseUrl;

  NutritionOrderingRemoteDataSourceImpl(this._dio, {String baseUrl = ''}) 
    : _baseUrl = baseUrl;

  @override
  Future<List<NutritionElement>> getNutritionConstants() async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/elements/constants');
      return (response.data as List)
          .map((json) => NutritionElement.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NutritionElement>> getNutritionElements({
    int? page,
    int? limit,
    String? category,
    String? importance,
    String? functions,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/nutrition/elements',
        queryParameters: {
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
          if (category != null) 'category': category,
          if (importance != null) 'importance': importance,
          if (functions != null) 'functions': functions,
          if (search != null) 'search': search,
          if (sortBy != null) 'sortBy': sortBy,
          if (sortOrder != null) 'sortOrder': sortOrder,
        },
      );
      return (response.data as List)
          .map((json) => NutritionElement.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionElement> getNutritionElementById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/elements/$id');
      return NutritionElement.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NutritionElement>> getNutritionElementsByCategory(String category) async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/elements/category/$category');
      return (response.data as List)
          .map((json) => NutritionElement.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<NutritionElement>> getNutritionElementsByFunction(String functionCategory) async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/elements/function/$functionCategory');
      return (response.data as List)
          .map((json) => NutritionElement.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getRecommendedIntake(
    String id, {
    required String gender,
    required String ageGroup,
    String? condition,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/nutrition/elements/$id/recommended-intake',
        queryParameters: {
          'gender': gender,
          'ageGroup': ageGroup,
          if (condition != null) 'condition': condition,
        },
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<IngredientNutrition>> getIngredientNutrition({
    int? page,
    int? limit,
    String? category,
    String? nutritionDensity,
    String? search,
    String? allergenFree,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/nutrition/ingredients',
        queryParameters: {
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
          if (category != null) 'category': category,
          if (nutritionDensity != null) 'nutritionDensity': nutritionDensity,
          if (search != null) 'search': search,
          if (allergenFree != null) 'allergenFree': allergenFree,
          if (sortBy != null) 'sortBy': sortBy,
          if (sortOrder != null) 'sortOrder': sortOrder,
        },
      );
      return (response.data as List)
          .map((json) => IngredientNutrition.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<IngredientNutrition> getIngredientNutritionById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/ingredients/$id');
      return IngredientNutrition.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<IngredientNutrition>> getIngredientsByCategory(String category) async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/ingredients/category/$category');
      return (response.data as List)
          .map((json) => IngredientNutrition.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<IngredientNutrition>> getIngredientsRichIn(
    String nutrient, {
    double? minAmount,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/nutrition/ingredients/rich-in/$nutrient',
        queryParameters: {
          if (minAmount != null) 'minAmount': minAmount,
        },
      );
      return (response.data as List)
          .map((json) => IngredientNutrition.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<IngredientNutrition>> getAllergenFreeIngredients(String allergens) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/nutrition/ingredients/allergen-free',
        queryParameters: {'allergens': allergens},
      );
      return (response.data as List)
          .map((json) => IngredientNutrition.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<CookingMethod>> getCookingMethods({
    int? page,
    int? limit,
    String? category,
    String? nutritionEfficiency,
    String? difficulty,
    String? search,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/nutrition/cooking-methods',
        queryParameters: {
          if (page != null) 'page': page,
          if (limit != null) 'limit': limit,
          if (category != null) 'category': category,
          if (nutritionEfficiency != null) 'nutritionEfficiency': nutritionEfficiency,
          if (difficulty != null) 'difficulty': difficulty,
          if (search != null) 'search': search,
        },
      );
      return (response.data as List)
          .map((json) => CookingMethod.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<CookingMethod> getCookingMethodById(String id) async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/cooking-methods/$id');
      return CookingMethod.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<CookingMethod>> getCookingMethodsByCategory(String category) async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/cooking-methods/category/$category');
      return (response.data as List)
          .map((json) => CookingMethod.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<CookingMethod>> getBestNutritionMethods({
    double? minRetention,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/nutrition/cooking-methods/best-nutrition',
        queryParameters: {
          if (minRetention != null) 'minRetention': minRetention,
        },
      );
      return (response.data as List)
          .map((json) => CookingMethod.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<CookingMethod>> getCookingMethodsByDifficulty(String difficulty) async {
    try {
      final response = await _dio.get('$_baseUrl/nutrition/cooking-methods/difficulty/$difficulty');
      return (response.data as List)
          .map((json) => CookingMethod.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> calculateIngredientNutrition({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/nutrition/calculate/ingredient',
        data: request,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> calculateCombinedNutrition({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/nutrition/calculate/combined',
        data: request,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionNeedsAnalysis> calculatePersonalizedNeeds({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/nutrition/calculate/personalized-needs',
        data: request,
      );
      return NutritionNeedsAnalysis.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionBalanceAnalysis> analyzeNutritionMatch({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/nutrition/analyze/match',
        data: request,
      );
      return NutritionBalanceAnalysis.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<IngredientRecommendation>> recommendIngredients({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/nutrition/recommend/ingredients',
        data: request,
      );
      return (response.data as List)
          .map((json) => IngredientRecommendation.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<NutritionScore> calculateNutritionScore({
    required Map<String, dynamic> request,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/nutrition/score/calculate',
        data: request,
      );
      return NutritionScore.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 错误处理
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('网络连接超时，请检查网络连接');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? '服务器错误';
          return Exception('请求失败($statusCode): $message');
        case DioExceptionType.cancel:
          return Exception('请求已取消');
        case DioExceptionType.connectionError:
          return Exception('网络连接错误，请检查网络设置');
        default:
          return Exception('未知网络错误: ${error.message}');
      }
    }
    return Exception('数据处理错误: $error');
  }
}