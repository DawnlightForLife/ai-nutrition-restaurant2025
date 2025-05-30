import 'package:dartz/dartz.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/failures/auth_failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi authApi;

  AuthRepositoryImpl({required this.authApi});

  @override
  Future<Either<AuthFailure, AuthUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      // TODO: 实现登录逻辑
      throw UnimplementedError('login待实现');
    } catch (e) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, AuthUser>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // TODO: 实现注册逻辑
      throw UnimplementedError('register待实现');
    } catch (e) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      // TODO: 实现登出逻辑
      throw UnimplementedError('logout待实现');
    } catch (e) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, AuthUser>> refreshToken() async {
    try {
      // TODO: 实现刷新令牌逻辑
      throw UnimplementedError('refreshToken待实现');
    } catch (e) {
      return left(const AuthFailure.serverError());
    }
  }

  @override
  Future<Either<AuthFailure, AuthUser?>> getCurrentUser() async {
    try {
      // TODO: 实现获取当前用户逻辑
      throw UnimplementedError('getCurrentUser待实现');
    } catch (e) {
      return left(const AuthFailure.serverError());
    }
  }
}