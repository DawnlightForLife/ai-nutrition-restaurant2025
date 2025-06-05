import 'package:flutter/material.dart';

/// 空状态展示组件
class EmptyStateWidget extends StatelessWidget {
  final String? image;
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final double iconSize;
  
  const EmptyStateWidget({
    super.key,
    this.image,
    this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.iconSize = 120,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.asset(
                image!,
                width: iconSize,
                height: iconSize,
              )
            else if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: theme.disabledColor,
              )
            else
              Icon(
                Icons.inbox_outlined,
                size: iconSize,
                color: theme.disabledColor,
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}