/// 环境配置
class Environment {
  static const String _env = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => _env == 'development';
  static bool get isProduction => _env == 'production';

  /// API 基础地址
  static String get apiBaseUrl {
    switch (_env) {
      case 'production':
        return 'https://api.yuanqicube.com/api';
      case 'development':
      default:
        // 开发环境使用本地后端服务
        // 后端运行在 Docker 容器中，通过 8080 端口访问
        // 如果是真机调试，需要改成电脑的 IP 地址
        return 'http://10.0.2.2:8080/api'; // Android 模拟器访问主机的8080端口
        // return 'http://localhost:8080/api'; // iOS 模拟器
        // return 'http://192.168.1.8:8080/api'; // 真机调试时使用实际 IP
    }
  }

  /// API 超时时间（毫秒）
  static const int apiTimeout = 30000;

  /// 是否启用日志
  static bool get enableLogging => isDevelopment;
}