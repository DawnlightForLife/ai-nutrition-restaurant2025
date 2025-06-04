# 订单管理 API

## 概述

订单管理 API 提供订单创建、查询、更新以及取餐码管理的接口。

## 订单管理

### 创建订单

```http
POST /api/v1/orders
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "restaurantId": "restaurant_id",
  "branchId": "branch_id",
  "orderType": "dine_in",
  "tableId": "table_id",
  "items": [
    {
      "dishId": "dish_id",
      "quantity": 2,
      "price": 28.00,
      "specialInstructions": "不要辣"
    }
  ],
  "deliveryInfo": {
    "address": {
      "province": "广东省",
      "city": "深圳市",
      "district": "南山区",
      "street": "科技园",
      "detail": "腾讯大厦1楼",
      "postalCode": "518000"
    },
    "contactName": "张三",
    "contactPhone": "13800138000",
    "deliveryTime": "2025-06-04T12:00:00Z",
    "deliveryInstructions": "请打电话"
  },
  "paymentMethod": "alipay",
  "couponCode": "SAVE10",
  "remarks": "请尽快配送"
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "order_id",
    "orderNumber": "ORD20250604001",
    "restaurantId": "restaurant_id",
    "branchId": "branch_id",
    "userId": "user_id",
    "orderType": "dine_in",
    "status": "pending",
    "paymentStatus": "pending",
    "items": [
      {
        "dishId": "dish_id",
        "dishName": "宫保鸡丁",
        "quantity": 2,
        "price": 28.00,
        "subtotal": 56.00,
        "specialInstructions": "不要辣"
      }
    ],
    "amount": {
      "subtotal": 56.00,
      "discount": 5.60,
      "deliveryFee": 3.00,
      "total": 53.40
    },
    "estimatedTime": 30,
    "createdAt": "2025-06-04T10:00:00Z"
  }
}
```

### 获取订单列表

```http
GET /api/v1/orders
Authorization: Bearer {token}
```

**查询参数：**
- `page` (可选): 页码，默认 1
- `limit` (可选): 每页数量，默认 20
- `status` (可选): 订单状态
- `orderType` (可选): 订单类型
- `startDate` (可选): 开始日期
- `endDate` (可选): 结束日期

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": "order_id",
      "orderNumber": "ORD20250604001",
      "restaurantName": "美味餐厅",
      "branchName": "南山店",
      "orderType": "dine_in",
      "status": "completed",
      "paymentStatus": "paid",
      "total": 53.40,
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

### 获取订单详情

```http
GET /api/v1/orders/{orderId}
Authorization: Bearer {token}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "order_id",
    "orderNumber": "ORD20250604001",
    "restaurant": {
      "id": "restaurant_id",
      "name": "美味餐厅",
      "logo": "https://example.com/logo.jpg"
    },
    "branch": {
      "id": "branch_id",
      "name": "南山店",
      "address": "深圳市南山区科技园",
      "phone": "0755-12345678"
    },
    "user": {
      "id": "user_id",
      "name": "张三",
      "phone": "13800138000"
    },
    "orderType": "dine_in",
    "status": "completed",
    "paymentStatus": "paid",
    "items": [
      {
        "dishId": "dish_id",
        "dishName": "宫保鸡丁",
        "dishImage": "https://example.com/dish.jpg",
        "quantity": 2,
        "price": 28.00,
        "subtotal": 56.00,
        "specialInstructions": "不要辣"
      }
    ],
    "amount": {
      "subtotal": 56.00,
      "discount": 5.60,
      "deliveryFee": 3.00,
      "tax": 0.00,
      "total": 53.40
    },
    "timeline": [
      {
        "status": "pending",
        "time": "2025-06-04T10:00:00Z",
        "note": "订单已创建"
      },
      {
        "status": "confirmed",
        "time": "2025-06-04T10:02:00Z",
        "note": "商家已确认"
      },
      {
        "status": "preparing",
        "time": "2025-06-04T10:05:00Z",
        "note": "正在制作"
      },
      {
        "status": "completed",
        "time": "2025-06-04T10:30:00Z",
        "note": "订单完成"
      }
    ],
    "createdAt": "2025-06-04T10:00:00Z",
    "updatedAt": "2025-06-04T10:30:00Z"
  }
}
```

### 更新订单状态

```http
PUT /api/v1/orders/{orderId}
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "status": "confirmed",
  "remarks": "预计30分钟完成"
}
```

### 取消订单

```http
POST /api/v1/orders/{orderId}/cancel
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "reason": "客户要求取消",
  "refundAmount": 53.40
}
```

## 取餐码管理

### 生成取餐码

```http
POST /api/v1/pickup-codes
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "orderId": "order_id",
  "storeId": "store_id",
  "orderType": "takeout",
  "expiryMinutes": 120
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "pickup_code_id",
    "code": "ABC123",
    "orderId": "order_id",
    "storeId": "store_id",
    "orderType": "takeout",
    "status": "active",
    "expiresAt": "2025-06-04T12:00:00Z",
    "createdAt": "2025-06-04T10:00:00Z"
  }
}
```

### 验证取餐码

```http
POST /api/v1/pickup-codes/verify
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "code": "ABC123",
  "storeId": "store_id"
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "valid": true,
    "pickupCode": {
      "id": "pickup_code_id",
      "code": "ABC123",
      "orderId": "order_id",
      "orderNumber": "ORD20250604001",
      "orderType": "takeout",
      "status": "active",
      "customerName": "张三",
      "customerPhone": "13800138000",
      "items": [
        {
          "dishName": "宫保鸡丁",
          "quantity": 2
        }
      ],
      "total": 53.40,
      "expiresAt": "2025-06-04T12:00:00Z"
    }
  }
}
```

### 使用取餐码

```http
POST /api/v1/pickup-codes/{pickupCodeId}/use
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "storeId": "store_id",
  "staffId": "staff_id"
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "message": "取餐码已使用",
    "usedAt": "2025-06-04T11:30:00Z",
    "usedBy": "staff_id"
  }
}
```

### 批量验证取餐码

```http
POST /api/v1/pickup-codes/batch-verify
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "codes": ["ABC123", "DEF456", "GHI789"],
  "storeId": "store_id"
}
```

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "code": "ABC123",
      "valid": true,
      "orderId": "order_id_1",
      "orderNumber": "ORD20250604001"
    },
    {
      "code": "DEF456",
      "valid": false,
      "reason": "expired"
    },
    {
      "code": "GHI789",
      "valid": false,
      "reason": "not_found"
    }
  ]
}
```

### 获取取餐码列表

```http
GET /api/v1/pickup-codes
Authorization: Bearer {token}
```

**查询参数：**
- `page` (可选): 页码，默认 1
- `limit` (可选): 每页数量，默认 20
- `status` (可选): 状态 (active, used, expired)
- `storeId` (可选): 门店ID
- `orderType` (可选): 订单类型

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": "pickup_code_id",
      "code": "ABC123",
      "orderId": "order_id",
      "orderNumber": "ORD20250604001",
      "orderType": "takeout",
      "status": "active",
      "customerName": "张三",
      "total": 53.40,
      "createdAt": "2025-06-04T10:00:00Z",
      "expiresAt": "2025-06-04T12:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 15,
    "pages": 1
  }
}
```

### 获取取餐码统计

```http
GET /api/v1/pickup-codes/stats
Authorization: Bearer {token}
```

**查询参数：**
- `storeId` (可选): 门店ID
- `date` (可选): 日期，格式：YYYY-MM-DD

**响应：**
```json
{
  "success": true,
  "data": {
    "total": 50,
    "active": 15,
    "used": 30,
    "expired": 5,
    "usageRate": 0.86,
    "avgUsageTime": 25.5
  }
}
```

## 支付管理

### 创建支付

```http
POST /api/v1/payments
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "orderId": "order_id",
  "paymentMethod": "alipay",
  "amount": 53.40,
  "returnUrl": "https://app.example.com/payment/success",
  "notifyUrl": "https://api.example.com/payment/notify"
}
```

### 查询支付状态

```http
GET /api/v1/payments/{paymentId}
Authorization: Bearer {token}
```

### 申请退款

```http
POST /api/v1/payments/{paymentId}/refund
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "amount": 53.40,
  "reason": "客户要求退款"
}
```

## 错误响应

订单相关 API 的错误响应格式与用户 API 相同：

```json
{
  "success": false,
  "error": "ErrorType",
  "message": "错误描述",
  "errors": [
    {
      "field": "items",
      "message": "订单项不能为空"
    }
  ]
}
```

### 订单特定错误码

- `OrderNotFound`: 订单不存在
- `OrderAlreadyCancelled`: 订单已取消
- `OrderCannotCancel`: 订单无法取消
- `PickupCodeExpired`: 取餐码已过期
- `PickupCodeAlreadyUsed`: 取餐码已使用
- `InsufficientStock`: 库存不足
- `PaymentFailed`: 支付失败

## 状态码

状态码与用户 API 相同，详见用户 API 文档。