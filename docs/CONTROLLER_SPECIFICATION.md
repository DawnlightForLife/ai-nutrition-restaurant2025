# 🎯 控制器规范说明文档（Controller Specification）

本文档为智慧AI营养餐厅项目后端控制器结构和开发规范的官方冻结文档，确保团队成员在开发时遵循统一规则。

## 📁 控制器目录结构（目录划分）

位于项目根目录 `backend/controllers/` 下，结构如下：

```
controllers/
┣ core/               // 用户、管理员、权限等基础控制器
┣ forum/              // 论坛发帖评论模块
┣ health/             // 健康/营养档案模块
┣ merchant/           // 商家相关操作
┣ misc/               // 通用系统配置、通知等
┣ nutrition/          // 推荐系统与营养师功能
┣ order/              // 订单、咨询、订阅服务
┣ audit/              // 审计日志
```

## 📌 控制器命名规范

| 控制器功能 | 文件命名 |
|------------|----------|
| 登录注册验证 | authController.js |
| 用户管理 | userController.js |
| 管理员管理 | adminController.js |
| 权限控制 | permissionController.js |
| 论坛帖子 | forumPostController.js |
| 论坛评论 | forumCommentController.js |
| 营养档案 | nutritionProfileController.js |
| 健康体检数据 | healthDataController.js |
| 商家基本资料 | merchantController.js |
| 店铺信息 | storeController.js |
| 菜品管理 | dishController.js |
| 商家统计 | merchantStatsController.js |
| 系统通知 | notificationController.js |
| 系统配置 | appConfigController.js |
| AI 推荐记录 | aiRecommendationController.js |
| 营养师资料/审核 | nutritionistController.js |
| 用户收藏 | favoriteController.js |
| 用户订单 | orderController.js |
| 咨询记录 | consultationController.js |
| 订阅服务 | subscriptionController.js |
| 审计操作日志 | auditLogController.js |

## 🧱 控制器函数设计规范

每个控制器应包含以下标准函数：

```javascript
exports.createX = async (req, res) => { ... };
exports.getXList = async (req, res) => { ... };
exports.getXById = async (req, res) => { ... };
exports.updateX = async (req, res) => { ... };
exports.deleteX = async (req, res) => { ... };
```

同时需支持以下通用功能：

* 分页查询（pageSize、pageNumber）
* 关键词搜索（keyword、searchFields）
* 排序（sortBy、sortOrder）
* 筛选（filters）
* 权限校验（通过中间件实现）
* 标准化错误处理
* 请求参数验证

## 🔐 安全规范与中间件要求

1. **权限控制**：所有敏感接口必须接入权限控制中间件
2. **数据隔离**：用户数据读取必须使用用户 ID 过滤
3. **审计日志**：重要操作（如更新档案、删除记录）必须记录审计日志
4. **数据脱敏**：禁止直接暴露密码、手机号、敏感配置等字段给前端
5. **输入验证**：所有用户输入必须经过验证和清洗
6. **CSRF防护**：修改数据的接口必须实施CSRF令牌验证
7. **限流保护**：敏感操作需实施请求频率限制

## 📄 标准响应格式

所有API响应应遵循以下统一格式：

```javascript
// 成功响应
{
  "success": true,
  "data": { ... },  // 或数组
  "message": "操作成功"
}

// 分页响应
{
  "success": true,
  "data": [ ... ],
  "pagination": {
    "total": 100,
    "pageSize": 10,
    "currentPage": 1,
    "totalPages": 10
  },
  "message": "查询成功"
}

// 错误响应
{
  "success": false,
  "error": {
    "code": "AUTH_REQUIRED",
    "message": "需要登录才能访问"
  }
}
```

## 📁 推荐分层架构

控制器应配合以下架构分层使用：

```
controllers/    // 处理HTTP请求/响应，参数验证，调用服务层
services/       // 包含业务逻辑，数据处理，调用模型层
models/         // 数据模型定义及基本CRUD操作
routes/         // API路由定义
middleware/     // 中间件（认证、日志、错误处理等）
utils/          // 工具函数
config/         // 配置文件
```

### 控制器职责

* 接收并验证HTTP请求参数
* 调用相应的service层处理业务逻辑
* 格式化响应数据并返回
* 捕获并处理异常
* 不直接操作数据库或包含复杂业务逻辑

## 🔄 错误处理规范

控制器应统一使用try-catch处理异常，并返回标准化错误响应：

```javascript
exports.getXById = async (req, res) => {
  try {
    const { id } = req.params;
    
    // 参数验证
    if (!id) {
      return res.status(400).json({
        success: false,
        error: {
          code: 'INVALID_PARAMS',
          message: '缺少必要参数'
        }
      });
    }
    
    const data = await xService.getById(id);
    
    // 404处理
    if (!data) {
      return res.status(404).json({
        success: false,
        error: {
          code: 'NOT_FOUND',
          message: '未找到请求的资源'
        }
      });
    }
    
    return res.json({
      success: true,
      data,
      message: '获取成功'
    });
  } catch (err) {
    console.error(`获取资源出错: ${err.message}`, err);
    return res.status(500).json({
      success: false,
      error: {
        code: 'SERVER_ERROR',
        message: '服务器内部错误'
      }
    });
  }
};
```

## 🧪 测试要求

每个控制器应编写对应的单元测试和集成测试，确保：

1. 参数验证逻辑正确
2. 权限控制有效
3. 成功和错误情况处理合理
4. 响应格式符合规范

## 📝 文档示例

每个控制器文件应包含JSDoc风格的注释：

```javascript
/**
 * 用户控制器
 * 处理用户相关HTTP请求，包括用户信息管理
 * @module controllers/core/userController
 */

/**
 * 获取用户信息
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含用户信息的JSON响应
 */
exports.getUserInfo = async (req, res) => {
  // 实现代码
};
```

---

**注意**：本规范为冻结文档，如需修改，请提交变更请求并获得项目负责人审批。 