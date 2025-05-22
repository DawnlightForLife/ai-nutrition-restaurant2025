# 咨询模块控制器 (consult/) - 结构冻结文档

## 模块说明

咨询模块负责处理营养师咨询服务相关的所有请求，包括咨询预约、消息交流、问题提交和消息管理等功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| consultationController.js | 咨询预约管理、问题提交、结果查看 | consultationService |
| chatMessageController.js | 咨询消息收发、历史记录查询、未读消息 | messageService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- roleCheckMiddleware: 角色检查中间件（用户/营养师）
- contentFilterMiddleware: 内容过滤中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleNotFound: 处理资源不存在错误
- handlePermissionError: 处理权限不足错误

## 实时通讯支持

咨询模块支持以下实时通讯功能:
- WebSocket消息推送
- 消息状态实时更新（已发送/已读）
- 多端同步
- 状态变更通知

## 内容安全

为保证平台内容安全，咨询模块实施以下内容安全措施:
- 敏感词过滤
- 反垃圾内容识别
- 图片内容审核
- 用户举报机制

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。消息交互符合实时通讯应用标准，支持多种消息类型和状态管理。 