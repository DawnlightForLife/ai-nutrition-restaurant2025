import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

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
  // 初始化injectable生成的依赖配置
  getIt.init();
}