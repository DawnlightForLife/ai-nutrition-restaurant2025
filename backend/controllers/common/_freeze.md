# 通用模块控制器 (common/) - 结构冻结文档

## 模块说明

通用模块负责处理系统通用功能相关的所有请求，包括文件上传、会话管理等跨业务的基础功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| fileUploadController.js | 文件上传、管理、访问控制 | fileService |
| sessionController.js | 会话管理、登录记录查询 | sessionService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- uploadMiddleware: 文件上传处理中间件
- fileSanitizerMiddleware: 文件安全检查中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleFileError: 处理文件相关错误
- handleStorageError: 处理存储服务错误

## 文件上传

文件上传支持以下功能:
- 多种文件类型（图片、文档、媒体）
- 文件大小限制
- 病毒/恶意文件检测
- 图片压缩和裁剪

## 存储策略

系统实施以下存储策略:
- 本地存储
- 云存储（阿里云OSS/腾讯云COS）
- CDN加速
- 文件生命周期管理

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。通用模块作为系统基础设施，为其他业务模块提供稳定可靠的通用服务。 