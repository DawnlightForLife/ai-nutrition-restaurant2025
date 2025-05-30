# 错误处理架构

## 概述

本项目采用清洁架构原则，将错误处理分为三层：

1. **领域层 (Domain Layer)** - 使用 `Failure` 类
2. **数据层 (Data Layer)** - 使用 `Exception` 类  
3. **展示层 (Presentation Layer)** - 错误展示和用户反馈

## 目录结构

```
lib/core/
├── failures/          # 领域层失败类
│   └── failures.dart
├── exceptions/        # 数据层异常类
│   ├── app_exceptions.dart
│   └── exception_mapper.dart
└── error/            # 展示层错误处理
    ├── error_boundary.dart
    └── centralized_error_handler.dart
```

## 使用指南

### 1. 领域层 - Failures

在 UseCase 和 Repository 接口中使用：

```dart
abstract class IAuthRepository {
  Future<Either<Failure, AuthUser>> signIn(String phone, String password);
}
```

### 2. 数据层 - Exceptions

在 Repository 实现和数据源中抛出：

```dart
class AuthRepositoryImpl implements IAuthRepository {
  @override
  Future<Either<Failure, AuthUser>> signIn(String phone, String password) async {
    return ExceptionMapper.guardAsync(() async {
      // 可能抛出 ApiException, NetworkException 等
      final response = await apiClient.post('/auth/login', {...});
      return AuthUser.fromJson(response.data);
    });
  }
}
```

### 3. 展示层 - 错误展示

使用 ErrorBoundary 和 CentralizedErrorHandler：

```dart
ErrorBoundary(
  child: MyApp(),
  onError: (error, stackTrace) {
    CentralizedErrorHandler.handle(error);
  },
)
```

## 异常类型

### 数据层异常 (Exceptions)
- `NetworkException` - 网络连接问题
- `ApiException` - API调用失败
- `ValidationException` - 数据验证失败
- `AuthException` - 认证失败
- `CacheException` - 缓存操作失败
- `PermissionException` - 权限不足
- `BusinessException` - 业务逻辑错误
- `DataFormatException` - 数据格式错误

### 领域层失败 (Failures)
- `NetworkFailure` - 网络连接失败
- `ServerFailure` - 服务器错误
- `ValidationFailure` - 验证失败
- `AuthFailure` - 认证失败
- `CacheFailure` - 缓存失败
- `PermissionFailure` - 权限失败
- `BusinessFailure` - 业务失败
- `DataFormatFailure` - 数据格式失败
- `UnknownFailure` - 未知失败

## 最佳实践

1. **不要在领域层使用 Exception**
2. **Repository 实现使用 ExceptionMapper 转换异常**
3. **展示层统一处理错误展示**
4. **为每种错误提供用户友好的提示信息**