import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/usecases/get_nutritionists_usecase.dart';
import '../../domain/repositories/nutritionist_repository.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/failures/failures.dart';

// 导出新的营养师列表provider
export 'nutritionist_list_provider.dart';
export 'nutritionist_detail_provider.dart';

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

/// Repository Provider
final nutritionistRepositoryProvider = Provider<UnutritionistRepository>((ref) {
  // 这里暂时返回一个模拟实现，实际应该注入真实的实现
  // TODO: 注入真实的 UnutritionistRepositoryImpl
  return _MockUnutritionistRepository();
});

/// 模拟仓储实现（临时使用）
class _MockUnutritionistRepository implements UnutritionistRepository {
  @override
  Future<Either<Failure, List<Unutritionist>>> getUnutritionists() async {
    // 返回空列表，避免错误
    return Right([]);
  }

  @override
  Future<Either<Failure, Unutritionist>> getUnutritionist(String id) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, Unutritionist>> createUnutritionist(Unutritionist nutritionist) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, Unutritionist>> updateUnutritionist(Unutritionist nutritionist) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }

  @override
  Future<Either<Failure, Unit>> deleteUnutritionist(String id) async {
    return Left(ServerFailure(message: 'Not implemented'));
  }
}
