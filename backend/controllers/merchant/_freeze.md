# 商家模块控制器 (merchant/) - 结构冻结文档

## 模块说明

商家模块负责处理商家相关的所有请求，包括商家注册、门店管理、菜品管理、促销活动和商家统计数据等功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| merchantController.js | 商家注册、资料管理、审核状态、商家分类 | merchantService |
| merchantStatsController.js | 商家数据统计、销售报表、客流分析 | merchantStatsService |
| storeController.js | 门店创建、修改、查询、状态管理 | storeService |
| dishController.js | 菜品管理、上下架、定价、营养信息 | dishService |
| promotionController.js | 促销活动、优惠券、会员折扣管理 | promotionService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- merchantAuthMiddleware: 商家身份验证中间件
- imageProcessMiddleware: 图片处理中间件（用于菜品图片）
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handleNotFound: 处理资源不存在错误
- handleForbidden: 处理权限不足错误

## 业务特性

商家模块支持以下业务特性:
- 多门店统一管理
- 菜品批量导入/导出
- 不同商家类型的差异化功能
- 实时销售数据分析

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。商家管理流程符合行业标准，支持多种商家类型和经营模式。 