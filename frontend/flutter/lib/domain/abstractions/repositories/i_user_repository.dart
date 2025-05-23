import 'package:dartz/dartz.dart';
import '../../common/failures/failure.dart';
import '../../user/entities/user.dart';

/// 用户仓储接口
/// 
/// 定义用户相关的数据操作
abstract class IUserRepository {
  /// 获取当前用户信息
  Future<Either<Failure, User>> getCurrentUser();
  
  /// 根据ID获取用户信息
  Future<Either<Failure, User>> getUserById(String userId);
  
  /// 更新用户信息
  Future<Either<Failure, User>> updateUser(User user);
  
  /// 更新用户头像
  Future<Either<Failure, String>> updateAvatar(String imagePath);
  
  /// 注销账号
  Future<Either<Failure, Unit>> deleteAccount();
  
  /// 检查邮箱是否已存在
  Future<Either<Failure, bool>> checkEmailExists(String email);
  
  /// 检查手机号是否已存在
  Future<Either<Failure, bool>> checkPhoneExists(String phone);
}