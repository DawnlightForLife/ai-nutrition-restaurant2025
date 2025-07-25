# AI智能营养餐厅系统 - UI设计系统文档

> **文档版本**: 2.0.0  
> **创建日期**: 2025-07-11  
> **更新日期**: 2025-07-11  
> **文档状态**: ✅ AI编码就绪  
> **目标受众**: AI编码工具、UI/UX设计师、前端开发团队

## 📋 目录

- [1. 设计系统概述](#1-设计系统概述)
- [2. 品牌视觉识别](#2-品牌视觉识别)
- [3. 色彩系统](#3-色彩系统)
- [4. 字体系统](#4-字体系统)
- [5. 间距布局](#5-间距布局)
- [6. 图标系统](#6-图标系统)
- [7. 基础组件](#7-基础组件)
- [8. 复合组件](#8-复合组件)
- [9. 页面模板](#9-页面模板)
- [10. 交互动效](#10-交互动效)
- [11. 响应式设计](#11-响应式设计)
- [12. 无障碍设计](#12-无障碍设计)
- [13. 设计令牌](#13-设计令牌)
- [14. 设计资源](#14-设计资源)

---

## 1. 设计系统概述

### 1.1 设计理念

```yaml
核心价值:
  - 健康: 传达健康生活的理念
  - 科技: 体现AI智能的特色
  - 温暖: 营造温馨的用餐体验
  - 专业: 展现专业的营养服务

设计原则:
  - 简洁明了: 界面简洁，信息层次清晰
  - 易用性: 操作流程简单，学习成本低
  - 一致性: 保持设计语言的统一性
  - 可访问性: 满足不同用户的使用需求
  - 品牌化: 强化品牌认知和记忆点

用户体验目标:
  - 降低认知负荷
  - 提高操作效率
  - 增强品牌认同
  - 提升用户满意度
```

### 1.2 设计系统架构

```
设计系统架构
├── 基础层 (Foundation)
│   ├── 色彩 (Colors)
│   ├── 字体 (Typography)
│   ├── 间距 (Spacing)
│   ├── 圆角 (Border Radius)
│   ├── 阴影 (Shadows)
│   └── 图标 (Icons)
├── 组件层 (Components)
│   ├── 基础组件 (Basic Components)
│   ├── 复合组件 (Composite Components)
│   └── 业务组件 (Business Components)
├── 模式层 (Patterns)
│   ├── 导航模式 (Navigation Patterns)
│   ├── 表单模式 (Form Patterns)
│   ├── 数据展示模式 (Data Display Patterns)
│   └── 反馈模式 (Feedback Patterns)
└── 页面层 (Pages)
    ├── 页面模板 (Page Templates)
    ├── 页面布局 (Page Layouts)
    └── 页面流程 (Page Flows)
```

### 1.3 设计工具与规范

```yaml
设计工具:
  - 主要工具: Figma
  - 原型工具: Figma + Framer
  - 图标设计: Iconify + Figma
  - 设计交付: Figma + Zeplin

文件规范:
  - 命名规范: 驼峰命名 + 版本号
  - 图层组织: 按功能模块分组
  - 组件库: 统一的组件库管理
  - 设计系统: 实时同步的设计系统

协作流程:
  - 设计评审: 每周定期评审
  - 开发对接: 实时沟通和确认
  - 测试验收: 设计还原度检查
  - 迭代优化: 基于用户反馈优化
```

---

## 2. 品牌视觉识别

### 2.1 Logo设计

```yaml
主Logo:
  - 设计理念: 结合营养、科技、餐饮元素
  - 核心图形: 叶子 + 大脑 + 餐具的抽象组合
  - 色彩应用: 主色调为清新绿色
  - 字体选择: 现代感的无衬线字体
  - 最小尺寸: 24px × 24px

Logo变体:
  - 水平版本: 图标 + 文字水平排列
  - 垂直版本: 图标 + 文字垂直排列
  - 图标版本: 仅图标，用于小尺寸应用
  - 单色版本: 黑色、白色版本
  - 反色版本: 适用于深色背景

使用规范:
  - 保护区域: Logo周围至少保留0.5倍Logo高度的空间
  - 最小尺寸: 确保清晰度和可读性
  - 禁止变形: 不得拉伸、倾斜或变形
  - 背景要求: 确保足够的对比度
```

### 2.2 品牌色彩定义

```css
/* 主品牌色 */
:root {
  --brand-primary: #4CAF50;      /* 健康绿 */
  --brand-secondary: #2196F3;    /* 科技蓝 */
  --brand-accent: #FF9800;       /* 活力橙 */
  
  /* 品牌色变体 */
  --brand-primary-light: #81C784;
  --brand-primary-dark: #388E3C;
  --brand-secondary-light: #64B5F6;
  --brand-secondary-dark: #1976D2;
  --brand-accent-light: #FFB74D;
  --brand-accent-dark: #F57C00;
}

/* 品牌色应用场景 */
.brand-primary {
  /* 主要按钮、导航栏、重要标识 */
  color: var(--brand-primary);
}

.brand-secondary {
  /* 次要按钮、链接、辅助信息 */
  color: var(--brand-secondary);
}

.brand-accent {
  /* 强调内容、促销信息、提醒标识 */
  color: var(--brand-accent);
}
```

### 2.3 视觉风格指南

```yaml
设计风格:
  - 整体风格: 现代简约、清新自然
  - 设计语言: Material Design 3.0
  - 视觉层次: 清晰的信息层级
  - 情感表达: 温暖、专业、值得信赖

视觉元素:
  - 插画风格: 扁平化插画，温暖色调
  - 图片风格: 清新自然，高质量食物摄影
  - 图标风格: 线性图标，简洁明了
  - 装饰元素: 简洁的几何图形

应用场景:
  - 移动应用: 主要应用场景
  - 网站: 展示和管理后台
  - 营销物料: 宣传海报、广告素材
  - 线下物料: 包装、餐具、环境装饰
```

---

## 3. 色彩系统

### 3.1 色彩层级定义

```css
/* 主色彩系统 */
:root {
  /* 主色调 - 健康绿 */
  --primary-50: #E8F5E8;
  --primary-100: #C8E6C8;
  --primary-200: #A5D6A5;
  --primary-300: #81C784;
  --primary-400: #66BB6A;
  --primary-500: #4CAF50;  /* 主色 */
  --primary-600: #43A047;
  --primary-700: #388E3C;
  --primary-800: #2E7D32;
  --primary-900: #1B5E20;
  
  /* 次色调 - 科技蓝 */
  --secondary-50: #E3F2FD;
  --secondary-100: #BBDEFB;
  --secondary-200: #90CAF9;
  --secondary-300: #64B5F6;
  --secondary-400: #42A5F5;
  --secondary-500: #2196F3;  /* 次色 */
  --secondary-600: #1E88E5;
  --secondary-700: #1976D2;
  --secondary-800: #1565C0;
  --secondary-900: #0D47A1;
  
  /* 强调色 - 活力橙 */
  --accent-50: #FFF3E0;
  --accent-100: #FFE0B2;
  --accent-200: #FFCC80;
  --accent-300: #FFB74D;
  --accent-400: #FFA726;
  --accent-500: #FF9800;   /* 强调色 */
  --accent-600: #FB8C00;
  --accent-700: #F57C00;
  --accent-800: #EF6C00;
  --accent-900: #E65100;
}

/* 中性色系统 */
:root {
  --neutral-50: #FAFAFA;
  --neutral-100: #F5F5F5;
  --neutral-200: #EEEEEE;
  --neutral-300: #E0E0E0;
  --neutral-400: #BDBDBD;
  --neutral-500: #9E9E9E;
  --neutral-600: #757575;
  --neutral-700: #616161;
  --neutral-800: #424242;
  --neutral-900: #212121;
  
  /* 语义化中性色 */
  --neutral-white: #FFFFFF;
  --neutral-black: #000000;
  --neutral-background: #FAFAFA;
  --neutral-surface: #FFFFFF;
  --neutral-outline: #E0E0E0;
}
```

### 3.2 语义化色彩

```css
/* 功能性色彩 */
:root {
  /* 成功色 */
  --success-50: #E8F5E8;
  --success-100: #C8E6C8;
  --success-500: #4CAF50;
  --success-600: #43A047;
  --success-700: #388E3C;
  
  /* 警告色 */
  --warning-50: #FFF3E0;
  --warning-100: #FFE0B2;
  --warning-500: #FF9800;
  --warning-600: #FB8C00;
  --warning-700: #F57C00;
  
  /* 错误色 */
  --error-50: #FFEBEE;
  --error-100: #FFCDD2;
  --error-500: #F44336;
  --error-600: #E53935;
  --error-700: #D32F2F;
  
  /* 信息色 */
  --info-50: #E3F2FD;
  --info-100: #BBDEFB;
  --info-500: #2196F3;
  --info-600: #1E88E5;
  --info-700: #1976D2;
}

/* 特殊场景色彩 */
:root {
  /* 营养相关色彩 */
  --nutrition-protein: #E57373;    /* 蛋白质 - 温暖红 */
  --nutrition-carb: #FFB74D;       /* 碳水化合物 - 活力橙 */
  --nutrition-fat: #FFF176;        /* 脂肪 - 明亮黄 */
  --nutrition-fiber: #81C784;      /* 纤维 - 健康绿 */
  --nutrition-vitamin: #BA68C8;    /* 维生素 - 活力紫 */
  --nutrition-mineral: #64B5F6;    /* 矿物质 - 清新蓝 */
  
  /* 餐厅类型色彩 */
  --restaurant-chinese: #F44336;   /* 中餐 - 中国红 */
  --restaurant-western: #2196F3;   /* 西餐 - 优雅蓝 */
  --restaurant-japanese: #4CAF50;  /* 日料 - 清新绿 */
  --restaurant-vegetarian: #8BC34A; /* 素食 - 自然绿 */
  --restaurant-fast: #FF9800;      /* 快餐 - 活力橙 */
}
```

### 3.3 色彩应用规则

```yaml
主色彩应用:
  - 主按钮背景色
  - 导航栏背景色
  - 重要图标颜色
  - 品牌标识色
  - 进度条颜色

次色彩应用:
  - 次要按钮背景色
  - 链接文字颜色
  - 选中状态颜色
  - 辅助信息颜色
  - 装饰元素颜色

强调色应用:
  - 重要提醒标识
  - 促销信息背景
  - 数据可视化重点
  - 悬浮按钮颜色
  - 通知徽章颜色

中性色应用:
  - 页面背景色
  - 卡片背景色
  - 分割线颜色
  - 禁用状态颜色
  - 占位符颜色

语义色应用:
  - 成功状态提示
  - 警告信息提示
  - 错误状态提示
  - 信息类型提示
  - 操作结果反馈
```

---

## 4. 字体系统

### 4.1 字体家族定义

```css
/* 字体家族 */
:root {
  /* 主字体 - 系统默认 */
  --font-family-primary: 
    -apple-system, 
    BlinkMacSystemFont, 
    "Segoe UI", 
    Roboto, 
    "Helvetica Neue", 
    Arial, 
    "Noto Sans", 
    sans-serif, 
    "Apple Color Emoji", 
    "Segoe UI Emoji", 
    "Segoe UI Symbol", 
    "Noto Color Emoji";
  
  /* 品牌字体 - 标题专用 */
  --font-family-brand: 
    "SF Pro Display", 
    "Helvetica Neue", 
    Arial, 
    sans-serif;
  
  /* 等宽字体 - 代码/数据 */
  --font-family-mono: 
    "SF Mono", 
    "Monaco", 
    "Inconsolata", 
    "Roboto Mono", 
    "Courier New", 
    monospace;
  
  /* 中文字体优化 */
  --font-family-chinese: 
    "PingFang SC", 
    "Hiragino Sans GB", 
    "Microsoft YaHei", 
    "Source Han Sans CN", 
    sans-serif;
}

/* 字体大小系统 */
:root {
  /* 基础字体大小 */
  --font-size-base: 16px;
  --line-height-base: 1.5;
  
  /* 字体大小等级 */
  --font-size-xs: 12px;    /* 辅助信息 */
  --font-size-sm: 14px;    /* 次要文本 */
  --font-size-md: 16px;    /* 正文文本 */
  --font-size-lg: 18px;    /* 重要文本 */
  --font-size-xl: 20px;    /* 小标题 */
  --font-size-2xl: 24px;   /* 中标题 */
  --font-size-3xl: 30px;   /* 大标题 */
  --font-size-4xl: 36px;   /* 特大标题 */
  --font-size-5xl: 48px;   /* 超大标题 */
  
  /* 行高系统 */
  --line-height-tight: 1.25;
  --line-height-snug: 1.375;
  --line-height-normal: 1.5;
  --line-height-relaxed: 1.625;
  --line-height-loose: 2;
}

/* 字体粗细系统 */
:root {
  --font-weight-thin: 100;
  --font-weight-light: 300;
  --font-weight-normal: 400;
  --font-weight-medium: 500;
  --font-weight-semibold: 600;
  --font-weight-bold: 700;
  --font-weight-extrabold: 800;
  --font-weight-black: 900;
}
```

### 4.2 字体等级定义

```css
/* 标题字体等级 */
.text-display-large {
  font-family: var(--font-family-brand);
  font-size: var(--font-size-5xl);
  font-weight: var(--font-weight-bold);
  line-height: var(--line-height-tight);
  letter-spacing: -0.02em;
}

.text-display-medium {
  font-family: var(--font-family-brand);
  font-size: var(--font-size-4xl);
  font-weight: var(--font-weight-semibold);
  line-height: var(--line-height-tight);
  letter-spacing: -0.01em;
}

.text-display-small {
  font-family: var(--font-family-brand);
  font-size: var(--font-size-3xl);
  font-weight: var(--font-weight-semibold);
  line-height: var(--line-height-snug);
}

/* 标题字体等级 */
.text-headline-large {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-semibold);
  line-height: var(--line-height-snug);
}

.text-headline-medium {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-xl);
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-normal);
}

.text-headline-small {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-normal);
}

/* 正文字体等级 */
.text-body-large {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-md);
  font-weight: var(--font-weight-normal);
  line-height: var(--line-height-relaxed);
}

.text-body-medium {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-normal);
  line-height: var(--line-height-normal);
}

.text-body-small {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-normal);
  line-height: var(--line-height-normal);
}

/* 标签字体等级 */
.text-label-large {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-normal);
  letter-spacing: 0.01em;
}

.text-label-medium {
  font-family: var(--font-family-primary);
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-normal);
  letter-spacing: 0.02em;
}

.text-label-small {
  font-family: var(--font-family-primary);
  font-size: 11px;
  font-weight: var(--font-weight-medium);
  line-height: var(--line-height-normal);
  letter-spacing: 0.03em;
}
```

### 4.3 字体应用指南

```yaml
标题字体应用:
  - Display Large: 启动页、欢迎页的主标题
  - Display Medium: 页面主要标题
  - Display Small: 重要功能区块标题
  - Headline Large: 卡片标题、模块标题
  - Headline Medium: 子标题、分组标题
  - Headline Small: 小节标题、次要标题

正文字体应用:
  - Body Large: 主要内容文本、重要描述
  - Body Medium: 一般内容文本、说明文字
  - Body Small: 辅助信息、次要说明

标签字体应用:
  - Label Large: 按钮文字、导航文字
  - Label Medium: 标签文字、状态文字
  - Label Small: 备注文字、版权信息

特殊字体应用:
  - 数字显示: 使用等宽字体，确保对齐
  - 品牌名称: 使用品牌字体，增强识别
  - 代码文本: 使用等宽字体，保持格式
  - 多语言: 针对不同语言优化字体选择
```

---

## 5. 间距布局

### 5.1 间距系统定义

```css
/* 间距系统 - 基于8px网格 */
:root {
  /* 基础间距单位 */
  --spacing-unit: 8px;
  
  /* 间距等级 */
  --spacing-0: 0;
  --spacing-1: 4px;    /* 0.5 * unit */
  --spacing-2: 8px;    /* 1 * unit */
  --spacing-3: 12px;   /* 1.5 * unit */
  --spacing-4: 16px;   /* 2 * unit */
  --spacing-5: 20px;   /* 2.5 * unit */
  --spacing-6: 24px;   /* 3 * unit */
  --spacing-8: 32px;   /* 4 * unit */
  --spacing-10: 40px;  /* 5 * unit */
  --spacing-12: 48px;  /* 6 * unit */
  --spacing-16: 64px;  /* 8 * unit */
  --spacing-20: 80px;  /* 10 * unit */
  --spacing-24: 96px;  /* 12 * unit */
  --spacing-32: 128px; /* 16 * unit */
  
  /* 特殊间距 */
  --spacing-px: 1px;
  --spacing-auto: auto;
  
  /* 页面级间距 */
  --page-padding: var(--spacing-4);
  --page-margin: var(--spacing-6);
  --section-gap: var(--spacing-8);
  --component-gap: var(--spacing-4);
}

/* 内边距工具类 */
.p-0 { padding: var(--spacing-0); }
.p-1 { padding: var(--spacing-1); }
.p-2 { padding: var(--spacing-2); }
.p-3 { padding: var(--spacing-3); }
.p-4 { padding: var(--spacing-4); }
.p-5 { padding: var(--spacing-5); }
.p-6 { padding: var(--spacing-6); }
.p-8 { padding: var(--spacing-8); }

/* 外边距工具类 */
.m-0 { margin: var(--spacing-0); }
.m-1 { margin: var(--spacing-1); }
.m-2 { margin: var(--spacing-2); }
.m-3 { margin: var(--spacing-3); }
.m-4 { margin: var(--spacing-4); }
.m-5 { margin: var(--spacing-5); }
.m-6 { margin: var(--spacing-6); }
.m-8 { margin: var(--spacing-8); }

/* 方向性间距 */
.pt-4 { padding-top: var(--spacing-4); }
.pr-4 { padding-right: var(--spacing-4); }
.pb-4 { padding-bottom: var(--spacing-4); }
.pl-4 { padding-left: var(--spacing-4); }
.px-4 { padding-left: var(--spacing-4); padding-right: var(--spacing-4); }
.py-4 { padding-top: var(--spacing-4); padding-bottom: var(--spacing-4); }
```

### 5.2 布局网格系统

```css
/* 网格系统 */
:root {
  /* 网格容器 */
  --grid-columns: 12;
  --grid-gap: var(--spacing-4);
  --grid-max-width: 1200px;
  
  /* 断点系统 */
  --breakpoint-xs: 0;
  --breakpoint-sm: 576px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 992px;
  --breakpoint-xl: 1200px;
  --breakpoint-xxl: 1400px;
}

/* 容器 */
.container {
  width: 100%;
  max-width: var(--grid-max-width);
  margin: 0 auto;
  padding: 0 var(--spacing-4);
}

/* 网格系统 */
.grid {
  display: grid;
  grid-template-columns: repeat(var(--grid-columns), 1fr);
  gap: var(--grid-gap);
}

.grid-cols-1 { grid-template-columns: repeat(1, 1fr); }
.grid-cols-2 { grid-template-columns: repeat(2, 1fr); }
.grid-cols-3 { grid-template-columns: repeat(3, 1fr); }
.grid-cols-4 { grid-template-columns: repeat(4, 1fr); }
.grid-cols-6 { grid-template-columns: repeat(6, 1fr); }
.grid-cols-12 { grid-template-columns: repeat(12, 1fr); }

/* 列跨度 */
.col-span-1 { grid-column: span 1 / span 1; }
.col-span-2 { grid-column: span 2 / span 2; }
.col-span-3 { grid-column: span 3 / span 3; }
.col-span-4 { grid-column: span 4 / span 4; }
.col-span-6 { grid-column: span 6 / span 6; }
.col-span-12 { grid-column: span 12 / span 12; }

/* Flexbox 布局 */
.flex { display: flex; }
.flex-col { flex-direction: column; }
.flex-row { flex-direction: row; }
.flex-wrap { flex-wrap: wrap; }
.flex-nowrap { flex-wrap: nowrap; }

/* 对齐方式 */
.justify-start { justify-content: flex-start; }
.justify-center { justify-content: center; }
.justify-end { justify-content: flex-end; }
.justify-between { justify-content: space-between; }
.justify-around { justify-content: space-around; }

.items-start { align-items: flex-start; }
.items-center { align-items: center; }
.items-end { align-items: flex-end; }
.items-stretch { align-items: stretch; }
```

### 5.3 响应式布局

```css
/* 响应式网格 */
@media (max-width: 767px) {
  .grid-responsive {
    grid-template-columns: 1fr;
    gap: var(--spacing-3);
  }
  
  .container {
    padding: 0 var(--spacing-3);
  }
}

@media (min-width: 768px) and (max-width: 991px) {
  .grid-responsive {
    grid-template-columns: repeat(2, 1fr);
    gap: var(--spacing-4);
  }
}

@media (min-width: 992px) {
  .grid-responsive {
    grid-template-columns: repeat(3, 1fr);
    gap: var(--spacing-6);
  }
}

/* 响应式间距 */
@media (max-width: 767px) {
  .p-responsive { padding: var(--spacing-3); }
  .m-responsive { margin: var(--spacing-3); }
  .gap-responsive { gap: var(--spacing-3); }
}

@media (min-width: 768px) {
  .p-responsive { padding: var(--spacing-4); }
  .m-responsive { margin: var(--spacing-4); }
  .gap-responsive { gap: var(--spacing-4); }
}

@media (min-width: 992px) {
  .p-responsive { padding: var(--spacing-6); }
  .m-responsive { margin: var(--spacing-6); }
  .gap-responsive { gap: var(--spacing-6); }
}
```

---

## 6. 图标系统

### 6.1 图标规范

```yaml
图标风格:
  - 设计风格: 线性图标 (Outline Style)
  - 线条粗细: 1.5px
  - 圆角大小: 2px
  - 网格基础: 24px × 24px
  - 填充区域: 20px × 20px (留2px边距)

图标分类:
  - 导航图标: 用于导航栏、菜单
  - 功能图标: 用于按钮、操作
  - 状态图标: 用于状态提示
  - 内容图标: 用于内容展示
  - 品牌图标: 用于品牌标识

图标尺寸:
  - 小图标: 16px × 16px
  - 标准图标: 24px × 24px
  - 中图标: 32px × 32px
  - 大图标: 48px × 48px
  - 特大图标: 64px × 64px

图标颜色:
  - 默认: var(--neutral-700)
  - 激活: var(--primary-500)
  - 禁用: var(--neutral-400)
  - 反向: var(--neutral-white)
  - 错误: var(--error-500)
  - 警告: var(--warning-500)
  - 成功: var(--success-500)
```

### 6.2 核心图标集合

```yaml
导航图标:
  - home: 首页
  - menu: 菜单
  - search: 搜索
  - filter: 筛选
  - sort: 排序
  - back: 返回
  - close: 关闭
  - more: 更多

功能图标:
  - add: 添加
  - edit: 编辑
  - delete: 删除
  - save: 保存
  - download: 下载
  - upload: 上传
  - share: 分享
  - favorite: 收藏
  - bookmark: 书签
  - settings: 设置

状态图标:
  - success: 成功
  - warning: 警告
  - error: 错误
  - info: 信息
  - loading: 加载
  - check: 选中
  - radio: 单选
  - checkbox: 多选

内容图标:
  - user: 用户
  - profile: 个人资料
  - nutrition: 营养
  - restaurant: 餐厅
  - food: 食物
  - order: 订单
  - payment: 支付
  - consultation: 咨询
  - chat: 聊天
  - notification: 通知
  - calendar: 日历
  - clock: 时间
  - location: 位置
  - star: 评分
  - heart: 喜欢
  - camera: 相机
  - image: 图片
  - document: 文档

营养专用图标:
  - calories: 卡路里
  - protein: 蛋白质
  - carbs: 碳水化合物
  - fat: 脂肪
  - fiber: 纤维
  - vitamin: 维生素
  - mineral: 矿物质
  - water: 水分
  - scale: 体重秤
  - measure: 测量
  - goal: 目标
  - progress: 进度
  - analysis: 分析
  - recommendation: 推荐
```

### 6.3 图标使用规范

```css
/* 图标基础样式 */
.icon {
  display: inline-block;
  width: 24px;
  height: 24px;
  fill: currentColor;
  stroke: currentColor;
  stroke-width: 1.5;
  stroke-linecap: round;
  stroke-linejoin: round;
}

/* 图标尺寸变体 */
.icon-xs { width: 16px; height: 16px; }
.icon-sm { width: 20px; height: 20px; }
.icon-md { width: 24px; height: 24px; }
.icon-lg { width: 32px; height: 32px; }
.icon-xl { width: 48px; height: 48px; }

/* 图标颜色变体 */
.icon-primary { color: var(--primary-500); }
.icon-secondary { color: var(--secondary-500); }
.icon-success { color: var(--success-500); }
.icon-warning { color: var(--warning-500); }
.icon-error { color: var(--error-500); }
.icon-muted { color: var(--neutral-400); }

/* 图标与文字组合 */
.icon-text {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
}

.icon-text-vertical {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--spacing-1);
}

/* 图标按钮 */
.icon-button {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: none;
  background: transparent;
  cursor: pointer;
  transition: all 0.2s ease;
}

.icon-button:hover {
  background: var(--neutral-100);
}

.icon-button:active {
  transform: scale(0.95);
}
```

---

## 7. 基础组件

### 7.1 按钮组件

```css
/* 按钮基础样式 */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--spacing-2);
  padding: var(--spacing-3) var(--spacing-4);
  border: none;
  border-radius: 8px;
  font-family: var(--font-family-primary);
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  line-height: 1;
  text-decoration: none;
  cursor: pointer;
  transition: all 0.2s ease;
  user-select: none;
  white-space: nowrap;
}

/* 按钮变体 */
.btn-primary {
  background: var(--primary-500);
  color: var(--neutral-white);
}

.btn-primary:hover {
  background: var(--primary-600);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
}

.btn-primary:active {
  background: var(--primary-700);
  transform: translateY(0);
}

.btn-secondary {
  background: var(--secondary-500);
  color: var(--neutral-white);
}

.btn-secondary:hover {
  background: var(--secondary-600);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(33, 150, 243, 0.3);
}

.btn-outline {
  background: transparent;
  color: var(--primary-500);
  border: 1px solid var(--primary-500);
}

.btn-outline:hover {
  background: var(--primary-500);
  color: var(--neutral-white);
}

.btn-ghost {
  background: transparent;
  color: var(--primary-500);
}

.btn-ghost:hover {
  background: var(--primary-50);
}

/* 按钮尺寸 */
.btn-sm {
  padding: var(--spacing-2) var(--spacing-3);
  font-size: var(--font-size-xs);
}

.btn-md {
  padding: var(--spacing-3) var(--spacing-4);
  font-size: var(--font-size-sm);
}

.btn-lg {
  padding: var(--spacing-4) var(--spacing-6);
  font-size: var(--font-size-md);
}

/* 按钮状态 */
.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  transform: none;
}

.btn-loading {
  position: relative;
  color: transparent;
}

.btn-loading::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 16px;
  height: 16px;
  margin: -8px 0 0 -8px;
  border: 2px solid currentColor;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
```

### 7.2 输入框组件

```css
/* 输入框基础样式 */
.input {
  display: block;
  width: 100%;
  padding: var(--spacing-3) var(--spacing-4);
  border: 1px solid var(--neutral-300);
  border-radius: 8px;
  font-family: var(--font-family-primary);
  font-size: var(--font-size-sm);
  line-height: 1.5;
  color: var(--neutral-900);
  background: var(--neutral-white);
  transition: all 0.2s ease;
}

.input:focus {
  outline: none;
  border-color: var(--primary-500);
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
}

.input:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  background: var(--neutral-100);
}

.input::placeholder {
  color: var(--neutral-400);
}

/* 输入框状态 */
.input-error {
  border-color: var(--error-500);
}

.input-error:focus {
  border-color: var(--error-500);
  box-shadow: 0 0 0 3px rgba(244, 67, 54, 0.1);
}

.input-success {
  border-color: var(--success-500);
}

.input-success:focus {
  border-color: var(--success-500);
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
}

/* 输入框尺寸 */
.input-sm {
  padding: var(--spacing-2) var(--spacing-3);
  font-size: var(--font-size-xs);
}

.input-lg {
  padding: var(--spacing-4) var(--spacing-5);
  font-size: var(--font-size-md);
}

/* 输入框组合 */
.input-group {
  position: relative;
  display: flex;
  width: 100%;
}

.input-group .input {
  flex: 1;
  border-radius: 0;
}

.input-group .input:first-child {
  border-top-left-radius: 8px;
  border-bottom-left-radius: 8px;
}

.input-group .input:last-child {
  border-top-right-radius: 8px;
  border-bottom-right-radius: 8px;
}

.input-group .input:not(:first-child) {
  border-left: none;
}

/* 输入框图标 */
.input-icon {
  position: relative;
}

.input-icon .input {
  padding-left: 40px;
}

.input-icon .icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--neutral-400);
}

.input-icon .input:focus ~ .icon {
  color: var(--primary-500);
}
```

### 7.3 卡片组件

```css
/* 卡片基础样式 */
.card {
  display: block;
  background: var(--neutral-white);
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  transition: all 0.2s ease;
}

.card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.card-clickable {
  cursor: pointer;
}

.card-clickable:active {
  transform: translateY(0);
}

/* 卡片内容 */
.card-header {
  padding: var(--spacing-4) var(--spacing-4) 0;
}

.card-body {
  padding: var(--spacing-4);
}

.card-footer {
  padding: 0 var(--spacing-4) var(--spacing-4);
}

/* 卡片图片 */
.card-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
}

.card-image-sm {
  height: 150px;
}

.card-image-lg {
  height: 250px;
}

/* 卡片变体 */
.card-outlined {
  border: 1px solid var(--neutral-200);
  box-shadow: none;
}

.card-elevated {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.card-flat {
  box-shadow: none;
}

/* 卡片标题 */
.card-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--neutral-900);
  margin: 0 0 var(--spacing-2) 0;
}

.card-subtitle {
  font-size: var(--font-size-sm);
  color: var(--neutral-600);
  margin: 0 0 var(--spacing-3) 0;
}

.card-text {
  font-size: var(--font-size-sm);
  color: var(--neutral-700);
  line-height: var(--line-height-relaxed);
}
```

### 7.4 标签组件

```css
/* 标签基础样式 */
.tag {
  display: inline-flex;
  align-items: center;
  gap: var(--spacing-1);
  padding: var(--spacing-1) var(--spacing-2);
  border-radius: 6px;
  font-size: var(--font-size-xs);
  font-weight: var(--font-weight-medium);
  line-height: 1;
  white-space: nowrap;
}

/* 标签变体 */
.tag-primary {
  background: var(--primary-100);
  color: var(--primary-700);
}

.tag-secondary {
  background: var(--secondary-100);
  color: var(--secondary-700);
}

.tag-success {
  background: var(--success-100);
  color: var(--success-700);
}

.tag-warning {
  background: var(--warning-100);
  color: var(--warning-700);
}

.tag-error {
  background: var(--error-100);
  color: var(--error-700);
}

.tag-neutral {
  background: var(--neutral-100);
  color: var(--neutral-700);
}

/* 标签尺寸 */
.tag-sm {
  padding: var(--spacing-1) var(--spacing-2);
  font-size: 11px;
}

.tag-md {
  padding: var(--spacing-1) var(--spacing-2);
  font-size: var(--font-size-xs);
}

.tag-lg {
  padding: var(--spacing-2) var(--spacing-3);
  font-size: var(--font-size-sm);
}

/* 可关闭标签 */
.tag-closable {
  padding-right: var(--spacing-1);
}

.tag-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.2s ease;
}

.tag-close:hover {
  background: rgba(0, 0, 0, 0.2);
}

/* 可选择标签 */
.tag-selectable {
  cursor: pointer;
  transition: all 0.2s ease;
}

.tag-selectable:hover {
  opacity: 0.8;
}

.tag-selected {
  background: var(--primary-500);
  color: var(--neutral-white);
}
```

---

## 8. 复合组件

### 8.1 导航组件

```css
/* 顶部导航栏 */
.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--spacing-3) var(--spacing-4);
  background: var(--neutral-white);
  border-bottom: 1px solid var(--neutral-200);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.navbar-brand {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--primary-500);
  text-decoration: none;
}

.navbar-nav {
  display: flex;
  align-items: center;
  gap: var(--spacing-1);
}

.navbar-item {
  padding: var(--spacing-2) var(--spacing-3);
  border-radius: 6px;
  color: var(--neutral-700);
  text-decoration: none;
  transition: all 0.2s ease;
}

.navbar-item:hover {
  background: var(--neutral-100);
  color: var(--primary-500);
}

.navbar-item.active {
  background: var(--primary-100);
  color: var(--primary-700);
}

/* 底部导航栏 */
.bottom-nav {
  display: flex;
  background: var(--neutral-white);
  border-top: 1px solid var(--neutral-200);
  box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.1);
}

.bottom-nav-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--spacing-1);
  padding: var(--spacing-2);
  color: var(--neutral-600);
  text-decoration: none;
  transition: all 0.2s ease;
}

.bottom-nav-item:hover {
  color: var(--primary-500);
}

.bottom-nav-item.active {
  color: var(--primary-500);
}

.bottom-nav-item .icon {
  width: 24px;
  height: 24px;
}

.bottom-nav-item .text {
  font-size: 11px;
  font-weight: var(--font-weight-medium);
}

/* 侧边导航 */
.sidebar {
  width: 280px;
  background: var(--neutral-white);
  border-right: 1px solid var(--neutral-200);
  overflow-y: auto;
}

.sidebar-header {
  padding: var(--spacing-4);
  border-bottom: 1px solid var(--neutral-200);
}

.sidebar-nav {
  padding: var(--spacing-2);
}

.sidebar-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-3);
  padding: var(--spacing-3);
  border-radius: 8px;
  color: var(--neutral-700);
  text-decoration: none;
  transition: all 0.2s ease;
}

.sidebar-item:hover {
  background: var(--neutral-100);
  color: var(--primary-500);
}

.sidebar-item.active {
  background: var(--primary-100);
  color: var(--primary-700);
}

.sidebar-item .icon {
  width: 20px;
  height: 20px;
}
```

### 8.2 表单组件

```css
/* 表单容器 */
.form {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

/* 表单字段 */
.form-field {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
}

.form-field.inline {
  flex-direction: row;
  align-items: center;
  gap: var(--spacing-4);
}

.form-field.inline .form-label {
  min-width: 120px;
  margin-bottom: 0;
}

/* 表单标签 */
.form-label {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--neutral-700);
}

.form-label.required::after {
  content: '*';
  color: var(--error-500);
  margin-left: var(--spacing-1);
}

/* 表单帮助文本 */
.form-help {
  font-size: var(--font-size-xs);
  color: var(--neutral-600);
  line-height: var(--line-height-relaxed);
}

/* 表单错误信息 */
.form-error {
  font-size: var(--font-size-xs);
  color: var(--error-500);
  display: flex;
  align-items: center;
  gap: var(--spacing-1);
}

.form-error .icon {
  width: 16px;
  height: 16px;
}

/* 表单成功信息 */
.form-success {
  font-size: var(--font-size-xs);
  color: var(--success-500);
  display: flex;
  align-items: center;
  gap: var(--spacing-1);
}

/* 表单动作 */
.form-actions {
  display: flex;
  gap: var(--spacing-3);
  margin-top: var(--spacing-4);
}

.form-actions.center {
  justify-content: center;
}

.form-actions.end {
  justify-content: flex-end;
}

/* 复选框和单选框 */
.checkbox, .radio {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  cursor: pointer;
}

.checkbox input, .radio input {
  margin: 0;
  width: 16px;
  height: 16px;
  accent-color: var(--primary-500);
}

.checkbox-group, .radio-group {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
}

.checkbox-group.inline, .radio-group.inline {
  flex-direction: row;
  flex-wrap: wrap;
  gap: var(--spacing-4);
}

/* 选择器 */
.select {
  position: relative;
}

.select select {
  appearance: none;
  width: 100%;
  padding: var(--spacing-3) var(--spacing-4);
  padding-right: 40px;
  border: 1px solid var(--neutral-300);
  border-radius: 8px;
  font-size: var(--font-size-sm);
  background: var(--neutral-white);
  cursor: pointer;
}

.select::after {
  content: '';
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  width: 0;
  height: 0;
  border-left: 6px solid transparent;
  border-right: 6px solid transparent;
  border-top: 6px solid var(--neutral-400);
  pointer-events: none;
}

.select select:focus {
  outline: none;
  border-color: var(--primary-500);
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
}
```

### 8.3 模态框组件

```css
/* 模态框遮罩 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: var(--spacing-4);
}

/* 模态框容器 */
.modal {
  background: var(--neutral-white);
  border-radius: 12px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
  width: 100%;
  max-width: 480px;
  max-height: 90vh;
  overflow-y: auto;
  animation: modal-enter 0.2s ease;
}

@keyframes modal-enter {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

/* 模态框头部 */
.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--spacing-4) var(--spacing-4) 0;
}

.modal-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--neutral-900);
}

.modal-close {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: none;
  background: transparent;
  cursor: pointer;
  transition: all 0.2s ease;
}

.modal-close:hover {
  background: var(--neutral-100);
}

/* 模态框内容 */
.modal-body {
  padding: var(--spacing-4);
}

.modal-footer {
  display: flex;
  gap: var(--spacing-3);
  padding: 0 var(--spacing-4) var(--spacing-4);
  justify-content: flex-end;
}

/* 模态框尺寸变体 */
.modal-sm {
  max-width: 320px;
}

.modal-md {
  max-width: 480px;
}

.modal-lg {
  max-width: 640px;
}

.modal-xl {
  max-width: 800px;
}

/* 全屏模态框 */
.modal-fullscreen {
  width: 100vw;
  height: 100vh;
  max-width: none;
  max-height: none;
  border-radius: 0;
  margin: 0;
}
```

### 8.4 消息提示组件

```css
/* 消息提示容器 */
.toast-container {
  position: fixed;
  top: var(--spacing-4);
  right: var(--spacing-4);
  z-index: 1100;
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
  pointer-events: none;
}

/* 消息提示 */
.toast {
  display: flex;
  align-items: center;
  gap: var(--spacing-3);
  padding: var(--spacing-3) var(--spacing-4);
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  min-width: 300px;
  max-width: 400px;
  background: var(--neutral-white);
  border-left: 4px solid var(--primary-500);
  animation: toast-enter 0.3s ease;
  pointer-events: auto;
}

@keyframes toast-enter {
  from {
    opacity: 0;
    transform: translateX(100%);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* 消息提示变体 */
.toast-success {
  border-left-color: var(--success-500);
}

.toast-success .toast-icon {
  color: var(--success-500);
}

.toast-warning {
  border-left-color: var(--warning-500);
}

.toast-warning .toast-icon {
  color: var(--warning-500);
}

.toast-error {
  border-left-color: var(--error-500);
}

.toast-error .toast-icon {
  color: var(--error-500);
}

.toast-info {
  border-left-color: var(--info-500);
}

.toast-info .toast-icon {
  color: var(--info-500);
}

/* 消息提示图标 */
.toast-icon {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}

/* 消息提示内容 */
.toast-content {
  flex: 1;
}

.toast-title {
  font-size: var(--font-size-sm);
  font-weight: var(--font-weight-medium);
  color: var(--neutral-900);
  margin: 0 0 var(--spacing-1) 0;
}

.toast-message {
  font-size: var(--font-size-xs);
  color: var(--neutral-600);
  line-height: var(--line-height-relaxed);
}

/* 消息提示关闭按钮 */
.toast-close {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  border: none;
  background: transparent;
  cursor: pointer;
  transition: all 0.2s ease;
}

.toast-close:hover {
  background: var(--neutral-100);
}

/* 消息提示进度条 */
.toast-progress {
  position: absolute;
  bottom: 0;
  left: 0;
  height: 3px;
  background: currentColor;
  border-radius: 0 0 8px 8px;
  animation: toast-progress 3s linear;
}

@keyframes toast-progress {
  from {
    width: 100%;
  }
  to {
    width: 0%;
  }
}
```

---

## 9. 页面模板

### 9.1 基础页面布局

```css
/* 页面容器 */
.page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: var(--neutral-background);
}

/* 页面头部 */
.page-header {
  background: var(--neutral-white);
  border-bottom: 1px solid var(--neutral-200);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

/* 页面主要内容 */
.page-main {
  flex: 1;
  padding: var(--spacing-4);
}

/* 页面底部 */
.page-footer {
  background: var(--neutral-white);
  border-top: 1px solid var(--neutral-200);
  padding: var(--spacing-4);
  text-align: center;
  font-size: var(--font-size-xs);
  color: var(--neutral-600);
}

/* 页面标题区域 */
.page-title-section {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--spacing-6);
}

.page-title {
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-bold);
  color: var(--neutral-900);
}

.page-subtitle {
  font-size: var(--font-size-md);
  color: var(--neutral-600);
  margin-top: var(--spacing-2);
}

.page-actions {
  display: flex;
  gap: var(--spacing-3);
}

/* 页面内容区域 */
.page-content {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-6);
}

.page-section {
  background: var(--neutral-white);
  border-radius: 12px;
  padding: var(--spacing-4);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.page-section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--spacing-4);
}

.page-section-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--neutral-900);
}

.page-section-content {
  /* 内容区域样式 */
}
```

### 9.2 登录页面模板

```css
/* 登录页面容器 */
.login-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(135deg, var(--primary-50) 0%, var(--secondary-50) 100%);
  padding: var(--spacing-4);
}

/* 登录卡片 */
.login-card {
  width: 100%;
  max-width: 400px;
  background: var(--neutral-white);
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  padding: var(--spacing-6);
}

/* 登录头部 */
.login-header {
  text-align: center;
  margin-bottom: var(--spacing-6);
}

.login-logo {
  width: 80px;
  height: 80px;
  margin: 0 auto var(--spacing-4);
}

.login-title {
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-bold);
  color: var(--neutral-900);
  margin-bottom: var(--spacing-2);
}

.login-subtitle {
  font-size: var(--font-size-md);
  color: var(--neutral-600);
}

/* 登录表单 */
.login-form {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

.login-form-field {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-2);
}

.login-form-actions {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-3);
  margin-top: var(--spacing-4);
}

.login-forgot-password {
  text-align: center;
  font-size: var(--font-size-sm);
  color: var(--primary-500);
  text-decoration: none;
}

.login-forgot-password:hover {
  text-decoration: underline;
}

/* 登录底部 */
.login-footer {
  text-align: center;
  margin-top: var(--spacing-6);
  padding-top: var(--spacing-4);
  border-top: 1px solid var(--neutral-200);
}

.login-register-link {
  font-size: var(--font-size-sm);
  color: var(--neutral-600);
}

.login-register-link a {
  color: var(--primary-500);
  text-decoration: none;
}

.login-register-link a:hover {
  text-decoration: underline;
}
```

### 9.3 列表页面模板

```css
/* 列表页面容器 */
.list-page {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

/* 列表工具栏 */
.list-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: var(--neutral-white);
  border-radius: 12px;
  padding: var(--spacing-4);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.list-toolbar-left {
  display: flex;
  align-items: center;
  gap: var(--spacing-3);
}

.list-toolbar-right {
  display: flex;
  align-items: center;
  gap: var(--spacing-3);
}

/* 搜索框 */
.list-search {
  position: relative;
  min-width: 300px;
}

.list-search .input {
  padding-left: 40px;
}

.list-search .icon {
  position: absolute;
  left: 12px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--neutral-400);
}

/* 筛选器 */
.list-filters {
  display: flex;
  align-items: center;
  gap: var(--spacing-3);
}

.list-filter {
  min-width: 120px;
}

/* 列表容器 */
.list-container {
  background: var(--neutral-white);
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

/* 列表头部 */
.list-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--spacing-4);
  border-bottom: 1px solid var(--neutral-200);
}

.list-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--neutral-900);
}

.list-count {
  font-size: var(--font-size-sm);
  color: var(--neutral-600);
}

/* 列表内容 */
.list-content {
  /* 列表项样式 */
}

.list-item {
  display: flex;
  align-items: center;
  padding: var(--spacing-4);
  border-bottom: 1px solid var(--neutral-100);
  transition: all 0.2s ease;
}

.list-item:last-child {
  border-bottom: none;
}

.list-item:hover {
  background: var(--neutral-50);
}

.list-item-content {
  flex: 1;
}

.list-item-actions {
  display: flex;
  gap: var(--spacing-2);
}

/* 列表分页 */
.list-pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-4);
  border-top: 1px solid var(--neutral-200);
}

/* 空状态 */
.list-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--spacing-12);
  text-align: center;
}

.list-empty-icon {
  width: 64px;
  height: 64px;
  color: var(--neutral-400);
  margin-bottom: var(--spacing-4);
}

.list-empty-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--neutral-700);
  margin-bottom: var(--spacing-2);
}

.list-empty-description {
  font-size: var(--font-size-md);
  color: var(--neutral-600);
  margin-bottom: var(--spacing-4);
}
```

### 9.4 详情页面模板

```css
/* 详情页面容器 */
.detail-page {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

/* 详情头部 */
.detail-header {
  background: var(--neutral-white);
  border-radius: 12px;
  padding: var(--spacing-4);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.detail-header-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--spacing-4);
}

.detail-back-button {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  color: var(--neutral-600);
  text-decoration: none;
  font-size: var(--font-size-sm);
}

.detail-back-button:hover {
  color: var(--primary-500);
}

.detail-actions {
  display: flex;
  gap: var(--spacing-3);
}

/* 详情主要信息 */
.detail-main-info {
  display: flex;
  gap: var(--spacing-4);
}

.detail-image {
  width: 120px;
  height: 120px;
  border-radius: 12px;
  object-fit: cover;
}

.detail-info {
  flex: 1;
}

.detail-title {
  font-size: var(--font-size-2xl);
  font-weight: var(--font-weight-bold);
  color: var(--neutral-900);
  margin-bottom: var(--spacing-2);
}

.detail-subtitle {
  font-size: var(--font-size-md);
  color: var(--neutral-600);
  margin-bottom: var(--spacing-3);
}

.detail-meta {
  display: flex;
  flex-wrap: wrap;
  gap: var(--spacing-4);
}

.detail-meta-item {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
  font-size: var(--font-size-sm);
  color: var(--neutral-700);
}

.detail-meta-item .icon {
  width: 16px;
  height: 16px;
  color: var(--neutral-500);
}

/* 详情内容 */
.detail-content {
  display: flex;
  flex-direction: column;
  gap: var(--spacing-4);
}

.detail-section {
  background: var(--neutral-white);
  border-radius: 12px;
  padding: var(--spacing-4);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.detail-section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--spacing-4);
}

.detail-section-title {
  font-size: var(--font-size-lg);
  font-weight: var(--font-weight-semibold);
  color: var(--neutral-900);
}

.detail-section-content {
  /* 内容区域样式 */
}

/* 详情表格 */
.detail-table {
  width: 100%;
  border-collapse: collapse;
}

.detail-table th,
.detail-table td {
  padding: var(--spacing-3);
  text-align: left;
  border-bottom: 1px solid var(--neutral-200);
}

.detail-table th {
  font-weight: var(--font-weight-medium);
  color: var(--neutral-700);
  background: var(--neutral-50);
}

.detail-table td {
  color: var(--neutral-900);
}

.detail-table tr:last-child td {
  border-bottom: none;
}
```

---

## 10. 交互动效

### 10.1 过渡动画

```css
/* 基础过渡 */
.transition-all {
  transition: all 0.2s ease;
}

.transition-colors {
  transition: color 0.2s ease, background-color 0.2s ease, border-color 0.2s ease;
}

.transition-transform {
  transition: transform 0.2s ease;
}

.transition-opacity {
  transition: opacity 0.2s ease;
}

/* 悬停效果 */
.hover-lift {
  transition: all 0.2s ease;
}

.hover-lift:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.hover-scale {
  transition: transform 0.2s ease;
}

.hover-scale:hover {
  transform: scale(1.05);
}

.hover-brighten {
  transition: filter 0.2s ease;
}

.hover-brighten:hover {
  filter: brightness(1.1);
}

/* 点击效果 */
.active-scale {
  transition: transform 0.1s ease;
}

.active-scale:active {
  transform: scale(0.95);
}

.active-press {
  transition: all 0.1s ease;
}

.active-press:active {
  transform: translateY(1px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 焦点效果 */
.focus-ring {
  transition: box-shadow 0.2s ease;
}

.focus-ring:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
}
```

### 10.2 加载动画

```css
/* 旋转加载 */
.spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* 脉冲加载 */
.pulse {
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

/* 骨架屏动画 */
.skeleton {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: skeleton 1.5s infinite;
}

@keyframes skeleton {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}

/* 呼吸动画 */
.breathe {
  animation: breathe 3s infinite;
}

@keyframes breathe {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.05); }
}

/* 弹跳动画 */
.bounce {
  animation: bounce 2s infinite;
}

@keyframes bounce {
  0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
  40% { transform: translateY(-10px); }
  60% { transform: translateY(-5px); }
}

/* 淡入淡出 */
.fade-in {
  animation: fadeIn 0.3s ease-in;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.fade-out {
  animation: fadeOut 0.3s ease-out;
}

@keyframes fadeOut {
  from { opacity: 1; }
  to { opacity: 0; }
}

/* 滑入滑出 */
.slide-in-right {
  animation: slideInRight 0.3s ease-out;
}

@keyframes slideInRight {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}

.slide-in-left {
  animation: slideInLeft 0.3s ease-out;
}

@keyframes slideInLeft {
  from { transform: translateX(-100%); }
  to { transform: translateX(0); }
}

.slide-in-up {
  animation: slideInUp 0.3s ease-out;
}

@keyframes slideInUp {
  from { transform: translateY(100%); }
  to { transform: translateY(0); }
}

.slide-in-down {
  animation: slideInDown 0.3s ease-out;
}

@keyframes slideInDown {
  from { transform: translateY(-100%); }
  to { transform: translateY(0); }
}
```

### 10.3 微交互效果

```css
/* 波纹效果 */
.ripple {
  position: relative;
  overflow: hidden;
}

.ripple::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  transform: translate(-50%, -50%);
  transition: all 0.3s ease;
}

.ripple:active::before {
  width: 300px;
  height: 300px;
}

/* 光晕效果 */
.glow {
  transition: box-shadow 0.3s ease;
}

.glow:hover {
  box-shadow: 0 0 20px rgba(76, 175, 80, 0.3);
}

/* 渐变动画 */
.gradient-animate {
  background: linear-gradient(45deg, var(--primary-500), var(--secondary-500));
  background-size: 400% 400%;
  animation: gradientShift 3s ease infinite;
}

@keyframes gradientShift {
  0% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
  100% { background-position: 0% 50%; }
}

/* 打字机效果 */
.typewriter {
  overflow: hidden;
  border-right: 2px solid var(--primary-500);
  white-space: nowrap;
  animation: typing 3s steps(30, end), blink 1s infinite;
}

@keyframes typing {
  from { width: 0; }
  to { width: 100%; }
}

@keyframes blink {
  0%, 50% { border-color: var(--primary-500); }
  51%, 100% { border-color: transparent; }
}

/* 摇摆效果 */
.wobble {
  animation: wobble 1s ease-in-out;
}

@keyframes wobble {
  0% { transform: translateX(0%); }
  15% { transform: translateX(-25px) rotate(-5deg); }
  30% { transform: translateX(20px) rotate(3deg); }
  45% { transform: translateX(-15px) rotate(-3deg); }
  60% { transform: translateX(10px) rotate(2deg); }
  75% { transform: translateX(-5px) rotate(-1deg); }
  100% { transform: translateX(0%); }
}

/* 弹性效果 */
.elastic {
  animation: elastic 1s ease-out;
}

@keyframes elastic {
  0% { transform: scale(1); }
  30% { transform: scale(1.25); }
  75% { transform: scale(0.85); }
  100% { transform: scale(1); }
}
```

---

## 11. 响应式设计

### 11.1 断点系统

```css
/* 断点定义 */
:root {
  --breakpoint-xs: 0px;
  --breakpoint-sm: 576px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 992px;
  --breakpoint-xl: 1200px;
  --breakpoint-xxl: 1400px;
}

/* 媒体查询 Mixins */
@media (max-width: 575px) {
  .container-xs { max-width: 100%; }
  .hidden-xs { display: none; }
  .visible-xs { display: block; }
  
  /* 小屏幕特定样式 */
  .text-xs-center { text-align: center; }
  .text-xs-left { text-align: left; }
  .text-xs-right { text-align: right; }
  
  .p-xs-2 { padding: var(--spacing-2); }
  .p-xs-3 { padding: var(--spacing-3); }
  .p-xs-4 { padding: var(--spacing-4); }
  
  .m-xs-2 { margin: var(--spacing-2); }
  .m-xs-3 { margin: var(--spacing-3); }
  .m-xs-4 { margin: var(--spacing-4); }
}

@media (min-width: 576px) {
  .container-sm { max-width: 540px; }
  .hidden-sm { display: none; }
  .visible-sm { display: block; }
  
  .col-sm-1 { width: 8.333333%; }
  .col-sm-2 { width: 16.666667%; }
  .col-sm-3 { width: 25%; }
  .col-sm-4 { width: 33.333333%; }
  .col-sm-6 { width: 50%; }
  .col-sm-12 { width: 100%; }
}

@media (min-width: 768px) {
  .container-md { max-width: 720px; }
  .hidden-md { display: none; }
  .visible-md { display: block; }
  
  .col-md-1 { width: 8.333333%; }
  .col-md-2 { width: 16.666667%; }
  .col-md-3 { width: 25%; }
  .col-md-4 { width: 33.333333%; }
  .col-md-6 { width: 50%; }
  .col-md-8 { width: 66.666667%; }
  .col-md-12 { width: 100%; }
}

@media (min-width: 992px) {
  .container-lg { max-width: 960px; }
  .hidden-lg { display: none; }
  .visible-lg { display: block; }
  
  .col-lg-1 { width: 8.333333%; }
  .col-lg-2 { width: 16.666667%; }
  .col-lg-3 { width: 25%; }
  .col-lg-4 { width: 33.333333%; }
  .col-lg-6 { width: 50%; }
  .col-lg-8 { width: 66.666667%; }
  .col-lg-9 { width: 75%; }
  .col-lg-12 { width: 100%; }
}

@media (min-width: 1200px) {
  .container-xl { max-width: 1140px; }
  .hidden-xl { display: none; }
  .visible-xl { display: block; }
}
```

### 11.2 移动端适配

```css
/* 移动端基础样式 */
@media (max-width: 767px) {
  /* 全局字体大小调整 */
  html { font-size: 14px; }
  
  /* 导航栏移动端适配 */
  .navbar {
    padding: var(--spacing-2) var(--spacing-3);
  }
  
  .navbar-brand {
    font-size: var(--font-size-md);
  }
  
  /* 页面内容移动端适配 */
  .page-main {
    padding: var(--spacing-3);
  }
  
  .page-title {
    font-size: var(--font-size-xl);
  }
  
  .page-subtitle {
    font-size: var(--font-size-sm);
  }
  
  /* 卡片移动端适配 */
  .card {
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  .card-body {
    padding: var(--spacing-3);
  }
  
  /* 按钮移动端适配 */
  .btn {
    padding: var(--spacing-3) var(--spacing-4);
    font-size: var(--font-size-sm);
  }
  
  .btn-sm {
    padding: var(--spacing-2) var(--spacing-3);
    font-size: var(--font-size-xs);
  }
  
  /* 输入框移动端适配 */
  .input {
    padding: var(--spacing-3);
    font-size: var(--font-size-sm);
  }
  
  /* 模态框移动端适配 */
  .modal {
    margin: var(--spacing-3);
    max-width: calc(100% - 2 * var(--spacing-3));
  }
  
  .modal-fullscreen {
    width: 100%;
    height: 100%;
    border-radius: 0;
    margin: 0;
  }
  
  /* 表格移动端适配 */
  .table-responsive {
    overflow-x: auto;
  }
  
  .table-mobile {
    display: block;
  }
  
  .table-mobile thead {
    display: none;
  }
  
  .table-mobile tbody,
  .table-mobile tr,
  .table-mobile td {
    display: block;
    width: 100%;
  }
  
  .table-mobile tr {
    margin-bottom: var(--spacing-4);
    border: 1px solid var(--neutral-200);
    border-radius: 8px;
    padding: var(--spacing-3);
  }
  
  .table-mobile td {
    text-align: left;
    padding: var(--spacing-2) 0;
    border: none;
  }
  
  .table-mobile td:before {
    content: attr(data-label) ': ';
    font-weight: var(--font-weight-medium);
    color: var(--neutral-700);
  }
}

/* 平板端适配 */
@media (min-width: 768px) and (max-width: 991px) {
  .container-tablet { max-width: 720px; }
  
  /* 网格系统调整 */
  .grid-tablet-2 { grid-template-columns: repeat(2, 1fr); }
  .grid-tablet-3 { grid-template-columns: repeat(3, 1fr); }
  
  /* 导航栏平板端适配 */
  .navbar {
    padding: var(--spacing-3) var(--spacing-4);
  }
  
  /* 侧边栏平板端适配 */
  .sidebar {
    width: 240px;
  }
  
  /* 卡片平板端适配 */
  .card-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: var(--spacing-4);
  }
}
```

### 11.3 触摸优化

```css
/* 触摸目标大小 */
.touch-target {
  min-width: 44px;
  min-height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 触摸反馈 */
.touch-feedback {
  transition: all 0.1s ease;
  user-select: none;
  -webkit-tap-highlight-color: transparent;
}

.touch-feedback:active {
  transform: scale(0.97);
  opacity: 0.8;
}

/* 滚动优化 */
.scroll-smooth {
  scroll-behavior: smooth;
  -webkit-overflow-scrolling: touch;
}

/* 手势支持 */
.swipe-container {
  touch-action: pan-y;
  overscroll-behavior: contain;
}

.swipe-horizontal {
  touch-action: pan-x;
}

.swipe-vertical {
  touch-action: pan-y;
}

/* 防止缩放 */
.no-zoom {
  touch-action: manipulation;
}

/* 移动端输入优化 */
@media (max-width: 767px) {
  .input-mobile {
    font-size: 16px; /* 防止iOS缩放 */
  }
  
  .input-mobile:focus {
    transform: scale(1);
  }
}
```

---

## 12. 无障碍设计

### 12.1 颜色对比度

```css
/* 确保充足的颜色对比度 */
:root {
  /* 文本对比度 - 至少 4.5:1 */
  --text-primary: #212121;        /* 对比度 16:1 */
  --text-secondary: #757575;      /* 对比度 4.54:1 */
  --text-disabled: #9E9E9E;       /* 对比度 2.85:1 */
  
  /* 背景对比度 */
  --bg-primary: #FFFFFF;
  --bg-secondary: #F5F5F5;
  --bg-disabled: #EEEEEE;
  
  /* 链接对比度 */
  --link-color: #1976D2;          /* 对比度 5.14:1 */
  --link-hover: #1565C0;          /* 对比度 5.77:1 */
  --link-visited: #7B1FA2;        /* 对比度 4.69:1 */
  
  /* 状态颜色对比度 */
  --success-accessible: #2E7D32;  /* 对比度 5.25:1 */
  --warning-accessible: #F57F17;  /* 对比度 4.52:1 */
  --error-accessible: #C62828;    /* 对比度 5.89:1 */
}

/* 高对比度模式 */
@media (prefers-contrast: high) {
  :root {
    --text-primary: #000000;
    --text-secondary: #000000;
    --bg-primary: #FFFFFF;
    --border-color: #000000;
  }
  
  .btn-outline {
    border-width: 2px;
  }
  
  .input {
    border-width: 2px;
  }
}
```

### 12.2 焦点管理

```css
/* 焦点指示器 */
.focus-visible {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
}

.focus-ring {
  transition: box-shadow 0.2s ease;
}

.focus-ring:focus-visible {
  outline: none;
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.3);
}

/* 跳过链接 */
.skip-link {
  position: absolute;
  top: -40px;
  left: 6px;
  background: var(--primary-500);
  color: white;
  padding: 8px;
  text-decoration: none;
  z-index: 10000;
  border-radius: 4px;
}

.skip-link:focus {
  top: 6px;
}

/* 焦点陷阱 */
.modal.focus-trap {
  /* 模态框焦点管理 */
}

.modal.focus-trap .modal-content {
  /* 确保焦点在模态框内循环 */
}

/* 焦点顺序 */
.tab-sequence {
  /* 确保逻辑的Tab顺序 */
}

.tab-sequence button,
.tab-sequence input,
.tab-sequence select,
.tab-sequence textarea,
.tab-sequence a {
  /* 可聚焦元素的样式 */
}
```

### 12.3 语义化HTML

```html
<!-- 页面结构 -->
<main role="main" aria-labelledby="main-heading">
  <h1 id="main-heading">页面标题</h1>
  
  <!-- 导航区域 -->
  <nav role="navigation" aria-label="主导航">
    <ul>
      <li><a href="#" aria-current="page">首页</a></li>
      <li><a href="#">营养管理</a></li>
      <li><a href="#">订单管理</a></li>
    </ul>
  </nav>
  
  <!-- 内容区域 -->
  <section aria-labelledby="content-heading">
    <h2 id="content-heading">内容标题</h2>
    <p>内容描述</p>
  </section>
  
  <!-- 侧边栏 -->
  <aside role="complementary" aria-labelledby="sidebar-heading">
    <h3 id="sidebar-heading">相关信息</h3>
    <ul>
      <li>相关链接1</li>
      <li>相关链接2</li>
    </ul>
  </aside>
</main>

<!-- 表单 -->
<form role="form" aria-labelledby="form-heading">
  <h2 id="form-heading">用户信息</h2>
  
  <div class="form-field">
    <label for="username">用户名 <span aria-hidden="true">*</span></label>
    <input 
      type="text" 
      id="username" 
      name="username" 
      required 
      aria-describedby="username-help username-error"
      aria-invalid="false"
    >
    <div id="username-help" class="form-help">
      请输入您的用户名
    </div>
    <div id="username-error" class="form-error" role="alert" aria-live="polite">
      <!-- 错误信息 -->
    </div>
  </div>
  
  <button type="submit" aria-describedby="submit-help">
    提交
  </button>
  <div id="submit-help" class="sr-only">
    点击提交按钮完成表单提交
  </div>
</form>

<!-- 数据表格 -->
<table role="table" aria-labelledby="table-caption">
  <caption id="table-caption">
    营养数据表格，包含食物名称、卡路里、蛋白质含量
  </caption>
  <thead>
    <tr>
      <th scope="col">食物名称</th>
      <th scope="col">卡路里 (kcal)</th>
      <th scope="col">蛋白质 (g)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">鸡胸肉</th>
      <td>165</td>
      <td>31</td>
    </tr>
  </tbody>
</table>
```

### 12.4 屏幕阅读器优化

```css
/* 屏幕阅读器专用内容 */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

.sr-only-focusable:focus {
  position: static;
  width: auto;
  height: auto;
  padding: inherit;
  margin: inherit;
  overflow: visible;
  clip: auto;
  white-space: normal;
}

/* 动态内容区域 */
.live-region {
  position: absolute;
  left: -10000px;
  width: 1px;
  height: 1px;
  overflow: hidden;
}

/* 状态指示器 */
.status-indicator {
  position: relative;
}

.status-indicator::before {
  content: attr(aria-label);
  position: absolute;
  left: -10000px;
  top: auto;
  width: 1px;
  height: 1px;
  overflow: hidden;
}

/* 图标和文本 */
.icon-with-text {
  display: flex;
  align-items: center;
  gap: var(--spacing-2);
}

.icon-with-text .icon {
  flex-shrink: 0;
}

.icon-with-text .text {
  flex: 1;
}

/* 装饰性内容 */
.decorative {
  aria-hidden: true;
}

/* 必填字段指示 */
.required-indicator {
  color: var(--error-500);
  font-weight: var(--font-weight-bold);
  margin-left: var(--spacing-1);
}

.required-indicator::before {
  content: "*";
}

/* 进度指示器 */
.progress-indicator {
  position: relative;
  background: var(--neutral-200);
  border-radius: 4px;
  overflow: hidden;
}

.progress-indicator::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  background: var(--primary-500);
  width: var(--progress-width, 0%);
  transition: width 0.3s ease;
}

.progress-indicator .sr-only {
  /* 屏幕阅读器进度文本 */
}
```

---

## 13. 设计令牌

### 13.1 设计令牌定义

```json
{
  "tokens": {
    "color": {
      "primary": {
        "50": { "value": "#E8F5E8" },
        "100": { "value": "#C8E6C8" },
        "200": { "value": "#A5D6A5" },
        "300": { "value": "#81C784" },
        "400": { "value": "#66BB6A" },
        "500": { "value": "#4CAF50" },
        "600": { "value": "#43A047" },
        "700": { "value": "#388E3C" },
        "800": { "value": "#2E7D32" },
        "900": { "value": "#1B5E20" }
      },
      "secondary": {
        "50": { "value": "#E3F2FD" },
        "100": { "value": "#BBDEFB" },
        "200": { "value": "#90CAF9" },
        "300": { "value": "#64B5F6" },
        "400": { "value": "#42A5F5" },
        "500": { "value": "#2196F3" },
        "600": { "value": "#1E88E5" },
        "700": { "value": "#1976D2" },
        "800": { "value": "#1565C0" },
        "900": { "value": "#0D47A1" }
      },
      "neutral": {
        "50": { "value": "#FAFAFA" },
        "100": { "value": "#F5F5F5" },
        "200": { "value": "#EEEEEE" },
        "300": { "value": "#E0E0E0" },
        "400": { "value": "#BDBDBD" },
        "500": { "value": "#9E9E9E" },
        "600": { "value": "#757575" },
        "700": { "value": "#616161" },
        "800": { "value": "#424242" },
        "900": { "value": "#212121" }
      },
      "semantic": {
        "success": { "value": "#4CAF50" },
        "warning": { "value": "#FF9800" },
        "error": { "value": "#F44336" },
        "info": { "value": "#2196F3" }
      }
    },
    "typography": {
      "fontFamily": {
        "primary": { "value": "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif" },
        "brand": { "value": "'SF Pro Display', 'Helvetica Neue', Arial, sans-serif" },
        "mono": { "value": "'SF Mono', 'Monaco', 'Courier New', monospace" }
      },
      "fontSize": {
        "xs": { "value": "12px" },
        "sm": { "value": "14px" },
        "md": { "value": "16px" },
        "lg": { "value": "18px" },
        "xl": { "value": "20px" },
        "2xl": { "value": "24px" },
        "3xl": { "value": "30px" },
        "4xl": { "value": "36px" },
        "5xl": { "value": "48px" }
      },
      "fontWeight": {
        "light": { "value": "300" },
        "normal": { "value": "400" },
        "medium": { "value": "500" },
        "semibold": { "value": "600" },
        "bold": { "value": "700" }
      },
      "lineHeight": {
        "tight": { "value": "1.25" },
        "snug": { "value": "1.375" },
        "normal": { "value": "1.5" },
        "relaxed": { "value": "1.625" },
        "loose": { "value": "2" }
      }
    },
    "spacing": {
      "0": { "value": "0px" },
      "1": { "value": "4px" },
      "2": { "value": "8px" },
      "3": { "value": "12px" },
      "4": { "value": "16px" },
      "5": { "value": "20px" },
      "6": { "value": "24px" },
      "8": { "value": "32px" },
      "10": { "value": "40px" },
      "12": { "value": "48px" },
      "16": { "value": "64px" },
      "20": { "value": "80px" },
      "24": { "value": "96px" },
      "32": { "value": "128px" }
    },
    "borderRadius": {
      "none": { "value": "0px" },
      "sm": { "value": "4px" },
      "md": { "value": "8px" },
      "lg": { "value": "12px" },
      "xl": { "value": "16px" },
      "2xl": { "value": "24px" },
      "full": { "value": "9999px" }
    },
    "shadow": {
      "sm": { "value": "0 1px 2px rgba(0, 0, 0, 0.05)" },
      "md": { "value": "0 4px 6px rgba(0, 0, 0, 0.07)" },
      "lg": { "value": "0 10px 15px rgba(0, 0, 0, 0.1)" },
      "xl": { "value": "0 20px 25px rgba(0, 0, 0, 0.1)" },
      "2xl": { "value": "0 25px 50px rgba(0, 0, 0, 0.25)" }
    },
    "breakpoint": {
      "xs": { "value": "0px" },
      "sm": { "value": "576px" },
      "md": { "value": "768px" },
      "lg": { "value": "992px" },
      "xl": { "value": "1200px" },
      "2xl": { "value": "1400px" }
    }
  }
}
```

### 13.2 令牌使用规范

```yaml
命名规范:
  - 类别-属性-变体-状态
  - 示例: color-primary-500, spacing-4, typography-body-large
  - 使用小写字母和连字符
  - 避免使用缩写和专有名词

组织结构:
  - 按功能分组: color, typography, spacing, etc.
  - 按层级排序: 50, 100, 200, ..., 900
  - 按重要性排序: primary, secondary, tertiary
  - 按状态排序: default, hover, active, disabled

版本控制:
  - 使用语义化版本号
  - 记录变更历史
  - 提供迁移指南
  - 保持向后兼容性

平台适配:
  - Web: CSS Custom Properties
  - iOS: Swift/Objective-C
  - Android: XML/Kotlin
  - Flutter: Dart
```

### 13.3 令牌工具链

```javascript
// 设计令牌构建工具
const StyleDictionary = require('style-dictionary');

// 配置
const config = {
  source: ['tokens/**/*.json'],
  platforms: {
    css: {
      transformGroup: 'css',
      buildPath: 'build/css/',
      files: [{
        destination: 'variables.css',
        format: 'css/variables'
      }]
    },
    js: {
      transformGroup: 'js',
      buildPath: 'build/js/',
      files: [{
        destination: 'tokens.js',
        format: 'javascript/es6'
      }]
    },
    flutter: {
      transformGroup: 'flutter',
      buildPath: 'build/flutter/',
      files: [{
        destination: 'tokens.dart',
        format: 'flutter/class.dart'
      }]
    }
  }
};

// 构建
StyleDictionary.extend(config).buildAllPlatforms();
```

---

## 14. 设计资源

### 14.1 设计文件结构

```
design-system/
├── tokens/                    # 设计令牌
│   ├── color.json
│   ├── typography.json
│   ├── spacing.json
│   └── components.json
├── components/                # 组件库
│   ├── buttons/
│   │   ├── button.fig
│   │   ├── button-states.fig
│   │   └── button-variants.fig
│   ├── forms/
│   │   ├── input.fig
│   │   ├── select.fig
│   │   └── checkbox.fig
│   ├── navigation/
│   │   ├── navbar.fig
│   │   ├── sidebar.fig
│   │   └── breadcrumb.fig
│   └── data-display/
│       ├── table.fig
│       ├── card.fig
│       └── list.fig
├── templates/                 # 页面模板
│   ├── login.fig
│   ├── dashboard.fig
│   ├── profile.fig
│   └── settings.fig
├── icons/                     # 图标库
│   ├── core-icons.fig
│   ├── nutrition-icons.fig
│   └── status-icons.fig
├── assets/                    # 设计资源
│   ├── logos/
│   ├── illustrations/
│   └── photos/
└── documentation/             # 文档
    ├── usage-guidelines.md
    ├── component-specs.md
    └── brand-guidelines.md
```

### 14.2 组件规范文档

```markdown
# 按钮组件规范

## 概述
按钮是用户与应用交互的主要方式，用于触发操作、提交表单、导航等。

## 设计原则
- 清晰的视觉层次
- 一致的交互行为
- 适当的触摸目标大小
- 明确的状态反馈

## 变体类型

### 主要按钮 (Primary Button)
- 用途: 页面中最重要的操作
- 样式: 实心背景，白色文字
- 数量: 每个页面最多1个

### 次要按钮 (Secondary Button)
- 用途: 次要操作或取消操作
- 样式: 实心背景，较淡的颜色
- 数量: 不限制

### 轮廓按钮 (Outline Button)
- 用途: 第三级操作
- 样式: 透明背景，有边框
- 数量: 不限制

### 文字按钮 (Text Button)
- 用途: 最低优先级操作
- 样式: 无背景，仅文字
- 数量: 不限制

## 尺寸规格

### 小按钮 (Small)
- 高度: 32px
- 内边距: 8px 12px
- 字体大小: 12px
- 使用场景: 表格操作、卡片操作

### 中按钮 (Medium)
- 高度: 40px
- 内边距: 12px 16px
- 字体大小: 14px
- 使用场景: 一般操作

### 大按钮 (Large)
- 高度: 48px
- 内边距: 16px 24px
- 字体大小: 16px
- 使用场景: 重要操作、移动端

## 状态说明

### 默认状态 (Default)
- 正常显示状态
- 可点击和悬停

### 悬停状态 (Hover)
- 背景颜色变深
- 轻微上浮效果
- 阴影增强

### 激活状态 (Active)
- 按下时的状态
- 背景颜色最深
- 向下轻微移动

### 禁用状态 (Disabled)
- 不可点击
- 透明度降低到60%
- 无悬停效果

### 加载状态 (Loading)
- 显示加载动画
- 文字隐藏
- 不可点击

## 使用指南

### 何时使用
- 需要用户进行操作时
- 提交表单时
- 导航到其他页面时
- 触发弹窗或对话框时

### 最佳实践
- 使用动词描述按钮功能
- 保持文字简洁明了
- 确保足够的对比度
- 提供清晰的状态反馈

### 避免使用
- 不要使用模糊的文字如"点击这里"
- 不要在同一视图中使用过多主按钮
- 不要让按钮过于拥挤
- 不要使用过长的文字

## 代码示例

```html
<!-- 主按钮 -->
<button class="btn btn-primary">确认提交</button>

<!-- 次要按钮 -->
<button class="btn btn-secondary">取消</button>

<!-- 轮廓按钮 -->
<button class="btn btn-outline">查看详情</button>

<!-- 文字按钮 -->
<button class="btn btn-text">编辑</button>

<!-- 大小变体 -->
<button class="btn btn-primary btn-sm">小按钮</button>
<button class="btn btn-primary btn-md">中按钮</button>
<button class="btn btn-primary btn-lg">大按钮</button>

<!-- 状态变体 -->
<button class="btn btn-primary" disabled>禁用状态</button>
<button class="btn btn-primary btn-loading">加载中...</button>
```

## 设计文件
- Figma: [按钮组件库](link-to-figma)
- Sketch: [按钮设计稿](link-to-sketch)
- Adobe XD: [按钮交互原型](link-to-xd)

## 更新记录
- v1.0.0: 初始版本
- v1.1.0: 添加加载状态
- v1.2.0: 优化移动端体验
```

### 14.3 设计资源清单

```yaml
品牌资源:
  - Logo文件: SVG, PNG, AI格式
  - 品牌色彩: RGB, CMYK, HEX值
  - 字体文件: 主字体和品牌字体
  - 品牌指南: 使用规范和示例

图标资源:
  - 核心图标: 导航、功能、状态图标
  - 业务图标: 营养、餐厅、订单图标
  - 装饰图标: 插画风格图标
  - 多格式: SVG, PNG, 字体图标

插画资源:
  - 空状态插画: 无数据、无网络、404页面
  - 引导插画: 功能介绍、使用指南
  - 情感插画: 成功、失败、警告场景
  - 营养主题: 健康饮食、运动、生活方式

摄影资源:
  - 食物摄影: 高质量菜品图片
  - 生活场景: 健康生活方式图片
  - 人物摄影: 用户、营养师、厨师
  - 环境摄影: 餐厅、厨房、用餐环境

模板资源:
  - 页面模板: 登录、列表、详情页
  - 组件模板: 卡片、表单、导航
  - 邮件模板: 通知、营销邮件
  - 报告模板: 数据报告、分析图表

文档资源:
  - 设计规范: 详细的使用指南
  - 组件文档: 每个组件的规格说明
  - 交互文档: 动效和交互说明
  - 更新日志: 版本变更记录
```

---

## 总结

本UI设计系统文档提供了AI智能营养餐厅系统的完整视觉设计指南，包括：

1. **设计理念**: 健康、科技、温暖、专业的核心价值观
2. **品牌识别**: 完整的品牌视觉系统
3. **色彩系统**: 科学的色彩层级和语义化应用
4. **字体系统**: 清晰的字体等级和使用规范
5. **间距布局**: 基于8px网格的间距系统
6. **图标系统**: 统一的图标风格和使用规范
7. **组件体系**: 完整的基础和复合组件库
8. **页面模板**: 标准化的页面布局模板
9. **交互动效**: 优雅的动画和微交互效果
10. **响应式设计**: 全设备适配的设计方案
11. **无障碍设计**: 包容性设计的实现方案
12. **设计令牌**: 系统化的设计变量管理
13. **设计资源**: 完整的设计文件和资源库

这个设计系统确保了产品的视觉一致性、用户体验的连贯性，并为开发团队提供了清晰的实现指南。通过系统化的设计方法，能够高效地构建出专业、美观、易用的智能营养餐厅应用。

---

**文档状态**: ✅ 已完成，AI编码就绪  
**下一步**: 创建统一技术栈规范文档