import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/consultation.dart';
import '../../domain/usecases/get_consultations_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'consultation_provider.freezed.dart';

/// Uconsultation状态
@freezed
class UconsultationState with _$UconsultationState {
  const factory UconsultationState.initial() = _Initial;
  const factory UconsultationState.loading() = _Loading;
  const factory UconsultationState.loaded(List<Uconsultation> consultations) = _Loaded;
  const factory UconsultationState.error(String message) = _Error;
}

/// UconsultationProvider
final consultationProvider = StateNotifierProvider<UconsultationNotifier, UconsultationState>((ref) {
  final useCase = ref.watch(getUconsultationsUseCaseProvider);
  return UconsultationNotifier(useCase);
});

/// UconsultationNotifier
class UconsultationNotifier extends StateNotifier<UconsultationState> {
  final GetUconsultationsUseCase _getUconsultationsUseCase;

  UconsultationNotifier(this._getUconsultationsUseCase) : super(const UconsultationState.initial());

  Future<void> loadUconsultations() async {
    state = const UconsultationState.loading();
    
    final result = await _getUconsultationsUseCase(NoParams());
    
    state = result.fold(
      (failure) => UconsultationState.error(failure.message),
      (consultations) => UconsultationState.loaded(consultations),
    );
  }
}

/// UseCase Provider
final getUconsultationsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(consultationRepositoryProvider);
  return GetUconsultationsUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final consultationRepositoryProvider = Provider<UconsultationRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
