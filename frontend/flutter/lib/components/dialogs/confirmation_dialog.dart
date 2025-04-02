import 'package:flutter/material.dart';

/// 确认对话框组件
///
/// 用于需要用户确认的操作，支持自定义标题、内容和按钮文本
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;
  final Widget? icon;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = '确认',
    this.cancelText = '取消',
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
    this.icon,
  }) : super(key: key);

  /// 显示确认对话框的静态方法
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '确认',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
    Widget? icon,
  }) async {
    // TODO: 待填充对话框显示逻辑
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
} 