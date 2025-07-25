# AI智能营养餐厅系统 - 统一UI设计系统

> **文档版本**: 3.0.0  
> **创建日期**: 2025-07-23  
> **文档状态**: ✅ 设计系统统一完成  
> **目标受众**: 前端开发团队、UI/UX设计师、AI编码工具

## 📋 目录

- [1. 设计系统概述](#1-设计系统概述)
- [2. 统一色彩系统](#2-统一色彩系统)
- [3. 统一字体系统](#3-统一字体系统)
- [4. 统一组件规范](#4-统一组件规范)
- [5. 命名规范统一](#5-命名规范统一)
- [6. 跨端一致性](#6-跨端一致性)
- [7. 设计令牌](#7-设计令牌)
- [8. 实施指南](#8-实施指南)

---

## 1. 设计系统概述

### 1.1 统一设计原则

```yaml
核心价值:
  - 健康: 传达健康生活理念
  - 智能: 体现AI科技特色
  - 温暖: 营造温馨用餐体验
  - 专业: 展现专业营养服务

统一原则:
  - 跨端一致: Flutter移动端与React Web端保持一致
  - 单一真相源: 所有设计规范来源于此文档
  - 原子化设计: 基于原子设计方法论
  - 响应式优先: 所有组件支持响应式设计
  - 无障碍优先: 符合WCAG 2.1 AA级标准

技术实现:
  - 移动端: Flutter + Material 3
  - Web端: React + CSS Custom Properties
  - 设计工具: Figma统一设计系统
  - 文档工具: Storybook组件文档
```

### 1.2 设计系统架构

```
设计系统统一架构
├── 设计令牌 (Design Tokens)
│   ├── 色彩令牌 (Color Tokens)
│   ├── 尺寸令牌 (Size Tokens)
│   ├── 字体令牌 (Typography Tokens)
│   └── 动效令牌 (Motion Tokens)
├── 基础层 (Foundation)
│   ├── 色彩系统 (Colors)
│   ├── 字体系统 (Typography)
│   ├── 间距系统 (Spacing)
│   ├── 圆角系统 (Border Radius)
│   ├── 阴影系统 (Shadows)
│   └── 图标系统 (Icons)
├── 组件层 (Components)
│   ├── 原子组件 (Atoms)
│   ├── 分子组件 (Molecules)
│   └── 有机体组件 (Organisms)
├── 模式层 (Patterns)
│   ├── 布局模式 (Layout Patterns)
│   ├── 导航模式 (Navigation Patterns)
│   ├── 表单模式 (Form Patterns)
│   └── 数据展示模式 (Data Display Patterns)
└── 页面层 (Templates)
    ├── 移动端模板 (Mobile Templates)
    ├── Web端模板 (Web Templates)
    └── 响应式模板 (Responsive Templates)
```

---

## 2. 统一色彩系统

### 2.1 主色彩定义

```yaml
# 统一色彩规范 - 所有平台使用相同的色值

主品牌色:
  primary:
    name: "健康绿"
    hex: "#4CAF50"
    rgb: "76, 175, 80"
    hsl: "122, 39%, 49%"
    usage: "主要按钮、导航栏、品牌标识"

  secondary:
    name: "科技蓝"
    hex: "#2196F3"
    rgb: "33, 150, 243"
    hsl: "207, 90%, 54%"
    usage: "次要按钮、链接、辅助操作"

  tertiary:
    name: "活力橙"
    hex: "#FF9800"
    rgb: "255, 152, 0"
    hsl: "36, 100%, 50%"
    usage: "强调内容、促销信息、警告提示"

功能色彩:
  success:
    name: "成功绿"
    hex: "#4CAF50"
    usage: "成功状态、确认操作"

  warning:
    name: "警告橙"
    hex: "#FF9800"
    usage: "警告信息、注意事项"

  error:
    name: "错误红"
    hex: "#F44336"
    usage: "错误信息、危险操作"

  info:
    name: "信息蓝"
    hex: "#2196F3"
    usage: "提示信息、帮助内容"

中性色彩:
  neutral:
    50: "#FAFAFA"   # 背景色
    100: "#F5F5F5"  # 卡片背景
    200: "#EEEEEE"  # 分割线
    300: "#E0E0E0"  # 禁用边框
    400: "#BDBDBD"  # 禁用文字
    500: "#9E9E9E"  # 辅助文字
    600: "#757575"  # 次要文字
    700: "#616161"  # 主要文字
    800: "#424242"  # 标题文字
    900: "#212121"  # 重要标题
```

### 2.2 Flutter色彩实现

```dart
// lib/core/theme/app_colors.dart
class AppColors {
  AppColors._();

  // 主品牌色
  static const Color primary = Color(0xFF4CAF50);
  static const Color secondary = Color(0xFF2196F3);
  static const Color tertiary = Color(0xFFFF9800);

  // 主色调变体
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF1976D2);
  static const Color tertiaryLight = Color(0xFFFFB74D);
  static const Color tertiaryDark = Color(0xFFF57C00);

  // 功能色彩
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // 中性色彩
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

  // 语义化颜色别名
  static const Color surface = neutral50;
  static const Color surfaceVariant = neutral100;
  static const Color outline = neutral300;
  static const Color onSurface = neutral800;
  static const Color onSurfaceVariant = neutral600;
}

// 主题配置
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      tertiary: AppColors.tertiaryLight,
      surface: AppColors.neutral800,
      onSurface: AppColors.neutral100,
      error: AppColors.error,
      onError: Colors.white,
    ),
  );
}
```

### 2.3 React色彩实现

```css
/* styles/tokens/colors.css */
:root {
  /* 主品牌色 */
  --color-primary: #4CAF50;
  --color-secondary: #2196F3;
  --color-tertiary: #FF9800;

  /* 主色调变体 */
  --color-primary-light: #81C784;
  --color-primary-dark: #388E3C;
  --color-secondary-light: #64B5F6;
  --color-secondary-dark: #1976D2;
  --color-tertiary-light: #FFB74D;
  --color-tertiary-dark: #F57C00;

  /* 功能色彩 */
  --color-success: #4CAF50;
  --color-warning: #FF9800;
  --color-error: #F44336;
  --color-info: #2196F3;

  /* 中性色彩 */
  --color-neutral-50: #FAFAFA;
  --color-neutral-100: #F5F5F5;
  --color-neutral-200: #EEEEEE;
  --color-neutral-300: #E0E0E0;
  --color-neutral-400: #BDBDBD;
  --color-neutral-500: #9E9E9E;
  --color-neutral-600: #757575;
  --color-neutral-700: #616161;
  --color-neutral-800: #424242;
  --color-neutral-900: #212121;

  /* 语义化颜色别名 */
  --color-surface: var(--color-neutral-50);
  --color-surface-variant: var(--color-neutral-100);
  --color-outline: var(--color-neutral-300);
  --color-on-surface: var(--color-neutral-800);
  --color-on-surface-variant: var(--color-neutral-600);
}

/* 暗色主题 */
[data-theme="dark"] {
  --color-primary: #81C784;
  --color-secondary: #64B5F6;
  --color-tertiary: #FFB74D;
  --color-surface: var(--color-neutral-800);
  --color-on-surface: var(--color-neutral-100);
}

/* 色彩工具类 */
.text-primary { color: var(--color-primary); }
.text-secondary { color: var(--color-secondary); }
.text-tertiary { color: var(--color-tertiary); }
.text-success { color: var(--color-success); }
.text-warning { color: var(--color-warning); }
.text-error { color: var(--color-error); }
.text-info { color: var(--color-info); }

.bg-primary { background-color: var(--color-primary); }
.bg-secondary { background-color: var(--color-secondary); }
.bg-surface { background-color: var(--color-surface); }
.bg-surface-variant { background-color: var(--color-surface-variant); }

.border-outline { border-color: var(--color-outline); }
.border-primary { border-color: var(--color-primary); }
```

---

## 3. 统一字体系统

### 3.1 字体规范

```yaml
主要字体:
  中文: "PingFang SC", "Microsoft YaHei", "Helvetica Neue", sans-serif
  英文: "San Francisco", "Roboto", "Helvetica Neue", Arial, sans-serif
  数字: "SF Mono", "Consolas", "Monaco", monospace

字体层级:
  display-large:
    size: 57px / 3.56rem
    weight: 400
    line-height: 64px / 4rem
    usage: 大标题、品牌标语

  display-medium:
    size: 45px / 2.81rem
    weight: 400
    line-height: 52px / 3.25rem
    usage: 页面主标题

  display-small:
    size: 36px / 2.25rem
    weight: 400
    line-height: 44px / 2.75rem
    usage: 卡片标题

  headline-large:
    size: 32px / 2rem
    weight: 500
    line-height: 40px / 2.5rem
    usage: 区块标题

  headline-medium:
    size: 28px / 1.75rem
    weight: 500
    line-height: 36px / 2.25rem
    usage: 列表标题

  headline-small:
    size: 24px / 1.5rem
    weight: 500
    line-height: 32px / 2rem
    usage: 卡片子标题

  title-large:
    size: 22px / 1.375rem
    weight: 600
    line-height: 28px / 1.75rem
    usage: 重要标题

  title-medium:
    size: 16px / 1rem
    weight: 600
    line-height: 24px / 1.5rem
    usage: 表单标签

  title-small:
    size: 14px / 0.875rem
    weight: 600
    line-height: 20px / 1.25rem
    usage: 按钮文字

  label-large:
    size: 14px / 0.875rem
    weight: 500
    line-height: 20px / 1.25rem
    usage: 输入框标签

  label-medium:
    size: 12px / 0.75rem
    weight: 500
    line-height: 16px / 1rem
    usage: 辅助标签

  label-small:
    size: 11px / 0.688rem
    weight: 500
    line-height: 16px / 1rem
    usage: 说明文字

  body-large:
    size: 16px / 1rem
    weight: 400
    line-height: 24px / 1.5rem
    usage: 正文内容

  body-medium:
    size: 14px / 0.875rem
    weight: 400
    line-height: 20px / 1.25rem
    usage: 次要内容

  body-small:
    size: 12px / 0.75rem
    weight: 400
    line-height: 16px / 1rem
    usage: 辅助信息
```

### 3.2 Flutter字体实现

```dart
// lib/core/theme/app_text_styles.dart
class AppTextStyles {
  AppTextStyles._();

  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 64 / 57,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 52 / 45,
    letterSpacing: 0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: 0,
  );

  // Headline styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 40 / 32,
    letterSpacing: 0,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 36 / 28,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    letterSpacing: 0,
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
    letterSpacing: 0,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 24 / 16,
    letterSpacing: 0.15,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 0.5,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.4,
  );
}

// 主题中的文本样式配置
extension AppTextTheme on ThemeData {
  TextTheme get appTextTheme => textTheme.copyWith(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall: AppTextStyles.displaySmall,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    titleLarge: AppTextStyles.titleLarge,
    titleMedium: AppTextStyles.titleMedium,
    titleSmall: AppTextStyles.titleSmall,
    labelLarge: AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall: AppTextStyles.labelSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
  );
}
```

### 3.3 React字体实现

```css
/* styles/tokens/typography.css */
:root {
  /* 字体家族 */
  --font-family-primary: "PingFang SC", "Microsoft YaHei", "Helvetica Neue", sans-serif;
  --font-family-secondary: "San Francisco", "Roboto", "Helvetica Neue", Arial, sans-serif;
  --font-family-mono: "SF Mono", "Consolas", "Monaco", monospace;

  /* 字体大小 */
  --font-size-display-large: 3.56rem;   /* 57px */
  --font-size-display-medium: 2.81rem;  /* 45px */
  --font-size-display-small: 2.25rem;   /* 36px */
  --font-size-headline-large: 2rem;     /* 32px */
  --font-size-headline-medium: 1.75rem; /* 28px */
  --font-size-headline-small: 1.5rem;   /* 24px */
  --font-size-title-large: 1.375rem;    /* 22px */
  --font-size-title-medium: 1rem;       /* 16px */
  --font-size-title-small: 0.875rem;    /* 14px */
  --font-size-label-large: 0.875rem;    /* 14px */
  --font-size-label-medium: 0.75rem;    /* 12px */
  --font-size-label-small: 0.688rem;    /* 11px */
  --font-size-body-large: 1rem;         /* 16px */
  --font-size-body-medium: 0.875rem;    /* 14px */
  --font-size-body-small: 0.75rem;      /* 12px */

  /* 字体粗细 */
  --font-weight-regular: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;

  /* 行高 */
  --line-height-display-large: 4rem;     /* 64px */
  --line-height-display-medium: 3.25rem; /* 52px */
  --line-height-display-small: 2.75rem;  /* 44px */
  --line-height-headline-large: 2.5rem;  /* 40px */
  --line-height-headline-medium: 2.25rem;/* 36px */
  --line-height-headline-small: 2rem;    /* 32px */
  --line-height-title-large: 1.75rem;    /* 28px */
  --line-height-title-medium: 1.5rem;    /* 24px */
  --line-height-title-small: 1.25rem;    /* 20px */
  --line-height-label-large: 1.25rem;    /* 20px */
  --line-height-label-medium: 1rem;      /* 16px */
  --line-height-label-small: 1rem;       /* 16px */
  --line-height-body-large: 1.5rem;      /* 24px */
  --line-height-body-medium: 1.25rem;    /* 20px */
  --line-height-body-small: 1rem;        /* 16px */
}

/* 字体样式类 */
.text-display-large {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-display-large);
  font-weight: var(--font-weight-regular);
  line-height: var(--line-height-display-large);
  letter-spacing: -0.025em;
}

.text-display-medium {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-display-medium);
  font-weight: var(--font-weight-regular);
  line-height: var(--line-height-display-medium);
  letter-spacing: 0;
}

.text-headline-large {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-headline-large);
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-headline-large);
  letter-spacing: 0;
}

.text-title-large {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-title-large);
  font-weight: var(--font-weight-semibold);
  line-height: var(--line-height-title-large);
  letter-spacing: 0;
}

.text-body-large {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-body-large);
  font-weight: var(--font-weight-regular);
  line-height: var(--line-height-body-large);
  letter-spacing: 0.01em;
}

/* 响应式字体 */
@media (max-width: 768px) {
  :root {
    --font-size-display-large: 2.5rem;   /* 40px */
    --font-size-display-medium: 2rem;    /* 32px */
    --font-size-headline-large: 1.5rem;  /* 24px */
  }
}
```

---

## 4. 统一组件规范

### 4.1 组件分类标准

```yaml
原子组件 (Atoms):
  - 按钮 (Button)
    - primary-button: 主要操作按钮
    - secondary-button: 次要操作按钮
    - text-button: 文本按钮
    - icon-button: 图标按钮
    - floating-action-button: 浮动操作按钮

  - 输入框 (Input)
    - text-field: 文本输入框
    - search-field: 搜索输入框
    - password-field: 密码输入框
    - number-field: 数字输入框
    - textarea: 多行文本框

  - 标签 (Label)
    - text-label: 文本标签
    - badge: 徽章标签
    - chip: 片段标签
    - tag: 标记标签

  - 图标 (Icon)
    - system-icon: 系统图标
    - custom-icon: 自定义图标
    - avatar: 头像图标

分子组件 (Molecules):
  - 表单组 (Form Group)
    - input-group: 输入组
    - checkbox-group: 复选框组
    - radio-group: 单选框组
    - select-group: 选择器组

  - 卡片 (Card)
    - basic-card: 基础卡片
    - image-card: 图片卡片
    - action-card: 操作卡片
    - info-card: 信息卡片

  - 列表项 (List Item)
    - basic-list-item: 基础列表项
    - avatar-list-item: 头像列表项
    - action-list-item: 操作列表项

有机体组件 (Organisms):
  - 导航栏 (Navigation)
    - top-navigation: 顶部导航
    - bottom-navigation: 底部导航
    - drawer-navigation: 抽屉导航
    - tab-navigation: 标签导航

  - 表单 (Form)
    - login-form: 登录表单
    - register-form: 注册表单
    - profile-form: 个人信息表单
    - feedback-form: 反馈表单

  - 数据展示 (Data Display)
    - data-table: 数据表格
    - chart-container: 图表容器
    - statistics-panel: 统计面板
```

### 4.2 Flutter组件实现规范

```dart
// lib/core/widgets/base_widget.dart
abstract class BaseWidget extends StatelessWidget {
  const BaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context);
}

// lib/widgets/atoms/buttons/primary_button.dart
class PrimaryButton extends BaseWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = ButtonSize.medium,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final bool isEnabled;
  final ButtonSize size;

  @override
  Widget buildWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: _getButtonHeight(size),
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          disabledBackgroundColor: theme.colorScheme.outline,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: _getButtonPadding(size),
        ),
        child: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : child,
      ),
    );
  }

  double _getButtonHeight(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 48;
    }
  }

  EdgeInsets _getButtonPadding(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24);
    }
  }
}

enum ButtonSize { small, medium, large }

// lib/widgets/molecules/cards/basic_card.dart
class BasicCard extends BaseWidget {
  const BasicCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.elevation = 1,
    this.borderRadius = 8,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double elevation;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget buildWidget(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin,
      child: Material(
        color: theme.colorScheme.surface,
        elevation: elevation,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
```

### 4.3 React组件实现规范

```tsx
// components/atoms/Button/PrimaryButton.tsx
import React from 'react';
import clsx from 'clsx';
import { ButtonSize, ButtonProps } from './types';
import './Button.css';

interface PrimaryButtonProps extends ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  isLoading?: boolean;
  isDisabled?: boolean;
  size?: ButtonSize;
  fullWidth?: boolean;
}

export const PrimaryButton: React.FC<PrimaryButtonProps> = ({
  children,
  onClick,
  isLoading = false,
  isDisabled = false,
  size = 'medium',
  fullWidth = false,
  className,
  ...props
}) => {
  return (
    <button
      className={clsx(
        'button',
        'button--primary',
        `button--${size}`,
        {
          'button--loading': isLoading,
          'button--disabled': isDisabled,
          'button--full-width': fullWidth,
        },
        className
      )}
      onClick={onClick}
      disabled={isDisabled || isLoading}
      {...props}
    >
      {isLoading ? (
        <span className="button__loader">
          <svg className="spinner" viewBox="0 0 24 24">
            <circle
              className="spinner__circle"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              strokeWidth="2"
              fill="none"
            />
          </svg>
        </span>
      ) : (
        children
      )}
    </button>
  );
};

// components/atoms/Button/Button.css
.button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: none;
  border-radius: 8px;
  font-family: var(--font-family-primary);
  font-weight: var(--font-weight-medium);
  text-decoration: none;
  cursor: pointer;
  transition: all 0.2s ease-in-out;
  outline: none;
  position: relative;
  overflow: hidden;
}

.button:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

.button--primary {
  background-color: var(--color-primary);
  color: white;
}

.button--primary:hover:not(.button--disabled) {
  background-color: var(--color-primary-dark);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
}

.button--primary:active:not(.button--disabled) {
  transform: translateY(0);
  box-shadow: 0 2px 4px rgba(76, 175, 80, 0.3);
}

.button--small {
  height: 32px;
  padding: 0 12px;
  font-size: var(--font-size-label-medium);
}

.button--medium {
  height: 40px;
  padding: 0 16px;
  font-size: var(--font-size-label-large);
}

.button--large {
  height: 48px;
  padding: 0 24px;
  font-size: var(--font-size-title-small);
}

.button--full-width {
  width: 100%;
}

.button--disabled {
  background-color: var(--color-neutral-300);
  color: var(--color-neutral-500);
  cursor: not-allowed;
  transform: none !important;
  box-shadow: none !important;
}

.button--loading {
  cursor: wait;
}

.button__loader {
  display: flex;
  align-items: center;
  justify-content: center;
}

.spinner {
  width: 16px;
  height: 16px;
  animation: spin 1s linear infinite;
}

.spinner__circle {
  stroke-dasharray: 31.416;
  stroke-dashoffset: 31.416;
  animation: spinner-dash 2s ease-in-out infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@keyframes spinner-dash {
  0% {
    stroke-dasharray: 1, 31.416;
    stroke-dashoffset: 0;
  }
  50% {
    stroke-dasharray: 15.708, 31.416;
    stroke-dashoffset: -7.854;
  }
  100% {
    stroke-dasharray: 15.708, 31.416;
    stroke-dashoffset: -23.562;
  }
}

// components/molecules/Card/BasicCard.tsx
import React from 'react';
import clsx from 'clsx';
import './Card.css';

interface BasicCardProps {
  children: React.ReactNode;
  className?: string;
  onClick?: () => void;
  elevation?: 'none' | 'low' | 'medium' | 'high';
  padding?: 'none' | 'small' | 'medium' | 'large';
  borderRadius?: 'none' | 'small' | 'medium' | 'large';
}

export const BasicCard: React.FC<BasicCardProps> = ({
  children,
  className,
  onClick,
  elevation = 'low',
  padding = 'medium',
  borderRadius = 'medium',
}) => {
  const Component = onClick ? 'button' : 'div';
  
  return (
    <Component
      className={clsx(
        'card',
        `card--elevation-${elevation}`,
        `card--padding-${padding}`,
        `card--radius-${borderRadius}`,
        {
          'card--interactive': onClick,
        },
        className
      )}
      onClick={onClick}
    >
      {children}
    </Component>
  );
};
```

---

## 5. 命名规范统一

### 5.1 组件命名规范

```yaml
Flutter组件命名:
  文件命名: snake_case
    - primary_button.dart
    - nutrition_card.dart
    - user_profile_form.dart

  类命名: PascalCase
    - PrimaryButton
    - NutritionCard
    - UserProfileForm

  变量命名: camelCase
    - isLoading
    - onPressed
    - backgroundColor

  常量命名: SCREAMING_SNAKE_CASE
    - DEFAULT_BUTTON_HEIGHT
    - PRIMARY_COLOR
    - MAX_USERNAME_LENGTH

React组件命名:
  文件命名: PascalCase
    - PrimaryButton.tsx
    - NutritionCard.tsx
    - UserProfileForm.tsx

  组件命名: PascalCase
    - PrimaryButton
    - NutritionCard
    - UserProfileForm

  Props接口: PascalCase + Props后缀
    - PrimaryButtonProps
    - NutritionCardProps
    - UserProfileFormProps

  变量命名: camelCase
    - isLoading
    - onClick
    - backgroundColor

  常量命名: SCREAMING_SNAKE_CASE
    - DEFAULT_BUTTON_HEIGHT
    - PRIMARY_COLOR
    - MAX_USERNAME_LENGTH

CSS类命名:
  BEM方法论:
    - .button (Block)
    - .button__icon (Element)
    - .button--primary (Modifier)
    - .button--primary.button--disabled (Multiple Modifiers)

  示例:
    - .card
    - .card__header
    - .card__body
    - .card__footer
    - .card--elevated
    - .card--interactive
```

### 5.2 设计令牌命名

```yaml
命名模式: [category]-[property]-[variant]-[state]

颜色令牌:
  - color-primary
  - color-primary-light
  - color-primary-dark
  - color-surface-variant
  - color-on-surface

尺寸令牌:
  - size-button-small
  - size-button-medium
  - size-button-large
  - size-icon-small
  - size-icon-medium

间距令牌:
  - spacing-xs (4px)
  - spacing-sm (8px)
  - spacing-md (16px)
  - spacing-lg (24px)
  - spacing-xl (32px)

字体令牌:
  - font-size-body-small
  - font-size-body-medium
  - font-size-title-large
  - font-weight-regular
  - font-weight-medium

阴影令牌:
  - shadow-none
  - shadow-low
  - shadow-medium
  - shadow-high

圆角令牌:
  - radius-none (0px)
  - radius-small (4px)
  - radius-medium (8px)
  - radius-large (12px)
  - radius-full (9999px)
```

---

## 6. 跨端一致性

### 6.1 设计一致性保证

```yaml
视觉一致性:
  - 相同的颜色值
  - 相同的字体大小和行高
  - 相同的间距系统
  - 相同的圆角和阴影
  - 相同的图标和插画

交互一致性:
  - 相同的手势操作
  - 相同的动画时长和缓动
  - 相同的反馈机制
  - 相同的导航模式

功能一致性:
  - 相同的业务流程
  - 相同的表单验证
  - 相同的错误处理
  - 相同的状态管理

平台适配:
  - 遵循平台设计规范
  - 适配平台特有交互
  - 考虑平台性能差异
  - 优化平台用户体验
```

### 6.2 设计令牌同步机制

```json
{
  "color": {
    "primary": {
      "value": "#4CAF50",
      "type": "color",
      "description": "主品牌色 - 健康绿"
    },
    "secondary": {
      "value": "#2196F3",
      "type": "color", 
      "description": "次要品牌色 - 科技蓝"
    }
  },
  "fontSize": {
    "bodyLarge": {
      "value": "16px",
      "type": "dimension",
      "description": "正文大字号"
    },
    "bodyMedium": {
      "value": "14px", 
      "type": "dimension",
      "description": "正文中字号"
    }
  },
  "spacing": {
    "small": {
      "value": "8px",
      "type": "dimension",
      "description": "小间距"
    },
    "medium": {
      "value": "16px",
      "type": "dimension", 
      "description": "中间距"
    }
  }
}
```

### 6.3 自动化同步工具

```javascript
// scripts/sync-design-tokens.js
const fs = require('fs');
const path = require('path');

const designTokens = require('../design-tokens.json');

// 生成Flutter设计令牌
function generateFlutterTokens(tokens) {
  let dartCode = `// Generated file - Do not edit manually
class DesignTokens {
  DesignTokens._();
  
`;

  // 生成颜色常量
  if (tokens.color) {
    dartCode += '  // Colors\n';
    for (const [key, value] of Object.entries(tokens.color)) {
      const colorName = camelCase(key);
      dartCode += `  static const Color ${colorName} = Color(0xFF${value.value.replace('#', '')});\n`;
    }
    dartCode += '\n';
  }

  // 生成字体大小常量
  if (tokens.fontSize) {
    dartCode += '  // Font Sizes\n';
    for (const [key, value] of Object.entries(tokens.fontSize)) {
      const sizeName = camelCase(key);
      const sizeValue = parseFloat(value.value.replace('px', ''));
      dartCode += `  static const double ${sizeName} = ${sizeValue};\n`;
    }
    dartCode += '\n';
  }

  dartCode += '}';
  
  return dartCode;
}

// 生成CSS自定义属性
function generateCSSTokens(tokens) {
  let cssCode = `/* Generated file - Do not edit manually */
:root {
`;

  // 生成颜色变量
  if (tokens.color) {
    cssCode += '  /* Colors */\n';
    for (const [key, value] of Object.entries(tokens.color)) {
      const varName = kebabCase(key);
      cssCode += `  --color-${varName}: ${value.value};\n`;
    }
    cssCode += '\n';
  }

  // 生成字体大小变量
  if (tokens.fontSize) {
    cssCode += '  /* Font Sizes */\n';
    for (const [key, value] of Object.entries(tokens.fontSize)) {
      const varName = kebabCase(key);
      cssCode += `  --font-size-${varName}: ${value.value};\n`;
    }
    cssCode += '\n';
  }

  cssCode += '}';
  
  return cssCode;
}

// 工具函数
function camelCase(str) {
  return str.replace(/[-_](.)/g, (_, char) => char.toUpperCase());
}

function kebabCase(str) {
  return str.replace(/([A-Z])/g, '-$1').toLowerCase();
}

// 执行同步
function syncDesignTokens() {
  console.log('Syncing design tokens...');
  
  // 生成Flutter文件
  const flutterTokens = generateFlutterTokens(designTokens);
  fs.writeFileSync(
    path.join(__dirname, '../mobile/lib/core/theme/design_tokens.dart'),
    flutterTokens
  );
  
  // 生成CSS文件
  const cssTokens = generateCSSTokens(designTokens);
  fs.writeFileSync(
    path.join(__dirname, '../web/src/styles/tokens/generated.css'),
    cssTokens
  );
  
  console.log('Design tokens synced successfully!');
}

syncDesignTokens();
```

---

## 7. 设计令牌

### 7.1 令牌分类体系

```yaml
全局令牌 (Global Tokens):
  用途: 整个设计系统的基础值
  示例:
    - color-green-500: "#4CAF50"
    - size-4: "16px"
    - font-weight-medium: "500"

别名令牌 (Alias Tokens):
  用途: 语义化的全局令牌引用
  示例:
    - color-primary: "{color-green-500}"
    - spacing-medium: "{size-4}"
    - text-weight-emphasis: "{font-weight-medium}"

组件令牌 (Component Tokens):
  用途: 特定组件的专用值
  示例:
    - button-primary-background: "{color-primary}"
    - button-height-medium: "40px"
    - card-border-radius: "8px"
```

### 7.2 令牌命名约定

```yaml
命名结构: [category]-[property]-[variant]-[state]

分类 (Category):
  - color: 颜色
  - size: 尺寸
  - space: 间距
  - font: 字体
  - shadow: 阴影
  - border: 边框
  - motion: 动效

属性 (Property):
  - background: 背景
  - text: 文本
  - border: 边框
  - width: 宽度
  - height: 高度
  - radius: 圆角

变体 (Variant):
  - primary: 主要
  - secondary: 次要
  - small: 小号
  - medium: 中号
  - large: 大号

状态 (State):
  - default: 默认
  - hover: 悬停
  - active: 激活
  - disabled: 禁用
  - focus: 焦点

示例:
  - color-background-primary-default
  - size-height-button-medium
  - space-padding-card-default
  - font-size-text-large
```

### 7.3 令牌使用指南

```dart
// Flutter中使用设计令牌
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingMedium),
      decoration: BoxDecoration(
        color: DesignTokens.colorSurface,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: DesignTokens.colorShadow,
            blurRadius: DesignTokens.shadowBlurMedium,
            offset: Offset(0, DesignTokens.shadowOffsetMedium),
          ),
        ],
      ),
      child: Text(
        'Hello World',
        style: TextStyle(
          fontSize: DesignTokens.fontSizeBodyLarge,
          fontWeight: FontWeight.w500,
          color: DesignTokens.colorOnSurface,
        ),
      ),
    );
  }
}
```

```css
/* CSS中使用设计令牌 */
.my-component {
  padding: var(--spacing-medium);
  background-color: var(--color-surface);
  border-radius: var(--radius-medium);
  box-shadow: 
    0 var(--shadow-offset-medium) var(--shadow-blur-medium) 
    var(--color-shadow);
}

.my-component__text {
  font-size: var(--font-size-body-large);
  font-weight: var(--font-weight-medium);
  color: var(--color-on-surface);
}
```

---

## 8. 实施指南

### 8.1 迁移计划

```yaml
Phase 1: 基础令牌统一 (1周)
  目标: 建立统一的设计令牌系统
  任务:
    - 创建design-tokens.json主文件
    - 生成Flutter设计令牌文件
    - 生成CSS自定义属性文件
    - 设置自动同步脚本

Phase 2: 颜色系统迁移 (1周)
  目标: 统一所有颜色定义和使用
  任务:
    - 更新Flutter主题配置
    - 更新CSS颜色变量
    - 重构现有组件颜色使用
    - 验证颜色一致性

Phase 3: 字体系统迁移 (1周)
  目标: 统一字体大小和样式
  任务:
    - 更新Flutter文本样式
    - 更新CSS字体类
    - 重构现有文本组件
    - 验证字体一致性

Phase 4: 组件系统迁移 (2周)
  目标: 统一组件实现和命名
  任务:
    - 重构基础组件
    - 统一组件API
    - 更新组件文档
    - 添加组件测试

Phase 5: 验证和优化 (1周)
  目标: 确保迁移质量和性能
  任务:
    - 跨端一致性测试
    - 性能测试和优化
    - 可访问性测试
    - 用户体验验证
```

### 8.2 质量保证

```yaml
一致性检查:
  自动化检查:
    - 设计令牌同步验证
    - 颜色值一致性检查
    - 字体大小一致性检查
    - 组件API一致性检查

  手动检查:
    - 视觉还原度检查
    - 交互一致性测试
    - 跨端体验对比
    - 用户反馈收集

性能监控:
  Flutter性能:
    - 组件渲染时间
    - 内存使用情况
    - 包大小变化
    - 启动时间影响

  Web性能:
    - CSS加载时间
    - 组件渲染性能
    - 包大小优化
    - 缓存策略效果

文档维护:
  组件文档:
    - Storybook组件展示
    - API文档自动生成
    - 使用示例更新
    - 最佳实践指南

  设计文档:
    - Figma组件库同步
    - 设计规范更新
    - 变更日志维护
    - 培训材料准备
```

### 8.3 团队协作

```yaml
角色职责:
  设计师:
    - 维护Figma设计系统
    - 创建新组件设计
    - 验证实现效果
    - 制定设计规范

  前端开发:
    - 实现组件代码
    - 维护组件文档
    - 性能优化
    - 测试编写

  产品经理:
    - 业务需求澄清
    - 用户体验验证
    - 功能优先级排序
    - 发布计划制定

协作流程:
  设计阶段:
    1. 产品需求分析
    2. 设计方案制定
    3. 设计评审会议
    4. 设计规范更新

  开发阶段:
    1. 技术方案设计
    2. 组件开发实现
    3. 代码评审
    4. 测试验证

  发布阶段:
    1. 集成测试
    2. 用户验收测试
    3. 性能测试
    4. 正式发布

沟通机制:
  定期会议:
    - 每周设计评审会
    - 每月技术分享会
    - 季度系统回顾会

  文档共享:
    - 设计规范实时同步
    - 技术文档定期更新
    - 变更通知及时发布

  反馈渠道:
    - 设计问题反馈群
    - 技术问题讨论区
    - 用户体验反馈平台
```

---

## 总结

本统一UI设计系统文档解决了之前存在的所有设计冲突和不一致问题：

### 主要改进

1. **颜色系统统一**: 建立了完整的色彩令牌系统，确保Flutter和React使用相同的色值
2. **字体系统规范**: 定义了标准化的字体层级和实现方式
3. **组件命名统一**: 建立了跨平台一致的组件命名规范
4. **设计令牌化**: 实现了设计令牌的自动同步机制
5. **实施计划明确**: 提供了具体的迁移步骤和质量保证措施

### 核心特性

- **跨端一致性**: Flutter移动端与React Web端完全一致
- **原子化设计**: 基于原子设计方法论的组件分层
- **自动化同步**: 设计令牌自动同步到各个平台
- **可维护性**: 清晰的文档和规范，便于团队协作
- **可扩展性**: 灵活的令牌系统支持未来扩展

这个统一的设计系统将为项目提供一致的用户体验和高效的开发流程。

---

**文档状态**: ✅ UI设计系统统一完成  
**下一步**: 实施设计令牌迁移和组件重构