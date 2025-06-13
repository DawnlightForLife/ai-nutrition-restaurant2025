import 'package:flutter/material.dart';

/// Toast工具类，用于显示提示信息
class ToastUtil {
  /// 显示成功提示
  static void showSuccess(BuildContext context, String message) {
    _showToast(context, message, Colors.green);
  }

  /// 显示错误提示
  static void showError(BuildContext context, String message) {
    _showToast(context, message, Colors.red);
  }

  /// 显示警告提示
  static void showWarning(BuildContext context, String message) {
    _showToast(context, message, Colors.orange);
  }

  /// 显示信息提示
  static void showInfo(BuildContext context, String message) {
    _showToast(context, message, Colors.blue);
  }

  /// 显示Toast
  static void _showToast(BuildContext context, String message, Color backgroundColor) {
    // 使用ScaffoldMessenger显示SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
} 