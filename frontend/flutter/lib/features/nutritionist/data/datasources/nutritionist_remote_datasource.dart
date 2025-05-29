import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/nutritionist_model.dart';

part 'nutritionist_remote_datasource.g.dart';

@RestApi()
abstract class UnutritionistRemoteDataSource {
  factory UnutritionistRemoteDataSource(Dio dio) = _UnutritionistRemoteDataSource;

  @GET('/nutritionists')
  Future<List<UnutritionistModel>> getUnutritionists();

  @GET('/nutritionists/{id}')
  Future<UnutritionistModel> getUnutritionist(@Path('id') String id);

  @POST('/nutritionists')
  Future<UnutritionistModel> createUnutritionist(@Body() UnutritionistModel nutritionist);

  @PUT('/nutritionists/{id}')
  Future<UnutritionistModel> updateUnutritionist(
    @Path('id') String id,
    @Body() UnutritionistModel nutritionist,
  );

  @DELETE('/nutritionists/{id}')
  Future<void> deleteUnutritionist(@Path('id') String id);
}
