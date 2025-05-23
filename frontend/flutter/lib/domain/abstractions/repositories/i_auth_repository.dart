import 'package:dartz/dartz.dart';
import '../../common/failures/failure.dart';
import '../../user/entities/user.dart';

/// 认证仓储接口
/// 
/// 处理用户认证相关的数据操作
abstract class IAuthRepository {
  /// 使用邮箱密码登录
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  /// 使用手机号密码登录
  Future<Either<Failure, User>> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  });
  
  /// 使用手机号验证码登录
  Future<Either<Failure, User>> signInWithPhoneAndCode({
    required String phone,
    required String code,
  });
  
  /// 注册新用户
  Future<Either<Failure, User>> signUp({
    required String email,
    required String phone,
    required String password,
    required String nickname,
  });
  
  /// 发送验证码
  Future<Either<Failure, Unit>> sendVerificationCode(String phone);
  
  /// 重置密码
  Future<Either<Failure, Unit>> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  });
  
  /// 修改密码
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  
  /// 登出
  Future<Either<Failure, Unit>> signOut();
  
  /// 获取当前认证用户
  Future<Either<Failure, User?>> getSignedInUser();
  
  /// 刷新认证令牌
  Future<Either<Failure, Unit>> refreshToken();
  
  /// 检查是否已登录
  Future<bool> isSignedIn();
}