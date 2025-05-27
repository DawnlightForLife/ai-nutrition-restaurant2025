import 'package:dartz/dartz.dart';

import '../../domain/common/facade/module_facade.dart';
import '../../domain/common/failures/failures.dart';
import '../../domain/user/entities/user.dart';
import '../../domain/user/value_objects/user_value_objects.dart';
import '../auth/use_cases/login_use_case.dart';
import '../auth/use_cases/logout_use_case.dart';
import '../core/use_case.dart';
import '../user/use_cases/get_user_profile_use_case.dart';
import '../user/use_cases/update_user_profile_use_case.dart';

/// Facade for the User bounded context
/// Provides a unified interface for all user-related operations
class UserFacade implements ModuleFacade {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  
  bool _isReady = false;
  
  UserFacade({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getUserProfileUseCase = getUserProfileUseCase,
        _updateUserProfileUseCase = updateUserProfileUseCase;
  
  @override
  String get moduleName => 'User';
  
  @override
  bool get isReady => _isReady;
  
  @override
  Future<void> initialize() async {
    // Initialize any module-specific resources
    _isReady = true;
  }
  
  @override
  Future<void> dispose() async {
    // Clean up resources
    _isReady = false;
  }
  
  /// Authentication operations
  Future<Either<AppFailure, User>> login({
    required String phone,
    required String verificationCode,
  }) {
    return _loginUseCase(LoginParams(
      phone: phone,
      verificationCode: verificationCode,
    ));
  }
  
  Future<Either<AppFailure, void>> logout() {
    return _logoutUseCase(NoParams());
  }
  
  /// User profile operations
  Future<Either<AppFailure, User>> getCurrentUser() async {
    // TODO(dev): 获取当前用户ID
    return Left(Failure.unexpected('Not implemented'));
  }
  
  Future<Either<AppFailure, User>> getUserById(UserId userId) {
    return _getUserProfileUseCase(GetUserProfileParams(userId: userId));
  }
  
  Future<Either<AppFailure, User>> updateProfile({
    required User user,
  }) {
    return _updateUserProfileUseCase(UpdateUserProfileParams(
      user: user,
    ));
  }
}