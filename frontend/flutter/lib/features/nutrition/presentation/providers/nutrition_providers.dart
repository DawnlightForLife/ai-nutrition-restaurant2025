/// 营养模块 Provider 统一导出
/// 
/// 提供营养模块相关的所有 Provider 和访问器
/// 避免使用全局 providers_index，实现模块化管理
library;

// 核心控制器
export 'nutrition_profile_controller.dart';
export 'nutrition_profile_provider.dart';

// TODO: 添加其他营养相关的 Provider
// export 'nutrition_recommendation_provider.dart';
// export 'nutrition_analysis_provider.dart';
// export 'dietary_preference_provider.dart';

/// 营养模块 Provider 访问器
/// 
/// 提供营养模块内部 Provider 的便捷访问方式
/// 遵循模块化设计原则，避免跨模块直接访问
class NutritionProviders {
  const NutritionProviders._();

  // 营养档案相关
  // static final nutritionProfileController = nutritionProfileControllerProvider;
  // static final nutritionProfiles = nutritionProfilesProvider;
  
  // TODO: 添加其他营养 Provider 的访问器
  // static final nutritionRecommendations = nutritionRecommendationsProvider;
  // static final nutritionAnalysis = nutritionAnalysisProvider;
  // static final dietaryPreferences = dietaryPreferencesProvider;
}