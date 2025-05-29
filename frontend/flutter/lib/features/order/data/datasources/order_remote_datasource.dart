import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/order_model.dart';

part 'order_remote_datasource.g.dart';

@RestApi()
abstract class UorderRemoteDataSource {
  factory UorderRemoteDataSource(Dio dio) = _UorderRemoteDataSource;

  @GET('/orders')
  Future<List<UorderModel>> getUorders();

  @GET('/orders/{id}')
  Future<UorderModel> getUorder(@Path('id') String id);

  @POST('/orders')
  Future<UorderModel> createUorder(@Body() UorderModel order);

  @PUT('/orders/{id}')
  Future<UorderModel> updateUorder(
    @Path('id') String id,
    @Body() UorderModel order,
  );

  @DELETE('/orders/{id}')
  Future<void> deleteUorder(@Path('id') String id);
}
