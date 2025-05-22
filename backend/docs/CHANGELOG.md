# 变更日志

本文档记录系统架构、API和模型的重要变更。

## 2025-05-25

### 架构变更

- **添加**: 引入领域驱动设计(DDD)架构
  - 创建领域层，包含实体、值对象、仓储接口和领域服务
  - 创建应用层，包含应用服务
  - 创建基础设施层，包含仓储实现
  - 添加新的架构文档 `subsystems/domain-driven-design.md`

### 核心领域模型

- **添加**: 营养(Nutrition)领域模型
  - 餐品(Meal)实体
  - 餐品营养信息(MealNutritionInfo)值对象
  - 餐品仓储(MealRepository)接口

- **添加**: 订单(Order)领域模型
  - 订单(Order)实体
  - 订单项(OrderItem)值对象
  - 订单状态(OrderStatus)值对象

### 应用服务

- **添加**: 餐品应用服务(MealService)
  - 创建餐品功能
  - 更新餐品功能
  - 获取推荐餐品功能
  - 营养筛选餐品功能

### 基础设施

- **添加**: MongoDB餐品仓储实现(MongoDBMealRepository)
  - 实现餐品的CRUD操作
  - 实现餐品的高级查询功能
