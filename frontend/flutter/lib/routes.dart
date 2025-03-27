import 'package:flutter/material.dart';
import 'screens/onboarding/onboarding_page.dart';
import 'screens/user/auth/login_page.dart';
import 'screens/admin/home/admin_home_page.dart';
import 'screens/admin/nutritionist_verification/nutritionist_verification_management.dart';
import 'screens/admin/merchant_verification/merchant_verification_management.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/onboarding': (context) => const OnboardingPage(),
  '/login': (context) => const LoginPage(),
  '/admin/home': (context) => const AdminHomePage(),
  '/admin/nutritionist-verification': (context) => const NutritionistVerificationManagement(),
  '/admin/merchant-verification': (context) => const MerchantVerificationManagement(),
  '/merchant/verification': (context) => const MerchantVerificationManagement(),
};
