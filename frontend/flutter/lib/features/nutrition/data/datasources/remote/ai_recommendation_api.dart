import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../domain/entities/ai_recommendation.dart';

part 'ai_recommendation_api.g.dart';

/// AI推荐API接口
@RestApi()
abstract class AIRecommendationApi {
  factory AIRecommendationApi(Dio dio, {String baseUrl}) = _AIRecommendationApi;

  /// 生成AI营养推荐
  @POST('/nutrition/profiles/{profileId}/recommendations')
  Future<HttpResponse<Map<String, dynamic>>> generateRecommendation(
    @Path('profileId') String profileId,
  );

  /// 获取推荐历史
  @GET('/nutrition/profiles/{profileId}/recommendations')
  Future<HttpResponse<Map<String, dynamic>>> getRecommendationHistory(
    @Path('profileId') String profileId,
  );

  /// 提交推荐反馈
  @POST('/nutrition/recommendations/{recommendationId}/feedback')
  Future<HttpResponse<Map<String, dynamic>>> submitFeedback(
    @Path('recommendationId') String recommendationId,
    @Body() Map<String, dynamic> feedback,
  );

  /// 保存用户调整
  @PUT('/nutrition/recommendations/{recommendationId}/adjustments')
  Future<HttpResponse<Map<String, dynamic>>> saveAdjustments(
    @Path('recommendationId') String recommendationId,
    @Body() Map<String, dynamic> adjustments,
  );
}