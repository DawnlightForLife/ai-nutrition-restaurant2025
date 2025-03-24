import 'package:flutter/material.dart';
import 'screens/onboarding/onboarding_page.dart';
import 'screens/user/auth/login_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/onboarding': (context) => const OnboardingPage(),
  '/login': (context) => const LoginPage(),
};
