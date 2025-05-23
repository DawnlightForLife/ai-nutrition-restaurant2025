import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'theme/theme_provider.dart';

/// 应用全局Provider配置
class AppProviders {
  AppProviders._();
  
  /// 所有Provider列表
  static List<SingleChildWidget> get providers => [
    // 主题Provider
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
    ),
    
    // TODO: 添加其他Provider
    // 注意：由于依赖注入尚未完全配置，暂时只启用ThemeProvider
  ];
}