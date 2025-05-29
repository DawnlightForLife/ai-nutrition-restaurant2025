import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/user_model.dart';

part 'user_remote_datasource.g.dart';

@RestApi()
abstract class UuserRemoteDataSource {
  factory UuserRemoteDataSource(Dio dio) = _UuserRemoteDataSource;

  @GET('/users')
  Future<List<UuserModel>> getUusers();

  @GET('/users/{id}')
  Future<UuserModel> getUuser(@Path('id') String id);

  @POST('/users')
  Future<UuserModel> createUuser(@Body() UuserModel user);

  @PUT('/users/{id}')
  Future<UuserModel> updateUuser(
    @Path('id') String id,
    @Body() UuserModel user,
  );

  @DELETE('/users/{id}')
  Future<void> deleteUuser(@Path('id') String id);
}
