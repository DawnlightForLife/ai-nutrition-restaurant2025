import 'package:injectable/injectable.dart';

/// 认证服务接口
abstract class IAuthService {
  /// 检查是否已登录
  bool get isLoggedIn;
  
  /// 检查是否第一次启动
  bool get isFirstLaunch;
  
  /// 标记已完成引导
  Future<void> markOnboardingComplete();
}

/// 认证服务实现
@Injectable(as: IAuthService)
class AuthService implements IAuthService {
  bool _isLoggedIn = false;
  bool _isFirstLaunch = true;
  
  @override
  bool get isLoggedIn => _isLoggedIn;
  
  @override
  bool get isFirstLaunch => _isFirstLaunch;
  
  @override
  Future<void> markOnboardingComplete() async {
    _isFirstLaunch = false;
  }
  
  // 测试用方法
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
  }
}