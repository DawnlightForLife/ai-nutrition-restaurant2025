import 'package:flutter/material.dart';

/// 主按钮
class PrimaryButton extends StatelessWidget {
  /// 按钮文本
  final String text;
  
  /// 点击事件
  final VoidCallback? onPressed;
  
  /// 是否加载中
  final bool isLoading;
  
  /// 是否填充宽度
  final bool fullWidth;
  
  /// 按钮高度
  final double height;
  
  /// 按钮颜色
  final Color? color;
  
  /// 文本颜色
  final Color? textColor;
  
  /// 图标
  final IconData? icon;
  
  /// 构造函数
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = 48.0,
    this.color,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.colorScheme.primary;
    final buttonTextColor = textColor ?? theme.colorScheme.onPrimary;
    
    final buttonChild = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: buttonTextColor),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: buttonTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: buttonTextColor,
          disabledBackgroundColor: buttonColor.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: buttonChild,
      ),
    );
  }
} 