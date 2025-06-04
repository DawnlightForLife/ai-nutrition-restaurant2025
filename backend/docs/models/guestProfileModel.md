# 游客档案模型 (GuestProfile Model)

## 概述

游客档案模型用于管理未注册用户的营养档案信息。营养师可以为访客创建临时档案，访客可以通过绑定令牌将档案绑定到正式用户账号。

## 业务场景

- 营养师为线下咨询客户创建临时档案
- 用户注册前的营养评估和推荐
- 游客账号转正式用户的数据迁移
- 营养档案的临时存储和管理

## 数据结构

### 主要字段

| 字段名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| guestId | String | ✓ | 自动生成 | 游客唯一标识，格式：guest_xxxxxxxx |
| profileData | Object | ✓ | - | 营养档案数据 |
| createdBy | ObjectId | ✓ | - | 创建者（营养师）ID |
| bindingToken | String | - | 自动生成 | 绑定令牌，用于账号绑定 |
| bindingStatus | String | - | pending | 绑定状态：pending/bound/expired |
| boundUserId | ObjectId | - | - | 绑定的用户ID |
| expiresAt | Date | - | 7天后 | 自动过期时间 |
| isDeleted | Boolean | - | false | 软删除标记 |

### 营养档案数据结构 (profileData)

```javascript
{
  // 基本信息
  age: Number,           // 年龄 (0-150)
  gender: String,        // 性别：male/female/other
  height: Number,        // 身高(cm) (50-300)
  weight: Number,        // 体重(kg) (20-500)
  activityLevel: String, // 活动水平：sedentary/light/moderate/active/very_active
  
  // 健康目标
  healthGoals: [String], // 健康目标数组
  
  // 饮食偏好
  dietaryPreferences: [String], // 饮食偏好数组
  
  // 过敏信息
  allergies: [{
    allergen: String,    // 过敏原名称
    severity: String     // 严重程度：mild/moderate/severe
  }],
  
  // 疾病史
  medicalConditions: [{
    condition: String,   // 疾病名称
    diagnosed: Date,     // 诊断日期
    severity: String     // 严重程度：mild/moderate/severe
  }]
}
```

### 访问日志 (accessLogs)

```javascript
[{
  timestamp: Date,       // 访问时间
  ipAddress: String,     // IP地址
  userAgent: String,     // 用户代理
  action: String         // 操作类型：created/viewed/updated/bound
}]
```

## 索引设计

### 主要索引

```javascript
// 主键索引
{ _id: 1 }

// 游客ID唯一索引
{ guestId: 1 }

// 绑定令牌稀疏索引
{ bindingToken: 1 }

// 创建者和时间复合索引
{ createdBy: 1, createdAt: -1 }

// TTL过期索引
{ expiresAt: 1 }, { expireAfterSeconds: 0 }
```

### 性能考量

- `guestId` 字段使用唯一索引，支持快速查找
- `bindingToken` 使用稀疏索引，节省存储空间
- TTL索引自动清理过期数据
- 复合索引优化营养师档案列表查询

## 静态方法

### `generateGuestId()`

生成唯一的游客ID。

```javascript
// 返回格式：guest_xxxxxxxx
const guestId = GuestProfile.generateGuestId();
```

### `generateBindingToken()`

生成绑定令牌。

```javascript
// 返回32字符的随机令牌
const token = GuestProfile.generateBindingToken();
```

### `createGuestProfile(profileData, createdBy, options)`

创建游客档案。

**参数：**
- `profileData` (Object): 营养档案数据
- `createdBy` (ObjectId): 创建者ID
- `options` (Object): 可选参数
  - `ipAddress` (String): IP地址
  - `userAgent` (String): 用户代理

**返回：** Promise\<GuestProfile\>

### `findByBindingToken(token)`

通过绑定令牌查找有效档案。

**参数：**
- `token` (String): 绑定令牌

**返回：** Promise\<GuestProfile|null\>

## 实例方法

### `bindToUser(userId, options)`

绑定档案到正式用户。

**参数：**
- `userId` (ObjectId): 用户ID
- `options` (Object): 可选参数

**返回：** Promise\<GuestProfile\>

### `logAccess(action, options)`

记录访问日志。

**参数：**
- `action` (String): 操作类型
- `options` (Object): 访问信息

**返回：** Promise\<GuestProfile\>

### `calculateNutritionNeeds()`

计算营养需求。

**返回：** Object|null

```javascript
{
  bmr: Number,      // 基础代谢率
  tdee: Number,     // 总消耗
  protein: Number,  // 蛋白质需求(g)
  carbs: Number,    // 碳水化合物需求(g)
  fat: Number,      // 脂肪需求(g)
  fiber: Number     // 纤维需求(g)
}
```

## 数据验证

### 自动验证

- 年龄范围：0-150岁
- 身高范围：50-300cm
- 体重范围：20-500kg
- BMI合理性：10-50

### 业务规则

- 只有营养师和管理员可以创建游客档案
- 绑定令牌7天有效
- 档案数据自动过期删除
- 访问日志最多保留20条

## 使用示例

### 创建游客档案

```javascript
const profileData = {
  age: 25,
  gender: 'female',
  height: 165,
  weight: 55,
  activityLevel: 'moderate',
  healthGoals: ['weight_loss'],
  dietaryPreferences: ['vegetarian'],
  allergies: [{
    allergen: '花生',
    severity: 'severe'
  }]
};

const guestProfile = await GuestProfile.createGuestProfile(
  profileData,
  nutritionistId,
  { ipAddress: '192.168.1.1' }
);
```

### 绑定到用户

```javascript
const guestProfile = await GuestProfile.findByBindingToken(token);
if (guestProfile) {
  await guestProfile.bindToUser(userId);
}
```

### 计算营养需求

```javascript
const guestProfile = await GuestProfile.findOne({ guestId });
const nutritionNeeds = guestProfile.calculateNutritionNeeds();
console.log(nutritionNeeds);
// { bmr: 1200, tdee: 1860, protein: 44, carbs: 209, fat: 52, fiber: 25 }
```

## 关联关系

### 多对一关系

- `createdBy` → User (营养师)
- `boundUserId` → User (绑定用户)

### 业务关联

- 与营养推荐系统集成
- 支持用户注册流程
- 数据迁移到正式档案

## 注意事项

1. **隐私保护**：游客档案包含敏感健康信息，需严格权限控制
2. **数据过期**：默认7天自动过期，避免数据累积
3. **绑定唯一性**：每个令牌只能绑定一次
4. **访问记录**：完整的操作审计日志
5. **数据迁移**：绑定时智能合并已有档案数据