# 数据库模型冻结文档

## 版本: 3.0
## 日期: 2024-04-15
## 状态: 已冻结

本文档描述了AI营养餐厅应用的数据库模型设计，作为开发团队的规范参考。所有模型结构在此版本中已冻结，任何更改必须通过变更管理流程审批。

---

## 核心用户模块

### User 模型
用户账户信息，包含认证和基本个人信息。

```javascript
{
  _id: ObjectId,                        // 用户唯一标识
  phone: String,                        // 手机号（唯一，用于登录）
  password: String,                     // 加密密码
  username: String,                     // 用户名
  nickname: String,                     // 昵称
  email: String,                        // 电子邮件
  avatar: String,                       // 头像URL
  gender: String,                       // 性别：male/female/other
  birthdate: Date,                      // 出生日期
  role: String,                         // 角色：user/nutritionist/merchant/admin
  address: {                            // 地址信息
    province: String,
    city: String,
    district: String,
    street: String,
    detail: String
  },
  verified: Boolean,                    // 是否已验证
  active: Boolean,                      // 账户是否活跃
  preferences: {                        // 用户偏好设置
    language: String,
    notification: {
      push: Boolean,
      email: Boolean,
      sms: Boolean
    },
    privacy: {
      share_data: Boolean,
      location_tracking: Boolean
    }
  },
  last_login: Date,                     // 最后登录时间
  created_at: Date,                     // 创建时间
  updated_at: Date                      // 更新时间
}
```

---

## 健康与营养模块

### NutritionProfile 模型
用户的营养档案，记录用户健康状况和饮食偏好。

```javascript
{
  _id: ObjectId,                        // 档案唯一标识
  userId: String,                       // 用户ID（字符串格式）
  user_id: ObjectId,                    // 用户ID关联
  nickname: String,                     // 档案昵称
  gender: String,                       // 性别：male/female/other
  ageGroup: String,                     // 年龄段：under_18/18_30/31_45/46_60/above_60
  height: Number,                       // 身高（cm）
  weight: Number,                       // 体重（kg）
  region: {                             // 地区信息
    province: String,
    city: String,
    district: String
  },
  occupation: String,                   // 职业：student/office_worker/physical_worker/retired/other
  healthStatus: {                       // 健康状况
    chronicDiseases: [String],          // 慢性疾病：hypertension/diabetes/gout/heart_disease/none
    specialConditions: [String]         // 特殊状况：pregnancy/lactation/menopause/none
  },
  dietaryPreferences: {                 // 饮食偏好
    isVegetarian: Boolean,              // 是否素食
    tastePreference: [String],          // 口味偏好：light/spicy/sour/sweet/salty
    taboos: [String],                   // 忌口食材
    cuisine: String,                    // 菜系偏好：chinese/western/japanese/korean/other
    allergies: [String]                 // 过敏食材
  },
  lifestyle: {                          // 生活方式
    smoking: Boolean,                   // 是否吸烟
    drinking: Boolean,                  // 是否饮酒
    sleepDuration: Number,              // 睡眠时长（小时）
    exerciseFrequency: String           // 运动频率：none/occasional/regular/frequent/daily
  },
  nutritionGoals: [String],             // 营养目标：weight_loss/weight_gain/muscle_gain等
  health_metrics: {                     // 健康指标
    bmi: Number,                        // 体质指数
    blood_pressure: {                   // 血压
      systolic: Number,                 // 收缩压
      diastolic: Number,                // 舒张压
      measured_at: Date                 // 测量时间
    },
    blood_glucose: {                    // 血糖
      value: Number,                    // 血糖值
      measured_at: Date                 // 测量时间
    }
  },
  isPrimary: Boolean,                   // 是否为主档案
  related_health_data: [ObjectId],      // 关联的健康数据
  privacy_settings: {                   // 隐私设置
    share_with_nutritionist: Boolean,   // 是否共享给营养师
    use_for_ai_recommendation: Boolean, // 是否用于AI推荐
    use_for_merchants: Boolean          // 是否在商家下单时使用
  },
  access_grants: [{                     // 授权记录
    granted_to: ObjectId,               // 被授权者ID
    granted_to_type: String,            // 被授权者类型：Nutritionist/Merchant
    granted_at: Date,                   // 授权时间
    valid_until: Date,                  // 有效期至
    reason: String,                     // 授权原因
    revoked: Boolean,                   // 是否已撤销
    revoked_at: Date                    // 撤销时间
  }],
  created_at: Date,                     // 创建时间
  updated_at: Date                      // 更新时间
}
```

### HealthData 模型
用户健康数据，包含详细的健康指标和体检报告。

```javascript
{
  _id: ObjectId,                         // 唯一标识
  user_id: ObjectId,                     // 用户ID关联
  userId: String,                        // 用户ID（字符串格式）
  nutrition_profile_id: ObjectId,        // 营养档案ID
  nutritionProfileId: String,            // 营养档案ID（字符串格式）
  profile_info: {                        // 基本档案信息
    nickname: String,                    // 昵称
    gender: String,                      // 性别：male/female/other
    age_group: String,                   // 年龄段：under_18/18_30/31_45/46_60/above_60
    region: {                            // 地区信息
      province: String,
      city: String,
      district: String
    },
    occupation: String                   // 职业：student/office_worker/physical_worker/retired/other
  },
  basic_metrics: {                       // 基本健康数据
    height: Number,                      // 身高（cm）
    weight: Number,                      // 体重（kg）
    bmi: Number,                         // 体质指数
    blood_pressure: {                    // 血压
      systolic: Number,                  // 收缩压
      diastolic: Number                  // 舒张压
    },
    heart_rate: Number                   // 心率
  },
  health_status: {                       // 健康状况
    chronic_diseases: [String],          // 慢性疾病：hypertension/diabetes/gout/heart_disease/none
    special_conditions: [String]         // 特殊状况：pregnancy/lactation/menopause/none
  },
  dietary_preferences: {                 // 饮食偏好
    is_vegetarian: Boolean,              // 是否素食
    taste_preference: [String],          // 口味偏好：light/spicy/sour/sweet/salty
    taboos: [String],                    // 忌口食材
    cuisine: String,                     // 菜系偏好：chinese/western/japanese/korean/other
    allergies: [String]                  // 过敏食材
  },
  lifestyle: {                           // 生活方式
    smoking: Boolean,                    // 是否吸烟
    drinking: Boolean,                   // 是否饮酒
    sleep_duration: Number,              // 睡眠时长（小时）
    exercise_frequency: String           // 运动频率：none/occasional/regular/frequent/daily
  },
  nutrition_goals: [String],             // 营养目标
  blood_metrics: {                       // 血液指标（加密存储）
    cholesterol: {                       // 胆固醇
      total: String,                     // 总胆固醇
      hdl: String,                       // 高密度脂蛋白
      ldl: String,                       // 低密度脂蛋白
      triglycerides: String              // 甘油三酯
    },
    glucose: {                           // 血糖
      fasting: String,                   // 空腹血糖
      after_meal: String,                // 餐后血糖
      hba1c: String                      // 糖化血红蛋白
    },
    liver: {                             // 肝功能
      alt: Number,                       // 丙氨酸氨基转移酶
      ast: Number,                       // 天冬氨酸氨基转移酶
      alp: Number                        // 碱性磷酸酶
    },
    kidney: {                            // 肾功能
      creatinine: Number,                // 肌酐
      urea: Number                       // 尿素
    },
    electrolytes: {                      // 电解质
      sodium: Number,                    // 钠
      potassium: Number,                 // 钾
      calcium: Number,                   // 钙
      magnesium: Number                  // 镁
    },
    blood_count: {                       // 血常规
      wbc: Number,                       // 白细胞
      rbc: Number,                       // 红细胞
      hemoglobin: Number,                // 血红蛋白
      platelets: Number                  // 血小板
    }
  },
  medical_report: {                      // 医疗报告
    ocr_image_url: String,               // OCR图像URL
    ocr_processing_status: String,       // OCR处理状态：pending/processing/completed/failed
    ocr_raw_text: String,                // OCR原始文本
    report_date: Date,                   // 报告日期
    hospital_name: String,               // 医院名称
    diagnosis: String                    // 诊断信息（加密存储）
  },
  health_advice: {                      // 健康建议
    nutrition_suggestions: [String],     // 营养建议
    lifestyle_changes: [String],         // 生活方式改变建议
    exercise_plan: String,              // 运动计划
    diet_restrictions: [String],        // 饮食限制
    recommended_supplements: [String],   // 推荐营养补充剂
    monitoring_plan: String             // 健康监测计划
  },
  analysis_history: [{                  // 分析历史
    analyzed_at: Date,                  // 分析时间
    analyzer_type: String,              // 分析器类型：ai/human
    analyzer_id: String,                // 分析者ID
    results: String,                    // 分析结果
    recommendations: String             // 建议
  }],
  privacy_level: String,                 // 隐私级别：high/medium/low
  synced_to_profile: Boolean,            // 是否已同步到营养档案
  sync_history: [{                      // 同步历史
    synced_at: Date,                    // 同步时间
    profile_id: ObjectId,               // 营养档案ID
    sync_type: String,                  // 同步类型：manual/automatic
    sync_status: String,                // 同步状态：success/failed
    sync_details: String                // 同步详情
  }],
  data_source: {                        // 数据来源
    source_type: String,                // 来源类型：manual/import/device
    device_info: String,                // 设备信息
    app_version: String,                // 应用版本
    import_file: String                 // 导入文件
  },
  validation: {                         // 数据验证
    is_validated: Boolean,              // 是否已验证
    validated_by: String,               // 验证者：system/professional/user
    validation_date: Date,              // 验证日期
    validation_method: String           // 验证方法
  },
  created_at: Date,                      // 创建时间
  updated_at: Date                       // 更新时间
}
```

---

## 餐厅与菜品模块

### Merchant 模型
商家信息，包含餐厅基本信息和运营数据。

```javascript
{
  _id: ObjectId,                        // 商家唯一标识
  user_id: ObjectId,                    // 关联的用户账户
  name: String,                         // 商家名称
  logo: String,                         // 商家logo URL
  banner: String,                       // 商家banner URL
  description: String,                  // 商家描述
  business_license: String,             // 营业执照号
  contact: {                            // 联系信息
    phone: String,                      // 联系电话
    email: String,                      // 联系邮箱
    contact_person: String              // 联系人
  },
  location: {                           // 位置信息
    province: String,                   // 省份
    city: String,                       // 城市
    district: String,                   // 区县
    address: String,                    // 详细地址
    coordinates: {                      // 坐标信息
      latitude: Number,                 // 纬度
      longitude: Number                 // 经度
    }
  },
  business_hours: [{                    // 营业时间
    day: Number,                        // 星期几（0-6）
    open: String,                       // 开始时间（HH:MM）
    close: String                       // 结束时间（HH:MM）
  }],
  cuisine_type: [String],               // 菜系类型
  features: [String],                   // 特色服务
  avg_price: Number,                    // 人均价格
  rating: Number,                       // 评分
  status: String,                       // 商家状态：active/pending/suspended
  ai_recommendation_enabled: Boolean,   // 是否启用AI推荐
  verification: {                       // 验证信息
    is_verified: Boolean,               // 是否已验证
    verified_at: Date,                  // 验证时间
    verified_by: ObjectId               // 验证人
  },
  subscription: {                       // 订阅信息
    plan: String,                       // 订阅计划
    start_date: Date,                   // 开始日期
    end_date: Date,                     // 结束日期
    auto_renew: Boolean                 // 是否自动续费
  },
  statistics: {                         // 统计数据
    total_orders: Number,               // 总订单数
    total_revenue: Number,              // 总收入
    avg_delivery_time: Number,          // 平均配送时间
    views: Number                       // 浏览量
  },
  created_at: Date,                     // 创建时间
  updated_at: Date                      // 更新时间
}
```

### Dish 模型
菜品信息，包含菜品基本信息和营养数据。

```javascript
{
  _id: ObjectId,                        // 菜品唯一标识
  merchant_id: ObjectId,                // 所属商家ID
  name: String,                         // 菜品名称
  category: String,                     // 菜品分类
  price: Number,                        // 价格
  description: String,                  // 描述
  images: [String],                     // 图片URLs
  ingredients: [{                       // 配料表
    name: String,                       // 食材名称
    amount: String                      // 用量描述
  }],
  attributes: {                         // 菜品属性
    is_spicy: Boolean,                  // 是否辣
    is_vegetarian: Boolean,             // 是否素食
    is_new: Boolean,                    // 是否新品
    is_signature: Boolean,              // 是否招牌菜
    contains_nuts: Boolean,             // 是否含坚果
    contains_dairy: Boolean,            // 是否含乳制品
    contains_gluten: Boolean            // 是否含麸质
  },
  nutrition_facts: {                    // 营养成分
    calories: Number,                   // 卡路里
    protein: Number,                    // 蛋白质(g)
    fat: Number,                        // 脂肪(g)
    carbohydrates: Number,              // 碳水化合物(g)
    fiber: Number,                      // 纤维素(g)
    sugar: Number,                      // 糖(g)
    sodium: Number,                     // 钠(mg)
    cholesterol: Number,                // 胆固醇(mg)
    vitamins: {                         // 维生素
      a: Number,                        // 维生素A
      c: Number,                        // 维生素C
      d: Number,                        // 维生素D
      e: Number,                        // 维生素E
      k: Number,                        // 维生素K
      b6: Number,                       // 维生素B6
      b12: Number                       // 维生素B12
    },
    minerals: {                         // 矿物质
      calcium: Number,                  // 钙
      iron: Number,                     // 铁
      magnesium: Number,                // 镁
      potassium: Number,                // 钾
      zinc: Number                      // 锌
    }
  },
  health_benefits: [String],            // 健康益处
  suitable_for: [String],               // 适合人群
  contraindications: [String],          // 禁忌人群
  popularity: Number,                   // 受欢迎程度（0-100）
  available: Boolean,                   // 是否可用
  preparation_time: Number,             // 准备时间（分钟）
  ai_analyzed: Boolean,                 // 是否已AI分析
  ai_tags: [String],                    // AI分析标签
  created_at: Date,                     // 创建时间
  updated_at: Date                      // 更新时间
}
```

---

## AI推荐模块

### AiRecommendation 模型
AI推荐结果记录，包含推荐菜品和推荐原因。

```javascript
{
  _id: ObjectId,                        // 推荐唯一标识
  user_id: ObjectId,                    // 用户ID
  nutrition_profile_id: ObjectId,       // 营养档案ID
  recommendation_type: String,          // 推荐类型：dish/meal/recipe
  context: {                            // 推荐上下文
    location: {                         // 位置信息
      latitude: Number,
      longitude: Number
    },
    meal_time: String,                  // 餐点时间：breakfast/lunch/dinner/snack
    special_occasion: String,           // 特殊场合
    budget: Number,                     // 预算
    companions: Number,                 // 同行人数
    preferences: [String],              // 临时偏好
    constraints: [String]               // 临时限制
  },
  dishes: [{                            // 推荐菜品列表
    dish_id: ObjectId,                  // 菜品ID
    dish_name: String,                  // 菜品名称
    merchant_id: ObjectId,              // 商家ID
    merchant_name: String,              // 商家名称
    confidence_score: Number,           // 置信度分数（0-1）
    match_reason: String,               // 匹配原因
    nutrition_benefit: String,          // 营养益处
    health_benefit: String,             // 健康益处
    price: Number,                      // 价格
    calories: Number,                   // 卡路里
    protein: Number,                    // 蛋白质
    carbs: Number,                      // 碳水
    fat: Number,                        // 脂肪
    key_nutrients: [{                   // 关键营养素
      name: String,                     // 名称
      amount: Number,                   // 含量
      unit: String,                     // 单位
      daily_value_percentage: Number    // 每日推荐值百分比
    }]
  }],
  meal_plans: [{                        // 推荐套餐列表
    name: String,                       // 套餐名称
    description: String,                // 套餐描述
    duration_days: Number,              // 持续天数
    target_calories_per_day: Number,    // 每日目标卡路里
    target_protein_per_day: Number,     // 每日目标蛋白质
    target_carbs_per_day: Number,       // 每日目标碳水
    target_fat_per_day: Number,         // 每日目标脂肪
    daily_plans: [{                     // 每日计划
      day: Number,                      // 第几天
      meals: [{                         // 餐点
        meal_type: String,              // 餐点类型：breakfast/lunch/dinner/snack
        dishes: [{                      // 菜品
          dish_id: ObjectId,            // 菜品ID
          dish_name: String,            // 菜品名称
          merchant_id: ObjectId,        // 商家ID
          merchant_name: String,        // 商家名称
          confidence_score: Number,     // 置信度分数
          match_reason: String,         // 匹配原因
          nutrition_benefit: String,    // 营养益处
          health_benefit: String,       // 健康益处
          price: Number,                // 价格
          calories: Number,             // 卡路里
          protein: Number,              // 蛋白质
          carbs: Number,                // 碳水
          fat: Number                   // 脂肪
        }]
      }]
    }]
  }],
  overall_nutrition_analysis: String,   // 整体营养分析
  health_improvement_suggestions: String, // 健康改进建议
  user_feedback: {                      // 用户反馈
    rating: Number,                     // 评分（1-5）
    comments: String,                   // 评论
    followed: Boolean                   // 是否采纳推荐
  },
  created_at: Date,                     // 创建时间
  expires_at: Date                      // 过期时间
}
```

---

## 订单与交易模块

### Order 模型
订单信息，记录用户的订餐信息和状态。

```javascript
{
  _id: ObjectId,                        // 订单唯一标识
  user_id: ObjectId,                    // 用户ID
  merchant_id: ObjectId,                // 商家ID
  nutrition_profile_id: ObjectId,       // 营养档案ID
  ai_recommendation_id: ObjectId,       // AI推荐ID
  order_number: String,                 // 订单编号
  items: [{                             // 订单项目
    dish_id: ObjectId,                  // 菜品ID
    name: String,                       // 菜品名称
    price: Number,                      // 单价
    quantity: Number,                   // 数量
    options: [{                         // 选项
      name: String,                     // 选项名称
      value: String,                    // 选项值
      price: Number                     // 选项价格
    }],
    subtotal: Number                    // 小计
  }],
  total_amount: Number,                 // 总金额
  discount_amount: Number,              // 折扣金额
  final_amount: Number,                 // 最终金额
  payment: {                            // 支付信息
    method: String,                     // 支付方式
    status: String,                     // 支付状态
    transaction_id: String,             // 支付交易号
    paid_at: Date                       // 支付时间
  },
  status: String,                       // 订单状态
  delivery: {                           // 配送信息
    address: {                          // 配送地址
      province: String,
      city: String,
      district: String,
      street: String,
      detail: String
    },
    contact_name: String,               // 联系人
    contact_phone: String,              // 联系电话
    delivery_fee: Number,               // 配送费
    expected_time: Date,                // 预计送达时间
    actual_time: Date,                  // 实际送达时间
    tracking_number: String,            // 配送单号
    courier: {                          // 配送员信息
      name: String,                     // 配送员姓名
      phone: String                     // 配送员电话
    }
  },
  notes: String,                        // 订单备注
  health_notes: String,                 // 健康备注（基于营养档案）
  rating: {                             // 评价信息
    score: Number,                      // 评分（1-5）
    comment: String,                    // 评论
    rated_at: Date                      // 评价时间
  },
  created_at: Date,                     // 创建时间
  updated_at: Date                      // 更新时间
}
```

---

## 社区互动模块

### Post 模型
社区帖子，用于用户分享饮食经验和健康心得。

```javascript
{
  _id: ObjectId,                        // 帖子唯一标识
  author_id: ObjectId,                  // 作者ID
  author_name: String,                  // 作者名称
  title: String,                        // 标题
  content: String,                      // 内容
  images: [String],                     // 图片URLs
  tags: [String],                       // 标签
  category: String,                     // 分类
  related_dish_ids: [ObjectId],         // 相关菜品ID
  related_merchant_ids: [ObjectId],     // 相关商家ID
  view_count: Number,                   // 查看次数
  like_count: Number,                   // 点赞次数
  comment_count: Number,                // 评论次数
  share_count: Number,                  // 分享次数
  ai_analyzed: Boolean,                 // 是否已AI分析
  ai_tags: [String],                    // AI分析标签
  created_at: Date,                     // 创建时间
  updated_at: Date                      // 更新时间
}
```

### Comment 模型
评论信息，包含对帖子和菜品的评论。

```javascript
{
  _id: ObjectId,                        // 评论唯一标识
  post_id: ObjectId,                    // 帖子ID
  dish_id: ObjectId,                    // 菜品ID
  author_id: ObjectId,                  // 作者ID
  author_name: String,                  // 作者名称
  parent_id: ObjectId,                  // 父评论ID
  content: String,                      // 内容
  images: [String],                     // 图片URLs
  like_count: Number,                   // 点赞次数
  reply_count: Number,                  // 回复次数
  created_at: Date,                     // 创建时间
  updated_at: Date                      // 更新时间
}
```

---

## 变更日志

### 版本3.0（2024-04-15）
- 更新HealthData模型：添加健康建议、分析历史、同步历史、数据来源和验证字段
- 增强HealthData与NutritionProfile的同步功能：完善了双向同步和历史记录
- 添加了userId和nutritionProfileId字符串格式字段，便于跨服务查询

### 版本2.0（2023-10-20）
- 新增NutritionProfile模型：完善了档案字段，支持更详细的健康状况和饮食偏好
- 新增HealthData模型：支持健康数据的加密存储和与档案同步
- 优化AiRecommendation模型：增加了更多推荐上下文参数和反馈机制

### 版本1.0（2023-09-01）
- 初始版本：定义了基本用户、商家、菜品和社区交互模型 