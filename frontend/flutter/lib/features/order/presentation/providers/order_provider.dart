import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/repositories/order_repository.dart';
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
    
    try {
      final orders = await _getUordersUseCase(NoParams());
      state = UorderState.loaded(orders);
    } catch (e) {
      state = UorderState.error(e.toString());
    }
  }
}

/// UseCase Provider
final getUordersUseCaseProvider = Provider((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetUordersUseCase(repository);
});

/// Repository Provider
final orderRepositoryProvider = Provider<UorderRepository>((ref) {
  // TODO: 实现真实的Repository
  return MockUorderRepository();
});

/// 临时的Mock Repository实现
class MockUorderRepository implements UorderRepository {
  @override
  Future<List<Uorder>> getUorders() async {
    // 返回空列表，避免错误
    return [];
  }

  @override
  Future<Uorder?> getUorder(String id) async {
    return null;
  }

  @override
  Future<Uorder> createUorder(Uorder order) async {
    return order;
  }

  @override
  Future<Uorder> updateUorder(Uorder order) async {
    return order;
  }

  @override
  Future<void> deleteUorder(String id) async {
    // 空实现
  }
}
