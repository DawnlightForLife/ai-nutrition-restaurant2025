import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/abstractions/repositories/i_user_repository.dart';
import '../../../domain/common/failures/failure.dart';
import '../../../domain/user/entities/user.dart';
import '../../core/use_case.dart';

/// 更新用户资料参数
class UpdateUserProfileParams extends Equatable {
  final User user;

  const UpdateUserProfileParams({required this.user});

  @override
  List<Object?> get props => [user];
}

/// 更新用户资料用例
@injectable
class UpdateUserProfileUseCase extends UseCase<User, UpdateUserProfileParams> {
  final IUserRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserProfileParams params) async {
    return _repository.updateUserProfile(params.user);
  }
}