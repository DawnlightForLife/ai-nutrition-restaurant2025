import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/admin_provider.dart';
import 'screens/onboarding/onboarding_page.dart';
import 'screens/user/auth/login_page.dart';
import 'screens/user/auth/register_page.dart';
import 'screens/user/health/nutrition_profile_list_page.dart';
import 'screens/user/health/nutrition_profile_form_page.dart';
import 'screens/user/home/home_page.dart';
import 'screens/nutritionist/nutritionist_verification_page.dart';
import 'screens/nutritionist/nutritionist_home_page.dart';
import 'screens/admin/admin_home_page.dart';
import 'screens/admin/merchant_code_management.dart';
import 'screens/admin/merchant_verification/merchant_verification_management.dart';
import 'screens/merchant/merchant_verification_apply_page.dart';
import 'constants/api.dart';

void main() {
  // 应用启动时打印API配置
  ApiConstants.printConfig();
  
  // 验证API常量
  final baseUrl = ApiConstants.baseUrl;
  if (baseUrl.isEmpty) {
    print('警告: API基础URL为空！');
  } else {
    print('应用启动: API基础URL = $baseUrl');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const SmartNutritionRestaurantApp(),
    ),
  );
}

class SmartNutritionRestaurantApp extends StatelessWidget {
  const SmartNutritionRestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智慧AI营养餐厅',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.greenAccent),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/nutrition/profiles': (context) => const NutritionProfileListPage(),
        '/nutrition/profile/form': (context) => const NutritionProfileFormPage(),
        '/nutritionist/verification': (context) => const NutritionistVerificationPage(),
        '/nutritionist/home': (context) => const NutritionistHomePage(),
        
        // 管理员路由
        '/admin/home': (context) => const AdminHomePage(),
        '/admin/merchant-codes': (context) => const MerchantCodeManagement(),
        '/admin/merchant-verification': (context) => const MerchantVerificationManagement(),
        
        // 商家路由
        '/merchant/verification': (context) => const MerchantVerificationApplyPage(),
      },
    );
  }
}
