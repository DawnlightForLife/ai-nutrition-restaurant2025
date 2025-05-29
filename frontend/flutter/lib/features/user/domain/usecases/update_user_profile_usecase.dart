import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

/// 更新用户档案用例
class UpdateUserProfileUseCase implements UseCase<UserProfile, UpdateUserProfileParams> {
  final UserRepository repository;

  UpdateUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UpdateUserProfileParams params) {
    return repository.updateUserProfile(params.profile);
  }
}

/// 更新用户档案参数
class UpdateUserProfileParams {
  final UserProfile profile;

  UpdateUserProfileParams({required this.profile});
}