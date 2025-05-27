import 'package:dartz/dartz.dart';

import '../../domain/common/facade/module_facade.dart';
import '../../domain/common/failures/failures.dart';
import '../../domain/nutrition/entities/ai_recommendation.dart';
import '../../domain/nutrition/entities/nutrition_profile.dart';
import '../../domain/user/value_objects/user_value_objects.dart';
import '../nutrition/use_cases/get_ai_recommendations_use_case.dart';
import '../nutrition/use_cases/get_nutrition_profile_use_case.dart';
import '../nutrition/use_cases/update_nutrition_profile_use_case.dart';

/// Facade for the Nutrition bounded context
/// Provides a unified interface for all nutrition-related operations
class NutritionFacade implements ModuleFacade {
  final GetNutritionProfileUseCase _getNutritionProfileUseCase;
  final UpdateNutritionProfileUseCase _updateNutritionProfileUseCase;
  final GetAiRecommendationsUseCase _getAiRecommendationsUseCase;
  
  bool _isReady = false;
  
  NutritionFacade({
    required GetNutritionProfileUseCase getNutritionProfileUseCase,
    required UpdateNutritionProfileUseCase updateNutritionProfileUseCase,
    required GetAiRecommendationsUseCase getAiRecommendationsUseCase,
  })  : _getNutritionProfileUseCase = getNutritionProfileUseCase,
        _updateNutritionProfileUseCase = updateNutritionProfileUseCase,
        _getAiRecommendationsUseCase = getAiRecommendationsUseCase;
  
  @override
  String get moduleName => 'Nutrition';
  
  @override
  bool get isReady => _isReady;
  
  @override
  Future<void> initialize() async {
    _isReady = true;
  }
  
  @override
  Future<void> dispose() async {
    _isReady = false;
  }
  
  /// Get nutrition profile for a user
  Future<Either<AppFailure, NutritionProfile>> getNutritionProfile(UserId userId) {
    return _getNutritionProfileUseCase(GetNutritionProfileParams(userId: userId));
  }
  
  /// Update nutrition profile
  Future<Either<AppFailure, NutritionProfile>> updateNutritionProfile({
    required UserId userId,
    required NutritionProfile profile,
  }) {
    return _updateNutritionProfileUseCase(UpdateNutritionProfileParams(
      userId: userId,
      profile: profile,
    ));
  }
  
  /// Get AI recommendations
  Future<Either<AppFailure, List<AiRecommendation>>> getRecommendations({
    required UserId userId,
    String? mealType,
    List<String>? preferences,
  }) {
    return _getAiRecommendationsUseCase(GetAiRecommendationsParams(
      userId: userId,
      mealType: mealType,
      preferences: preferences,
    ));
  }
}