import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../network/network_monitor.dart';
import '../network/offline_manager.dart';
import '../../infrastructure/services/auth_service.dart';
import '../../infrastructure/services/user_preferences_service.dart';

/// 全局依赖注入容器
final GetIt getIt = GetIt.instance;

/// 配置依赖注入
/// 
/// 该函数初始化所有依赖项，必须在应用启动时调用
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  // 临时初始化，等待代码生成后替换
  // getIt.init();
  
  // 手动注册核心服务
  _registerCoreServices();
}

/// 手动注册核心服务
void _registerCoreServices() {
  // 这里手动注册一些关键服务
  // 后续可以替换为自动生成的依赖注入代码
  
  // 注册网络监控器
  final networkMonitor = NetworkMonitor();
  getIt.registerSingleton<NetworkMonitor>(networkMonitor);
  
  // 注册离线管理器
  getIt.registerSingleton<OfflineManager>(OfflineManager(networkMonitor));
  
  // 注册认证服务
  getIt.registerLazySingleton<IAuthService>(() => AuthService());
  
  // 注册用户偏好服务
  getIt.registerLazySingleton<IUserPreferencesService>(() => UserPreferencesService());
}

/// 重置依赖注入容器（主要用于测试）
void resetDependencies() {
  getIt.reset();
}