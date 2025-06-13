import 'package:flutter/material.dart';

/// 箭头右图标
class ArrowRight extends StatelessWidget {
  /// 颜色
  final Color? color;
  
  /// 大小
  final double size;
  
  /// 构造函数
  const ArrowRight({
    super.key,
    this.color,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios,
      color: color,
      size: size,
    );
  }
} 