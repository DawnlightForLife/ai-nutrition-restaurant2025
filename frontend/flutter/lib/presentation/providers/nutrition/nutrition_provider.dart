import 'package:flutter/foundation.dart';
import '../../../domain/abstractions/repositories/i_nutrition_repository.dart';

/// 营养Provider
class NutritionProvider extends ChangeNotifier {
  final INutritionRepository _nutritionRepository;
  final String _userId;
  
  NutritionProvider({
    required INutritionRepository nutritionRepository,
    required String userId,
  }) : _nutritionRepository = nutritionRepository,
       _userId = userId;
  
  // TODO(dev): 实现营养相关功能
}