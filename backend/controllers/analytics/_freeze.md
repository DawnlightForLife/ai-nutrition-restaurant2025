# 分析模块控制器 (analytics/) - 结构冻结文档

## 模块说明

分析模块负责处理数据分析相关的所有请求，包括用户行为日志记录、数据导出、统计分析等功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| usageLogController.js | 用户行为日志记录、查询、分析 | usageLogService |
| exportTaskController.js | 数据导出任务管理、进度跟踪、文件下载 | exportTaskService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- adminAuthMiddleware: 管理员身份验证中间件
- asyncTaskMiddleware: 异步任务处理中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleTaskError: 处理导出任务错误
- handlePermissionError: 处理权限不足错误

## 行为分析

系统支持以下用户行为分析:
- 页面访问统计
- 功能使用频率
- 转化路径分析
- 用户参与度指标

## 数据导出

支持以下数据导出功能:
- 后台数据报表导出
- 用户数据批量导出
- 定时统计报表
- 自定义查询导出

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。分析系统支持多维度的数据收集和分析，同时具备完善的数据导出和异步处理能力。 