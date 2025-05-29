import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation.dart';
import '../../domain/usecases/get_recommendations_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'recommendation_provider.freezed.dart';

/// Urecommendation状态
@freezed
class UrecommendationState with _$UrecommendationState {
  const factory UrecommendationState.initial() = _Initial;
  const factory UrecommendationState.loading() = _Loading;
  const factory UrecommendationState.loaded(List<Urecommendation> recommendations) = _Loaded;
  const factory UrecommendationState.error(String message) = _Error;
}

/// UrecommendationProvider
final recommendationProvider = StateNotifierProvider<UrecommendationNotifier, UrecommendationState>((ref) {
  final useCase = ref.watch(getUrecommendationsUseCaseProvider);
  return UrecommendationNotifier(useCase);
});

/// UrecommendationNotifier
class UrecommendationNotifier extends StateNotifier<UrecommendationState> {
  final GetUrecommendationsUseCase _getUrecommendationsUseCase;

  UrecommendationNotifier(this._getUrecommendationsUseCase) : super(const UrecommendationState.initial());

  Future<void> loadUrecommendations() async {
    state = const UrecommendationState.loading();
    
    final result = await _getUrecommendationsUseCase(NoParams());
    
    state = result.fold(
      (failure) => UrecommendationState.error(failure.message),
      (recommendations) => UrecommendationState.loaded(recommendations),
    );
  }
}

/// UseCase Provider
final getUrecommendationsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(recommendationRepositoryProvider);
  return GetUrecommendationsUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final recommendationRepositoryProvider = Provider<UrecommendationRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
