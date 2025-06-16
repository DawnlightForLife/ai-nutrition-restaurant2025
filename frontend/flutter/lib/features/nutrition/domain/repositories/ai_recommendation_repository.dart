import '../entities/ai_recommendation.dart';
import '../entities/nutrition_profile_v2.dart';

/// AI推荐仓库接口
/// 遵循Clean Architecture的Repository模式
abstract class AIRecommendationRepository {
  /// 基于营养档案生成AI推荐
  Future<AIRecommendation> generateRecommendation({
    required NutritionProfileV2 profile,
    String? requestId,
  });

  /// 获取历史推荐记录
  Future<List<AIRecommendation>> getRecommendationHistory(String profileId);

  /// 提交用户反馈
  Future<void> submitFeedback({
    required String recommendationId,
    required int rating,
    String? comments,
    required bool isAccepted,
    Map<String, dynamic>? adjustments,
  });

  /// 保存用户调整
  Future<AIRecommendation> saveUserAdjustments({
    required String recommendationId,
    required Map<String, dynamic> adjustments,
  });

  /// 验证推荐结果
  Future<bool> validateRecommendation(AIRecommendation recommendation);
}