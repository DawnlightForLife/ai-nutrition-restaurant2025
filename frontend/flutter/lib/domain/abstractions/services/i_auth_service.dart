/// 认证服务接口
abstract class IAuthService {
  /// 检查用户是否已登录
  bool get isLoggedIn;
  
  /// 获取当前用户token
  String? get currentToken;
  
  /// 登录
  Future<bool> login(String email, String password);
  
  /// 登出
  Future<void> logout();
  
  /// 注册
  Future<bool> register(String email, String password, String name);
  
  /// 检查token是否有效
  Future<bool> isTokenValid();
  
  /// 刷新token
  Future<String?> refreshToken();
}