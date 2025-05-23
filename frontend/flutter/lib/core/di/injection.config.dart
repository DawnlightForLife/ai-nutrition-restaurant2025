// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../application/auth/sign_in_use_case.dart' as _i433;
import '../../application/user/get_current_user_use_case.dart' as _i731;
import '../../domain/abstractions/repositories/i_auth_repository.dart' as _i756;
import '../../domain/abstractions/repositories/i_user_repository.dart' as _i295;
import '../../infrastructure/repositories/auth_repository.dart' as _i437;
import '../../infrastructure/repositories/user_repository.dart' as _i919;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i295.IUserRepository>(() => _i919.UserRepository());
    gh.factory<_i756.IAuthRepository>(() => _i437.AuthRepository());
    gh.factory<_i731.GetCurrentUserUseCase>(
        () => _i731.GetCurrentUserUseCase(gh<_i295.IUserRepository>()));
    gh.factory<_i433.SignInUseCase>(
        () => _i433.SignInUseCase(gh<_i756.IAuthRepository>()));
    return this;
  }
}
