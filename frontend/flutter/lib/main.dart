import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding/onboarding_page.dart';
import 'screens/user//auth/login_page.dart';
import 'screens/user/health/health_form_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/health/form': (context) => const HealthFormPage(),

        // 其他页面继续补充
      },
    );
  }
}
