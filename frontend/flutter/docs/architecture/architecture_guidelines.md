# 前端架构规范指南

本文档提供智能营养餐厅App前端架构的规范和指导，以确保开发团队在实现各功能模块时遵循统一的标准。

## 目录

- [架构概述](#架构概述)
- [目录结构](#目录结构)
- [层次职责](#层次职责)
- [接口设计规范](#接口设计规范)
- [实现类规范](#实现类规范)
- [依赖注入规范](#依赖注入规范)
- [离线优先策略](#离线优先策略)
- [业务逻辑规范](#业务逻辑规范)
- [命名规范](#命名规范)
- [测试规范](#测试规范)
- [新增功能流程](#新增功能流程)

## 架构概述

我们的应用采用分层架构，结合了领域驱动设计(DDD)、接口隔离原则(ISP)和应用层协调者模式：

1. **表现层(UI)**：Flutter widgets、页面和状态管理
2. **应用层**：Use Cases(用例)，协调业务流程
3. **领域层**：包含核心业务逻辑和领域模型
4. **基础设施层**：处理外部服务、网络请求和本地存储

架构遵循以下核心原则：

- **依赖倒置原则**：高层模块不应依赖低层模块，二者都应依赖于抽象
- **接口隔离原则**：多个特定接口优于一个通用接口
- **单一职责原则**：每个类只负责一个职责
- **开闭原则**：对扩展开放，对修改关闭

## 目录结构

```
lib/
├── app/                        # 应用入口与全局配置
│   ├── app.dart
│   ├── main.dart
│   ├── router.dart
│   └── router.gr.dart
│
├── common/                     # 公共资源
│   ├── constants/
│   ├── exceptions/
│   ├── styles/
│   ├── utils/
│   └── widgets/
│
├── config/                     # 环境与配置文件
│   ├── config.dart
│   ├── env_config.dart
│   ├── l10n_config.dart
│   ├── locator_config.dart
│   ├── route_config.dart
│   └── widgetbook_config.dart
│
├── environment/               # 环境常量
│   ├── dev.dart
│   └── prod.dart
│
├── gen/                       # 自动生成文件
│   └── assets.gen.dart
│
├── l10n/                      # 多语言资源
│   ├── app_en.arb
│   ├── app_zh.arb
│   ├── app_localizations.dart
│   ├── app_localizations_en.dart
│   └── app_localizations_zh.dart
│
├── hooks/                     # 自定义Hooks
├── plugins/                   # 插件扩展
├── providers/                 # 全局状态管理
│   └── app_providers.dart
├── repositories/              # 仓库
├── services/                  # 服务层
│   ├── api_client.dart
│   └── generated/
└── modules/                   # 功能模块（每个模块含5类子目录）
    ├── {module}/
    │   ├── models/
    │   ├── providers/
    │   ├── screens/
    │   ├── services/
    │   └── widgets/
    └── ...
```

## 层次职责

### 表现层(UI)

- **职责**：显示数据和捕获用户输入
- **组件**：
  - **页面(Screens)**：完整的应用页面
  - **组件(Components)**：可复用的UI部件
  - **Provider**：管理UI状态和与应用层交互
  
- **规则**：
  - 不应包含业务逻辑
  - 通过Provider获取数据和触发动作
  - 关注点分离，遵循组件化设计

### 应用层

- **职责**：协调业务流程，编排仓库和服务的调用
- **组件**：
  - **Use Cases**：实现特定业务用例
  - **结果处理**：统一处理成功和失败情况
  
- **规则**：
  - 依赖抽象接口，不依赖具体实现
  - 封装跨领域的业务流程
  - 返回统一的结果类型(Result)

### 领域层

- **职责**：定义业务模型和核心规则
- **组件**：
  - **抽象接口**：定义与外部系统交互的约定
  - **领域模型**：业务实体和值对象
  - **领域服务**：跨实体的业务规则
  
- **规则**：
  - 不依赖外部框架
  - 纯粹的业务逻辑
  - 通过接口与外部系统交互

### 基础设施层

- **职责**：实现与外部系统的交互
- **组件**：
  - **仓库实现**：数据访问和持久化
  - **服务实现**：外部API调用
  - **依赖注入**：管理对象创建和依赖
  
- **规则**：
  - 实现领域层定义的接口
  - 处理技术细节，如网络请求、数据库访问
  - 异常转换为领域异常

## 接口设计规范

### 命名规范

- 接口名应以字母`I`开头，如`IUserService`
- 方法名应使用动词+名词形式，如`getUserProfile`
- 接口应关注单一职责，避免过大接口

### 职责分离

- **服务接口**：处理外部系统交互，如API调用
- **仓库接口**：处理数据访问和持久化
- **领域服务接口**：处理跨实体的业务规则

### 接口设计原则

- 遵循接口隔离原则，按功能分解接口
- 接口方法应表达意图而非实现细节
- 参数和返回类型应使用领域模型，避免暴露基础设施细节
- 异常处理策略应在接口中明确

示例：

```dart
/// 用户仓库接口
abstract class IUserRepository {
  /// 获取用户信息
  Future<UserModel> getUserProfile();
  
  /// 更新用户信息
  Future<UserModel> updateUserProfile(Map<String, dynamic> userData);
}
```

## 实现类规范

### 命名规范

- 实现类名应与接口名对应，去掉`I`前缀，如`UserService`实现`IUserService`
- 私有变量和方法应以下划线`_`开头

### 实现原则

- 实现类应专注于技术细节，不包含业务逻辑
- 错误处理遵循既定模式，如使用Result包装或异常转换
- 依赖其他服务时，应依赖其接口而非实现
- 使用依赖注入获取依赖，不直接实例化

示例：

```dart
@Injectable(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IUserService _userService;
  
  UserRepository(this._userService);
  
  @override
  Future<UserModel> getUserProfile() async {
    final response = await _userService.getUserProfile();
    if (!response.success) {
      throw Exception(response.message);
    }
    return response.data!;
  }
}
```

## 依赖注入规范

### 注册规则

- 所有依赖应通过接口注册，实现解耦
- 使用`@Injectable`和`@lazySingleton`等注解标注依赖
- 在`injection.dart`中集中管理依赖注册

### 使用规则

- 通过构造函数注入依赖
- 使用命名参数允许可选依赖
- 测试时使用依赖注入便于模拟

示例：

```dart
// 注册依赖
void _registerInterfaceImplementations() {
  locator.registerLazySingleton<IApiService>(() => ApiService());
  locator.registerLazySingleton<IUserService>(() => UserService(locator<IApiService>()));
}

// 使用依赖
class UserUseCase {
  final IUserRepository _userRepository;
  
  UserUseCase(this._userRepository);
  
  // ...
}
```

## 离线优先策略

应用采用离线优先架构，确保用户即使在网络连接不稳定或断开的情况下也能继续使用核心功能。

### 核心概念

- **离线优先**：应用程序首先考虑离线状态，然后再考虑在线状态
- **本地存储优先**：优先使用本地数据，减少对网络的依赖
- **操作队列化**：离线状态下的操作被保存并在网络恢复后自动同步
- **乐观UI更新**：操作立即反映在UI上，不等待服务器响应
- **数据冲突解决**：妥善处理本地数据与服务器数据的冲突

### 组件结构

- **OfflineSyncService**：管理离线操作队列、同步、网络监控
- **PendingOperation**：存储待处理的离线操作数据结构
- **EnhancedHttpClient**：支持离线功能的HTTP客户端
- **OfflineSyncIndicator**：显示同步状态的UI组件

### 数据存储规范

- 使用Hive作为本地存储引擎
- 所有关键业务数据都应缓存在本地
- 缓存数据应有明确的过期策略
- 实体模型应实现适当的序列化方法

### 离线操作规范

- 修改操作（创建/更新/删除）应支持离线队列
- 读取操作应优先使用本地缓存
- 离线操作应有优先级机制
- 敏感操作可配置为"仅在线模式"

### 乐观UI更新规范

- 立即反映用户操作结果，不等待服务器响应
- 使用视觉指示器区分"待同步"和"已同步"状态
- 实现变更监听机制，保持UI与数据状态一致
- 提供撤销/重做机制处理同步失败的情况

示例：

```dart
// 添加离线支持的网络请求
Future<void> createOrder(Order order) async {
  // 生成临时ID
  final tempId = generateTempId();
  
  try {
    // 使用支持离线功能的客户端
    final result = await enhancedHttpClient.post(
      '/api/orders',
      data: order.toJson(),
      entityType: 'order',
      entityId: tempId,
    );
    
    // 处理离线操作结果
    if (result['offline'] == true) {
      showMessage('订单已创建，将在网络恢复后同步');
    } else {
      showMessage('订单创建成功');
    }
  } catch (e) {
    showError('创建订单失败: $e');
  }
}

// 离线状态监听
void initOfflineListener() {
  enhancedHttpClient.addEntityChangeListener((entityType, change) {
    if (entityType == 'order') {
      // 基于状态变更更新UI
      if (change['status'] == 'success') {
        refreshOrderList();
      }
    }
  });
}
```

### 冲突解决策略

- 定义明确的冲突解决规则（服务器优先/客户端优先/智能合并）
- 冲突严重时提供用户介入的机制
- 维护操作日志，便于追踪和回溯
- 使用版本号或时间戳标记数据变更

## 业务逻辑规范

### 用例设计

- 每个用例应专注于单一业务流程
- 遵循`UseCase<Params, Result>`模式
- 用例应包含验证、执行和结果处理

### 结果处理

- 使用`Result<T>`包装异步操作结果
- 使用`fold`方法处理成功和失败情况
- 错误应分类并包含详细信息

示例：

```dart
class CompleteProfileUseCase {
  final IUserRepository _userRepository;
  
  CompleteProfileUseCase(this._userRepository);
  
  Future<Result<UserModel>> execute(CompleteProfileParams params) async {
    try {
      // 验证
      if (!_validateUserData(params.userData)) {
        return Result.failure(ValidationError(message: '数据格式不正确'));
      }
      
      // 执行
      final user = await _userRepository.updateUserProfile(params.userData);
      
      // 返回结果
      return Result.success(user);
    } catch (e) {
      return Result.failure(AppError(message: '更新失败: ${e.toString()}'));
    }
  }
}
```

## 命名规范

### 文件命名

- 小写字母，使用下划线分隔，如`user_repository.dart`
- 接口文件前缀为`i_`，如`i_user_repository.dart`
- 用例文件后缀为`_use_case`，如`get_user_profile_use_case.dart`

### 类命名

- 使用PascalCase(首字母大写)，如`UserRepository`
- 接口前缀为`I`，如`IUserRepository`
- Provider后缀为`Provider`，如`UserProvider`
- 用例后缀为`UseCase`，如`GetUserProfileUseCase`

### 方法命名

- 使用camelCase(首字母小写)，如`getUserProfile`
- 私有方法前缀为`_`，如`_validateUserData`

## 测试规范

### 测试金字塔架构

我们采用测试金字塔原则来组织测试，确保代码质量和稳定性：

![测试金字塔](https://miro.medium.com/max/1400/1*Tcj3OsK8Kou7tCMQgeeCuw.png)

- **单元测试**（底层，数量最多）：测试独立功能单元
- **组件测试**（中层）：测试UI组件的渲染和行为
- **集成测试**（中层）：测试多个组件间的协作
- **端到端测试**（顶层，数量最少）：测试完整用户流程

### 测试目录结构

```
test/
├── unit/                 # 单元测试
│   ├── application/      # 应用层用例测试
│   ├── repositories/     # 仓库实现测试
│   ├── services/         # 服务实现测试
│   └── models/           # 模型测试
│
├── component/            # 组件测试
│   └── {module}/         # 按模块分组的组件测试
│
├── integration/          # 集成测试
│   ├── repositories/     # 仓库集成测试
│   ├── services/         # 服务集成测试
│   └── screens/          # 屏幕集成测试
│
├── e2e/                  # 端到端测试
│   └── flows/            # 用户流程测试
│
└── mocks/                # 测试模拟对象
    └── {module}/         # 按模块分组的模拟对象
```

### 单元测试

单元测试是测试金字塔的基础，应覆盖所有独立功能单元：

- **测试对象**：用例(UseCase)、模型(Model)、服务(Service)、仓库(Repository)等
- **测试原则**：
  - 使用模拟对象隔离被测单元
  - 一个测试只测试一个函数的一个方面
  - 遵循"Arrange-Act-Assert"模式
  - 测试边界条件和异常情况
- **工具**：`flutter_test`、`mockito`或`mocktail`
- **命名约定**：`{tested_unit}_test.dart`

示例：

```dart
// test/unit/application/get_user_profile_use_case_test.dart
void main() {
  group('GetUserProfileUseCase', () {
    late MockUserRepository mockRepository;
    late GetUserProfileUseCase useCase;
    
    setUp(() {
      mockRepository = MockUserRepository();
      useCase = GetUserProfileUseCase(mockRepository);
    });
    
    test('should return success with user when repository succeeds', () async {
      // Arrange
      final user = UserModel(id: '1', name: '测试用户');
      when(mockRepository.getUserProfile()).thenAnswer((_) async => user);
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result.isSuccess, true);
      expect(result.value.id, '1');
      expect(result.value.name, '测试用户');
    });
    
    test('should return failure when repository throws exception', () async {
      // Arrange
      when(mockRepository.getUserProfile())
          .thenThrow(Exception('网络错误'));
      
      // Act
      final result = await useCase();
      
      // Assert
      expect(result.isFailure, true);
      expect(result.error.message, contains('网络错误'));
    });
  });
}
```

### 组件测试

组件测试关注UI组件的渲染和交互行为：

- **测试对象**：所有可重用的UI组件、Widget
- **测试原则**：
  - 验证组件正确渲染
  - 验证用户交互（点击、输入等）的正确响应
  - 验证组件的不同状态（加载中、错误、空数据等）
- **工具**：`flutter_test`的`testWidgets`、`WidgetTester`
- **命名约定**：`{component_name}_test.dart`

示例：

```dart
// test/component/common/nutrition_tag_selector_test.dart
void main() {
  testWidgets('NutritionTagSelector 正确显示标签列表', (WidgetTester tester) async {
    // Arrange
    final tags = ['低糖', '低脂', '高蛋白'];
    
    // Act
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NutritionTagSelector(
          tags: tags,
          selectedTags: const [],
          onTagSelected: (_) {},
        ),
      ),
    ));
    
    // Assert
    for (final tag in tags) {
      expect(find.text(tag), findsOneWidget);
    }
  });
  
  testWidgets('NutritionTagSelector 点击标签时调用回调', (WidgetTester tester) async {
    // Arrange
    final tags = ['低糖', '低脂', '高蛋白'];
    String? selectedTag;
    
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NutritionTagSelector(
          tags: tags,
          selectedTags: const [],
          onTagSelected: (tag) {
            selectedTag = tag;
          },
        ),
      ),
    ));
    
    // Act
    await tester.tap(find.text('低糖'));
    
    // Assert
    expect(selectedTag, '低糖');
  });
}
```

### 集成测试

集成测试验证多个组件间的协作：

- **测试对象**：
  - 多个服务和仓库的协作
  - 页面和状态管理的协作
  - 数据流从仓库到UI的完整路径
- **测试原则**：
  - 最小化模拟对象，测试真实交互
  - 关注组件间通信和数据流
  - 验证边界条件和错误处理
- **工具**：`flutter_test`、`integration_test`、`network_image_mock`
- **命名约定**：`{flow_name}_integration_test.dart`

示例：

```dart
// test/integration/screens/profile_screen_integration_test.dart
void main() {
  group('个人信息页面集成测试', () {
    late UserRepository userRepository;
    late NutritionRepository nutritionRepository;
    
    setUp(() {
      // 使用真实实现但模拟API响应
      final mockApi = MockApiService();
      userRepository = UserRepository(mockApi);
      nutritionRepository = NutritionRepository(mockApi);
      
      // 模拟API响应
      when(mockApi.getUserProfile()).thenAnswer((_) async => 
        ApiResponse(success: true, data: sampleUserResponse));
    });
    
    testWidgets('加载用户资料并显示营养档案', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => UserProvider(
                userRepository: userRepository,
                nutritionRepository: nutritionRepository,
              ),
            ),
          ],
          child: MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );
      
      // 模拟加载过程
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // 完成加载
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('测试用户'), findsOneWidget);
      expect(find.text('营养档案 (3)'), findsOneWidget);
    });
  });
}
```

### 端到端测试

端到端测试验证完整的用户场景：

- **测试对象**：完整用户流程，如注册、登录、创建营养档案等
- **测试原则**：
  - 模拟真实用户操作
  - 关注关键业务流程
  - 数量少但覆盖核心流程
- **工具**：`integration_test`、`flutter_driver`
- **命名约定**：`{user_flow}_test.dart`

示例：

```dart
// test/e2e/flows/create_nutrition_profile_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('创建营养档案流程', () {
    testWidgets('用户成功创建营养档案', (WidgetTester tester) async {
      // 启动应用
      app.main();
      await tester.pumpAndSettle();
      
      // 登录流程
      await tester.tap(find.text('登录'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(Key('password_field')), 'password123');
      await tester.tap(find.text('登录'));
      await tester.pumpAndSettle();
      
      // 导航到营养档案页面
      await tester.tap(find.text('我的营养'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('创建新档案'));
      await tester.pumpAndSettle();
      
      // 填写档案信息
      await tester.enterText(find.byKey(Key('profile_name')), '日常饮食档案');
      await tester.tap(find.text('男性'));
      await tester.tap(find.text('30-40岁'));
      await tester.enterText(find.byKey(Key('height')), '175');
      await tester.enterText(find.byKey(Key('weight')), '70');
      await tester.tap(find.text('减脂'));
      await tester.tap(find.text('保存'));
      
      // 验证结果
      await tester.pumpAndSettle();
      expect(find.text('档案创建成功'), findsOneWidget);
      expect(find.text('日常饮食档案'), findsOneWidget);
    });
  });
}
```

### 测试覆盖率

为确保足够的测试覆盖，我们设定以下覆盖率目标：

- **单元测试**：核心业务逻辑覆盖率 > 80%
- **组件测试**：所有共享组件至少有一个测试
- **集成测试**：所有主要用户流程至少有一个测试
- **端到端测试**：所有关键业务流程至少有一个测试

使用`flutter test --coverage`生成覆盖率报告，并定期审查测试覆盖情况。

### 测试自动化

- 配置CI/CD流水线运行所有测试
- 在Pull Request时触发测试运行
- 将单元测试和组件测试作为提交前的强制检查
- 定期运行集成测试和端到端测试

## 新增功能流程

实现新功能模块时，应遵循以下步骤：

1. **领域建模**：定义领域模型和业务规则
2. **接口设计**：设计仓库和服务接口
3. **实现接口**：创建服务和仓库实现
4. **用例实现**：实现业务用例
5. **Provider创建**：实现状态管理
6. **UI实现**：创建页面和组件
7. **测试**：编写单元和集成测试

### 示例：添加订单模块

1. 定义接口：
   ```dart
   // domain/abstractions/repositories/i_order_repository.dart
   abstract class IOrderRepository {
     Future<List<Order>> getOrders();
     Future<Order> createOrder(CreateOrderDto dto);
   }
   ```

2. 实现接口：
   ```dart
   // repositories/order/order_repository.dart
   @Injectable(as: IOrderRepository)
   class OrderRepository implements IOrderRepository {
     final IOrderService _orderService;
     
     OrderRepository(this._orderService);
     
     // 实现方法...
   }
   ```

3. 创建用例：
   ```dart
   // application/order/create_order_use_case.dart
   @injectable
   class CreateOrderUseCase {
     final IOrderRepository _orderRepository;
     
     CreateOrderUseCase(this._orderRepository);
     
     Future<Result<Order>> execute(CreateOrderParams params) async {
       // 实现逻辑...
     }
   }
   ```

4. 注册依赖：
   ```dart
   // core/di/injection.dart
   void _registerInterfaceImplementations() {
     // 已有代码...
     locator.registerLazySingleton<IOrderRepository>(() => OrderRepository(locator<IOrderService>()));
   }
   
   void _registerUseCases() {
     // 已有代码...
     locator.registerFactory<CreateOrderUseCase>(() => CreateOrderUseCase(locator<IOrderRepository>()));
   }
   ```

5. 创建Provider：
   ```dart
   // providers/order/order_provider.dart
   class OrderProvider extends ChangeNotifier {
     final AppUseCases _useCases;
     
     OrderProvider({AppUseCases? useCases}) : _useCases = useCases ?? AppUseCases.fromGetIt();
     
     // 实现方法...
   }
   ```

---

遵循上述规范，可以确保团队在实现不同功能模块时保持一致的代码风格和架构模式，提高代码质量和可维护性。 