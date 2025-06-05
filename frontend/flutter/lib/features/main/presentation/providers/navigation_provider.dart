import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 底部导航栏索引状态管理
final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((ref) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }

  void toHome() => setIndex(0);
  void toRecommendation() => setIndex(1);
  void toForum() => setIndex(2);
  void toOrder() => setIndex(3);
  void toProfile() => setIndex(4);
}

/// 导航栏配置
class NavigationConfig {
  static const List<NavigationItem> items = [
    NavigationItem(
      label: '首页',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavigationItem(
      label: '推荐',
      icon: Icons.restaurant_outlined,
      activeIcon: Icons.restaurant,
    ),
    NavigationItem(
      label: '论坛',
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum,
    ),
    NavigationItem(
      label: '订单',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
    ),
    NavigationItem(
      label: '我的',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];
}

class NavigationItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}