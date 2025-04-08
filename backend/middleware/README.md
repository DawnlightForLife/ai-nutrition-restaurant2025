# Middleware 中间件目录结构（已冻结）

本目录包含项目全部中间件，已按功能分类如下：

- `auth/`：身份验证相关
  - `authMiddleware.js`：身份认证中间件，用于验证JWT令牌
  - `permissionMiddleware.js`：权限控制中间件，用于验证用户权限
  - `roleMiddleware.js`：角色验证中间件，用于验证用户角色

- `security/`：安全控制策略
  - `securityMiddleware.js`：基本安全中间件，提供XSS防护、MongoDB注入防护等
  - `advancedSecurityMiddleware.js`：高级安全中间件，提供JWT处理、请求签名验证等
  - `rateLimitMiddleware.js`：基本速率限制中间件，限制请求频率
  - `advancedRateLimitMiddleware.js`：高级速率限制中间件，提供基于角色/路径的限制

- `performance/`：性能优化控制
  - `performanceMiddleware.js`：基本性能中间件，提供HTTP压缩、请求计时等
  - `advancedPerformanceMiddleware.js`：高级性能监控中间件，监控系统资源使用
  - `cacheOptimizationMiddleware.js`：缓存优化中间件，优化Redis缓存使用
  - `dbOptimizationMiddleware.js`：数据库优化中间件，优化查询性能

- `validation/`：参数校验相关
  - `requestValidationMiddleware.js`：请求验证中间件，验证请求体、查询参数等
  - `validationMiddleware.js`：基本数据验证中间件，提供Joi验证功能
  - `schemaValidationMiddleware.js`：Schema验证中间件，验证MongoDB Schema

- `core/`：核心中间件
  - `loggingMiddleware.js`：日志中间件，记录请求、错误、性能等日志
  - `cacheMiddleware.js`：缓存中间件，提供基本的Redis缓存功能
  - `errorHandlingMiddleware.js`：错误处理中间件，统一处理各种错误

## 结构冻结说明

中间件结构已于2025-04-08冻结，标记文件：`.structure-frozen`。这意味着：

1. 中间件目录结构不应随意更改
2. 文件命名应遵循现有规范
3. 新功能应在现有结构基础上进行扩展

## 使用指南

# 中间件使用指南

本文档提供了关于如何在项目中正确使用中间件的指导。

## 正确的导入路径

请使用相对路径导入中间件，从使用中间件的文件位置开始计算路径：

```javascript
// 在controllers中使用中间件
const authMiddleware = require('../../middleware/auth/authMiddleware');
const errorMiddleware = require('../../middleware/error/errorHandler');
const validationMiddleware = require('../../middleware/validation/requestValidator');
const performanceMiddleware = require('../../middleware/performance/rateLimiter');
const securityMiddleware = require('../../middleware/security/xssProtection');

// 在路由文件中使用中间件
const authMiddleware = require('../middleware/auth/authMiddleware');
const errorMiddleware = require('../middleware/error/errorHandler');
```

## 中间件执行顺序

中间件按照添加的顺序执行，因此请注意以下推荐的顺序：

1. 安全性相关中间件（例如：CORS, helmet）
2. 请求解析中间件（例如：body-parser）
3. 认证中间件
4. 业务逻辑中间件
5. 错误处理中间件（通常放在最后）

## 中间件组织

中间件按功能分组到不同目录中：

```
middleware/
  ├── auth/           - 认证和授权相关
  ├── error/          - 错误处理
  ├── validation/     - 请求验证
  ├── performance/    - 性能优化
  ├── security/       - 安全相关
  └── logging/        - 日志记录
```

## 修改现有中间件

修改现有中间件时，请确保：

1. 维护API兼容性，不要改变现有的接口
2. 更新测试以确保功能正常
3. 在更改可能影响其他部分的中间件前先与团队讨论

## 添加新中间件

添加新中间件时，请遵循以下规则：

1. 将中间件放在正确的目录中
2. 使用一致的命名约定（例如：`featureMiddleware.js`）
3. 提供足够的文档和注释
4. 包含适当的错误处理
5. 在引入新中间件后更新相关测试

## 结构冻结通知

注意：自2025-04-08起，中间件的目录结构已被冻结。新的中间件应放在现有目录中，不应创建新的顶级目录。这有助于维护项目的一致性和可预测性。

## 注意事项

- 不同中间件之间可能存在依赖关系，修改时需谨慎
- 必要时应进行性能测试，确保中间件不会对系统性能造成显著影响
- 在路由中应合理组织中间件执行顺序，通常建议顺序为：
  1. 日志记录
  2. 安全控制
  3. 身份验证
  4. 请求验证
  5. 业务逻辑
- 中间件路径应始终使用相对路径（使用 `../../middleware/` 而非 `../middleware/`），确保在项目结构调整后依然可用 