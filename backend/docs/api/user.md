# 用户管理 API

## 概述

用户管理 API 提供用户注册、登录、个人资料管理以及相关功能的接口。

## 认证相关

### 用户注册

```http
POST /api/v1/auth/register
```

**请求体：**
```json
{
  "phone": "13800138000",
  "password": "password123",
  "confirmPassword": "password123",
  "name": "张三",
  "email": "zhangsan@example.com",
  "verificationCode": "123456"
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_id",
      "phone": "13800138000",
      "name": "张三",
      "email": "zhangsan@example.com"
    },
    "token": "jwt_token_here"
  }
}
```

### 用户登录

```http
POST /api/v1/auth/login
```

**请求体：**
```json
{
  "phone": "13800138000",
  "password": "password123"
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_id",
      "phone": "13800138000",
      "name": "张三"
    },
    "token": "jwt_token_here"
  }
}
```

### 发送验证码

```http
POST /api/v1/sms/send-verification
```

**请求体：**
```json
{
  "phone": "13800138000",
  "type": "register"
}
```

## 用户资料管理

### 获取个人资料

```http
GET /api/v1/users/profile
Authorization: Bearer {token}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "user_id",
    "phone": "13800138000",
    "name": "张三",
    "email": "zhangsan@example.com",
    "avatar": "https://example.com/avatar.jpg",
    "gender": "male",
    "birthday": "1990-01-01",
    "bio": "这是个人简介"
  }
}
```

### 更新个人资料

```http
PUT /api/v1/users/profile
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "name": "张三",
  "email": "zhangsan@example.com",
  "avatar": "https://example.com/avatar.jpg",
  "gender": "male",
  "birthday": "1990-01-01",
  "bio": "这是个人简介"
}
```

### 修改密码

```http
PUT /api/v1/users/change-password
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "oldPassword": "old_password",
  "newPassword": "new_password",
  "confirmPassword": "new_password"
}
```

## 访客档案管理

### 创建访客档案

```http
POST /api/v1/guest-profiles
```

**请求体：**
```json
{
  "profileData": {
    "height": 170,
    "weight": 65,
    "age": 30,
    "gender": "male",
    "activityLevel": "moderate",
    "dietaryRestrictions": ["vegetarian"],
    "allergies": ["nuts"]
  }
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "guestId": "guest_123456",
    "bindingToken": "token_for_binding",
    "profileData": {
      "height": 170,
      "weight": 65,
      "age": 30,
      "gender": "male",
      "activityLevel": "moderate",
      "dietaryRestrictions": ["vegetarian"],
      "allergies": ["nuts"]
    },
    "nutritionNeeds": {
      "calories": 2200,
      "protein": 110,
      "carbs": 275,
      "fat": 73
    }
  }
}
```

### 获取访客档案

```http
GET /api/v1/guest-profiles/{guestId}
```

### 绑定访客档案到用户

```http
POST /api/v1/guest-profiles/bind
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "bindingToken": "token_for_binding"
}
```

## 积分管理

### 获取用户积分

```http
GET /api/v1/points/balance
Authorization: Bearer {token}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "balance": 1500,
    "level": "silver",
    "nextLevel": "gold",
    "pointsToNextLevel": 500
  }
}
```

### 获取积分历史

```http
GET /api/v1/points/history
Authorization: Bearer {token}
```

**查询参数：**
- `page` (可选): 页码，默认 1
- `limit` (可选): 每页数量，默认 20
- `type` (可选): 交易类型 (earn, redeem, expire, adjust)

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": "transaction_id",
      "type": "earn",
      "points": 100,
      "reason": "完成订单",
      "orderId": "order_123",
      "createdAt": "2025-06-04T10:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 50,
    "pages": 3
  }
}
```

### 积分兑换

```http
POST /api/v1/points/redeem
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "points": 500,
  "rewardType": "discount",
  "rewardValue": 50
}
```

### 获取积分排行榜

```http
GET /api/v1/points/leaderboard
```

**查询参数：**
- `period` (可选): 时间范围 (weekly, monthly, all_time)
- `limit` (可选): 返回数量，默认 10

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "rank": 1,
      "userId": "user_id",
      "userName": "张三",
      "avatar": "https://example.com/avatar.jpg",
      "points": 5000
    }
  ]
}
```

## 积分规则管理

### 获取积分规则列表

```http
GET /api/v1/points/rules
Authorization: Bearer {token}
```

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": "rule_id",
      "name": "订单消费积分",
      "type": "earn",
      "action": "order",
      "points": 10,
      "conditions": {
        "minAmount": 50
      },
      "isActive": true
    }
  ]
}
```

### 创建积分规则（管理员）

```http
POST /api/v1/points/rules
Authorization: Bearer {admin_token}
```

**请求体：**
```json
{
  "name": "订单消费积分",
  "type": "earn",
  "action": "order",
  "points": 10,
  "conditions": {
    "minAmount": 50,
    "maxAmount": 1000
  },
  "validFrom": "2025-06-01T00:00:00Z",
  "validTo": "2025-12-31T23:59:59Z",
  "isActive": true,
  "priority": 1
}
```

## 错误响应

所有 API 在出错时都会返回以下格式的错误响应：

```json
{
  "success": false,
  "error": "ErrorType",
  "message": "错误描述",
  "errors": [
    {
      "field": "phone",
      "message": "手机号格式不正确"
    }
  ]
}
```

### 常见错误码

- `ValidationError`: 请求参数验证失败
- `AuthenticationError`: 认证失败（未登录或 token 无效）
- `AuthorizationError`: 权限不足
- `NotFoundError`: 资源不存在
- `ConflictError`: 资源冲突（如用户已存在）
- `RateLimitError`: 请求频率限制

## 状态码

- `200`: 成功
- `201`: 创建成功
- `400`: 请求参数错误
- `401`: 未认证
- `403`: 权限不足
- `404`: 资源不存在
- `409`: 资源冲突
- `429`: 请求频率限制
- `500`: 服务器内部错误