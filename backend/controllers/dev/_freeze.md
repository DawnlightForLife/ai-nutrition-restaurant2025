# 开发工具模块控制器 (dev/) - 结构冻结文档

## 模块说明

开发工具模块提供系统Schema管理、模型热更新、可视化等开发辅助功能，仅在开发和测试环境启用。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| modelHotUpdateController.js | 模型结构热更新、Schema自动重载 | modelUpdateService |
| schemaAdminController.js | Schema元数据管理、字段增删改、标签维护 | schemaService |
| schemaExplorerController.js | Schema浏览查询、字段结构探索 | schemaService |
| schemaVisualizationController.js | Schema关系可视化、文档生成 | schemaVisualizationService |

## 依赖中间件

- adminAuthMiddleware: 管理员身份验证中间件
- envRestrictMiddleware: 环境限制中间件（仅开发/测试环境可用）
- logMiddleware: 详细操作日志中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleSchemaError: 处理Schema相关错误
- handleEnvironmentError: 处理环境限制错误

## 安全限制

为保证系统稳定性和数据安全，开发工具模块实施以下安全限制:
- 仅开发/测试环境可用，生产环境自动禁用
- 仅超级管理员可访问
- 所有操作记录详细审计日志
- 敏感操作需二次确认

## 状态声明

**开发工具接口，根据需求可能变更**

控制器结构设计合理，但作为开发辅助工具，不对外部应用提供服务，可能随系统内部需求变更。Schema管理工具与当前数据库结构紧密耦合，数据库变更时需同步更新。 