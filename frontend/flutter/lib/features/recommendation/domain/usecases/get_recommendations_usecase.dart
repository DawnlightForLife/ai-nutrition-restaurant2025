import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/recommendation.dart';
import '../repositories/recommendation_repository.dart';

/// 获取Urecommendation列表用例
class GetUrecommendationsUseCase implements UseCase<List<Urecommendation>, NoParams> {
  final UrecommendationRepository repository;

  GetUrecommendationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Urecommendation>>> call(NoParams params) async {
    return await repository.getUrecommendations();
  }
}
