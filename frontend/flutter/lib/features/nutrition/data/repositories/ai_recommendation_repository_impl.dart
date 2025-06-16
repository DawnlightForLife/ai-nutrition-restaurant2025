import 'package:dio/dio.dart';
import '../../domain/entities/ai_recommendation.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/repositories/ai_recommendation_repository.dart';
import '../datasources/remote/ai_recommendation_api.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../shared/data/models/api_error_model.dart';

/// AI推荐仓库实现 - 使用真实的后端API
class AIRecommendationRepositoryImpl implements AIRecommendationRepository {
  final AIRecommendationApi _api;
  
  AIRecommendationRepositoryImpl({AIRecommendationApi? api})
      : _api = api ?? AIRecommendationApi(DioClient.instance);

  @override
  Future<AIRecommendation> generateRecommendation({
    required NutritionProfileV2 profile,
    String? requestId,
  }) async {
    try {
      final response = await _api.generateRecommendation(profile.id!);
      
      if (response.response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(response.data);
        
        if (apiResponse.success) {
          return _parseRecommendation(apiResponse.data);
        } else {
          throw Exception(apiResponse.message ?? '生成推荐失败');
        }
      } else {
        throw Exception('网络请求失败: ${response.response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('请求超时，请检查网络连接');
      } else if (e.response != null) {
        final errorData = ApiErrorModel.fromJson(e.response!.data);
        throw Exception(errorData.message);
      } else {
        throw Exception('网络连接失败: ${e.message}');
      }
    } catch (e) {
      throw Exception('生成推荐失败: $e');
    }
  }

  @override
  Future<List<AIRecommendation>> getRecommendationHistory(String profileId) async {
    try {
      final response = await _api.getRecommendationHistory(profileId);
      
      if (response.response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(response.data);
        
        if (apiResponse.success) {
          final List<dynamic> dataList = apiResponse.data as List<dynamic>;
          return dataList.map((item) => _parseRecommendation(item)).toList();
        } else {
          throw Exception(apiResponse.message ?? '获取历史失败');
        }
      } else {
        throw Exception('网络请求失败: ${response.response.statusCode}');
      }
    } catch (e) {
      throw Exception('获取推荐历史失败: $e');
    }
  }

  @override
  Future<void> submitFeedback({
    required String recommendationId,
    required int rating,
    String? comments,
    required bool isAccepted,
    Map<String, dynamic>? adjustments,
  }) async {
    try {
      final feedbackData = {
        'rating': rating,
        'comments': comments,
        'isAccepted': isAccepted,
        'adjustments': adjustments,
      };
      
      final response = await _api.submitFeedback(recommendationId, feedbackData);
      
      if (response.response.statusCode != 200) {
        throw Exception('提交反馈失败: ${response.response.statusCode}');
      }
    } catch (e) {
      // 反馈提交失败不应该影响主流程，记录错误即可
      print('提交反馈失败: $e');
    }
  }

  @override
  Future<AIRecommendation> saveUserAdjustments({
    required String recommendationId,
    required Map<String, dynamic> adjustments,
  }) async {
    try {
      final response = await _api.saveAdjustments(
        recommendationId,
        {'adjustments': adjustments},
      );
      
      if (response.response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(response.data);
        
        if (apiResponse.success) {
          return _parseRecommendation(apiResponse.data);
        } else {
          throw Exception(apiResponse.message ?? '保存调整失败');
        }
      } else {
        throw Exception('网络请求失败: ${response.response.statusCode}');
      }
    } catch (e) {
      throw Exception('保存调整失败: $e');
    }
  }

  @override
  Future<bool> validateRecommendation(AIRecommendation recommendation) async {
    // 基础验证规则
    final targets = recommendation.nutritionTargets;
    
    // 检查热量合理性 (800-4000 kcal)
    if (targets.dailyCalories < 800 || targets.dailyCalories > 4000) {
      return false;
    }
    
    // 检查宏量营养素比例
    if (!targets.macroRatio.isValid) {
      return false;
    }
    
    // 检查饮水量合理性 (1000-4000ml)
    if (targets.hydrationGoal < 1000 || targets.hydrationGoal > 4000) {
      return false;
    }
    
    return true;
  }

  /// 解析推荐数据
  AIRecommendation _parseRecommendation(Map<String, dynamic> data) {
    final targets = data['nutritionTargets'] as Map<String, dynamic>;
    final macroRatio = targets['macroRatio'] as Map<String, dynamic>;
    
    final nutritionTargets = NutritionTargets(
      dailyCalories: (targets['dailyCalories'] as num).toDouble(),
      hydrationGoal: (targets['hydrationGoal'] as num).toDouble(),
      mealFrequency: targets['mealFrequency'] as int,
      macroRatio: MacronutrientRatio(
        protein: (macroRatio['protein'] as num).toDouble(),
        fat: (macroRatio['fat'] as num).toDouble(),
        carbs: (macroRatio['carbs'] as num).toDouble(),
      ),
      vitaminTargets: Map<String, double>.from(
        (targets['vitaminTargets'] as Map).map(
          (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
        ),
      ),
      mineralTargets: Map<String, double>.from(
        (targets['mineralTargets'] as Map).map(
          (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
        ),
      ),
    );
    
    final explanations = (data['explanations'] as List<dynamic>)
        .map((item) => RecommendationExplanation(
              category: item['category'] as String,
              field: item['field'] as String,
              explanation: item['explanation'] as String,
              reasoning: item['reasoning'] as String,
            ))
        .toList();
    
    return AIRecommendation(
      id: data['id'] as String?,
      profileId: data['profileId'] as String,
      nutritionTargets: nutritionTargets,
      explanations: explanations,
      confidence: (data['confidence'] as num).toDouble(),
      source: _parseSource(data['source'] as String),
      createdAt: DateTime.parse(data['createdAt'] as String),
      userAdjustments: data['userAdjustments'] as Map<String, dynamic>?,
    );
  }

  /// 解析推荐来源
  RecommendationSource _parseSource(String source) {
    switch (source) {
      case 'mock':
        return RecommendationSource.mock;
      case 'deepseek':
        return RecommendationSource.deepseek;
      case 'rule_based':
        return RecommendationSource.ruleBased;
      case 'fallback':
      default:
        return RecommendationSource.hybrid;
    }
  }
}