import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/merchant_model.dart';

part 'merchant_remote_datasource.g.dart';

@RestApi()
abstract class UmerchantRemoteDataSource {
  factory UmerchantRemoteDataSource(Dio dio) = _UmerchantRemoteDataSource;

  @GET('/merchants')
  Future<List<UmerchantModel>> getUmerchants();

  @GET('/merchants/{id}')
  Future<UmerchantModel> getUmerchant(@Path('id') String id);

  @POST('/merchants')
  Future<UmerchantModel> createUmerchant(@Body() UmerchantModel merchant);

  @PUT('/merchants/{id}')
  Future<UmerchantModel> updateUmerchant(
    @Path('id') String id,
    @Body() UmerchantModel merchant,
  );

  @DELETE('/merchants/{id}')
  Future<void> deleteUmerchant(@Path('id') String id);
}
