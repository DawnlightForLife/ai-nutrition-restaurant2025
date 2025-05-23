# 项目目录结构说明

本文档详细说明智能营养餐厅App项目的目录结构和各部分文件的用途，帮助开发者快速定位和理解项目组织方式。

## 顶级目录结构

```
lib/
├── application/          # 应用层：用例和业务流程协调
├── domain/               # 领域层：抽象接口和领域模型
├── repositories/         # 仓库实现：数据访问实现
├── services/             # 服务实现：外部系统交互实现
├── providers/            # 状态管理：Provider类
├── screens/              # UI页面：应用页面组件
├── components/           # UI组件：可复用界面组件
├── models/               # 数据模型：DTO和领域模型
├── core/                 # 核心功能：通用基础设施
├── config/               # 配置文件：应用配置
├── common/               # 通用工具：工具类和扩展方法
└── main.dart             # 应用入口

test/
├── unit/                 # 单元测试：独立功能单元测试
├── component/            # 组件测试：UI组件渲染和行为测试
├── integration/          # 集成测试：多组件间交互测试
├── e2e/                  # 端到端测试：完整用户流程测试
└── mocks/                # 测试模拟：模拟对象和测试辅助工具

integration_test/         # 集成测试入口
```

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

### domain/

领域层，包含抽象接口和领域规则。

```
domain/
├── abstractions/         # 抽象接口
│   ├── repositories/     # 仓库接口
│   │   └── i_user_repository.dart
│   └── services/         # 服务接口
│       └── i_user_service.dart
└── {module}/             # 按模块分组的领域实体和规则
    └── user_entity.dart
```

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

状态管理层，包含各个功能模块的Provider。

```
providers/
├── app_providers.dart     # Provider注册中心
└── {module}/              # 按模块分组的Provider
    └── user_provider.dart
```

### screens/

UI页面层，包含应用的各个页面。

```
screens/
└── {module}/              # 按模块分组的页面
    ├── user_profile_screen.dart
    └── user_edit_screen.dart
```

### components/

UI组件层，包含可复用的界面组件。

```
components/
├── core/                  # 核心组件
│   ├── app_button.dart
│   └── app_text_field.dart
└── {module}/              # 按模块分组的组件
    └── user_avatar.dart
```

### models/

数据模型层，包含DTO和领域模型。

```
models/
├── common/                # 通用模型
│   └── api_response.dart
└── {module}/              # 按模块分组的数据模型
    └── user_model.dart
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

## 模块划分

项目按领域功能划分为多个模块，每个模块在各层都有对应的目录：

- **user**: 用户相关功能
- **nutrition**: 营养数据相关功能
- **restaurant**: 餐厅相关功能
- **order**: 订单相关功能
- **menu**: 菜单相关功能
- **consultation**: 咨询相关功能
- **notification**: 通知相关功能

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