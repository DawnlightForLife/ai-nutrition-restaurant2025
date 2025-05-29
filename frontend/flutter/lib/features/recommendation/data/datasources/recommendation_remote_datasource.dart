import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/recommendation_model.dart';

part 'recommendation_remote_datasource.g.dart';

@RestApi()
abstract class UrecommendationRemoteDataSource {
  factory UrecommendationRemoteDataSource(Dio dio) = _UrecommendationRemoteDataSource;

  @GET('/recommendations')
  Future<List<UrecommendationModel>> getUrecommendations();

  @GET('/recommendations/{id}')
  Future<UrecommendationModel> getUrecommendation(@Path('id') String id);

  @POST('/recommendations')
  Future<UrecommendationModel> createUrecommendation(@Body() UrecommendationModel recommendation);

  @PUT('/recommendations/{id}')
  Future<UrecommendationModel> updateUrecommendation(
    @Path('id') String id,
    @Body() UrecommendationModel recommendation,
  );

  @DELETE('/recommendations/{id}')
  Future<void> deleteUrecommendation(@Path('id') String id);
}
