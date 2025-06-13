import 'package:flutter/material.dart';

/// 应用分隔线
class AppDivider extends StatelessWidget {
  /// 高度
  final double height;
  
  /// 颜色
  final Color? color;
  
  /// 左边距
  final double leftIndent;
  
  /// 右边距
  final double rightIndent;
  
  /// 构造函数
  const AppDivider({
    super.key,
    this.height = 1.0,
    this.color,
    this.leftIndent = 0.0,
    this.rightIndent = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: height,
      color: color ?? Theme.of(context).dividerColor.withOpacity(0.1),
      indent: leftIndent,
      endIndent: rightIndent,
    );
  }
} 