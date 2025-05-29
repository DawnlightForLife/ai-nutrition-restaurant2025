import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'recommendation_controller.freezed.dart';
part 'recommendation_controller.g.dart';

/// 推荐状态
@freezed
class RecommendationState with _$RecommendationState {
  const factory RecommendationState({
    @Default([]) List<Urecommendation> recommendations,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _RecommendationState;
}

/// 推荐控制器 - 使用新的 AsyncNotifier 模式
@riverpod
class RecommendationController extends _$RecommendationController {
  @override
  Future<List<Urecommendation>> build() async {
    final useCase = ref.read(getRecommendationsUseCaseProvider);
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (recommendations) => recommendations,
    );
  }

  /// 刷新推荐列表
  Future<void> refreshRecommendations() async {
    ref.invalidateSelf();
    await future;
  }

  /// 加载推荐（兼容旧接口）
  Future<void> loadRecommendations() async {
    return refreshRecommendations();
  }

  /// 添加新推荐到列表
  void addRecommendation(Urecommendation recommendation) {
    final currentRecommendations = state.valueOrNull ?? [];
    state = AsyncValue.data([recommendation, ...currentRecommendations]);
  }

  /// 更新推荐
  void updateRecommendation(Urecommendation updatedRecommendation) {
    final currentRecommendations = state.valueOrNull ?? [];
    final updatedRecommendations = currentRecommendations.map((recommendation) {
      return recommendation.id == updatedRecommendation.id ? updatedRecommendation : recommendation;
    }).toList();
    
    state = AsyncValue.data(updatedRecommendations);
  }

  /// 删除推荐
  void removeRecommendation(String recommendationId) {
    final currentRecommendations = state.valueOrNull ?? [];
    final filteredRecommendations = currentRecommendations
        .where((recommendation) => recommendation.id != recommendationId)
        .toList();
    state = AsyncValue.data(filteredRecommendations);
  }
}

/// 单个推荐控制器
@riverpod
class SingleRecommendationController extends _$SingleRecommendationController {
  @override
  Future<Urecommendation?> build(String recommendationId) async {
    final recommendations = await ref.watch(recommendationControllerProvider.future);
    return recommendations.firstWhere(
      (recommendation) => recommendation.id == recommendationId,
      orElse: () => throw Exception('推荐不存在'),
    );
  }

  /// 刷新单个推荐
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// 推荐类型过滤器
@riverpod
List<Urecommendation> filteredRecommendations(
  FilteredRecommendationsRef ref,
  String? type,
) {
  final recommendations = ref.watch(recommendationControllerProvider).valueOrNull ?? [];
  
  if (type == null || type.isEmpty) {
    return recommendations;
  }
  
  return recommendations.where((recommendation) => recommendation.type == type).toList();
}

/// 个性化推荐控制器
@riverpod
class PersonalizedRecommendationController extends _$PersonalizedRecommendationController {
  @override
  Future<List<Urecommendation>> build(String userId) async {
    final useCase = ref.read(getRecommendationsUseCaseProvider);
    // 假设有个性化推荐的用例，这里使用通用的
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (recommendations) => recommendations
          .where((rec) => rec.userId == userId)
          .toList(),
    );
  }

  /// 刷新个性化推荐
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// 推荐统计
@riverpod
Map<String, int> recommendationStats(RecommendationStatsRef ref) {
  final recommendations = ref.watch(recommendationControllerProvider).valueOrNull ?? [];
  
  final stats = <String, int>{};
  for (final recommendation in recommendations) {
    stats[recommendation.type] = (stats[recommendation.type] ?? 0) + 1;
  }
  
  return stats;
}

/// UseCase Provider
@riverpod
GetUrecommendationsUseCase getRecommendationsUseCase(GetRecommendationsUseCaseRef ref) {
  final repository = ref.read(recommendationRepositoryProvider);
  return GetUrecommendationsUseCase(repository);
}

/// Repository Provider
@riverpod
UrecommendationRepository recommendationRepository(RecommendationRepositoryRef ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
}

/// 便捷访问器
@riverpod
List<Urecommendation> currentRecommendations(CurrentRecommendationsRef ref) {
  return ref.watch(recommendationControllerProvider).valueOrNull ?? [];
}

@riverpod
bool hasRecommendations(HasRecommendationsRef ref) {
  final recommendations = ref.watch(currentRecommendationsProvider);
  return recommendations.isNotEmpty;
}

@riverpod
int recommendationCount(RecommendationCountRef ref) {
  final recommendations = ref.watch(currentRecommendationsProvider);
  return recommendations.length;
}

/// 热门推荐
@riverpod
List<Urecommendation> popularRecommendations(PopularRecommendationsRef ref) {
  final recommendations = ref.watch(currentRecommendationsProvider);
  // 假设有热度字段，这里简单返回前5个
  return recommendations.take(5).toList();
}