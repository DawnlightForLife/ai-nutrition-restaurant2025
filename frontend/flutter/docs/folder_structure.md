# 项目目录结构说明

本文档详细说明智能营养餐厅App项目的目录结构和各部分文件的用途，帮助开发者快速定位和理解项目组织方式。

## 顶级目录结构

```
lib/
├── application/          # 应用层：用例和业务流程协调
│   ├── facades/          # 模块Facade接口
│   ├── services/         # 应用服务（事件总线等）
│   └── event_handlers/   # 事件处理器
├── domain/               # 领域层：抽象接口和领域模型
│   ├── events/           # 领域事件
│   └── common/           
│       ├── failures/     # 失败类型定义
│       └── facade/       # Facade基础接口
├── infrastructure/       # 基础设施层：技术实现
│   ├── repositories/     # 仓库实现
│   ├── dtos/             # 数据传输对象
│   │   └── generated/    # OpenAPI生成的DTO
│   ├── mappers/          # DTO-Entity映射器
│   │   └── generated/    # 自动生成的Mapper
│   └── api/              # API相关
│       ├── error_handler.dart # 统一错误处理
│       └── generated/    # OpenAPI生成的客户端
├── presentation/         # 表现层：UI和状态管理
│   ├── screens/          # UI页面
│   ├── components/       # UI组件
│   │   └── charts/       # 图表组件
│   ├── providers/        # 状态管理
│   │   ├── {module}/     # Provider模式
│   │   └── riverpod/     # Riverpod模式
│   └── viewmodels/       # 视图模型
├── repositories/         # 仓库实现（保留兼容）
├── services/             # 服务实现（保留兼容）
├── models/               # 数据模型（保留兼容）
├── core/                 # 核心功能：通用基础设施
├── config/               # 配置文件：应用配置
├── common/               # 通用工具：工具类和扩展方法
├── widgetbook/           # 组件预览系统
└── main.dart             # 应用入口

test/
├── unit/                 # 单元测试：独立功能单元测试
├── component/            # 组件测试：UI组件渲染和行为测试
├── integration/          # 集成测试：多组件间交互测试
├── e2e/                  # 端到端测试：完整用户流程测试
├── golden/               # Golden测试：UI一致性测试
├── modules/              # 模块化测试套件
└── fixtures/             # 测试夹具：Mock数据生成器

scripts/                  # 自动化脚本
├── generate-openapi-models.sh  # 生成DTO和API客户端
├── generate-mappers.sh         # 生成Mapper
├── sync-backend-models.sh      # 同步后端模型
├── clean-rebuild.sh            # 清理重建
└── run-tests.sh                # 运行测试

docs/                     # 项目文档
├── architecture_guidelines.md   # 架构规范
├── ARCHITECTURE_FREEZE.md      # 架构冻结文档
└── ...其他文档
```

## 目录详细说明

### application/

应用层，包含业务用例实现、模块Facade和事件处理。

```
application/
├── core/                 # 核心用例组件
│   ├── use_case.dart     # 基础用例抽象类
│   └── result.dart       # 结果处理类
├── facades/              # 模块Facade实现
│   ├── user_facade.dart  # 用户模块Facade
│   ├── nutrition_facade.dart # 营养模块Facade
│   └── restaurant_facade.dart # 餐厅模块Facade
├── services/             # 应用服务
│   └── event_bus.dart    # 领域事件总线
├── event_handlers/       # 事件处理器
│   └── {module}_event_handler.dart
├── app_use_cases.dart    # 用例协调器工厂
└── {module}/             # 按模块分组的用例
    ├── get_data_use_case.dart
    └── update_data_use_case.dart
```

### domain/

领域层，包含抽象接口、领域事件和领域规则。

```
domain/
├── abstractions/         # 抽象接口
│   ├── repositories/     # 仓库接口
│   │   └── i_user_repository.dart
│   └── services/         # 服务接口
│       └── i_user_service.dart
├── events/               # 领域事件
│   ├── base_event.dart   # 事件基类
│   └── {module}/         # 模块事件
│       └── user_logged_in_event.dart
├── common/               # 通用领域组件
│   ├── failures/         # 失败类型定义
│   │   └── app_failure.dart
│   └── facade/           # Facade接口
│       └── module_facade.dart
└── {module}/             # 按模块分组的领域实体和规则
    └── user_entity.dart
```

### infrastructure/

基础设施层，包含技术实现细节。

```
infrastructure/
├── repositories/         # 仓库实现
│   └── {module}/         # 按模块分组
│       └── user_repository_impl.dart
├── dtos/                 # 数据传输对象
│   ├── generated/        # OpenAPI生成的DTO
│   │   └── models/       # 生成的模型文件
│   └── {module}/         # 手动创建的DTO
│       └── user_dto.dart
├── mappers/              # DTO-Entity映射器
│   ├── base_mapper.dart  # 映射器基类
│   ├── generated/        # 自动生成的Mapper
│   │   └── {module}_mapper.dart
│   └── {module}/         # 手动创建的Mapper
│       └── user_mapper.dart
└── api/                  # API相关
    ├── error_handler.dart # 统一错误处理
    ├── generated/        # OpenAPI生成的客户端
    │   └── api/          # API客户端文件
    └── interceptors/     # 请求拦截器
        └── auth_interceptor.dart
```

### repositories/

仓库实现，负责数据访问和持久化（保留以支持向后兼容）。

```
repositories/
└── {module}/             # 按模块分组的仓库实现
    └── user_repository.dart
```

> 注意：新的仓库实现应放在 `infrastructure/repositories/` 目录下

### services/

服务实现，处理外部系统交互。

```
services/
├── core/                 # 核心服务
│   └── api_service.dart  # 网络请求服务
└── {module}/             # 按模块分组的服务实现
    └── user_service.dart
```

### presentation/

表现层，包含UI组件和状态管理。

#### providers/

状态管理层，支持Provider和Riverpod两种模式。

```
presentation/
├── providers/             # 状态管理
│   ├── app_providers.dart # Provider注册中心
│   ├── {module}/          # Provider模式（保留兼容）
│   │   └── user_provider.dart
│   └── riverpod/          # Riverpod模式（新推荐）
│       ├── {module}/      # 按模块分组
│       │   ├── user_state_provider.dart
│       │   └── user_async_notifier.dart
│       └── providers.dart # Riverpod注册中心
├── viewmodels/            # 视图模型
│   └── {module}/          # 按模块分组
│       └── user_viewmodel.dart
└── widgets/               # 可复用组件
    └── charts/            # 图表组件
        ├── unified_chart.dart # 统一图表组件
        └── chart_types.dart   # 图表类型定义
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
├── charts/                # 图表组件
│   ├── unified_chart.dart # 统一图表组件
│   ├── chart_types.dart   # 图表类型定义
│   └── chart_themes.dart  # 图表主题配置
└── {module}/              # 按模块分组的组件
    └── user_avatar.dart
```

### models/

数据模型层，包含DTO和领域模型（保留以支持向后兼容）。

```
models/
├── common/                # 通用模型
│   └── api_response.dart
└── {module}/              # 按模块分组的数据模型
    └── user_model.dart
```

> 注意：新的DTO应放在 `infrastructure/dtos/` 目录下，领域模型应放在 `domain/{module}/` 目录下

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
├── logger/                # 日志工具
│   └── logger.dart
└── test_utils/            # 测试工具
    ├── golden_test_utils.dart # Golden测试工具
    └── mock_generators.dart    # Mock生成器
```

### widgetbook/

组件预览系统，用于独立开发和测试UI组件。

```
widgetbook/
├── widgetbook.dart        # Widgetbook入口
├── use_cases/             # 组件用例
│   └── {module}/          # 按模块分组
│       └── user_avatar_use_case.dart
└── themes/                # 主题配置
    └── app_theme_addon.dart
```

### scripts/

自动化脚本，包含代码生成和同步工具。

```
scripts/
├── generate-openapi-models.sh  # 生成DTO和API客户端
├── generate-mappers.sh         # 生成Mapper代码
├── sync-backend-models.sh      # 同步后端模型
├── clean-rebuild.sh            # 清理重建项目
├── run-tests.sh                # 运行测试套件
└── update-golden-tests.sh      # 更新Golden测试
```

## 命名约定

- **文件命名**：使用小写字母和下划线分隔，如`user_repository.dart`
- **接口命名**：使用`i_`前缀，如`i_user_repository.dart`
- **用例命名**：使用动词+名词+`_use_case`后缀，如`get_user_profile_use_case.dart`
- **Provider命名**：使用名词+`_provider`后缀，如`user_provider.dart`
- **Riverpod命名**：
  - StateNotifier: 使用名词+`_notifier`后缀，如`user_notifier.dart`
  - AsyncNotifier: 使用名词+`_async_notifier`后缀，如`user_async_notifier.dart`
- **Facade命名**：使用名词+`_facade`后缀，如`user_facade.dart`
- **Mapper命名**：使用名词+`_mapper`后缀，如`user_mapper.dart`
- **DTO命名**：使用名词+`_dto`后缀，如`user_dto.dart`
- **事件命名**：使用过去式动词+名词+`_event`后缀，如`user_logged_in_event.dart`
- **页面命名**：使用名词+`_screen`后缀，如`user_profile_screen.dart`
- **测试文件命名**：使用被测单元名+`_test`后缀，如`user_repository_test.dart`
- **Golden测试命名**：使用组件名+`_golden_test`后缀，如`user_avatar_golden_test.dart`

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
│   ├── domain/           # 领域层测试
│   ├── infrastructure/   # 基础设施层测试
│   │   ├── mappers/      # Mapper测试
│   │   └── repositories/ # 仓库实现测试
│   ├── services/         # 服务实现测试
│   └── models/           # 模型测试
│
├── component/            # 组件测试
│   └── {module}/         # 按模块分组的组件测试
│
├── integration/          # 集成测试
│   ├── facades/          # Facade集成测试
│   ├── repositories/     # 仓库集成测试
│   ├── services/         # 服务集成测试
│   └── screens/          # 屏幕集成测试
│
├── e2e/                  # 端到端测试
│   └── flows/            # 用户流程测试
│
├── golden/               # Golden测试
│   ├── components/       # 组件Golden测试
│   └── goldens/          # Golden文件存储
│
├── modules/              # 模块化测试套件
│   └── {module}/         # 按模块组织的完整测试
│       ├── unit/         # 模块单元测试
│       ├── integration/  # 模块集成测试
│       └── e2e/          # 模块端到端测试
│
├── fixtures/             # 测试夹具
│   ├── mock_generators/  # Mock生成器
│   └── test_data/        # 测试数据
│
└── mocks/                # 测试模拟对象
    └── {module}/         # 按模块分组的模拟对象
```

## 文件模板位置

标准代码模板位于：`docs/architecture/code_templates.md`

测试代码模板位于：`test/README.md`

这些模板提供了创建新文件时的标准格式，确保代码风格一致性。 