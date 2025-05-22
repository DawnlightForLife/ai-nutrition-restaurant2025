# 安全模块控制器 (security/) - 结构冻结文档

## 模块说明

安全模块负责处理系统安全与访问追踪相关的所有请求，包括访问日志记录、异常监控、黑名单管理等安全功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| accessTrackController.js | 接口访问日志、异常IP识别、黑名单管理 | accessTrackService |

## 依赖中间件

- adminAuthMiddleware: 管理员身份验证中间件
- riskControlMiddleware: 风险控制中间件
- ipRestrictionMiddleware: IP限制中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleSecurityError: 处理安全相关错误
- handlePermissionError: 处理权限不足错误

## 安全策略

系统实施以下安全策略:
- 异常访问监控与告警
- IP黑名单管理
- 接口访问频率控制
- 可疑行为识别

## 访问追踪

系统记录以下访问信息:
- 接口调用记录
- 用户登录历史
- 敏感操作日志
- IP访问统计

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。安全模块遵循行业最佳实践，为系统提供全面的安全防护能力。 