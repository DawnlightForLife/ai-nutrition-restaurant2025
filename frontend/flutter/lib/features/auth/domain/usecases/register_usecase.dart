import 'package:dartz/dartz.dart';
import '../failures/auth_failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<AuthFailure, AuthUser>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      name: name,
    );
  }
}