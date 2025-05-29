# Flutter Clean Architecture 项目结构

## 目录结构说明

```
lib/
├── core/                    # 核心模块：包含跨功能模块的共享代码
│   ├── di/                  # 依赖注入配置
│   ├── error/               # 统一错误处理（Failures, Exceptions）
│   ├── network/             # 网络配置（Dio, 拦截器）
│   ├── router/              # 路由配置（auto_route）
│   ├── utils/               # 工具类（验证器、格式化器、扩展）
│   └── base/                # 基础抽象类（UseCase, Repository, Entity）
│
├── features/                # 功能模块（按业务领域划分）
│   ├── auth/                # 认证模块
│   ├── user/                # 用户模块
│   ├── nutrition/           # 营养档案模块
│   ├── recommendation/      # AI推荐模块
│   ├── forum/               # 论坛社区模块
│   ├── order/               # 订单模块
│   ├── consultation/        # 咨询模块
│   ├── merchant/            # 商家模块
│   ├── nutritionist/        # 营养师模块
│   ├── admin/               # 管理后台模块
│   └── common/              # 通用页面（隐私政策、关于我们等）
│
├── shared/                  # 共享资源
│   ├── theme/               # 主题配置（颜色、文字样式、尺寸）
│   ├── l10n/                # 国际化资源
│   └── widgets/             # 通用UI组件
│
├── config/                  # 应用配置
│   ├── env_config.dart      # 环境配置
│   ├── flavor_config.dart   # 构建变体配置
│   └── app_config.dart      # 应用配置
│
└── 入口文件
    ├── main.dart            # 生产环境入口
    ├── main_dev.dart        # 开发环境入口
    ├── main_staging.dart    # 测试环境入口
    └── app.dart             # 主应用
```

## 每个功能模块的标准结构

```
features/[module_name]/
├── data/                    # 数据层
│   ├── datasources/         # 数据源（远程API、本地缓存）
│   ├── models/              # 数据模型（DTO）
│   └── repositories/        # Repository实现
│
├── domain/                  # 领域层
│   ├── entities/            # 业务实体
│   ├── repositories/        # Repository接口
│   ├── usecases/            # 用例（业务逻辑）
│   └── value_objects/       # 值对象
│
└── presentation/            # 表现层
    ├── providers/           # 状态管理（Riverpod）
    ├── pages/               # 页面
    └── widgets/             # 模块专用组件
```

## 架构原则

### 1. 依赖规则
- **Presentation** → **Domain** ← **Data**
- Domain层不依赖任何其他层
- Data和Presentation层依赖Domain层
- 依赖方向永远指向内部

### 2. 数据流
```
UI (Pages/Widgets) 
    ↓ 触发事件
Provider (StateNotifier)
    ↓ 调用
UseCase
    ↓ 调用
Repository Interface
    ↓ 实现
Repository Implementation
    ↓ 调用
DataSource (Remote/Local)
    ↓ 返回
Model → Entity 转换
    ↓ 返回给UI
State 更新
```

### 3. 命名规范

#### 文件命名
- 使用小写字母和下划线：`user_profile_page.dart`
- 页面文件以`_page`结尾
- 组件文件以`_widget`或具体组件类型结尾
- Provider文件以`_provider`结尾
- UseCase文件以`_usecase`结尾

#### 类命名
- 使用大驼峰命名：`UserProfilePage`
- UseCase类以`UseCase`结尾：`GetUserProfileUseCase`
- Provider类以`Provider`或`Notifier`结尾
- Model类以`Model`结尾
- Entity类不需要特殊后缀

### 4. 状态管理

使用Riverpod进行状态管理：

```dart
// State定义（使用Freezed）
@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.loaded(User user) = _Loaded;
  const factory UserState.error(Failure failure) = _Error;
}

// StateNotifier
class UserNotifier extends StateNotifier<UserState> {
  final GetUserProfileUseCase _getUserProfile;
  
  UserNotifier(this._getUserProfile) : super(const UserState.initial());
}

// Provider定义
final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.watch(getUserProfileUseCaseProvider));
});
```

### 5. 错误处理

统一使用`Either<Failure, Success>`模式：

```dart
// UseCase返回
Future<Either<Failure, User>> call(String userId);

// Repository返回
Future<Either<Failure, User>> getUser(String userId);

// 处理结果
final result = await getUserProfile(userId);
result.fold(
  (failure) => showError(failure.message),
  (user) => showUser(user),
);
```

## 开发流程

1. **需求分析**：确定功能属于哪个模块
2. **定义Entity**：在domain层定义业务实体
3. **定义Repository接口**：在domain层定义数据操作接口
4. **实现UseCase**：在domain层实现业务逻辑
5. **实现Model**：在data层定义数据模型
6. **实现Repository**：在data层实现数据操作
7. **实现DataSource**：在data层实现具体的数据获取
8. **创建Provider**：在presentation层创建状态管理
9. **创建UI**：在presentation层创建页面和组件

## 注意事项

1. **不要跨层调用**：UI不应直接调用Repository或DataSource
2. **保持Domain层纯净**：不要在Domain层使用Flutter相关的类
3. **使用依赖注入**：通过Provider管理依赖关系
4. **编写测试**：每层都应该有对应的单元测试
5. **遵循单一职责**：每个类只负责一件事情

## 模块职责说明

### 核心功能模块
- `auth`: 统一登录、注册、找回密码
- `user`: 个人中心、资料管理、设置、角色入口
- `nutrition`: 营养档案管理
- `recommendation`: AI推荐、推荐历史、反馈
- `forum`: 社区论坛、发帖、评论
- `order`: 订单列表、订单详情、支付
- `consultation`: 营养师咨询、聊天

### 角色功能模块

#### 商家功能（merchant）
- `merchant/auth`: 商家认证（店铺资质上传）
- `merchant/dish`: 菜品管理
- `merchant/order`: 订单处理
- `merchant/inventory`: 库存管理
- `merchant/activity`: 活动管理
- `merchant/profile`: 店铺管理、员工授权

#### 营养师功能（nutritionist）
- `nutritionist/auth`: 营养师认证（资质上传、认证状态）
- `nutritionist/consult`: 咨询管理
- `nutritionist/recommendation`: 推荐方案管理
- `nutritionist/profile`: 工作台、个人资料

#### 管理后台功能（admin）
- `admin`: 后台管理所有功能（Web端）

## 权限系统设计

### 用户角色（UserRole）
```dart
enum UserRole {
  user,         // 普通用户
  merchant,     // 商家
  employee,     // 店员
  nutritionist, // 营养师
  admin,        // 管理员
}
```

### 角色入口显示逻辑
1. **普通用户**: 默认功能
2. **商家权限**: 个人中心显示"商家管理"入口
3. **店员权限**: 个人中心显示"员工工作台"入口
4. **营养师权限**: 个人中心显示"营养师工作台"入口
5. **管理员权限**: 可访问管理后台（Web端）

### 权限获取流程
1. **商家**: 管理员在后台授权用户为商家
2. **店员**: 商家在商家管理系统中授权其他用户为店员
3. **营养师**: 用户申请认证，管理员审核通过
4. **管理员**: 系统初始化或超级管理员授权

## 下一步

1. 复制备份的代码到对应的新位置
2. 按照新的架构规范重构代码
3. 删除冗余和重复的代码
4. 统一错误处理和状态管理
5. 添加缺失的功能实现