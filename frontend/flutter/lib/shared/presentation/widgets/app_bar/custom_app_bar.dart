import 'package:flutter/material.dart';
import 'package:ai_nutrition_restaurant/core/extensions/context_extension.dart';

/// 自定义AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 标题
  final String title;
  
  /// 是否居中标题
  final bool centerTitle;
  
  /// 是否显示返回按钮
  final bool showBackButton;
  
  /// 返回按钮点击事件
  final VoidCallback? onBackPressed;
  
  /// 操作按钮
  final List<Widget>? actions;
  
  /// 背景颜色
  final Color? backgroundColor;
  
  /// 标题颜色
  final Color? titleColor;
  
  /// 底部边框
  final Border? border;
  
  /// 高度
  final double height;
  
  /// 构造函数
  const CustomAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.border,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: context.textTheme.titleLarge?.copyWith(
          color: titleColor ?? context.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? context.colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: showBackButton,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              color: context.colorScheme.onSurface,
            )
          : null,
      actions: actions,
      bottom: border != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                decoration: BoxDecoration(border: border),
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
} 