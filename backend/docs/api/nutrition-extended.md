# 营养档案扩展API文档

## 新增端点

### 1. 获取营养档案模板

```
GET /api/nutrition/nutrition-profiles-extended/templates
```

获取预设的营养档案模板，帮助用户快速创建档案。

**响应示例:**
```json
{
  "success": true,
  "templates": {
    "diabetic": { 
      "name": "糖尿病患者",
      "data": {
        "nutritionGoals": ["blood_sugar_control"],
        "healthGoalDetails": {
          "bloodSugarControl": {
            "diabetesType": "type2",
            "medicationStatus": "oral",
            "monitoringFrequency": "daily"
          }
        }
      }
    },
    "fitness": { 
      "name": "健身增肌",
      "data": {
        "nutritionGoals": ["muscle_gain", "sports_performance"],
        "activityLevel": "very_active",
        "activityLevelDetail": "more_than_3hours"
      }
    },
    "pregnancy": { 
      "name": "孕期营养",
      "data": {
        "gender": "female",
        "nutritionGoals": ["pregnancy"]
      }
    },
    "weightLoss": { 
      "name": "健康减重",
      "data": {
        "nutritionGoals": ["weight_loss", "fat_loss"]
      }
    }
  }
}
```

### 2. 验证健康目标配置一致性

```
POST /api/nutrition/nutrition-profiles-extended/validate-health-goals
```

验证所选健康目标与详细配置是否一致。

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

**响应:**
```json
{
  "success": true,
  "message": "健康目标配置验证通过"
}
```

### 3. 智能冲突检测

```
POST /api/nutrition/nutrition-profiles-extended/detect-conflicts
```

检测营养档案中的配置冲突。

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
    },
    {
      "type": "dietary",
      "message": "清真饮食需要特殊的饮食限制"
    }
  ]
}
```

### 4. 基于目标生成建议

```
POST /api/nutrition/nutrition-profiles-extended/generate-suggestions
```

根据用户的健康目标和基本信息生成个性化建议。

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

## 新增枚举类型

### 活动水平详情 (activityLevelDetail)
- `less_than_30min` - 久坐办公（每天活动<30分钟）
- `30_to_60min` - 轻度活动（每天30-60分钟）
- `1_to_2hours` - 中度活动（每天1-2小时）
- `2_to_3hours` - 高强度活动（每天2-3小时）
- `more_than_3hours` - 极高强度（每天>3小时）
- `professional_athlete` - 专业运动员

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

### 运动类型 (exerciseTypes)
- **耐力运动**
  - `running` - 跑步
  - `cycling` - 骑行
  - `swimming` - 游泳
- **力量训练**
  - `gym` - 健身房训练
  - `bodyweight` - 自重训练
- **球类运动**
  - `basketball` - 篮球
  - `football` - 足球
  - `badminton` - 羽毛球
  - `table_tennis` - 乒乓球
  - `tennis` - 网球
- **搏击类**
  - `boxing` - 拳击
  - `martial_arts` - 武术
- **其他**
  - `yoga` - 瑜伽
  - `pilates` - 普拉提
  - `dance` - 舞蹈
  - `team_sports` - 团队运动
  - `outdoor` - 户外运动

### 训练强度 (trainingIntensity)
- `low` - 低强度
- `moderate` - 中等强度
- `high` - 高强度
- `very_high` - 极高强度

### 糖尿病类型 (diabetesType)
- `type1` - 1型糖尿病
- `type2` - 2型糖尿病
- `gestational` - 妊娠期糖尿病
- `none` - 无糖尿病

### 用药情况 (medicationStatus)
- `insulin` - 胰岛素
- `oral` - 口服药
- `diet_only` - 仅饮食控制
- `none` - 无用药

### 监测频率 (monitoringFrequency)
- `daily` - 每日
- `weekly` - 每周
- `monthly` - 每月

### 高血压分级 (hypertensionGrade)
- `normal` - 正常
- `elevated` - 偏高
- `stage1` - 1级高血压
- `stage2` - 2级高血压
- `stage3` - 3级高血压

### 体重管理目标类型 (targetType)
- `loss` - 减重
- `gain` - 增重
- `maintain` - 保持
- `recomposition` - 塑形

### 目标速度 (targetSpeed)
- `conservative` - 保守（0.5kg/周）
- `moderate` - 标准（1kg/周）
- `aggressive` - 激进（1.5kg/周）

### 训练阶段 (trainingPhase)
- `off_season` - 休赛期
- `pre_season` - 备赛期
- `competition` - 比赛期
- `recovery` - 恢复期

### 更年期阶段 (menopauseStage)
- `pre` - 更年期前期
- `peri` - 围绝经期
- `post` - 绝经后期

### 消化系统症状 (digestiveSymptoms)
- `bloating` - 腹胀
- `constipation` - 便秘
- `diarrhea` - 腹泻
- `acid_reflux` - 反酸
- `ibs` - 肠易激综合征
- `ibd` - 炎症性肠病

### 幽门螺杆菌状态 (hPyloriStatus)
- `positive` - 阳性
- `negative` - 阴性
- `unknown` - 未知

### 感染频率 (infectionFrequency)
- `rare` - 很少
- `occasional` - 偶尔
- `frequent` - 频繁