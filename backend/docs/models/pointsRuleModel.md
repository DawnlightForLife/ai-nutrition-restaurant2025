# 积分规则模型 (PointsRule Model)

## 概述

积分规则模型定义了用户在不同场景下获得积分的规则和计算方式。支持灵活的条件配置、多种计算模式、频率限制和A/B测试，为积分系统提供强大的业务规则引擎。

## 业务场景

- 订单完成积分奖励规则
- 用户签到积分规则
- 评价反馈积分奖励
- 推荐好友积分奖励
- 特殊活动积分规则
- 会员等级积分倍率

## 数据结构

### 主要字段

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| name | String | ✓ | - | 规则名称 |
| type | String | ✓ | - | 规则类型 |
| status | String | - | active | 规则状态：active/inactive/expired |
| pointsConfig | Object | ✓ | - | 积分计算配置 |
| conditions | Object | - | {} | 触发条件 |
| frequency | Object | - | - | 频率限制 |
| validity | Object | - | - | 有效期配置 |
| priority | Number | - | 0 | 优先级 |
| description | String | - | - | 规则描述 |
| createdBy | ObjectId | ✓ | - | 创建者ID |
| lastModifiedBy | ObjectId | - | - | 最后修改者ID |
| usageStats | Object | - | - | 使用统计 |
| abTestConfig | Object | - | - | A/B测试配置 |
| tags | Array | - | [] | 规则标签 |

### 规则类型 (type)

| 类型 | 说明 | 适用场景 |
|------|------|----------|
| order_completion | 订单完成 | 用户完成订单后获得积分 |
| order_amount | 订单金额 | 基于订单金额比例获得积分 |
| review_submission | 提交评价 | 用户提交订单评价获得积分 |
| referral_success | 推荐成功 | 成功推荐新用户获得积分 |
| daily_checkin | 每日签到 | 用户每日签到获得积分 |
| birthday_bonus | 生日奖励 | 用户生日当天获得积分 |
| activity_participation | 活动参与 | 参与特定活动获得积分 |
| membership_upgrade | 会员升级 | 会员等级提升获得积分 |
| first_order | 首次下单 | 新用户首次下单获得积分 |
| consecutive_orders | 连续下单 | 连续下单获得额外积分 |

### 积分计算配置 (pointsConfig)

```javascript
{
  calculationType: String,    // 计算方式：fixed/percentage/tiered/formula
  fixedAmount: Number,        // 固定积分数量
  percentage: Number,         // 百分比（0-100）
  tiers: [{                   // 分层配置
    minAmount: Number,        // 最小金额
    maxAmount: Number,        // 最大金额
    points: Number,           // 积分数量
    multiplier: Number        // 倍率
  }],
  formula: String,            // 自定义公式
  minPoints: Number,          // 最小积分
  maxPoints: Number,          // 最大积分
  multiplier: Number          // 全局倍率
}
```

### 触发条件 (conditions)

```javascript
{
  minOrderAmount: Number,     // 最小订单金额
  maxOrderAmount: Number,     // 最大订单金额
  categoryIds: [ObjectId],    // 指定商品类别
  storeIds: [ObjectId],       // 指定门店
  membershipLevels: [String], // 用户会员等级
  minRegistrationDays: Number,// 最小注册天数
  minOrderCount: Number,      // 最小历史订单数
  timeRestrictions: {         // 时间限制
    dayOfWeek: [Number],      // 星期几（0-6）
    hourOfDay: {              // 小时范围
      start: Number,          // 开始小时（0-23）
      end: Number             // 结束小时（0-23）
    },
    dateRange: {              // 日期范围
      start: Date,            // 开始日期
      end: Date               // 结束日期
    }
  },
  customCondition: String     // 自定义条件表达式
}
```

### 频率限制 (frequency)

```javascript
{
  limitType: String,          // 限制类型：once/daily/weekly/monthly/unlimited
  limitCount: Number,         // 限制次数
  cooldownHours: Number       // 冷却时间（小时）
}
```

### 有效期配置 (validity)

```javascript
{
  startDate: Date,            // 规则开始时间
  endDate: Date,              // 规则结束时间
  pointsValidityDays: Number  // 获得积分的有效期（天）
}
```

### 使用统计 (usageStats)

```javascript
{
  totalUsages: Number,        // 总使用次数
  totalPointsIssued: Number,  // 总发放积分
  lastUsedAt: Date,           // 最后使用时间
  avgPointsPerUsage: Number   // 平均每次积分
}
```

### A/B测试配置 (abTestConfig)

```javascript
{
  isTestRule: Boolean,        // 是否为测试规则
  testGroup: String,          // 测试组名称
  testPercentage: Number,     // 测试流量百分比（0-100）
  controlRuleId: ObjectId     // 对照规则ID
}
```

## 索引设计

### 主要索引

```javascript
// 主键索引
{ _id: 1 }

// 类型、状态和优先级复合索引
{ type: 1, status: 1, priority: -1 }

// 有效期复合索引
{ status: 1, 'validity.startDate': 1, 'validity.endDate': 1 }

// 门店条件索引
{ 'conditions.storeIds': 1 }

// 类别条件索引
{ 'conditions.categoryIds': 1 }
```

### 性能考量

- 类型索引支持快速规则匹配
- 优先级排序优化规则选择
- 条件索引加速规则筛选
- 有效期索引支持时间范围查询

## 静态方法

### `getApplicableRules(context)`

获取适用的积分规则。

**参数：**
- `context` (Object): 上下文信息
  - `type` (String): 规则类型
  - `userId` (ObjectId): 用户ID
  - `orderAmount` (Number): 订单金额
  - `storeId` (ObjectId): 门店ID
  - `categoryIds` (Array): 商品类别
  - `timestamp` (Date): 时间戳

**返回：** Promise\<Array\<PointsRule\>\>

### `checkConditions(rule, context)`

检查规则条件是否满足。

**参数：**
- `rule` (PointsRule): 积分规则
- `context` (Object): 上下文信息

**返回：** Promise\<Boolean\>

### `checkFrequencyLimit(ruleId, userId, frequency)`

检查频率限制。

**参数：**
- `ruleId` (ObjectId): 规则ID
- `userId` (ObjectId): 用户ID
- `frequency` (Object): 频率配置

**返回：** Promise\<Boolean\>

### `getUsageReport(options)`

获取规则使用报告。

**参数：**
- `options` (Object): 查询选项
  - `startDate` (Date): 开始日期
  - `endDate` (Date): 结束日期
  - `ruleType` (String): 规则类型
  - `storeId` (ObjectId): 门店ID

**返回：** Promise\<Array\>

## 实例方法

### `calculatePoints(context)`

计算积分数量。

**参数：**
- `context` (Object): 计算上下文
  - `orderAmount` (Number): 订单金额
  - `customValue` (Number): 自定义值

**返回：** Number

**计算逻辑：**

```javascript
// 固定积分
if (calculationType === 'fixed') {
  points = fixedAmount;
}

// 百分比积分
if (calculationType === 'percentage') {
  points = Math.floor(orderAmount * percentage / 100);
}

// 分层积分
if (calculationType === 'tiered') {
  for (const tier of tiers) {
    if (orderAmount >= tier.minAmount && 
        (!tier.maxAmount || orderAmount <= tier.maxAmount)) {
      points = tier.points * (tier.multiplier || 1);
      break;
    }
  }
}

// 公式计算
if (calculationType === 'formula') {
  // 支持简单的数学表达式
  points = eval(formula.replace(/orderAmount/g, orderAmount));
}

// 应用倍率和限制
points = Math.floor(points * multiplier);
points = Math.max(points, minPoints || 0);
points = Math.min(points, maxPoints || Infinity);
```

### `recordUsage(pointsIssued)`

记录使用统计。

**参数：**
- `pointsIssued` (Number): 发放的积分数量

**返回：** Promise\<PointsRule\>

## 数据验证

### 自动验证

- 计算方式验证：必须指定对应的配置参数
- 百分比范围验证：0-100之间
- 分层配置验证：金额范围合理性
- 时间范围验证：开始时间小于结束时间

### 业务规则

- 优先级越高的规则优先匹配
- 同一用户同一规则频率限制
- 规则有效期内才能使用
- A/B测试流量分配合理

## 使用示例

### 创建订单积分规则

```javascript
const orderRule = new PointsRule({
  name: '订单完成积分奖励',
  type: 'order_completion',
  pointsConfig: {
    calculationType: 'percentage',
    percentage: 1, // 订单金额的1%
    minPoints: 1,
    maxPoints: 1000
  },
  conditions: {
    minOrderAmount: 50, // 最低50元
    membershipLevels: ['gold', 'platinum'] // 仅限金卡和白金卡用户
  },
  frequency: {
    limitType: 'unlimited'
  },
  validity: {
    pointsValidityDays: 365 // 积分1年有效
  },
  createdBy: adminId
});
```

### 创建分层积分规则

```javascript
const tieredRule = new PointsRule({
  name: '分层订单积分',
  type: 'order_amount',
  pointsConfig: {
    calculationType: 'tiered',
    tiers: [
      { minAmount: 0, maxAmount: 100, points: 10 },
      { minAmount: 100, maxAmount: 500, points: 50 },
      { minAmount: 500, points: 200 }
    ]
  }
});
```

### 获取适用规则

```javascript
const context = {
  type: 'order_completion',
  userId: user._id,
  orderAmount: 150,
  storeId: store._id,
  userMembershipLevel: 'gold',
  userOrderCount: 5
};

const applicableRules = await PointsRule.getApplicableRules(context);
const rule = applicableRules[0]; // 获取最高优先级规则
const points = rule.calculatePoints(context);
```

### 检查频率限制

```javascript
const isAllowed = await PointsRule.checkFrequencyLimit(
  rule._id,
  userId,
  rule.frequency
);

if (isAllowed) {
  // 可以获得积分
  const points = rule.calculatePoints(context);
} else {
  // 超出频率限制
  console.log('超出使用频率限制');
}
```

## 条件匹配逻辑

### 订单金额条件

```javascript
if (conditions.minOrderAmount && orderAmount < conditions.minOrderAmount) {
  return false;
}
if (conditions.maxOrderAmount && orderAmount > conditions.maxOrderAmount) {
  return false;
}
```

### 时间条件

```javascript
const now = new Date();

// 检查星期几
if (conditions.timeRestrictions?.dayOfWeek?.length > 0) {
  if (!conditions.timeRestrictions.dayOfWeek.includes(now.getDay())) {
    return false;
  }
}

// 检查小时范围
if (conditions.timeRestrictions?.hourOfDay) {
  const hour = now.getHours();
  const { start, end } = conditions.timeRestrictions.hourOfDay;
  if (start <= end) {
    if (hour < start || hour > end) return false;
  } else {
    // 跨天情况
    if (hour < start && hour > end) return false;
  }
}
```

### 频率限制检查

```javascript
const PointsTransaction = require('../pointsTransactionModel');

const usageCount = await PointsTransaction.countDocuments({
  userId,
  'ruleInfo.ruleId': ruleId,
  createdAt: { $gte: periodStartDate },
  status: 'completed'
});

return usageCount < frequency.limitCount;
```

## 关联关系

### 多对一关系

- `createdBy` → User (创建者)
- `lastModifiedBy` → User (修改者)
- `abTestConfig.controlRuleId` → PointsRule (对照规则)

### 业务关联

- 与积分交易记录关联
- 与用户行为事件关联
- 与商品类别系统关联
- 与门店系统关联

## A/B测试支持

### 测试流程

```javascript
// 1. 创建测试规则
const testRule = new PointsRule({
  name: '测试规则A',
  abTestConfig: {
    isTestRule: true,
    testGroup: 'A',
    testPercentage: 50,
    controlRuleId: originalRule._id
  }
});

// 2. 根据用户分组选择规则
const userGroup = getUserTestGroup(userId);
const rule = (userGroup === 'A') ? testRule : originalRule;

// 3. 统计测试效果
const testStats = await PointsRule.getUsageReport({
  ruleType: 'order_completion',
  startDate: testStartDate
});
```

## 性能优化

1. **规则缓存**：热门规则内存缓存
2. **条件预筛选**：快速排除不匹配的规则
3. **批量验证**：批量检查频率限制
4. **索引优化**：合理的复合索引设计

## 注意事项

1. **规则优先级**：高优先级规则优先匹配
2. **向后兼容**：规则变更要考虑历史数据
3. **测试验证**：新规则要充分测试
4. **监控告警**：异常积分发放的监控
5. **审计日志**：规则变更的完整记录