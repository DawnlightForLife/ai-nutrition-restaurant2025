import 'package:dartz/dartz.dart';
import '../failures/auth_failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, AuthUser>> login({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, AuthUser>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<AuthFailure, void>> logout();

  Future<Either<AuthFailure, AuthUser>> refreshToken();

  Future<Either<AuthFailure, AuthUser?>> getCurrentUser();
}