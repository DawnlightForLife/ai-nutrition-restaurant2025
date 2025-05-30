# Core Module

核心模块包含应用程序的基础设施组件。

## 目录结构

```
core/
├── di/                 # 依赖注入
├── router/            # 路由系统
├── exceptions/        # 异常处理
├── failures/          # 失败类型
├── error/            # 展示层错误处理
├── plugins/          # 插件系统
├── hooks/            # 生命周期钩子
├── coordinators/     # 流程协调器
├── services/         # 核心服务
├── utils/            # 工具函数
└── widgets/          # 核心组件
```

## 主要组件

### 1. 依赖注入 (DI)

- **InjectionContainer**: 依赖注入容器
- **AppInjection**: 应用级别的依赖配置
- **ModuleInitializer**: 模块初始化器

### 2. 路由系统

- **AppRouter**: 主路由配置
- **RouterManager**: 路由管理器，提供统一的导航接口
- **AppRouterCoordinator**: 收集和协调各模块的路由
- **Guards**: 路由守卫（认证、权限等）

### 3. 错误处理

- **Exceptions**: 数据层异常类
- **Failures**: 领域层失败类
- **ExceptionMapper**: 异常到失败的映射器
- **CentralizedErrorHandler**: 集中式错误处理器

### 4. 插件系统

- **PluginManager**: 插件管理器
- **Plugin接口**: 支付、存储、分享等插件接口

### 5. 生命周期钩子

- **AppHooks**: 应用生命周期钩子管理
- 支持14种不同的生命周期事件

### 6. 协调器系统

- **BaseCoordinator**: 协调器基类
- **CoordinatorManager**: 协调器管理器
- 用于复杂业务流程的协调

## 使用示例

### 路由导航

```dart
// 使用 RouterManager
final router = ref.read(routerManagerProvider);
router.navigateTo('/user/profile');
```

### 错误处理

```dart
// 在 Repository 中使用
return ExceptionMapper.guardAsync(() async {
  final response = await api.getData();
  return response.toDomain();
});
```

### 依赖注入

```dart
// 注册依赖
getIt.registerLazySingleton<IUserRepository>(
  () => UserRepositoryImpl(getIt()),
);
```

## 设计原则

1. **单一职责**: 每个组件只负责一个特定功能
2. **依赖倒置**: 高层模块不依赖低层模块
3. **开闭原则**: 对扩展开放，对修改关闭
4. **接口隔离**: 使用小而专注的接口