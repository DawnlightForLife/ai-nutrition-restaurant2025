# Flutter前端架构说明

本项目采用**Clean Architecture + DDD（领域驱动设计）**架构，与后端架构保持一致。

## 目录结构

```
lib/
├── app.dart                 # 应用根组件
├── main.dart               # 应用入口
├── domain/                 # 领域层（核心业务逻辑）
│   ├── abstractions/       # 抽象接口定义
│   │   ├── repositories/   # 仓储接口
│   │   └── services/       # 服务接口
│   ├── common/             # 通用领域组件
│   ├── user/              # 用户领域
│   ├── restaurant/        # 餐厅领域
│   ├── order/             # 订单领域
│   ├── nutrition/         # 营养领域
│   ├── forum/             # 论坛领域
│   └── merchant/          # 商户领域
├── application/           # 应用层（用例/业务流程）
│   ├── core/              # 核心用例组件
│   └── {module}/          # 各模块用例
├── infrastructure/        # 基础设施层（技术实现）
│   ├── repositories/      # 仓储实现
│   ├── services/          # 服务实现
│   ├── datasources/       # 数据源
│   ├── mappers/           # 数据映射
│   └── dtos/              # 数据传输对象
├── presentation/          # 表现层（UI）
│   ├── screens/           # 页面
│   ├── components/        # 组件
│   ├── viewmodels/        # 视图模型
│   └── providers/         # 状态管理
├── services/              # 服务实现
│   ├── api/               # API服务
│   ├── cache/             # 缓存服务
│   └── plugins/           # 插件服务
├── core/                  # 核心功能
│   ├── di/                # 依赖注入
│   ├── navigation/        # 路由导航
│   └── utils/             # 工具函数
├── config/                # 配置
│   ├── theme/             # 主题配置
│   ├── routes/            # 路由配置
│   └── env/               # 环境配置
└── common/                # 通用资源
    ├── constants/         # 常量
    ├── utils/             # 工具类
    ├── theme/             # 主题
    └── extensions/        # 扩展方法
```

## 架构原则

### 1. 依赖规则
- 依赖方向：表现层 → 应用层 → 领域层 ← 基础设施层
- 领域层不依赖任何外部框架
- 使用接口进行依赖反转

### 2. 领域驱动设计
- **实体(Entity)**: 具有唯一标识的业务对象
- **值对象(Value Object)**: 不可变的、无标识的对象
- **聚合(Aggregate)**: 相关实体和值对象的集合
- **领域服务(Domain Service)**: 跨实体的业务逻辑
- **仓储(Repository)**: 数据访问抽象

### 3. 分层职责

#### 领域层 (Domain)
- 包含核心业务逻辑和规则
- 定义实体、值对象、领域服务
- 定义仓储和服务接口（抽象）

#### 应用层 (Application)
- 协调领域对象完成业务用例
- 不包含业务规则，只负责流程编排
- 返回统一的Result类型处理成功/失败

#### 基础设施层 (Infrastructure)
- 实现领域层定义的接口
- 处理技术细节（API调用、数据库访问等）
- 数据模型转换（DTO ↔ Entity）

#### 表现层 (Presentation)
- UI组件和页面
- 状态管理（Provider）
- 用户交互处理

## 与后端映射关系

| 后端模块 | 前端模块 | 说明 |
|---------|---------|-----|
| domain/ | domain/ | 领域模型一对一映射 |
| application/ | application/ | 用例逻辑对应 |
| controllers/ | screens/ | 控制器对应UI页面 |
| services/ | services/ | 服务层实现 |
| repositories/ | repositories/ | 数据访问层 |
| plugins/ | services/plugins/ | 第三方服务集成 |

## 开发规范

### 命名规范
- 接口以`I`开头：`IUserRepository`
- 值对象使用描述性名称：`Email`, `Phone`
- 用例以动作命名：`SignInUseCase`
- Provider后缀：`AuthProvider`

### 文件组织
- 每个领域模块独立文件夹
- 相关文件就近放置
- 公共组件放在common目录

### 依赖注入
- 使用get_it + injectable
- 接口和实现分离
- 通过构造函数注入依赖

## 快速开始

1. 运行代码生成
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

2. 初始化依赖注入
```dart
await configureDependencies();
```

3. 运行应用
```bash
flutter run
```