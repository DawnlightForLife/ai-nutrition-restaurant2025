# 智能营养餐厅系统 - 路由结构冻结文档

**文档日期**: `2025-05-17`

## 目录
1. [路由系统设计概述](#路由系统设计概述)
2. [目录结构](#目录结构)
3. [模块详情](#模块详情)
4. [冻结范围](#冻结范围)
5. [更新与维护指南](#更新与维护指南)

## 路由系统设计概述

智能营养餐厅系统的路由层采用模块化设计，按业务领域分组。每个路由文件负责特定功能模块的API路径定义，遵循RESTful API设计原则。系统统一通过`index.js`进行挂载和管理。

### 设计原则

1. **模块化路由**: 按业务领域分组，保持结构清晰
2. **统一前缀**: 在主路由文件中统一定义API路径前缀
3. **中间件分层**: 路由级别中间件由路由文件引入，全局中间件在应用入口处理
4. **RESTful设计**: 遵循资源命名和HTTP方法语义
5. **控制器映射**: 路由定义与控制器方法一一对应，职责分明

## 目录结构

```
routes/
├── user/                            # 用户账户系统
├── nutrition/                       # 营养档案与 AI 推荐
├── merchant/                        # 商家系统
├── order/                           # 订单系统（餐品 + 订阅 + 咨询）
├── consult/                         # 营养咨询服务
├── forum/                           # 营养社区模块
├── notification/                    # 系统通知模块
├── feedback/                        # 用户反馈与建议
├── analytics/                       # 数据分析 + 导出
├── security/                        # 安全审计与访问追踪
├── core/                            # 系统设置与配置项
├── common/                          # 通用能力
├── dev/                             # 开发工具接口
└── index.js                         # 主路由注册文件
```

## 模块详情

### 用户账户系统 (user/)

📁 **模块说明**: 负责用户注册、登录、信息管理、权限分配等用户核心功能

📄 **路由文件列表**:
- `authRoutes.js`: 用户登录、注册、令牌验证、密码重置等身份验证功能
- `userRoutes.js`: 用户信息获取与修改、头像更新、个人资料管理
- `oauthRoutes.js`: 第三方登录（微信、Apple、支付宝）功能
- `adminRoutes.js`: 管理员账户操作、用户账户冻结、权限管理
- `permissionRoutes.js`: 权限树结构获取、角色权限配置与查询
- `smsRoutes.js`: 短信验证码发送与校验、防刷限制处理

🔗 **中间件使用**:
- `authMiddleware`: 用于身份验证和令牌校验
- `roleMiddleware`: 用于角色和权限检查
- `rateLimitMiddleware`: 用于短信接口请求频率限制
- `validationMiddleware`: 用于输入参数验证

🎯 **控制器映射**:
- `authController.js`: 处理认证相关逻辑
- `userController.js`: 处理用户信息管理
- `oauthController.js`: 处理第三方登录
- `adminController.js`: 处理管理员功能
- `permissionController.js`: 处理权限管理
- `smsController.js`: 处理短信验证码

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。认证路由结构完整，包含多种登录方式和验证流程。

### 营养档案与 AI 推荐 (nutrition/)

📁 **模块说明**: 用户营养档案管理、AI饮食推荐、营养师服务和收藏管理

📄 **路由文件列表**:
- `nutritionProfileRoutes.js`: 营养档案创建、查询、修改、删除等管理功能
- `dietaryPreferenceRoutes.js`: 用户饮食偏好设置、食材忌口、口味设置
- `aiRecommendationRoutes.js`: AI推荐请求、结果获取、历史记录查询
- `nutritionPlanRoutes.js`: 推荐方案详情获取、方案应用、多日计划管理
- `nutritionistRoutes.js`: 营养师信息展示、详情查询、资格认证
- `favoriteRoutes.js`: 用户收藏功能、收藏列表获取、取消收藏操作

🔗 **中间件使用**:
- `authenticate`: 用于身份验证
- `cacheMiddleware`: 用于缓存常用结果
- `validationMiddleware`: 用于参数验证

🎯 **控制器映射**:
- `nutritionProfileController.js`: 处理营养档案
- `dietaryPreferenceController.js`: 处理饮食偏好
- `aiRecommendationController.js`: 处理AI推荐
- `nutritionPlanController.js`: 处理营养计划
- `nutritionistController.js`: 处理营养师相关
- `favoriteController.js`: 处理收藏功能

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。营养模块是系统核心功能，接口结构完整。

### 商家系统 (merchant/)

📁 **模块说明**: 商家信息管理、门店管理、菜品管理、促销活动配置

📄 **路由文件列表**:
- `merchantRoutes.js`: 商家信息注册、修改、查询、资质审核
- `storeRoutes.js`: 门店信息管理、增删改查、营业状态管理
- `dishRoutes.js`: 菜品管理、上架下架、推荐设置、价格调整
- `merchantStatsRoutes.js`: 商家数据统计、报表生成、经营分析
- `promotionRoutes.js`: 优惠活动配置、优惠券管理、限时促销

🔗 **中间件使用**:
- `auth()`: 身份验证中间件
- `authorize()`: 权限检查中间件
- `uploadMiddleware`: 文件上传中间件

🎯 **控制器映射**:
- `merchantController.js`: 处理商家信息
- `storeController.js`: 处理门店信息
- `dishController.js`: 处理菜品信息
- `merchantStatsController.js`: 处理商家统计
- `promotionController.js`: 处理促销活动

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。商家模块接口清晰完整，支持完整的商家运营流程。

### 订单系统 (order/)

📁 **模块说明**: 菜品订单、营养咨询订单、订阅计划和支付管理

📄 **路由文件列表**:
- `orderRoutes.js`: 菜品订单创建、状态管理、查询等功能
- `subscriptionRoutes.js`: 订阅计划创建、管理、自动续费设置
- `paymentRoutes.js`: 支付处理、退款申请、支付状态回调
- `consultationOrderRoutes.js`: 营养咨询预约、付费订单管理

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `transactionMiddleware`: 事务处理中间件
- `webhookMiddleware`: 支付回调处理中间件

🎯 **控制器映射**:
- `orderController.js`: 处理菜品订单
- `subscriptionController.js`: 处理订阅计划
- `paymentController.js`: 处理支付流程
- `consultationOrderController.js`: 处理咨询订单

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。订单系统支持多种订单类型和支付方式。

### 营养咨询服务 (consult/)

📁 **模块说明**: 营养咨询问题提交、回复管理、聊天记录

📄 **路由文件列表**:
- `consultationRoutes.js`: 咨询问题提交、回复管理、状态跟踪
- `chatMessageRoutes.js`: 聊天消息处理、历史记录查询

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `paginationMiddleware`: 分页处理中间件

🎯 **控制器映射**:
- `consultationController.js`: 处理咨询功能
- `chatMessageController.js`: 处理聊天消息

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。咨询模块支持用户和营养师之间的互动交流。

### 营养社区模块 (forum/)

📁 **模块说明**: 社区论坛、帖子管理、评论互动、标签分类

📄 **路由文件列表**:
- `forumPostRoutes.js`: 帖子发布、编辑、置顶、点赞等功能
- `forumCommentRoutes.js`: 评论发布、回复、点赞、举报等功能
- `forumTagRoutes.js`: 标签管理、热门标签获取、分类查询

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `contentFilterMiddleware`: 内容过滤中间件
- `paginationMiddleware`: 分页处理中间件

🎯 **控制器映射**:
- `forumPostController.js`: 处理帖子功能
- `forumCommentController.js`: 处理评论功能
- `forumTagController.js`: 处理标签功能

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。社区模块提供完整的UGC内容管理功能。

### 系统通知模块 (notification/)

📁 **模块说明**: 系统通知创建、发送、状态管理

📄 **路由文件列表**:
- `notificationRoutes.js`: 创建和推送通知，管理通知内容
- `userNotificationStatusRoutes.js`: 用户获取通知、设置已读状态、通知设置

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `paginationMiddleware`: 分页处理中间件

🎯 **控制器映射**:
- `notificationController.js`: 处理通知功能
- `userNotificationStatusController.js`: 处理用户通知状态

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。通知模块支持多种类型的系统通知。

### 用户反馈与建议 (feedback/)

📁 **模块说明**: 用户意见反馈、问题报告、满意度评价

📄 **路由文件列表**:
- `feedbackRoutes.js`: 提交反馈、查询处理状态、满意度评分

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `uploadMiddleware`: 文件上传中间件

🎯 **控制器映射**:
- `feedbackController.js`: 处理反馈功能

📍 **主路由挂载状态**: 已挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。反馈模块提供简洁的用户反馈渠道。

### 数据分析与导出 (analytics/)

📁 **模块说明**: 用户行为日志、数据分析报表、数据导出

📄 **路由文件列表**:
- `usageLogRoutes.js`: 用户行为记录、访问日志、点击行为跟踪
- `exportTaskRoutes.js`: 数据导出请求、任务进度查询、结果下载

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `adminMiddleware`: 管理员权限检查
- `paginationMiddleware`: 分页处理中间件

🎯 **控制器映射**:
- `usageLogController.js`: 处理用户行为日志
- `exportTaskController.js`: 处理数据导出任务

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。分析模块支持完整的用户行为跟踪和数据导出功能。

### 安全审计与访问追踪 (security/)

📁 **模块说明**: 安全审计、访问日志、异常行为检测

📄 **路由文件列表**:
- `accessTrackRoutes.js`: 接口访问记录、异常行为检测、安全审计

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `adminMiddleware`: 管理员权限检查
- `paginationMiddleware`: 分页处理中间件

🎯 **控制器映射**:
- `accessTrackController.js`: 处理访问追踪功能

📍 **主路由挂载状态**: 已挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。安全模块提供完整的访问审计功能。

### 系统设置与配置项 (core/)

📁 **模块说明**: 系统配置参数、全局设置、审计日志

📄 **路由文件列表**:
- `appConfigRoutes.js`: 系统配置参数获取与修改
- `auditLogRoutes.js`: 管理员操作审计日志查询

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `adminMiddleware`: 管理员权限检查
- `paginationMiddleware`: 分页处理中间件

🎯 **控制器映射**:
- `appConfigController.js`: 处理系统配置
- `auditLogController.js`: 处理审计日志

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。核心模块提供系统配置和管理功能。

### 通用能力 (common/)

📁 **模块说明**: 文件上传、会话管理等通用功能

📄 **路由文件列表**:
- `fileUploadRoutes.js`: 文件上传接口，支持各类资源上传
- `sessionRoutes.js`: 会话管理、登录设备信息获取

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `uploadMiddleware`: 文件上传处理中间件
- `rateLimitMiddleware`: 请求频率限制中间件

🎯 **控制器映射**:
- `fileUploadController.js`: 处理文件上传
- `sessionController.js`: 处理会话管理

📍 **主路由挂载状态**: 已全部挂载到主路由index.js

✅ **状态说明**: 路由结构已冻结，符合分层设计。通用模块提供跨业务的基础能力支持。

### 开发工具接口 (dev/)

📁 **模块说明**: 仅在开发环境使用的工具接口，用于Schema管理和模型热更新

📄 **路由文件列表**:
- `schemaAdminRoutes.js`: Schema管理员操作接口
- `schemaExplorerRoutes.js`: Schema浏览和查询接口
- `schemaVisualizationRoutes.js`: Schema可视化展示接口
- `modelHotUpdateRoutes.js`: 模型热更新接口

🔗 **中间件使用**:
- `authMiddleware`: 身份验证中间件
- `adminMiddleware`: 管理员权限检查
- `devEnvMiddleware`: 开发环境检查中间件

🎯 **控制器映射**:
- 直接在路由中实现或使用专门的开发工具控制器

📍 **主路由挂载状态**: 已挂载到主路由index.js的开发环境条件块中

⚠️ **状态说明**: 开发工具接口，仅在开发环境可用，结构可能随需求变动。

## 冻结范围

本文档冻结以下内容:

1. **路由目录结构**: 各业务领域的路由分组保持稳定
2. **路由命名规范**: 路由文件命名、RESTful路径设计的规范
3. **中间件使用**: 主要中间件的使用方式和顺序
4. **控制器映射**: 路由与控制器之间的映射关系

不包含在冻结范围内:

1. 具体API参数和返回值结构
2. 路由处理中的业务逻辑实现
3. 开发工具路由的具体实现
4. 路由处理的具体错误码和错误消息

## 更新与维护指南

1. **添加新端点**:
   - 新端点应遵循RESTful设计原则
   - 在现有路由文件中添加，保持模块化结构
   - 确保与控制器方法一一对应

2. **添加新路由文件**:
   - 新路由文件应放置在对应的业务目录下
   - 在主路由`index.js`中注册
   - 遵循现有的命名和代码风格

3. **修改现有路由**:
   - 不应更改已发布API的路径和HTTP方法
   - 保持对客户端的向后兼容性
   - 重大变更应通过版本号管理

4. **版本控制**:
   - API重大变更应通过URL前缀或HTTP头指定版本
   - 弃用的端点应标记为deprecated并保留一段支持期 