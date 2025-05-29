import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/consultation_model.dart';

part 'consultation_remote_datasource.g.dart';

@RestApi()
abstract class UconsultationRemoteDataSource {
  factory UconsultationRemoteDataSource(Dio dio) = _UconsultationRemoteDataSource;

  @GET('/consultations')
  Future<List<UconsultationModel>> getUconsultations();

  @GET('/consultations/{id}')
  Future<UconsultationModel> getUconsultation(@Path('id') String id);

  @POST('/consultations')
  Future<UconsultationModel> createUconsultation(@Body() UconsultationModel consultation);

  @PUT('/consultations/{id}')
  Future<UconsultationModel> updateUconsultation(
    @Path('id') String id,
    @Body() UconsultationModel consultation,
  );

  @DELETE('/consultations/{id}')
  Future<void> deleteUconsultation(@Path('id') String id);
}
