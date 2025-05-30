import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/user/presentation/pages/home_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

/// App Theme Provider
final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // 2秒后关闭欢迎页
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSplash = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(appThemeProvider);
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: '营养立方',
      theme: appTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: _showSplash 
        ? const SplashPage()
        : (authState.isAuthenticated ? const MainHomePage() : const LoginPage()),
    );
  }
}