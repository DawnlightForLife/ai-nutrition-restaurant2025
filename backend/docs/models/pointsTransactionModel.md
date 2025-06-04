# 积分交易模型 (PointsTransaction Model)

## 概述

积分交易模型用于记录用户积分的所有变动情况，包括积分获得、消费、过期、管理员调整等操作。每笔交易都有完整的审计记录，确保积分系统的透明性和可追溯性。

## 业务场景

- 订单完成获得积分奖励
- 用户签到获得积分
- 积分兑换商品或优惠
- 积分过期自动扣除
- 管理员手动调整积分
- 积分余额计算和验证

## 数据结构

### 主要字段

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| userId | ObjectId | ✓ | - | 用户ID |
| type | String | ✓ | - | 交易类型 |
| amount | Number | ✓ | - | 积分变动数量（正数获得，负数消费） |
| balanceBefore | Number | ✓ | - | 交易前余额 |
| balanceAfter | Number | ✓ | - | 交易后余额 |
| relatedObject | Object | - | - | 关联对象信息 |
| ruleInfo | Object | - | - | 积分规则信息 |
| expiresAt | Date | - | - | 积分有效期（获得积分时） |
| status | String | - | completed | 交易状态 |
| description | String | ✓ | - | 交易描述 |
| operator | Object | - | - | 操作员信息（管理员操作时） |
| storeInfo | Object | - | - | 门店信息 |
| deviceInfo | Object | - | - | 设备和位置信息 |
| batchId | String | - | - | 批次ID（批量操作时） |
| isExpired | Boolean | - | false | 是否已过期 |
| expiredAt | Date | - | - | 过期处理时间 |
| tags | Array | - | [] | 交易标签 |

### 交易类型 (type)

| 类型 | 说明 | 积分变动 |
|------|------|----------|
| earn_order | 订单获得积分 | + |
| earn_review | 评价获得积分 | + |
| earn_referral | 推荐获得积分 | + |
| earn_checkin | 签到获得积分 | + |
| earn_birthday | 生日积分 | + |
| earn_activity | 活动获得积分 | + |
| earn_bonus | 额外奖励积分 | + |
| spend_order | 订单消费积分 | - |
| spend_redeem | 兑换消费积分 | - |
| adjust_admin | 管理员调整 | +/- |
| expire_auto | 自动过期 | - |
| refund_order | 订单退款返还积分 | + |

### 关联对象信息 (relatedObject)

```javascript
{
  objectType: String,     // 对象类型：order/review/referral/activity/redemption/admin_action
  objectId: ObjectId,     // 对象ID
  objectNumber: String,   // 对象编号（如订单号）
  objectTitle: String     // 对象标题或描述
}
```

### 积分规则信息 (ruleInfo)

```javascript
{
  ruleId: ObjectId,       // 规则ID
  ruleName: String,       // 规则名称
  ruleType: String,       // 规则类型
  multiplier: Number,     // 倍率
  baseAmount: Number      // 基础积分
}
```

### 操作员信息 (operator)

```javascript
{
  operatorId: ObjectId,   // 操作员ID
  operatorName: String,   // 操作员姓名
  operatorRole: String,   // 操作员角色
  reason: String          // 操作原因
}
```

### 门店信息 (storeInfo)

```javascript
{
  storeId: ObjectId,      // 门店ID
  storeName: String,      // 门店名称
  storeCode: String       // 门店编号
}
```

### 设备信息 (deviceInfo)

```javascript
{
  deviceId: String,       // 设备ID
  deviceType: String,     // 设备类型
  ipAddress: String,      // IP地址
  location: {
    latitude: Number,     // 纬度
    longitude: Number,    // 经度
    address: String       // 地址
  }
}
```

## 索引设计

### 主要索引

```javascript
// 主键索引
{ _id: 1 }

// 用户和时间复合索引
{ userId: 1, createdAt: -1 }

// 用户、类型和时间复合索引
{ userId: 1, type: 1, createdAt: -1 }

// 用户、状态和时间复合索引
{ userId: 1, status: 1, createdAt: -1 }

// 关联对象复合索引
{ 'relatedObject.objectType': 1, 'relatedObject.objectId': 1 }

// 过期时间稀疏索引
{ expiresAt: 1 }

// 批次ID稀疏索引
{ batchId: 1 }
```

### 性能考量

- 用户时间复合索引优化历史查询
- 类型索引支持分类统计
- 关联对象索引支持关联查询
- 稀疏索引节省存储空间

## 静态方法

### `createTransaction(transactionData)`

创建积分交易记录。

**参数：**
- `transactionData` (Object): 交易数据

**功能：**
- 获取用户当前余额
- 验证余额是否足够（消费时）
- 创建交易记录
- 更新用户积分余额

**返回：** Promise\<PointsTransaction\>

### `createBatchTransactions(transactions, batchId)`

批量创建积分交易。

**参数：**
- `transactions` (Array): 交易数据数组
- `batchId` (String): 批次ID

**返回：** Promise\<Array\>

### `getUserPointsStats(userId, options)`

获取用户积分统计。

**参数：**
- `userId` (ObjectId): 用户ID
- `options` (Object): 查询选项
  - `startDate` (Date): 开始日期
  - `endDate` (Date): 结束日期
  - `type` (String): 交易类型

**返回：** Promise\<Array\>

### `processExpiredPoints()`

处理过期积分。

**功能：**
- 查找过期的积分获得记录
- 创建过期扣除记录
- 更新用户积分余额
- 标记原记录为已过期

**返回：** Promise\<Array\>

### `getPointsTrend(userId, days)`

获取积分变动趋势。

**参数：**
- `userId` (ObjectId): 用户ID
- `days` (Number): 查询天数，默认30天

**返回：** Promise\<Array\>

## 数据验证

### 自动验证

- 余额计算验证：`balanceAfter = balanceBefore + amount`
- 余额非负验证：积分余额不能为负数
- 变动量非零验证：积分变动不能为0

### 业务规则

- 消费积分时检查余额充足
- 过期积分自动扣除处理
- 交易状态只能是 pending/completed/cancelled
- 每笔交易都有描述信息

## 使用示例

### 创建积分交易

```javascript
const transactionData = {
  userId: user._id,
  type: 'earn_order',
  amount: 100,
  description: '订单完成获得积分',
  relatedObject: {
    objectType: 'order',
    objectId: order._id,
    objectNumber: order.orderNumber
  },
  ruleInfo: {
    ruleId: rule._id,
    ruleName: rule.name,
    ruleType: rule.type
  },
  expiresAt: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000) // 1年后过期
};

const transaction = await PointsTransaction.createTransaction(transactionData);
```

### 批量处理积分

```javascript
const transactions = [
  { userId: user1._id, type: 'earn_order', amount: 50, description: '订单积分' },
  { userId: user2._id, type: 'earn_order', amount: 75, description: '订单积分' }
];

const results = await PointsTransaction.createBatchTransactions(
  transactions, 
  'batch_20231201_001'
);
```

### 获取用户积分统计

```javascript
const stats = await PointsTransaction.getUserPointsStats(userId, {
  startDate: new Date('2023-01-01'),
  endDate: new Date('2023-12-31')
});

stats.forEach(stat => {
  console.log(`${stat._id}: 总积分${stat.totalAmount}, 次数${stat.count}`);
});
```

### 处理过期积分

```javascript
const expiredResults = await PointsTransaction.processExpiredPoints();
console.log(`处理了${expiredResults.length}条过期积分记录`);
```

### 获取积分趋势

```javascript
const trend = await PointsTransaction.getPointsTrend(userId, 30);
trend.forEach(day => {
  console.log(`${day.date}: 获得${day.earned}, 消费${day.spent}, 净值${day.net}`);
});
```

## 关联关系

### 多对一关系

- `userId` → User (用户)
- `ruleInfo.ruleId` → PointsRule (积分规则)
- `operator.operatorId` → User (操作员)
- `storeInfo.storeId` → Store (门店)
- `relatedObject.objectId` → 各种对象 (订单、评价等)

### 业务关联

- 与用户积分余额同步
- 与积分规则系统集成
- 与订单系统联动
- 支持积分过期处理

## 积分过期机制

### 过期策略

1. **FIFO原则**：先获得的积分先过期
2. **自动处理**：定时任务自动扣除过期积分
3. **记录完整**：过期扣除也创建交易记录
4. **通知提醒**：过期前提醒用户使用

### 过期处理流程

```javascript
// 1. 查找过期积分
const expiredTransactions = await PointsTransaction.find({
  expiresAt: { $lte: new Date() },
  status: 'completed',
  amount: { $gt: 0 },
  isExpired: false
});

// 2. 创建过期扣除记录
for (const transaction of expiredTransactions) {
  await PointsTransaction.createTransaction({
    userId: transaction.userId,
    type: 'expire_auto',
    amount: -transaction.amount,
    description: `积分过期自动扣除 (原交易: ${transaction.description})`
  });
  
  // 3. 标记原交易为已过期
  transaction.isExpired = true;
  transaction.expiredAt = new Date();
  await transaction.save();
}
```

## 安全考虑

1. **余额验证**：严格的余额计算验证
2. **操作审计**：完整的操作日志记录
3. **权限控制**：管理员操作需要特殊权限
4. **防重复处理**：幂等性保证

## 性能优化

1. **索引优化**：合理的复合索引设计
2. **分页查询**：大量数据的分页处理
3. **批量操作**：支持批量积分处理
4. **缓存策略**：用户余额缓存

## 注意事项

1. **原子性**：积分变动和余额更新保证原子性
2. **一致性**：交易记录与用户余额保持一致
3. **审计性**：所有积分变动都有记录
4. **扩展性**：支持新的积分获得和消费场景
5. **监控性**：异常积分变动的监控和告警