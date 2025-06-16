import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/services/error_handling_service.dart';

/// 用户反馈服务
class UserFeedbackService {
  /// 显示SnackBar消息
  static void showSnackBar(
    BuildContext context,
    FeedbackMessage feedback,
  ) {
    if (!context.mounted) return;
    
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            _getIconForType(feedback.type),
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feedback.message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _getColorForType(feedback.type),
      duration: feedback.duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      action: feedback.action != null
          ? SnackBarAction(
              label: feedback.actionLabel ?? '重试',
              textColor: Colors.white,
              onPressed: feedback.action!,
            )
          : null,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  /// 显示成功消息
  static void showSuccess(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? action,
  }) {
    HapticFeedback.lightImpact();
    showSnackBar(
      context,
      FeedbackMessage.success(
        message,
        actionLabel: actionLabel,
        action: action,
      ),
    );
  }
  
  /// 显示错误消息
  static void showError(
    BuildContext context,
    dynamic error, {
    String? actionLabel,
    VoidCallback? action,
  }) {
    HapticFeedback.heavyImpact();
    final errorMessage = NutritionErrorHandlingService.getErrorMessage(error);
    final canRetry = NutritionErrorHandlingService.canRetry(error);
    
    showSnackBar(
      context,
      FeedbackMessage.error(
        errorMessage,
        actionLabel: actionLabel ?? (canRetry ? '重试' : null),
        action: action,
      ),
    );
  }
  
  /// 显示警告消息
  static void showWarning(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? action,
  }) {
    HapticFeedback.selectionClick();
    showSnackBar(
      context,
      FeedbackMessage.warning(
        message,
        actionLabel: actionLabel,
        action: action,
      ),
    );
  }
  
  /// 显示信息消息
  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? action,
  }) {
    showSnackBar(
      context,
      FeedbackMessage.info(
        message,
        actionLabel: actionLabel,
        action: action,
      ),
    );
  }
  
  /// 显示加载对话框
  static void showLoadingDialog(
    BuildContext context, {
    String message = '处理中...',
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => LoadingDialog(message: message),
    );
  }
  
  /// 隐藏加载对话框
  static void hideLoadingDialog(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
  
  /// 显示确认对话框
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '确认',
    String cancelText = '取消',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
  
  /// 显示选择对话框
  static Future<T?> showChoiceDialog<T>(
    BuildContext context, {
    required String title,
    required String message,
    required List<ChoiceOption<T>> options,
  }) async {
    return await showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            ...options.map((option) => ListTile(
              leading: option.icon != null
                  ? Icon(option.icon, color: option.color)
                  : null,
              title: Text(option.title),
              subtitle: option.subtitle != null
                  ? Text(option.subtitle!)
                  : null,
              onTap: () => Navigator.of(context).pop(option.value),
            )),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  static IconData _getIconForType(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return Icons.check_circle;
      case FeedbackType.error:
        return Icons.error;
      case FeedbackType.warning:
        return Icons.warning;
      case FeedbackType.info:
        return Icons.info;
    }
  }
  
  static Color _getColorForType(FeedbackType type) {
    switch (type) {
      case FeedbackType.success:
        return Colors.green;
      case FeedbackType.error:
        return Colors.red;
      case FeedbackType.warning:
        return Colors.orange;
      case FeedbackType.info:
        return Colors.blue;
    }
  }
}

/// 选择选项模型
class ChoiceOption<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final T value;
  
  const ChoiceOption({
    required this.title,
    this.subtitle,
    this.icon,
    this.color,
    required this.value,
  });
}

/// 加载对话框组件
class LoadingDialog extends StatelessWidget {
  final String message;
  
  const LoadingDialog({
    Key? key,
    required this.message,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}