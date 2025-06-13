import 'package:flutter/material.dart';
import 'package:ai_nutrition_restaurant/l10n/app_localizations.dart';

/// BuildContext 扩展方法
extension BuildContextExtensions on BuildContext {
  /// 获取本地化资源
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// 获取主题
  ThemeData get theme => Theme.of(this);
  
  /// 获取颜色方案
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// 获取文本主题
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// 获取屏幕尺寸
  Size get screenSize => MediaQuery.of(this).size;
  
  /// 获取屏幕宽度
  double get screenWidth => MediaQuery.of(this).size.width;
  
  /// 获取屏幕高度
  double get screenHeight => MediaQuery.of(this).size.height;
  
  /// 获取安全区域
  EdgeInsets get padding => MediaQuery.of(this).padding;
  
  /// 获取底部安全区域高度
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  
  /// 获取顶部安全区域高度
  double get topPadding => MediaQuery.of(this).padding.top;
  
  /// 显示加载对话框
  Future<void> showLoading({String? message}) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(message),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  /// 隐藏对话框
  void hideLoading() {
    Navigator.of(this).pop();
  }
} 