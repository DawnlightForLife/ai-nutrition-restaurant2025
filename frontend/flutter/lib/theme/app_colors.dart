/// 应用颜色定义
/// 
/// 统一管理所有颜色常量
library;

import 'package:flutter/material.dart';

/// 应用颜色
abstract class AppColors {
  // ========== 主色系 ==========
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFF81C784);
  
  // ========== 辅助色 ==========
  static const Color secondary = Color(0xFFFF9800);
  static const Color accent = Color(0xFF03DAC6);
  
  // ========== 语义色 ==========
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // ========== 中性色 ==========
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color gray = Color(0xFF9E9E9E);
  static const Color grayLight = Color(0xFFE0E0E0);
  static const Color grayDark = Color(0xFF424242);
  
  // ========== 背景色 ==========
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFFEEEEEE);
  
  // ========== 文字色 ==========
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);
  
  // ========== 元气营养品牌色（原 yuanqi_colors） ==========
  static const Color brandGreen = Color(0xFF4CAF50);
  static const Color brandOrange = Color(0xFFFF6B35);
  static const Color brandYellow = Color(0xFFFFC107);
}
