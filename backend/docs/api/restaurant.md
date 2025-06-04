# 餐厅管理 API

## 概述

餐厅管理 API 提供餐厅、分店、桌位管理以及设置配置的接口。

## 餐厅管理

### 创建餐厅

```http
POST /api/v1/restaurants
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "name": "美味餐厅",
  "type": "chain",
  "description": "专注健康营养的中式餐厅",
  "logo": "https://example.com/logo.jpg",
  "coverImage": "https://example.com/cover.jpg",
  "businessLicense": "440300123456789",
  "registrationNumber": "91440300123456789X",
  "legalRepresentative": "张三",
  "establishedDate": "2020-01-01",
  "contactInfo": {
    "phone": "0755-12345678",
    "email": "contact@restaurant.com",
    "website": "https://restaurant.com"
  },
  "socialMedia": {
    "wechat": "restaurant_wechat",
    "weibo": "restaurant_weibo"
  },
  "tags": ["健康", "营养", "中式"],
  "features": ["wifi", "parking", "private_room"],
  "cuisineTypes": ["chinese", "cantonese"],
  "priceRange": "medium",
  "serviceTypes": ["dine_in", "takeout", "delivery"],
  "paymentMethods": ["cash", "alipay", "wechat_pay"]
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "restaurant_id",
    "name": "美味餐厅",
    "type": "chain",
    "status": "active",
    "verificationStatus": "pending",
    "contactInfo": {
      "phone": "0755-12345678",
      "email": "contact@restaurant.com"
    },
    "createdAt": "2025-06-04T10:00:00Z"
  }
}
```

### 获取餐厅详情

```http
GET /api/v1/restaurants/{restaurantId}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "restaurant_id",
    "name": "美味餐厅",
    "type": "chain",
    "description": "专注健康营养的中式餐厅",
    "logo": "https://example.com/logo.jpg",
    "coverImage": "https://example.com/cover.jpg",
    "status": "active",
    "verificationStatus": "verified",
    "verifiedAt": "2025-06-01T10:00:00Z",
    "contactInfo": {
      "phone": "0755-12345678",
      "email": "contact@restaurant.com",
      "website": "https://restaurant.com"
    },
    "tags": ["健康", "营养", "中式"],
    "features": ["wifi", "parking", "private_room"],
    "cuisineTypes": ["chinese", "cantonese"],
    "priceRange": "medium",
    "serviceTypes": ["dine_in", "takeout", "delivery"],
    "createdAt": "2025-06-01T10:00:00Z"
  }
}
```

### 搜索餐厅

```http
GET /api/v1/restaurants/search
```

**查询参数：**
- `keyword` (可选): 关键词搜索
- `cuisineType` (可选): 菜系类型
- `priceRange` (可选): 价格范围
- `serviceType` (可选): 服务类型
- `features` (可选): 特色功能，多个用逗号分隔
- `status` (可选): 状态筛选

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": "restaurant_id",
      "name": "美味餐厅",
      "logo": "https://example.com/logo.jpg",
      "cuisineTypes": ["chinese", "cantonese"],
      "priceRange": "medium",
      "rating": 4.5,
      "branchCount": 5
    }
  ],
  "total": 25
}
```

### 更新餐厅信息

```http
PUT /api/v1/restaurants/{restaurantId}
Authorization: Bearer {token}
```

### 验证餐厅

```http
POST /api/v1/restaurants/{restaurantId}/verify
Authorization: Bearer {admin_token}
```

## 分店管理

### 创建分店

```http
POST /api/v1/restaurants/{restaurantId}/branches
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "name": "美味餐厅南山店",
  "address": {
    "province": "广东省",
    "city": "深圳市",
    "district": "南山区",
    "street": "科技园南区",
    "detail": "深圳湾科技生态园10栋A座1楼",
    "postalCode": "518000"
  },
  "location": {
    "type": "Point",
    "coordinates": [113.947, 22.540]
  },
  "contactInfo": {
    "phone": "0755-12345678",
    "email": "nanshan@restaurant.com"
  },
  "businessHours": {
    "monday": { "open": "09:00", "close": "22:00", "isOpen": true },
    "tuesday": { "open": "09:00", "close": "22:00", "isOpen": true },
    "wednesday": { "open": "09:00", "close": "22:00", "isOpen": true },
    "thursday": { "open": "09:00", "close": "22:00", "isOpen": true },
    "friday": { "open": "09:00", "close": "22:00", "isOpen": true },
    "saturday": { "open": "09:00", "close": "22:00", "isOpen": true },
    "sunday": { "open": "10:00", "close": "21:00", "isOpen": true }
  },
  "manager": {
    "name": "李四",
    "phone": "13800138000",
    "email": "lisi@restaurant.com"
  },
  "staffCount": 15,
  "seatingCapacity": 100,
  "features": ["wifi", "parking"],
  "parkingInfo": {
    "available": true,
    "type": "free",
    "spaces": 20
  }
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "branch_id",
    "restaurantId": "restaurant_id",
    "name": "美味餐厅南山店",
    "code": "BR001",
    "address": {
      "province": "广东省",
      "city": "深圳市",
      "district": "南山区",
      "detail": "深圳湾科技生态园10栋A座1楼"
    },
    "status": "active",
    "isOpenNow": true,
    "createdAt": "2025-06-04T10:00:00Z"
  }
}
```

### 获取分店详情

```http
GET /api/v1/branches/{branchId}
```

### 获取餐厅的所有分店

```http
GET /api/v1/restaurants/{restaurantId}/branches
```

### 查找附近分店

```http
GET /api/v1/branches/nearby
```

**查询参数：**
- `longitude`: 经度 (必填)
- `latitude`: 纬度 (必填)
- `radius`: 半径（米），默认 5000

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": "branch_id",
      "restaurantId": "restaurant_id",
      "restaurantName": "美味餐厅",
      "name": "南山店",
      "address": "深圳市南山区科技园",
      "distance": 1200,
      "isOpenNow": true,
      "estimatedTime": 25
    }
  ],
  "total": 3
}
```

### 更新分店信息

```http
PUT /api/v1/branches/{branchId}
Authorization: Bearer {token}
```

## 桌位管理

### 创建桌位

```http
POST /api/v1/branches/{branchId}/tables
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "tableNumber": "A01",
  "area": "main",
  "capacity": 4,
  "minCapacity": 2,
  "tableType": "regular",
  "shape": "square",
  "features": ["window_seat", "power_outlet"],
  "position": {
    "x": 100,
    "y": 150,
    "floor": 1
  },
  "isActive": true
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "table_id",
    "branchId": "branch_id",
    "tableNumber": "A01",
    "qrCode": "https://restaurant.app/scan/table/branch_id/A01",
    "area": "main",
    "capacity": 4,
    "status": "available",
    "isActive": true,
    "createdAt": "2025-06-04T10:00:00Z"
  }
}
```

### 批量创建桌位

```http
POST /api/v1/branches/{branchId}/tables/batch
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "tables": [
    {
      "tableNumber": "A01",
      "capacity": 4,
      "area": "main"
    },
    {
      "tableNumber": "A02",
      "capacity": 6,
      "area": "main"
    },
    {
      "tableNumber": "B01",
      "capacity": 2,
      "area": "vip"
    }
  ]
}
```

### 获取分店桌位列表

```http
GET /api/v1/branches/{branchId}/tables
```

**查询参数：**
- `area` (可选): 区域筛选
- `status` (可选): 状态筛选
- `minCapacity` (可选): 最小容量
- `activeOnly` (可选): 只显示启用的桌位

**响应：**
```json
{
  "success": true,
  "data": [
    {
      "id": "table_id",
      "tableNumber": "A01",
      "area": "main",
      "capacity": 4,
      "status": "available",
      "currentOrderId": null,
      "features": ["window_seat"],
      "isActive": true
    }
  ],
  "total": 25
}
```

### 获取桌位详情

```http
GET /api/v1/tables/{tableId}
```

### 占用桌位

```http
POST /api/v1/tables/{tableId}/occupy
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "orderId": "order_id"
}
```

### 释放桌位

```http
POST /api/v1/tables/{tableId}/release
Authorization: Bearer {token}
```

### 更新桌位信息

```http
PUT /api/v1/tables/{tableId}
Authorization: Bearer {token}
```

## 设置管理

### 获取餐厅设置

```http
GET /api/v1/restaurants/{restaurantId}/settings
Authorization: Bearer {token}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "id": "settings_id",
    "restaurantId": "restaurant_id",
    "orderSettings": {
      "enableOnlineOrder": true,
      "enableTableOrder": true,
      "autoConfirmMinutes": 5,
      "autoCancelMinutes": 30,
      "minOrderAmount": 20,
      "maxOrderAmount": 1000
    },
    "paymentSettings": {
      "enableOnlinePayment": true,
      "paymentMethods": ["alipay", "wechat_pay"],
      "paymentTimeout": 15
    },
    "deliverySettings": {
      "enableDelivery": true,
      "deliveryRadius": 5,
      "deliveryFee": 5,
      "freeDeliveryAmount": 50
    },
    "tableSettings": {
      "enableTableReservation": true,
      "reservationDuration": 120,
      "enableQROrdering": true
    },
    "nutritionSettings": {
      "displayNutrition": true,
      "displayCalories": true,
      "displayAllergens": true
    }
  }
}
```

### 获取分店设置

```http
GET /api/v1/branches/{branchId}/settings
Authorization: Bearer {token}
```

### 更新设置

```http
PUT /api/v1/settings/{settingsId}
Authorization: Bearer {token}
```

**请求体：**
```json
{
  "orderSettings": {
    "autoConfirmMinutes": 10,
    "minOrderAmount": 30
  },
  "paymentSettings": {
    "paymentTimeout": 20
  }
}
```

## 错误响应

餐厅相关 API 的错误响应格式：

```json
{
  "success": false,
  "error": "ErrorType",
  "message": "错误描述",
  "errors": [
    {
      "field": "businessLicense",
      "message": "营业执照已被注册"
    }
  ]
}
```

### 餐厅特定错误码

- `RestaurantNotFound`: 餐厅不存在
- `BranchNotFound`: 分店不存在
- `TableNotFound`: 桌位不存在
- `TableNotAvailable`: 桌位不可用
- `TableAlreadyOccupied`: 桌位已被占用
- `BusinessLicenseExists`: 营业执照已存在
- `InvalidBusinessHours`: 营业时间格式错误
- `SettingsValidationFailed`: 设置验证失败

## 状态码

状态码与用户 API 相同，详见用户 API 文档。