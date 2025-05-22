# 论坛模块控制器 (forum/) - 结构冻结文档

## 模块说明

论坛模块负责处理社区互动系统相关的所有请求，包括帖子管理、评论管理、标签管理和内容审核等功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| forumPostController.js | 帖子发布、编辑、删除、置顶、查询 | forumPostService |
| forumCommentController.js | 评论发布、回复、删除、举报 | forumCommentService |
| forumTagController.js | 标签管理、分类查询、热门标签 | forumTagService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- contentFilterMiddleware: 内容过滤中间件
- rateLimitMiddleware: 频率限制中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleNotFound: 处理资源不存在错误
- handleForbidden: 处理权限不足错误

## 内容管理

论坛模块实施以下内容管理策略:
- 关键词过滤
- 内容审核流程
- 用户举报处理
- 敏感内容自动识别

## 社区功能

论坛模块支持以下社区互动功能:
- 点赞/收藏
- 热门内容推荐
- 标签订阅
- 消息通知

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。社区互动符合现代社区应用标准，具备完善的内容管理和用户互动功能。 