# 路由模块化架构

## 概述

本项目采用模块化路由架构，每个功能模块维护自己的路由配置，主路由文件仅负责组合各模块路由。

## 目录结构

```
lib/
├── core/
│   └── router/
│       ├── app_router.dart          # 主路由文件
│       ├── app_router.gr.dart       # AutoRoute生成文件
│       ├── guards.dart              # 路由守卫
│       ├── route_paths.dart         # 路由路径常量
│       ├── router_manager.dart      # 路由管理器
│       └── README.md               # 本文档
└── features/
    ├── auth/
    │   └── presentation/
    │       └── router/
    │           └── auth_router.dart # Auth模块路由
    ├── nutrition/
    │   └── presentation/
    │       └── router/
    │           └── nutrition_router.dart # Nutrition模块路由
    └── ... # 其他模块
```

## 使用指南

### 1. 添加新路由

在对应模块的 `xxx_router.dart` 文件中添加：

```dart
class MyModuleRouter {
  static List<AutoRoute> get routes => [
    AutoRoute(
      page: MyPageRoute.page,
      path: '/my-path',
      guards: [AuthGuard()], // 可选
    ),
  ];
  
  static const String myPath = '/my-path';
}
```

### 2. 路由导航

使用 RouterManager 进行导航：

```dart
// 注入 RouterManager
final routerManager = ref.read(routerManagerProvider);

// 导航到指定路径
await routerManager.navigateTo(NutritionRouter.profilesPath);

// 带参数导航
await routerManager.navigateTo(
  NutritionRouter.profileDetailPathWithId('123'),
);

// 替换当前路由
await routerManager.replaceTo(AuthRouter.loginPath);

// 返回
routerManager.goBack();
```

### 3. 路由守卫

支持的守卫类型：
- `AuthGuard`: 检查用户是否已登录
- `RoleGuard`: 检查用户角色权限

```dart
AutoRoute(
  page: AdminDashboardRoute.page,
  path: '/admin/dashboard',
  guards: [AuthGuard(), RoleGuard([UserRole.admin])],
)
```

### 4. 路由常量

使用 `RoutePaths` 类获取路由路径常量：

```dart
// 不推荐
context.router.pushNamed('/nutrition/profiles');

// 推荐
context.router.pushNamed(RoutePaths.nutritionProfiles);
```

## 最佳实践

1. **模块独立性**：每个模块的路由配置应该独立，不依赖其他模块
2. **路径命名**：使用模块名作为路径前缀，如 `/nutrition/xxx`、`/auth/xxx`
3. **常量管理**：在模块路由类中定义路径常量，避免硬编码
4. **守卫使用**：需要认证的页面必须添加 `AuthGuard`
5. **参数传递**：使用强类型的路由参数，避免使用 Map

## 路由生成

修改路由后需要运行：

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 模块列表

- **Auth**: 认证相关（登录、注册、密码重置等）
- **User**: 用户相关（主页、个人资料等）
- **Nutrition**: 营养管理（档案、AI推荐等）
- **Merchant**: 商家管理
- **Nutritionist**: 营养师管理
- **Admin**: 管理员功能
- **Employee**: 员工工作台
- **Forum**: 论坛功能
- **Order**: 订单管理
- **Recommendation**: 推荐管理
- **Consultation**: 咨询管理
- **GlobalPages**: 全局页面（启动页、关于页等）