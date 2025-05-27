import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/abstractions/repositories/i_auth_repository.dart';
import '../../domain/common/failures/failure.dart';
import '../../domain/user/entities/user.dart';
import '../datasources/auth_datasource.dart';
import '../api/api_client.dart';

/// AuthRepository实现
@Injectable(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final AuthDatasource _authDatasource;
  final ApiClient _apiClient;
  
  AuthRepository(this._authDatasource, this._apiClient);
  
  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // TODO(dev): 实现邮箱密码登录
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, User>> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  }) async {
    // TODO(dev): 实现手机号密码登录
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, User>> signInWithPhoneAndCode({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await _authDatasource.signInWithPhoneAndCode(
        phone: phone,
        code: code,
      );
      // TODO(dev): 保存token并转换用户数据
      return Left(Failure.unexpected('Not fully implemented'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String phone,
    required String password,
    required String nickname,
  }) async {
    // TODO(dev): 实现用户注册
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Unit>> sendVerificationCode(String phone) async {
    // TODO(dev): 实现发送验证码
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String phone,
    required String code,
    required String newPassword,
  }) async {
    // TODO(dev): 实现重置密码
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Unit>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    // TODO(dev): 实现修改密码
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Unit>> signOut() async {
    // TODO(dev): 实现登出
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, User?>> getSignedInUser() async {
    // TODO(dev): 实现获取当前用户
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Unit>> refreshToken() async {
    // TODO(dev): 实现刷新令牌
    throw UnimplementedError();
  }
  
  @override
  Future<bool> isSignedIn() async {
    // TODO(dev): 实现检查是否已登录
    throw UnimplementedError();
  }
} 