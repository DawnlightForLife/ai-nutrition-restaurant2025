import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/abstractions/repositories/i_user_repository.dart';
import '../../../domain/common/failures/failure.dart';
import '../../../domain/user/entities/user.dart';
import '../../../domain/user/value_objects/user_value_objects.dart';
import '../../core/use_case.dart';

/// 获取用户资料参数
class GetUserProfileParams extends Equatable {
  final UserId userId;

  const GetUserProfileParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// 获取用户资料用例
@injectable
class GetUserProfileUseCase extends UseCase<User, GetUserProfileParams> {
  final IUserRepository _repository;

  GetUserProfileUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(GetUserProfileParams params) async {
    return _repository.getUserById(params.userId.getOrCrash());
  }
}