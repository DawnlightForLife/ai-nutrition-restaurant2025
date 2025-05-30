import 'package:dartz/dartz.dart';
import '../../domain/failures/auth_failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<AuthFailure, AuthUser>> execute({
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