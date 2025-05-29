# Provider 迁移指南

## 概述

本指南说明如何将现有的 StateNotifier/ChangeNotifier 模式迁移到 Riverpod 2.0 的 AsyncNotifier 模式。

## 迁移对比

### 旧模式 (StateNotifier)

```dart
class OldNotifier extends StateNotifier<OldState> {
  OldNotifier() : super(const OldState.initial());
  
  Future<void> loadData() async {
    state = const OldState.loading();
    try {
      final data = await repository.getData();
      state = OldState.data(data);
    } catch (e) {
      state = OldState.error(e.toString());
    }
  }
}

final oldNotifierProvider = StateNotifierProvider<OldNotifier, OldState>(
  (ref) => OldNotifier(),
);
```

### 新模式 (AsyncNotifier)

```dart
@riverpod
class NewNotifier extends _$NewNotifier {
  @override
  Future<Data> build() async {
    // 在 build 方法中执行初始化逻辑
    return ref.read(repositoryProvider).getData();
  }
  
  Future<void> refreshData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => 
      ref.read(repositoryProvider).getData()
    );
  }
}
```

## 迁移步骤

### 1. 更新依赖

```yaml
dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.3.5

dev_dependencies:
  riverpod_generator: ^2.4.3
  riverpod_lint: ^2.3.13
  build_runner: ^2.4.13
```

### 2. 状态类迁移

#### 旧状态类
```dart
@freezed
class OldState with _$OldState {
  const factory OldState.initial() = _Initial;
  const factory OldState.loading() = _Loading;
  const factory OldState.data(Data data) = _Data;
  const factory OldState.error(String message) = _Error;
}
```

#### 新状态类（简化）
```dart
@freezed
class NewState with _$NewState {
  const factory NewState({
    required Data data,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _NewState;
}
```

### 3. Provider 迁移

#### 从 StateNotifier 迁移
```dart
// 旧方式
class DataNotifier extends StateNotifier<AsyncValue<Data>> {
  DataNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadData();
  }
  
  final Repository _repository;
  
  Future<void> _loadData() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getData());
  }
}

final dataNotifierProvider = StateNotifierProvider<DataNotifier, AsyncValue<Data>>(
  (ref) => DataNotifier(ref.read(repositoryProvider)),
);

// 新方式
@riverpod
class DataNotifier extends _$DataNotifier {
  @override
  Future<Data> build() {
    return ref.read(repositoryProvider).getData();
  }
  
  Future<void> refresh() {
    return ref.refresh(dataNotifierProvider.future);
  }
}
```

#### 从 ChangeNotifier 迁移
```dart
// 旧方式
class AuthProvider extends ChangeNotifier {
  AuthUser? _user;
  bool _isLoading = false;
  
  AuthUser? get user => _user;
  bool get isLoading => _isLoading;
  
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await authRepository.signIn(email, password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

// 新方式
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    final user = await ref.read(authRepositoryProvider).getCurrentUser();
    return AuthState(user: user);
  }
  
  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(authRepositoryProvider).signIn(email, password);
      return AuthState(user: user);
    });
  }
}
```

### 4. UI 层使用

#### 使用 AsyncView 组件
```dart
class DataPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(dataNotifierProvider);
    
    return Scaffold(
      body: AsyncView<Data>(
        value: dataState,
        data: (data) => DataWidget(data: data),
        loading: () => const LoadingWidget(),
        error: (error, stack) => ErrorWidget(error: error),
      ),
    );
  }
}
```

#### 带刷新功能
```dart
class DataPageWithRefresh extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(dataNotifierProvider);
    
    return Scaffold(
      body: AsyncViewWithRefresh<Data>(
        value: dataState,
        data: (data) => DataWidget(data: data),
        onRefresh: () => ref.refresh(dataNotifierProvider.future),
      ),
    );
  }
}
```

## 最佳实践

### 1. 依赖注入
```dart
@riverpod
Repository repository(RepositoryRef ref) {
  return RepositoryImpl(
    apiClient: ref.read(apiClientProvider),
    storage: ref.read(storageProvider),
  );
}

@riverpod
class DataController extends _$DataController {
  @override
  Future<List<Data>> build() {
    // 自动依赖注入
    return ref.read(repositoryProvider).getAllData();
  }
}
```

### 2. 错误处理
```dart
@riverpod
class DataController extends _$DataController {
  @override
  Future<Data> build() async {
    try {
      return await ref.read(repositoryProvider).getData();
    } catch (e) {
      // 统一错误处理
      throw DataException.fromError(e);
    }
  }
}
```

### 3. 缓存和刷新
```dart
@riverpod
class CachedDataController extends _$CachedDataController {
  @override
  Future<Data> build() async {
    // 自动缓存
    return ref.read(repositoryProvider).getData();
  }
  
  // 强制刷新
  Future<void> forceRefresh() {
    ref.invalidateSelf();
    return future;
  }
}
```

### 4. 条件依赖
```dart
@riverpod
class UserDataController extends _$UserDataController {
  @override
  Future<UserData> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      throw const UserNotAuthenticatedException();
    }
    
    return ref.read(repositoryProvider).getUserData(user.id);
  }
}
```

## 迁移检查清单

- [ ] 更新 pubspec.yaml 依赖
- [ ] 添加 riverpod_lint 到 analysis_options.yaml
- [ ] 迁移状态类到 Freezed（如果尚未使用）
- [ ] 将 StateNotifier 替换为 AsyncNotifier
- [ ] 将 ChangeNotifier 替换为 AsyncNotifier
- [ ] 更新 UI 层使用 AsyncView
- [ ] 运行 `flutter packages pub run build_runner build`
- [ ] 运行测试确保功能正常
- [ ] 删除旧的 Provider 文件

## 常见问题

### Q: 如何处理同步状态？
A: 使用 `@riverpod` 注解的普通函数：
```dart
@riverpod
String currentTheme(CurrentThemeRef ref) {
  return ref.watch(settingsProvider).theme;
}
```

### Q: 如何处理复杂的状态组合？
A: 使用多个 Provider 组合：
```dart
@riverpod
AppState appState(AppStateRef ref) {
  final user = ref.watch(currentUserProvider);
  final settings = ref.watch(settingsProvider);
  final notifications = ref.watch(notificationsProvider);
  
  return AppState(
    user: user,
    settings: settings,
    notifications: notifications,
  );
}
```

### Q: 如何处理表单状态？
A: 使用 Notifier 而不是 AsyncNotifier：
```dart
@riverpod
class FormController extends _$FormController {
  @override
  FormState build() {
    return const FormState();
  }
  
  void updateField(String field, String value) {
    state = state.copyWith(fields: {...state.fields, field: value});
  }
}
```