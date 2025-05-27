import 'package:flutter/foundation.dart';
import '../../../domain/user/entities/user.dart';
import '../../../domain/abstractions/repositories/i_user_repository.dart';

/// 用户Provider
class UserProvider extends ChangeNotifier {
  final IUserRepository _userRepository;
  User _currentUser;
  
  UserProvider({
    required IUserRepository userRepository,
    required User currentUser,
  }) : _userRepository = userRepository,
       _currentUser = currentUser;
  
  User get currentUser => _currentUser;
  
  // TODO(dev): 实现用户相关功能
}