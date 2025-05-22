# 前端架构快速入门

本文档为新加入智能营养餐厅App项目的开发者提供快速入门指南，帮助您理解项目架构和开发流程。

## 架构概览

我们的应用采用分层架构，遵循干净架构和领域驱动设计原则。这种架构有助于：

- **解耦**：各层之间通过接口隔离，降低耦合
- **可测试性**：业务逻辑可独立测试，不依赖于UI或外部系统
- **可维护性**：代码结构清晰，职责分明

主要分层如下：

### 🎨 表现层 (UI)

Flutter widgets和页面，负责显示和用户交互。通过Provider与应用层交互。

**关键文件位置**：
- `lib/modules/{module}/screens/` - 页面组件
- `lib/common/widgets/` - 可复用UI组件
- `lib/modules/{module}/providers/` 和 `lib/providers/app_providers.dart` - 状态管理，模块各自维护自己的Provider，顶层提供一个总入口

### 🔄 应用层 (Application)

业务用例和流程协调，封装业务流程，组织仓库调用。

**关键文件位置**：
- `lib/application/core/` - 基础用例类和结果处理
- `lib/application/{module}/` - 按模块分组的用例

### 📊 领域层 (Domain)

业务核心，包含领域模型和抽象接口。

**关键文件位置**：
- `lib/domain/abstractions/` - 抽象接口
- 模型按模块放置于 `lib/modules/{module}/models/`

### 🛠 基础设施层 (Infrastructure)

技术实现细节，如API调用、数据库访问等。

**关键文件位置**：
- `lib/services/` - 服务实现
- `lib/repositories/` - 仓库实现

### ⚙️ 配置层 (Config)

集中管理配置类，如环境变量、路由、Widgetbook等。

**关键文件位置**：
- `lib/config/`

## 常见开发场景

### 1. 实现新功能

实现新功能时，请按照以下步骤：

1. **创建/更新领域模型**
   ```dart
   // lib/modules/{module}/models/order_model.dart
   class Order {
     final String id;
     final String status;
     // ...
   }
   ```

2. **定义接口**
   ```dart
   // lib/domain/abstractions/repositories/i_order_repository.dart
   abstract class IOrderRepository {
     Future<List<Order>> getOrders();
     Future<Order> createOrder(CreateOrderDto dto);
   }
   ```

3. **实现仓库和服务**
   ```dart
   // lib/repositories/order/order_repository.dart
   @Injectable(as: IOrderRepository)
   class OrderRepository implements IOrderRepository {
     final IOrderService _orderService;
     
     OrderRepository(this._orderService);
     
     // 实现方法...
   }
   ```

4. **创建用例**
   ```dart
   // lib/application/order/get_orders_use_case.dart
   @injectable
   class GetOrdersUseCase {
     final IOrderRepository _orderRepository;
     
     GetOrdersUseCase(this._orderRepository);
     
     Future<Result<List<Order>>> execute() async {
       // 实现逻辑...
     }
   }
   ```

5. **注册依赖**
   ```dart
   // lib/core/di/injection.dart
   void _registerInterfaceImplementations() {
     // 注册服务和仓库...
     locator.registerLazySingleton<IOrderRepository>(() => 
         OrderRepository(locator<IOrderService>()));
   }
   ```

6. **创建Provider**
   ```dart
   // lib/modules/order/providers/order_provider.dart
   class OrderProvider extends ChangeNotifier {
     final AppUseCases _useCases;
     
     // 实现方法...
   }
   ```

7. **实现UI**
   ```dart
   // lib/modules/order/screens/order_list_screen.dart
   class OrderListScreen extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return Consumer<OrderProvider>(
         builder: (context, provider, _) {
           // 构建UI...
         },
       );
     }
   }
   ```

### 2. 调试数据流

理解数据如何在各层之间流动：

**用户操作** → Provider方法调用 → 用例执行 → 仓库方法调用 → 服务API请求 → 数据返回 → 结果封装 → 状态更新 → UI刷新

## 常用类说明

### Result\<T\>

封装操作结果，处理成功和失败情况：

```dart
// 使用示例
final result = await getUserProfileUseCase();

result.fold(
  (user) {
    // 处理成功情况
    _user = user;
  },
  (error) {
    // 处理错误情况
    _errorMessage = error.message;
  },
);
```

### AppUseCases

统一访问所有用例的协调器：

```dart
// 使用示例
final _useCases = AppUseCases.fromGetIt();

// 调用用例
final result = await _useCases.getUserProfile();
```

## 测试指南

我们采用测试金字塔原则组织测试架构，确保代码质量和稳定性：

![测试金字塔](https://miro.medium.com/max/1400/1*Tcj3OsK8Kou7tCMQgeeCuw.png)

### 测试类型

- **单元测试**：测试独立功能单元（如用例、服务、仓库等）
  ```dart
  // 用例测试示例
  void main() {
    group('GetUserProfileUseCase', () {
      late MockUserRepository mockRepository;
      late GetUserProfileUseCase useCase;
      
      setUp(() {
        mockRepository = MockUserRepository();
        useCase = GetUserProfileUseCase(mockRepository);
      });
      
      test('should return user when repository succeeds', () async {
        // Arrange
        when(mockRepository.getUserProfile())
            .thenAnswer((_) async => testUser);
        
        // Act
        final result = await useCase();
        
        // Assert
        expect(result.isSuccess, true);
        expect(result.value, testUser);
      });
    });
  }
  ```

- **组件测试**：测试UI组件的渲染和交互行为
  ```dart
  void main() {
    testWidgets('NutritionTagSelector 正确显示标签列表', (WidgetTester tester) async {
      final tags = ['低糖', '低脂', '高蛋白'];
      
      await tester.pumpWidget(MaterialApp(
        home: NutritionTagSelector(
          tags: tags,
          selectedTags: const [],
          onTagSelected: (_) {},
        ),
      ));
      
      for (final tag in tags) {
        expect(find.text(tag), findsOneWidget);
      }
    });
  }
  ```

- **集成测试**：测试多个组件协作
  ```dart
  void main() {
    testWidgets('ProfileScreen 显示用户数据', (WidgetTester tester) async {
      // 设置模拟数据...
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider(...)),
          ],
          child: MaterialApp(home: ProfileScreen()),
        ),
      );
      
      // 验证UI...
    });
  }
  ```

- **端到端测试**：测试完整用户流程
  ```dart
  void main() {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    
    testWidgets('用户创建营养档案', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // 执行完整用户流程...
      // 验证结果...
    });
  }
  ```

### 运行测试

```bash
# 运行单元测试和组件测试
flutter test

# 运行特定测试文件
flutter test test/unit/models/nutrition_profile_model_test.dart

# 运行集成测试
flutter test integration_test/app_test.dart
```

### 测试最佳实践

- 遵循AAA模式：Arrange（准备）、Act（执行）、Assert（断言）
- 一个测试只测试一个方面
- 使用模拟对象隔离被测单元
- 测试边界条件和异常情况

完整的测试指南请参阅：[测试架构指南](../../test/README.md)

## 常见问题

### 应该把业务逻辑放在哪里？

业务逻辑应该放在**用例(Use Case)**中，不要放在Provider或UI组件中。

### 如何处理表单验证？

表单验证应在用例层处理，确保业务规则在所有使用场景中一致执行。

### 怎样在测试中模拟依赖？

使用Mockito创建模拟对象，替代真实依赖：

```dart
@GenerateMocks([IUserRepository])
import 'get_user_profile_use_case_test.mocks.dart';

void main() {
  late MockIUserRepository mockRepository;
  late GetUserProfileUseCase useCase;
  
  setUp(() {
    mockRepository = MockIUserRepository();
    useCase = GetUserProfileUseCase(mockRepository);
  });
  
  // 测试...
}
```

## 推荐阅读

1. [架构规范指南](architecture_guidelines.md) - 详细的架构设计原则
2. [代码模板](code_templates.md) - 标准代码模板和示例
3. [接口隔离原则](../domain/abstractions/README.md) - 接口设计指南 