import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/usecases/get_merchants_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'merchant_provider.freezed.dart';

/// Umerchant状态
@freezed
class UmerchantState with _$UmerchantState {
  const factory UmerchantState.initial() = _Initial;
  const factory UmerchantState.loading() = _Loading;
  const factory UmerchantState.loaded(List<Umerchant> merchants) = _Loaded;
  const factory UmerchantState.error(String message) = _Error;
}

/// UmerchantProvider
final merchantProvider = StateNotifierProvider<UmerchantNotifier, UmerchantState>((ref) {
  final useCase = ref.watch(getUmerchantsUseCaseProvider);
  return UmerchantNotifier(useCase);
});

/// UmerchantNotifier
class UmerchantNotifier extends StateNotifier<UmerchantState> {
  final GetUmerchantsUseCase _getUmerchantsUseCase;

  UmerchantNotifier(this._getUmerchantsUseCase) : super(const UmerchantState.initial());

  Future<void> loadUmerchants() async {
    state = const UmerchantState.loading();
    
    final result = await _getUmerchantsUseCase(NoParams());
    
    state = result.fold(
      (failure) => UmerchantState.error(failure.message),
      (merchants) => UmerchantState.loaded(merchants),
    );
  }
}

/// UseCase Provider
final getUmerchantsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(merchantRepositoryProvider);
  return GetUmerchantsUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final merchantRepositoryProvider = Provider<UmerchantRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
