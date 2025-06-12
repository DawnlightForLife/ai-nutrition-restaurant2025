# 系统配置 API 文档

## 概述

系统配置模块提供了对系统级配置项的管理功能，包括功能开关、业务配置等。

## API 端点

### 公开接口

#### 获取公开配置

获取所有标记为公开的系统配置项。

```
GET /api/system-config/public
```

**响应示例：**

```json
{
  "success": true,
  "data": {
    "merchant_certification_enabled": false,
    "nutritionist_certification_enabled": false,
    "merchant_certification_mode": "contact",
    "nutritionist_certification_mode": "contact"
  }
}
```

#### 获取认证功能配置

获取商家和营养师认证相关的配置。

```
GET /api/system-config/certification
```

**响应示例：**

```json
{
  "success": true,
  "data": {
    "merchant_certification_enabled": false,
    "nutritionist_certification_enabled": false,
    "merchant_certification_mode": "contact",
    "nutritionist_certification_mode": "contact"
  }
}
```

### 管理后台接口

所有管理后台接口需要管理员认证。

#### 获取配置分类列表

```
GET /api/system-config/categories
```

**响应示例：**

```json
{
  "success": true,
  "data": [
    {
      "value": "feature",
      "label": "功能配置",
      "description": "功能开关和模式设置"
    },
    {
      "value": "system",
      "label": "系统配置",
      "description": "系统级别的配置项"
    }
  ]
}
```

#### 获取所有配置

```
GET /api/system-config
```

**查询参数：**

- `category` (string, 可选): 按分类过滤
- `isPublic` (boolean, 可选): 是否公开
- `isEditable` (boolean, 可选): 是否可编辑

**响应示例：**

```json
{
  "success": true,
  "data": [
    {
      "_id": "xxx",
      "key": "merchant_certification_enabled",
      "value": false,
      "valueType": "boolean",
      "category": "feature",
      "description": "商家认证功能开关",
      "isPublic": true,
      "isEditable": true,
      "updatedBy": {
        "name": "管理员",
        "email": "admin@example.com"
      },
      "updatedAt": "2025-06-11T10:00:00.000Z"
    }
  ],
  "total": 4
}
```

#### 获取单个配置

```
GET /api/system-config/:key
```

**响应示例：**

```json
{
  "success": true,
  "data": {
    "key": "merchant_certification_enabled",
    "value": false
  }
}
```

#### 更新配置

```
PUT /api/system-config/:key
```

**请求体：**

```json
{
  "value": true
}
```

**响应示例：**

```json
{
  "success": true,
  "message": "配置更新成功",
  "data": {
    "key": "merchant_certification_enabled",
    "value": true,
    "updatedAt": "2025-06-11T10:00:00.000Z"
  }
}
```

#### 批量更新认证配置

```
PUT /api/system-config/certification
```

**请求体：**

```json
{
  "merchant_certification_enabled": true,
  "nutritionist_certification_enabled": true,
  "merchant_certification_mode": "contact",
  "nutritionist_certification_mode": "auto"
}
```

**响应示例：**

```json
{
  "success": true,
  "message": "认证配置更新成功",
  "data": {
    "merchant_certification_enabled": true,
    "nutritionist_certification_enabled": true,
    "merchant_certification_mode": "contact",
    "nutritionist_certification_mode": "auto"
  }
}
```

#### 创建配置

```
POST /api/system-config
```

**请求体：**

```json
{
  "key": "new_feature_enabled",
  "value": false,
  "valueType": "boolean",
  "category": "feature",
  "description": "新功能开关",
  "isPublic": true,
  "isEditable": true
}
```

**响应示例：**

```json
{
  "success": true,
  "message": "配置创建成功",
  "data": {
    "_id": "xxx",
    "key": "new_feature_enabled",
    "value": false
  }
}
```

#### 删除配置

```
DELETE /api/system-config/:key
```

**响应示例：**

```json
{
  "success": true,
  "message": "配置删除成功"
}
```

#### 初始化默认配置

```
POST /api/system-config/initialize
```

**响应示例：**

```json
{
  "success": true,
  "message": "默认配置初始化成功"
}
```

## 配置项说明

### 认证功能配置

| 配置键 | 类型 | 说明 | 默认值 |
|--------|------|------|--------|
| merchant_certification_enabled | boolean | 商家认证功能开关 | false |
| nutritionist_certification_enabled | boolean | 营养师认证功能开关 | false |
| merchant_certification_mode | string | 商家认证模式：contact-联系客服，auto-自动认证 | contact |
| nutritionist_certification_mode | string | 营养师认证模式：contact-联系客服，auto-自动认证 | contact |

## 错误码

- `400`: 请求参数错误
- `401`: 未认证
- `403`: 无权限或配置不可编辑
- `404`: 配置项不存在
- `409`: 配置项已存在（创建时）
- `500`: 服务器内部错误

## 实现说明

### 模型层

系统配置使用 MongoDB 存储，模型定义在 `/models/core/systemConfigModel.js`：

- 使用复合唯一索引确保配置键唯一性
- 支持多种值类型：boolean, string, number, json
- 包含审计字段：updatedBy, updatedAt

### 服务层

服务层 (`/services/core/systemConfigService.js`) 提供：

- CRUD 操作的业务逻辑
- 批量更新操作
- 初始化默认配置
- 类型转换和验证

### 控制器层

控制器 (`/controllers/core/systemConfigController.js`) 处理：

- HTTP 请求和响应
- 权限验证（admin 权限）
- 错误处理
- 审计信息记录

### 路由配置

路由定义在 `/routes/core/systemConfigRoutes.js`：

- 公开路由：无需认证
- 管理路由：需要 admin 权限

## 使用场景

1. **功能开关管理**：通过后台界面控制功能的启用/禁用
2. **认证流程控制**：切换自动认证和联系客服模式
3. **系统参数配置**：配置系统级别的参数
4. **动态功能发布**：无需重新部署即可控制功能可见性