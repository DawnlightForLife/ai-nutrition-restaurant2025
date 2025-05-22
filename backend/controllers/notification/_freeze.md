# 通知模块控制器 (notification/) - 结构冻结文档

## 模块说明

通知模块负责处理消息通知系统相关的所有请求，包括系统消息推送、状态管理、通知设置等功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| notificationController.js | 通知查询、标记已读、删除通知 | notificationService |
| userNotificationStatusController.js | 通知设置管理、订阅偏好、推送渠道 | userNotificationStatusService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- pagingMiddleware: 分页处理中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleNotFound: 处理资源不存在错误

## 通知渠道

通知模块支持以下推送渠道:
- 应用内通知
- 短信通知
- 邮件通知
- 微信消息推送

## 通知分类

系统支持的通知类型包括:
- 系统公告
- 交易通知
- 互动消息
- 活动提醒
- 账户安全

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。通知系统支持多渠道、多类型的消息管理，具备完善的用户个性化设置能力。 