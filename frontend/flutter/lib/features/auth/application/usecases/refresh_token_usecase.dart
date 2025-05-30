import 'package:dartz/dartz.dart';
import '../../domain/failures/auth_failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<AuthFailure, AuthUser>> execute() async {
    return await repository.refreshToken();
  }
}