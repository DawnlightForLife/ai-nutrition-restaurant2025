# 营养档案API文档

## 概述

- 基础路径: `/api/nutrition/profiles`
- 认证方式: 需要Bearer Token认证

## 数据模型

### NutritionProfile (营养档案)

```javascript
{
  _id: ObjectId,
  userId: ObjectId,              // 用户ID
  profileName: String,           // 档案名称
  gender: String,                // 性别: male/female/other
  ageGroup: String,              // 年龄段: under18/18to25/26to35/36to45/46to55/56to65/above65
  height: Number,                // 身高(cm)
  weight: Number,                // 体重(kg)
  activityLevel: String,         // 活动水平: sedentary/light/moderate/active/very_active/professional
  activityLevelDetail: String,   // 活动水平详情
  bodyFatPercentage: Number,     // 体脂率(%)
  
  // 饮食偏好
  dietaryPreferences: {
    dietaryType: String,         // 饮食类型
    cuisinePreferences: [String], // 菜系偏好
    ethnicDietary: String,       // 民族饮食
    religiousDietary: String,    // 宗教饮食
    tastePreferences: {          // 口味偏好
      spicy: Number,             // 辣度偏好(0-4)
      salty: Number,             // 咸淡偏好(0-2)
      sweet: Number,             // 甜度偏好(0-2)
      sour: Number,              // 酸度偏好(0-2)
      oily: Number               // 油腻程度(0-2)
    },
    taboos: [String],            // 忌口食材
    allergies: [String],         // 过敏食材
    specialRequirements: [String] // 特殊饮食需求
  },
  
  // 生活方式
  lifestyle: {
    smoking: Boolean,
    drinking: Boolean,
    sleepDuration: Number,
    exerciseFrequency: String,
    exerciseTypes: [String],
    trainingIntensity: String,
    weeklyExerciseHours: Number,
    preferredExerciseTime: String
  },
  
  // 营养目标
  nutritionGoals: [String],       // 营养目标
  
  // 健康目标详细配置
  healthGoalDetails: {
    bloodSugarControl: {...},     // 血糖控制
    bloodPressureControl: {...},  // 血压管理
    cholesterolManagement: {...}, // 血脂管理
    weightManagement: {...},      // 体重管理
    sportsNutrition: {...},       // 运动营养
    specialPhysiological: {...},  // 特殊生理期
    digestiveHealth: {...},       // 消化健康
    immunityBoost: {...}          // 免疫与抗炎
  },
  
  isPrimary: Boolean,            // 是否为主要档案
  archived: Boolean,             // 是否已归档
  createdAt: Date,
  updatedAt: Date
}
```

## 接口列表

### 1. 获取所有营养档案列表

```
GET /api/nutrition/profiles
```

**响应示例:**
```json
{
  "success": true,
  "profiles": [...]
}
```

### 2. 获取单个营养档案

```
GET /api/nutrition/profiles/:id
```

**响应示例:**
```json
{
  "success": true,
  "profile": {...}
}
```

### 3. 获取用户的所有营养档案

```
GET /api/nutrition/profiles/user/:userId
```

**响应示例:**
```json
{
  "success": true,
  "profiles": [...]
}
```

### 4. 创建营养档案

```
POST /api/nutrition/profiles
```

**请求体示例:**
```json
{
  "profileName": "主要档案",
  "gender": "male",
  "ageGroup": "26to35",
  "height": 175,
  "weight": 70,
  "activityLevel": "moderate",
  "dietaryPreferences": {
    "dietaryType": "omnivore",
    "cuisinePreferences": ["sichuan", "cantonese"],
    "tastePreferences": {
      "spicy": 2,
      "salty": 1,
      "sweet": 1,
      "sour": 1,
      "oily": 1
    }
  },
  "nutritionGoals": ["weight_loss", "blood_sugar_control"]
}
```

### 5. 更新营养档案

```
PUT /api/nutrition/profiles/:id
```

**请求体:** 与创建接口相同的数据结构

### 6. 删除营养档案

```
DELETE /api/nutrition/profiles/:id
```

### 7. 设置为主要档案

```
PUT /api/nutrition/profiles/:id/primary
```

### 8. 获取档案完成度统计

```
GET /api/nutrition/profiles/stats/completion
```

**响应示例:**
```json
{
  "success": true,
  "data": {
    "completionPercentage": 75,
    "missingInfo": ["体脂率", "饮食偏好"],
    "profileId": "...",
    "lastUpdated": "2024-01-15T10:30:00Z"
  }
}
```

### 9. 获取AI推荐数据

```
GET /api/nutrition/profiles/ai/data
```

### 10. 验证档案数据

```
POST /api/nutrition/profiles/validate
```

**请求体:** 营养档案数据

**响应示例:**
```json
{
  "success": true,
  "isValid": false,
  "errors": ["BMI值不在合理范围内，请检查身高体重数据"]
}
```

### 11. 更新健康目标详细配置

```
PUT /api/nutrition/profiles/:id/health-goals
```

**请求体示例:**
```json
{
  "healthGoalDetails": {
    "bloodSugarControl": {
      "fastingGlucose": 6.2,
      "postprandialGlucose": 8.5,
      "hba1c": 5.8,
      "diabetesType": "type2",
      "medicationStatus": "oral",
      "monitoringFrequency": "daily"
    }
  }
}
```

### 12. 获取档案完整度详情

```
GET /api/nutrition/profiles/:id/completeness
```

**响应示例:**
```json
{
  "success": true,
  "data": {
    "profileId": "...",
    "completeness": 85,
    "recommendations": [
      "建议完善饮食偏好信息",
      "建议添加运动习惯信息"
    ]
  }
}
```

### 13. 获取营养档案模板

```
GET /api/nutrition/nutrition-profiles-extended/templates
```

**响应示例:**
```json
{
  "success": true,
  "templates": {
    "diabetic": { 
      "name": "糖尿病患者",
      "data": { ... }
    },
    "fitness": { 
      "name": "健身增肌",
      "data": { ... }
    },
    "pregnancy": { 
      "name": "孕期营养",
      "data": { ... }
    },
    "weightLoss": { 
      "name": "健康减重",
      "data": { ... }
    }
  }
}
```

### 14. 验证健康目标配置一致性

```
POST /api/nutrition/nutrition-profiles-extended/validate-health-goals
```

**请求体:**
```json
{
  "nutritionGoals": ["blood_sugar_control"],
  "healthGoalDetails": {
    "bloodSugarControl": {
      "diabetesType": "type2",
      "medicationStatus": "oral"
    }
  }
}
```

### 15. 智能冲突检测

```
POST /api/nutrition/nutrition-profiles-extended/detect-conflicts
```

**请求体:** 营养档案数据

**响应示例:**
```json
{
  "success": true,
  "hasConflicts": true,
  "conflicts": [
    {
      "type": "goal",
      "message": "减重和增肌目标存在冲突，建议选择塑形目标"
    }
  ]
}
```

### 16. 基于目标生成建议

```
POST /api/nutrition/nutrition-profiles-extended/generate-suggestions
```

**请求体:**
```json
{
  "nutritionGoals": ["weight_loss"],
  "activityLevel": "moderate",
  "gender": "male",
  "ageGroup": "26to35"
}
```

**响应示例:**
```json
{
  "success": true,
  "suggestions": {
    "dietaryType": ["low_carb", "mediterranean"],
    "tastePreferences": {
      "sweet": 0,
      "oily": 1
    },
    "dailyCalorieTarget": 1800,
    "macroRatios": {
      "protein": 0.3,
      "fat": 0.35,
      "carbs": 0.35
    }
  }
}
```

## 枚举类型

### 性别 (gender)
- `male` - 男
- `female` - 女  
- `other` - 其他

### 年龄段 (ageGroup)
- `under18` - 18岁以下
- `18to25` - 18-25岁
- `26to35` - 26-35岁
- `36to45` - 36-45岁
- `46to55` - 46-55岁
- `56to65` - 56-65岁
- `above65` - 65岁以上

### 活动水平 (activityLevel)
- `sedentary` - 久坐生活（每天活动<30分钟）
- `light` - 轻度活动（每天30-60分钟）
- `moderate` - 中度活动（每天1-2小时）
- `active` - 高强度活动（每天2-3小时）
- `very_active` - 极高强度活动（每天>3小时）
- `professional` - 专业运动员

### 活动水平详情 (activityLevelDetail)
- `less_than_30min` - 久坐办公（每天活动<30分钟）
- `30_to_60min` - 轻度活动（每天30-60分钟）
- `1_to_2hours` - 中度活动（每天1-2小时）
- `2_to_3hours` - 高强度活动（每天2-3小时）
- `more_than_3hours` - 极高强度（每天>3小时）
- `professional_athlete` - 专业运动员

### 饮食类型 (dietaryType)
- `omnivore` - 杂食
- `vegetarian` - 素食
- `vegan` - 纯素食
- `pescatarian` - 鱼素食
- `flexitarian` - 弹性素食
- `keto` - 生酮饮食
- `low_carb` - 低碳水
- `mediterranean` - 地中海饮食

### 菜系偏好 (cuisinePreferences)
#### 八大菜系
- `sichuan` - 川菜
- `cantonese` - 粤菜
- `shandong` - 鲁菜
- `jiangsu` - 苏菜
- `zhejiang` - 浙菜
- `fujian` - 闽菜
- `hunan` - 湘菜
- `anhui` - 徽菜

#### 地方特色
- `northeast` - 东北菜
- `northwest` - 西北菜
- `yunnan` - 云南菜
- `guizhou` - 贵州菜
- `jiangxi` - 江西菜
- `taiwan` - 台湾菜
- `beijing` - 京菜
- `shanghai` - 沪菜
- `xinjiang` - 新疆菜
- `tibet` - 藏菜
- `inner_mongolia` - 内蒙菜

### 民族饮食 (ethnicDietary)
- `han` - 汉族
- `hui` - 回族	
- `tibetan` - 藏族
- `uyghur` - 维吾尔族
- `mongolian` - 蒙古族

### 宗教饮食 (religiousDietary)
- `halal` - 清真饮食
- `buddhist` - 佛教素食
- `hindu` - 印度教饮食
- `jewish` - 犹太洁食

### 营养目标 (nutritionGoals)
- `weight_loss` - 减重
- `weight_gain` - 增重
- `fat_loss` - 减脂
- `muscle_gain` - 增肌
- `blood_sugar_control` - 血糖控制
- `blood_pressure_control` - 血压管理
- `cholesterol_management` - 血脂管理
- `sports_performance` - 运动表现
- `gut_health` - 肠道健康
- `immunity_boost` - 提升免疫力

### 口味强度级别

#### 辣度 (spicy: 0-4)
- 0 - 不吃辣
- 1 - 微辣
- 2 - 中辣
- 3 - 特辣
- 4 - 变态辣

#### 咸淡 (salty: 0-2)
- 0 - 清淡
- 1 - 适中
- 2 - 偏咸

#### 甜度 (sweet: 0-2)
- 0 - 不喜甜
- 1 - 微甜
- 2 - 嗜甜

#### 酸度 (sour: 0-2)
- 0 - 不喜酸
- 1 - 适度
- 2 - 嗜酸

#### 油腻程度 (oily: 0-2)
- 0 - 少油
- 1 - 适中
- 2 - 重油

## 错误响应

所有接口的错误响应格式如下:

```json
{
  "success": false,
  "message": "错误信息",
  "error": "详细错误描述"
}
```

状态码:
- `400` - 请求参数错误
- `401` - 未授权
- `403` - 无权限
- `404` - 资源不存在
- `500` - 服务器错误