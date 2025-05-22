# 领域驱动设计架构说明

**版本:** 1.0  
**状态:** 正式发布  
**更新日期:** 2025-05-25  
**编制人:** 系统架构组

## 📑 目录

- [1. 概述](#1-概述)
- [2. 架构分层](#2-架构分层)
- [3. 核心领域](#3-核心领域)
- [4. 实现细节](#4-实现细节)
- [5. 代码示例](#5-代码示例)
- [6. 最佳实践](#6-最佳实践)

## 1. 概述

智能营养餐厅系统采用领域驱动设计(DDD)架构，将核心业务逻辑封装进领域实体和值对象，从而降低系统复杂性、提高代码可维护性，并更好地反映业务逻辑和规则。本文档介绍系统的DDD架构实现方式和关键概念。

### 1.1 背景与目标

随着系统业务逻辑日益复杂，传统的分层架构难以有效管理业务规则和数据流。领域驱动设计通过将业务领域知识显式建模，实现以下目标：

- 降低领域复杂性，提高代码可理解性
- 确保业务规则在领域模型中得到正确实施
- 分离技术复杂性和业务复杂性
- 提高代码的可测试性和可维护性
- 促进技术团队和业务团队的沟通

## 2. 架构分层

系统架构分为四个核心层：

### 2.1 领域层 (Domain Layer)

领域层是DDD的核心，包含业务领域概念的实现：

- **实体(Entities)**: 具有唯一标识的业务对象
- **值对象(Value Objects)**: 没有唯一标识的不可变对象
- **领域服务(Domain Services)**: 处理跨实体的业务逻辑
- **仓储接口(Repository Interfaces)**: 定义持久化操作的抽象接口

**位置**: `/backend/domain/{domain_name}/{entities|value_objects|services|repositories}`

### 2.2 应用层 (Application Layer)

应用层负责协调领域对象完成具体的业务用例：

- **应用服务(Application Services)**: 编排领域对象实现业务用例
- **DTO(Data Transfer Objects)**: 跨层数据传输对象

**位置**: `/backend/application/{domain_name}/services`

### 2.3 基础设施层 (Infrastructure Layer)

基础设施层提供技术能力支持：

- **仓储实现(Repository Implementations)**: 实现领域层定义的仓储接口
- **外部服务集成(External Service Integration)**: 与外部系统交互

**位置**: `/backend/infrastructure/{repositories|external_services}`

### 2.4 接口层 (Interface Layer)

接口层处理用户交互：

- **控制器(Controllers)**: 处理HTTP请求
- **中间件(Middlewares)**: 请求预处理和后处理

**位置**: `/backend/controllers` 和 `/backend/middleware`

## 3. 核心领域

系统包含以下核心领域模型：

### 3.1 营养(Nutrition)领域

管理食品营养信息和用户营养需求。

**关键概念**:
- 餐品(Meal): 代表提供给用户的食品
- 营养信息(NutritionInfo): 包含食品的营养成分详情
- 营养计划(NutritionPlan): 用户个性化的饮食计划

### 3.2 订单(Order)领域

处理用户订单的生命周期。

**关键概念**:
- 订单(Order): 用户的餐食订购请求
- 订单项(OrderItem): 订单中的单个餐品
- 订单状态(OrderStatus): 订单的当前处理阶段

### 3.3 用户(User)领域

管理用户信息和身份验证。

**关键概念**:
- 用户(User): 系统用户信息
- 用户角色(Role): 用户的权限级别
- 用户偏好(Preference): 用户的饮食偏好和设置

### 3.4 餐厅(Restaurant)领域

管理餐厅信息和菜品。

**关键概念**:
- 餐厅(Restaurant): 提供餐品的门店信息
- 菜单(Menu): 餐厅提供的食品列表
- 分类(Category): 餐品的分类信息

## 4. 实现细节

### 4.1 领域层核心组件

领域层包含以下核心组件：

- **实体基类(Entity)**: 所有领域实体的基类，提供ID和相等性比较
- **值对象基础设施**: 实现不可变值对象的共同特性
- **仓储接口**: 定义领域模型的持久化操作
- **领域服务**: 实现跨实体的业务逻辑

### 4.2 应用层实现方式

应用服务作为用例的协调者，负责：

- 从请求中提取数据
- 创建或加载所需的领域对象
- 调用领域对象的方法执行业务逻辑
- 保存变更
- 返回结果

### 4.3 基础设施层实现

基础设施层包含：

- **MongoDB仓储实现**: 将领域模型映射到MongoDB数据模型
- **外部服务适配器**: 集成第三方API和服务

## 5. 代码示例

### 5.1 实体示例(餐品实体)

```javascript
class Meal extends Entity {
  constructor(
    id,
    name,
    description,
    price,
    imageUrls,
    categoryId,
    nutritionInfo,
    isFeatured = false,
    isRecommended = false,
    tags = [],
    rating = 0.0,
    reviewCount = 0,
    createdAt = new Date(),
    updatedAt = new Date()
  ) {
    super(id);
    // 初始化属性和验证
  }
  
  // 领域行为
  addRating(newRating) {
    // 业务逻辑实现
    return new Meal(/* 更新后的属性 */);
  }
}
```

### 5.2 应用服务示例

```javascript
class MealService {
  constructor({ mealRepository }) {
    this._mealRepository = mealRepository;
  }

  async createMeal(mealData) {
    // 创建值对象
    const nutritionInfo = new MealNutritionInfo(/* 参数 */);
    
    // 创建实体
    const meal = Meal.create(/* 参数 */);
    
    // 保存实体
    const savedMeal = await this._mealRepository.save(meal);
    
    // 返回DTO
    return savedMeal.toJSON();
  }
}
```

### 5.3 基础设施示例(MongoDB仓储)

```javascript
class MongoDBMealRepository extends MealRepository {
  constructor({ mealModel }) {
    super();
    this._mealModel = mealModel;
  }

  async save(meal) {
    const persistenceData = this._toPersistence(meal);
    
    const result = await this._mealModel.findByIdAndUpdate(
      persistenceData._id,
      persistenceData,
      { new: true, upsert: true }
    );
    
    return this._toDomainEntity(result);
  }
}
```

## 6. 最佳实践

### 6.1 开发指南

- 保持领域模型的纯粹性，不混入基础设施代码
- 使用不可变对象实现值对象
- 确保实体方法返回新的实体实例而非修改当前实例
- 在领域层实现所有业务规则和约束
- 使用工厂方法创建复杂的领域对象

### 6.2 测试策略

- 领域层：单元测试，无外部依赖
- 应用层：集成测试，模拟仓储
- 基础设施层：与数据库的集成测试

### 6.3 扩展建议

- 新增领域概念应先在领域层定义
- 扩展现有领域模型时保持向后兼容
- 考虑使用事件溯源记录领域事件 