# 项目目录结构说明

本文档详细说明智能营养餐厅App项目的目录结构和各部分文件的用途，帮助开发者快速定位和理解项目组织方式。

## 顶级目录结构

```
lib/
├── app/                  # 应用启动和主入口（如 app.dart, router.dart）
├── config/               # 全局配置（主题、环境等）
├── common/               # 公共工具（常量、样式、通用组件等）
├── modules/              # 主要功能模块（每个模块下含 models, screens, services 等）
├── services/             # 第三方/全局服务（如 OpenAPI 生成代码）
├── providers/            # 全局 Provider 注册
├── hooks/                # 自定义 Hook
├── l10n/                 # 国际化资源文件
├── gen/                  # 自动生成资源文件（flutter_gen）
├── environment/          # 多环境配置
├── mason_bricks/         # mason 模板
└── application/          # 可选：DDD 架构的应用层协调器
```

注：当前结构采用模块化设计，每个功能模块集中在 `modules/` 下，统一包含 models、providers、screens、services、widgets 等子目录。

test/
├── unit/                 # 单元测试：独立功能单元测试
├── component/            # 组件测试：UI组件渲染和行为测试
├── integration/          # 集成测试：多组件间交互测试
├── e2e/                  # 端到端测试：完整用户流程测试
└── mocks/                # 测试模拟：模拟对象和测试辅助工具

integration_test/         # 集成测试入口


## 目录详细说明

### application/

应用层，包含业务用例实现和协调器。

```
application/
├── core/                 # 核心用例组件
│   ├── use_case.dart     # 基础用例抽象类
│   └── result.dart       # 结果处理类
├── app_use_cases.dart    # 用例协调器工厂
└── {module}/             # 按模块分组的用例
    ├── get_data_use_case.dart
    └── update_data_use_case.dart
```

### modules/

主要功能模块，按领域功能划分。每个模块内部统一管理其数据模型（models）、页面（screens）、服务（services）、状态管理（providers）、组件（widgets）等。

示例结构：

```
modules/
└── {module}/
    ├── models/           # 数据模型
    ├── providers/        # 状态管理Provider
    ├── screens/          # UI页面
    ├── services/         # 服务实现
    ├── widgets/          # 可复用组件
    └── ...               # 其他模块相关目录
```

模块示例：

- user: 用户相关功能
- nutrition: 营养数据相关功能
- restaurant: 餐厅相关功能
- order: 订单相关功能
- menu: 菜单相关功能
- consultation: 咨询相关功能
- notification: 通知相关功能

### repositories/

仓库实现，负责数据访问和持久化。

```
repositories/
└── {module}/             # 按模块分组的仓库实现
    └── user_repository.dart
```

### services/

服务实现，处理外部系统交互。

```
services/
├── core/                 # 核心服务
│   └── api_service.dart  # 网络请求服务
└── {module}/             # 按模块分组的服务实现
    └── user_service.dart
```

### providers/

状态管理层，包含各个功能模块的Provider注册。

```
providers/
├── app_providers.dart     # Provider注册中心
└── {module}/              # 按模块分组的Provider
    └── user_provider.dart
```

### core/

核心功能层，包含通用基础设施。

```
core/
├── di/                    # 依赖注入
│   ├── injection.dart
│   └── service_locator.dart
├── navigation/            # 路由导航
│   └── app_router.dart
└── utils/                 # 工具类
    └── validators.dart
```

### config/

配置文件层，包含应用配置。

```
config/
├── app_config.dart        # 应用全局配置
├── theme_config.dart      # 主题配置
└── di_config.dart         # 依赖注入配置
```

### common/

通用工具层，包含工具类和扩展方法。

```
common/
├── exceptions/            # 自定义异常
│   └── api_exception.dart
├── extensions/            # 扩展方法
│   └── string_extensions.dart
└── logger/                # 日志工具
    └── logger.dart
```

## 命名约定

- **文件命名**：使用小写字母和下划线分隔，如`user_repository.dart`
- **接口命名**：使用`i_`前缀，如`i_user_repository.dart`
- **用例命名**：使用动词+名词+`_use_case`后缀，如`get_user_profile_use_case.dart`
- **Provider命名**：使用名词+`_provider`后缀，如`user_provider.dart`
- **页面命名**：使用名词+`_screen`后缀，如`user_profile_screen.dart`
- **测试文件命名**：使用被测单元名+`_test`后缀，如`user_repository_test.dart`

## 测试目录结构

测试目录遵循测试金字塔原则组织：

```
test/
├── unit/                 # 单元测试
│   ├── application/      # 应用层用例测试
│   ├── repositories/     # 仓库实现测试
│   ├── services/         # 服务实现测试
│   └── models/           # 模型测试
│
├── component/            # 组件测试
│   └── {module}/         # 按模块分组的组件测试
│
├── integration/          # 集成测试
│   ├── repositories/     # 仓库集成测试
│   ├── services/         # 服务集成测试
│   └── screens/          # 屏幕集成测试
│
├── e2e/                  # 端到端测试
│   └── flows/            # 用户流程测试
│
└── mocks/                # 测试模拟对象
    └── {module}/         # 按模块分组的模拟对象
```

## 文件模板位置

标准代码模板位于：`docs/architecture/code_templates.md`

测试代码模板位于：`test/README.md`

这些模板提供了创建新文件时的标准格式，确保代码风格一致性。