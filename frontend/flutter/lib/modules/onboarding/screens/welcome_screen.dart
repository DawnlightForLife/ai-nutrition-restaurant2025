import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_nutrition_restaurant/app/router.dart';

/// 欢迎页，用于引导首次用户体验
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // 模拟初始化操作：如检查登录状态、加载缓存配置等
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FlutterLogo(size: 100), // 项目 Logo 或启动动画
      ),
    );
  }
}