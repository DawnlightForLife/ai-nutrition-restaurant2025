import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/nutrition/nutrition_screen.dart';
import '../../presentation/screens/nutrition/recommendation_entry_page.dart';
import '../../presentation/screens/nutrition/nutrition_profile_management_page.dart';
import '../../presentation/screens/nutrition/nutrition_profile_list_page.dart';
import '../../presentation/screens/nutrition/ai_recommendation_chat_page.dart';
import '../../presentation/screens/nutrition/ai_recommendation_result_page.dart';
import '../../presentation/screens/restaurant/restaurant_screen.dart';
import '../../presentation/screens/menu/menu_screen.dart';
import '../../presentation/screens/order/order_screen.dart';
import '../../presentation/screens/consultation/consultation_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/test/test_home_page.dart';
import '../../presentation/screens/test/test_error_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    // 启动页面
    AutoRoute(
      page: SplashRoute.page,
      path: '/splash',
      initial: true,
    ),
    
    // 引导页面
    AutoRoute(
      page: OnboardingRoute.page,
      path: '/onboarding',
    ),
    
    // 认证相关页面
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    AutoRoute(
      page: RegisterRoute.page,
      path: '/register',
    ),
    
    // 主要功能页面
    AutoRoute(
      page: HomeRoute.page,
      path: '/home',
    ),
    AutoRoute(
      page: ProfileRoute.page,
      path: '/profile',
    ),
    
    // 营养相关页面
    AutoRoute(
      page: NutritionRoute.page,
      path: '/nutrition',
    ),
    AutoRoute(
      page: RecommendationEntryRoute.page,
      path: '/nutrition/recommendation',
    ),
    AutoRoute(
      page: NutritionProfileListRoute.page,
      path: '/nutrition/profiles',
    ),
    AutoRoute(
      page: NutritionProfileManagementRoute.page,
      path: '/nutrition/profile/:id',
    ),
    AutoRoute(
      page: AiRecommendationChatRoute.page,
      path: '/nutrition/ai-chat',
    ),
    AutoRoute(
      page: AiRecommendationResultRoute.page,
      path: '/nutrition/ai-result',
    ),
    
    // 餐厅相关页面
    AutoRoute(
      page: RestaurantRoute.page,
      path: '/restaurant',
    ),
    
    // 菜单页面
    AutoRoute(
      page: MenuRoute.page,
      path: '/menu',
    ),
    
    // 订单页面
    AutoRoute(
      page: OrderRoute.page,
      path: '/order',
    ),
    
    // 咨询页面
    AutoRoute(
      page: ConsultationRoute.page,
      path: '/consultation',
    ),
    
    // 测试页面
    AutoRoute(
      page: TestHomeRoute.page,
      path: '/test',
    ),
    AutoRoute(
      page: TestErrorRoute.page,
      path: '/test/error',
    ),
    
    // 404页面
    AutoRoute(
      page: NotFoundRoute.page,
      path: '/404',
    ),
    
    // 重定向未知路由到404
    RedirectRoute(
      path: '*',
      redirectTo: '/404',
    ),
  ];
}

// 404页面
@RoutePage()
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('页面未找到'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              '抱歉，您访问的页面不存在',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              '请检查网址是否正确',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replaceAll([const HomeRoute()]),
        label: const Text('返回首页'),
        icon: const Icon(Icons.home),
      ),
    );
  }
}