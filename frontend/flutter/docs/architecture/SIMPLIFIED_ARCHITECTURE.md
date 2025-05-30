# 简化架构文档

## 概述

本文档记录了 Flutter 前端项目的架构简化过程和最终架构设计。项目从过度工程化的架构优化为适合单人开发的简洁架构。

## 架构简化原则

1. **移除过度抽象** - 删除不必要的架构层次
2. **统一技术选型** - 避免功能重复的依赖
3. **简化开发流程** - 减少样板代码
4. **保持可扩展性** - 在简单和灵活之间找到平衡

## 简化前后对比

### 依赖精简

| 功能类别 | 简化前 | 简化后 | 说明 |
|---------|--------|--------|------|
| 路由管理 | auto_route | Navigator | 使用原生路由，减少复杂性 |
| 依赖注入 | get_it + injectable + riverpod | riverpod | 统一使用 Riverpod |
| 代码生成 | freezed + json_serializable + build_runner | build_runner + riverpod_generator + retrofit_generator | 只保留必要的代码生成 |
| 网络请求 | dio + http | dio + retrofit | 统一使用 dio |
| 本地存储 | hive + sqflite + shared_preferences + flutter_secure_storage | shared_preferences + flutter_secure_storage | 简化存储方案 |
| 图表库 | syncfusion_flutter_charts + fl_chart | fl_chart | 使用开源方案 |
| 动画库 | rive + flutter_animate | flutter_animate | 移除复杂的 Rive |
| 测试框架 | mockito + mocktail + golden_toolkit | mocktail | 统一测试框架 |
| 函数式编程 | dartz + equatable | equatable | 使用原生 Dart |

### 架构层次简化

#### 简化前的架构
```
feature/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   ├── usecases/
│   └── value_objects/
├── application/
│   ├── facades/        ❌ 已移除
│   └── coordinators/   ❌ 已移除
└── presentation/
    ├── pages/
    ├── widgets/
    ├── providers/
    └── coordinators/   ❌ 已移除
```

#### 简化后的架构
```
feature/
├── data/              # 数据层
│   ├── datasources/   # API 调用
│   ├── models/        # 数据模型
│   └── repositories/  # 仓储实现
├── domain/            # 领域层
│   ├── entities/      # 业务实体
│   ├── repositories/  # 仓储接口
│   └── usecases/      # 用例（可选）
└── presentation/      # 表现层
    ├── pages/         # 页面
    ├── widgets/       # 组件
    └── providers/     # 状态管理
```

## 核心架构决策

### 1. 状态管理 - Riverpod

统一使用 Riverpod 进行：
- 状态管理
- 依赖注入
- 缓存管理

```dart
// Provider 定义
@riverpod
class UserController extends _$UserController {
  @override
  Future<User> build() async {
    return ref.read(userRepositoryProvider).getCurrentUser();
  }
}
```

### 2. 路由管理 - Navigator

使用 Flutter 原生 Navigator：
- 简单直观
- 无需代码生成
- 类型安全

```dart
// 路由跳转
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => UserProfilePage(userId: userId),
  ),
);
```

### 3. 网络请求 - Dio + Retrofit

```dart
// API 定义
@RestApi(baseUrl: "https://api.example.com")
abstract class UserApi {
  factory UserApi(Dio dio) = _UserApi;

  @GET("/users/{id}")
  Future<UserModel> getUser(@Path("id") String id);
}
```

### 4. 本地存储策略

- **SharedPreferences**: 简单配置和用户偏好
- **flutter_secure_storage**: 敏感信息（token、密码等）

```dart
// 简单数据
final prefs = await SharedPreferences.getInstance();
await prefs.setString('theme', 'dark');

// 敏感数据
const storage = FlutterSecureStorage();
await storage.write(key: 'token', value: accessToken);
```

## 项目结构

```
lib/
├── core/                    # 核心基础设施
│   ├── network/            # 网络配置
│   ├── error/              # 错误处理
│   ├── utils/              # 工具函数
│   └── widgets/            # 通用组件
├── features/               # 功能模块
│   └── [feature_name]/    # 具体功能
│       ├── data/          # 数据层
│       ├── domain/        # 领域层
│       └── presentation/  # 表现层
├── shared/                 # 共享资源
│   ├── widgets/           # 共享组件
│   └── models/            # 共享模型
└── theme/                  # 主题配置
```

## 开发流程

### 1. 创建新功能模块

```bash
features/
└── new_feature/
    ├── data/
    │   ├── datasources/
    │   │   └── new_feature_api.dart
    │   ├── models/
    │   │   └── new_feature_model.dart
    │   └── repositories/
    │       └── new_feature_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   └── new_feature.dart
    │   └── repositories/
    │       └── new_feature_repository.dart
    └── presentation/
        ├── pages/
        │   └── new_feature_page.dart
        ├── widgets/
        │   └── new_feature_widget.dart
        └── providers/
            └── new_feature_provider.dart
```

### 2. 数据流

```
UI (Page/Widget)
    ↓ 监听
Provider (Riverpod)
    ↓ 调用
Repository
    ↓ 请求
DataSource (API/Local)
```

### 3. 错误处理

使用统一的错误处理机制：

```dart
class AppException implements Exception {
  final String message;
  final String? code;
  
  AppException(this.message, {this.code});
}

// 在 Provider 中处理错误
@riverpod
class DataController extends _$DataController {
  @override
  Future<Data> build() async {
    try {
      return await ref.read(repositoryProvider).getData();
    } catch (e) {
      throw AppException('Failed to load data');
    }
  }
}
```

## 最佳实践

### 1. 保持简单
- 优先使用 Dart 原生功能
- 避免过度抽象
- 只在必要时添加新依赖

### 2. 代码组织
- 按功能模块组织代码
- 保持文件和类的单一职责
- 使用清晰的命名

### 3. 状态管理
- 使用 Riverpod 的 AsyncNotifier
- 合理使用缓存
- 避免全局状态

### 4. 性能优化
- 使用 const 构造函数
- 懒加载大型资源
- 合理使用 Widget 重建

## 迁移指南

对于需要从旧架构迁移的模块：

1. **移除 auto_route**: 改用 Navigator.push
2. **移除 get_it**: 改用 Riverpod Provider
3. **移除 freezed**: 手动编写数据类
4. **简化存储**: 迁移到 SharedPreferences/SecureStorage
5. **统一网络请求**: 全部使用 Dio + Retrofit

## 总结

简化后的架构具有以下优势：

- ✅ **开发效率高** - 减少样板代码
- ✅ **易于理解** - 架构层次清晰
- ✅ **维护简单** - 依赖少，复杂度低
- ✅ **性能更好** - 编译速度快，包体积小
- ✅ **适合单人开发** - 降低认知负担

这个架构在保持代码质量的同时，大大提升了开发体验，特别适合快速迭代和个人项目开发。