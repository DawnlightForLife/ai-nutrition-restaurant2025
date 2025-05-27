import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/abstractions/repositories/i_auth_repository.dart';
import '../../../domain/common/failures/failure.dart';
import '../../../domain/user/entities/user.dart';
import '../../core/use_case.dart';

/// 登录用例参数
class LoginParams extends Equatable {
  final String phone;
  final String verificationCode;

  const LoginParams({
    required this.phone,
    required this.verificationCode,
  });

  @override
  List<Object?> get props => [phone, verificationCode];
}

/// 登录用例
@injectable
class LoginUseCase extends UseCase<User, LoginParams> {
  final IAuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return _repository.signInWithPhoneAndCode(
      phone: params.phone,
      code: params.verificationCode,
    );
  }
}