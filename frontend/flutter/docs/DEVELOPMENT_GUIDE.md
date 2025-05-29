# 开发指南

## 📋 目录

- [开发环境配置](#开发环境配置)
- [代码规范](#代码规范)
- [架构设计原则](#架构设计原则)
- [最佳实践](#最佳实践)
- [性能优化](#性能优化)
- [调试技巧](#调试技巧)

## 🛠️ 开发环境配置

### 必需工具
```bash
# Flutter SDK
flutter --version  # >= 3.8.0

# Dart SDK  
dart --version     # >= 3.3.0

# 开发工具
code --version     # VS Code (推荐)
```

### VS Code 扩展
```json
{
  "recommendations": [
    "dart-code.flutter",
    "dart-code.dart-code",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss",
    "usernamehw.errorlens",
    "esbenp.prettier-vscode"
  ]
}
```

### 项目配置
```bash
# 1. 安装依赖
flutter pub get

# 2. 生成代码
flutter packages pub run build_runner build

# 3. 运行项目
flutter run --flavor dev
```

## 📏 代码规范

### 1. 命名规范

#### 文件命名
```dart
// ✅ 好的命名
auth_controller.dart
nutrition_profile_model.dart
user_repository_impl.dart
phone_number.dart  // 值对象
user_dto.dart      // DTO对象

// ❌ 避免的命名
AuthController.dart
nutritionProfileModel.dart
UserRepositoryImplementation.dart
```

#### 类命名
```dart
// ✅ 好的命名
class AuthController extends _$AuthController {}
class NutritionProfile {}
class UserRepository {}
class PhoneNumber {}  // 值对象
class UserDto {}      // DTO
class PaymentPlugin implements Plugin {}  // 插件

// ❌ 避免的命名
class authController {}
class nutritionprofile {}
class userRepo {}
```

#### 变量命名
```dart
// ✅ 好的命名
final String userName = 'john';
final List<Order> userOrders = [];
final bool isAuthenticated = false;

// ❌ 避免的命名
final String un = 'john';
final List<Order> orders = [];
final bool auth = false;
```

### 2. 代码格式

#### 导入顺序
```dart
// 1. Dart core libraries
import 'dart:async';
import 'dart:convert';

// 2. Flutter libraries
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 4. Project imports
import '../domain/entities/user.dart';
import '../data/models/user_model.dart';
```

#### 构造函数格式
```dart
// ✅ 推荐格式
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.avatar,
  });

  final String id;
  final String name;
  final String? email;
  final String? avatar;
}
```

### 3. 注释规范

#### 类和方法注释
```dart
/// 用户认证控制器
/// 
/// 负责管理用户登录、注册、登出等认证相关功能。
/// 使用 AsyncNotifier 模式管理异步状态。
@riverpod
class AuthController extends _$AuthController {
  /// 构建初始认证状态
  /// 
  /// 检查本地存储的认证信息，如果存在有效的用户信息则设置为已认证状态。
  /// 
  /// Returns: [AuthState] 包含认证状态和用户信息
  @override
  Future<AuthState> build() async {
    // 实现逻辑
  }

  /// 用户登录
  /// 
  /// [email] 用户邮箱（可选，与phone二选一）
  /// [phone] 用户手机号（可选，与email二选一）
  /// [password] 用户密码
  /// 
  /// Throws: [AuthException] 当认证失败时
  Future<void> signIn({
    String? email,
    String? phone,
    required String password,
  }) async {
    // 实现逻辑
  }
}
```

#### TODO 注释
```dart
// TODO(username): 添加邮箱验证功能
// FIXME: 修复在网络不稳定时的重连问题
// HACK: 临时解决方案，待重构
```

## 🏗️ 架构设计原则

### 1. Clean Architecture

#### 分层职责
```
Presentation Layer (UI)
    ↓ 依赖
Application Layer (Use Cases)
    ↓ 依赖  
Domain Layer (Business Logic)
    ↑ 实现
Data Layer (Repositories & Data Sources)
```

#### 依赖规则
- 外层可以依赖内层
- 内层不能依赖外层
- 领域层不依赖任何外部框架

### 2. Feature-First 组织

```
features/
├── auth/                 # 认证功能
│   ├── data/            # 数据层
│   ├── domain/          # 领域层
│   └── presentation/    # 表现层
├── nutrition/           # 营养管理
└── order/              # 订单管理
```

### 3. 单一职责原则

```dart
// ✅ 好的设计 - 单一职责
class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Future<User> getCurrentUser();
}

class UserProfileRepository {
  Future<UserProfile> getProfile(String userId);
  Future<void> updateProfile(UserProfile profile);
}

// ❌ 避免的设计 - 职责过多
class UserService {
  Future<User> signIn(String email, String password);
  Future<UserProfile> getProfile(String userId);
  Future<List<Order>> getOrders(String userId);
  Future<void> sendNotification(String message);
}
```

## 💡 最佳实践

### 1. 状态管理

#### 使用 AsyncNotifier
```dart
// ✅ 推荐方式
@riverpod
class DataController extends _$DataController {
  @override
  Future<List<Data>> build() async {
    return ref.read(repositoryProvider).getData();
  }
  
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

// ❌ 避免的方式
class DataNotifier extends StateNotifier<AsyncValue<List<Data>>> {
  DataNotifier() : super(const AsyncValue.loading()) {
    _loadData();
  }
  
  Future<void> _loadData() async {
    state = const AsyncValue.loading();
    try {
      final data = await repository.getData();
      state = AsyncValue.data(data);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

#### 状态组织
```dart
// ✅ 使用 Freezed 创建不可变状态
@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default([]) List<User> users,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _UserState;
}

// ❌ 使用可变状态
class UserState {
  List<User> users = [];
  bool isLoading = false;
  String? errorMessage;
}
```

### 2. 错误处理

#### 统一错误处理
```dart
// ✅ 使用 Either 类型处理错误
abstract class Repository {
  Future<Either<Failure, List<Data>>> getData();
}

// Controller 中的错误处理
@riverpod
class DataController extends _$DataController {
  @override
  Future<List<Data>> build() async {
    final result = await ref.read(repositoryProvider).getData();
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data,
    );
  }
}

// 值对象的错误处理
class PhoneNumber {
  static Either<PhoneNumberFailure, PhoneNumber> create(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(cleaned)) {
      return left(const PhoneNumberFailure.invalid());
    }
    return right(PhoneNumber(cleaned));
  }
}
```

#### UI 错误显示
```dart
// ✅ 使用 AsyncView 统一处理
class DataPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataState = ref.watch(dataControllerProvider);
    
    return AsyncView<List<Data>>(
      value: dataState,
      data: (data) => DataList(data: data),
      error: (error, stack) => ErrorRetryWidget(
        error: error,
        onRetry: () => ref.refresh(dataControllerProvider),
      ),
    );
  }
}
```

### 3. 网络请求

#### 使用 Retrofit
```dart
@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;
  
  @GET('/users/{id}')
  Future<HttpResponse<UserDto>> getUser(@Path() String id);
  
  @POST('/users')
  Future<HttpResponse<UserDto>> createUser(@Body() UserDto user);
}
```

#### DTO 转换
```dart
// DTO 到实体的转换
class UserMapper {
  static User fromDto(UserDto dto) {
    return User(
      id: dto.id,
      name: dto.name,
      email: Email.create(dto.email).getOrElse(() => Email.empty()),
      phone: PhoneNumber.create(dto.phone).getOrElse(() => PhoneNumber.empty()),
    );
  }
  
  static UserDto toDto(User entity) {
    return UserDto(
      id: entity.id,
      name: entity.name,
      email: entity.email.value,
      phone: entity.phone.value,
    );
  }
}
```

#### 请求拦截器
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = TokenManager.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
```

### 4. 数据持久化

#### 使用 Hive
```dart
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? email;
  
  UserModel({
    required this.id,
    required this.name,
    this.email,
  });
}
```

#### 安全存储
```dart
class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
```

## 🚀 性能优化

### 1. Widget 优化

#### 使用 const 构造函数
```dart
// ✅ 推荐
const Text('Hello World')
const SizedBox(height: 16)
const Icon(Icons.home)

// ❌ 避免
Text('Hello World')
SizedBox(height: 16)
Icon(Icons.home)
```

#### 避免在 build 方法中创建对象
```dart
// ✅ 推荐
class MyWidget extends StatelessWidget {
  static const _textStyle = TextStyle(fontSize: 16);
  
  @override
  Widget build(BuildContext context) {
    return Text('Hello', style: _textStyle);
  }
}

// ❌ 避免
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Hello',
      style: TextStyle(fontSize: 16), // 每次 build 都创建新对象
    );
  }
}
```

### 2. 列表优化

#### 使用 ListView.builder
```dart
// ✅ 推荐 - 延迟加载
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index].name));
  },
)

// ❌ 避免 - 一次性创建所有 Widget
ListView(
  children: items.map((item) => ListTile(title: Text(item.name))).toList(),
)
```

### 3. 图片优化

#### 使用 CachedNetworkImage
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  fadeInDuration: const Duration(milliseconds: 300),
)
```

### 4. 状态优化

#### 避免不必要的重建
```dart
// ✅ 使用 select 监听部分状态
class UserCounter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCount = ref.watch(
      userControllerProvider.select((state) => 
        state.valueOrNull?.length ?? 0
      ),
    );
    
    return Text('用户数量: $userCount');
  }
}
```

## 🐛 调试技巧

### 1. 日志输出

#### 使用 Logger
```dart
import 'package:logger/logger.dart';

final logger = Logger();

void debugApi(String endpoint, Map<String, dynamic> data) {
  logger.d('API Request: $endpoint');
  logger.d('Data: $data');
}

void handleError(Object error, StackTrace stack) {
  logger.e('Error occurred', error, stack);
}
```

### 2. 性能分析

#### 使用 Flutter Inspector
```bash
# 启动性能分析
flutter run --profile

# 在 VS Code 中
Cmd/Ctrl + Shift + P -> "Flutter: Open Flutter Inspector"
```

#### Widget 重建监控
```dart
class DebugWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('DebugWidget rebuilt'); // 监控重建
    return Container();
  }
}
```

### 3. 网络调试

#### Dio 日志拦截器
```dart
dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
  requestHeader: true,
  responseHeader: false,
  error: true,
));
```

### 4. 状态调试

#### Riverpod 日志
```dart
class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''
Provider: ${provider.name ?? provider.runtimeType}
Previous: $previousValue
New: $newValue
''');
  }
}

// 在 main.dart 中
runApp(
  ProviderScope(
    observers: [ProviderLogger()],
    child: MyApp(),
  ),
);
```

## 🔌 插件系统

### 1. 插件接口

```dart
// 插件基础接口
abstract class Plugin {
  String get name;
  Future<void> initialize();
  Future<void> enable();
  Future<void> disable();
  Future<void> dispose();
}

// 支付插件接口
abstract class PaymentPlugin extends Plugin {
  Future<PaymentResult> pay(PaymentRequest request);
  Future<RefundResult> refund(RefundRequest request);
  Future<PaymentStatus> queryStatus(String orderId);
}
```

### 2. 插件实现

```dart
class AlipayPlugin extends PaymentPlugin {
  @override
  String get name => 'Alipay';
  
  @override
  Future<void> initialize() async {
    // 初始化支付宝SDK
  }
  
  @override
  Future<PaymentResult> pay(PaymentRequest request) async {
    // 实现支付宝支付逻辑
  }
}
```

### 3. 插件管理

```dart
class PluginManager {
  final Map<String, Plugin> _plugins = {};
  
  void register(Plugin plugin) {
    _plugins[plugin.name] = plugin;
  }
  
  T? getPlugin<T extends Plugin>(String name) {
    return _plugins[name] as T?;
  }
  
  Future<void> initializeAll() async {
    for (final plugin in _plugins.values) {
      await plugin.initialize();
    }
  }
}
```

## 🪝 生命周期钩子

### 1. 钩子定义

```dart
// 钩子类型
enum HookType {
  beforeUserLogin,
  afterUserLogin,
  beforeUserLogout,
  afterUserLogout,
  beforeDataCreate,
  afterDataCreate,
  beforeDataUpdate,
  afterDataUpdate,
  beforeDataDelete,
  afterDataDelete,
  beforeApiCall,
  afterApiCall,
  onNetworkStatusChange,
  onAppLifecycleChange,
}

// 钩子上下文
class HookContext {
  final HookType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  
  HookContext({
    required this.type,
    required this.data,
  }) : timestamp = DateTime.now();
}
```

### 2. 钩子注册

```dart
class AppHooks {
  static final _hooks = <HookType, List<HookHandler>>{};
  
  static void register(HookType type, HookHandler handler) {
    _hooks.putIfAbsent(type, () => []).add(handler);
  }
  
  static Future<void> trigger(HookContext context) async {
    final handlers = _hooks[context.type] ?? [];
    for (final handler in handlers) {
      try {
        await handler(context);
      } catch (e) {
        // 错误隔离
        logger.e('Hook error: $e');
      }
    }
  }
}
```

### 3. 使用示例

```dart
// 注册钩子
void setupHooks() {
  // 用户登录后同步数据
  AppHooks.register(HookType.afterUserLogin, (context) async {
    final userId = context.data['userId'] as String;
    await syncUserData(userId);
  });
  
  // API调用前添加认证
  AppHooks.register(HookType.beforeApiCall, (context) async {
    final request = context.data['request'] as Request;
    request.headers['Authorization'] = await getAuthToken();
  });
}

// 触发钩子
Future<void> loginUser(String email, String password) async {
  // 登录前钩子
  await AppHooks.trigger(HookContext(
    type: HookType.beforeUserLogin,
    data: {'email': email},
  ));
  
  final user = await authService.login(email, password);
  
  // 登录后钩子
  await AppHooks.trigger(HookContext(
    type: HookType.afterUserLogin,
    data: {'userId': user.id, 'user': user},
  ));
}
```

## 📦 值对象（Value Objects）

### 1. 值对象设计

```dart
@freezed
class Email with _$Email {
  const factory Email(String value) = _Email;
  
  static Either<EmailFailure, Email> create(String input) {
    final trimmed = input.trim().toLowerCase();
    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(trimmed)) {
      return left(const EmailFailure.invalid());
    }
    return right(Email(trimmed));
  }
}

@freezed
class Money with _$Money {
  const factory Money({
    required int amount,  // 分为单位
    required String currency,
  }) = _Money;
  
  static Either<MoneyFailure, Money> create({
    required double amount,
    required String currency,
  }) {
    if (amount < 0) {
      return left(const MoneyFailure.negativeAmount());
    }
    if (!['CNY', 'USD', 'EUR'].contains(currency)) {
      return left(const MoneyFailure.invalidCurrency());
    }
    return right(Money(
      amount: (amount * 100).round(),
      currency: currency,
    ));
  }
}
```

### 2. 使用值对象

```dart
class User {
  final String id;
  final String name;
  final Email email;
  final PhoneNumber phone;
  final Money balance;
  
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.balance,
  });
}

// 创建用户
final emailResult = Email.create('user@example.com');
final phoneResult = PhoneNumber.create('13800138000');
final balanceResult = Money.create(amount: 100.0, currency: 'CNY');

if (emailResult.isRight() && phoneResult.isRight() && balanceResult.isRight()) {
  final user = User(
    id: '123',
    name: 'John',
    email: emailResult.getOrElse(() => throw 'Invalid email'),
    phone: phoneResult.getOrElse(() => throw 'Invalid phone'),
    balance: balanceResult.getOrElse(() => throw 'Invalid balance'),
  );
}
```

## 📝 代码审查清单

### 提交前检查
- [ ] 代码格式化 (`flutter format .`)
- [ ] 静态分析 (`flutter analyze`)
- [ ] 测试通过 (`flutter test`)
- [ ] 无 TODO 或已有追踪
- [ ] 错误处理完整
- [ ] 性能影响评估
- [ ] 文档更新
- [ ] 值对象验证正确
- [ ] DTO 转换完整
- [ ] 插件接口实现规范
- [ ] 钩子使用合理

### 审查要点
- [ ] 架构设计合理
- [ ] 命名清晰准确
- [ ] 职责单一明确
- [ ] 错误处理妥当
- [ ] 测试覆盖充分
- [ ] 性能表现良好
- [ ] 安全性考虑
- [ ] 值对象不可变性
- [ ] 插件生命周期正确
- [ ] 钩子错误隔离

---

**📚 相关文档**
- [Flutter 最佳实践](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)
- [Dart 风格指南](https://dart.dev/guides/language/effective-dart)
- [Riverpod 文档](https://riverpod.dev/docs/getting_started)