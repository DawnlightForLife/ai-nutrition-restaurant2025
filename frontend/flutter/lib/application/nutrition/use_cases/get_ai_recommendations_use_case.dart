import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/abstractions/repositories/i_nutrition_repository.dart';
import '../../../domain/common/failures/failure.dart';
import '../../../domain/nutrition/entities/ai_recommendation.dart';
import '../../../domain/user/value_objects/user_value_objects.dart';
import '../../core/use_case.dart';

/// 获取AI推荐用例参数
class GetAiRecommendationsParams extends Equatable {
  final UserId userId;
  final String? mealType;
  final List<String>? preferences;

  const GetAiRecommendationsParams({
    required this.userId,
    this.mealType,
    this.preferences,
  });

  @override
  List<Object?> get props => [userId, mealType, preferences];
}

/// 获取AI推荐用例
@injectable
class GetAiRecommendationsUseCase extends UseCase<List<AiRecommendation>, GetAiRecommendationsParams> {
  final INutritionRepository _repository;

  GetAiRecommendationsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AiRecommendation>>> call(GetAiRecommendationsParams params) {
    return _repository.getAiRecommendations(
      params.userId,
      mealType: params.mealType,
      preferences: params.preferences,
    );
  }
}