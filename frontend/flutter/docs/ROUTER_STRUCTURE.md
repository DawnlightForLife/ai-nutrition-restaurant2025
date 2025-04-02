# 路由结构与管理规范

本文档描述智慧AI营养餐厅Flutter项目中路由的统一管理规则、守卫分类以及相关最佳实践，确保应用内导航的一致性和安全性。

## 路由架构概述

智慧AI营养餐厅应用采用声明式路由架构，基于 GoRouter 实现，所有路由定义集中在 `router/` 目录中管理，严格遵循以下层次结构：

```
router/
├── app_routes.dart        # 路由名称和路径常量
├── route_config.dart      # 路由配置和初始化
└── guards/                # 路由守卫
    ├── auth_guard.dart    # 认证守卫
    ├── role_guard.dart    # 角色权限守卫
    └── ... 其他守卫
```

## 路由定义规范

### 路由命名规则

1. **路由名称常量**
   - 在 `app_routes.dart` 中定义
   - 使用大写字母和下划线：`ROUTE_NAME`
   - 按模块分组，清晰注释

2. **路由路径规则**
   - 路径全部小写，使用连字符 `-` 分隔单词
   - 模块前缀清晰，如：`/user/profile`, `/merchant/dashboard`
   - 参数使用冒号，如：`/dish/:dishId`
   - 嵌套路由使用合理的层次结构

### 定义示例

```dart
// app_routes.dart

// 认证相关路由
const String LOGIN = 'login';
const String REGISTER = 'register';
const String FORGOT_PASSWORD = 'forgot-password';

// 用户模块路由
const String USER_PROFILE = 'user-profile';
const String USER_ORDERS = 'user-orders';
const String USER_ORDER_DETAIL = 'user-order-detail';

// 商家模块路由
const String MERCHANT_DASHBOARD = 'merchant-dashboard';
const String MERCHANT_MENU = 'merchant-menu';
```

## 路由配置与初始化

`route_config.dart` 文件负责定义和初始化应用的路由配置，包括：

1. **路由器实例创建**
   - 配置路由初始位置
   - 设置全局重定向
   - 设置错误页面处理

2. **路由定义**
   - 将路由名称映射到实际页面组件
   - 配置路由参数和查询参数
   - 设置页面转场动画

3. **路由钩子**
   - 路由进入前处理
   - 路由离开前确认
   - 路由错误处理

### 配置示例

```dart
// route_config.dart
final router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  redirectLimit: 5,
  routes: [
    // 主页
    GoRoute(
      path: '/',
      name: HOME,
      builder: (context, state) => const HomePage(),
    ),
    
    // 认证路由组
    GoRoute(
      path: '/auth',
      name: AUTH,
      builder: (context, state) => const AuthPage(),
      routes: [
        GoRoute(
          path: 'login',
          name: LOGIN,
          builder: (context, state) => const LoginPage(),
          redirect: (context, state) => authGuard(context, state),
        ),
        // 其他认证子路由...
      ],
    ),
    
    // 其他路由定义...
  ],
  // 全局重定向
  redirect: (context, state) {
    // 全局重定向逻辑
    return null;
  },
  // 错误页面
  errorBuilder: (context, state) => NotFoundPage(error: state.error),
);
```

## 路由守卫

路由守卫是保护路由访问的拦截器，所有守卫都放在 `router/guards/` 目录中。项目定义了以下几类守卫：

### 1. 认证守卫 (`auth_guard.dart`)

检查用户是否已登录，未登录用户重定向到登录页面。

```dart
String? authGuard(BuildContext context, GoRouterState state) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final bool isLoggedIn = authProvider.isLoggedIn;
  
  // 如果用户未登录且当前不是公开路由，重定向到登录页
  if (!isLoggedIn && !isPublicRoute(state.location)) {
    return '/auth/login?redirect=${state.location}';
  }
  
  // 如果用户已登录且尝试访问登录页，重定向到首页
  if (isLoggedIn && isAuthRoute(state.location)) {
    return '/';
  }
  
  return null; // 不重定向
}
```

### 2. 角色守卫 (`role_guard.dart`)

检查用户是否有权限访问特定角色的页面，例如商家、用户、营养师或管理员页面。

```dart
String? roleGuard(BuildContext context, GoRouterState state, List<String> allowedRoles) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  
  // 如果用户未登录，先经过认证守卫处理
  final authRedirect = authGuard(context, state);
  if (authRedirect != null) return authRedirect;
  
  // 如果用户角色不在允许的角色列表中，重定向到未授权页面
  if (!allowedRoles.contains(authProvider.userRole)) {
    return '/unauthorized';
  }
  
  return null; // 不重定向
}
```

### 3. 订阅守卫 (`subscription_guard.dart`)

检查用户是否有有效订阅访问高级功能页面。

```dart
String? subscriptionGuard(BuildContext context, GoRouterState state) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
  
  // 如果用户未登录，先经过认证守卫处理
  final authRedirect = authGuard(context, state);
  if (authRedirect != null) return authRedirect;
  
  // 如果用户没有有效订阅，重定向到订阅页面
  if (!subscriptionProvider.hasActiveSubscription) {
    return '/subscription?redirect=${state.location}';
  }
  
  return null; // 不重定向
}
```

### 4. 表单提交守卫 (`form_submission_guard.dart`)

防止用户在表单未保存时意外离开页面。

```dart
Future<bool> formSubmissionGuard(BuildContext context) async {
  final formProvider = Provider.of<FormProvider>(context, listen: false);
  
  // 如果表单有未保存的更改，显示确认对话框
  if (formProvider.hasUnsavedChanges) {
    return await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: '未保存的更改',
        content: '您有未保存的更改，确定要离开吗？',
        confirmText: '离开',
        cancelText: '取消',
      ),
    ) ?? false;
  }
  
  return true; // 允许离开
}
```

### 5. 数据加载守卫 (`data_loading_guard.dart`)

确保页面所需数据已加载完成，否则显示加载中页面。

```dart
Widget dataLoadingGuard<T>(
  BuildContext context,
  AsyncSnapshot<T> snapshot,
  Widget Function(T data) builder,
) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const LoadingPage();
  } else if (snapshot.hasError) {
    return ErrorPage(error: snapshot.error);
  } else if (!snapshot.hasData) {
    return const EmptyDataPage();
  } else {
    return builder(snapshot.data as T);
  }
}
```

## 路由代码组织最佳实践

### 1. 模块化路由定义

为大型应用模块化定义路由，每个模块在单独文件中定义路由，然后在主路由配置中组合。

```dart
// user_routes.dart
List<GoRoute> getUserRoutes() {
  return [
    // 用户模块路由定义...
  ];
}

// merchant_routes.dart
List<GoRoute> getMerchantRoutes() {
  return [
    // 商家模块路由定义...
  ];
}

// route_config.dart
final router = GoRouter(
  routes: [
    ...getUserRoutes(),
    ...getMerchantRoutes(),
    // 其他模块路由...
  ],
);
```

### 2. 参数和查询参数处理

一致性地处理路由参数和查询参数：

```dart
// 路由参数
GoRoute(
  path: 'order/:orderId',
  name: ORDER_DETAIL,
  builder: (context, state) {
    final orderId = state.params['orderId']!;
    return OrderDetailPage(orderId: orderId);
  },
),

// 查询参数
GoRoute(
  path: 'search',
  name: SEARCH,
  builder: (context, state) {
    final query = state.queryParams['q'] ?? '';
    final category = state.queryParams['category'];
    return SearchPage(query: query, category: category);
  },
),
```

### 3. 路由动画标准化

标准化页面转场动画，保持一致的用户体验：

```dart
// 自定义页面构建器
CustomTransitionPage<void> buildPageWithTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  TransitionType transitionType = TransitionType.fade,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        case TransitionType.rightToLeft:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        // 其他转场动画类型...
      }
    },
  );
}
```

## 路由测试

所有路由定义和守卫应有对应的单元测试和集成测试，包括：

1. **路由名称和路径测试**
   - 验证路由名称和路径映射关系正确

2. **守卫逻辑测试**
   - 测试各种情况下守卫的行为是否正确

3. **参数传递测试**
   - 测试路由参数和查询参数的传递和解析

4. **重定向测试**
   - 测试各种条件下的重定向是否正确

## 路由版本管理

随着应用版本更新，路由结构可能需要变更，应遵循以下原则：

1. **向后兼容**
   - 尽量保持老版本路由有效
   - 必要时添加重定向从老路由到新路由

2. **路由变更记录**
   - 记录路由结构变更的历史和原因
   - 在重大路由结构变更时更新版本号

3. **深链接处理**
   - 确保外部深链接仍然有效
   - 提供从外部链接到应用内部路由的映射机制

## 总结

路由是应用程序的骨架，良好的路由结构和管理对于提供一致、安全、易于导航的用户体验至关重要。严格遵循本文档的规范可以确保应用路由系统的可维护性和扩展性。 