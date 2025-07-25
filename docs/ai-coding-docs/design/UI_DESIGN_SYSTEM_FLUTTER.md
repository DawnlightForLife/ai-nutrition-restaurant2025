# AI智能营养餐厅系统 - Flutter UI组件设计系统

> **文档版本**: 2.0.0  
> **创建日期**: 2025-07-14  
> **更新日期**: 2025-07-14  
> **文档状态**: ✅ AI编码就绪  
> **目标受众**: AI编码工具、Flutter开发团队、UI/UX设计师

## 📋 目录

- [1. Flutter设计系统概述](#1-flutter设计系统概述)
- [2. 技术栈与规范](#2-技术栈与规范)
- [3. 主题配置](#3-主题配置)
- [4. 基础组件库](#4-基础组件库)
- [5. 复合组件库](#5-复合组件库)
- [6. 业务组件库](#6-业务组件库)
- [7. 页面模板](#7-页面模板)
- [8. 状态管理集成](#8-状态管理集成)
- [9. 响应式设计](#9-响应式设计)
- [10. 动画与交互](#10-动画与交互)
- [11. 无障碍设计](#11-无障碍设计)
- [12. 组件文档和示例](#12-组件文档和示例)

---

## 1. Flutter设计系统概述

### 1.1 设计原则

```yaml
核心理念:
  - Material Design 3: 遵循Material Design 3设计规范
  - 健康主题: 体现营养健康的品牌特色
  - AI智能: 突出智能化的用户体验
  - 易用性: 降低用户学习成本，提高操作效率

设计目标:
  - 统一性: 所有组件保持一致的设计语言
  - 可复用性: 组件高度可复用，降低开发成本
  - 可维护性: 代码结构清晰，易于维护和扩展
  - 性能优化: 组件性能优良，用户体验流畅

Flutter特性:
  - 跨平台一致性: iOS和Android体验统一
  - 热重载: 快速开发和调试
  - 响应式设计: 适配不同屏幕尺寸
  - 原生性能: 接近原生应用的性能表现
```

### 1.2 项目架构

```
lib/
├── core/                          # 核心配置
│   ├── theme/                     # 主题配置
│   │   ├── app_theme.dart         # 应用主题
│   │   ├── color_schemes.dart     # 颜色方案
│   │   └── text_themes.dart       # 文字主题
│   ├── constants/                 # 常量定义
│   │   ├── app_sizes.dart         # 尺寸常量
│   │   ├── app_durations.dart     # 动画时长
│   │   └── app_assets.dart        # 资源路径
│   └── utils/                     # 工具类
│       ├── responsive_utils.dart  # 响应式工具
│       └── theme_utils.dart       # 主题工具
├── widgets/                       # 组件库
│   ├── atoms/                     # 原子组件
│   │   ├── buttons/               # 按钮组件
│   │   ├── inputs/                # 输入组件
│   │   ├── indicators/            # 指示器组件
│   │   └── displays/              # 显示组件
│   ├── molecules/                 # 分子组件
│   │   ├── cards/                 # 卡片组件
│   │   ├── forms/                 # 表单组件
│   │   └── navigation/            # 导航组件
│   ├── organisms/                 # 有机体组件
│   │   ├── app_bars/              # 应用栏
│   │   ├── bottom_sheets/         # 底部面板
│   │   └── dialogs/               # 对话框
│   └── templates/                 # 页面模板
│       ├── auth_template.dart     # 认证页面模板
│       ├── main_template.dart     # 主页面模板
│       └── detail_template.dart   # 详情页面模板
└── features/                      # 业务功能
    ├── auth/                      # 认证模块
    ├── nutrition/                 # 营养模块
    ├── restaurants/               # 餐厅模块
    └── orders/                    # 订单模块
```

---

## 2. 技术栈与规范

### 2.1 核心技术栈

```yaml
Flutter SDK: 3.24.3
Dart: 3.5.3

核心依赖:
  - riverpod: ^3.0.9              # 状态管理
  - flutter_riverpod: ^3.0.9     # Riverpod Flutter集成
  - riverpod_annotation: ^2.6.1  # Riverpod代码生成
  - go_router: ^14.6.2            # 路由管理
  - dio: ^5.7.0                   # HTTP客户端
  - freezed: ^2.5.2               # 数据类生成
  - json_annotation: ^4.9.0      # JSON序列化注解
  - cached_network_image: ^3.4.1  # 图片缓存

UI和动画:
  - material_design_icons_flutter: ^7.0.7  # Material图标
  - lottie: ^3.1.3                         # Lottie动画
  - shimmer: ^3.0.0                        # 加载动画
  - flutter_staggered_animations: ^1.1.1   # 交错动画

开发工具:
  - flutter_screenutil: ^5.9.3    # 屏幕适配
  - easy_localization: ^3.0.7     # 国际化
  - logger: ^2.4.0                # 日志记录
  - build_runner: ^2.4.13         # 代码生成工具
  - freezed_annotation: ^2.4.4    # Freezed注解
  - json_serializable: ^6.8.0     # JSON序列化生成器
```

### 2.2 代码规范

```dart
// 组件命名规范
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = AppButtonSize.medium,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: _getButtonStyle(context),
      child: isLoading ? _buildLoadingIndicator() : child,
    );
  }
}

// 文件命名规范
// app_primary_button.dart
// nutrition_card.dart
// order_status_indicator.dart

// 常量定义规范
class AppSizes {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
```

---

## 3. 主题配置

### 3.1 品牌标识系统

#### 3.1.1 Logo设计规范

```dart
// lib/core/assets/logo_assets.dart
class LogoAssets {
  // 3D立方体Logo资源
  static const String logo3DCube = 'assets/images/logo_3d_cube.svg';
  static const String logoIcon = 'assets/images/logo_icon.svg';
  static const String logoText = 'assets/images/logo_text.svg';
  static const String logoFull = 'assets/images/logo_full.svg';

  // 品牌名称
  static const String brandName = '营养立方';
  static const String brandNameEn = 'Nutrition Cube';
  static const String brandSlogan = 'AI智能营养管理专家';
}

// 3D立方体Logo组件
class NutritionCubeLogo extends StatefulWidget {
  final double size;
  final bool animated;
  final Color? primaryColor;
  final Color? secondaryColor;

  const NutritionCubeLogo({
    Key? key,
    this.size = 64.0,
    this.animated = true,
    this.primaryColor,
    this.secondaryColor,
  }) : super(key: key);
}

// Logo设计规范
/*
3D立方体设计要素：
- 立方体由6个面组成，体现营养的全面性
- 使用橙绿渐变色彩，体现活力与健康
- 旋转动画体现动态营养管理
- 可缩放适配不同尺寸需求
- 支持单色版本用于特殊场景
*/
```

### 3.2 颜色系统

```dart
// lib/core/theme/color_schemes.dart
import 'package:flutter/material.dart';

class AppColors {
  // 主色调 - 营养橙色 (活力、食欲、温暖)
  static const Color primarySeed = Color(0xFFFF6B35);
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFFF6B35,
    <int, Color>{
      50: Color(0xFFFFF3F0),
      100: Color(0xFFFFE0D6),
      200: Color(0xFFFFBFA8),
      300: Color(0xFFFF9E7A),
      400: Color(0xFFFF8257),
      500: Color(0xFFFF6B35),
      600: Color(0xFFE85A2F),
      700: Color(0xFFCC4A28),
      800: Color(0xFFB03A22),
      900: Color(0xFF942A1C),
    },
  );

  // 辅助色调 - 健康绿色 (营养、自然、平衡)
  static const Color secondarySeed = Color(0xFF4CAF50);
  static const MaterialColor secondarySwatch = MaterialColor(
    0xFF4CAF50,
    <int, Color>{
      50: Color(0xFFE8F5E8),
      100: Color(0xFFC8E6C9),
      200: Color(0xFFA5D6A7),
      300: Color(0xFF81C784),
      400: Color(0xFF66BB6A),
      500: Color(0xFF4CAF50),
      600: Color(0xFF43A047),
      700: Color(0xFF388E3C),
      800: Color(0xFF2E7D32),
      900: Color(0xFF1B5E20),
    },
  );

  // 次要色 - 智能蓝色
  static const Color secondarySeed = Color(0xFF2196F3);
  static const MaterialColor secondarySwatch = MaterialColor(
    0xFF2196F3,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  // 功能色
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // 中性色
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // 品牌渐变色 - 橙绿渐变体现营养活力
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B35), // 营养橙
      Color(0xFF4CAF50), // 健康绿
    ],
    stops: [0.0, 1.0],
  );

  // 启动页渐变 - 更柔和的橙绿渐变
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFF8A65), // 浅橙
      Color(0xFF66BB6A), // 浅绿
    ],
    stops: [0.3, 0.9],
  );

  // 语义化色彩系统
  static const Color success = Color(0xFF4CAF50);        // 成功-绿色
  static const Color warning = Color(0xFFFF9800);        // 警告-橙色
  static const Color error = Color(0xFFF44336);          // 错误-红色
  static const Color info = Color(0xFF2196F3);           // 信息-蓝色

  // 营养主题色
  static const Color proteinColor = Color(0xFFE91E63);   // 蛋白质-红色
  static const Color carbsColor = Color(0xFFFFC107);     // 碳水化合物-黄色
  static const Color fatColor = Color(0xFF9C27B0);       // 脂肪-紫色
  static const Color fiberColor = Color(0xFF795548);     // 纤维-棕色
  static const Color vitaminColor = Color(0xFFFF5722);   // 维生素-橙色

  // 中性色系
  static const Color textPrimary = Color(0xFF212121);    // 主要文字
  static const Color textSecondary = Color(0xFF757575);  // 次要文字
  static const Color textHint = Color(0xFF9E9E9E);       // 提示文字
  static const Color divider = Color(0xFFE0E0E0);        // 分割线
  static const Color background = Color(0xFFFAFAFA);     // 背景色
  static const Color surface = Color(0xFFFFFFFF);        // 表面色

  // 深色模式色彩
  static const Color darkBackground = Color(0xFF121212); // 深色背景
  static const Color darkSurface = Color(0xFF1E1E1E);    // 深色表面
  static const Color darkTextPrimary = Color(0xFFFFFFFF);// 深色主文字
  static const Color darkTextSecondary = Color(0xFFB3B3B3); // 深色次文字
}

// ColorScheme配置 - 橙绿双色主题
ColorScheme lightColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primarySeed, // 营养橙作为主色
  brightness: Brightness.light,
  secondary: AppColors.secondarySeed, // 健康绿作为辅助色
);

ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primarySeed,
  brightness: Brightness.dark,
  secondary: AppColors.secondarySeed,
);
```

### 3.2 文字主题

```dart
// lib/core/theme/text_themes.dart
import 'package:flutter/material.dart';

class AppTextThemes {
  static TextTheme lightTextTheme = const TextTheme(
    // 显示类文字
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),

    // 标题类文字
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.33,
    ),

    // 标题类文字
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),

    // 标签和正文
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),

    // 正文文字
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.50,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
  );

  // 营养相关的自定义文字样式
  static const TextStyle nutritionLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle calorieTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );

  static const TextStyle macroNutrientStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );
}
```

### 3.3 主题配置

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: AppTextThemes.lightTextTheme,
    
    // 应用栏主题
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 1,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),

    // 卡片主题
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // 按钮主题
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    ),

    // 输入框主题
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),

    // 底部导航栏主题
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedItemColor: AppColors.primarySwatch,
      unselectedItemColor: AppColors.neutral500,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: AppTextThemes.lightTextTheme,
    // ... 其他暗色主题配置
  );
}
```

---

## 4. 基础组件库

### 4.1 按钮组件

```dart
// lib/widgets/atoms/buttons/app_button.dart
import 'package:flutter/material.dart';

enum AppButtonSize { small, medium, large }
enum AppButtonVariant { filled, outlined, text }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.fullWidth = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final Widget? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isInteractive = isEnabled && !isLoading && onPressed != null;

    Widget button = switch (variant) {
      AppButtonVariant.filled => FilledButton(
          onPressed: isInteractive ? onPressed : null,
          style: _getFilledButtonStyle(theme),
          child: _buildButtonChild(),
        ),
      AppButtonVariant.outlined => OutlinedButton(
          onPressed: isInteractive ? onPressed : null,
          style: _getOutlinedButtonStyle(theme),
          child: _buildButtonChild(),
        ),
      AppButtonVariant.text => TextButton(
          onPressed: isInteractive ? onPressed : null,
          style: _getTextButtonStyle(theme),
          child: _buildButtonChild(),
        ),
    };

    if (fullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          child,
        ],
      );
    }

    return child;
  }

  ButtonStyle _getFilledButtonStyle(ThemeData theme) {
    return FilledButton.styleFrom(
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: _getTextStyle(theme),
    );
  }

  ButtonStyle _getOutlinedButtonStyle(ThemeData theme) {
    return OutlinedButton.styleFrom(
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: _getTextStyle(theme),
    );
  }

  ButtonStyle _getTextButtonStyle(ThemeData theme) {
    return TextButton.styleFrom(
      padding: _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: _getTextStyle(theme),
    );
  }

  EdgeInsets _getPadding() {
    return switch (size) {
      AppButtonSize.small => const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      AppButtonSize.medium => const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      AppButtonSize.large => const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
    };
  }

  TextStyle _getTextStyle(ThemeData theme) {
    return switch (size) {
      AppButtonSize.small => theme.textTheme.labelMedium!,
      AppButtonSize.medium => theme.textTheme.labelLarge!,
      AppButtonSize.large => theme.textTheme.titleMedium!,
    };
  }

  double _getIconSize() {
    return switch (size) {
      AppButtonSize.small => 16,
      AppButtonSize.medium => 18,
      AppButtonSize.large => 20,
    };
  }
}

// 快捷构造器
class AppPrimaryButton extends AppButton {
  const AppPrimaryButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.size,
    super.isLoading,
    super.isEnabled,
    super.icon,
    super.fullWidth,
  }) : super(variant: AppButtonVariant.filled);
}

class AppSecondaryButton extends AppButton {
  const AppSecondaryButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.size,
    super.isLoading,
    super.isEnabled,
    super.icon,
    super.fullWidth,
  }) : super(variant: AppButtonVariant.outlined);
}
```

### 4.2 输入框组件

```dart
// lib/widgets/atoms/inputs/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppTextFieldType { text, email, phone, password, number }

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.type = AppTextFieldType.text,
    this.isRequired = false,
    this.isEnabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
  });

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final AppTextFieldType type;
  final bool isRequired;
  final bool isEnabled;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = true;
  late final bool _isPasswordField;

  @override
  void initState() {
    super.initState();
    _isPasswordField = widget.type == AppTextFieldType.password;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: _getKeyboardType(),
      textInputAction: _getTextInputAction(),
      obscureText: _isPasswordField && _isObscured,
      enabled: widget.isEnabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
      decoration: InputDecoration(
        labelText: _getLabelText(),
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffixIcon(),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  String? _getLabelText() {
    if (widget.labelText == null) return null;
    return widget.isRequired ? '${widget.labelText} *' : widget.labelText;
  }

  Widget? _buildSuffixIcon() {
    if (_isPasswordField) {
      return IconButton(
        icon: Icon(
          _isObscured ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () => setState(() => _isObscured = !_isObscured),
      );
    }
    return widget.suffixIcon;
  }

  TextInputType _getKeyboardType() {
    return switch (widget.type) {
      AppTextFieldType.email => TextInputType.emailAddress,
      AppTextFieldType.phone => TextInputType.phone,
      AppTextFieldType.number => TextInputType.number,
      _ => TextInputType.text,
    };
  }

  TextInputAction _getTextInputAction() {
    return widget.maxLines == 1 ? TextInputAction.next : TextInputAction.newline;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    return switch (widget.type) {
      AppTextFieldType.phone => [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
      AppTextFieldType.number => [
          FilteringTextInputFormatter.digitsOnly,
        ],
      _ => null,
    };
  }
}
```

### 4.3 卡片组件

```dart
// lib/widgets/atoms/displays/app_card.dart
import 'package:flutter/material.dart';

enum AppCardVariant { elevated, outlined, filled }

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.elevated,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
  });

  final Widget child;
  final AppCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(12);
    final defaultPadding = padding ?? const EdgeInsets.all(16);

    Widget card = switch (variant) {
      AppCardVariant.elevated => Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
          child: Padding(padding: defaultPadding, child: child),
        ),
      AppCardVariant.outlined => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: defaultBorderRadius,
            side: BorderSide(color: theme.colorScheme.outline),
          ),
          child: Padding(padding: defaultPadding, child: child),
        ),
      AppCardVariant.filled => Card(
          elevation: 0,
          color: theme.colorScheme.surfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
          child: Padding(padding: defaultPadding, child: child),
        ),
    };

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: defaultBorderRadius,
        child: card,
      );
    }

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}
```

### 4.4 加载指示器

```dart
// lib/widgets/atoms/indicators/app_loading_indicator.dart
import 'package:flutter/material.dart';

enum AppLoadingSize { small, medium, large }

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = AppLoadingSize.medium,
    this.color,
    this.message,
  });

  final AppLoadingSize size;
  final Color? color;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;

    final indicator = SizedBox(
      height: _getSize(),
      width: _getSize(),
      child: CircularProgressIndicator(
        color: indicatorColor,
        strokeWidth: _getStrokeWidth(),
      ),
    );

    if (message == null) return indicator;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(height: 16),
        Text(
          message!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  double _getSize() {
    return switch (size) {
      AppLoadingSize.small => 16,
      AppLoadingSize.medium => 24,
      AppLoadingSize.large => 32,
    };
  }

  double _getStrokeWidth() {
    return switch (size) {
      AppLoadingSize.small => 2,
      AppLoadingSize.medium => 3,
      AppLoadingSize.large => 4,
    };
  }
}

// 页面级加载覆盖
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  final bool isLoading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(
              child: AppLoadingIndicator(
                size: AppLoadingSize.large,
                message: message,
              ),
            ),
          ),
      ],
    );
  }
}
```

---

## 5. 复合组件库

### 5.1 营养卡片组件

```dart
// lib/widgets/molecules/cards/nutrition_card.dart
import 'package:flutter/material.dart';

class NutritionData {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;

  const NutritionData({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
  });
}

class NutritionCard extends StatelessWidget {
  const NutritionCard({
    super.key,
    required this.nutrition,
    this.title,
    this.subtitle,
    this.onTap,
  });

  final NutritionData nutrition;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 16),
          ],
          
          // 卡路里显示
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${nutrition.calories.toInt()} 千卡',
                  style: AppTextThemes.calorieTextStyle.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 营养素分布
          Row(
            children: [
              Expanded(
                child: _buildNutrientItem(
                  context,
                  label: '蛋白质',
                  value: nutrition.protein,
                  unit: 'g',
                  color: AppColors.proteinColor,
                ),
              ),
              Expanded(
                child: _buildNutrientItem(
                  context,
                  label: '碳水',
                  value: nutrition.carbs,
                  unit: 'g',
                  color: AppColors.carbsColor,
                ),
              ),
              Expanded(
                child: _buildNutrientItem(
                  context,
                  label: '脂肪',
                  value: nutrition.fat,
                  unit: 'g',
                  color: AppColors.fatColor,
                ),
              ),
              Expanded(
                child: _buildNutrientItem(
                  context,
                  label: '纤维',
                  value: nutrition.fiber,
                  unit: 'g',
                  color: AppColors.fiberColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientItem(
    BuildContext context, {
    required String label,
    required double value,
    required String unit,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Container(
          width: 8,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${value.toInt()}$unit',
          style: AppTextThemes.macroNutrientStyle.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
```

### 5.2 菜品卡片组件

```dart
// lib/widgets/molecules/cards/menu_item_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MenuItemData {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final NutritionData nutrition;
  final List<String> tags;
  final bool isAvailable;

  const MenuItemData({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.nutrition,
    this.tags = const [],
    this.isAvailable = true,
  });
}

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onAddToCart,
  });

  final MenuItemData item;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 菜品图片
          if (item.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: const Center(
                      child: AppLoadingIndicator(size: AppLoadingSize.small),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.restaurant,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 12),
          
          // 菜品信息
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '¥${item.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (onAddToCart != null)
                    AppButton(
                      onPressed: item.isAvailable ? onAddToCart : null,
                      variant: AppButtonVariant.filled,
                      size: AppButtonSize.small,
                      child: const Text('加入购物车'),
                    ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // 营养信息简要显示
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${item.nutrition.calories.toInt()}千卡',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.fitness_center,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '蛋白质${item.nutrition.protein.toInt()}g',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          
          // 标签
          if (item.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: item.tags.map((tag) => _buildTag(context, tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
          fontSize: 10,
        ),
      ),
    );
  }
}
```

### 5.3 订单状态组件

```dart
// lib/widgets/molecules/displays/order_status_indicator.dart
import 'package:flutter/material.dart';

enum OrderStatus {
  pending,    // 待支付
  confirmed,  // 已确认
  preparing,  // 制作中
  ready,      // 已完成
  delivering, // 配送中
  completed,  // 已送达
  cancelled,  // 已取消
}

class OrderStatusIndicator extends StatelessWidget {
  const OrderStatusIndicator({
    super.key,
    required this.status,
    this.showLabel = true,
  });

  final OrderStatus status;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusInfo = _getStatusInfo(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusInfo.color,
            shape: BoxShape.circle,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            statusInfo.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusInfo.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  ({String label, Color color}) _getStatusInfo(BuildContext context) {
    final theme = Theme.of(context);
    
    return switch (status) {
      OrderStatus.pending => (
          label: '待支付',
          color: theme.colorScheme.outline,
        ),
      OrderStatus.confirmed => (
          label: '已确认',
          color: AppColors.infoColor,
        ),
      OrderStatus.preparing => (
          label: '制作中',
          color: AppColors.warningColor,
        ),
      OrderStatus.ready => (
          label: '已完成',
          color: AppColors.successColor,
        ),
      OrderStatus.delivering => (
          label: '配送中',
          color: AppColors.secondarySwatch[600]!,
        ),
      OrderStatus.completed => (
          label: '已送达',
          color: AppColors.successColor,
        ),
      OrderStatus.cancelled => (
          label: '已取消',
          color: AppColors.errorColor,
        ),
    };
  }
}
```

---

## 6. 业务组件库

### 6.1 用户档案表单

```dart
// lib/widgets/organisms/forms/nutrition_profile_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActivityLevel { sedentary, light, moderate, active, veryActive }
enum HealthGoal { weightLoss, weightGain, maintainWeight, muscleGain, generalHealth }

class NutritionProfileFormData {
  final double? height;
  final double? weight;
  final int? age;
  final String? gender;
  final ActivityLevel? activityLevel;
  final HealthGoal? healthGoal;
  final List<String> allergies;
  final List<String> dietaryRestrictions;

  const NutritionProfileFormData({
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.activityLevel,
    this.healthGoal,
    this.allergies = const [],
    this.dietaryRestrictions = const [],
  });

  NutritionProfileFormData copyWith({
    double? height,
    double? weight,
    int? age,
    String? gender,
    ActivityLevel? activityLevel,
    HealthGoal? healthGoal,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
  }) {
    return NutritionProfileFormData(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      healthGoal: healthGoal ?? this.healthGoal,
      allergies: allergies ?? this.allergies,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
    );
  }
}

class NutritionProfileForm extends ConsumerStatefulWidget {
  const NutritionProfileForm({
    super.key,
    this.initialData,
    this.onDataChanged,
    this.onSubmit,
  });

  final NutritionProfileFormData? initialData;
  final ValueChanged<NutritionProfileFormData>? onDataChanged;
  final ValueChanged<NutritionProfileFormData>? onSubmit;

  @override
  ConsumerState<NutritionProfileForm> createState() => _NutritionProfileFormState();
}

class _NutritionProfileFormState extends ConsumerState<NutritionProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _ageController;
  
  late NutritionProfileFormData _formData;

  @override
  void initState() {
    super.initState();
    _formData = widget.initialData ?? const NutritionProfileFormData();
    
    _heightController = TextEditingController(
      text: _formData.height?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: _formData.weight?.toString() ?? '',
    );
    _ageController = TextEditingController(
      text: _formData.age?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBasicInfoSection(),
          const SizedBox(height: 24),
          _buildActivitySection(),
          const SizedBox(height: 24),
          _buildGoalSection(),
          const SizedBox(height: 24),
          _buildRestrictionsSection(),
          const SizedBox(height: 32),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    final theme = Theme.of(context);
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '基础信息',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _heightController,
                  labelText: '身高',
                  hintText: '请输入身高(cm)',
                  type: AppTextFieldType.number,
                  isRequired: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return '请输入身高';
                    final height = double.tryParse(value!);
                    if (height == null || height < 100 || height > 250) {
                      return '请输入有效身高(100-250cm)';
                    }
                    return null;
                  },
                  onChanged: (value) => _updateFormData(
                    height: double.tryParse(value),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppTextField(
                  controller: _weightController,
                  labelText: '体重',
                  hintText: '请输入体重(kg)',
                  type: AppTextFieldType.number,
                  isRequired: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return '请输入体重';
                    final weight = double.tryParse(value!);
                    if (weight == null || weight < 30 || weight > 300) {
                      return '请输入有效体重(30-300kg)';
                    }
                    return null;
                  },
                  onChanged: (value) => _updateFormData(
                    weight: double.tryParse(value),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _ageController,
                  labelText: '年龄',
                  hintText: '请输入年龄',
                  type: AppTextFieldType.number,
                  isRequired: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return '请输入年龄';
                    final age = int.tryParse(value!);
                    if (age == null || age < 1 || age > 120) {
                      return '请输入有效年龄(1-120岁)';
                    }
                    return null;
                  },
                  onChanged: (value) => _updateFormData(
                    age: int.tryParse(value),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _formData.gender,
                  decoration: const InputDecoration(
                    labelText: '性别 *',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('男')),
                    DropdownMenuItem(value: 'female', child: Text('女')),
                    DropdownMenuItem(value: 'other', child: Text('其他')),
                  ],
                  onChanged: (value) => _updateFormData(gender: value),
                  validator: (value) => value == null ? '请选择性别' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivitySection() {
    final theme = Theme.of(context);
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '活动水平',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          ...ActivityLevel.values.map((level) {
            return RadioListTile<ActivityLevel>(
              title: Text(_getActivityLevelLabel(level)),
              subtitle: Text(_getActivityLevelDescription(level)),
              value: level,
              groupValue: _formData.activityLevel,
              onChanged: (value) => _updateFormData(activityLevel: value),
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGoalSection() {
    final theme = Theme.of(context);
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '健康目标',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          ...HealthGoal.values.map((goal) {
            return RadioListTile<HealthGoal>(
              title: Text(_getHealthGoalLabel(goal)),
              value: goal,
              groupValue: _formData.healthGoal,
              onChanged: (value) => _updateFormData(healthGoal: value),
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRestrictionsSection() {
    final theme = Theme.of(context);
    
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '饮食限制',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请选择您的过敏源和饮食限制（可选）',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          // 这里可以添加过敏源和饮食限制的多选组件
          // 为简化示例，暂时省略具体实现
          Text(
            '过敏源和饮食限制选择器（待实现）',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return AppPrimaryButton(
      onPressed: _submitForm,
      fullWidth: true,
      child: const Text('保存营养档案'),
    );
  }

  void _updateFormData({
    double? height,
    double? weight,
    int? age,
    String? gender,
    ActivityLevel? activityLevel,
    HealthGoal? healthGoal,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
  }) {
    setState(() {
      _formData = _formData.copyWith(
        height: height,
        weight: weight,
        age: age,
        gender: gender,
        activityLevel: activityLevel,
        healthGoal: healthGoal,
        allergies: allergies,
        dietaryRestrictions: dietaryRestrictions,
      );
    });
    
    widget.onDataChanged?.call(_formData);
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit?.call(_formData);
    }
  }

  String _getActivityLevelLabel(ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => '久坐',
      ActivityLevel.light => '轻度活动',
      ActivityLevel.moderate => '中度活动',
      ActivityLevel.active => '重度活动',
      ActivityLevel.veryActive => '极重度活动',
    };
  }

  String _getActivityLevelDescription(ActivityLevel level) {
    return switch (level) {
      ActivityLevel.sedentary => '很少运动，主要是办公室工作',
      ActivityLevel.light => '轻度运动，每周1-3次',
      ActivityLevel.moderate => '中度运动，每周3-5次',
      ActivityLevel.active => '重度运动，每周6-7次',
      ActivityLevel.veryActive => '极重度运动，每天2次或体力劳动',
    };
  }

  String _getHealthGoalLabel(HealthGoal goal) {
    return switch (goal) {
      HealthGoal.weightLoss => '减重',
      HealthGoal.weightGain => '增重',
      HealthGoal.maintainWeight => '维持体重',
      HealthGoal.muscleGain => '增肌',
      HealthGoal.generalHealth => '一般健康',
    };
  }
}
```

---

## 7. 页面模板

### 7.1 认证页面模板

```dart
// lib/widgets/templates/auth_template.dart
import 'package:flutter/material.dart';

class AuthTemplate extends StatelessWidget {
  const AuthTemplate({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.showBackButton = false,
    this.backgroundImage,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final bool showBackButton;
  final String? backgroundImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          decoration: backgroundImage != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(backgroundImage!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.surface.withOpacity(0.8),
                      BlendMode.overlay,
                    ),
                  ),
                )
              : null,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBackButton) ...[
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const SizedBox(height: 24),
                ],
                
                const SizedBox(height: 48),
                
                // Logo区域
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 40,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 标题
                Center(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // 内容区域
                child,
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### 7.2 主页面模板

```dart
// lib/widgets/templates/main_template.dart
import 'package:flutter/material.dart';

class MainTemplate extends StatelessWidget {
  const MainTemplate({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
    );
  }
}

// 带侧滑菜单的主页模板
class MainTemplateWithDrawer extends StatelessWidget {
  const MainTemplateWithDrawer({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onNavigationTap,
    this.appBar,
    this.floatingActionButton,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onNavigationTap;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onNavigationTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: '点餐',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: '营养',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: '订单',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
      ],
    );
  }
}
```

---

## 8. 状态管理集成

### 8.1 Riverpod Provider集成

```dart
// lib/core/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode { light, dark, system }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.system);

  void setThemeMode(AppThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == AppThemeMode.light 
        ? AppThemeMode.dark 
        : AppThemeMode.light;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>(
  (ref) => ThemeNotifier(),
);

final materialThemeModeProvider = Provider<ThemeMode>((ref) {
  final themeMode = ref.watch(themeProvider);
  return switch (themeMode) {
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
    AppThemeMode.system => ThemeMode.system,
  };
});
```

### 8.2 响应式状态组件

```dart
// lib/widgets/atoms/buttons/app_async_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppAsyncButton extends ConsumerWidget {
  const AppAsyncButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.fullWidth = false,
  });

  final Future<void> Function() onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      onPressed: () async {
        // 这里可以集成全局loading状态
        await onPressed();
      },
      variant: variant,
      size: size,
      fullWidth: fullWidth,
      child: child,
    );
  }
}
```

---

## 9. 响应式设计

### 9.1 断点定义

```dart
// lib/core/utils/responsive_utils.dart
import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobileBreakpoint) {
      return ScreenSize.mobile;
    } else if (width < tabletBreakpoint) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  static bool isMobile(BuildContext context) {
    return getScreenSize(context) == ScreenSize.mobile;
  }

  static bool isTablet(BuildContext context) {
    return getScreenSize(context) == ScreenSize.tablet;
  }

  static bool isDesktop(BuildContext context) {
    return getScreenSize(context) == ScreenSize.desktop;
  }

  static double getResponsiveWidth(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final screenSize = getScreenSize(context);
    return switch (screenSize) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet ?? mobile,
      ScreenSize.desktop => desktop ?? tablet ?? mobile,
    };
  }
}
```

### 9.2 响应式布局组件

```dart
// lib/widgets/atoms/layouts/responsive_layout.dart
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveUtils.getScreenSize(context);
    
    return switch (screenSize) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet ?? mobile,
      ScreenSize.desktop => desktop ?? tablet ?? mobile,
    };
  }
}

class ResponsiveGridView extends StatelessWidget {
  const ResponsiveGridView({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveUtils.getScreenSize(context);
    
    final columns = switch (screenSize) {
      ScreenSize.mobile => mobileColumns,
      ScreenSize.tablet => tabletColumns,
      ScreenSize.desktop => desktopColumns,
    };

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: 1,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
```

---

## 10. 动画与交互

### 10.1 预定义动画

```dart
// lib/core/constants/app_durations.dart
class AppDurations {
  static const Duration veryFast = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 700);
}

// lib/core/animations/app_animations.dart
import 'package:flutter/material.dart';

class AppAnimations {
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve bounceIn = Curves.bounceIn;

  // 淡入动画
  static Widget fadeIn({
    required Widget child,
    Duration duration = AppDurations.medium,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // 滑入动画
  static Widget slideIn({
    required Widget child,
    Duration duration = AppDurations.medium,
    Offset beginOffset = const Offset(0, 1),
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: beginOffset, end: Offset.zero),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: value,
          child: child,
        );
      },
      child: child,
    );
  }

  // 缩放动画
  static Widget scaleIn({
    required Widget child,
    Duration duration = AppDurations.medium,
    double beginScale = 0.0,
    Curve curve = defaultCurve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: beginScale, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
}
```

### 10.2 交互反馈组件

```dart
// lib/widgets/atoms/interactive/app_inkwell.dart
import 'package:flutter/material.dart';

class AppInkWell extends StatelessWidget {
  const AppInkWell({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.splashColor,
    this.highlightColor,
    this.hoverColor,
  });

  final Widget child;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? hoverColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        splashColor: splashColor ?? theme.colorScheme.primary.withOpacity(0.1),
        highlightColor: highlightColor ?? theme.colorScheme.primary.withOpacity(0.05),
        hoverColor: hoverColor ?? theme.colorScheme.primary.withOpacity(0.05),
        child: child,
      ),
    );
  }
}
```

---

## 11. 无障碍设计

### 11.1 语义化标签

```dart
// lib/core/utils/accessibility_utils.dart
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  static Widget addSemanticLabel({
    required Widget child,
    required String label,
    String? hint,
    bool? isButton,
    bool? isSelected,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton ?? false,
      selected: isSelected ?? false,
      child: child,
    );
  }

  static Widget excludeSemantics({required Widget child}) {
    return ExcludeSemantics(child: child);
  }

  static Widget mergeSemantics({required Widget child}) {
    return MergeSemantics(child: child);
  }
}
```

### 11.2 无障碍组件封装

```dart
// lib/widgets/atoms/accessibility/accessible_button.dart
import 'package:flutter/material.dart';

class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.semanticLabel,
    this.semanticHint,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final String semanticLabel;
  final String? semanticHint;
  final AppButtonVariant variant;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      button: true,
      enabled: onPressed != null,
      child: AppButton(
        onPressed: onPressed,
        variant: variant,
        size: size,
        child: child,
      ),
    );
  }
}
```

---

## 12. 组件文档和示例

### 12.1 Storybook风格的组件展示

```dart
// lib/storybook/component_showcase.dart
import 'package:flutter/material.dart';

class ComponentShowcase extends StatelessWidget {
  const ComponentShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('组件展示')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('按钮组件', _buildButtonExamples()),
          _buildSection('卡片组件', _buildCardExamples()),
          _buildSection('表单组件', _buildFormExamples()),
          _buildSection('营养组件', _buildNutritionExamples()),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildButtonExamples() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AppPrimaryButton(
                onPressed: () {},
                child: const Text('主要按钮'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppSecondaryButton(
                onPressed: () {},
                child: const Text('次要按钮'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () {},
                variant: AppButtonVariant.text,
                child: const Text('文本按钮'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                onPressed: null,
                child: const Text('禁用按钮'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardExamples() {
    return Column(
      children: [
        AppCard(
          child: const Text('基础卡片'),
        ),
        const SizedBox(height: 16),
        AppCard(
          variant: AppCardVariant.outlined,
          child: const Text('边框卡片'),
        ),
      ],
    );
  }

  Widget _buildFormExamples() {
    return Column(
      children: [
        AppTextField(
          labelText: '用户名',
          hintText: '请输入用户名',
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: '密码',
          type: AppTextFieldType.password,
          isRequired: true,
        ),
      ],
    );
  }

  Widget _buildNutritionExamples() {
    const sampleNutrition = NutritionData(
      calories: 450,
      protein: 25,
      carbs: 60,
      fat: 12,
      fiber: 8,
    );

    return NutritionCard(
      nutrition: sampleNutrition,
      title: '营养成分示例',
      subtitle: '今日推荐',
    );
  }
}
```

### 12.2 组件使用文档

```yaml
# 组件使用指南

## 按钮组件使用
用途: 触发用户操作的交互元素
变体: filled(填充), outlined(边框), text(文本)
尺寸: small, medium, large
状态: enabled, disabled, loading

示例:
```dart
AppPrimaryButton(
  onPressed: () => print('按钮点击'),
  child: Text('确认'),
)
```

## 输入框组件使用
用途: 用户输入文本信息
类型: text, email, phone, password, number
状态: normal, error, success, disabled
验证: 支持自定义验证规则

示例:
```dart
AppTextField(
  labelText: '手机号',
  type: AppTextFieldType.phone,
  isRequired: true,
  validator: (value) => value?.isEmpty == true ? '请输入手机号' : null,
)
```

## 营养卡片使用
用途: 展示营养信息
数据: 卡路里、蛋白质、碳水、脂肪、纤维
样式: 统一的营养主题色彩
交互: 支持点击查看详情

示例:
```dart
NutritionCard(
  nutrition: NutritionData(
    calories: 450,
    protein: 25,
    carbs: 60,
    fat: 12,
    fiber: 8,
  ),
  title: '今日营养摄入',
  onTap: () => Navigator.push(...),
)
```
```

---

## 总结

这套Flutter UI组件设计系统基于以下核心特性：

1. **Material Design 3兼容**: 完全遵循最新的Material Design规范
2. **MVP优先**: 组件设计聚焦核心功能，支持渐进式增强
3. **营养主题**: 针对营养健康应用的专门设计
4. **高度可复用**: 原子化设计，组件可灵活组合
5. **类型安全**: 充分利用Dart的类型系统
6. **响应式设计**: 适配不同屏幕尺寸
7. **无障碍友好**: 支持屏幕阅读器和其他辅助技术
8. **性能优化**: 组件轻量且高效

该设计系统为AI智能营养餐厅系统提供了完整的UI基础，支持快速开发和一致的用户体验。