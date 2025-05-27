import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/auth/login_page.dart';
import 'presentation/screens/home/home_page.dart';
import 'presentation/providers/auth_state_provider.dart';
import 'config/theme/yuanqi_colors.dart';
import 'config/app_config.dart';

class YuanqiApp extends ConsumerWidget {
  const YuanqiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = AppConfig.instance;
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp(
        title: config.appName,
        debugShowCheckedModeBanner: !config.isProd,
        theme: ThemeData(
          primaryColor: YuanqiColors.primaryOrange,
          colorScheme: ColorScheme.fromSeed(
            seedColor: YuanqiColors.primaryOrange,
            primary: YuanqiColors.primaryOrange,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: YuanqiColors.textPrimary),
            titleTextStyle: TextStyle(
              color: YuanqiColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: YuanqiColors.primaryOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: YuanqiColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: YuanqiColors.primaryOrange,
                width: 2,
              ),
            ),
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return YuanqiColors.primaryOrange;
              }
              return null;
            }),
          ),
        ),
        home: _buildHome(authState),
      );
  }
  
  Widget _buildHome(AuthState authState) {
    // 如果正在加载，显示启动画面
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/logo.png'),
                width: 120,
                height: 120,
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                color: YuanqiColors.primaryOrange,
              ),
              SizedBox(height: 16),
              Text(
                '元气立方',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: YuanqiColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '正在启动...',
                style: TextStyle(
                  fontSize: 14,
                  color: YuanqiColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    // 如果已认证，显示主页
    if (authState.isAuthenticated && authState.user != null) {
      return const HomePage();
    }
    
    // 否则显示登录页
    return const LoginPage();
  }
}