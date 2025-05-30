import 'package:dartz/dartz.dart';
import '../failures/auth_failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<AuthFailure, AuthUser>> call() async {
    return await repository.refreshToken();
  }
}