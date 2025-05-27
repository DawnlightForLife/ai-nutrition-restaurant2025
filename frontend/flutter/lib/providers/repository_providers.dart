import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/nutrition_profile_repository.dart';
import '../repositories/nutrition_profile_repository_impl.dart';

// 营养档案Repository Provider
final nutritionProfileRepositoryProvider = Provider<NutritionProfileRepository>((ref) {
  return NutritionProfileRepositoryImpl();
});