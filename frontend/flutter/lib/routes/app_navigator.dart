import 'package:flutter/material.dart';
import 'route_names.dart';

/// 应用导航管理器
/// 封装了所有的路由跳转逻辑，提供类型安全的导航方法
class AppNavigator {
  // 防止实例化
  AppNavigator._();

  // 基础导航方法
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> pushNamed<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget page) {
    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static Future<T?> pushReplacementNamed<T, TO>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T, TO>(context, routeName, arguments: arguments);
  }

  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget page, RoutePredicate predicate) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
      predicate,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T>(BuildContext context, String routeName, RoutePredicate predicate, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  static void popUntil(BuildContext context, RoutePredicate predicate) {
    Navigator.popUntil(context, predicate);
  }

  // 业务导航方法
  
  /// 导航到搜索页面
  static Future<T?> pushToSearch<T>(BuildContext context, {String? initialQuery}) {
    return pushNamed<T>(
      context,
      RouteNames.search,
      arguments: initialQuery != null ? {'query': initialQuery} : null,
    );
  }
  
  /// 跳转到登录页
  static Future<void> toLogin(BuildContext context) {
    return pushReplacementNamed(context, RouteNames.login);
  }

  /// 跳转到主页
  static Future<void> toMain(BuildContext context) {
    return pushNamedAndRemoveUntil(
      context,
      RouteNames.main,
      (route) => false,
    );
  }

  /// 跳转到营养档案列表
  static Future<void> toNutritionProfiles(BuildContext context) {
    return pushNamed(context, RouteNames.nutritionProfileList);
  }

  /// 跳转到营养档案详情
  static Future<void> toNutritionProfileDetail(BuildContext context, String profileId) {
    return pushNamed(
      context,
      RouteNames.nutritionProfileDetail,
      arguments: {'profileId': profileId},
    );
  }

  /// 跳转到营养档案编辑
  static Future<void> toNutritionProfileEditor(BuildContext context, {String? profileId}) {
    return pushNamed(
      context,
      RouteNames.nutritionProfileEditor,
      arguments: {'profileId': profileId},
    );
  }

  /// 跳转到AI聊天
  static Future<void> toAIChat(BuildContext context, String profileId) {
    return pushNamed(
      context,
      RouteNames.aiChat,
      arguments: {'profileId': profileId},
    );
  }

  /// 跳转到购物车
  static Future<void> toCart(BuildContext context) {
    return pushNamed(context, RouteNames.cart);
  }

  /// 跳转到订单确认
  static Future<void> toOrderConfirm(BuildContext context, List<String> cartItemIds) {
    return pushNamed(
      context,
      RouteNames.orderConfirm,
      arguments: {'cartItemIds': cartItemIds},
    );
  }

  /// 跳转到支付
  static Future<void> toPayment(BuildContext context, String orderId) {
    return pushNamed(
      context,
      RouteNames.payment,
      arguments: {'orderId': orderId},
    );
  }

  /// 跳转到支付结果
  static Future<void> toPaymentResult(BuildContext context, {
    required String orderId,
    required bool success,
  }) {
    return pushReplacementNamed(
      context,
      RouteNames.paymentResult,
      arguments: {'orderId': orderId, 'success': success},
    );
  }

  /// 跳转到商家展示页
  static Future<void> toStore(BuildContext context, String storeId) {
    return pushNamed(
      context,
      RouteNames.storeDisplay,
      arguments: {'storeId': storeId},
    );
  }

  /// 跳转到菜品详情
  static Future<void> toDish(BuildContext context, String dishId) {
    return pushNamed(
      context,
      RouteNames.dishDetail,
      arguments: {'dishId': dishId},
    );
  }

  /// 跳转到搜索
  static Future<void> toSearch(BuildContext context, {String? initialQuery}) {
    return pushNamed(
      context,
      RouteNames.search,
      arguments: {'query': initialQuery},
    );
  }

  /// 跳转到设置
  static Future<void> toSettings(BuildContext context) {
    return pushNamed(context, RouteNames.settings);
  }

  /// 跳转到消息中心
  static Future<void> toNotifications(BuildContext context) {
    return pushNamed(context, RouteNames.notificationCenter);
  }

  /// 跳转到地址管理
  static Future<void> toAddresses(BuildContext context) {
    return pushNamed(context, RouteNames.addressManager);
  }

  /// 跳转到论坛帖子详情
  static Future<void> toForumPost(BuildContext context, String postId) {
    return pushNamed(
      context,
      RouteNames.forumPostDetail,
      arguments: {'postId': postId},
    );
  }

  /// 跳转到营养师工作台
  static Future<void> toNutritionistWorkspace(BuildContext context) {
    return pushNamed(context, RouteNames.nutritionistMain);
  }

  /// 跳转到商家工作台
  static Future<void> toMerchantWorkspace(BuildContext context) {
    return pushNamed(context, RouteNames.merchantMain);
  }

  /// 跳转到员工工作台
  static Future<void> toEmployeeWorkspace(BuildContext context) {
    return pushNamed(context, RouteNames.employeeEntry);
  }

  /// 跳转到营养师认证申请
  static Future<void> toNutritionistCertification(BuildContext context, {
    String? applicationId,
    dynamic initialData,
  }) {
    return pushNamed(
      context,
      RouteNames.nutritionistCertification,
      arguments: {
        'applicationId': applicationId,
        'initialData': initialData,
      },
    );
  }

  /// 跳转到营养师认证状态
  static Future<void> toNutritionistCertificationStatus(
    BuildContext context, {
    required String applicationId,
  }) {
    return pushNamed(
      context,
      RouteNames.nutritionistCertificationStatus,
      arguments: {'applicationId': applicationId},
    );
  }

  /// 跳转到营养师认证编辑
  static Future<void> toNutritionistCertificationEdit(BuildContext context, {
    String? applicationId,
    dynamic initialData,
  }) {
    return pushNamed(
      context,
      RouteNames.nutritionistCertificationEdit,
      arguments: {
        'applicationId': applicationId,
        'initialData': initialData,
      },
    );
  }
}