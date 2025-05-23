import 'package:flutter/material.dart';

/// 应用颜色定义
class AppColors {
  AppColors._();
  
  // 主题色
  static const Color primary = Color(0xFF4CAF50);      // 绿色 - 健康主题
  static const Color secondary = Color(0xFFFF9800);    // 橙色 - 营养主题
  static const Color tertiary = Color(0xFF2196F3);     // 蓝色 - 辅助色
  
  // 背景色
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // 文本色
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  // 状态色
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // 输入框背景色
  static const Color inputBackground = Color(0xFFF5F5F5);
  static const Color inputBackgroundDark = Color(0xFF2C2C2C);
  
  // 分割线
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
  
  // 营养相关颜色
  static const Color carbs = Color(0xFFFFB74D);        // 碳水化合物
  static const Color protein = Color(0xFF81C784);      // 蛋白质
  static const Color fat = Color(0xFF64B5F6);          // 脂肪
  static const Color fiber = Color(0xFFBA68C8);        // 纤维
  static const Color calories = Color(0xFFE57373);     // 热量
}