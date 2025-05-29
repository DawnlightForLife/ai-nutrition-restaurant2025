import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/usecases/get_nutritionists_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'nutritionist_provider.freezed.dart';

/// Unutritionist状态
@freezed
class UnutritionistState with _$UnutritionistState {
  const factory UnutritionistState.initial() = _Initial;
  const factory UnutritionistState.loading() = _Loading;
  const factory UnutritionistState.loaded(List<Unutritionist> nutritionists) = _Loaded;
  const factory UnutritionistState.error(String message) = _Error;
}

/// UnutritionistProvider
final nutritionistProvider = StateNotifierProvider<UnutritionistNotifier, UnutritionistState>((ref) {
  final useCase = ref.watch(getUnutritionistsUseCaseProvider);
  return UnutritionistNotifier(useCase);
});

/// UnutritionistNotifier
class UnutritionistNotifier extends StateNotifier<UnutritionistState> {
  final GetUnutritionistsUseCase _getUnutritionistsUseCase;

  UnutritionistNotifier(this._getUnutritionistsUseCase) : super(const UnutritionistState.initial());

  Future<void> loadUnutritionists() async {
    state = const UnutritionistState.loading();
    
    final result = await _getUnutritionistsUseCase(NoParams());
    
    state = result.fold(
      (failure) => UnutritionistState.error(failure.message),
      (nutritionists) => UnutritionistState.loaded(nutritionists),
    );
  }
}

/// UseCase Provider
final getUnutritionistsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(nutritionistRepositoryProvider);
  return GetUnutritionistsUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final nutritionistRepositoryProvider = Provider<UnutritionistRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
