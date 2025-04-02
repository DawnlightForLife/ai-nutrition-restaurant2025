import 'package:flutter/material.dart';

/// 加载指示器组件
///
/// 用于表示内容正在加载中，支持自定义大小和颜色
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;
  final bool overlay;
  final bool fullScreen;
  final double strokeWidth;

  const LoadingIndicator({
    Key? key,
    this.size = 40.0,
    this.color,
    this.message,
    this.overlay = false,
    this.fullScreen = false,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  /// 创建全屏加载指示器
  static Widget fullScreenIndicator({
    String? message,
    Color? color,
  }) {
    // TODO: 待填充全屏加载指示器逻辑
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
} 