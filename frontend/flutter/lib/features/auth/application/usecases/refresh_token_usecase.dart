import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<AuthUser> execute() async {
    return await repository.refreshToken();
  }
}