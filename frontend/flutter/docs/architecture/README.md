# 智能营养餐厅App架构文档

欢迎阅读智能营养餐厅App的架构文档。本文档集提供了应用架构的详细说明和实现指南，帮助开发团队理解系统设计并保持一致的开发风格。

## 文档索引

### 规范文档

1. [架构规范指南](architecture_guidelines.md) - 详细的架构设计原则和实现规范
2. [代码模板](code_templates.md) - 标准代码模板和示例
3. [离线优先架构](offline_first.md) - 离线优先的架构设计和实现方案
4. [测试架构指南](testing_architecture.md) - 测试金字塔架构和测试实现方案
5. [测试详细实例](../../test/README.md) - 详细的测试类型实现示例

### 实施文档

6. [接口隔离原则](../domain/abstractions/README.md) - 接口设计和隔离原则的实现指南
7. [应用层协调者模式](../application/README.md) - 用例和业务流程协调的实现方式

## 架构概览

我们的应用采用了结合领域驱动设计(DDD)和干净架构(Clean Architecture)的分层设计：

```
┌─────────────┐
│    UI层     │  modules 下按功能划分的 screens、widgets、providers 目录
└─────┬───────┘
      │
┌─────▼───────┐
│   应用层    │  Use Cases, App Coordinators
└─────┬───────┘
      │
┌─────▼───────┐
│   领域层    │  Domain Models, Interfaces
└─────┬───────┘
      │
┌─────▼───────┐
│ 基础设施层  │  Services, Repositories, External APIs
└─────────────┘
```

### 核心原则

- **依赖倒置**: 高层模块不应依赖低层模块，二者应依赖抽象
- **接口隔离**: 客户端不应依赖它不使用的接口
- **单一职责**: 一个类应该只有一个引起它变化的原因
- **开闭原则**: 对扩展开放，对修改封闭
- **离线优先**: 应用首先考虑离线情况，确保核心功能在无网络时可用

## 技术栈

- **UI框架**: Flutter
- **状态管理**: Provider
- **依赖注入**: GetIt + Injectable
- **网络**: Dio
- **本地存储**: Hive, SharedPreferences
- **离线同步**: 自定义离线同步框架(OfflineSyncService)
- **网络状态检测**: Connectivity Plus
- **导航**: GoRouter
- **测试框架**: Flutter Test, Mockito, Integration Test
- **测试模拟**: Mockito, Mocktail, Network Image Mock
- **UI测试**: Flutter Driver, Golden Toolkit 