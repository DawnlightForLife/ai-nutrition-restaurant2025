import 'package:flutter/material.dart';
import 'package:ai_nutrition_restaurant/modules/core/screens/splash_screen.dart';
import 'package:ai_nutrition_restaurant/modules/core/screens/main_page.dart';
import 'package:ai_nutrition_restaurant/modules/onboarding/screens/welcome_screen.dart';
import 'package:ai_nutrition_restaurant/modules/onboarding/screens/intro_page.dart';
import 'package:ai_nutrition_restaurant/modules/onboarding/screens/onboarding_page.dart';
import 'package:ai_nutrition_restaurant/modules/user/screens/login_page.dart';
import 'package:ai_nutrition_restaurant/modules/user/screens/register_page.dart';

// 定义路由名常量
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  static const String main = '/main';
}

// 应用路由表
final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.welcome: (context) => const WelcomeScreen(),
  AppRoutes.intro: (context) => const IntroPage(),
  AppRoutes.login: (context) => const LoginPage(),
  AppRoutes.register: (context) => const RegisterPage(),
  AppRoutes.onboarding: (context) => const OnboardingPage(),
  AppRoutes.main: (context) => const MainPage(),
};