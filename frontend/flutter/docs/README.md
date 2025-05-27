# 智能营养餐厅App架构文档

欢迎阅读智能营养餐厅App的架构文档。本文档集提供了应用架构的详细说明和实现指南，帮助开发团队理解系统设计并保持一致的开发风格。

## 文档索引

### 核心文档

1. [快速入门指南](quick_start.md) - 新开发者快速了解项目架构
2. [架构冻结文档](ARCHITECTURE_FREEZE.md) - 架构版本和功能历史记录
3. [目录结构说明](folder_structure.md) - 项目文件组织详细说明

### 规范文档

4. [架构规范指南](architecture_guidelines.md) - 详细的架构设计原则和实现规范
5. [代码模板](code_templates.md) - 标准代码模板和示例（含新架构组件）
6. [离线优先架构](offline_first.md) - 离线优先的架构设计和实现方案
7. [测试架构指南](testing_architecture.md) - 测试金字塔架构和测试实现方案
8. [验证策略](validation_strategy.md) - 数据验证和错误处理策略

### 实施文档

9. [接口隔离原则](../domain/abstractions/README.md) - 接口设计和隔离原则的实现指南
10. [应用层协调者模式](../application/README.md) - 用例和业务流程协调的实现方式
11. [Mason模板](MASON_TEMPLATES.md) - 代码生成模板使用指南

### 架构改进文档

12. [架构改进总览](ARCHITECTURE_IMPROVEMENTS_2025.md) - 2025年实施的10项架构改进
13. [架构改进摘要](ARCHITECTURE_IMPROVEMENTS_SUMMARY.md) - 架构改进快速参考
14. [Riverpod迁移指南](RIVERPOD_MIGRATION_GUIDE.md) - 从Provider到Riverpod的迁移指南
15. [图表组件指南](CHART_COMPONENTS_GUIDE.md) - 统一的数据可视化组件使用指南

### 配置和故障排查

16. [Android配置指南](ANDROID_SETUP_GUIDE.md) - Android平台配置和问题解决
17. [故障排查指南](TROUBLESHOOTING.md) - 常见问题和解决方案
18. [实现验证报告](IMPLEMENTATION_VERIFICATION.md) - 新功能实现状态验证
19. [架构完整性扫描](architecture_integrity_scan.md) - 架构一致性检查

## 架构概览

我们的应用采用了结合领域驱动设计(DDD)和干净架构(Clean Architecture)的分层设计：

```
┌─────────────────┐
│  表现层(UI)      │  Screens, Components, Riverpod/Provider
└─────┬───────────┘
      │
┌─────▼───────────┐
│    应用层        │  Use Cases, Facades, Event Bus
└─────┬───────────┘
      │
┌─────▼───────────┐
│    领域层        │  Entities, Events, Value Objects, Interfaces
└─────┬───────────┘
      │
┌─────▼───────────┐
│  基础设施层      │  Repositories, DTOs, Mappers, API Clients
└─────────────────┘
```

### 架构特性

- **OpenAPI驱动开发**: 自动生成DTO和API客户端，确保前后端一致性
- **模块化设计**: 每个业务模块通过Facade提供统一接口
- **事件驱动架构**: 使用领域事件实现模块间解耦通信
- **类型安全映射**: BaseMapper模式统一DTO-Entity转换
- **现代状态管理**: Riverpod AsyncNotifier处理异步状态
- **离线优先**: 核心功能支持离线操作和数据同步

### 核心原则

- **依赖倒置**: 高层模块不应依赖低层模块，二者应依赖抽象
- **接口隔离**: 客户端不应依赖它不使用的接口
- **单一职责**: 一个类应该只有一个引起它变化的原因
- **开闭原则**: 对扩展开放，对修改封闭
- **离线优先**: 应用首先考虑离线情况，确保核心功能在无网络时可用

## 技术栈

### 核心框架
- **UI框架**: Flutter 3.x
- **状态管理**: Riverpod 2.x (推荐), Provider (兼容)
- **依赖注入**: GetIt + Injectable
- **路由导航**: GoRouter, Auto Route

### 网络和数据
- **HTTP客户端**: Dio + 拦截器
- **API集成**: Retrofit + OpenAPI Generator
- **本地存储**: Hive, SharedPreferences
- **离线同步**: OfflineSyncService + 操作队列
- **网络监控**: Connectivity Plus

### 代码生成
- **构建工具**: Build Runner
- **数据模型**: Freezed + Json Serializable
- **API客户端**: Retrofit Generator + OpenAPI Generator
- **依赖注入**: Injectable Generator
- **状态管理**: Riverpod Generator
- **路由生成**: Auto Route Generator

### 测试工具
- **单元测试**: Flutter Test + Mockito
- **组件测试**: Widget Testing + Golden Toolkit
- **集成测试**: Integration Test
- **E2E测试**: Flutter Driver
- **Mock工具**: Mockito, Mocktail, Network Image Mock
- **测试覆盖率**: lcov + 测试脚本

### 数据可视化
- **图表库**: FL Chart, Syncfusion Flutter Charts
- **组件预览**: Widgetbook 3.x
- **主题系统**: 动态主题 + 图表主题
- **动画库**: Flutter Animate, Rive

### 架构组件
- **事件总线**: Domain Event Bus
- **模块边界**: Module Facade Pattern
- **数据映射**: BaseMapper + 自动生成
- **错误处理**: Either + AppFailure
- **性能监控**: Performance Monitor + Analytics
- **用户分析**: User Analytics + Mixins

### CI/CD集成
- **多环境构建**: Flutter Flavors (dev/staging/prod)
- **自动化打包**: Fastlane + 构建脚本
- **代码质量**: Flutter Analyze + Format
- **测试覆盖**: 测试覆盖率脚本 (目标90%+)
- **NDK管理**: NDK 27.0.12077973 统一配置

## 快速开始

### 常用命令

```bash
# 生成代码
flutter pub run build_runner build --delete-conflicting-outputs

# 多环境构建
./scripts/build.sh -p android -f dev -t debug     # 开发环境
./scripts/build.sh -p android -f staging -t debug # 测试环境
./scripts/build.sh -p android -f prod -t release  # 生产环境

# 运行测试
flutter test                                       # 运行所有测试
flutter test --coverage                           # 生成覆盖率
./scripts/test_coverage.sh                        # 覆盖率报告

# Golden测试
flutter test --update-goldens                     # 更新黄金文件

# Widgetbook组件预览
flutter run -t lib/main_widgetbook.dart

# Fastlane打包
cd android && fastlane build_dev                 # Android开发版
cd ios && fastlane build_dev                     # iOS开发版
```

### 使用Riverpod

```dart
// 定义Provider
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final authState = await ref.watch(authAsyncProvider.future);
  return authState!;
}

// 在Widget中使用
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    // 使用userAsync...
  }
}
```

### 使用事件总线

```dart
// 发布事件
UserLoggedInEvent(user: user, authMethod: 'email').publish();

// 订阅事件
EventBus().on<UserLoggedInEvent>((event) {
  print('User ${event.user.id} logged in');
});
```

### 使用数据可视化

```dart
// 创建图表
NutritionPieChart(
  data: [
    NutritionData(name: 'Protein', value: 25.5),
    NutritionData(name: 'Carbs', value: 45.2),
  ],
  config: ChartConfig(
    theme: ChartTheme.fromTheme(Theme.of(context)),
  ),
)
```

### 使用性能监控

```dart
// 在页面中使用性能监控
class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> 
    with PerformanceTrackingMixin, AnalyticsMixin {
  
  // 跟踪网络请求
  Future<void> loadData() async {
    await trackNetworkRequest('load_home_data', () async {
      return await repository.fetchData();
    });
  }
  
  // 跟踪用户行为
  void onButtonTap() {
    trackButtonClick('home_action_button');
    // 处理点击事件
  }
}
```

### 环境配置

```dart
// 使用环境配置
final config = AppConfig.instance;
final apiUrl = config.apiBaseUrl;
final isDebug = config.enableLogging;

// 根据环境执行不同逻辑
if (config.isDev) {
  // 开发环境特定代码
} else if (config.isProd) {
  // 生产环境特定代码
}
``` 