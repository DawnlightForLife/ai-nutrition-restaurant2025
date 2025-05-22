# 用户模块控制器 (user/) - 结构冻结文档

## 模块说明

用户模块负责处理用户账户系统相关的所有请求，包括用户注册、登录、资料管理、权限分配等核心功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| userController.js | 用户信息CRUD、个人资料管理、基于角色的差异化信息返回 | userService |
| authController.js | 用户登录、令牌管理、身份验证、自动登录 | authService |
| oauthController.js | 第三方登录（微信、Apple ID等）、账号绑定 | oauthService |
| adminController.js | 管理员账户创建、权限分配、账户冻结 | adminService |
| permissionController.js | 权限树查询、角色权限分配、权限验证 | permissionService |
| smsController.js | 短信验证码发送、校验 | smsService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- permissionMiddleware: 权限检查中间件
- rateLimitMiddleware: 请求频率限制中间件（用于SMS发送）
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleNotFound: 处理用户不存在等错误
- handleUnauthorized: 处理未授权错误

## 响应格式

所有API返回统一的JSON格式:

```javascript
{
  success: true|false,
  message: "操作结果描述",
  data: { ... }  // 实际数据(可选)
}
```

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。用户认证流程符合行业安全标准，包含多种认证方式支持。 