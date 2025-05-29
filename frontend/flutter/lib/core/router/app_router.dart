import 'package:auto_route/auto_route.dart';

// 导入各模块路由
import '../../features/auth/presentation/router/auth_router.dart';
import '../../features/user/presentation/router/user_router.dart';
import '../../features/nutrition/presentation/router/nutrition_router.dart';
import '../../features/merchant/presentation/router/merchant_router.dart';
import '../../features/nutritionist/presentation/router/nutritionist_router.dart';
import '../../features/admin/presentation/router/admin_router.dart';
import '../../features/employee/presentation/router/employee_router.dart';
import '../../features/global_pages/presentation/router/global_pages_router.dart';
import '../../features/forum/presentation/router/forum_router.dart';
import '../../features/order/presentation/router/order_router.dart';
import '../../features/recommendation/presentation/router/recommendation_router.dart';
import '../../features/consultation/presentation/router/consultation_router.dart';

// 导入guards
import '../../shared/enums/user_role.dart';
import 'guards.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // 全局页面路由
    ...GlobalPagesRouter.routes,
    
    // 认证模块路由
    ...AuthRouter.routes,
    
    // 用户模块路由
    ...UserRouter.routes,
    
    // 营养模块路由
    ...NutritionRouter.routes,
    
    // 商家模块路由
    ...MerchantRouter.routes,
    
    // 营养师模块路由
    ...NutritionistRouter.routes,
    
    // 管理员模块路由
    ...AdminRouter.routes,
    
    // 员工模块路由
    ...EmployeeRouter.routes,
    
    // 论坛模块路由
    ...ForumRouter.routes,
    
    // 订单模块路由
    ...OrderRouter.routes,
    
    // 推荐模块路由
    ...RecommendationRouter.routes,
    
    // 咨询模块路由
    ...ConsultationRouter.routes,
  ];
  
  /// 获取模块路由映射，便于动态配置
  static Map<String, List<AutoRoute>> get moduleRoutes => {
    'auth': AuthRouter.routes,
    'user': UserRouter.routes,
    'nutrition': NutritionRouter.routes,
    'merchant': MerchantRouter.routes,
    'nutritionist': NutritionistRouter.routes,
    'admin': AdminRouter.routes,
    'employee': EmployeeRouter.routes,
    'global': GlobalPagesRouter.routes,
    'forum': ForumRouter.routes,
    'order': OrderRouter.routes,
    'recommendation': RecommendationRouter.routes,
    'consultation': ConsultationRouter.routes,
  };
}