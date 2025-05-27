# 测试架构设计

本文档详细描述了AI营养餐厅应用的测试架构设计，包括测试类型、组织方式和最佳实践。

## 目录

- [概述](#概述)
- [测试金字塔](#测试金字塔)
- [测试类型](#测试类型)
- [目录结构](#目录结构)
- [测试工具](#测试工具)
- [实现指南](#实现指南)
- [自动化测试](#自动化测试)
- [最佳实践](#最佳实践)
- [代码审查检查清单](#代码审查检查清单)

## 概述

我们的测试架构遵循测试金字塔原则，自下而上分为单元测试、组件测试、集成测试和端到端测试。这种分层方法确保了测试的全面性和效率，同时保持了适当的测试投入比例。

测试架构的主要目标是：
- 确保代码质量和功能正确性
- 早期发现并解决问题
- 支持安全重构
- 提供功能文档
- 降低维护成本

## 测试金字塔

![测试金字塔](https://miro.medium.com/max/1400/1*Tcj3OsK8Kou7tCMQgeeCuw.png)

测试金字塔描述了不同类型测试的数量比例：
- 底层（单元测试）：数量最多，执行最快，维护成本最低
- 中层（组件/集成测试）：数量适中，关注组件间交互
- 顶层（端到端测试）：数量最少，执行最慢，但覆盖关键用户流程

## 测试类型

### 单元测试

单元测试关注独立功能单元的正确性，通常通过模拟外部依赖来隔离被测单元。

**测试对象**：
- 用例(Use Cases)
- 服务(Services)
- 仓库(Repositories)
- 数据模型(Models)
- 工具类(Utilities)

**示例**：

```dart
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
      expect(result.value, user);
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

组件测试验证UI组件的渲染和交互行为，确保组件在各种状态下正确显示和响应用户操作。

**测试对象**：
- Widget组件
- 自定义UI元素
- 表单控件

**示例**：

```dart
void main() {
  group('NutritionTagSelector 组件测试', () {
    testWidgets('应显示所有提供的标签', (WidgetTester tester) async {
      final tags = ['低糖', '低脂', '高蛋白'];
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: NutritionTagSelector(
            tags: tags,
            selectedTags: const [],
            onTagSelected: (_) {},
          ),
        ),
      ));
      
      // 验证所有标签都已显示
      for (final tag in tags) {
        expect(find.text(tag), findsOneWidget);
      }
    });
    
    testWidgets('点击未选中的标签应调用onTagSelected', (WidgetTester tester) async {
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
      
      // 点击标签
      await tester.tap(find.text('低糖'));
      
      // 验证回调是否被调用
      expect(selectedTag, '低糖');
    });
  });
}
```

### 集成测试

集成测试验证多个组件协同工作的情况，关注组件间的交互和数据流。

**测试对象**：
- 页面(Screens)与Provider的交互
- 多个服务和仓库的协作
- 导航和路由

**示例**：

```dart
void main() {
  group('个人资料页面集成测试', () {
    late MockApiService mockApiService;
    late UserRepository userRepository;
    late NutritionRepository nutritionRepository;
    
    setUp(() {
      mockApiService = MockApiService();
      userRepository = UserRepository(mockApiService);
      nutritionRepository = NutritionRepository(mockApiService);
      
      // 模拟API响应
      when(mockApiService.getUserProfile()).thenAnswer((_) async => 
        MockApiResponse.success(testUser));
    });
    
    testWidgets('应加载并显示用户资料和营养档案', (WidgetTester tester) async {
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
      
      // 初始显示加载状态
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // 等待加载完成
      await tester.pumpAndSettle();
      
      // 验证内容显示
      expect(find.text('测试用户'), findsOneWidget);
      expect(find.text('营养档案 (3)'), findsOneWidget);
    });
  });
}
```

### 端到端测试

端到端测试验证完整的用户流程，模拟真实用户操作，确保关键业务流程正常工作。

**测试对象**：
- 完整用户旅程
- 跨多个页面的操作流程
- 实际API交互（可选）

**示例**：

```dart
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
      // ...其他字段填写
      
      // 保存档案
      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();
      
      // 验证结果
      expect(find.text('档案创建成功'), findsOneWidget);
      expect(find.text('日常饮食档案'), findsOneWidget);
    });
  });
}
```

## 目录结构

我们的测试目录结构与代码结构对应，并按测试类型组织：

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

## 测试工具

我们使用以下工具来支持测试：

1. **flutter_test**：Flutter自带的测试框架
2. **mockito/mocktail**：创建模拟对象
3. **integration_test**：集成和端到端测试支持
4. **network_image_mock**：模拟网络图片加载
5. **golden_toolkit**：支持黄金文件测试（视觉回归测试）

## 实现指南

### 模拟对象

我们使用Mockito来创建模拟对象：

```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ai_nutrition_restaurant/domain/abstractions/repositories/i_user_repository.dart';

// 生成模拟类
@GenerateMocks([IUserRepository])
void main() {}
```

然后运行代码生成：

```bash
flutter pub run build_runner build
```

### 测试命名约定

测试命名应清晰描述被测试的行为：

```dart
test('should calculate correct BMI when height and weight are provided', () {...});
test('should throw exception when age is negative', () {...});
test('should display error message when login fails', () {...});
```

### 编写单元测试的步骤

1. **导入必要的包**
2. **创建测试组**：使用`group`将相关测试分组
3. **设置测试环境**：使用`setUp`和`tearDown`准备和清理测试环境
4. **编写测试**：使用AAA模式（Arrange-Act-Assert）
5. **模拟依赖**：使用Mockito模拟外部依赖
6. **验证行为**：使用断言验证结果

## 自动化测试

### 持续集成

我们在CI/CD流程中集成测试：

1. **Pull Request检查**：所有PR必须通过单元测试和组件测试
2. **夜间构建**：定期运行完整的测试套件，包括集成测试和端到端测试
3. **发布前检查**：发布前运行所有测试以确保质量

### 测试覆盖率

我们使用以下命令生成覆盖率报告：

```bash
flutter test --coverage
```

覆盖率目标：
- 单元测试：核心业务逻辑 > 80%
- 组件测试：关键UI组件 100%覆盖
- 集成测试：主要用户流程全覆盖
- 端到端测试：关键业务流程全覆盖

## 最佳实践

1. **测试独立性**：每个测试应该独立运行，不依赖其他测试
2. **测试对象隔离**：使用模拟对象隔离被测单元
3. **关注行为而非实现**：测试应验证行为而非实现细节
4. **遵循AAA模式**：Arrange（准备）、Act（执行）、Assert（断言）
5. **一个测试一个断言**：每个测试专注于一个方面
6. **测试边界条件**：包括正常情况、边界条件和异常情况
7. **避免测试私有方法**：通过公共API测试私有方法的行为
8. **测试驱动开发**：考虑先编写测试再实现功能
9. **持续维护测试**：随着代码变化更新测试
10. **保持测试简洁**：测试代码应该简单易懂

## 代码审查检查清单

本检查清单用于代码审查过程中，确保新加入的代码符合项目架构规范。

### 测试检查

- [ ] 用例有单元测试
- [ ] 测试覆盖了成功和失败场景
- [ ] 测试使用模拟对象隔离依赖
- [ ] 测试断言验证了关键行为
- [ ] 测试名称清晰描述测试场景和预期结果
- [ ] 测试结构遵循测试金字塔原则
- [ ] 单元测试覆盖了所有公共方法
- [ ] 组件测试验证了UI渲染和用户交互
- [ ] 集成测试验证了多个组件协作
- [ ] 端到端测试覆盖了关键用户流程
- [ ] 使用了适当的测试工具（Mockito、Flutter Test等）
- [ ] 测试代码组织到正确的测试目录中
- [ ] 测试遵循AAA(Arrange-Act-Assert)模式
- [ ] 测试没有不必要的依赖和硬编码值

### 功能实现流程测试检查

当实现新功能模块时，确保测试按照以下顺序完成：

- [ ] 模型单元测试
- [ ] 仓库单元测试
- [ ] 服务单元测试
- [ ] 用例单元测试
- [ ] UI组件测试
- [ ] 页面集成测试
- [ ] 端到端流程测试

### 接口设计检查

- [ ] 接口名称使用`I`前缀（如`IUserRepository`）
- [ ] 接口遵循单一职责原则，功能聚焦
- [ ] 接口方法声明清晰，名称表达意图
- [ ] 接口方法参数和返回类型使用领域模型
- [ ] 接口注释完整，包含方法用途和参数说明

### 实现类检查

- [ ] 实现类名去掉接口名中的`I`前缀（如`UserRepository`实现`IUserRepository`）
- [ ] 类上方添加了`@Injectable`和`@lazySingleton`等适当注解
- [ ] 类通过构造函数注入依赖，依赖于接口而非实现
- [ ] 实现方法处理了成功和异常情况
- [ ] 私有方法和属性使用下划线`_`前缀
- [ ] 错误转换为领域错误，不暴露底层实现细节

### 用例检查

- [ ] 用例类实现单一业务流程
- [ ] 用例依赖于仓库接口，不依赖具体实现
- [ ] 用例参数类（如果有）清晰封装所需数据
- [ ] 用例实现了数据验证逻辑
- [ ] 用例使用`Result`类型封装结果
- [ ] 用例处理并转换异常为适当的错误类型
- [ ] 用例实现了`call`方法以便调用者使用

### Provider/Riverpod检查

- [ ] Provider类只负责UI状态管理
- [ ] Provider通过依赖注入获取用例实例
- [ ] Provider使用`notifyListeners`通知状态变化（Provider模式）
- [ ] AsyncNotifier正确处理加载、成功和错误状态（Riverpod模式）
- [ ] Provider方法命名清晰表达意图
- [ ] Provider不包含业务逻辑，仅协调用例调用

### 依赖注入检查

- [ ] 在`injection.dart`或相关文件中注册了新服务、仓库和用例
- [ ] 依赖注册使用接口类型，而非实现类型
- [ ] 依赖注册遵循依赖关系顺序
- [ ] 对单例和工厂实例使用了恰当的注册方法

### 命名规范检查

- [ ] 文件名使用小写字母和下划线（如`user_repository.dart`）
- [ ] 类名使用PascalCase（首字母大写，如`UserRepository`）
- [ ] 方法名使用camelCase（首字母小写，如`getUserProfile`）
- [ ] 常量名使用SCREAMING_SNAKE_CASE（全大写下划线，如`API_BASE_URL`）
- [ ] 变量名使用描述性命名，避免缩写和单字母

### 文档检查

- [ ] 类和公共方法有文档注释
- [ ] 复杂逻辑有行内注释说明
- [ ] 参数、返回值和异常有说明
- [ ] 代码遵循项目统一的文档风格

### 提交前最终检查

- [ ] 代码符合项目架构规范
- [ ] 未包含调试代码和注释掉的代码
- [ ] 所有测试通过
- [ ] 代码风格一致（使用linter检查）
- [ ] 性能问题已评估和处理

---

更多详细的测试指南和示例，请参阅[测试README文档](../../test/README.md)。 