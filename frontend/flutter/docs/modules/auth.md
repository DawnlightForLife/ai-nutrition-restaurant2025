# 认证模块 (Auth)

## 📋 模块概述

认证模块负责用户身份验证、授权管理和会话控制，是整个应用的安全基础。

### 核心功能
- 🔐 多种登录方式（邮箱、手机、第三方）
- 📱 短信验证码登录
- 🔑 JWT Token 管理
- 👤 用户状态管理
- 🔒 安全会话控制

## 🏗️ 模块架构

```
auth/
├── data/                    # 数据层
│   ├── datasources/        # 数据源
│   │   ├── auth_local_datasource.dart
│   │   └── auth_remote_datasource.dart
│   ├── models/             # 数据模型
│   │   ├── auth_user.dart
│   │   └── user_model.dart
│   └── repositories/       # 仓储实现
│       └── auth_repository_impl.dart
├── domain/                 # 领域层
│   ├── entities/           # 业务实体
│   │   └── auth_user.dart
│   ├── repositories/       # 仓储接口
│   │   └── i_auth_repository.dart
│   └── usecases/          # 用例
│       ├── sign_in_usecase.dart
│       ├── sign_up_usecase.dart
│       └── sign_out_usecase.dart
└── presentation/          # 表现层
    ├── pages/             # 页面
    │   ├── login_page.dart
    │   ├── register_page.dart
    │   └── forgot_password_page.dart
    ├── widgets/           # 组件
    │   ├── login_form.dart
    │   └── social_login_buttons.dart
    └── providers/         # 状态管理
        └── auth_controller.dart
```

## 🎯 主要用例

### 1. 用户登录
- **邮箱密码登录**：传统邮箱+密码方式
- **手机密码登录**：手机号+密码方式
- **验证码登录**：手机号+短信验证码
- **第三方登录**：微信、QQ、微博等

### 2. 用户注册
- **完整注册**：邮箱、手机、密码、昵称
- **验证码验证**：手机号验证
- **协议确认**：用户协议和隐私政策

### 3. 密码管理
- **忘记密码**：通过邮箱或手机重置
- **修改密码**：在设置中修改
- **密码强度检查**：实时密码强度提示

## 🔌 状态管理

### AuthController (新版本)

使用 Riverpod 2.0 AsyncNotifier 模式：

```dart
@riverpod
class AuthController extends _$AuthController {
  @override
  Future<AuthState> build() async {
    // 检查本地存储的认证状态
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.getSignedInUser();
    
    return result.fold(
      (failure) => const AuthState(isAuthenticated: false),
      (user) => AuthState(
        isAuthenticated: user != null,
        currentUser: user,
      ),
    );
  }

  // 登录方法
  Future<void> signIn({
    String? email,
    String? phone,
    required String password,
  }) async { /* ... */ }
}
```

### 状态结构

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    AuthUser? currentUser,
    String? errorMessage,
  }) = _AuthState;
}
```

## 📱 UI 组件

### 1. 登录页面
- **响应式设计**：适配不同屏幕尺寸
- **表单验证**：实时输入验证
- **错误提示**：用户友好的错误信息
- **加载状态**：优雅的加载动画

### 2. 核心组件
```dart
// 登录表单
class LoginForm extends ConsumerStatefulWidget {
  // 支持邮箱和手机号登录
  // 自动表单验证
  // 密码显示/隐藏切换
}

// 社交登录按钮
class SocialLoginButtons extends StatelessWidget {
  // 微信、QQ、微博登录
  // 统一样式设计
}

// 验证码输入框
class VerificationCodeInput extends StatefulWidget {
  // 6位验证码输入
  // 自动焦点切换
  // 倒计时功能
}
```

## 🔐 安全特性

### 1. Token 管理
- **JWT Token**：安全的身份令牌
- **自动刷新**：Token 过期自动刷新
- **安全存储**：使用 FlutterSecureStorage

### 2. 数据保护
- **敏感信息加密**：本地存储加密
- **HTTPS 通信**：API 通信加密
- **输入验证**：防止注入攻击

### 3. 会话管理
- **自动登出**：长时间不活跃自动登出
- **设备绑定**：限制同时登录设备数
- **异常检测**：异常登录行为检测

## 🧪 测试策略

### 1. 单元测试
```dart
// AuthController 测试
group('AuthController', () {
  test('should authenticate user with valid credentials', () async {
    // 测试成功登录
  });
  
  test('should handle authentication failure', () async {
    // 测试登录失败
  });
});
```

### 2. Widget 测试
```dart
// LoginPage 测试
testWidgets('should show error message on invalid login', (tester) async {
  // 测试UI错误提示
});
```

### 3. 集成测试
```dart
// 完整登录流程测试
testWidgets('user can login and navigate to home', (tester) async {
  // 测试端到端登录流程
});
```

## 📡 API 集成

### 认证相关接口

```dart
abstract class AuthRemoteDataSource {
  // 邮箱密码登录
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  // 手机密码登录
  Future<AuthUser> signInWithPhoneAndPassword({
    required String phone,
    required String password,
  });
  
  // 手机验证码登录
  Future<AuthUser> signInWithPhoneAndCode({
    required String phone,
    required String code,
  });
  
  // 发送验证码
  Future<void> sendVerificationCode(String phone);
  
  // 用户注册
  Future<AuthUser> signUp({
    required String email,
    required String phone,
    required String password,
    required String nickname,
  });
  
  // 刷新Token
  Future<String> refreshToken(String refreshToken);
  
  // 登出
  Future<void> signOut();
}
```

## 🔄 数据流

### 登录流程
```
UI Layer (LoginPage)
    ↓ 用户输入
AuthController
    ↓ 调用用例
SignInUseCase
    ↓ 调用仓储
AuthRepository
    ↓ 调用数据源
AuthRemoteDataSource → API
    ↓ 存储Token
AuthLocalDataSource → SecureStorage
    ↓ 更新状态
AuthController → UI更新
```

## ⚙️ 配置说明

### 环境配置
```dart
// lib/core/config/auth_config.dart
class AuthConfig {
  static const String baseUrl = 'https://api.nutrition-ai.com';
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  static const int maxLoginAttempts = 3;
  static const Duration lockoutDuration = Duration(minutes: 15);
}
```

### 第三方登录配置
```dart
// 微信登录配置
class WechatConfig {
  static const String appId = 'your_wechat_app_id';
  static const String appSecret = 'your_wechat_app_secret';
}
```

## 🚀 使用示例

### 1. 在页面中使用
```dart
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    
    return authState.when(
      data: (state) {
        if (!state.isAuthenticated) {
          return const LoginPage();
        }
        return const MainContent();
      },
      loading: () => const LoadingPage(),
      error: (error, stack) => ErrorPage(error: error),
    );
  }
}
```

### 2. 执行登录
```dart
class LoginButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        await ref.read(authControllerProvider.notifier).signIn(
          email: 'user@example.com',
          password: 'password123',
        );
      },
      child: const Text('登录'),
    );
  }
}
```

### 3. 检查认证状态
```dart
// 使用便捷访问器
final isAuthenticated = ref.watch(isAuthenticatedProvider);
final currentUser = ref.watch(currentUserProvider);

if (isAuthenticated) {
  // 用户已登录
  print('当前用户: ${currentUser?.nickname}');
}
```

## 🛠️ 开发指南

### 1. 添加新的登录方式
1. 在 `AuthRemoteDataSource` 中添加接口
2. 在 `AuthRepositoryImpl` 中实现逻辑
3. 在 `AuthController` 中添加方法
4. 在 UI 中添加对应按钮

### 2. 自定义错误处理
```dart
// 在 AuthController 中
Future<void> signIn(...) async {
  try {
    // 登录逻辑
  } catch (e) {
    if (e is NetworkException) {
      // 网络错误处理
    } else if (e is AuthException) {
      // 认证错误处理
    }
  }
}
```

### 3. 扩展用户信息
1. 修改 `AuthUser` 实体
2. 更新数据模型 `UserModel`
3. 调整API接口
4. 更新UI显示

## 📝 最佳实践

### 1. 安全性
- 永远不要在客户端存储明文密码
- 使用 HTTPS 进行所有API通信
- 定期刷新Token
- 实现适当的重试机制

### 2. 用户体验
- 提供清晰的错误信息
- 实现优雅的加载状态
- 支持自动登录
- 提供登出确认

### 3. 性能优化
- 缓存用户信息
- 延迟加载非必要数据
- 优化网络请求
- 使用适当的状态管理

## 🔍 故障排除

### 常见问题

#### 1. Token 过期问题
```dart
// 检查Token刷新逻辑
if (response.statusCode == 401) {
  await refreshToken();
  // 重试原请求
}
```

#### 2. 网络错误处理
```dart
try {
  await signIn(...);
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    // 连接超时处理
  }
}
```

#### 3. 状态同步问题
```dart
// 确保状态正确更新
ref.invalidate(authControllerProvider);
```

---

**📚 相关文档**
- [Provider 迁移指南](../PROVIDER_MIGRATION_GUIDE.md)
- [API 集成文档](../../README_API_INTEGRATION.md)
- [安全配置指南](../../docs/SECURITY_GUIDE.md)