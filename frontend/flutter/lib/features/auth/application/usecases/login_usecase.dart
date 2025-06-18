import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthUser> execute({
    required String email,
    required String password,
  }) async {
    return await repository.login(email: email, password: password);
  }
}