import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../entities/consultation.dart';

/// Uconsultation 仓储接口
abstract class UconsultationRepository {
  Future<Either<Failure, List<Uconsultation>>> getUconsultations();
  Future<Either<Failure, Uconsultation>> getUconsultation(String id);
  Future<Either<Failure, Uconsultation>> createUconsultation(Uconsultation consultation);
  Future<Either<Failure, Uconsultation>> updateUconsultation(Uconsultation consultation);
  Future<Either<Failure, Unit>> deleteUconsultation(String id);
}
