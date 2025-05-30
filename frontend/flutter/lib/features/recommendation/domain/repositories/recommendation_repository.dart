import 'package:dartz/dartz.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';
import '../entities/recommendation.dart';

/// Urecommendation 仓储接口
abstract class UrecommendationRepository {
  Future<Either<Failure, List<Urecommendation>>> getUrecommendations();
  Future<Either<Failure, Urecommendation>> getUrecommendation(String id);
  Future<Either<Failure, Urecommendation>> createUrecommendation(Urecommendation recommendation);
  Future<Either<Failure, Urecommendation>> updateUrecommendation(Urecommendation recommendation);
  Future<Either<Failure, Unit>> deleteUrecommendation(String id);
}
