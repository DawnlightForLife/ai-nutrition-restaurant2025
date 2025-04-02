import 'package:flutter/material.dart';

/// 带徽章的图标按钮组件
///
/// 在图标按钮上显示徽章，通常用于显示未读消息数量等
class IconButtonWithBadge extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final int? badgeCount;
  final Color? badgeColor;
  final Color? iconColor;
  final double iconSize;
  final bool showBadge;
  final EdgeInsetsGeometry padding;
  final String? tooltip;
  final bool useBadgeOverflow;
  final int badgeMaxValue;

  const IconButtonWithBadge({
    Key? key,
    required this.icon,
    this.onPressed,
    this.badgeCount,
    this.badgeColor,
    this.iconColor,
    this.iconSize = 24.0,
    this.showBadge = true,
    this.padding = const EdgeInsets.all(8.0),
    this.tooltip,
    this.useBadgeOverflow = true,
    this.badgeMaxValue = 99,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }

  /// 获取显示的徽章文本
  String _getBadgeText() {
    // TODO: 待填充徽章文本逻辑
    return '';
  }
} 