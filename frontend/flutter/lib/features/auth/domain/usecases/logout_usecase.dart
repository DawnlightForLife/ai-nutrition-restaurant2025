import 'package:dartz/dartz.dart';
import '../failures/auth_failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<AuthFailure, void>> call() async {
    return await repository.logout();
  }
}