# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-01-30

### 🔥 Breaking Changes
- 移除 auto_route，改用原生 Navigator
- 移除 get_it + injectable，统一使用 Riverpod
- 移除 freezed + json_serializable，手动编写数据类
- 移除 dartz，使用原生 Dart
- 简化存储方案，移除 Hive 和 sqflite

### ✨ Added
- 新增 `main_clean.dart` 作为简化版入口文件
- 新增架构简化文档 `SIMPLIFIED_ARCHITECTURE.md`
- 统一错误处理机制
- 集中式事件总线

### 🔧 Changed
- 统一使用 Riverpod 进行状态管理和依赖注入
- 简化代码生成，只保留 retrofit + riverpod
- 网络请求统一使用 dio + retrofit
- 图表库统一使用 fl_chart
- 动画库统一使用 flutter_animate
- 测试框架统一使用 mocktail

### ❌ Removed
- 移除 auto_route 及相关代码
- 移除 get_it + injectable 依赖注入
- 移除 http 包（使用 dio）
- 移除 syncfusion_flutter_charts（使用 fl_chart）
- 移除 rive 动画（使用 flutter_animate）
- 移除 mockito + golden_toolkit（使用 mocktail）
- 移除 hive + sqflite（简化存储）
- 移除 dartz（使用原生 Dart）
- 移除 data_table_2, device_info_plus 等未使用依赖
- 移除 Facade 层（application/facades）
- 移除 Coordinator 层（presentation/coordinators）
- 移除 Plugin Manager（core/plugins）
- 移除 Hooks 系统（core/hooks）

### 📦 Dependencies
- Flutter: 3.19.0+
- Dart: 3.3.0+
- Riverpod: 2.6.1
- Dio: 5.7.0
- Retrofit: 4.4.1

### 🎯 Migration Guide
1. 路由迁移：将 `context.router.push()` 改为 `Navigator.push()`
2. 依赖注入：将 `getIt<T>()` 改为 Riverpod Provider
3. 数据类：移除 `@freezed` 注解，手动编写构造函数和方法
4. 存储迁移：将 Hive 迁移到 SharedPreferences
5. 错误处理：使用新的 `AppException` 类

## [1.0.0] - 2025-01-XX

### ✨ Initial Release
- 完整的用户认证系统
- 营养档案管理
- AI 营养推荐
- 在线咨询功能
- 智能点餐系统
- 社区论坛
- 多角色支持（用户、商家、营养师、管理员）