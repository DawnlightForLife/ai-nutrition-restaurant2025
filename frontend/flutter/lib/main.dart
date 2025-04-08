import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show HttpClient, HttpOverrides, SecurityContext, X509Certificate;
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// 导入项目中已有的模块
import 'providers/core/auth_provider.dart';
import 'providers/forum/forum_provider.dart';
import 'providers/health/health_profile_provider.dart';
import 'services/core/api_service.dart';
import 'services/core/auth_service.dart';
import 'services/forum/forum_service.dart';
import 'repositories/forum/forum_repository.dart';
import 'router/app_routes.dart';
import 'routes.dart';
import 'theme/app_theme.dart';

/**
 * 自定义HTTP覆盖类
 * 用于在开发环境中允许自签名证书，便于本地测试
 */
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

/**
 * 获取API基础URL
 * 根据环境不同返回对应的服务器地址
 * 
 * @returns {String} API基础URL
 */
String getApiBaseUrl() {
  debugPrint('📱 平台: ${defaultTargetPlatform.toString()}');
  
  // 为不同平台提供不同的API地址
  if (kIsWeb) {
    // Web环境使用相对路径
    return '/api';  // 添加/api前缀
  } else {
    // AndroidStudio模拟器环境
    if (defaultTargetPlatform == TargetPlatform.android) {
      // 后端容器将内部3000端口映射到主机的8080端口
      // Android模拟器中10.0.2.2是访问主机的特殊IP
      debugPrint('🔄 使用Android模拟器专用地址: 10.0.2.2:8080');
      return 'http://10.0.2.2:8080/api';  // 添加/api前缀
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS模拟器通过localhost访问宿主机
      debugPrint('🔄 使用iOS模拟器地址: localhost:8080');
      return 'http://localhost:8080/api';  // 添加/api前缀
    } else {
      // 其他平台（桌面等）
      debugPrint('🔄 使用默认地址: localhost:8080');
      return 'http://localhost:8080/api';  // 添加/api前缀
    }
  }
}

/**
 * 应用入口函数
 * 包含应用的初始化配置和主应用启动
 */
void main() {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  // 在开发环境中允许自签名证书
  if (kDebugMode) {
    HttpOverrides.global = MyHttpOverrides();
  }
  
  // 捕获全局错误
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter错误: ${details.exception}');
    debugPrint('Flutter错误堆栈: ${details.stack}');
    // 可以在这里添加更多的错误处理逻辑，比如上报服务器等
  };
  
  // 设置应用方向
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // A设置状态栏样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  
  runApp(const MyApp());
}

/**
 * 主应用类
 * 应用的根组件，配置主题、路由和全局状态管理
 */
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取API基础URL
    final apiBaseUrl = getApiBaseUrl();
    debugPrint('API基础URL: $apiBaseUrl');
    
    return MultiProvider(
      providers: [
        // 核心服务提供者 - 配置API服务
        Provider<ApiService>(
          create: (_) => ApiService(
            baseUrl: apiBaseUrl,
          ),
        ),
        
        // 身份验证服务 - 依赖于API服务
        ProxyProvider<ApiService, AuthService>(
          update: (_, apiService, __) => AuthService(apiService),
        ),
        
        // 身份验证状态管理提供者 - 管理用户登录状态
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        
        // 论坛服务提供者 - 依赖于API服务
        ProxyProvider<ApiService, ForumService>(
          update: (_, apiService, __) => ForumService(apiService),
        ),
        
        // 论坛仓库提供者 - 依赖于论坛服务和认证服务
        ProxyProvider2<ForumService, AuthService, ForumRepository>(
          update: (_, forumService, authService, __) => 
              ForumRepository(forumService, authService),
        ),
        
        // 论坛状态管理提供者 - 管理论坛数据状态
        ChangeNotifierProxyProvider<ForumRepository, ForumProvider>(
          create: (_) => ForumProvider(null), // 初始创建时传入null，等update时再提供真正的repository
          update: (_, repository, previous) => previous!..updateRepository(repository),
        ),
        
        // 健康档案Provider - 管理用户健康数据
        ChangeNotifierProxyProvider2<AuthProvider, ApiService, HealthProfileProvider>(
          create: (ctx) => HealthProfileProvider(
            authProvider: Provider.of<AuthProvider>(ctx, listen: false),
            apiService: Provider.of<ApiService>(ctx, listen: false),
          ),
          update: (ctx, auth, api, previousProfiles) => previousProfiles ?? HealthProfileProvider(
            authProvider: auth,
            apiService: api,
          ),
        ),
        
        // 其他服务提供者可以在这里添加...
      ],
      child: Consumer<AuthProvider>(
        builder: (context, userAuthProvider, child) {
          return MaterialApp(
            // 应用标题
            title: 'AI营养餐厅',
            
            // 主题配置
            theme: ThemeData(
              // 主题色
              primarySwatch: Colors.green,
              // 视觉密度
              visualDensity: VisualDensity.adaptivePlatformDensity,
              // 应用栏主题
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0.5,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.black87),
              ),
              // 文本主题
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                displayMedium: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                bodyLarge: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                bodyMedium: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              // 按钮主题
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // 输入装饰主题
              inputDecorationTheme: InputDecorationTheme(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                // 让错误文本更加突出
                errorStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
            
            // 路由配置
            initialRoute: AppRoutes.splash, // 总是从启动页面开始
            routes: AppRoutes.routes,
            onUnknownRoute: AppRoutes.onUnknownRoute,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            
            // 禁用调试横幅
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
