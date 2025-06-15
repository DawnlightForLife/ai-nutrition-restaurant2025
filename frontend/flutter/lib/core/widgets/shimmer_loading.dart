import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer加载占位组件
class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerLoading({
    Key? key,
    this.width,
    this.height,
    this.child,
    this.borderRadius,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}

/// Shimmer列表加载组件
class ShimmerListLoading extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;

  const ShimmerListLoading({
    Key? key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerLoading(
          height: itemHeight,
          margin: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              ShimmerLoading(
                width: 60,
                height: 60,
                borderRadius: BorderRadius.circular(30),
                margin: const EdgeInsets.all(10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                      height: 16,
                      width: 150,
                      margin: const EdgeInsets.only(bottom: 8),
                    ),
                    ShimmerLoading(
                      height: 12,
                      width: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}