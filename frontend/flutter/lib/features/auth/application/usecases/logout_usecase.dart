import 'package:dartz/dartz.dart';
import '../../domain/failures/auth_failures.dart';
import '../../domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<AuthFailure, void>> execute() async {
    return await repository.logout();
  }
}