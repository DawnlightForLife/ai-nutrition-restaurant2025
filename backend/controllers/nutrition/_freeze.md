# 营养模块控制器 (nutrition/) - 结构冻结文档

## 模块说明

营养模块负责处理用户营养相关的所有请求，包括营养档案管理、AI推荐、营养计划、饮食偏好设置和收藏管理等功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| nutritionProfileController.js | 创建/更新/获取用户营养档案，健康指标计算 | nutritionProfileService |
| dietaryPreferenceController.js | 管理用户饮食偏好（忌口、素食、口味等） | dietaryPreferenceService |
| aiRecommendationController.js | 发起AI推荐、获取推荐历史、推荐反馈 | aiRecommendationService |
| nutritionPlanController.js | 营养计划制定、计划进度跟踪、计划调整 | nutritionPlanService |
| nutritionistController.js | 营养师资料管理、认证流程、排班管理 | nutritionistService |
| favoriteController.js | 用户收藏/取消收藏功能，收藏列表管理 | favoriteService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- dataSanitizerMiddleware: 数据净化中间件（如BMI计算）
- cacheMiddleware: 响应缓存中间件（用于推荐结果等）
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleNotFound: 处理资源不存在错误
- handleServiceError: 处理第三方AI服务异常

## 数据安全

营养模块处理用户健康数据，实施了以下数据安全措施:
- 敏感数据字段加密
- 权限粒度控制（如营养师只能查看授权用户数据）
- 数据访问审计日志

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。AI推荐接口设计与主流AI模型交互标准兼容，便于后续升级。 