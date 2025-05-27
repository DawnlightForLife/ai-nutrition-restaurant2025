# 智能营养餐厅系统 - 数据库模型冻结文档

**文档日期**: `2025-05-17`  
**最后更新**: `2025-01-26` (v2.0.0 - 元气立方品牌转型)

## 目录
1. [模型设计概述](#模型设计概述)
2. [目录结构](#目录结构)
3. [核心组件](#核心组件)
4. [模型分类](#模型分类)
5. [模型关系图](#模型关系图)
6. [设计限制和约束](#设计限制和约束)
7. [冻结范围](#冻结范围)
8. [更新与维护指南](#更新与维护指南)

## 模型设计概述

智能营养餐厅系统采用 MongoDB 作为主要数据库，使用 Mongoose ODM 进行模型定义和数据处理。系统设计了一套高度可扩展、高性能的数据模型架构，支持读写分离、分片、缓存和批处理等高级特性。

### 设计原则

1. **数据隔离**: 不同业务领域的数据模型通过目录分隔，确保职责单一
2. **高性能**: 支持读写分离和分片，针对不同模型可配置不同的性能优化策略
3. **可扩展性**: 通过工厂模式和注册器模式，支持模型的动态创建和管理
4. **安全性**: 内置数据敏感度分级和访问控制机制
5. **可维护性**: 统一的模型注册和管理接口，简化模型扩展和维护

## 目录结构

```
models/
├── analytics/          # 数据分析相关模型
├── common/             # 通用模型（文件、会话等）
├── consult/            # 咨询服务相关模型
├── core/               # 核心模型（用户、权限等）
├── feedback/           # 用户反馈相关模型
├── forum/              # 论坛相关模型
├── franchise/          # 加盟店相关模型 (新增 v2.0.0)
├── menu/               # 标准菜单相关模型 (新增 v2.0.0)
├── merchant/           # 商家相关模型 (已废弃，保留兼容)
├── notification/       # 通知系统相关模型
├── nutrition/          # 营养相关模型
├── order/              # 订单相关模型
├── promotion/          # 促销相关模型
├── security/           # 安全相关模型
├── user/               # 用户相关模型
├── index.js            # 模型导出入口
├── modelFactory.js     # 模型工厂
└── modelRegistrar.js   # 模型注册器
```

## 核心组件

### 模型工厂 (modelFactory.js)

模型工厂负责创建和管理所有 Mongoose 模型，提供以下核心功能：

1. **读写分离**: 自动根据操作类型选择读或写数据库连接
2. **缓存管理**: 支持模型级别的缓存配置，包括 TTL、缓存键生成等
3. **批处理支持**: 对批量操作提供批处理优化
4. **错误处理**: 提供全面的错误处理和重试机制
5. **连接池管理**: 动态调整连接池大小，优化数据库性能
6. **分片支持**: 对支持分片的模型提供分片键管理

### 模型注册器 (modelRegistrar.js)

模型注册器提供统一的接口用于注册和配置 Mongoose 模型，支持以下功能：

1. **索引管理**: 支持配置普通、复合、部分和地理空间索引
2. **插件应用**: 可配置应用多个 Mongoose 插件
3. **验证选项**: 提供统一的验证选项配置
4. **集合命名**: 支持自定义集合名称
5. **缓存配置**: 支持可缓存模型的配置

## 模型分类

系统模型主要分为以下几类：

### 用户相关模型 (core/, user/)

- **User**: 用户基本信息、认证和角色
- **UserRole**: 用户角色和权限
- **Admin**: 管理员账户
- **OAuthAccount**: 第三方认证账户

### 营养相关模型 (nutrition/)

- **NutritionProfile**: 用户营养档案
- **AiRecommendation**: AI 营养推荐
- **Nutritionist**: 营养师信息
- **UserFavorite**: 用户收藏

### 加盟店相关模型 (franchise/) - v2.0.0 新增

- **FranchiseStore**: 加盟店基本信息
- **StaffManagement**: 员工管理（集成在FranchiseStore中）

### 标准菜单模型 (menu/) - v2.0.0 新增

- **StandardDish**: 标准化菜品信息
- **MenuCategory**: 菜单分类管理

### 商家相关模型 (merchant/) - 已废弃

- **Merchant**: 商家基本信息（已被FranchiseStore替代）
- **MerchantTypes**: 商家类型枚举（已统一为加盟店）
- **Store**: 门店信息（已整合到FranchiseStore）
- **StoreDish**: 门店菜品（已被StandardDish替代）
- **Dish**: 菜品信息（已被StandardDish替代）
- **MerchantStats**: 商家统计数据（已整合到FranchiseStore）

### 订单相关模型 (order/)

- **Order**: 订单信息
- **Subscription**: 订阅计划
- **Payment**: 支付信息

### 其他模型

- **通知系统**: Notification, UserNotificationStatus
- **论坛模块**: ForumPost, ForumComment, ForumTag
- **咨询服务**: Consultation
- **安全模块**: 访问控制相关模型
- **分析模块**: 用户行为和系统性能分析模型

## 模型关系图

主要模型关系如下：

```
User ──────┬───► NutritionProfile ◄──── AiRecommendation
           │
           ├───► Order ◄───── Merchant
           │        │
           │        └───► Dish
           │
           └───► Consultation ◄───── Nutritionist
```

## 设计限制和约束

1. **数据敏感度**:
   - 所有包含敏感信息的字段都应标记 `sensitivityLevel` 属性
   - 敏感级别分为: 1(高度敏感), 2(中度敏感), 3(低度敏感)

2. **分片约束**:
   - 用户相关数据以 userId 作为分片键
   - 商家相关数据以 merchantId 作为分片键
   - 考虑跨分片查询性能问题，应避免过多跨分片操作

3. **缓存策略**:
   - 用户模型: TTL 30分钟
   - 商家模型: TTL 60分钟
   - 菜品模型: TTL 60分钟
   - 订单模型: TTL 5分钟

4. **索引限制**:
   - 每个集合的索引数量应控制在 10 个以内
   - 复合索引字段数量不超过 5 个
   - 文本索引每个集合最多 1 个

## 冻结范围

本文档冻结以下内容:

1. **核心架构**: modelFactory.js, modelRegistrar.js 的核心架构和设计
2. **目录结构**: 各业务领域的模型分类和目录结构
3. **模型关系**: 主要模型之间的依赖和关系
4. **主要模型字段**: 用户、商家、营养、订单等核心模型的主要字段结构

不包含在冻结范围内:

1. 模型的具体实现细节和业务逻辑
2. 非关键字段的增删改
3. 索引配置和优化
4. 缓存策略的调整

## 更新与维护指南

1. **添加新字段**:
   - 非关键字段可直接添加，但需注意字段命名与现有风格保持一致
   - 关键字段添加需提交变更申请，评估对关联模型的影响

2. **添加新模型**:
   - 新模型应放置在对应的业务目录下
   - 使用 modelRegistrar 进行注册
   - 在 index.js 中导出

3. **性能优化**:
   - 索引优化需进行性能测试并记录基准测试结果
   - 缓存策略调整需评估内存占用和命中率

4. **版本控制**:
   - 模型重大变更应更新版本号
   - 变更记录应包含变更原因、影响范围和迁移方案

## 附录：模型目录详细说明

### 用户相关模型 (user/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| userModel | 用户基本信息、认证和个人资料 | phone, password, authType, role, nickname, realName, height, weight, dietaryPreferences | UserRole, NutritionProfile, Order |
| userRoleModel | 用户角色权限配置 | roleName, permissions, accessLevel | User |
| adminModel | 管理员账户 | adminName, permissions, department | User |
| oauthAccountModel | 第三方账号绑定 | provider, providerUserId, accessToken | User |

### 营养相关模型 (nutrition/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| nutritionProfileModel | 用户营养档案 | userId, bmi, dailyCalories, preferences, nutritionGoals | User, AiRecommendation |
| nutritionistModel | 营养师信息 | userId, specialty, certification, experience, clients | User, Consultation |
| aiRecommendationModel | AI营养推荐 | userId, recommendations, mealPlan, ingredients, healthMetrics | NutritionProfile |
| FavoriteModel | 用户收藏 | userId, favoriteType, itemId, addedAt | User, Dish, Merchant |

### 商家相关模型 (merchant/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| merchantModel | 商家基本信息 | name, type, businessLicense, contactInfo, operatingHours | User, Store, MerchantStats |
| merchantTypeEnum | 商家类型枚举 | value, label, description, features | Merchant |
| productDishModel | 菜品信息 | name, price, ingredients, nutritionFacts, allergies, cuisineType | Merchant, Order |
| storeModel | 门店信息 | merchantId, location, managerInfo, capacity | Merchant, StoreDish |
| storeDishModel | 门店特定菜品 | storeId, dishId, availability, price, specialOffers | Store, Dish |
| merchantStatsModel | 商家统计数据 | merchantId, salesData, customerRatings, popularDishes | Merchant, Order |

### 订单相关模型 (order/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| orderModel | 订单信息 | userId, merchantId, items, totalAmount, status, deliveryInfo | User, Merchant, Dish |
| subscriptionModel | 订阅计划 | userId, plan, startDate, endDate, status, paymentInfo | User, Order |
| paymentModel | 支付信息 | orderId, amount, method, status, transactionId | Order |

### 咨询相关模型 (consult/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| consultationModel | 营养咨询会话 | userId, nutritionistId, status, schedule, notes | User, Nutritionist |

### 论坛相关模型 (forum/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| forumPostModel | 论坛帖子 | authorId, title, content, tags, likes | User, ForumComment |
| forumCommentModel | 帖子评论 | postId, authorId, content, parentId | ForumPost, User |
| forumTagModel | 论坛标签 | name, category, postCount | ForumPost |

### 通知相关模型 (notification/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| notificationModel | 系统通知 | userId, type, content, status, actionUrl | User |
| userNotificationStatusModel | 用户通知设置 | userId, channels, preferences, unsubscribed | User |

### 分析相关模型 (analytics/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| usageLogModel | 用户行为日志 | userId, action, route, timestamp, deviceInfo | User |
| exportTaskModel | 数据导出任务 | userId, status, fileUrl, exportType, parameters | User |

### 通用模型 (common/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| fileUploadModel | 文件上传记录 | userId, fileType, fileUrl, size, uploadedAt | User |
| sessionModel | 用户会话 | userId, token, device, expiresAt, lastActivity | User |

### 安全相关模型 (security/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| accessTrackModel | 访问追踪记录 | userId, resource, operation, timestamp, ipAddress | User |

### 核心模型 (core/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| auditLogModel | 审计日志 | userId, action, entityType, entityId, changes | User |
| dataAccessControlModel | 数据访问控制 | role, resource, permissions, conditions | UserRole |
| dbMetricsModel | 数据库性能指标 | operation, collection, duration, slow_query | - |

### 反馈相关模型 (feedback/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| feedbackModel | 用户反馈 | userId, type, content, rating, status | User, Order, Merchant |

### 促销相关模型 (promotion/)

| 模型名称 | 主要功能 | 关键字段 | 关联模型 |
|---------|--------|---------|---------|
| promotionModel | 促销活动 | merchantId, type, discount, startDate, endDate, conditions | Merchant, Order |

---

## 版本更新记录

### v2.0.0 (2025-01-26) - 元气立方品牌转型

#### 重大变更
1. **商家模型重构**
   - 废弃原有的多商家类型模型 (merchant/)
   - 新增统一的加盟店模型 (franchise/franchiseStoreModel.js)
   - 整合门店管理、员工管理功能

2. **用户角色调整**
   - 原角色：user, admin, nutritionist, merchant
   - 新角色：customer, store_manager, store_staff, nutritionist, admin, area_manager, system
   - 用户模型新增：franchiseStoreId, managedStores 字段

3. **菜单标准化**
   - 新增标准菜品模型 (menu/standardDishModel.js)
   - 统一的营养成分结构
   - 标准化的菜品分类体系

4. **认证系统优化**
   - 支持自动注册机制
   - 新增员工认证服务
   - 用户模型新增：profileCompleted, autoRegistered 字段

#### 新增模型

**加盟店模型 (FranchiseStore)**
- 基本信息：storeCode, storeName, managerId
- 加盟信息：franchiseDate, contractDates, franchiseStatus
- 服务配置：supportedServices, targetCustomers
- 员工管理：staff数组
- 运营数据：订单统计、营收数据、评分

**标准菜品模型 (StandardDish)**
- 基本信息：dishCode, dishName, description
- 分类信息：category (main/sub), mealType
- 营养信息：详细营养成分、营养标签
- 制作信息：准备时间、烹饪时间、制作步骤
- 定价信息：成本、基础价格、建议零售价

#### 兼容性说明
- 保留原有角色映射：USER → CUSTOMER, MERCHANT → STORE_MANAGER
- 原商家模型保留但标记为废弃
- API接口保持向后兼容

### v1.0.0 (2025-05-17) - 初始版本
- 建立基础模型架构
- 支持多商家类型平台
- 实现用户、商家、订单、营养等核心模型 