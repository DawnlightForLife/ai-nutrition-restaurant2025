import 'package:flutter/material.dart';

/// 骨架加载项组件
///
/// 用于在内容加载过程中显示的占位UI
class SkeletonItem extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final Duration animationDuration;
  final bool isCircle;
  final EdgeInsetsGeometry? margin;

  const SkeletonItem({
    Key? key,
    this.width = double.infinity,
    this.height = 16.0,
    this.borderRadius = 4.0,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.animationDuration = const Duration(milliseconds: 1500),
    this.isCircle = false,
    this.margin,
  }) : super(key: key);

  @override
  State<SkeletonItem> createState() => _SkeletonItemState();
}

class _SkeletonItemState extends State<SkeletonItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);
    
    _colorAnimation = ColorTween(
      begin: widget.baseColor,
      end: widget.highlightColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
}

/// 骨架列表组件
///
/// 用于显示一组骨架加载项
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry itemMargin;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final SkeletonItem Function(BuildContext, int)? itemBuilder;

  const SkeletonList({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 80.0,
    this.padding = const EdgeInsets.all(16.0),
    this.itemMargin = const EdgeInsets.only(bottom: 16.0),
    this.shrinkWrap = false,
    this.physics,
    this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
}
