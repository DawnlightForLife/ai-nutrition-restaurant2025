import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/di/service_locator.dart';
import 'core/navigation/app_router.dart';
import 'core/error/error_boundary.dart';
import 'core/error/error_handler.dart';
import 'presentation/components/common/network_indicator.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化依赖注入
  await configureDependencies();
  
  // 网络监控会在首次访问时自动初始化
  
  // 运行应用
  runApp(const ProviderScope(child: TestApp()));
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    
    return ErrorBoundary(
      onError: (error, stackTrace) {
        GlobalErrorHandler.logError(
          'Test app error',
          error: error,
          stackTrace: stackTrace,
        );
      },
      child: MaterialApp.router(
        title: 'Phase 1 Test',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: appRouter.config(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return NetworkBanner(
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}