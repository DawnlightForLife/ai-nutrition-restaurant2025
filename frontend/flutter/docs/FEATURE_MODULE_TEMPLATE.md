# Feature 模块标准模板

## 标准目录结构

每个 Feature 模块必须遵循以下标准结构：

```
features/[module_name]/
├── README.md                    # 模块说明（可选）
├── [module_name]_module.dart    # 模块初始化
├── application/                 # 应用层（必须）
│   └── facades/                 # 业务门面
│       └── [module]_facade.dart
├── domain/                      # 领域层（必须）
│   ├── entities/               # 实体
│   ├── repositories/           # 仓库接口
│   ├── usecases/              # 用例
│   └── value_objects/         # 值对象
├── data/                       # 数据层（必须）
│   ├── datasources/           # 数据源
│   ├── models/                # 数据模型
│   ├── repositories/          # 仓库实现
│   └── injection.dart         # 模块内部 DI（私有）
└── presentation/              # 展示层（必须）
    ├── pages/                 # 页面
    ├── widgets/              # 组件
    ├── controllers/          # 控制器
    ├── providers/            # Provider
    └── router/              # 路由配置
```

## 创建新模块的步骤

1. **使用脚手架工具创建模块结构**
   ```bash
   dart run tools/create_feature_module.dart [module_name]
   ```

2. **实现各层内容**
   - Domain 层：定义业务实体和接口
   - Data 层：实现数据访问
   - Application 层：聚合业务逻辑
   - Presentation 层：实现 UI

3. **注册模块**
   - 在 `ModuleInitializer` 中添加模块初始化
   - 在 `AppInjection` 中注册依赖

## 命名规范

| 层级 | 文件类型 | 命名规则 | 示例 |
|------|----------|----------|------|
| Domain | Entity | [Entity].dart | user.dart |
| Domain | Repository | [Entity]Repository | UserRepository |
| Domain | UseCase | [Action][Entity]UseCase | GetUserUseCase |
| Data | Model | [Entity]Model | UserModel |
| Data | DataSource | [Entity]RemoteDataSource | UserRemoteDataSource |
| Application | Facade | [Module]Facade | UserFacade |
| Presentation | Page | [Feature]Page | ProfilePage |
| Presentation | Controller | [Feature]Controller | ProfileController |

## 示例：创建 Payment 模块

```bash
# 1. 创建模块结构
dart run tools/create_feature_module.dart payment

# 2. 生成的结构
features/payment/
├── payment_module.dart
├── application/
│   └── facades/
│       └── payment_facade.dart
├── domain/
│   ├── entities/
│   │   └── payment.dart
│   ├── repositories/
│   │   └── payment_repository.dart
│   └── usecases/
│       └── process_payment_usecase.dart
├── data/
│   ├── datasources/
│   │   └── payment_remote_datasource.dart
│   ├── models/
│   │   └── payment_model.dart
│   ├── repositories/
│   │   └── payment_repository_impl.dart
│   └── injection.dart
└── presentation/
    ├── pages/
    │   └── payment_page.dart
    ├── controllers/
    │   └── payment_controller.dart
    ├── providers/
    │   └── payment_providers.dart
    └── router/
        └── payment_router.dart
```

## 注意事项

1. **必须包含 Application 层**：所有模块都必须有 application/facades 目录
2. **DI 私有化**：依赖注入配置放在 data/injection.dart，不单独创建 di/ 目录
3. **路由集中管理**：路由配置暴露给 core/router 统一管理
4. **遵循依赖方向**：严格遵循 Clean Architecture 的依赖规则