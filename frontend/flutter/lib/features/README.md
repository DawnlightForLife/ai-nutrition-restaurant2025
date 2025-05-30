# Features Module

业务功能模块，每个模块都遵循清洁架构和DDD原则。

## 模块列表

- **admin** - 管理员功能
- **auth** - 认证功能
- **consultation** - 咨询功能
- **forum** - 论坛功能
- **global_pages** - 全局页面
- **merchant** - 商家功能
- **nutrition** - 营养功能
- **nutritionist** - 营养师功能
- **order** - 订单功能
- **recommendation** - AI推荐功能
- **user** - 用户功能

## 标准模块结构

每个功能模块都遵循以下结构：

```
feature_name/
├── domain/              # 领域层
│   ├── entities/       # 实体
│   ├── repositories/   # 仓库接口
│   ├── usecases/      # 用例
│   └── value_objects/ # 值对象
├── data/               # 数据层
│   ├── datasources/   # 数据源
│   ├── dtos/          # 数据传输对象
│   ├── mappers/       # 映射器
│   └── repositories/  # 仓库实现
├── application/        # 应用层
│   ├── facade/        # 门面模式
│   └── services/      # 应用服务
├── presentation/       # 表现层
│   ├── pages/         # 页面
│   ├── widgets/       # 组件
│   ├── controllers/   # 控制器
│   ├── providers/     # 状态管理
│   ├── router/        # 路由配置
│   └── coordinators/  # 流程协调
└── di/                # 依赖注入
```

## 开发指南

### 1. 创建新模块

使用 Mason 模板生成器：

```bash
mason make feature_module --name=<module_name>
```

### 2. 添加路由

在模块的 `presentation/router/` 中定义路由：

```dart
class ModuleRouter {
  static List<AutoRoute> get routes => [
    AutoRoute(
      page: ModulePageRoute.page,
      path: '/module',
    ),
  ];
}
```

### 3. 注册依赖

在模块的 `di/` 目录中配置依赖：

```dart
void configureModuleDependencies() {
  // 注册仓库
  getIt.registerLazySingleton<IModuleRepository>(
    () => ModuleRepositoryImpl(),
  );
  
  // 注册用例
  getIt.registerFactory(() => GetModuleUseCase(getIt()));
}
```

### 4. 状态管理

使用 Riverpod 进行状态管理：

```dart
@riverpod
class ModuleController extends _$ModuleController {
  @override
  FutureOr<ModuleState> build() async {
    return ModuleState.initial();
  }
}
```

## 最佳实践

1. **保持模块独立**: 模块之间通过接口通信
2. **遵循DDD原则**: 领域逻辑放在domain层
3. **使用依赖注入**: 避免硬编码依赖
4. **编写测试**: 每个层都应有对应的测试
5. **文档化**: 为复杂业务逻辑添加注释