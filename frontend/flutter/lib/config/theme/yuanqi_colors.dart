import 'package:flutter/material.dart';

/// 元气立方品牌色彩系统
class YuanqiColors {
  // 私有构造函数，防止实例化
  YuanqiColors._();

  // 主色 - 活力橙色
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color primaryOrangeLight = Color(0xFFFF8F5E);
  static const Color primaryOrangeDark = Color(0xFFE55100);
  
  // 辅助色
  static const Color secondaryGreen = Color(0xFF4CAF50);  // 健康绿
  static const Color secondaryBlue = Color(0xFF2196F3);   // 信任蓝
  static const Color secondaryYellow = Color(0xFFFFB74D); // 温暖黄
  
  // 中性色
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textTertiary = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  
  // 功能色
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, primaryOrangeLight],
  );
  
  // 按钮渐变
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFF6B35), Color(0xFFFF8F5E)],
  );
  
  // 第三方登录图标颜色
  static const Color wechatGreen = Color(0xFF07C160);
  static const Color alipayBlue = Color(0xFF1677FF);
  static const Color dingdingBlue = Color(0xFF0089FF);
  static const Color wecomBlue = Color(0xFF2B7BF6);
}