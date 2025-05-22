// app.dart
// 应用入口：配置全局路由
import 'package:flutter/material.dart';
import 'router.dart'; // 导入路由配置

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智慧AI营养餐厅',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: appRoutes,
    );
  }
}