import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/abstractions/repositories/i_auth_repository.dart';
import '../../../domain/common/failures/failure.dart';
import '../../core/use_case.dart';

/// 登出用例
@injectable
class LogoutUseCase extends UseCase<void, NoParams> {
  final IAuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final result = await _repository.signOut();
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }
}