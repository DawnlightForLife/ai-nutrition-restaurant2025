import 'package:auto_route/auto_route.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/guards.dart';

/// Order 模块路由配置
class OrderRouter {
  /// 获取 Order 模块的所有路由
  static List<AutoRoute> get routes => [
    // 订单列表
    AutoRoute(
      page: OrderListRoute.page,
      path: '/orders',
      guards: [AuthGuard()],
    ),
    
    // 订单详情
    AutoRoute(
      page: OrderDetailRoute.page,
      path: '/order/:id',
      guards: [AuthGuard()],
    ),
    
    // 创建订单
    AutoRoute(
      page: OrderCreateRoute.page,
      path: '/order/create',
      guards: [AuthGuard()],
    ),
    
    // 支付页面
    AutoRoute(
      page: PaymentRoute.page,
      path: '/order/:id/payment',
      guards: [AuthGuard()],
    ),
    
    // 订单追踪
    AutoRoute(
      page: OrderTrackingRoute.page,
      path: '/order/:id/tracking',
      guards: [AuthGuard()],
    ),
    
    // 退款申请
    AutoRoute(
      page: RefundRequestRoute.page,
      path: '/order/:id/refund',
      guards: [AuthGuard()],
    ),
  ];
  
  /// 路由名称常量
  static const String orderListPath = '/orders';
  static const String orderDetailPath = '/order/:id';
  static const String orderCreatePath = '/order/create';
  static const String paymentPath = '/order/:id/payment';
  static const String trackingPath = '/order/:id/tracking';
  static const String refundPath = '/order/:id/refund';
  
  /// 便捷方法：生成订单详情路径
  static String orderDetailPathWithId(String id) => '/order/$id';
  
  /// 便捷方法：生成支付路径
  static String paymentPathWithId(String id) => '/order/$id/payment';
  
  /// 便捷方法：生成追踪路径
  static String trackingPathWithId(String id) => '/order/$id/tracking';
  
  /// 便捷方法：生成退款路径
  static String refundPathWithId(String id) => '/order/$id/refund';
}