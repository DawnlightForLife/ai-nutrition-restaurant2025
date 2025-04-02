import 'package:flutter/material.dart';

/// 应用通用按钮组件
///
/// 支持多种按钮样式，包括主要、次要、文本和图标按钮
class AppButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;

  const AppButton({
    Key? key,
    this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
}

/// 按钮类型枚举
enum ButtonType {
  primary,
  secondary,
  text,
  icon,
}
