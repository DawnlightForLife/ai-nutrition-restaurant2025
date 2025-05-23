import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/common/failures/failure.dart';
import '../../domain/user/entities/user.dart';
import '../../domain/abstractions/repositories/i_user_repository.dart';
import '../core/use_case.dart';

/// 获取当前用户信息用例
@injectable
class GetCurrentUserUseCase extends NoParamsUseCase<User> {
  final IUserRepository _userRepository;
  
  GetCurrentUserUseCase(this._userRepository);
  
  @override
  Future<Either<Failure, User>> call() async {
    return await _userRepository.getCurrentUser();
  }
}