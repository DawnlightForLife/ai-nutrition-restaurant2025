import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 营养档案列表状态
final nutritionProfilesProvider = StateNotifierProvider<NutritionProfilesNotifier, List<NutritionProfile>>((ref) {
  return NutritionProfilesNotifier();
});

class NutritionProfilesNotifier extends StateNotifier<List<NutritionProfile>> {
  NutritionProfilesNotifier() : super([]);

  void addProfile(NutritionProfile profile) {
    state = [...state, profile];
  }

  void updateProfile(NutritionProfile profile) {
    state = state.map((p) => p.id == profile.id ? profile : p).toList();
  }

  void removeProfile(String profileId) {
    state = state.where((p) => p.id != profileId).toList();
  }

  void loadProfiles() {
    // TODO: Load from repository
  }
}

/// 营养档案模型（临时）
class NutritionProfile {
  final String id;
  final String name;
  final int age;
  final double height;
  final double weight;
  final String goal;

  NutritionProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.weight,
    required this.goal,
  });
}