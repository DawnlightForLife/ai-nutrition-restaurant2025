# 后端结构冻结说明（v1.2.0）

冻结日期：2025-05-20  
负责人：系统架构组  
状态：✅ 已冻结

## 技术栈概览

- **主框架**：Node.js (v18 LTS) + Express (v4.x)
- **架构模式**：领域驱动设计 (DDD) + 洋葱架构
- **API风格**：RESTful + GraphQL（特定模块）
- **数据库**：MongoDB (v6.0+)
- **ODM**：Mongoose (v7.0+)
- **认证**：JWT + OAuth2.0 + RBAC
- **测试框架**：Jest + Supertest
- **文档**：OpenAPI 3.0 (Swagger)
- **容器化**：Docker + Docker Compose
- **CI/CD**：GitHub Actions + Jenkins
- **日志**：Winston + Morgan
- **监控**：Prometheus + Grafana
- **缓存**：Redis (v6.x)
- **消息队列**：RabbitMQ / Kafka（选配）
- **搜索引擎**：Elasticsearch（选配，营养数据检索）

## 冻结模块

- ✅ **数据模型**：models/
  - 领域实体定义和Mongoose模式
  - 模型校验规则和中间件
  - 索引优化配置
  
- ✅ **控制器**：controllers/
  - 请求验证和参数处理
  - 权限检查和认证
  - 服务层调用和响应格式化
  
- ✅ **路由**：routes/
  - API版本控制
  - 模块化路由注册
  - 路由中间件管理
  
- ✅ **服务层**：services/
  - 业务逻辑实现
  - 跨领域服务协调
  - 事务管理和一致性保证
  
- ✅ **中间件**：middleware/
  - 认证与授权
  - 请求日志和追踪
  - 错误处理和格式化
  - 性能监控和速率限制
  
- ✅ **配置系统**：config/
  - 环境隔离配置
  - 特性开关机制
  - 安全配置管理
  
- ✅ **常量定义**：constants/
  - 业务常量和枚举值
  - 错误码和消息模板
  - API路径和版本定义
  
- ✅ **工具函数**：utils/
  - 通用功能封装
  - 辅助函数库
  - 格式化和验证工具
  
- ✅ **领域层**：domain/
  - 核心业务规则和逻辑
  - 领域事件和聚合根
  - 领域服务和值对象
  
- ✅ **应用层**：application/
  - 用例实现
  - 服务编排
  - 请求-响应映射
  
- ✅ **基础设施层**：infrastructure/
  - 数据库访问实现
  - 外部服务集成
  - 消息队列和缓存访问

## 目录结构

```
backend/
├── server.js                         # 应用入口
├── app.js                            # Express应用配置
├── models/                           # 数据模型
│   ├── user/                         # 用户相关模型
│   ├── nutrition/                    # 营养相关模型
│   ├── restaurant/                   # 餐厅相关模型
│   ├── order/                        # 订单相关模型
│   └── ...                           # 其他业务模型
├── controllers/                      # 控制器
│   ├── user/                         # 用户相关控制器
│   ├── nutrition/                    # 营养相关控制器
│   ├── restaurant/                   # 餐厅相关控制器
│   ├── order/                        # 订单相关控制器
│   └── ...                           # 其他业务控制器
├── routes/                           # 路由
│   ├── api/                          # API路由
│   │   ├── v1/                       # V1 API
│   │   └── v2/                       # V2 API（扩展）
│   ├── user.routes.js                # 用户路由
│   ├── nutrition.routes.js           # 营养路由
│   └── ...                           # 其他业务路由
├── services/                         # 服务层
│   ├── user/                         # 用户服务
│   ├── nutrition/                    # 营养服务
│   ├── ai/                           # AI推荐服务
│   ├── payment/                      # 支付服务
│   └── ...                           # 其他业务服务
├── middleware/                       # 中间件
│   ├── auth.middleware.js            # 认证中间件
│   ├── error.middleware.js           # 错误处理
│   ├── validator.middleware.js       # 请求验证
│   └── ...                           # 其他中间件
├── domain/                           # 领域层
│   ├── user/                         # 用户领域
│   ├── nutrition/                    # 营养领域
│   ├── order/                        # 订单领域
│   └── ...                           # 其他业务领域
├── application/                      # 应用层
│   ├── user/                         # 用户用例
│   ├── nutrition/                    # 营养用例
│   └── ...                           # 其他业务用例
├── infrastructure/                   # 基础设施
│   ├── database/                     # 数据库连接和配置
│   ├── cache/                        # 缓存服务
│   ├── messaging/                    # 消息服务
│   └── external/                     # 外部服务集成
├── config/                           # 配置
│   ├── database.config.js            # 数据库配置
│   ├── auth.config.js                # 认证配置
│   ├── app.config.js                 # 应用配置
│   └── ...                           # 其他配置
├── utils/                            # 工具函数
│   ├── logger.js                     # 日志工具
│   ├── validators.js                 # 验证工具
│   ├── formatters.js                 # 格式化工具
│   └── ...                           # 其他工具
├── constants/                        # 常量
│   ├── error.constants.js            # 错误常量
│   ├── api.constants.js              # API常量
│   └── ...                           # 其他常量
├── docs/                             # 文档
│   ├── api/                          # API文档
│   ├── internal/                     # 内部文档
│   └── ...                           # 其他文档
├── tests/                            # 测试
│   ├── unit/                         # 单元测试
│   ├── integration/                  # 集成测试
│   ├── e2e/                          # 端到端测试
│   └── ...                           # 其他测试
├── scripts/                          # 脚本
│   ├── seed.js                       # 数据种子
│   ├── migration/                    # 迁移脚本
│   └── ...                           # 其他脚本
└── logs/                             # 日志文件
```

## API设计规范

### RESTful API规范

- **命名规则**：使用资源复数形式（如`/users`而非`/user`）
- **版本控制**：在URL中包含版本信息（如`/api/v1/users`）
- **HTTP方法**：
  - `GET`：获取资源
  - `POST`：创建资源
  - `PUT`：完全更新资源
  - `PATCH`：部分更新资源
  - `DELETE`：删除资源
- **状态码**：
  - `200 OK`：请求成功
  - `201 Created`：资源创建成功
  - `204 No Content`：成功但无返回内容
  - `400 Bad Request`：客户端错误
  - `401 Unauthorized`：未授权
  - `403 Forbidden`：禁止访问
  - `404 Not Found`：资源不存在
  - `500 Internal Server Error`：服务器错误
- **响应格式**：
  ```json
  {
    "success": true,
    "data": {},
    "message": "操作成功",
    "code": 200,
    "meta": {
      "page": 1,
      "limit": 10,
      "total": 100
    }
  }
  ```
- **错误格式**：
  ```json
  {
    "success": false,
    "error": {
      "code": "USER_NOT_FOUND",
      "message": "用户不存在",
      "details": {}
    }
  }
  ```

### GraphQL API规范（营养推荐模块专用）

- **Schema优先设计**：先定义Schema再实现解析器
- **关注分离**：每个类型对应特定领域
- **错误处理**：使用Apollo标准错误格式
- **缓存策略**：实现DataLoader批处理和缓存
- **权限控制**：指令和解析器级别的权限检查
- **性能优化**：字段级别的查询复杂度控制

## 与前端框架的集成

### 数据流向

```
前端 <-- API --> 控制器 --> 应用层 --> 领域层 --> 仓库层 --> 数据库
```

### 与前端DDD结构映射

| 后端模块 | 对应前端模块 |
|---------|-------------|
| domain/user/ | domain/user/ |
| domain/nutrition/ | domain/nutrition/ |
| domain/order/ | domain/order/ |
| controllers/user/ | presentation/screens/user/ |
| application/user/ | application/user/ |
| services/payment/ | services/plugins/payment/ |

## 与数据库模型的集成

### 数据模型映射

| 数据库集合 | 后端模型 | 领域实体 |
|---------|---------|---------|
| users | models/user/user.model.js | domain/user/user.entity.js |
| nutrition_profiles | models/nutrition/nutritionProfile.model.js | domain/nutrition/nutritionProfile.entity.js |
| orders | models/order/order.model.js | domain/order/order.entity.js |

### 仓库实现与领域模型映射

```javascript
// 仓库实现
class UserRepository implements IUserRepository {
  async findById(id: string): Promise<UserEntity> {
    const userModel = await UserModel.findById(id);
    return this.modelToEntity(userModel);
  }
  
  private modelToEntity(model: any): UserEntity {
    return new UserEntity({
      id: model._id.toString(),
      name: model.name,
      // ...映射其他属性
    });
  }
}
```

## 性能优化策略

### 数据库优化

- **索引优化**：
  - 根据查询模式设计索引
  - 使用复合索引优化多字段查询
  - 定期分析索引使用情况

- **查询优化**：
  - 有选择地投影字段减少数据传输
  - 使用批量操作替代多次单一操作
  - 实现分页避免大量数据返回

### 缓存策略

- **多级缓存**：
  - 内存缓存（Node.js本地）
  - Redis缓存（分布式）
  - CDN缓存（静态资源）

- **缓存粒度**：
  - 完整响应缓存
  - 数据片段缓存
  - 计算结果缓存

### API性能

- **压缩和最小化**：
  - 启用gzip/brotli压缩
  - 减少响应体积
  
- **连接优化**：
  - 实现HTTP/2支持
  - 开启Keep-Alive

## 安全实践

### 认证与授权

- **JWT实现**：
  - 短期访问令牌 + 长期刷新令牌
  - 令牌轮换机制
  - 令牌吊销列表
  
- **RBAC模型**：
  - 角色继承结构
  - 细粒度权限控制
  - 动态权限分配

### 数据安全

- **加密策略**：
  - 传输层加密（HTTPS）
  - 存储加密（敏感字段）
  - 密钥管理与轮换
  
- **输入验证**：
  - 请求数据验证中间件
  - SQL/NoSQL注入防护
  - XSS防护

### 审计与日志

- **安全日志**：
  - 认证事件记录
  - 权限变更审计
  - 敏感操作跟踪
  
- **合规考虑**：
  - 数据保留策略
  - 个人信息处理
  - 操作合规性记录

## 冻结原则

1. 所有结构性变更需评估后审批；
2. 命名规范、目录划分不得擅自修改；
3. 功能新增应在结构下有序扩展，不破坏封装边界；
4. 禁止直接在 controller 中写业务逻辑；
5. 单元测试为关键模块开发必选项；
6. 领域实体必须遵循DDD原则，不引入基础设施依赖；
7. 应用服务负责协调领域对象，不包含业务规则；
8. API接口签名冻结，新功能须向后兼容；
9. 中间件执行顺序和职责边界冻结；
10. 错误码和响应格式结构冻结。

## 可扩展部分

以下部分不在冻结范围内，可以灵活扩展：

1. 新的业务逻辑实现；
2. 服务内部实现优化；
3. 具体查询和命令处理；
4. 第三方服务集成实现细节；
5. 非核心中间件功能。

## 微服务架构考虑

当前版本采用单体架构，但已规划未来微服务拆分路径：

### 微服务边界

- **用户服务**：用户管理、认证和权限
- **营养服务**：营养档案、推荐算法
- **餐厅服务**：商家管理、菜品管理
- **订单服务**：订单处理、支付集成
- **社区服务**：论坛、评论、内容管理
- **通知服务**：消息推送、邮件、短信

### 服务间通信

- 同步通信：REST / gRPC
- 异步通信：消息队列（Kafka/RabbitMQ）
- 服务发现：Consul/etcd

### 数据策略

- 数据库隔离：每个微服务独立数据库
- 一致性策略：最终一致性（事件驱动）
- 查询策略：CQRS模式（读写分离）

## 后续工作

- ❗ 所有新功能开发必须依赖当前 frozen 架构；
- 🧪 启动后端单元测试覆盖率目标（>85%）；
- 🧰 为每个 service 添加集成测试 stub 模板；
- 🏗️ 逐步将传统服务迁移到领域驱动设计架构；
- 📚 为新增领域模型编写详细文档；
- 🔄 完善CI/CD管道，确保代码质量；
- 🔍 实现更完善的监控和报警机制。

## 变更历史记录

| 版本 | 日期 | 变更内容 | 负责人 |
|-----|------|---------|-------|
| v1.0.0 | 2025-05-15 | 初始冻结版本 | 架构团队 |
| v1.1.0 | 2025-05-30 | 添加GraphQL API规范 | API团队 |
| v1.2.0 | 2025-06-10 | 完善安全策略和性能优化 | 系统架构组 |