import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'order_provider.freezed.dart';

/// Uorder状态
@freezed
class UorderState with _$UorderState {
  const factory UorderState.initial() = _Initial;
  const factory UorderState.loading() = _Loading;
  const factory UorderState.loaded(List<Uorder> orders) = _Loaded;
  const factory UorderState.error(String message) = _Error;
}

/// UorderProvider
final orderProvider = StateNotifierProvider<UorderNotifier, UorderState>((ref) {
  final useCase = ref.watch(getUordersUseCaseProvider);
  return UorderNotifier(useCase);
});

/// UorderNotifier
class UorderNotifier extends StateNotifier<UorderState> {
  final GetUordersUseCase _getUordersUseCase;

  UorderNotifier(this._getUordersUseCase) : super(const UorderState.initial());

  Future<void> loadUorders() async {
    state = const UorderState.loading();
    
    final result = await _getUordersUseCase(NoParams());
    
    state = result.fold(
      (failure) => UorderState.error(failure.message),
      (orders) => UorderState.loaded(orders),
    );
  }
}

/// UseCase Provider
final getUordersUseCaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetUordersUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final orderRepositoryProvider = Provider<UorderRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
