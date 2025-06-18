import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<AuthUser> call() async {
    return await repository.refreshToken();
  }
}