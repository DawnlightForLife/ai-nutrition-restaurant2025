import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection.dart';
import 'config/theme/app_theme.dart';
import 'config/routes/app_router.dart';
import 'presentation/providers/app_providers.dart';

/// 应用根组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'AI营养餐厅',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            navigatorKey: AppRouter.navigatorKey,
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: '/splash',
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}