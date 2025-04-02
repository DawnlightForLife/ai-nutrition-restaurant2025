import 'package:flutter/material.dart';

/// 应用卡片组件
///
/// 标准化的卡片容器，支持阴影、圆角和点击事件
class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius? borderRadius;
  final double elevation;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? shadowColor;
  final Border? border;
  final bool clipBehavior;
  final Widget? header;
  final Widget? footer;

  const AppCard({
    Key? key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius,
    this.elevation = 1.0,
    this.onTap,
    this.onLongPress,
    this.shadowColor,
    this.border,
    this.clipBehavior = false,
    this.header,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
}
