import 'package:flutter/material.dart';

import 'screens/user/auth/login_page.dart';
import 'screens/user/auth/register_page.dart';
import 'screens/user/home/home_page.dart';
import 'screens/user/profile/profile_page.dart';
import 'screens/user/health/health_profiles_page.dart';
import 'screens/user/orders/orders_page.dart';

/**
 * 获取应用路由表
 * 
 * 为应用程序定义路由映射，将路由路径与对应的页面构建器关联。
 * 这个函数返回一个Map，其中:
 * - 键(String): 是导航路径
 * - 值(WidgetBuilder): 是构建相应页面的函数
 * 
 * 路由表中包含：
 * - 首页路由
 * - 用户认证相关路由(登录、注册)
 * - 用户个人信息相关路由(个人资料)
 * - 健康档案相关路由
 * - 订单相关路由
 * 
 * @return {Map<String, WidgetBuilder>} 路由路径到页面构建器的映射
 */
Map<String, WidgetBuilder> getApplicationRoutes() {
  return {
    '/': (context) => const HomePage(),              // 首页路由，应用的默认页面
    '/login': (context) => const LoginPage(),        // 登录页面路由
    '/register': (context) => const RegisterPage(),  // 注册页面路由
    '/profile': (context) => const ProfilePage(),    // 用户个人资料页面路由
    '/health-profiles': (context) => const HealthProfilesPage(), // 健康档案列表页面路由
    '/orders': (context) => const OrdersPage(),      // 用户订单列表页面路由
  };
} 