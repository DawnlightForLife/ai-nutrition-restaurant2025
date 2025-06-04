# 变更日志

本文档记录系统架构、API和模型的重要变更。

## 2025-05-25

### 架构变更

- **添加**: 引入领域驱动设计(DDD)架构
  - 创建领域层，包含实体、值对象、仓储接口和领域服务
  - 创建应用层，包含应用服务
  - 创建基础设施层，包含仓储实现
  - 添加新的架构文档 `subsystems/domain-driven-design.md`

### 核心领域模型

- **添加**: 营养(Nutrition)领域模型
  - 餐品(Meal)实体
  - 餐品营养信息(MealNutritionInfo)值对象
  - 餐品仓储(MealRepository)接口

- **添加**: 订单(Order)领域模型
  - 订单(Order)实体
  - 订单项(OrderItem)值对象
  - 订单状态(OrderStatus)值对象

### 应用服务

- **添加**: 餐品应用服务(MealService)
  - 创建餐品功能
  - 更新餐品功能
  - 获取推荐餐品功能
  - 营养筛选餐品功能

### 基础设施

- **添加**: MongoDB餐品仓储实现(MongoDBMealRepository)
  - 实现餐品的CRUD操作
  - 实现餐品的高级查询功能

## 2025-06-04

### 数据库模型变更

- **添加**: 访客营养档案模型(GuestProfile)
  - 支持未注册用户创建临时营养档案
  - 包含绑定令牌机制，便于注册后数据迁移
  - 自动过期清理（30天TTL）
  - 完整的营养需求计算功能

- **添加**: 取餐码模型(PickupCode)
  - 6位字符码生成（避免混淆字符）
  - 支持到店取餐和外卖配送场景
  - 包含验证和使用记录功能
  - 自动过期清理（24小时TTL）

- **添加**: 积分交易模型(PointsTransaction)
  - 支持多种积分类型（消费、签到、评价等）
  - 包含交易原因和关联订单追踪
  - 不可变设计，确保积分历史完整性

- **添加**: 积分规则模型(PointsRule)
  - 灵活的积分计算规则配置
  - 支持条件判断和优先级设置
  - 包含生效时间范围控制

- **添加**: 内容举报模型(ContentReport)
  - 支持多种内容类型举报（帖子、评论、用户等）
  - 包含处理流程和结果记录
  - 支持管理员处理追踪

### 服务层变更

- **添加**: 访客档案服务(GuestProfileService)
  - 完整的CRUD操作
  - 令牌绑定和数据迁移功能
  - 营养需求计算和更新

- **添加**: 取餐码服务(PickupCodeService)
  - 唯一码生成算法
  - 批量验证支持
  - 使用统计功能

- **添加**: 积分服务(PointsService)
  - 积分增减操作
  - 规则匹配和计算
  - 积分历史查询
  - 积分排行榜功能

- **添加**: 内容举报服务(ContentReportService)
  - 举报创建和处理
  - 自动检测集成
  - 统计分析功能

### 控制器变更

- **添加**: 访客档案控制器(GuestProfileController)
  - RESTful API端点
  - 营养需求计算接口
  - 数据绑定接口

- **添加**: 取餐码控制器(PickupCodeController)
  - 生成、验证、查询接口
  - 批量操作支持
  - 统计查询接口

- **添加**: 积分控制器(PointsController)
  - 积分查询和历史接口
  - 积分规则管理接口
  - 排行榜接口

- **添加**: 内容举报控制器(ContentReportController)
  - 举报提交接口
  - 管理员处理接口
  - 统计查询接口

### 路由变更

- **添加**: 访客档案路由 `/api/v1/guest-profiles`
- **添加**: 积分管理路由 `/api/v1/points`
- **添加**: 取餐码路由 `/api/v1/pickup-codes`
- **添加**: 内容举报路由 `/api/v1/content-reports`

### 工具类变更

- **添加**: 自定义错误类(errors.js)
  - ValidationError - 验证错误
  - AuthenticationError - 认证错误
  - AuthorizationError - 授权错误
  - NotFoundError - 资源不存在
  - ConflictError - 资源冲突
  - RateLimitError - 限流错误

- **添加**: 响应助手(responseHelper.js)
  - 统一的成功响应格式
  - 统一的错误响应格式
  - 分页响应格式

### 文档变更

- **添加**: 模型文档
  - docs/models/guestProfileModel.md - 访客档案模型详细说明
  - docs/models/pickupCodeModel.md - 取餐码模型详细说明
  - docs/models/pointsModel.md - 积分系统模型详细说明
  - docs/models/contentReportModel.md - 内容举报模型详细说明
  - docs/models/schemaRelations.md - 更新模型关系图

- **添加**: API文档
  - 更新 docs/api/user.md - 添加访客档案和积分管理接口

## 2025-06-04 (系统修复更新)

### Docker & 基础设施修复

- **修复**: Redis服务配置
  - 添加Redis服务到docker-compose.yml
  - 配置Redis健康检查和数据持久化
  - 设置正确的环境变量（REDIS_HOST=redis, REDIS_PORT=6379）
  - 修复Redis连接错误处理和日志格式问题

- **修复**: Docker容器依赖关系
  - 后端容器现在正确依赖Redis和MongoDB健康检查
  - 添加Redis数据卷持久化
  - 优化容器启动顺序

### 中间件系统修复

- **修复**: 认证中间件导入问题
  - 统一authMiddleware导入为`{ authenticateUser }`
  - 修复roleMiddleware导出方式，直接导出函数
  - 修复permissionMiddleware解构导入问题

- **修复**: 限流中间件重构
  - 统一rateLimitMiddleware导入为`{ createDynamicLimiter }`
  - 修复RedisStore导入方式，使用正确的解构语法
  - 添加Redis连接错误时的内存存储降级机制
  - 优化错误日志格式，避免对象序列化问题

- **修复**: 验证中间件路径
  - 临时注释未实现的validationMiddleware方法调用
  - 添加TODO标记用于后续实现
  - 保持系统可启动性优先

### 路由系统修复

- **修复**: 模块导入路径错误
  - 修复accessTrackingMiddleware路径：`./accessTrackingMiddleware` → `../access/accessTrackingMiddleware`
  - 统一所有路由文件的中间件导入方式
  - 解决"Cannot find module"错误

- **修复**: 路由回调函数问题
  - 解决"Route.post() requires a callback function"错误
  - 确保所有中间件正确加载和调用
  - 修复undefined中间件引用

### 启动流程优化

- **修复**: 系统启动序列
  - 修复容器重启后代码更新问题
  - 优化Docker volume映射和代码热更新
  - 确保所有服务按正确顺序初始化

- **验证**: 服务健康状态
  - ✅ Backend: 运行在端口8080，正常响应
  - ✅ Redis: 健康运行在端口6379
  - ✅ MongoDB: 健康运行在端口27017  
  - ✅ AI Service: 运行在端口8000
  - ✅ Frontend: 运行在端口80

### 日志和监控改进

- **改进**: 错误日志格式
  - 修复Redis错误消息的字符串序列化问题
  - 优化启动日志输出格式
  - 添加服务初始化成功确认信息

### 技术债务清理

- **清理**: 临时方案标记
  - 所有暂时注释的验证中间件都已标记TODO
  - 明确标识需要后续实现的功能
  - 保持代码可维护性和扩展性

### 系统稳定性提升

- **提升**: 错误处理机制
  - Redis连接失败时自动降级到内存存储
  - 改进的断路器模式和重试机制
  - 更好的服务间依赖管理

### 开发体验优化

- **优化**: 开发工作流
  - 修复Docker开发环境启动问题
  - 改进代码热更新机制
  - 简化本地开发环境搭建
  - 更新 docs/api/order.md - 添加取餐码管理接口
  - 更新 docs/api/security.md - 添加内容举报管理接口

- **添加**: 工作流文档
  - docs/workflows/guest_to_user_migration.md - 访客转用户流程
  - docs/workflows/pickup_code_lifecycle.md - 取餐码生命周期
  - docs/workflows/points_calculation_flow.md - 积分计算流程
  - docs/workflows/content_moderation_process.md - 内容审核流程

### 餐厅模块实现

- **添加**: 餐厅领域实体(Restaurant)
  - 完整的餐厅信息管理
  - 验证状态和运营状态控制
  - 公开信息和私密信息分离

- **添加**: 分店领域实体(Branch)
  - 分店位置和营业时间管理
  - 地理位置计算功能
  - 实时营业状态判断

- **添加**: 餐桌领域实体(Table)
  - 餐桌状态管理（可用、占用、预订、清洁、维护）
  - 扫码点餐二维码支持
  - 餐桌特性和位置信息

- **添加**: 餐厅设置领域实体(RestaurantSetting)
  - 订单、支付、配送设置
  - 营运、营养、促销设置
  - 分店级别设置继承

### 第二阶段模型实现

- **添加**: 数据导出请求模型(DataExportRequest)
  - 支持多种导出类型（个人数据、订单、营养记录等）
  - 导出审批流程（敏感数据需审批）
  - 文件过期和访问控制
  - 导出统计和清理功能

- **添加**: 加盟商模型(Franchise)
  - 完整的加盟商信息管理
  - 合同和财务信息跟踪
  - 绩效评估和警告系统
  - 区域限制和门店授权

- **添加**: 门店权限模型(StorePermission)
  - 细粒度的权限控制
  - 预设角色权限模板
  - 时间和功能范围限制
  - 权限使用记录追踪

### 中间件增强

- **更新**: 验证中间件(validationMiddleware)
  - 支持通过配置名称选择验证规则
  - 集中管理所有API验证模式
  - 包含通用验证规则复用

- **添加**: 验证模式集合(validationSchemas)
  - 用户、餐厅、订单、营养等模块验证规则
  - Joi验证规则定义
  - 支持复杂对象和数组验证

### 待实施项目

- Swagger/OpenAPI规范生成
- 集成测试用例编写
- 性能优化和索引调优
