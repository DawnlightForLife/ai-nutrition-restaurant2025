# Shared Module

共享模块包含跨功能模块使用的通用组件。

## 目录结构

```
shared/
├── domain/           # 共享领域概念
│   └── value_objects/  # 通用值对象
├── data/            # 共享数据结构
│   └── dtos/          # 通用DTO
├── presentation/    # 共享UI组件
│   └── widgets/       # 通用组件
├── enums/          # 枚举定义
├── constants/      # 常量定义
└── utils/          # 工具函数
```

## 主要内容

### 1. 值对象 (Value Objects)

- **PhoneNumber**: 电话号码值对象
- **Email**: 邮箱值对象
- 其他通用业务值对象

### 2. 数据传输对象 (DTOs)

- **BaseDTO**: DTO基类
- **ApiResponseDTO**: API响应包装
- **PaginatedResponseDTO**: 分页响应

### 3. 枚举 (Enums)

- **UserRole**: 用户角色
- **Gender**: 性别
- **SubscriptionPlan**: 订阅计划
- 其他业务枚举

### 4. 通用组件 (Widgets)

- **LoadingWidget**: 加载组件
- **ErrorWidget**: 错误显示组件
- **EmptyWidget**: 空状态组件
- 其他可复用UI组件

## 使用原则

### 什么应该放在 Shared

1. **跨模块使用的组件**: 至少被2个以上模块使用
2. **无业务色彩的组件**: 不包含特定业务逻辑
3. **基础数据结构**: 通用的数据模型和DTO
4. **工具函数**: 格式化、验证等通用功能

### 什么不应该放在 Shared

1. **特定业务逻辑**: 属于某个具体功能模块
2. **模块专用组件**: 只在单个模块使用
3. **具体实现类**: 应该放在各自的模块中

## 使用示例

### 值对象使用

```dart
// 创建电话号码
final phoneResult = PhoneNumber.create('13812345678');
phoneResult.fold(
  (failure) => print('Invalid phone'),
  (phone) => print('Valid: ${phone.value}'),
);
```

### DTO使用

```dart
// API响应
final response = ApiResponseDTO<User>(
  success: true,
  data: user,
  message: 'Success',
);
```

### 枚举使用

```dart
// 用户角色判断
if (user.role == UserRole.admin) {
  // 管理员逻辑
}
```

## 维护指南

1. **定期审查**: 检查组件是否仍被多个模块使用
2. **避免过度共享**: 不要为了"可能的复用"而共享
3. **保持简单**: 共享组件应该简单且易于理解
4. **版本控制**: 修改时考虑对其他模块的影响