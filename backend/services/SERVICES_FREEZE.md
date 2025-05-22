# 智能营养餐厅系统 - 服务层冻结文档

**文档版本**: `v1.2.0`
**文档日期**: `2025-05-20`
**状态**: ✅ 已冻结

## 目录
1. [服务层设计概述](#服务层设计概述)
2. [目录结构](#目录结构) 
3. [模块详情](#模块详情)
4. [服务实现规范](#服务实现规范)
5. [服务间通信](#服务间通信)
6. [性能优化策略](#性能优化策略)
7. [错误处理机制](#错误处理机制)
8. [监控与可观测性](#监控与可观测性)
9. [与前端和数据库的集成](#与前端和数据库的集成)
10. [冻结范围](#冻结范围)
11. [更新与维护指南](#更新与维护指南)
12. [变更记录](#变更记录)

## 服务层设计概述

智能营养餐厅系统的服务层采用分层架构，将业务逻辑与数据访问分离。服务层作为控制器与数据模型之间的桥梁，实现业务规则和数据流转。系统按业务领域划分服务模块，同时提供基础设施服务支持高级特性。

### 设计原则

1. **领域驱动设计**: 按业务领域划分服务模块，体现DDD思想
2. **单一职责**: 每个服务模块专注于特定功能领域
3. **松耦合**: 服务之间通过依赖注入和事件机制实现松耦合
4. **可测试性**: 服务接口设计便于单元测试和集成测试
5. **错误处理**: 统一的错误处理和日志记录机制
6. **可扩展性**: 支持水平扩展和垂直扩展的服务设计
7. **幂等性**: 关键操作遵循幂等性原则
8. **事务完整性**: 确保跨服务操作的事务一致性
9. **防腐层**: 外部依赖通过适配器隔离，降低系统耦合
10. **可观测性**: 服务行为透明，支持全链路监控

## 目录结构

```
services/
├── user/                         # 用户系统服务层
├── nutrition/                    # 用户营养相关服务
├── merchant/                     # 商家与门店服务
├── forum/                        # 社区模块服务
├── order/                        # 订单系统服务
├── consult/                      # 咨询服务逻辑层
├── notification/                 # 系统通知服务
├── monitoring/                   # 系统级观测模块
├── feedback/                     # 意见反馈模块
├── promotion/                    # 营销活动逻辑
├── analytics/                    # 后台数据分析服务
├── security/                     # 安全相关服务
├── core/                         # 系统配置与审计服务
├── database/                     # 数据访问控制服务
├── cache/                        # 缓存服务层
├── model/                        # 数据模型动态管理
├── performance/                  # 性能优化服务
├── messaging/                    # 消息通知服务
├── ai/                           # AI推荐引擎集成服务
├── payment/                      # 支付服务集成
├── dev/                          # 开发工具服务
└── index.js                      # 服务统一导出入口
```

## 模块详情

### 用户系统服务 (user/)

📁 **模块说明**: 用户账户管理、身份验证、权限管理的核心服务层

📄 **服务文件列表**:
- `userService.js`: 用户资料管理、状态变更、查询与修改
- `userRoleService.js`: 用户角色分配、权限管理、角色层级控制
- `adminService.js`: 管理员账户管理、权限判断、后台用户列表
- `authService.js`: 用户登录验证、JWT令牌签发与校验、会话管理、未注册用户自动注册
- `oauthService.js`: 第三方登录集成、社交账号绑定与解绑

🧩 **依赖关系**: 调用User模型、缓存服务、加密服务、日志服务、消息服务

🧪 **测试覆盖**: 单元测试覆盖率92%，关键流程100%测试

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。身份验证模块作为系统安全核心组件，具备高稳定性和可靠性。

🧩 **领域特性**: 符合DDD领域服务模式，实现用户身份与权限领域的核心业务逻辑。

🔄 **服务接口示例**:
```javascript
// UserService接口
interface IUserService {
  getUserById(id: string): Promise<UserEntity>;
  updateProfile(id: string, data: UserProfileDTO): Promise<UserEntity>;
  changeUserStatus(id: string, status: UserStatus): Promise<void>;
  searchUsers(criteria: UserSearchCriteria): Promise<UserSearchResult>;
  deleteUser(id: string): Promise<boolean>;
}
```

### 营养模块服务 (nutrition/)

📁 **模块说明**: 用户营养档案管理、AI推荐生成、营养师资质认证的专业服务层

📄 **服务文件列表**:
- `nutritionProfileService.js`: 用户营养档案创建、更新与查询
- `dietaryPreferenceService.js`: 饮食偏好设置、食材禁忌管理
- `aiRecommendationService.js`: AI推荐生成与查询、用户反馈收集
- `nutritionPlanService.js`: 营养计划制定、执行状态跟踪
- `nutritionistService.js`: 营养师资质管理、服务项目管理
- `FavoriteService.js`: 用户收藏管理、收藏列表查询

🧩 **依赖关系**: 调用营养相关模型、AI服务接口、缓存服务、用户服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。AI推荐服务接口稳定，支持多种推荐算法插件。

🧩 **领域特性**: 符合DDD领域服务模式，营养分析与推荐是系统的核心竞争力。

### 商家模块服务 (merchant/)

📁 **模块说明**: 商家管理、门店管理、菜品管理的综合服务层

📄 **服务文件列表**:
- `merchantService.js`: 商家注册、资料管理、审核流程
- `merchantStatsService.js`: 商家数据统计、销售分析、客流分析
- `storeService.js`: 门店信息管理、营业状态管理
- `dishService.js`: 菜品信息管理、营养成分标注
- `storeDishService.js`: 门店菜品关联、库存与价格管理

🧩 **依赖关系**: 调用商家相关模型、文件上传服务、地理位置服务、缓存服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。支持多种商家类型和经营模式。

🧩 **领域特性**: 符合DDD领域服务模式，商家管理是平台运营的核心组成部分。

### 订单模块服务 (order/)

📁 **模块说明**: 订单创建、支付处理、订阅管理的交易服务层

📄 **服务文件列表**:
- `orderService.js`: 订单创建、状态管理、取消与退款
- `subscriptionService.js`: 订阅计划管理、自动续费处理
- `consultationService.js`: 咨询服务订单、预约时间管理

🧩 **依赖关系**: 调用订单模型、支付网关接口、用户服务、商家服务、事务服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。订单处理流程完善，支持多种支付方式。

🧩 **领域特性**: 符合DDD领域服务模式，实现交易领域的核心业务逻辑。

### 咨询服务 (consult/)

📁 **模块说明**: 营养师咨询服务、消息管理的互动服务层

📄 **服务文件列表**:
- `consultationService.js`: 咨询问题提交、回复管理、会话状态控制

🧩 **依赖关系**: 调用咨询模型、用户服务、营养师服务、通知服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。支持实时消息和异步消息模式。

### 社区模块服务 (forum/)

📁 **模块说明**: 社区内容管理、互动功能的UGC服务层

📄 **服务文件列表**:
- `forumPostService.js`: 帖子发布、编辑、审核管理
- `forumCommentService.js`: 评论管理、回复树结构处理

🧩 **依赖关系**: 调用论坛模型、用户服务、内容审核服务、通知服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。内容管理流程完善，支持多级评论。

### 通知服务 (notification/)

📁 **模块说明**: 系统通知、消息推送的通知服务层

📄 **服务文件列表**:
- `notificationService.js`: 通知创建、发送、状态管理、模板处理

🧩 **依赖关系**: 调用通知模型、用户服务、消息推送服务、模板渲染服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。支持多渠道通知派发。

### 系统监控服务 (monitoring/)

📁 **模块说明**: 系统性能监控、异常告警的监控服务层

📄 **服务文件列表**:
- `alertSystem.js`: 异常监控、阈值告警、指标收集

🧩 **依赖关系**: 调用监控模型、日志服务、消息推送服务

🧱 **基础设施**: 作为系统基础组件，被多个业务模块引用，提供可靠的监控能力。

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。告警系统支持多级别和多渠道。

### 反馈服务 (feedback/)

📁 **模块说明**: 用户意见反馈、问题处理的反馈服务层

📄 **服务文件列表**:
- `feedbackService.js`: 反馈提交、状态管理、回复处理

🧩 **依赖关系**: 调用反馈模型、用户服务、通知服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。

### 促销服务 (promotion/)

📁 **模块说明**: 优惠活动、促销规则的营销服务层

📄 **服务文件列表**:
- `promotionService.js`: 优惠券管理、满减规则、限时折扣

🧩 **依赖关系**: 调用促销模型、商家服务、订单服务、用户服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。支持多种促销规则组合。

### 数据分析服务 (analytics/)

📁 **模块说明**: 用户行为分析、数据导出的分析服务层

📄 **服务文件列表**:
- `usageLogService.js`: 用户行为日志记录、查询分析
- `exportTaskService.js`: 数据导出任务创建、进度控制

🧩 **依赖关系**: 调用分析模型、批处理服务、文件服务

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。支持异步导出和定时统计。

### 安全服务 (security/)

📁 **模块说明**: 数据安全、访问控制的安全服务层

📄 **服务文件列表**:
- `accessTrackingService.js`: 接口访问日志、异常行为识别
- `fieldEncryptionService.js`: 敏感字段加解密处理
- `dataAccessControlService.js`: 数据访问权限控制

🧩 **依赖关系**: 调用安全模型、加密算法、审计日志服务

🧱 **基础设施**: 作为系统基础组件，为多个业务模块提供安全保障。

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。安全机制采用行业标准实践。

### 核心服务 (core/)

📁 **模块说明**: 系统配置、审计日志的核心服务层

📄 **服务文件列表**:
- `appConfigService.js`: 系统配置管理、参数读写
- `auditLogService.js`: 审计日志记录、查询分析

🧩 **依赖关系**: 调用核心模型、缓存服务、日志服务

🧱 **基础设施**: 作为系统基础组件，为整个应用提供配置管理和审计能力。

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。

### 数据库服务 (database/)

📁 **模块说明**: 数据库访问、分片管理、连接池控制的数据服务层

📄 **服务文件列表**:
- `shardingService.js`: 数据分片策略实现
- `shardAdvisorService.js`: 分片优化建议生成
- `shardAccessService.js`: 分片数据访问控制
- `adaptiveShardingService.js`: 自适应分片策略调整
- `connectionPoolManager.js`: 数据库连接池管理
- `asyncConnectionPoolManager.js`: 异步连接池管理
- `readConsistencyService.js`: 读一致性控制
- `transactionService.js`: 事务管理封装
- `distributedTransactionService.js`: 分布式事务控制
- `dbProxyService.js`: 数据库代理服务

🧩 **依赖关系**: 调用数据库驱动、配置服务、性能监控服务

🧱 **基础设施**: 作为系统基础组件，为所有数据访问提供底层支持。

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。数据库服务是整个应用的核心基础设施。

### 缓存服务 (cache/)

📁 **模块说明**: Redis缓存封装、缓存策略管理的缓存服务层

📄 **服务文件列表**:
- `cacheService.js`: 基础缓存操作封装
- `enhancedCacheService.js`: 高级缓存策略实现
- `cacheManager.js`: 缓存命名空间管理

🧩 **依赖关系**: 调用Redis客户端、配置服务、日志服务

🧱 **基础设施**: 作为系统基础组件，为多个模块提供缓存能力，提升系统性能。

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。缓存机制完善，支持多级缓存和一致性策略。

### 模型管理服务 (model/)

📁 **模块说明**: 数据模型动态管理、Schema分析的模型服务层

📄 **服务文件列表**:
- `dynamicModelLoaderService.js`: 动态加载模型定义
- `modelIntegrationService.js`: 模型集成与关联
- `schemaAnalysisService.js`: Schema结构分析
- `schemaGuardService.js`: Schema完整性验证
- `schemaJsonConverter.js`: Schema与JSON转换
- `schemaTransformer.js`: Schema结构转换
- `migrationManagerService.js`: 数据迁移管理

🧩 **依赖关系**: 调用Mongoose模型、数据库服务、日志服务

🧱 **基础设施**: 作为系统基础组件，为模型定义和数据迁移提供支持。

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。模型管理服务支持动态模型加载和数据迁移。

### 性能优化服务 (performance/)

📁 **模块说明**: 性能监控、优化、保护的性能服务层

📄 **服务文件列表**:
- `dbOptimizationManager.js`: 数据库查询优化
- `circuitBreakerService.js`: 断路器保护机制
- `retryStrategyService.js`: 重试策略实现
- `batchProcessService.js`: 批处理任务管理

🧩 **依赖关系**: 调用数据库服务、监控服务、日志服务

🧱 **基础设施**: 作为系统基础组件，为应用提供性能保障和优化能力。

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。性能服务实现了多种优化策略和保护机制。

### 消息服务 (messaging/)

📁 **模块说明**: 邮件、短信发送的消息服务层

📄 **服务文件列表**:
- `emailService.js`: 邮件发送与模板渲染
- `smsService.js`: 短信发送与验证码管理

🧩 **依赖关系**: 调用第三方API、模板服务、配置服务

🧱 **基础设施**: 作为系统基础组件，为多个模块提供外部通讯能力。

✅ **状态说明**: 服务逻辑结构已冻结，推荐不再随意重构。消息服务支持多渠道和消息模板。

### 开发工具服务 (dev/)

📁 **模块说明**: 开发辅助工具的开发服务层

📄 **服务文件列表**:
- `schemaDevToolService.js`: Schema开发工具服务

🧩 **依赖关系**: 调用模型服务、数据库服务

✅ **状态说明**: 开发工具接口，可能随需求变动。仅在开发环境使用。

## 服务实现规范

### 服务类实现模式

所有服务类实现应遵循以下结构模式:

```javascript
// 服务类实现示例
class UserService implements IUserService {
  // 私有成员变量
  #userRepository;
  #cacheService;
  #eventEmitter;
  #logger;
  
  // 构造函数 - 依赖注入
  constructor(
    userRepository,
    cacheService,
    eventEmitter,
    logger
  ) {
    this.#userRepository = userRepository;
    this.#cacheService = cacheService;
    this.#eventEmitter = eventEmitter;
    this.#logger = logger;
  }
  
  // 公共服务方法
  async getUserById(id) {
    try {
      // 缓存检查
      const cachedUser = await this.#cacheService.get(`user:${id}`);
      if (cachedUser) return cachedUser;
      
      // 数据库查询
      const user = await this.#userRepository.findById(id);
      if (!user) throw new EntityNotFoundError('User', id);
      
      // 缓存结果
      await this.#cacheService.set(`user:${id}`, user, { ttl: 3600 });
      
      return user;
    } catch (error) {
      // 错误处理
      this.#logger.error(`Failed to get user ${id}`, { error });
      throw this.#handleError(error);
    }
  }
  
  // 私有辅助方法
  #handleError(error) {
    // 错误转换逻辑
    if (error instanceof DatabaseError) 
      return new ServiceError('数据库操作失败', error);
    return error;
  }
}
```

### 服务模型与领域对象转换

服务层需要在数据模型和领域对象之间进行转换，保持领域纯净性:

```javascript
// 数据模型转领域对象
function mapToEntity(userModel) {
  return new UserEntity({
    id: userModel._id.toString(),
    username: userModel.username,
    email: userModel.email,
    role: mapToRole(userModel.roleId),
    status: userModel.status,
    // 省略其他映射...
  });
}

// 领域对象转数据模型
function mapToModel(userEntity) {
  return {
    username: userEntity.username,
    email: userEntity.email,
    roleId: userEntity.role.id,
    status: userEntity.status,
    // 省略其他映射...
  };
}
```

### 事务处理模式

跨服务和跨资源操作的事务保证:

```javascript
// 两阶段事务示例
async function createOrderWithPayment(userId, orderData) {
  // 阶段1: 资源准备
  const orderCreation = await orderService.prepareOrder(userId, orderData);
  const paymentPrepare = await paymentService.preparePayment(orderData.payment);
  
  try {
    // 阶段2: 执行提交
    const order = await orderService.confirmOrder(orderCreation.preparationId);
    const payment = await paymentService.executePayment(paymentPrepare.preparationId);
    
    // 发送事件通知
    eventEmitter.emit('order.created', { order, payment });
    
    return { order, payment };
  } catch (error) {
    // 回滚
    await orderService.rollbackOrder(orderCreation.preparationId);
    await paymentService.cancelPayment(paymentPrepare.preparationId);
    throw error;
  }
}
```

## 服务间通信

### 同步通信模式

服务之间的直接调用应通过接口进行，而非直接依赖实现:

```javascript
// 错误示范 - 直接引用实现
const OrderServiceImpl = require('../order/orderService');
const orderService = new OrderServiceImpl();

// 正确示范 - 通过依赖注入
function UserService(orderService) {
  this.orderService = orderService;
  
  this.getUserOrders = async function(userId) {
    return this.orderService.getOrdersByUserId(userId);
  };
}
```

### 异步通信模式

对于不需要立即反馈的操作，服务应使用事件驱动模式通信:

```javascript
// 发布事件
class OrderService {
  async createOrder(orderData) {
    const order = await this.orderRepository.create(orderData);
    this.eventEmitter.emit('order.created', { order });
    return order;
  }
}

// 订阅事件
class NotificationService {
  constructor(eventEmitter) {
    this.eventEmitter = eventEmitter;
    
    // 注册事件处理器
    this.eventEmitter.on('order.created', this.handleOrderCreated.bind(this));
  }
  
  async handleOrderCreated(data) {
    await this.sendOrderNotification(data.order);
  }
}
```

### 请求上下文传播

服务调用链中传递请求上下文，确保全链路追踪和权限连贯性:

```javascript
// 上下文传播
async function processUserRequest(ctx, userId, action) {
  // 记录当前上下文
  this.logger.debug('Processing request', { 
    requestId: ctx.requestId,
    userId,
    action
  });
  
  // 传递上下文到下游服务
  const result = await this.downstreamService.performAction(ctx, action);
  return result;
}
```

## 性能优化策略

### 缓存策略

各服务层实现应采用以下缓存模式:

```javascript
// 多级缓存策略示例
async function getPopularDishes() {
  // 1. 检查本地内存缓存(最快)
  const memoryCache = localCache.get('popular_dishes');
  if (memoryCache) return memoryCache;
  
  // 2. 检查Redis缓存(次快)
  const redisCache = await redisService.get('popular_dishes');
  if (redisCache) {
    // 回填本地缓存
    localCache.set('popular_dishes', redisCache, { ttl: 60 }); // 1分钟
    return redisCache;
  }
  
  // 3. 查询数据库(最慢)
  const dishes = await dishRepository.findPopularDishes();
  
  // 4. 设置缓存
  redisService.set('popular_dishes', dishes, { ttl: 300 }); // 5分钟
  localCache.set('popular_dishes', dishes, { ttl: 60 }); // 1分钟
  
  return dishes;
}
```

### 批量处理

对于大量数据操作，应实现批量处理机制:

```javascript
// 批量操作示例
async function updateUserStatuses(userIds, status) {
  // 批量大小
  const BATCH_SIZE = 100;
  const results = [];
  
  // 分批处理
  for (let i = 0; i < userIds.length; i += BATCH_SIZE) {
    const batch = userIds.slice(i, i + BATCH_SIZE);
    const batchResults = await userRepository.bulkUpdateStatus(batch, status);
    results.push(...batchResults);
  }
  
  return results;
}
```

### 并行处理

对于独立操作，采用并行处理提高性能:

```javascript
// 并行处理示例
async function getUserDashboard(userId) {
  // 并行获取多个独立数据源
  const [
    userProfile,
    recentOrders,
    nutritionData,
    recommendations
  ] = await Promise.all([
    userService.getUserProfile(userId),
    orderService.getUserRecentOrders(userId, { limit: 5 }),
    nutritionService.getUserNutritionSummary(userId),
    recommendationService.getUserRecommendations(userId)
  ]);
  
  // 组合结果
  return {
    profile: userProfile,
    orders: recentOrders,
    nutrition: nutritionData,
    recommendations
  };
}
```

## 错误处理机制

### 错误类型层次结构

系统定义统一的错误类型继承体系:

```javascript
// 错误基类
class AppError extends Error {
  constructor(message, code, details = {}) {
    super(message);
    this.name = this.constructor.name;
    this.code = code;
    this.details = details;
    this.timestamp = new Date();
  }
}

// 业务错误
class BusinessError extends AppError {
  constructor(message, details) {
    super(message, 'BUSINESS_ERROR', details);
  }
}

// 验证错误
class ValidationError extends AppError {
  constructor(message, details) {
    super(message, 'VALIDATION_ERROR', details);
  }
}

// 访问错误
class AuthorizationError extends AppError {
  constructor(message, details) {
    super(message, 'AUTHORIZATION_ERROR', details);
  }
}

// 实体未找到错误
class NotFoundError extends AppError {
  constructor(entity, id, details) {
    super(`${entity} with id ${id} not found`, 'NOT_FOUND_ERROR', details);
    this.entity = entity;
    this.entityId = id;
  }
}
```

### 错误处理标准流程

服务方法的标准错误处理模式:

```javascript
// 标准错误处理流程
async function performServiceOperation() {
  try {
    // 业务逻辑实现...
    return result;
  } catch (error) {
    // 日志记录
    this.logger.error('Operation failed', { 
      error,
      operation: 'performServiceOperation',
      params: '...'
    });
    
    // 错误转换 - 确保返回应用定义的错误类型
    if (error instanceof DatabaseError) {
      throw new SystemError('数据库操作失败', { cause: error });
    }
    
    // 原样传递应用错误
    if (error instanceof AppError) {
      throw error;
    }
    
    // 未知错误转换为系统错误
    throw new SystemError('操作失败', { cause: error });
  }
}
```

### 事务回滚机制

失败操作的回滚实现:

```javascript
// 使用中间状态和回滚
async function processPayment(orderId, paymentData) {
  // 1. 创建支付记录(初始状态: pending)
  const payment = await paymentRepository.create({
    orderId,
    ...paymentData,
    status: 'pending'
  });
  
  try {
    // 2. 调用支付网关
    const gatewayResult = await paymentGateway.process(payment);
    
    // 3. 更新支付记录(成功状态)
    await paymentRepository.update(payment.id, {
      status: 'completed',
      gatewayReference: gatewayResult.reference
    });
    
    // 4. 触发后续流程
    await orderService.updateOrderStatus(orderId, 'paid');
    return { success: true, payment };
  } catch (error) {
    // 5. 回滚 - 更新支付记录为失败状态
    await paymentRepository.update(payment.id, {
      status: 'failed',
      errorMessage: error.message
    });
    
    // 重新抛出带上下文的错误
    throw new PaymentError('支付处理失败', { 
      orderId, 
      paymentId: payment.id,
      cause: error 
    });
  }
}
```

## 监控与可观测性

### 性能监控

服务性能关键指标监控:

```javascript
// 性能监控装饰器
function monitorPerformance(target, name, descriptor) {
  const originalMethod = descriptor.value;
  
  descriptor.value = async function(...args) {
    const startTime = process.hrtime.bigint();
    
    try {
      // 执行原始方法
      const result = await originalMethod.apply(this, args);
      
      // 计算执行时间
      const endTime = process.hrtime.bigint();
      const executionTimeMs = Number(endTime - startTime) / 1_000_000;
      
      // 记录性能指标
      metrics.recordMethodExecution(target.constructor.name, name, executionTimeMs);
      
      // 慢方法警告
      if (executionTimeMs > 500) {
        logger.warn(`Slow method execution: ${target.constructor.name}.${name}`, {
          executionTimeMs,
          args: JSON.stringify(args)
        });
      }
      
      return result;
    } catch (error) {
      // 记录错误指标
      metrics.recordMethodError(target.constructor.name, name);
      throw error;
    }
  };
  
  return descriptor;
}

// 使用装饰器
class UserService {
  @monitorPerformance
  async getUserById(id) {
    // 实现...
  }
}
```

### 健康检查

服务健康状态检查实现:

```javascript
// 健康检查服务
class HealthService {
  constructor(dependencies) {
    this.dependencies = dependencies;
  }
  
  // 综合健康检查
  async checkHealth() {
    const results = {};
    let overallStatus = 'healthy';
    
    // 检查各依赖组件
    for (const [name, service] of Object.entries(this.dependencies)) {
      try {
        const status = await service.checkHealth();
        results[name] = { status: 'up', ...status };
      } catch (error) {
        results[name] = { 
          status: 'down', 
          error: error.message,
          since: new Date()
        };
        overallStatus = 'degraded';
      }
    }
    
    return {
      status: overallStatus,
      timestamp: new Date(),
      services: results
    };
  }
}
```

### 分布式跟踪

请求全链路跟踪:

```javascript
// 跟踪中间件
function traceMiddleware(req, res, next) {
  // 生成或继承跟踪ID
  const traceId = req.headers['x-trace-id'] || generateTraceId();
  const spanId = generateSpanId();
  
  // 设置跟踪上下文
  req.context = {
    traceId,
    spanId,
    startTime: Date.now()
  };
  
  // 注入响应头
  res.setHeader('x-trace-id', traceId);
  
  // 记录请求开始
  logger.info('Request started', {
    traceId,
    spanId,
    method: req.method,
    path: req.path
  });
  
  // 响应完成时记录
  res.on('finish', () => {
    const duration = Date.now() - req.context.startTime;
    logger.info('Request completed', {
      traceId,
      spanId,
      method: req.method,
      path: req.path,
      statusCode: res.statusCode,
      duration
    });
  });
  
  next();
}

// 服务调用跟踪
async function tracedServiceCall(context, serviceName, methodName, callback) {
  const spanId = generateSpanId();
  
  // 记录调用开始
  logger.debug('Service call started', {
    traceId: context.traceId,
    parentSpanId: context.spanId,
    spanId,
    service: serviceName,
    method: methodName
  });
  
  const startTime = Date.now();
  
  try {
    // 执行调用
    const result = await callback();
    
    // 记录调用成功
    const duration = Date.now() - startTime;
    logger.debug('Service call completed', {
      traceId: context.traceId,
      parentSpanId: context.spanId,
      spanId,
      service: serviceName,
      method: methodName,
      duration
    });
    
    return result;
  } catch (error) {
    // 记录调用失败
    const duration = Date.now() - startTime;
    logger.error('Service call failed', {
      traceId: context.traceId,
      parentSpanId: context.spanId,
      spanId,
      service: serviceName,
      method: methodName,
      error: error.message,
      duration
    });
    
    throw error;
  }
}
```

## 与前端和数据库的集成

### 与前端集成

服务层与前端交互规范:

```javascript
// API层调用服务层示例
async function handleUserProfileRequest(req, res) {
  try {
    // 从服务层获取数据
    const userProfile = await userService.getUserProfile(req.params.userId);
    
    // 转换为前端DTO
    const userProfileDTO = userProfileMapper.toDTO(userProfile);
    
    // 返回给前端
    return res.json({
      success: true,
      data: userProfileDTO
    });
  } catch (error) {
    // 错误处理
    return errorHandler.handleApiError(error, req, res);
  }
}
```

### 与数据库集成

服务层通过仓库模式与数据库交互:

```javascript
// 服务层调用仓库层
class NutritionService {
  constructor(nutritionProfileRepository) {
    this.nutritionProfileRepository = nutritionProfileRepository;
  }
  
  async getUserNutritionProfile(userId) {
    // 通过仓库访问数据库
    const profileData = await this.nutritionProfileRepository.findByUserId(userId);
    
    // 数据不存在处理
    if (!profileData) {
      throw new NotFoundError('NutritionProfile', null, { userId });
    }
    
    // 转换为领域对象
    return new NutritionProfileEntity(profileData);
  }
}
```

### 数据映射模式

```javascript
// DTO映射器示例
const userProfileMapper = {
  // 实体到DTO的映射(返回给前端)
  toDTO(entity) {
    return {
      id: entity.id,
      username: entity.username,
      email: entity.email,
      fullName: entity.getFullName(),
      avatarUrl: entity.avatarUrl,
      // 省略敏感字段
    };
  },
  
  // DTO到实体的映射(来自前端)
  toEntity(dto) {
    return new UserEntity({
      id: dto.id,
      username: dto.username,
      email: dto.email,
      firstName: dto.firstName,
      lastName: dto.lastName,
      avatarUrl: dto.avatarUrl
    });
  }
};
```

## 冻结范围

本文档冻结以下内容:

1. **服务层目录结构**: 各业务领域和基础设施服务的目录划分
2. **服务命名规范**: 服务文件命名和方法命名的规范
3. **模块依赖关系**: 各服务模块间的依赖关系和调用方式
4. **领域模型边界**: 各业务领域的服务边界和职责划分
5. **错误处理机制**: 标准错误类型和处理流程
6. **服务通信模式**: 同步和异步通信的标准模式
7. **监控与跟踪接口**: 性能监控和分布式跟踪的标准接口

不包含在冻结范围内:

1. 服务实现的具体业务逻辑
2. 内部方法和私有方法的实现细节
3. 第三方服务集成的具体实现
4. 开发工具服务的实现细节
5. 微优化和非核心性能调整

## 更新与维护指南

1. **添加新方法**:
   - 新方法应遵循现有命名规范和参数风格
   - 保持单一职责原则，避免在一个方法中混合多种业务逻辑
   - 确保错误处理一致性，使用统一的错误封装方式

2. **添加新服务**:
   - 新服务应放置在对应的业务目录下
   - 在 index.js 中注册导出
   - 遵循现有的服务设计模式和代码风格

3. **修改现有服务**:
   - 不应改变基本服务接口和返回结构
   - 不应更改已发布API的参数结构
   - 添加功能时应与现有代码风格保持一致

4. **性能优化**:
   - 服务优化应关注算法效率、缓存策略和数据库查询
   - 复杂查询应通过数据库优化、索引设计提升性能
   - 高频服务应实施缓存策略 

## 变更记录

| 版本 | 日期 | 变更内容 | 负责人 |
|-----|------|---------|-------|
| v1.0.0 | 2025-05-17 | 初始冻结版本 | 服务架构组 |
| v1.1.0 | 2025-06-01 | 添加AI服务集成规范 | AI团队 |
| v1.2.0 | 2025-06-15 | 完善错误处理、监控和集成关系 | 服务架构组 | 