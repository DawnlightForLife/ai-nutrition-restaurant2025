# 核心模块控制器 (core/) - 结构冻结文档

## 模块说明

核心模块负责处理系统核心配置与管理相关的所有请求，包括应用配置、审计日志、系统参数等基础功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| appConfigController.js | 系统配置管理、版本控制、公告发布 | appConfigService |
| auditLogController.js | 操作审计记录、管理员行为跟踪 | auditLogService |

## 依赖中间件

- adminAuthMiddleware: 管理员身份验证中间件
- auditLogMiddleware: 操作审计记录中间件
- cacheMiddleware: 配置缓存中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleNotFound: 处理资源不存在错误
- handlePermissionError: 处理权限不足错误

## 系统配置

系统配置包括以下方面:
- 应用版本信息
- 系统公告
- 功能开关
- 全局参数
- API限流设置

## 审计日志

审计日志记录以下操作:
- 管理员账户操作
- 敏感数据访问
- 系统配置变更
- 权限变更

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。核心模块作为系统基础设施，具备高稳定性和可扩展性。 