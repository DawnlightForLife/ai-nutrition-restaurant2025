/// AI推荐模块 Provider 统一导出
/// 
/// 提供AI推荐模块相关的所有 Provider 和访问器
/// 避免使用全局 providers_index，实现模块化管理
library;

// 核心控制器
export 'recommendation_controller.dart';
export 'recommendation_provider.dart';

// TODO: 添加其他推荐相关的 Provider
// export 'ai_chat_provider.dart';
// export 'recommendation_feedback_provider.dart';
// export 'recommendation_history_provider.dart';

/// AI推荐模块 Provider 访问器
/// 
/// 提供推荐模块内部 Provider 的便捷访问方式
/// 遵循模块化设计原则，避免跨模块直接访问
class RecommendationProviders {
  const RecommendationProviders._();

  // 推荐相关
  // static final recommendationController = recommendationControllerProvider;
  // static final recommendations = recommendationsProvider;
  
  // TODO: 添加其他推荐 Provider 的访问器
  // static final aiChat = aiChatProvider;
  // static final recommendationFeedback = recommendationFeedbackProvider;
  // static final recommendationHistory = recommendationHistoryProvider;
}