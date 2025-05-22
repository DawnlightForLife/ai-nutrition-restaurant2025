# AI营养健康餐厅后端项目

## 项目结构说明

本项目采用模块化设计，按照业务功能划分为不同的模块：

```
backend/
├── controllers/           # 控制器目录
│   ├── core/              # 核心模块控制器
│   ├── forum/             # 论坛模块控制器
│   ├── nutrition/         # 营养档案模块控制器
│   ├── merchant/          # 商家模块控制器
│   ├── misc/              # 杂项模块控制器
│   ├── nutrition/         # 营养模块控制器
│   ├── order/             # 订单模块控制器
│   ├── audit/             # 审计模块控制器
│   └── index.js           # 控制器统一导出
├── routes/                # 路由目录
│   ├── core/              # 核心模块路由
│   ├── forum/             # 论坛模块路由
│   ├── nutrition/         # 营养档案模块路由
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

### 文件编码规范

- **强制要求**: 所有代码文件(*.js, *.json, *.md)必须使用**UTF-8编码**(无BOM)
- **禁止使用**: UTF-16、UTF-32或其他编码格式会导致服务器启动失败
- **编辑器设置**: 请配置您的编辑器默认使用UTF-8编码保存文件
- **中文注释**: 确保所有包含中文字符的文件也使用UTF-8编码

如遇编码问题，可使用以下命令转换:
```bash
# 单个文件转换
iconv -f UTF-16 -t UTF-8 问题文件.js > 临时文件.js && mv 临时文件.js 问题文件.js

# Windows PowerShell转换
$content = Get-Content 问题文件.js
$utf8 = [System.Text.Encoding]::UTF8
Set-Content -Path 问题文件.js -Value $utf8.GetString($utf8.GetBytes($content)) -Encoding UTF8

# 批量转换目录下所有JS文件
find ./目录名 -name "*.js" -type f -exec bash -c 'iconv -f UTF-16 -t UTF-8 "$0" > "$0.tmp" && mv "$0.tmp" "$0"' {} \;
```

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

## 查询助手方法使用指南

查询助手方法（Query Helper Methods）是为MongoDB模型定义的一组链式调用方法，用于简化和标准化常见的查询操作。用户模型（User Model）中定义了以下查询助手方法：

### 用户模型查询助手

User模型提供了四种查询视图，用于不同场景下获取用户信息：

1. **basicProfile** - 获取用户基本信息
   ```javascript
   // 获取所有用户的基本信息列表
   const users = await User.find({}).basicProfile();
   
   // 按角色筛选并获取基本信息
   const customers = await User.find({ role: 'user' }).basicProfile();
   ```

2. **fullProfile** - 获取用户完整信息
   ```javascript
   // 获取单个用户的完整信息
   const user = await User.findById(userId).fullProfile();
   
   // 获取符合条件的用户完整信息
   const activeUsers = await User.find({ accountStatus: 'active' }).fullProfile();
   ```

3. **nutritionistView** - 营养师视角的用户信息
   ```javascript
   // 营养师查看用户信息
   const userForNutritionist = await User.findById(clientId).nutritionistView();
   ```

4. **merchantView** - 商家视角的用户信息
   ```javascript
   // 商家查看用户信息
   const userForMerchant = await User.findById(customerId).merchantView();
   ```

### 在服务层中的应用

查询助手方法可以在服务层中使用，简化代码并确保数据访问的一致性：

```javascript
// 用户服务示例
const getUserProfile = async (userId, viewingRole) => {
  let userQuery = User.findById(userId);
  
  // 根据查看者角色选择合适的视图
  switch (viewingRole) {
    case 'nutritionist':
      userQuery = userQuery.nutritionistView();
      break;
    case 'merchant':
      userQuery = userQuery.merchantView();
      break;
    case 'admin':
      userQuery = userQuery.fullProfile();
      break;
    default:
      userQuery = userQuery.basicProfile();
  }
  
  return await userQuery;
};
```

### 查询助手的好处

1. **代码简洁性** - 减少重复的select字段列表
2. **一致性** - 确保在整个应用中对用户数据的访问保持一致
3. **关注点分离** - 将查询逻辑封装在模型层，而不是散布在各个控制器中
4. **可维护性** - 当需要修改字段选择时，只需更改模型中的定义，而不是每个调用点

### 其他模型的查询助手

除了User模型外，其他模型（如Merchant、Nutritionist等）也定义了类似的查询助手，可以采用相同的方式使用。

## 领域驱动设计(DDD)架构

本项目后端采用领域驱动设计(DDD)架构，将核心业务逻辑封装进领域实体和值对象。

### 架构分层

- **领域层(Domain)**: 包含业务核心概念的实体、值对象和领域服务
  - **实体(Entities)**: 具有唯一标识的业务对象
  - **值对象(Value Objects)**: 无唯一标识的不可变对象
  - **领域服务(Domain Services)**: 处理跨实体的业务逻辑
  - **仓储接口(Repository Interfaces)**: 定义持久化操作的抽象接口

- **应用层(Application)**: 协调领域对象完成用例
  - **应用服务(Application Services)**: 编排领域对象实现业务用例
  - **DTO(Data Transfer Objects)**: 跨层数据传输对象

- **基础设施层(Infrastructure)**: 提供技术能力支持
  - **仓储实现(Repository Implementations)**: 实现领域层定义的仓储接口
  - **外部服务集成(External Service Integration)**: 与外部系统交互

- **接口层(Interface)**: 处理用户交互
  - **控制器(Controllers)**: 处理HTTP请求
  - **中间件(Middlewares)**: 请求预处理和后处理

### 领域模型

核心领域模型包括：

1. **营养(Nutrition)**: 管理食品营养信息和用户营养需求
2. **订单(Order)**: 处理用户订单生命周期
3. **用户(User)**: 管理用户信息和身份验证
4. **餐厅(Restaurant)**: 管理餐厅信息和菜品

每个领域模型都遵循相同的结构组织：实体、值对象、仓储接口和领域服务。