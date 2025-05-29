# AI开发工具使用规范

## 🚫 禁止事项

1. **不要创建新的顶层目录**
   - 所有代码必须放在现有的目录结构中
   - 新功能应该作为 `features/` 下的子模块

2. **不要修改核心文件**
   - `lib/main.dart`
   - `lib/app.dart`
   - `lib/core/` 下的所有文件
   - `pubspec.yaml`（除非明确要求添加依赖）

3. **不要混合架构模式**
   - 不要在项目中引入 MVC、MVP 等其他架构
   - 严格遵循 Clean Architecture + DDD

4. **不要创建重复功能**
   - 使用现有的基类和工具类
   - 检查 `shared/` 目录中的可复用组件

## ✅ 必须遵循

### 1. 文件创建规则

创建新功能时，必须包含完整的层次结构：

```
features/[功能名]/
├── data/
│   ├── datasources/
│   │   └── [功能名]_remote_datasource.dart
│   ├── models/
│   │   └── [功能名]_model.dart
│   └── repositories/
│       └── [功能名]_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── [功能名].dart
│   ├── repositories/
│   │   └── [功能名]_repository.dart
│   └── usecases/
│       └── [具体用例]_usecase.dart
└── presentation/
    ├── pages/
    │   └── [功能名]_page.dart
    ├── widgets/
    │   └── [功能名]_widget.dart
    └── providers/
        └── [功能名]_provider.dart
```

### 2. 代码模板

#### 创建新的UseCase：
```dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/[entity_name].dart';
import '../repositories/[repository_name].dart';

class [UseCaseName]UseCase implements UseCase<[ReturnType], [ParamsType]> {
  final [RepositoryName]Repository repository;

  [UseCaseName]UseCase(this.repository);

  @override
  Future<Either<Failure, [ReturnType]>> call([ParamsType] params) async {
    return await repository.[methodName](params);
  }
}

class [ParamsType] extends Equatable {
  // 参数定义
  
  @override
  List<Object?> get props => [];
}
```

#### 创建新的Provider：
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/usecases/[usecase_name].dart';

part '[provider_name]_provider.freezed.dart';

@freezed
class [StateName] with _$[StateName] {
  const factory [StateName].initial() = _Initial;
  const factory [StateName].loading() = _Loading;
  const factory [StateName].loaded([DataType] data) = _Loaded;
  const factory [StateName].error(String message) = _Error;
}

@riverpod
class [ProviderName]Notifier extends _$[ProviderName]Notifier {
  @override
  [StateName] build() => const [StateName].initial();

  Future<void> load() async {
    state = const [StateName].loading();
    
    final useCase = ref.read([useCaseProvider]);
    final result = await useCase(params);
    
    state = result.fold(
      (failure) => [StateName].error(failure.message),
      (data) => [StateName].loaded(data),
    );
  }
}
```

### 3. 导入规则

```dart
// ✅ 正确的导入顺序
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. 第三方包
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

// 4. 项目内导入（使用相对路径）
import '../../domain/entities/user.dart';
import '../widgets/user_card.dart';

// ❌ 错误的导入
import 'package:ai_nutrition_restaurant/...'  // 不要使用包名导入
```

### 4. 状态管理规则

- 使用 Riverpod，不要使用 setState
- 使用 freezed 生成不可变状态类
- 使用 AsyncValue 处理异步状态
- Provider 必须是顶层变量或使用 @riverpod 注解

### 5. 错误处理规则

```dart
// 所有异步操作必须返回 Either<Failure, Success>
Future<Either<Failure, User>> getUser() async {
  try {
    final response = await api.getUser();
    return Right(User.fromJson(response));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

## 🔧 AI工具配置建议

### 对于 Cursor：

1. 在 `.cursor/rules` 文件中添加：
```
- 遵循 AI_DEVELOPMENT_RULES.md 中的所有规则
- 不要创建新的顶层目录
- 使用现有的架构模式
- 检查 features/ 下是否已有类似功能
```

2. 使用上下文文件：
- 始终包含 `ARCHITECTURE_FREEZE.md`
- 包含相关feature的 README.md

### 对于 GitHub Copilot：

在 `.github/copilot-instructions.md` 中定义规则

## 📋 检查清单

在提交代码前，确保：

- [ ] 没有创建新的顶层目录
- [ ] 遵循了正确的文件命名规范
- [ ] 包含了必要的测试文件
- [ ] 没有硬编码的值（使用常量或配置）
- [ ] 没有直接的跨层调用
- [ ] 使用了依赖注入而不是直接实例化
- [ ] 错误处理使用了 Either 模式
- [ ] UI组件是无状态的或使用 Riverpod 管理状态

## 🚨 常见错误示例

```dart
// ❌ 错误：直接在UI中调用API
class MyPage extends StatelessWidget {
  void loadData() async {
    final response = await http.get('...');  // 错误！
  }
}

// ✅ 正确：通过Provider和UseCase
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    // UI代码
  }
}
```

## 🎯 记住

> "AI是辅助工具，不是架构师。遵循既定架构，不要让AI重新发明轮子。"