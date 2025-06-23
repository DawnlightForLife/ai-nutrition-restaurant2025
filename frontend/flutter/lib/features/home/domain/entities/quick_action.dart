import 'package:flutter/material.dart';

/// 快捷操作实体
class QuickAction {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;
  final Map<String, dynamic>? params;
  final bool isEnabled;
  final int order;
  
  const QuickAction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
    this.params,
    required this.isEnabled,
    required this.order,
  });
}

/// 预定义的快捷操作
class DefaultQuickActions {
  static const List<QuickAction> actions = [
    QuickAction(
      id: 'ai_recommendation',
      title: 'AI推荐',
      subtitle: '智能营养搭配',
      icon: Icons.restaurant_menu,
      color: Colors.orange,
      route: '/ai/chat',
      isEnabled: true,
      order: 1,
    ),
    QuickAction(
      id: 'search_dishes',
      title: '搜索菜品',
      subtitle: '找到您想要的',
      icon: Icons.search,
      color: Colors.blue,
      route: '/search',
      isEnabled: true,
      order: 2,
    ),
    QuickAction(
      id: 'nutrition_profile',
      title: '营养档案',
      subtitle: '管理健康信息',
      icon: Icons.person_outline,
      color: Colors.green,
      route: '/nutrition/profiles',
      isEnabled: true,
      order: 3,
    ),
    QuickAction(
      id: 'nutritionist',
      title: '找营养师',
      subtitle: '专业营养咨询',
      icon: Icons.medical_services,
      color: Colors.teal,
      route: '/nutritionists',
      isEnabled: true,
      order: 4,
    ),
    QuickAction(
      id: 'nearby_stores',
      title: '附近门店',
      subtitle: '找到最近门店',
      icon: Icons.store,
      color: Colors.purple,
      route: '/stores/nearby',
      isEnabled: true,
      order: 5,
    ),
    QuickAction(
      id: 'shopping_cart',
      title: '购物车',
      subtitle: '查看已选菜品',
      icon: Icons.shopping_cart,
      color: Colors.redAccent,
      route: '/cart',
      isEnabled: true,
      order: 6,
    ),
  ];
}