# AI营养健康餐厅后端项目

## 项目结构说明

本项目采用模块化设计，按照业务功能划分为不同的模块：

```
backend/
├── controllers/           # 控制器目录
│   ├── core/              # 核心模块控制器
│   ├── forum/             # 论坛模块控制器
│   ├── health/            # 健康模块控制器
│   ├── merchant/          # 商家模块控制器
│   ├── misc/              # 杂项模块控制器
│   ├── nutrition/         # 营养模块控制器
│   ├── order/             # 订单模块控制器
│   ├── audit/             # 审计模块控制器
│   └── index.js           # 控制器统一导出
├── routes/                # 路由目录
│   ├── core/              # 核心模块路由
│   ├── forum/             # 论坛模块路由
│   ├── health/            # 健康模块路由
│   ├── merchant/          # 商家模块路由
│   ├── misc/              # 杂项模块路由
│   ├── nutrition/         # 营养模块路由
│   ├── order/             # 订单模块路由
│   ├── audit/             # 审计模块路由
│   └── index.js           # 路由统一注册
├── models/                # 数据模型目录
├── services/              # 服务层目录
├── middlewares/           # 中间件目录
└── utils/                 # 工具函数目录
```

## 项目架构

本项目采用分层架构:

1. **路由层(Routes)**: 负责定义API路由和URL映射
2. **控制器层(Controllers)**: 负责处理HTTP请求/响应
3. **服务层(Services)**: 包含业务逻辑
4. **数据访问层(Models)**: 负责数据库交互

## 冻结结构说明

项目的控制器、路由、服务层和中间件结构已经冻结，标记文件位于各自目录下的`.structure-frozen`。
这意味着:

1. 控制器、路由、服务层和中间件的目录结构不应随意更改
2. 文件命名应遵循现有规范
3. 新功能应在现有结构基础上进行扩展

### 中间件结构 (2025-04-08冻结)

中间件按功能分类组织，具体包括：

- **auth**: 身份验证相关中间件，包括认证、权限控制、角色验证等
- **security**: 安全控制中间件，包括XSS防护、速率限制、请求签名验证等
- **performance**: 性能优化中间件，包括监控、缓存优化、数据库优化等
- **validation**: 验证相关中间件，包括请求验证、Schema验证等
- **core**: 核心中间件，包括日志记录、缓存、错误处理等

详细说明见 `middleware/README.md` 文件。

### 服务层结构 (2025-04-08冻结)

服务层按模块组织，具体包括：

- **core**: 核心模块服务，如用户、认证、审计等
- **forum**: 论坛模块服务，如帖子、评论等
- **health**: 健康模块服务，如营养档案、健康指标、健康目标和饮食偏好等
- **merchant**: 商家模块服务，如商家、店铺、菜品等
- **misc**: 杂项模块服务，如通知、应用配置等
- **nutrition**: 营养模块服务，如AI推荐、营养师、营养计划等
- **order**: 订单模块服务，如订单、订阅、咨询等

添加新功能时，请在相应模块下创建或扩展服务。如需创建新模块，请与架构团队协商。

## 开发规范

### 命名规范

- **文件命名**: 使用驼峰命名法，如`userController.js`
- **路由命名**: 使用kebab-case，如`/forum-posts`
- **变量命名**: 使用驼峰命名法，如`userId`
- **常量命名**: 使用全大写下划线分隔，如`MAX_FILE_SIZE`

### 控制器规范

每个控制器应包含以下标准方法:

- `createX`: 创建资源
- `getXList`: 获取资源列表
- `getXById`: 根据ID获取单个资源
- `updateX`: 更新资源
- `deleteX`: 删除资源

### 路由规范

遵循RESTful API设计原则:

- `POST /resource`: 创建资源
- `GET /resource`: 获取资源列表
- `GET /resource/:id`: 获取单个资源
- `PUT /resource/:id`: 更新资源
- `DELETE /resource/:id`: 删除资源

## 模块说明

- **core**: 核心功能，包括用户认证、权限管理等
- **forum**: 论坛功能，包括帖子、评论等
- **health**: 健康数据管理，包括营养档案、健康指标等
- **merchant**: 商家管理，包括商家信息、店铺、菜品等
- **misc**: 杂项功能，包括通知、应用配置等
- **nutrition**: 营养推荐功能，包括AI推荐、营养师服务等
- **order**: 订单管理，包括订单、咨询、订阅等
- **audit**: 审计功能，包括操作日志等

## 技术栈

- **Node.js**: JavaScript运行环境
- **Express**: Web框架
- **MongoDB**: 数据库
- **Mongoose**: MongoDB对象模型工具
- **JWT**: 用户认证
- **Redis**: 缓存和会话存储
- **Jest**: 单元测试
- **Swagger**: API文档
- **Docker**:, 容器化部署

## 运行项目

### 环境要求

- Node.js >= 14.0.0
- MongoDB >= 4.0.0
- Redis >= 6.0.0

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

### 构建生产环境

```bash
npm run build
```

### 启动生产服务器

```bash
npm start
```

### 运行测试

```bash
npm test
```

## API文档

启动服务器后，访问以下地址查看API文档：

```
http://localhost:3000/api-docs
```

## 团队开发规范

1. 遵循统一的代码风格和目录结构
2. 每个功能提交前进行单元测试
3. 提交代码前使用ESLint检查代码质量
4. 遵循语义化版本管理
5. 使用Conventional Commits规范提交信息

## 许可证

MIT