import 'package:injectable/injectable.dart';

/// 用户偏好服务接口
abstract class IUserPreferencesService {
  /// 获取语言偏好
  String get language;
  
  /// 设置语言偏好
  Future<void> setLanguage(String language);
  
  /// 获取主题模式
  bool get isDarkMode;
  
  /// 设置主题模式
  Future<void> setDarkMode(bool isDark);
}

/// 用户偏好服务实现
@Injectable(as: IUserPreferencesService)
class UserPreferencesService implements IUserPreferencesService {
  String _language = 'zh';
  bool _isDarkMode = false;
  
  @override
  String get language => _language;
  
  @override
  Future<void> setLanguage(String language) async {
    _language = language;
  }
  
  @override
  bool get isDarkMode => _isDarkMode;
  
  @override
  Future<void> setDarkMode(bool isDark) async {
    _isDarkMode = isDark;
  }
}