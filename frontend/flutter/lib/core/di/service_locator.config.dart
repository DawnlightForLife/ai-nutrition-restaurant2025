// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../application/auth/sign_in_use_case.dart' as _i20;
import '../../application/auth/use_cases/login_use_case.dart' as _i16;
import '../../application/auth/use_cases/logout_use_case.dart' as _i17;
import '../../application/nutrition/use_cases/create_nutrition_profile_use_case.dart'
    as _i23;
import '../../application/nutrition/use_cases/delete_nutrition_profile_use_case.dart'
    as _i24;
import '../../application/nutrition/use_cases/get_ai_recommendations_use_case.dart'
    as _i25;
import '../../application/nutrition/use_cases/get_nutrition_profile_use_case.dart'
    as _i27;
import '../../application/nutrition/use_cases/update_nutrition_profile_use_case.dart'
    as _i21;
import '../../application/user/get_current_user_use_case.dart' as _i26;
import '../../application/user/use_cases/get_user_profile_use_case.dart'
    as _i28;
import '../../application/user/use_cases/update_user_profile_use_case.dart'
    as _i22;
import '../../domain/abstractions/repositories/i_auth_repository.dart' as _i6;
import '../../domain/abstractions/repositories/i_nutrition_repository.dart'
    as _i9;
import '../../domain/abstractions/repositories/i_user_repository.dart' as _i14;
import '../../domain/abstractions/services/i_storage_service.dart' as _i11;
import '../../infrastructure/api/api_client.dart' as _i3;
import '../../infrastructure/datasources/auth_datasource.dart' as _i4;
import '../../infrastructure/repositories/auth_repository.dart' as _i7;
import '../../infrastructure/repositories/nutrition_repository.dart' as _i10;
import '../../infrastructure/repositories/user_repository.dart' as _i15;
import '../../infrastructure/services/auth_service.dart' as _i8;
import '../../infrastructure/services/storage/hive_storage_service.dart'
    as _i12;
import '../../infrastructure/services/user_preferences_service.dart' as _i13;
import '../error/error_handler.dart' as _i5;
import '../network/network_monitor.dart' as _i18;
import '../network/offline_manager.dart' as _i19;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.ApiClient>(() => _i3.ApiClient());
    gh.factory<_i4.AuthDatasource>(
        () => _i4.AuthDatasource(gh<_i3.ApiClient>()));
    gh.singleton<_i5.GlobalErrorHandler>(() => _i5.GlobalErrorHandler());
    gh.factory<_i6.IAuthRepository>(() => _i7.AuthRepository(
          gh<_i4.AuthDatasource>(),
          gh<_i3.ApiClient>(),
        ));
    gh.factory<_i8.IAuthService>(() => _i8.AuthService());
    gh.lazySingleton<_i9.INutritionRepository>(
        () => _i10.NutritionRepository());
    gh.lazySingleton<_i11.IStorageService>(() => _i12.HiveStorageService());
    gh.factory<_i13.IUserPreferencesService>(
        () => _i13.UserPreferencesService());
    gh.factory<_i14.IUserRepository>(() => _i15.UserRepository());
    gh.factory<_i16.LoginUseCase>(
        () => _i16.LoginUseCase(gh<_i6.IAuthRepository>()));
    gh.factory<_i17.LogoutUseCase>(
        () => _i17.LogoutUseCase(gh<_i6.IAuthRepository>()));
    gh.factory<_i18.NetworkMonitor>(() => _i18.NetworkMonitor());
    gh.factory<_i19.OfflineManager>(
        () => _i19.OfflineManager(gh<_i18.NetworkMonitor>()));
    gh.factory<_i20.SignInUseCase>(
        () => _i20.SignInUseCase(gh<_i6.IAuthRepository>()));
    gh.factory<_i21.UpdateNutritionProfileUseCase>(() =>
        _i21.UpdateNutritionProfileUseCase(gh<_i9.INutritionRepository>()));
    gh.factory<_i22.UpdateUserProfileUseCase>(
        () => _i22.UpdateUserProfileUseCase(gh<_i14.IUserRepository>()));
    gh.factory<_i23.CreateNutritionProfileUseCase>(() =>
        _i23.CreateNutritionProfileUseCase(gh<_i9.INutritionRepository>()));
    gh.factory<_i24.DeleteNutritionProfileUseCase>(() =>
        _i24.DeleteNutritionProfileUseCase(gh<_i9.INutritionRepository>()));
    gh.factory<_i25.GetAiRecommendationsUseCase>(
        () => _i25.GetAiRecommendationsUseCase(gh<_i9.INutritionRepository>()));
    gh.factory<_i26.GetCurrentUserUseCase>(
        () => _i26.GetCurrentUserUseCase(gh<_i14.IUserRepository>()));
    gh.factory<_i27.GetNutritionProfileUseCase>(
        () => _i27.GetNutritionProfileUseCase(gh<_i9.INutritionRepository>()));
    gh.factory<_i28.GetUserProfileUseCase>(
        () => _i28.GetUserProfileUseCase(gh<_i14.IUserRepository>()));
    return this;
  }
}
