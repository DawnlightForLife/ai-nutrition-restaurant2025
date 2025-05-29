import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/common_model.dart';

part 'common_remote_datasource.g.dart';

@RestApi()
abstract class UcommonRemoteDataSource {
  factory UcommonRemoteDataSource(Dio dio) = _UcommonRemoteDataSource;

  @GET('/commons')
  Future<List<UcommonModel>> getUcommons();

  @GET('/commons/{id}')
  Future<UcommonModel> getUcommon(@Path('id') String id);

  @POST('/commons')
  Future<UcommonModel> createUcommon(@Body() UcommonModel common);

  @PUT('/commons/{id}')
  Future<UcommonModel> updateUcommon(
    @Path('id') String id,
    @Body() UcommonModel common,
  );

  @DELETE('/commons/{id}')
  Future<void> deleteUcommon(@Path('id') String id);
}
