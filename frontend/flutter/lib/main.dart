import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/index.dart';
import 'screens/onboarding/index.dart';
import 'screens/user//auth/index.dart';
import 'screens/user/health/index.dart';

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
        '/register': (context) => const RegisterPage(),

        // 其他页面继续补充
      },
    );
  }
}
