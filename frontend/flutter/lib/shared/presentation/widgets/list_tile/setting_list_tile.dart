import 'package:flutter/material.dart';

/// 设置列表项
class SettingListTile extends StatelessWidget {
  /// 标题
  final String title;
  
  /// 副标题
  final String? subtitle;
  
  /// 左侧图标
  final IconData? leadingIcon;
  
  /// 右侧图标
  final IconData trailingIcon;
  
  /// 点击事件
  final VoidCallback? onTap;
  
  /// 文本颜色
  final Color? textColor;
  
  /// 图标颜色
  final Color? iconColor;
  
  /// 构造函数
  const SettingListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.trailingIcon = Icons.chevron_right,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final finalTextColor = textColor ?? defaultColor;
    final finalIconColor = iconColor ?? defaultColor;

    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: finalTextColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: finalTextColor.withOpacity(0.7),
              ),
            )
          : null,
      leading: leadingIcon != null
          ? Icon(
              leadingIcon,
              color: finalIconColor,
            )
          : null,
      trailing: Icon(
        trailingIcon,
        color: finalIconColor.withOpacity(0.7),
        size: 20,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: false,
    );
  }
} 