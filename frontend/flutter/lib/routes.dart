import 'package:flutter/material.dart';

import 'screens/user/auth/login_page.dart';
import 'screens/user/auth/register_page.dart';
import 'screens/user/home/home_page.dart';
import 'screens/user/profile/profile_page.dart';
import 'screens/user/health/health_profiles_page.dart';
import 'screens/user/orders/orders_page.dart';

// 路由表
Map<String, WidgetBuilder> getApplicationRoutes() {
  return {
    '/': (context) => const HomePage(),
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/profile': (context) => const ProfilePage(),
    '/health-profiles': (context) => const HealthProfilesPage(),
    '/orders': (context) => const OrdersPage(),
  };
} 