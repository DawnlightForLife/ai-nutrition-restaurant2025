import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/admin_model.dart';

part 'admin_remote_datasource.g.dart';

@RestApi()
abstract class UadminRemoteDataSource {
  factory UadminRemoteDataSource(Dio dio) = _UadminRemoteDataSource;

  @GET('/admins')
  Future<List<UadminModel>> getUadmins();

  @GET('/admins/{id}')
  Future<UadminModel> getUadmin(@Path('id') String id);

  @POST('/admins')
  Future<UadminModel> createUadmin(@Body() UadminModel admin);

  @PUT('/admins/{id}')
  Future<UadminModel> updateUadmin(
    @Path('id') String id,
    @Body() UadminModel admin,
  );

  @DELETE('/admins/{id}')
  Future<void> deleteUadmin(@Path('id') String id);
}
