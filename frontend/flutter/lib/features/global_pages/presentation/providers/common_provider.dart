import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/common.dart';
import '../../domain/usecases/get_commons_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'common_provider.freezed.dart';

/// Ucommon状态
@freezed
class UcommonState with _$UcommonState {
  const factory UcommonState.initial() = _Initial;
  const factory UcommonState.loading() = _Loading;
  const factory UcommonState.loaded(List<Ucommon> commons) = _Loaded;
  const factory UcommonState.error(String message) = _Error;
}

/// UcommonProvider
final commonProvider = StateNotifierProvider<UcommonNotifier, UcommonState>((ref) {
  final useCase = ref.watch(getUcommonsUseCaseProvider);
  return UcommonNotifier(useCase);
});

/// UcommonNotifier
class UcommonNotifier extends StateNotifier<UcommonState> {
  final GetUcommonsUseCase _getUcommonsUseCase;

  UcommonNotifier(this._getUcommonsUseCase) : super(const UcommonState.initial());

  Future<void> loadUcommons() async {
    state = const UcommonState.loading();
    
    final result = await _getUcommonsUseCase(NoParams());
    
    state = result.fold(
      (failure) => UcommonState.error(failure.message),
      (commons) => UcommonState.loaded(commons),
    );
  }
}

/// UseCase Provider
final getUcommonsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(commonRepositoryProvider);
  return GetUcommonsUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final commonRepositoryProvider = Provider<UcommonRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
