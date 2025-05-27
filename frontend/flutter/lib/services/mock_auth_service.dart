import 'auth_service.dart';

class MockAuthService extends AuthService {
  // 开发测试用的mock token
  static const String mockToken = 'mock_jwt_token_for_development';
  static const String mockUserId = 'test_user_123';

  @override
  Future<String?> getToken() async {
    // 开发环境返回mock token
    return mockToken;
  }
  
  @override
  Future<String?> getUserId() async {
    // 开发环境返回mock用户ID
    return mockUserId;
  }
  
  @override
  Future<bool> isLoggedIn() async {
    // 开发环境始终返回已登录
    return true;
  }
}