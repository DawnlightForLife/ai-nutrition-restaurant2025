# 取餐码模型 (PickupCode Model)

## 概述

取餐码模型用于管理订单取餐验证码系统。为已确认的订单生成6位字母数字取餐码，用户凭取餐码到门店取餐，门店员工验证后完成订单交付。

## 业务场景

- 订单确认后自动生成取餐码
- 用户凭取餐码到店取餐
- 门店员工验证取餐码真实性
- 防止订单冒取和欺诈
- 取餐流程数字化管理

## 数据结构

### 主要字段

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| code | String | ✓ | 自动生成 | 6位取餐码，字母数字组合 |
| orderId | ObjectId | ✓ | - | 关联订单ID |
| orderNumber | String | ✓ | - | 订单号（冗余字段） |
| storeId | ObjectId | ✓ | - | 门店ID |
| userId | ObjectId | ✓ | - | 用户ID |
| status | String | - | active | 状态：active/used/expired/cancelled |
| generatedAt | Date | - | 当前时间 | 生成时间 |
| expiresAt | Date | - | 2小时后 | 过期时间 |
| usageRecord | Object | - | - | 使用记录 |
| verificationAttempts | Array | - | [] | 验证尝试记录 |
| pickupPerson | Object | - | - | 取餐人信息 |
| specialNotes | String | - | - | 特殊说明 |
| notificationStatus | Object | - | - | 通知状态 |

### 使用记录结构 (usageRecord)

```javascript
{
  usedAt: Date,           // 使用时间
  usedBy: ObjectId,       // 使用者（门店员工）ID
  verificationMethod: String, // 验证方式：manual/qr_scan/voice_input
  deviceInfo: {
    deviceId: String,     // 设备ID
    deviceType: String,   // 设备类型
    ipAddress: String     // IP地址
  }
}
```

### 验证尝试记录 (verificationAttempts)

```javascript
[{
  timestamp: Date,        // 尝试时间
  inputCode: String,      // 输入的码
  success: Boolean,       // 是否成功
  ipAddress: String,      // IP地址
  userAgent: String,      // 用户代理
  failureReason: String   // 失败原因
}]
```

### 取餐人信息 (pickupPerson)

```javascript
{
  name: String,           // 取餐人姓名
  phone: String,          // 取餐人电话
  isOriginalCustomer: Boolean // 是否为原下单客户
}
```

### 通知状态 (notificationStatus)

```javascript
{
  smsNotified: Boolean,   // 短信通知状态
  emailNotified: Boolean, // 邮件通知状态
  appNotified: Boolean,   // 应用推送状态
  lastNotificationAt: Date // 最后通知时间
}
```

## 索引设计

### 主要索引

```javascript
// 主键索引
{ _id: 1 }

// 取餐码唯一索引
{ code: 1 }

// 订单ID索引
{ orderId: 1 }

// 门店和状态复合索引
{ storeId: 1, status: 1, generatedAt: -1 }

// 用户和状态复合索引
{ userId: 1, status: 1, generatedAt: -1 }

// 取餐码和门店复合索引
{ code: 1, storeId: 1 }

// TTL过期索引
{ expiresAt: 1 }, { expireAfterSeconds: 0 }
```

### 性能考量

- `code` 字段唯一索引，支持快速验证
- 复合索引优化门店查询性能
- TTL索引自动清理过期数据
- 避免使用容易混淆的字符（I、L、0、O）

## 静态方法

### `generateCode()`

生成唯一的6位取餐码。

**特点：**
- 6位字母数字组合
- 避免容易混淆的字符
- 确保在活跃状态下唯一
- 最多重试10次

```javascript
const code = await PickupCode.generateCode();
// 返回如：'ABC123'
```

### `createForOrder(orderData)`

为订单创建取餐码。

**参数：**
- `orderData` (Object): 订单数据
  - `orderId` (ObjectId): 订单ID
  - `orderNumber` (String): 订单号
  - `storeId` (ObjectId): 门店ID
  - `userId` (ObjectId): 用户ID
  - `customerName` (String): 客户姓名
  - `customerPhone` (String): 客户电话
  - `specialNotes` (String): 特殊说明

**返回：** Promise\<PickupCode\>

### `verifyCode(code, storeId, options)`

验证取餐码。

**参数：**
- `code` (String): 取餐码
- `storeId` (ObjectId): 门店ID
- `options` (Object): 验证选项

**返回：** Promise\<PickupCode|null\>

### `getStoreStats(storeId, date)`

获取门店取餐码统计。

**参数：**
- `storeId` (ObjectId): 门店ID
- `date` (Date): 统计日期

**返回：** Promise\<Object\>

```javascript
{
  total: Number,     // 总数
  active: Number,    // 活跃数
  used: Number,      // 已使用数
  expired: Number,   // 已过期数
  cancelled: Number  // 已取消数
}
```

## 实例方法

### `markAsUsed(staffUserId, options)`

标记取餐码为已使用。

**参数：**
- `staffUserId` (ObjectId): 门店员工ID
- `options` (Object): 使用选项
  - `verificationMethod` (String): 验证方式
  - `deviceId` (String): 设备ID
  - `deviceType` (String): 设备类型
  - `ipAddress` (String): IP地址
  - `pickupPerson` (Object): 代取人信息

**返回：** Promise\<PickupCode\>

### `cancel(reason)`

取消取餐码。

**参数：**
- `reason` (String): 取消原因

**返回：** Promise\<PickupCode\>

### `extendExpiry(additionalHours)`

延长过期时间。

**参数：**
- `additionalHours` (Number): 延长小时数，默认1小时

**返回：** Promise\<PickupCode\>

**限制：**
- 只能延长有效取餐码
- 最多延长至生成后24小时

## 数据验证

### 自动验证

- 取餐码格式：6位字母数字组合
- 状态检查：只有active状态可以使用
- 过期检查：超过过期时间自动设为expired
- 唯一性检查：同一门店同一时间码不重复

### 业务规则

- 取餐码默认2小时有效期
- 每个订单只能有一个活跃取餐码
- 只有门店员工可以验证使用
- 验证失败记录攻击尝试

## 使用示例

### 为订单创建取餐码

```javascript
const orderData = {
  orderId: order._id,
  orderNumber: order.orderNumber,
  storeId: order.storeId,
  userId: order.userId,
  customerName: '张三',
  customerPhone: '13812345678'
};

const pickupCode = await PickupCode.createForOrder(orderData);
console.log(`取餐码：${pickupCode.code}`);
```

### 验证取餐码

```javascript
const pickupCode = await PickupCode.verifyCode('ABC123', storeId, {
  ipAddress: '192.168.1.1',
  userAgent: 'Mozilla/5.0...'
});

if (pickupCode) {
  console.log('取餐码有效，可以取餐');
} else {
  console.log('取餐码无效或已过期');
}
```

### 使用取餐码

```javascript
const pickupCode = await PickupCode.findOne({ 
  code: 'ABC123', 
  storeId, 
  status: 'active' 
});

await pickupCode.markAsUsed(staffId, {
  verificationMethod: 'manual',
  deviceId: 'POS001',
  deviceType: 'POS机'
});
```

### 获取门店统计

```javascript
const stats = await PickupCode.getStoreStats(storeId, new Date());
console.log(stats);
// { total: 50, active: 10, used: 35, expired: 3, cancelled: 2 }
```

## 关联关系

### 多对一关系

- `orderId` → Order (订单)
- `storeId` → Store (门店)
- `userId` → User (用户)
- `usageRecord.usedBy` → User (门店员工)

### 业务关联

- 与订单状态同步更新
- 与通知系统集成
- 与门店POS系统对接

## 安全考虑

1. **防暴力破解**：记录验证失败尝试，限制频繁验证
2. **防重放攻击**：取餐码一次性使用
3. **防过期使用**：严格的时间验证
4. **审计日志**：完整的操作记录

## 性能优化

1. **索引优化**：合理的复合索引设计
2. **自动清理**：TTL索引清理过期数据
3. **缓存策略**：热点取餐码缓存
4. **批量操作**：支持批量验证

## 注意事项

1. **唯一性保证**：在同一门店同一时间段内唯一
2. **过期处理**：定时任务清理过期数据
3. **通知集成**：与短信、推送系统集成
4. **代取支持**：支持非本人取餐场景
5. **设备兼容**：支持多种验证设备