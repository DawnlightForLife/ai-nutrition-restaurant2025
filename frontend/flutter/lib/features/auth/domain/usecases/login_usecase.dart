import 'package:dartz/dartz.dart';
import '../failures/auth_failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<AuthFailure, AuthUser>> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}