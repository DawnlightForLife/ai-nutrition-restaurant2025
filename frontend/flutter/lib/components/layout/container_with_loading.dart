import 'package:flutter/material.dart';

/// 带加载状态的容器组件
///
/// 可以在内容加载时显示加载指示器，加载完成后显示内容
class ContainerWithLoading extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  final Color? loadingBackgroundColor;
  final bool showChildWhileLoading;
  final bool fullScreenLoading;
  final String? loadingText;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const ContainerWithLoading({
    Key? key,
    required this.isLoading,
    required this.child,
    this.loadingWidget,
    this.loadingBackgroundColor,
    this.showChildWhileLoading = false,
    this.fullScreenLoading = false,
    this.loadingText,
    this.padding,
    this.backgroundColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
} 