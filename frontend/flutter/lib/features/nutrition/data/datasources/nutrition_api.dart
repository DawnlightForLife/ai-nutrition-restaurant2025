import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/network/api_client.dart';

part 'nutrition_api.g.dart';

/// 营养相关API接口定义
@RestApi()
abstract class NutritionApi {
  factory NutritionApi(Dio dio, {String baseUrl}) = _NutritionApi;
  
  /// 为ApiClient.getClient提供静态创建方法
  static NutritionApi create(ApiClient apiClient, {String? baseUrl}) {
    return NutritionApi(apiClient.getDio(), baseUrl: baseUrl ?? '');
  }

  /// 获取营养档案
  @GET('/nutrition/profile/{userId}')
  Future<dynamic> getNutritionProfile(
    @Path('userId') String userId,
  );

  /// 更新营养档案
  @PUT('/nutrition/profile/{userId}')
  Future<dynamic> updateNutritionProfile(
    @Path('userId') String userId,
    @Body() Map<String, dynamic> body,
  );

  /// 获取AI推荐
  @POST('/nutrition/ai-recommendations')
  Future<dynamic> getAiRecommendations(
    @Body() Map<String, dynamic> body,
  );

  /// 获取营养计划列表
  @GET('/nutrition/plans')
  Future<dynamic> getNutritionPlans(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// 创建营养计划
  @POST('/nutrition/plans')
  Future<dynamic> createNutritionPlan(
    @Body() Map<String, dynamic> body,
  );

  /// 记录餐食
  @POST('/nutrition/meals')
  Future<dynamic> recordMeal(
    @Body() Map<String, dynamic> body,
  );

  /// 获取餐食历史
  @GET('/nutrition/meals/history')
  Future<dynamic> getMealHistory(
    @Query('startDate') String startDate,
    @Query('endDate') String endDate,
  );
}