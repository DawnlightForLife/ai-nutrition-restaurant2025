import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/ai_recommendation.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/repositories/ai_recommendation_repository.dart';
import '../../data/repositories/mock_ai_recommendation_repository.dart';

part 'ai_recommendation_provider.freezed.dart';

/// AI推荐状态
@freezed
class AIRecommendationState with _$AIRecommendationState {
  const factory AIRecommendationState({
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    String? errorMessage,
    AIRecommendation? recommendation,
    @Default({}) Map<String, dynamic> userAdjustments,
    @Default([]) List<AIRecommendation> history,
  }) = _AIRecommendationState;
}

/// AI推荐仓库Provider
final aiRecommendationRepositoryProvider = Provider<AIRecommendationRepository>((ref) {
  // 这里可以根据配置切换Mock和真实实现
  return MockAIRecommendationRepository();
});

/// AI推荐Provider - 使用family支持多个档案
final aiRecommendationProvider = StateNotifierProvider.family
    .autoDispose<AIRecommendationNotifier, AIRecommendationState, String>(
  (ref, profileId) {
    final repository = ref.read(aiRecommendationRepositoryProvider);
    return AIRecommendationNotifier(repository, profileId);
  },
);

/// AI推荐状态管理器
class AIRecommendationNotifier extends StateNotifier<AIRecommendationState> {
  final AIRecommendationRepository _repository;
  final String _profileId;

  AIRecommendationNotifier(this._repository, this._profileId)
      : super(const AIRecommendationState());

  /// 生成AI推荐
  Future<void> generateRecommendation(NutritionProfileV2 profile) async {
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    );

    try {
      final recommendation = await _repository.generateRecommendation(
        profile: profile,
        requestId: _generateRequestId(),
      );

      // 验证推荐结果
      final isValid = await _repository.validateRecommendation(recommendation);
      if (!isValid) {
        throw Exception('AI推荐结果验证失败，请重试');
      }

      state = state.copyWith(
        isLoading: false,
        recommendation: recommendation,
        userAdjustments: {}, // 重置用户调整
      );

      // 记录成功日志
      _logRecommendationGenerated(recommendation);

    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: _formatErrorMessage(e),
      );

      // 记录错误日志
      _logError('生成AI推荐失败', e, stackTrace);
    }
  }

  /// 调整推荐参数
  void adjustRecommendation(String field, dynamic value) {
    if (state.recommendation == null) return;

    final adjustments = Map<String, dynamic>.from(state.userAdjustments);
    adjustments[field] = value;

    state = state.copyWith(userAdjustments: adjustments);

    // 实时更新推荐值（为了UI展示）
    _updateRecommendationDisplay(field, value);
  }

  /// 保存用户调整
  Future<void> saveAdjustments() async {
    if (state.recommendation?.id == null || state.userAdjustments.isEmpty) {
      return;
    }

    try {
      final updatedRecommendation = await _repository.saveUserAdjustments(
        recommendationId: state.recommendation!.id!,
        adjustments: state.userAdjustments,
      );

      state = state.copyWith(recommendation: updatedRecommendation);
    } catch (e) {
      // 静默处理保存失败，不影响用户体验
      _logError('保存用户调整失败', e, null);
    }
  }

  /// 提交反馈
  Future<void> submitFeedback({
    required int rating,
    String? comments,
    required bool isAccepted,
  }) async {
    if (state.recommendation?.id == null) return;

    try {
      await _repository.submitFeedback(
        recommendationId: state.recommendation!.id!,
        rating: rating,
        comments: comments,
        isAccepted: isAccepted,
        adjustments: state.userAdjustments.isNotEmpty ? state.userAdjustments : null,
      );

      _logFeedbackSubmitted(rating, isAccepted);
    } catch (e) {
      // 反馈提交失败不影响主流程
      _logError('提交反馈失败', e, null);
    }
  }

  /// 获取推荐历史
  Future<void> loadRecommendationHistory() async {
    try {
      final history = await _repository.getRecommendationHistory(_profileId);
      state = state.copyWith(history: history);
    } catch (e) {
      _logError('加载推荐历史失败', e, null);
    }
  }

  /// 重新生成推荐
  Future<void> regenerateRecommendation(NutritionProfileV2 profile) async {
    // 清除当前状态并重新生成
    state = state.copyWith(
      recommendation: null,
      userAdjustments: {},
      hasError: false,
      errorMessage: null,
    );

    await generateRecommendation(profile);
  }

  /// 清除当前推荐
  void clearRecommendation() {
    state = state.copyWith(
      recommendation: null,
      userAdjustments: {},
      hasError: false,
      errorMessage: null,
    );
  }

  /// 实时更新推荐显示值
  void _updateRecommendationDisplay(String field, dynamic value) {
    final currentRec = state.recommendation;
    if (currentRec == null) return;

    // 根据字段更新对应的营养目标
    final updatedTargets = currentRec.nutritionTargets.copyWith();
    NutritionTargets newTargets;

    switch (field) {
      case 'dailyCalories':
        newTargets = updatedTargets.copyWith(dailyCalories: value.toDouble());
        break;
      case 'hydrationGoal':
        newTargets = updatedTargets.copyWith(hydrationGoal: value.toDouble());
        break;
      case 'mealFrequency':
        newTargets = updatedTargets.copyWith(mealFrequency: value.toInt());
        break;
      case 'protein':
        final newRatio = updatedTargets.macroRatio.copyWith(protein: value.toDouble());
        newTargets = updatedTargets.copyWith(macroRatio: newRatio);
        break;
      case 'fat':
        final newRatio = updatedTargets.macroRatio.copyWith(fat: value.toDouble());
        newTargets = updatedTargets.copyWith(macroRatio: newRatio);
        break;
      case 'carbs':
        final newRatio = updatedTargets.macroRatio.copyWith(carbs: value.toDouble());
        newTargets = updatedTargets.copyWith(macroRatio: newRatio);
        break;
      default:
        // 处理维生素/矿物质调整
        if (updatedTargets.vitaminTargets.containsKey(field)) {
          final newVitamins = Map<String, double>.from(updatedTargets.vitaminTargets);
          newVitamins[field] = value.toDouble();
          newTargets = updatedTargets.copyWith(vitaminTargets: newVitamins);
        } else if (updatedTargets.mineralTargets.containsKey(field)) {
          final newMinerals = Map<String, double>.from(updatedTargets.mineralTargets);
          newMinerals[field] = value.toDouble();
          newTargets = updatedTargets.copyWith(mineralTargets: newMinerals);
        } else {
          return; // 未知字段，不处理
        }
    }

    final updatedRecommendation = currentRec.copyWith(nutritionTargets: newTargets);
    state = state.copyWith(recommendation: updatedRecommendation);
  }

  /// 生成请求ID
  String _generateRequestId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ai_req_${_profileId}_$timestamp';
  }

  /// 格式化错误消息
  String _formatErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    }
    return error.toString();
  }

  /// 记录推荐生成成功
  void _logRecommendationGenerated(AIRecommendation recommendation) {
    print('AI推荐生成成功: ${recommendation.id}, 置信度: ${recommendation.confidence}');
  }

  /// 记录反馈提交
  void _logFeedbackSubmitted(int rating, bool isAccepted) {
    print('用户反馈已提交: 评分=$rating, 接受=$isAccepted');
  }

  /// 记录错误
  void _logError(String message, dynamic error, StackTrace? stackTrace) {
    print('$message: $error');
    if (stackTrace != null) {
      print('Stack trace: $stackTrace');
    }
  }
}

/// 获取特定推荐的Provider（便于UI使用）
final specificRecommendationProvider = Provider.family<AIRecommendation?, String>(
  (ref, profileId) {
    return ref.watch(aiRecommendationProvider(profileId)).recommendation;
  },
);

/// 检查是否正在加载推荐
final isGeneratingRecommendationProvider = Provider.family<bool, String>(
  (ref, profileId) {
    return ref.watch(aiRecommendationProvider(profileId)).isLoading;
  },
);

/// 获取推荐错误状态
final recommendationErrorProvider = Provider.family<String?, String>(
  (ref, profileId) {
    final state = ref.watch(aiRecommendationProvider(profileId));
    return state.hasError ? state.errorMessage : null;
  },
);