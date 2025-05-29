import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';

/// 获取用户档案用例
class GetUserProfileUseCase implements UseCase<UserProfile, GetUserProfileParams> {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(GetUserProfileParams params) {
    return repository.getUserProfile(params.userId);
  }
}

/// 获取用户档案参数
class GetUserProfileParams {
  final String userId;

  GetUserProfileParams({required this.userId});
}