import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/forum.dart';
import '../../domain/usecases/get_forums_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'forum_provider.freezed.dart';

/// Uforum状态
@freezed
class UforumState with _$UforumState {
  const factory UforumState.initial() = _Initial;
  const factory UforumState.loading() = _Loading;
  const factory UforumState.loaded(List<Uforum> forums) = _Loaded;
  const factory UforumState.error(String message) = _Error;
}

/// UforumProvider
final forumProvider = StateNotifierProvider<UforumNotifier, UforumState>((ref) {
  final useCase = ref.watch(getUforumsUseCaseProvider);
  return UforumNotifier(useCase);
});

/// UforumNotifier
class UforumNotifier extends StateNotifier<UforumState> {
  final GetUforumsUseCase _getUforumsUseCase;

  UforumNotifier(this._getUforumsUseCase) : super(const UforumState.initial());

  Future<void> loadUforums() async {
    state = const UforumState.loading();
    
    final result = await _getUforumsUseCase(NoParams());
    
    state = result.fold(
      (failure) => UforumState.error(failure.message),
      (forums) => UforumState.loaded(forums),
    );
  }
}

/// UseCase Provider
final getUforumsUseCaseProvider = Provider((ref) {
  final repository = ref.watch(forumRepositoryProvider);
  return GetUforumsUseCase(repository);
});

/// Repository Provider (需要在DI中配置)
final forumRepositoryProvider = Provider<UforumRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});
