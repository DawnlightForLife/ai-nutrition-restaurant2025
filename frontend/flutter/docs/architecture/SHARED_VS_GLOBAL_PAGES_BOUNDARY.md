# Shared 与 Global Pages 边界说明

## 概述

本文档明确了 `lib/shared/` 和 `lib/features/global_pages/` 目录的职责边界和使用规范，避免代码职责模糊和重复。

## 边界定义

### lib/shared/ - 共享基础设施层

**职责范围：**
- 跨模块的**基础设施**和**工具组件**
- 不包含业务逻辑的**纯技术组件**
- 可被任何 feature 模块复用的**底层能力**

**包含内容：**
```
lib/shared/
├── components/          # 通用UI组件（Button、Input、Loading等）
├── enums/              # 全局枚举定义
├── extensions/         # Dart扩展方法
├── utils/              # 工具类和助手函数
├── constants/          # 全局常量
├── themes/             # 主题配置
├── validators/         # 表单验证器
└── mixins/             # 通用Mixin
```

**特征：**
- ✅ 无业务逻辑
- ✅ 高度可复用
- ✅ 技术导向
- ✅ 状态无关
- ❌ 不包含页面或路由
- ❌ 不包含特定业务场景

### lib/features/global_pages/ - 全局页面模块

**职责范围：**
- 跨用户角色的**通用页面**
- 不属于特定业务域的**独立页面**
- 应用级别的**功能页面**

**包含内容：**
```
lib/features/global_pages/
├── presentation/
│   ├── pages/
│   │   ├── about_page.dart          # 关于我们
│   │   ├── privacy_policy_page.dart # 隐私政策
│   │   ├── terms_of_service_page.dart # 服务条款
│   │   ├── help_center_page.dart    # 帮助中心
│   │   ├── feedback_page.dart       # 意见反馈
│   │   ├── settings_page.dart       # 应用设置
│   │   └── splash_page.dart         # 启动页
│   ├── providers/       # 全局页面状态管理
│   ├── router/          # 全局页面路由
│   └── widgets/         # 全局页面专用组件
├── domain/              # 全局页面业务逻辑
├── data/                # 全局页面数据层
└── README.md
```

**特征：**
- ✅ 包含完整页面
- ✅ 跨角色通用
- ✅ 独立业务逻辑
- ✅ 有状态管理
- ❌ 不是基础设施
- ❌ 不是纯技术组件

## 使用规范

### 1. 组件放置规则

#### 放入 shared/ 的情况：
```dart
// ✅ 通用UI组件
class AppButton extends StatelessWidget { ... }

// ✅ 工具类
class DateTimeUtils { ... }

// ✅ 全局枚举
enum UserRole { user, merchant, admin }

// ✅ 扩展方法
extension StringExtension on String { ... }
```

#### 放入 global_pages/ 的情况：
```dart
// ✅ 通用页面
class AboutPage extends StatelessWidget { ... }

// ✅ 全局页面的状态管理
class SettingsController extends AsyncNotifier<SettingsState> { ... }

// ✅ 全局页面专用组件（不会被其他模块复用）
class PrivacyPolicySection extends StatelessWidget { ... }
```

### 2. 导入规则

#### shared 组件的导入：
```dart
// ✅ 任何模块都可以导入 shared
import 'package:app/shared/components/app_button.dart';
import 'package:app/shared/utils/date_utils.dart';
import 'package:app/shared/enums/user_role.dart';
```

#### global_pages 的导入：
```dart
// ✅ 通过路由导航访问
context.router.push(const AboutRoute());

// ❌ 不应该直接导入页面组件
import 'package:app/features/global_pages/presentation/pages/about_page.dart';
```

### 3. 依赖方向

```
┌─────────────────┐
│   Features      │
│   Modules       │ ────────┐
└─────────────────┘         │
                           │
┌─────────────────┐         │
│  global_pages   │ ────────┼──► ┌─────────────────┐
└─────────────────┘         │    │     shared      │
                           │    └─────────────────┘
┌─────────────────┐         │
│      core       │ ────────┘
└─────────────────┘
```

**依赖规则：**
- ✅ 所有模块可以依赖 `shared`
- ✅ `global_pages` 可以依赖 `shared`
- ❌ `shared` 不应该依赖任何 feature 模块
- ❌ 其他 feature 模块不应该直接依赖 `global_pages`

## 判断标准

### 放入 shared/ 的判断标准：

1. **可复用性**：是否会被多个模块使用？
2. **业务无关性**：是否与具体业务逻辑无关？
3. **技术导向**：是否是纯技术实现？
4. **无状态性**：是否不包含复杂状态管理？

### 放入 global_pages/ 的判断标准：

1. **页面完整性**：是否是一个完整的页面？
2. **跨角色通用性**：是否被所有用户角色使用？
3. **独立性**：是否不属于特定业务域？
4. **应用级功能**：是否是应用级别的功能？

## 示例场景

### 场景1：用户反馈功能

**错误做法：**
```dart
// ❌ 放在 shared/ - 这是页面不是组件
lib/shared/pages/feedback_page.dart

// ❌ 放在 user/ - 不只是用户模块使用
lib/features/user/presentation/pages/feedback_page.dart
```

**正确做法：**
```dart
// ✅ 放在 global_pages/ - 跨角色的通用页面
lib/features/global_pages/presentation/pages/feedback_page.dart

// ✅ 如果有通用的反馈组件，可以放在 shared/
lib/shared/components/feedback_form.dart
```

### 场景2：日期选择器

**错误做法：**
```dart
// ❌ 放在特定模块 - 应该共享
lib/features/order/presentation/widgets/date_picker.dart
```

**正确做法：**
```dart
// ✅ 放在 shared/ - 通用UI组件
lib/shared/components/app_date_picker.dart
```

### 场景3：应用设置页面

**错误做法：**
```dart
// ❌ 放在 shared/ - 这是页面不是组件
lib/shared/pages/settings_page.dart

// ❌ 放在 user/ - 不只是用户设置
lib/features/user/presentation/pages/settings_page.dart
```

**正确做法：**
```dart
// ✅ 放在 global_pages/ - 应用级设置页面
lib/features/global_pages/presentation/pages/settings_page.dart
```

## 迁移指南

如果发现组件放置错误，按以下步骤迁移：

1. **评估影响范围**：检查有哪些文件导入了该组件
2. **创建新位置**：在正确的目录创建文件
3. **更新导入路径**：修改所有导入该组件的文件
4. **运行测试**：确保迁移后功能正常
5. **删除旧文件**：清理原来的错误位置

## 总结

- **shared/**：技术基础设施，面向代码复用
- **global_pages/**：业务页面模块，面向用户功能

明确这两个目录的边界有助于：
- 提高代码组织的清晰度
- 减少循环依赖的风险
- 提升代码的可维护性
- 便于团队协作和代码审查