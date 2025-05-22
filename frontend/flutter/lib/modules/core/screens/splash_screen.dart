import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ai_nutrition_restaurant/app/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 延迟2秒后导航到欢迎页
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 24),
            Text('欢迎使用 AI 营养餐厅'),
          ],
        ),
      ),
    );
  }
}