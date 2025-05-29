# Coordinator 层架构

## 概述

Coordinator 层负责处理跨模块的业务流程编排，解耦页面与复杂的业务逻辑流程。每个 Coordinator 专注于特定领域的流程管理。

## 设计理念

- **单一职责**：每个 Coordinator 负责一个业务领域的流程编排
- **流程编排**：将多步骤的业务流程抽象为统一的接口
- **解耦导航**：页面不需要知道下一步该去哪，由 Coordinator 决定
- **可测试性**：业务流程独立于 UI，便于单元测试

## 目录结构

```
lib/
├── core/
│   └── coordinators/
│       ├── base_coordinator.dart       # 基类
│       ├── coordinator_result.dart     # 结果类型
│       ├── coordinator_manager.dart    # 管理器
│       └── README.md                  # 本文档
└── features/
    ├── auth/
    │   └── presentation/
    │       └── coordinators/
    │           └── auth_flow_coordinator.dart
    ├── nutrition/
    │   └── presentation/
    │       └── coordinators/
    │           └── nutrition_flow_coordinator.dart
    └── ... # 其他模块
```

## 核心组件

### 1. BaseCoordinator

所有 Coordinator 的基类，提供基础功能：

```dart
abstract class BaseCoordinator {
  final Ref ref;
  late final RouterManager _routerManager;
  
  BaseCoordinator(this.ref);
  
  RouterManager get router => _routerManager;
  Future<void> start();
  void dispose();
}
```

### 2. CoordinatorResult

统一的结果类型，支持成功、失败、取消三种状态：

```dart
@freezed
class CoordinatorResult<T> with _$CoordinatorResult<T> {
  const factory CoordinatorResult.success({required T data, String? message}) = _Success<T>;
  const factory CoordinatorResult.failure({required String error, String? code}) = _Failure<T>;
  const factory CoordinatorResult.cancelled() = _Cancelled<T>;
}
```

### 3. CoordinatorManager

集中管理所有 Coordinator，提供统一访问接口：

```dart
class CoordinatorManager {
  AuthFlowCoordinator get auth => ...
  NutritionFlowCoordinator get nutrition => ...
  OrderFlowCoordinator get order => ...
  ConsultationFlowCoordinator get consultation => ...
}
```

## 使用指南

### 1. 在页面中使用

```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        // 获取 Coordinator
        final coordinator = ref.read(coordinatorManagerProvider).auth;
        
        // 执行业务流程
        final result = await coordinator.handleLoginSuccess(user);
        
        // 处理结果
        result.when(
          success: (data, message) {
            // 成功处理
          },
          failure: (error, code) {
            // 错误处理
          },
          cancelled: () {
            // 取消处理
          },
        );
      },
      child: Text('执行流程'),
    );
  }
}
```

### 2. 创建新的 Coordinator

```dart
class MyFlowCoordinator extends BaseCoordinator {
  MyFlowCoordinator(super.ref);
  
  @override
  Future<void> start() async {
    // 初始导航
  }
  
  // 定义业务流程方法
  Future<CoordinatorResult<void>> handleMyFlow() async {
    try {
      // 1. 执行步骤1
      // 2. 执行步骤2
      // 3. 导航到下一页
      return CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(error: '流程失败');
    }
  }
}
```

### 3. 在 Provider 中使用

```dart
final myProvider = Provider((ref) {
  final coordinator = ref.read(coordinatorManagerProvider).nutrition;
  
  // 使用 coordinator 处理业务流程
  return MyService(coordinator);
});
```

## 已实现的 Coordinator

### AuthFlowCoordinator
- `handleLoginSuccess`: 登录成功后的流程（检查资料、营养档案等）
- `handleRegisterSuccess`: 注册成功后的流程
- `handleProfileCompletionSuccess`: 资料完善后的流程
- `handleLogout`: 登出流程

### NutritionFlowCoordinator
- `handleProfileCreationSuccess`: 营养档案创建完成后的流程
- `handleAiRecommendationComplete`: AI推荐完成后的流程
- `handleRecommendationViewComplete`: 推荐查看完成后的流程
- `handleProfileSwitch`: 档案切换流程
- `handleProfileDeletion`: 档案删除流程

### OrderFlowCoordinator
- `handleMealSelection`: 餐品选择流程（营养分析、确认等）
- `handleOrderPayment`: 订单支付流程
- `handleOrderCompletion`: 订单完成后的流程（评价、营养建议）
- `handleOrderCancellation`: 订单取消流程

### ConsultationFlowCoordinator
- `handleNutritionistSelection`: 选择营养师流程
- `handleConsultationStart`: 咨询开始流程
- `handleConsultationEnd`: 咨询结束流程（报告生成、评价）
- `handleConsultationPayment`: 咨询支付流程
- `handleConsultationCancellation`: 咨询取消流程（退款处理）

## 最佳实践

1. **流程粒度**：每个方法处理一个完整的业务流程，不要过于细碎
2. **错误处理**：使用 CoordinatorResult 统一处理成功、失败、取消
3. **导航管理**：所有导航操作通过 router 属性进行
4. **状态管理**：Coordinator 不应该持有状态，状态应该在 Provider 中管理
5. **测试友好**：将业务逻辑抽离到可测试的方法中

## 扩展指南

添加新的 Coordinator：

1. 在对应 feature 的 `presentation/coordinators/` 目录创建文件
2. 继承 `BaseCoordinator`
3. 实现 `start()` 方法和业务流程方法
4. 在 `CoordinatorManager` 中添加访问器
5. 创建 Provider（可选）

## 注意事项

- Coordinator 是无状态的，不要在其中存储业务数据
- 复杂的对话框、选择器等 UI 操作应该抽象为方法
- 保持方法的原子性，每个方法完成一个独立的流程
- 使用有意义的方法名，清晰表达业务意图