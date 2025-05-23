import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/common/failures/failure.dart';
import '../../domain/user/entities/user.dart';
import '../../domain/abstractions/repositories/i_auth_repository.dart';
import '../core/use_case.dart';

/// 登录参数
class SignInParams extends Equatable {
  final String? email;
  final String? phone;
  final String password;
  
  const SignInParams({
    this.email,
    this.phone,
    required this.password,
  }) : assert(email != null || phone != null, '邮箱或手机号至少提供一个');
  
  @override
  List<Object?> get props => [email, phone, password];
}

/// 用户登录用例
@injectable
class SignInUseCase extends UseCase<User, SignInParams> {
  final IAuthRepository _authRepository;
  
  SignInUseCase(this._authRepository);
  
  @override
  Future<Either<Failure, User>> call(SignInParams params) async {
    if (params.email != null) {
      return await _authRepository.signInWithEmailAndPassword(
        email: params.email!,
        password: params.password,
      );
    } else {
      return await _authRepository.signInWithPhoneAndPassword(
        phone: params.phone!,
        password: params.password,
      );
    }
  }
}