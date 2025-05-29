import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

/// 用户档案仓储接口
abstract class UserRepository {
  Future<Either<Failure, UserProfile>> getUserProfile(String userId);
  Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile profile);
  Future<Either<Failure, Unit>> uploadAvatar(String userId, String filePath);
  Future<Either<Failure, List<UserProfile>>> searchUsers(String query);
  Future<Either<Failure, Unit>> deleteAccount(String userId);
}
