# 智能营养餐厅系统 - 控制器模块冻结文档

**文档日期**: `2025-05-17`

## 目录
1. [控制器设计概述](#控制器设计概述)
2. [目录结构](#目录结构)
3. [核心约定](#核心约定)
4. [模块详情](#模块详情)
5. [冻结范围](#冻结范围)
6. [更新与维护指南](#更新与维护指南)

## 控制器设计概述

智能营养餐厅系统采用了模块化的控制器设计，按业务领域进行分组。每个控制器负责特定功能模块的请求处理，遵循单一职责原则。系统整体采用 MVC 架构，控制器作为 C 层处理客户端请求并返回响应。

### 设计原则

1. **职责分离**: 控制器仅负责请求处理与响应生成，业务逻辑封装在 Service 层
2. **统一响应**: 所有API返回统一的响应格式，包含`success`、`message`和`data`字段
3. **错误处理**: 统一使用错误处理工具函数，确保一致的错误响应
4. **代码规范**: 所有控制器方法采用 async/await 异步处理模式
5. **参数验证**: 输入验证逻辑与控制器代码分离，由专门的验证器处理

## 目录结构

```
controllers/
├── user/                            # 用户账户系统（注册、登录、权限等）
├── nutrition/                       # 用户营养相关（档案、推荐、收藏）
├── merchant/                        # 商家与门店、菜品管理
├── order/                           # 点餐、订阅与支付系统
├── dev/                             # 开发工具接口（Schema管理等）
├── consult/                         # 营养师咨询服务（预约、消息）
├── forum/                           # 社区互动系统（帖子、评论）
├── feedback/                        # 用户意见反馈系统
├── notification/                    # 消息通知模块
├── analytics/                       # 后台数据分析、导出任务
├── core/                            # 系统核心配置与管理
├── security/                        # 安全与访问追踪模块
├── common/                          # 通用模块接口
└── index.js                         # 统一导出所有controller
```

## 核心约定

### 命名规范

- 控制器文件名: `xxxController.js` (camelCase)
- 控制器方法名: `createResource`, `getResourceById`, `updateResource`, `deleteResource` 等 (camelCase)
- 控制器导出: 使用 `exports.methodName` 导出方法

### 错误处理

所有控制器共用以下错误处理函数:
- `handleError`: 处理一般性错误
- `handleValidationError`: 处理验证错误
- `handleNotFound`: 处理资源不存在错误
- `handleUnauthorized`: 处理未授权错误

### 响应格式

所有API返回统一的JSON格式:

```javascript
{
  success: true|false,  // 请求是否成功
  message: "操作结果描述",  // 用户友好的消息
  data: { ... }  // 实际数据 (可选)
}
```

### 代码结构

控制器方法的标准结构:

```javascript
exports.methodName = async (req, res) => {
  try {
    // 1. 提取参数
    // 2. 参数验证
    // 3. 调用服务层方法
    // 4. 返回格式化响应
    
    res.status(200).json({
      success: true,
      message: '操作成功',
      data: result
    });
  } catch (error) {
    handleError(res, error);
  }
};
```

## 模块详情

### 用户模块 (user/)

| 控制器 | 主要功能 | 服务依赖 |
|-------|----------|----------|
| userController | 用户CRUD、信息管理 | userService |
| authController | 登录、未注册自动注册、令牌验证 | authService |
| oauthController | 第三方登录集成 | oauthService |
| adminController | 管理员账户管理 | adminService |
| permissionController | 权限管理 | permissionService |
| smsController | 验证码发送与校验 | smsService |

**状态**: 接口结构已稳定，控制器分层设计合理，可长期维护

### 营养模块 (nutrition/)

| 控制器 | 主要功能 | 服务依赖 |
|-------|----------|----------|
| nutritionProfileController | 用户营养档案管理 | nutritionProfileService |
| dietaryPreferenceController | 饮食偏好管理 | dietaryPreferenceService |
| aiRecommendationController | AI推荐管理 | aiRecommendationService |
| nutritionPlanController | 营养计划管理 | nutritionPlanService |
| nutritionistController | 营养师资料管理 | nutritionistService |
| favoriteController | 收藏管理 | favoriteService |

**状态**: 接口结构已稳定，控制器分层设计合理，可长期维护

### 商家模块 (merchant/)

| 控制器 | 主要功能 | 服务依赖 |
|-------|----------|----------|
| merchantController | 商家账户管理 | merchantService |
| merchantStatsController | 商家数据统计 | merchantStatsService |
| storeController | 门店管理 | storeService |
| dishController | 菜品管理 | dishService |
| promotionController | 优惠活动管理 | promotionService |

**状态**: 接口结构已稳定，控制器分层设计合理，可长期维护

### 订单模块 (order/)

| 控制器 | 主要功能 | 服务依赖 |
|-------|----------|----------|
| orderController | 普通订单管理 | orderService |
| subscriptionController | 订阅计划管理 | subscriptionService |
| paymentController | 支付处理 | paymentService |
| consultationOrderController | 咨询订单管理 | consultationOrderService |

**状态**: 接口结构已稳定，控制器分层设计合理，可长期维护

### 开发工具模块 (dev/)

| 控制器 | 主要功能 | 服务依赖 |
|-------|----------|----------|
| modelHotUpdateController | 模型热更新 | modelUpdateService |
| schemaAdminController | Schema元数据管理 | schemaService |
| schemaExplorerController | Schema浏览 | schemaService |
| schemaVisualizationController | Schema可视化 | schemaVisualizationService |

**状态**: 开发工具接口，可能随需求变动

### 其他模块

| 模块 | 主要控制器 | 状态 |
|------|------------|------|
| consult/ | consultationController, chatMessageController | 接口结构已稳定 |
| forum/ | forumPostController, forumCommentController, forumTagController | 接口结构已稳定 |
| feedback/ | feedbackController | 接口结构已稳定 |
| notification/ | notificationController, userNotificationStatusController | 接口结构已稳定 |
| analytics/ | usageLogController, exportTaskController | 接口结构已稳定 |
| core/ | appConfigController, auditLogController | 接口结构已稳定 |
| security/ | accessTrackController | 接口结构已稳定 |
| common/ | fileUploadController, sessionController | 接口结构已稳定 |

## 冻结范围

本文档冻结以下内容:

1. **控制器目录结构**: 各业务领域的控制器分组保持稳定
2. **命名规范**: 控制器命名、方法命名的规范
3. **响应格式**: API统一返回格式
4. **错误处理**: 错误处理策略和工具函数的使用

不包含在冻结范围内:

1. 控制器实现的具体业务逻辑
2. 内部方法和私有方法的实现细节
3. 控制器返回的具体数据结构
4. 开发工具模块的实现细节

## 更新与维护指南

1. **添加新方法**:
   - 新方法应遵循现有命名规范和错误处理模式
   - 使用 async/await 处理异步逻辑
   - 保持单一职责原则，避免在控制器中编写复杂业务逻辑

2. **添加新控制器**:
   - 新控制器应放置在对应的业务目录下
   - 在 index.js 中注册导出
   - 遵循现有的命名和代码风格

3. **修改现有控制器**:
   - 不应改变基本响应格式和错误处理模式
   - 不应更改已发布API的参数和返回结构
   - 添加功能时应与现有代码风格保持一致

4. **版本控制**:
   - API变更应通过版本号管理
   - 重大变更应提供向下兼容支持
   - 弃用的方法应标记为 deprecated 并保留支持期 