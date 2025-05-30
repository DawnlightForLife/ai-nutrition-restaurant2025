# AI智能营养餐厅 Flutter 前端

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.19.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-2.6.1-00C4CC?style=for-the-badge)
![Architecture](https://img.shields.io/badge/Architecture-Simplified-purple?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

*基于 AI 技术的智能营养推荐系统移动端应用*

</div>

## 📋 目录

- [项目简介](#项目简介)
- [功能特性](#功能特性)
- [技术架构](#技术架构)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [开发指南](#开发指南)
- [状态管理](#状态管理)
- [测试](#测试)
- [部署](#部署)
- [贡献指南](#贡献指南)
- [📚 项目文档](#项目文档)

## 🎯 项目简介

AI智能营养餐厅 Flutter 前端是一款基于人工智能技术的营养健康管理应用，为用户提供个性化的营养推荐、健康咨询和智能点餐服务。

### 核心价值
- 🧠 **AI 驱动**：基于用户健康数据的个性化营养推荐
- 🏥 **专业咨询**：连接认证营养师提供专业指导
- 🍽️ **智能点餐**：根据营养需求推荐最佳餐品组合
- 📊 **数据洞察**：全面的营养摄入分析和健康报告

## ✨ 功能特性

### 🔐 用户模块
- [x] 多种登录方式（手机、邮箱）
- [x] 完整的用户档案管理
- [x] 安全的身份验证机制

### 🥗 营养管理
- [x] 个性化营养档案创建
- [x] AI 智能营养推荐
- [x] 营养目标设定与追踪
- [x] 膳食记录与分析

### 👨‍⚕️ 专业咨询
- [x] 在线营养师咨询
- [x] 实时聊天功能
- [x] 咨询历史管理
- [x] 专业建议追踪

### 🛒 智能点餐
- [x] 基于营养需求的餐品推荐
- [x] 多样化商家选择
- [x] 订单管理与追踪
- [x] 营养成分实时显示

### 💬 社区交流
- [x] 营养知识论坛
- [x] 用户经验分享
- [x] 专家答疑区
- [x] 健康话题讨论

### 📱 管理端
- [x] 商家管理后台
- [x] 营养师工作台
- [x] 系统管理功能
- [x] 数据分析面板

## 🏗️ 技术架构

### 核心技术栈（简化版）
- **框架**: Flutter 3.19.0+
- **语言**: Dart 3.3.0+
- **状态管理**: Riverpod 2.6.1（统一使用）
- **代码生成**: build_runner, riverpod_generator, retrofit_generator
- **路由**: 原生 Navigator（移除 auto_route）
- **网络**: dio, retrofit（统一使用）
- **本地存储**: shared_preferences, flutter_secure_storage（简化存储方案）
- **UI组件**: flutter_screenutil, cached_network_image
- **动画**: flutter_animate（移除 Rive）
- **图表**: fl_chart（移除 syncfusion）

### 架构模式
采用 **简化的分层架构**：

```
lib/
├── core/                    # 核心基础设施
│   ├── network/            # 网络层
│   ├── error/              # 错误处理
│   ├── utils/              # 工具函数
│   └── widgets/            # 通用组件
├── features/               # 功能模块
│   ├── auth/              # 认证模块
│   ├── nutrition/         # 营养管理
│   ├── consultation/      # 咨询模块
│   ├── order/            # 订单模块
│   └── ...               # 其他模块
└── shared/                # 共享资源
```

### 分层设计（简化版）
每个功能模块采用三层架构：

```
feature/
├── data/                  # 数据层
│   ├── datasources/      # 数据源
│   ├── models/           # 数据模型
│   └── repositories/     # 仓储实现
├── domain/               # 领域层
│   ├── entities/         # 业务实体
│   ├── repositories/     # 仓储接口
│   └── usecases/        # 用例
└── presentation/         # 表现层
    ├── pages/           # 页面
    ├── widgets/         # 组件
    └── providers/       # 状态管理
```

## 🚀 快速开始

### 环境要求
- Flutter SDK: 3.19.0+
- Dart SDK: 3.3.0+
- iOS: 12.0+ / Android: API 21+
- IDE: VS Code / Android Studio

### 安装步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd ai-nutrition-restaurant2025/frontend/flutter
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **代码生成**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **运行应用**
   ```bash
   # 使用简化版入口文件
   flutter run -t lib/main_clean.dart
   
   # 或使用原始入口（需要修复依赖问题）
   flutter run
   ```

### 开发脚本
项目提供了便捷的开发脚本：

```bash
# 启动开发服务器
./run_flutter_dev.sh

# 运行代码生成
flutter packages pub run build_runner build --delete-conflicting-outputs

# 运行测试
flutter test

# 代码分析
flutter analyze
```

## 📁 项目结构

<details>
<summary>点击展开完整目录结构</summary>

```
lib/
├── app.dart                    # 应用入口
├── main.dart                   # 主函数
├── main_clean.dart            # 简化版入口（推荐使用）
├── core/                       # 核心基础设施
│   ├── config/                # 配置管理
│   ├── error/                 # 错误处理
│   ├── exceptions/            # 异常定义
│   ├── events/               # 事件总线
│   ├── network/              # 网络层
│   ├── base/                 # 基础类
│   └── utils/                # 工具函数
├── features/                   # 功能模块
│   ├── auth/                  # 认证模块
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       ├── widgets/
│   │       └── providers/
│   ├── nutrition/             # 营养管理
│   ├── consultation/          # 咨询模块
│   ├── order/                 # 订单模块
│   ├── forum/                 # 论坛模块
│   ├── merchant/              # 商家模块
│   ├── user/                  # 用户模块
│   └── global_pages/          # 全局页面
├── shared/                     # 共享资源
│   ├── dto/                   # 数据传输对象
│   ├── enums/                # 枚举定义
│   ├── widgets/              # 共享组件
│   └── domain/               # 共享领域对象
├── theme/                     # 主题配置
└── l10n/                      # 国际化
```

</details>

## 👨‍💻 开发指南

### 架构简化说明
项目已经过架构优化，移除了过度工程化的部分：

#### 已移除的依赖和功能：
- ❌ auto_route → 使用原生 Navigator
- ❌ get_it + injectable → 统一使用 Riverpod
- ❌ freezed + json_serializable → 手动编写数据类
- ❌ hive + sqflite → 简化为 SharedPreferences + flutter_secure_storage
- ❌ syncfusion_flutter_charts → 使用 fl_chart
- ❌ rive → 使用 flutter_animate
- ❌ dartz → 使用原生 Dart
- ❌ mockito + golden_toolkit → 统一使用 mocktail

#### 已移除的架构层：
- ❌ Facade 层（application/facades）
- ❌ Coordinator 层（presentation/coordinators）
- ❌ Plugin Manager（core/plugins）
- ❌ Hooks 系统（core/hooks）

### 代码规范
- 遵循 [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- 使用 `flutter_lints` 进行代码检查
- 强制使用 `const` 构造函数
- 优先使用 `final` 声明变量

### Git 工作流
```bash
# 创建功能分支
git checkout -b feature/new-feature

# 提交代码
git add .
git commit -m "feat: add new feature"

# 推送分支
git push origin feature/new-feature
```

### 提交规范
使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：
- `feat:` 新功能
- `fix:` 修复
- `docs:` 文档
- `style:` 格式
- `refactor:` 重构
- `test:` 测试
- `chore:` 构建

## 🎛️ 状态管理

### Riverpod 统一方案
项目统一使用 Riverpod 进行状态管理和依赖注入：

```dart
// Provider 定义
@riverpod
class MyController extends _$MyController {
  @override
  Future<MyData> build() async {
    return ref.read(repositoryProvider).getData();
  }
  
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

// 使用示例
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myData = ref.watch(myControllerProvider);
    return myData.when(
      data: (data) => Text(data.toString()),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

## 🧪 测试

### 测试策略（简化版）
- **单元测试**：使用 mocktail 进行模拟
- **Widget 测试**：测试 UI 组件
- **集成测试**：完整用户流程

### 运行测试
```bash
# 运行所有测试
flutter test

# 运行特定测试
flutter test test/unit/auth/

# 生成覆盖率报告
flutter test --coverage
```

## 📦 构建与部署

### 构建命令
```bash
# iOS 构建
flutter build ios

# Android 构建
flutter build appbundle

# Web 构建
flutter build web
```

## 📚 项目文档

完整的项目文档已整理到 `docs/` 目录下，包含：

- **架构文档** - 系统设计和技术决策
- **开发指南** - 编码规范和最佳实践  
- **API文档** - 接口说明和使用示例
- **测试文档** - 测试策略和用例
- **故障排除** - 常见问题和解决方案

👉 [进入文档中心](./docs/README.md)

## 🤝 贡献指南

### 贡献流程
1. Fork 项目
2. 创建功能分支
3. 提交代码
4. 创建 Pull Request
5. 代码审查
6. 合并主分支

### 代码审查标准
- 功能完整性
- 代码质量
- 测试覆盖率
- 文档完整性
- 性能考虑

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](./LICENSE) 文件了解详情。

## 🆘 问题反馈

遇到问题？我们提供多种支持方式：

- 📧 **邮件支持**: dev-team@nutrition-ai.com
- 🐛 **Bug 报告**: [GitHub Issues](https://github.com/your-repo/issues)
- 💬 **技术讨论**: [GitHub Discussions](https://github.com/your-repo/discussions)
- 📖 **开发文档**: [项目 Wiki](https://github.com/your-repo/wiki)

## 🔄 版本历史

### v2.0.0 (2025-01-30)
- 🔥 架构大幅简化，移除过度工程化
- ✨ 统一使用 Riverpod 进行状态管理
- 🚀 移除 auto_route，使用原生 Navigator
- 📦 精简依赖，提升编译速度
- 🎯 优化开发体验，降低复杂度

### v1.0.0 (2025-01-XX)
- ✨ 初始版本发布
- 🎯 完整的营养管理功能
- 🔐 用户认证系统
- 💬 咨询功能
- 🛒 智能点餐

---

<div align="center">

**用 ❤️ 和 ☕ 制作**

*如果这个项目对你有帮助，请给我们一个 ⭐*

</div>