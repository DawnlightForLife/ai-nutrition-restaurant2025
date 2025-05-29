# 模块边界强化指南

## 概述

本文档定义了 Flutter 项目中的模块边界规则和最佳实践，确保架构的清晰性和可维护性。

## 模块层次结构

```
lib/
├── config/              # 应用配置层
├── core/                # 核心基础设施层
│   ├── base/           # 基础抽象类
│   ├── di/             # 依赖注入
│   ├── error/          # 错误处理
│   ├── events/         # 事件系统
│   ├── network/        # 网络基础设施
│   ├── router/         # 路由基础设施
│   ├── utils/          # 工具类
│   └── widgets/        # 核心组件
├── features/           # 功能模块层
│   └── [module]/       # 具体功能模块
│       ├── di/         # 模块依赖注入
│       ├── application/# 应用层（Facade/UseCase）
│       ├── domain/     # 领域层
│       ├── data/       # 数据层
│       └── presentation/# 展示层
└── shared/             # 共享资源层
    ├── domain/         # 共享领域模型
    │   └── value_objects/  # 值对象
    ├── data/           # 共享数据层
    │   └── dtos/      # 数据传输对象
    ├── enums/          # 全局枚举
    ├── l10n/           # 国际化
    ├── theme/          # 主题
    └── widgets/        # 共享组件
```

## 模块依赖规则

### 1. 依赖方向

```
┌─────────────────┐
│   Presentation  │ ──┐
├─────────────────┤   │
│   Application   │   ├──► Domain
├─────────────────┤   │
│      Data       │ ──┘
└─────────────────┘
         │
         ▼
    Core & Shared
```

### 2. 允许的依赖

| 层级 | 可以依赖 | 不能依赖 |
|------|----------|----------|
| Presentation | Application, Domain, Core, Shared | Data, 其他模块的 Presentation |
| Application | Domain, Core, Shared/DTOs | Data, Presentation |
| Domain | Core (仅接口), Shared/ValueObjects | Application, Data, Presentation |
| Data | Domain, Core, Shared/DTOs | Application, Presentation |
| Core | 无 | Features, Shared |
| Shared | Core | Features |

### 3. 跨模块通信

**❌ 错误方式：**
```dart
// 在 auth 模块直接导入 user 模块
import 'package:app/features/user/domain/entities/user_profile.dart';
```

**✅ 正确方式：**
```dart
// 通过事件总线通信
CentralizedEventBus.instance.publish(UserLoggedInEvent(userId: userId));

// 或通过共享的领域模型
import 'package:app/shared/domain/entities/user_info.dart';

// 使用值对象处理业务数据
import 'package:app/shared/domain/value_objects/phone_number.dart';

// 使用DTO进行API数据传输
import 'package:app/shared/data/dtos/base_dto.dart';
```

## 文件组织规范

### 1. 依赖注入文件

每个模块必须有独立的 DI 配置：
```
features/[module]/di/
├── [module]_injection.dart     # 模块依赖注入
└── [module]_providers.dart     # Provider 定义
```

### 2. 导出文件规范

**Presentation 层导出：**
```dart
// features/auth/presentation/providers/auth_providers.dart
export 'auth_controller.dart';
export 'auth_state.dart';
// 不导出内部实现细节
```

**Domain 层导出：**
```dart
// features/auth/domain/auth_domain.dart
export 'entities/auth_user.dart';
export 'repositories/auth_repository.dart';
export 'usecases/login_usecase.dart';
// 不导出实现类
```

### 3. 命名规范

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| UseCase | [Action][Entity]UseCase | LoginUserUseCase |
| Repository | [Module]Repository | AuthRepository |
| Facade | [Module]Facade | AuthFacade |
| Controller | [Module]Controller | AuthController |
| Provider | [entity]Provider | authStateProvider |
| ValueObject | [Property] | PhoneNumber, Email |
| DTO | [Entity]Dto | UserDto, OrderDto |
| Plugin | [Service]Plugin | AlipayPlugin |
| Hook | [Action]Hook | beforeUserLoginHook |

## 强制执行措施

### 1. 分析规则配置

在 `analysis_options.yaml` 中添加：
```yaml
analyzer:
  errors:
    # 将导入违规设为错误
    depend_on_referenced_packages: error
    implementation_imports: error
    
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    
linter:
  rules:
    - avoid_relative_lib_imports
    - always_use_package_imports
```

### 2. 自定义 Lint 规则

创建自定义规则检查跨模块依赖：
```dart
// tools/custom_lints/no_cross_module_imports.dart
class NoCrossModuleImports extends DartLintRule {
  // 检查 features/[moduleA] 不能导入 features/[moduleB]
}
```

### 3. CI/CD 检查

在 CI 流程中添加架构检查：
```yaml
- name: Check Architecture Boundaries
  run: |
    dart run tools/check_boundaries.dart
    dart analyze --fatal-infos
```

## 迁移指南

### 现有违规的处理

1. **识别违规：** 运行 `dart run tools/find_cross_module_imports.dart`
2. **评估影响：** 确定需要共享的代码
3. **重构代码：**
   - 将共享实体移至 `shared/domain/`
   - 使用事件总线替代直接调用
   - 创建应用层 Facade 聚合跨模块逻辑
4. **验证修复：** 重新运行边界检查

### 新功能开发

1. **创建模块结构：** 使用脚手架工具 `dart run tools/create_module.dart [module_name]`
2. **定义依赖注入：** 在 `di/` 目录创建注入配置
3. **定义值对象：** 在 `domain/value_objects/` 创建业务数据验证
4. **定义DTO：** 在 `data/dtos/` 创建API数据传输对象
5. **实现功能：** 遵循 Clean Architecture 层次
6. **配置插件：** 如需第三方服务，实现插件接口
7. **注册钩子：** 在适当位置添加生命周期钩子
8. **添加测试：** 为每层添加相应测试
9. **文档更新：** 更新模块 README

## 最佳实践

### 1. 模块内聚性

- 每个模块应该是高内聚的
- 相关功能放在同一模块
- 避免过度拆分

### 2. 接口隔离

- Domain 层只定义接口
- Data 层实现具体逻辑
- Presentation 层通过 Application 层访问

### 3. 依赖倒置

- 高层模块不依赖低层模块
- 都依赖于抽象接口
- 抽象不依赖细节

### 4. 事件驱动

- 模块间通过事件通信
- 避免直接的模块间调用
- 保持模块的独立性

### 5. 值对象使用

- 业务数据验证封装在值对象中
- 值对象保证不可变性
- 使用Either处理创建失败

### 6. DTO设计

- API数据传输使用DTO
- DTO与领域实体分离
- 提供Mapper进行转换

## 工具支持

### 1. 模块生成器
```bash
# 创建新模块
dart run tools/module_generator.dart create payment

# 添加 UseCase
dart run tools/module_generator.dart add-usecase payment ProcessPayment
```

### 2. 依赖检查器
```bash
# 检查模块依赖
dart run tools/dependency_checker.dart

# 生成依赖图
dart run tools/dependency_graph.dart --output=deps.png
```

### 3. 架构验证
```bash
# 运行完整的架构验证
dart run tools/architecture_validator.dart
```

## 总结

遵循这些模块边界规则可以：
- ✅ 提高代码的可维护性
- ✅ 降低模块间耦合
- ✅ 便于团队并行开发
- ✅ 简化测试和重构
- ✅ 支持模块的独立演进
- ✅ 业务规则内聚于值对象
- ✅ API通信通过DTO标准化
- ✅ 第三方服务通过插件隔离
- ✅ 业务扩展通过钩子实现

## 更新记录

- **2025-05-29**: 添加值对象、DTO、插件和钩子相关规范