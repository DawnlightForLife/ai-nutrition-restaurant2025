# API契约文档

## 概述

本文档定义了AI营养餐厅应用程序的API契约，规范了前后端之间的数据交互格式和规则。所有API开发和调用必须严格遵循本契约，以确保系统稳定性和数据一致性。

**更新说明**: 2023年4月10日更新，添加了扩展模型相关API端点，扩展模型已冻结。

## 通用规范

### 基础URL
- 开发环境: `https://dev-api.nutritioneats.com/v1`
- 测试环境: `https://test-api.nutritioneats.com/v1`
- 生产环境: `https://api.nutritioneats.com/v1`

### 请求头
所有请求必须包含以下头信息：
```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token} (除了登录和注册API)
```

### 响应格式
所有API响应必须遵循统一格式：
```json
{
  "success": true|false,
  "data": {}, // 成功时返回的数据
  "error": {  // 失败时返回的错误信息
    "code": "ERROR_CODE",
    "message": "错误描述"
  },
  "pagination": { // 分页接口返回的分页信息
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

### 错误码
| 错误码 | 描述 |
|--------|------|
| AUTH_FAILED | 身份验证失败 |
| INVALID_PARAMS | 无效参数 |
| RESOURCE_NOT_FOUND | 资源未找到 |
| PERMISSION_DENIED | 权限不足 |
| SERVER_ERROR | 服务器错误 |

## API端点

### 用户管理

#### 用户注册
- **URL**: `/users/register`
- **方法**: `POST`
- **请求体**:
```json
{
  "username": "string",
  "email": "string",
  "password": "string",
  "phone": "string",
  "fullName": "string"
}
```
- **响应**:
```json
{
  "success": true,
  "data": {
    "userId": "string",
    "username": "string",
    "email": "string",
    "role": "USER",
    "token": "string"
  }
}
```

#### 用户登录
- **URL**: `/users/login`
- **方法**: `POST`
- **请求体**:
```json
{
  "username": "string",
  "password": "string"
}
```
或
```json
{
  "email": "string",
  "password": "string"
}
```
- **响应**:
```json
{
  "success": true,
  "data": {
    "userId": "string",
    "username": "string",
    "email": "string",
    "role": "USER",
    "token": "string",
    "refreshToken": "string"
  }
}
```

#### 获取用户信息
- **URL**: `/users/profile`
- **方法**: `GET`
- **响应**:
```json
{
  "success": true,
  "data": {
    "userId": "string",
    "username": "string",
    "email": "string",
    "phone": "string",
    "fullName": "string",
    "createdAt": "string",
    "role": "USER",
    "preferences": {
      "theme": "LIGHT|DARK",
      "language": "zh_CN|en_US"
    }
  }
}
```

### 营养档案管理
说明：
- 所有获取健康档案的 API 应返回当前用户所创建的所有营养档案（而非单个档案）
- 所有档案均以 ownerId 作为归属标识，一个用户可以拥有多个
- 建议前端支持多档案切换或选择创建新档案

#### 创建营养档案
- **URL**: `/nutrition-profiles`
- **方法**: `POST`
- **请求体**:
```json
{
  "userId": "string",
  "height": number,
  "weight": number,
  "age": number,
  "gender": "MALE|FEMALE|OTHER",
  "activityLevel": "SEDENTARY|LIGHT|MODERATE|ACTIVE|VERY_ACTIVE",
  "dietaryRestrictions": ["VEGETARIAN", "VEGAN", "GLUTEN_FREE", ...],
  "allergies": ["NUTS", "DAIRY", "SHELLFISH", ...],
  "healthGoals": ["WEIGHT_LOSS", "MUSCLE_GAIN", "MAINTENANCE", ...]
}
```
- **响应**:
```json
{
  "success": true,
  "data": {
    "profileId": "string",
    "userId": "string",
    "height": number,
    "weight": number,
    "age": number,
    "gender": "MALE|FEMALE|OTHER",
    "activityLevel": "SEDENTARY|LIGHT|MODERATE|ACTIVE|VERY_ACTIVE",
    "dietaryRestrictions": ["VEGETARIAN", "VEGAN", "GLUTEN_FREE", ...],
    "allergies": ["NUTS", "DAIRY", "SHELLFISH", ...],
    "healthGoals": ["WEIGHT_LOSS", "MUSCLE_GAIN", "MAINTENANCE", ...],
    "createdAt": "string",
    "updatedAt": "string"
  }
}
```

### AI推荐

#### 获取个性化菜单推荐
- **URL**: `/recommendations/menu`
- **方法**: `GET`
- **查询参数**:
```
mealType=BREAKFAST|LUNCH|DINNER
calories=number (可选)
```
- **响应**:
```json
{
  "success": true,
  "data": {
    "recommendationId": "string",
    "userId": "string",
    "items": [
      {
        "dishId": "string",
        "name": "string",
        "description": "string",
        "nutritionInfo": {
          "calories": number,
          "protein": number,
          "carbs": number,
          "fat": number
        },
        "price": number,
        "image": "string",
        "ingredients": ["string"],
        "tags": ["string"],
        "merchantId": "string"
      }
    ],
    "nutritionSummary": {
      "totalCalories": number,
      "totalProtein": number,
      "totalCarbs": number,
      "totalFat": number
    },
    "createdAt": "string"
  }
}
```

### 商家管理

#### 获取商家列表
- **URL**: `/merchants`
- **方法**: `GET`
- **查询参数**:
```
page=number
pageSize=number
location=string (可选)
cuisine=string (可选)
```
- **响应**:
```json
{
  "success": true,
  "data": [
    {
      "merchantId": "string",
      "name": "string",
      "description": "string",
      "address": "string",
      "phone": "string",
      "email": "string",
      "cuisine": ["string"],
      "rating": number,
      "openingHours": {
        "monday": {"open": "09:00", "close": "22:00"},
        ...
      },
      "featuredDishes": ["string"],
      "logoUrl": "string",
      "coverImageUrl": "string"
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

### 健康数据管理

#### 记录健康数据
- **URL**: `/health-data`
- **方法**: `POST`
- **请求体**:
```json
{
  "userId": "string",
  "nutritionProfileId": "string",
  "dataType": "DAILY_RECORD|MEDICAL_REPORT|BODY_INDEX|NUTRITION_INTAKE",
  "recordDate": "string (ISO date)",
  "weight": number,
  "bloodPressure": {
    "systolic": number,
    "diastolic": number
  },
  "bloodSugar": number,
  "heartRate": number,
  "waterIntake": number,
  "foodLogs": [
    {
      "mealType": "BREAKFAST|LUNCH|DINNER|SNACK",
      "foods": [
        {
          "name": "string",
          "quantity": number,
          "unit": "string",
          "calories": number,
          "nutrients": {
            "protein": number,
            "carbs": number,
            "fat": number
          }
        }
      ]
    }
  ],
  "exerciseLogs": [
    {
      "type": "string",
      "duration": number,
      "caloriesBurned": number,
      "intensity": "LOW|MEDIUM|HIGH"
    }
  ],
  "sleepLogs": {
    "duration": number,
    "quality": "POOR|FAIR|GOOD|EXCELLENT"
  },
  "moodLogs": {
    "mood": "VERY_BAD|BAD|NEUTRAL|GOOD|VERY_GOOD",
    "notes": "string"
  }
}
```
- **响应**:
```json
{
  "success": true,
  "data": {
    "healthDataId": "string",
    "userId": "string",
    "nutritionProfileId": "string",
    "dataType": "DAILY_RECORD|MEDICAL_REPORT|BODY_INDEX|NUTRITION_INTAKE",
    "recordDate": "string (ISO date)",
    "createdAt": "string",
    "updatedAt": "string"
  }
}
```

#### 获取健康数据历史
- **URL**: `/health-data/history`
- **方法**: `GET`
- **查询参数**:
```
profileId=string
startDate=string (ISO date)
endDate=string (ISO date)
dataType=DAILY_RECORD|MEDICAL_REPORT|BODY_INDEX|NUTRITION_INTAKE (可选)
```
- **响应**:
```json
{
  "success": true,
  "data": [
    {
      "healthDataId": "string",
      "userId": "string",
      "nutritionProfileId": "string",
      "dataType": "DAILY_RECORD|MEDICAL_REPORT|BODY_INDEX|NUTRITION_INTAKE",
      "recordDate": "string (ISO date)",
      "weight": number,
      "bloodPressure": {
        "systolic": number,
        "diastolic": number
      },
      "bloodSugar": number,
      "heartRate": number,
      "waterIntake": number,
      "foodLogs": [...],
      "exerciseLogs": [...],
      "sleepLogs": {...},
      "moodLogs": {...},
      "createdAt": "string",
      "updatedAt": "string"
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

### 菜品管理

#### 获取菜品列表
- **URL**: `/dishes`
- **方法**: `GET`
- **查询参数**:
```
page=number
pageSize=number
category=string (可选)
tags=string,string,... (可选)
searchQuery=string (可选)
```
- **响应**:
```json
{
  "success": true,
  "data": [
    {
      "dishId": "string",
      "name": "string",
      "description": "string",
      "categories": ["string"],
      "tags": ["string"],
      "imageUrl": "string",
      "nutritionFacts": {
        "calories": number,
        "protein": number,
        "carbohydrates": number,
        "fat": number,
        "fiber": number,
        "sugar": number,
        "sodium": number,
        "cholesterol": number,
        "vitamins": {"A": number, "C": number, ...},
        "minerals": {"calcium": number, "iron": number, ...}
      },
      "ingredients": ["string"],
      "cookingMethod": "string",
      "spicyLevel": "NONE|MILD|MEDIUM|HOT|EXTRA_HOT",
      "suitableHealthConditions": ["string"],
      "unsuitableHealthConditions": ["string"],
      "seasonAvailability": ["SPRING", "SUMMER", "AUTUMN", "WINTER", "ALL"],
      "averageRating": number,
      "reviewCount": number
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

### 店铺管理

#### 获取店铺列表
- **URL**: `/stores`
- **方法**: `GET`
- **查询参数**:
```
merchantId=string (可选)
page=number
pageSize=number
location=string (可选)
storeType=string (可选)
```
- **响应**:
```json
{
  "success": true,
  "data": [
    {
      "storeId": "string",
      "merchantId": "string",
      "storeName": "string",
      "storeType": "string",
      "address": {
        "street": "string",
        "city": "string",
        "state": "string",
        "postalCode": "string",
        "country": "string",
        "coordinates": {
          "latitude": number,
          "longitude": number
        }
      },
      "contact": {
        "phone": "string",
        "email": "string"
      },
      "businessHours": {
        "monday": {"open": "09:00", "close": "22:00"},
        "tuesday": {"open": "09:00", "close": "22:00"},
        ...
      },
      "deliveryRadius": number,
      "minimumOrder": number,
      "paymentMethods": ["CASH", "CREDIT_CARD", "DEBIT_CARD", "WECHAT_PAY", "ALIPAY"],
      "storeRating": number,
      "reviewCount": number,
      "storeImages": ["string"]
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

### 商家菜品管理

#### 获取商家菜品
- **URL**: `/store-dishes`
- **方法**: `GET`
- **查询参数**:
```
storeId=string
page=number
pageSize=number
category=string (可选)
```
- **响应**:
```json
{
  "success": true,
  "data": [
    {
      "storeDishId": "string",
      "storeId": "string",
      "dishId": "string",
      "merchantId": "string",
      "localPrice": number,
      "promotion": {
        "isOnPromotion": boolean,
        "promotionPrice": number,
        "startDate": "string",
        "endDate": "string",
        "description": "string"
      },
      "available": boolean,
      "salesCount": number,
      "preparationTime": number,
      "featured": boolean,
      "isSeasonal": boolean,
      "stockStatus": "IN_STOCK|LOW_STOCK|OUT_OF_STOCK",
      "activePeriod": "ALL_DAY|BREAKFAST|LUNCH|DINNER",
      "dish": {
        // 包含完整的菜品信息，同/dishes接口响应
      }
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

### 用户收藏管理

#### 添加收藏
- **URL**: `/favorites`
- **方法**: `POST`
- **请求体**:
```json
{
  "userId": "string",
  "itemId": "string",
  "itemType": "DISH|MERCHANT|STORE|NUTRITIONIST",
  "note": "string",
  "customTags": ["string"],
  "collectionName": "string"
}
```
- **响应**:
```json
{
  "success": true,
  "data": {
    "favoriteId": "string",
    "userId": "string",
    "itemId": "string",
    "itemType": "DISH|MERCHANT|STORE|NUTRITIONIST",
    "favoriteDate": "string",
    "note": "string",
    "customTags": ["string"],
    "collectionName": "string",
    "createdAt": "string"
  }
}
```

#### 获取用户收藏列表
- **URL**: `/favorites`
- **方法**: `GET`
- **查询参数**:
```
userId=string
itemType=DISH|MERCHANT|STORE|NUTRITIONIST (可选)
collectionName=string (可选)
page=number
pageSize=number
```
- **响应**:
```json
{
  "success": true,
  "data": [
    {
      "favoriteId": "string",
      "userId": "string",
      "itemId": "string",
      "itemType": "DISH|MERCHANT|STORE|NUTRITIONIST",
      "favoriteDate": "string",
      "note": "string",
      "customTags": ["string"],
      "collectionName": "string",
      "item": {
        // 根据itemType返回对应的详细信息
      },
      "createdAt": "string",
      "lastViewed": "string"
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

### 论坛评论管理

#### 发表评论
- **URL**: `/forum/comments`
- **方法**: `POST`
- **请求体**:
```json
{
  "userId": "string",
  "postId": "string",
  "parentId": "string", // 可选，回复其他评论时使用
  "content": "string",
  "images": ["string"] // 可选，图片URL数组
}
```
- **响应**:
```json
{
  "success": true,
  "data": {
    "commentId": "string",
    "userId": "string",
    "postId": "string",
    "parentId": "string",
    "content": "string",
    "images": ["string"],
    "likeCount": 0,
    "isHidden": false,
    "isExpertComment": false,
    "createdAt": "string",
    "user": {
      "userId": "string",
      "username": "string",
      "avatarUrl": "string"
    }
  }
}
```

#### 获取帖子评论
- **URL**: `/forum/posts/{postId}/comments`
- **方法**: `GET`
- **查询参数**:
```
page=number
pageSize=number
sortBy=newest|oldest|popular (可选)
```
- **响应**:
```json
{
  "success": true,
  "data": [
    {
      "commentId": "string",
      "userId": "string",
      "postId": "string",
      "parentId": "string",
      "content": "string",
      "images": ["string"],
      "likeCount": number,
      "isHidden": boolean,
      "isExpertComment": boolean,
      "createdAt": "string",
      "updatedAt": "string",
      "user": {
        "userId": "string",
        "username": "string",
        "avatarUrl": "string",
        "role": "string"
      },
      "replies": [ // 一级评论包含回复
        {
          // 子评论结构同上
        }
      ]
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "pageSize": 10,
    "totalPages": 10
  }
}
```

### 数据访问控制

#### 授予数据访问权限
- **URL**: `/data-access-controls`
- **方法**: `POST`
- **请求体**:
```json
{
  "accessName": "string",
  "description": "string",
  "dataOwner": {
    "userId": "string",
    "ownerType": "USER"
  },
  "dataRequester": {
    "userId": "string",
    "requesterType": "NUTRITIONIST|MERCHANT|ADMIN"
  },
  "accessLevel": "READ_ONLY|READ_WRITE|FULL_ACCESS",
  "resourceType": "HEALTH_DATA|NUTRITION_PROFILE|ORDER_HISTORY|ALL",
  "resourceId": "string", // 可选，特定资源ID
  "grantedPermissions": ["READ", "WRITE", "DELETE", "RECOMMEND"],
  "timeLimitations": {
    "startDate": "string",
    "endDate": "string",
    "indefinite": boolean
  }
}
```
- **响应**:
```json
{
  "success": true,
  "data": {
    "accessId": "string",
    "accessName": "string",
    "description": "string",
    "dataOwner": {
      "userId": "string",
      "ownerType": "USER"
    },
    "dataRequester": {
      "userId": "string",
      "requesterType": "NUTRITIONIST|MERCHANT|ADMIN"
    },
    "accessLevel": "READ_ONLY|READ_WRITE|FULL_ACCESS",
    "resourceType": "HEALTH_DATA|NUTRITION_PROFILE|ORDER_HISTORY|ALL",
    "resourceId": "string",
    "grantedPermissions": ["READ", "WRITE", "DELETE", "RECOMMEND"],
    "timeLimitations": {
      "startDate": "string",
      "endDate": "string",
      "indefinite": boolean
    },
    "createdAt": "string"
  }
}
```

## 版本历史

| 版本 | 日期 | 变更内容 |
|------|------|----------|
| 1.0 | 2023-01-15 | 初始版本，定义基础API规范 |
| 1.1 | 2023-02-10 | 添加AI推荐和商家相关API |
| 1.2 | 2023-03-05 | 添加订单和咨询相关API |
| 1.3 | 2023-03-20 | 添加论坛和管理员相关API |
| 1.4 | 2023-03-28 | 添加审计日志和用户角色相关API |
| 2.0 | 2023-04-01 | API契约冻结，与核心模型对应 |
| 2.1 | 2023-04-10 | 添加扩展模型相关API，包括健康数据、菜品、商家菜品、店铺、用户收藏、论坛评论和数据访问控制 |

## 重要说明

1. 所有API必须遵循本契约，不得随意改变响应格式或字段名称
2. 字段名使用驼峰命名法 (camelCase)
3. 枚举值使用全大写，单词间用下划线分隔 (SNAKE_CASE)
4. 任何API变更必须先通过评审流程，并在新版本中发布
5. 前端开发必须根据此契约开发接口调用代码，避免硬编码
6. 后端开发必须确保API实现严格符合此契约

## 数据校验规则

根据已冻结的数据模型，API交互必须遵循以下验证规则：

1. **用户名**: 5-20个字符，只允许字母、数字和下划线
2. **邮箱**: 有效的邮箱格式
3. **密码**: 8-20个字符，至少包含一个大写字母、一个小写字母和一个数字
4. **手机号**: 11位数字，符合中国手机号格式
5. **枚举值**: 所有枚举值必须是预定义值之一
6. **ID格式**: 所有ID必须是有效的MongoDB ObjectId或UUID格式
7. **日期格式**: 所有日期必须是ISO 8601格式

## 版本控制

API版本控制通过URL路径中的版本号实现，例如`/v1/users`。当前版本为`v1`，未来版本会按照`v2`、`v3`依次递增。

## 附录：模型映射

| API字段 | 数据库模型字段 | 备注 |
|---------|---------------|------|
| userId | _id (userModel) | |
| profileId | _id (nutritionProfileModel) | |
| recommendationId | _id (aiRecommendationModel) | |
| merchantId | _id (merchantModel) | |
| orderId | _id (orderModel) | | 