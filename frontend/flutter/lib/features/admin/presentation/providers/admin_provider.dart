import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin.dart';
import '../../domain/usecases/get_admins_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'admin_provider.freezed.dart';

/// Uadmin状态
@freezed
class UadminState with _$UadminState {
  const factory UadminState.initial() = _Initial;
  const factory UadminState.loading() = _Loading;
  const factory UadminState.loaded(List<Uadmin> admins) = _Loaded;
  const factory UadminState.error(String message) = _Error;
}

/// UadminProvider
final adminProvider = StateNotifierProvider<UadminNotifier, UadminState>((ref) {
  final useCase = ref.watch(getUadminsUseCaseProvider);
  return UadminNotifier(useCase);
});

/// UadminNotifier
class UadminNotifier extends StateNotifier<UadminState> {
  final GetUadminsUseCase _getUadminsUseCase;

  UadminNotifier(this._getUadminsUseCase) : super(const UadminState.initial());

  Future<void> loadUadmins() async {
    state = const UadminState.loading();
    
    final result = await _getUadminsUseCase(NoParams());
    
    state = result.fold(
      (failure) => UadminState.error(failure.message),
      (admins) => UadminState.loaded(admins),
    );
  }
}

/// UseCase Provider
final getUadminsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return GetUadminsUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final adminRepositoryProvider = Provider<UadminRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
