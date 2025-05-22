# 订单模块控制器 (order/) - 结构冻结文档

## 模块说明

订单模块负责处理点餐、订阅与支付系统相关的所有请求，包括订单创建、支付处理、订阅管理和咨询订单等功能。

## 控制器列表

| 控制器 | 主要职责 | 依赖服务 |
|--------|---------|----------|
| orderController.js | 普通订单创建、查询、状态更新、取消 | orderService |
| subscriptionController.js | 订阅计划管理、续订、升降级、暂停 | subscriptionService |
| paymentController.js | 支付发起、回调处理、退款、账单 | paymentService |
| consultationOrderController.js | 营养咨询预约、支付、取消、评价 | consultationOrderService |

## 依赖中间件

- authMiddleware: 身份验证中间件
- transactionMiddleware: 事务处理中间件
- paymentSecurityMiddleware: 支付安全验证中间件
- validationMiddleware: 输入参数验证中间件

## 错误处理

所有控制器统一使用以下错误处理函数:
- handleError: 处理一般性错误
- handleValidationError: 处理验证错误
- handlePaymentError: 处理支付相关错误
- handleNotFound: 处理订单不存在等错误

## 支付集成

订单模块支持以下支付方式:
- 微信支付
- 支付宝
- 银联
- 储值卡支付

支付流程遵循行业标准安全协议，包括签名验证、通知重试、幂等性保证等机制。

## 数据一致性

订单模块实现了以下数据一致性保障:
- 事务控制
- 分布式锁
- 状态机流转控制
- 异步通知重试

## 状态声明

**接口结构冻结，API已稳定**

控制器结构已符合分层设计，职责明确，可长期维护。订单流程符合电商行业标准，支持多种支付方式和订阅模式。 