import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/forum_model.dart';

part 'forum_remote_datasource.g.dart';

@RestApi()
abstract class UforumRemoteDataSource {
  factory UforumRemoteDataSource(Dio dio) = _UforumRemoteDataSource;

  @GET('/forums')
  Future<List<UforumModel>> getUforums();

  @GET('/forums/{id}')
  Future<UforumModel> getUforum(@Path('id') String id);

  @POST('/forums')
  Future<UforumModel> createUforum(@Body() UforumModel forum);

  @PUT('/forums/{id}')
  Future<UforumModel> updateUforum(
    @Path('id') String id,
    @Body() UforumModel forum,
  );

  @DELETE('/forums/{id}')
  Future<void> deleteUforum(@Path('id') String id);
}
