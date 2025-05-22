# 数据库模型冻结文档

## 版本: 4.2
## 日期: 2025-06-10
## 状态: 已冻结

本文档描述了AI营养餐厅应用的数据库模型设计，作为开发团队的规范参考。所有模型结构在此版本中已冻结，任何更改必须通过变更管理流程审批。

## 一、系统架构

### 技术选择
- 数据库：MongoDB (版本: 6.0+)
- ODM：Mongoose (版本: 7.0+)
- 性能优化：读写分离、分片、缓存、批处理
- 复制集配置：1主2从配置，实现高可用
- 数据安全：字段级加密、访问控制、审计日志

### 核心组件
- **模型工厂**(modelFactory.js)：提供读写分离、缓存管理、批处理支持和错误处理
- **模型注册器**(modelRegistrar.js)：提供统一的模型注册接口，支持索引、插件和缓存配置
- **数据校验器**(validator.js)：提供通用的数据校验方法和自定义验证规则
- **模式守卫**(schemaGuardService.js)：提供模式结构验证、冻结和变更检测

### 目录结构
```
models/
├── analytics/          # 数据分析相关模型
├── common/             # 通用模型（文件、会话等）
├── consult/            # 咨询服务相关模型
├── core/               # 核心模型（权限等）
├── feedback/           # 用户反馈相关模型
├── forum/              # 论坛相关模型
├── merchant/           # 商家相关模型
├── notification/       # 通知系统相关模型
├── nutrition/          # 营养相关模型
├── order/              # 订单相关模型
├── promotion/          # 促销相关模型
├── security/           # 安全相关模型
├── user/               # 用户相关模型
├── index.js            # 模型导出入口
├── modelFactory.js     # 模型工厂
└── modelRegistrar.js   # 模型注册器
```

### 与前后端架构的集成
本数据库模型设计与前后端架构紧密集成，遵循以下映射关系：

**与后端服务映射**
| 数据模型 | 对应后端服务 |
|---------|-------------|
| User 模型 | UserService |
| NutritionProfile 模型 | NutritionProfileService |
| Nutritionist 模型 | NutritionistService |
| Merchant 模型 | MerchantService |
| ProductDish 模型 | DishService |
| Order 模型 | OrderService |
| ForumPost 模型 | ForumPostService |
| Notification 模型 | NotificationService |

**与前端模块映射**
| 数据模型 | 对应前端模块 |
|---------|-------------|
| User 模型 | domain/user/ |
| NutritionProfile 模型 | domain/nutrition/ |
| Merchant 模型 | domain/restaurant/ |
| Order 模型 | domain/order/ |
| ForumPost 模型 | domain/forum/ |
| AiRecommendation 模型 | domain/nutrition/ |

## 二、用户相关模型

### User 模型
用户基本信息、认证和个人资料。

```javascript
{
  _id: ObjectId,                        // 用户唯一标识
  phone: {                              // 手机号
    type: String,                       // 数据类型
    required: true,                     // 必填字段
    unique: true,                       // 唯一索引
    validate: /^1[3-9]\d{9}$/           // 验证规则：中国大陆手机号
  },
  password: {                           // 密码（加密存储）
    type: String,
    required: function() {              // 条件必填
      return this.authType === 'password';
    }
  },
  authType: {                           // 登录方式
    type: String,
    enum: ['password', 'code', 'oauth'],// 枚举可选值
    default: 'password'                 // 默认值
  },
  verification: {                       // 验证码信息
    code: String,                       // 验证码
    expiresAt: Date                     // 过期时间
  },
  role: {                               // 用户角色
    type: String,
    enum: ['user', 'admin', 'nutritionist', 'merchant'],
    default: 'user',
    index: true                         // 创建索引以加速查询
  },
  currentRole: {                        // 当前活跃角色
    type: String,
    default: function() {
      return this.role;
    }
  },
  
  // 基本信息
  nickname: String,                     // 用户昵称
  realName: String,                     // 真实姓名
  email: {                              // 邮箱
    type: String,
    unique: true,                       // 唯一索引
    sparse: true,                       // 稀疏索引，允许为null
    validate: /^\S+@\S+\.\S+$/          // 邮箱格式验证
  },
  avatarUrl: String,                    // 头像URL
  height: {                             // 身高(cm)
    type: Number,
    min: 50,                           // 最小值限制
    max: 250                           // 最大值限制
  },
  weight: {                             // 体重(kg)
    type: Number,
    min: 20,
    max: 300
  },
  age: {                                // 年龄
    type: Number,
    min: 0,
    max: 120
  },
  gender: {                             // 性别
    type: String,
    enum: ['male', 'female', 'other']
  },
  activityLevel: {                      // 活动水平
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active']
  },
  
  // 地区信息
  region: {
    province: String,                   // 省份
    city: String                        // 城市
  },
  
  // 饮食偏好
  dietaryPreferences: {
    cuisinePreference: String,          // 偏好菜系
    allergies: [String],                // 过敏原
    avoidedIngredients: [String],       // 避免食材
    spicyPreference: {                  // 辣度偏好
      type: String,
      enum: ['none', 'mild', 'medium', 'hot', 'extra_hot']
    }
  },
  
  // 认证信息
  nutritionistCertification: {          // 营养师认证
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      index: true                       // 索引以加速查询
    },
    rejectionReason: String             // 拒绝原因
  },
  merchantCertification: {              // 商家认证
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      index: true
    },
    rejectionReason: String             // 拒绝原因
  },
  
  // 其他系统信息
  lastLoginAt: Date,                    // 最后登录时间
  status: {                             // 账户状态
    type: String,
    enum: ['active', 'suspended', 'deactivated'],
    default: 'active',
    index: true
  },
  createdAt: {                          // 创建时间
    type: Date,
    default: Date.now,
    immutable: true                     // 创建后不可修改
  },
  updatedAt: {                          // 更新时间
    type: Date,
    default: Date.now
  }
}
```

**推荐索引**:
```javascript
// 复合索引：用于用户搜索和筛选
{ role: 1, status: 1, createdAt: -1 }
// 文本索引：用于全局搜索
{ nickname: 'text', realName: 'text', email: 'text' }
```

### UserRole 模型
用户角色和权限配置。

```javascript
{
  _id: ObjectId,                       // 角色ID
  roleName: String,                    // 角色名称
  permissions: [String],               // 权限列表
  accessLevel: Number,                 // 访问等级
  description: String,                 // 角色描述
  isSystem: Boolean,                   // 是否系统角色
  createdAt: Date,                     // 创建时间
  updatedAt: Date                      // 更新时间
}
```

## 三、营养相关模型

### NutritionProfile 模型
用户营养档案，包含详细的营养状态和健康信息。

```javascript
{
  _id: ObjectId,                      // 营养档案ID
  userId: ObjectId,                   // 所属用户ID
  profileName: String,                // 档案名称
  
  // 基本数据
  bmi: Number,                        // 体质指数
  bmr: Number,                        // 基础代谢率
  dailyCalories: Number,              // 日需卡路里
  
  // 健康状况
  nutritionStatus: {
    chronicDiseases: [String],        // 慢性疾病列表
    specialConditions: [String],      // 特殊健康状况
    allergies: [String],              // 过敏物列表
    notes: String,                    // 营养状态备注
    
    // 进阶营养指标
    nutritionalBiomarkers: Map,       // 营养生物标志物数据
    micronutrientStatus: Map,         // 微量营养素状态评估
    metabolicIndicators: Object,      // 代谢健康指标
    bodyComposition: Object           // 身体成分分析
  },
  
  // 饮食偏好
  dietaryPreference: {
    isVegetarian: Boolean,            // 是否素食
    tastePreference: [String],        // 口味偏好
    taboos: [String],                 // 忌口食材
    cuisine: String,                  // 菜系偏好
    allergies: [String]               // 过敏食材
  },
  
  // 生活方式
  lifestyle: {
    smoking: Boolean,                 // 是否吸烟
    drinking: Boolean,                // 是否饮酒
    sleepDuration: Number,            // 睡眠时长（小时）
    exerciseFrequency: String         // 运动频率
  },
  
  // 营养目标
  nutritionGoals: {
    targetWeight: Number,             // 目标体重
    targetDate: Date,                 // 目标日期
    dailyProteinGoal: Number,         // 每日蛋白质目标
    dailyFatGoal: Number,             // 每日脂肪目标
    dailyCarbGoal: Number,            // 每日碳水目标
    customGoals: [Object]             // 自定义目标
  },
  
  createdAt: Date,                    // 创建时间
  updatedAt: Date                     // 更新时间
}
```

### AiRecommendation 模型
AI营养推荐，基于用户营养档案和行为生成个性化推荐。

```javascript
{
  _id: ObjectId,                        // 推荐ID
  userId: ObjectId,                     // 用户ID
  nutritionProfileId: ObjectId,         // 营养档案ID
  
  // 推荐内容
  recommendations: {
    meals: [{                           // 推荐餐品
      dishId: ObjectId,                 // 菜品ID
      score: Number,                    // 推荐分数
      reason: String                    // 推荐原因
    }],
    mealPlan: {                         // 膳食计划
      breakfast: [ObjectId],            // 早餐菜品ID
      lunch: [ObjectId],                // 午餐菜品ID
      dinner: [ObjectId],               // 晚餐菜品ID
      snacks: [ObjectId]                // 零食菜品ID
    },
    nutritionInsights: [String],        // 营养洞察
    improvementSuggestions: [String]    // 改进建议
  },
  
  // 算法信息
  algorithm: {
    version: String,                    // 算法版本
    modelName: String,                  // 模型名称
    parameters: Object,                 // 算法参数
    confidence: Number                  // 置信度
  },
  
  // 用户反馈
  userFeedback: {
    rating: Number,                     // 用户评分
    feedback: String,                   // 反馈内容
    followedRecommendation: Boolean,    // 是否采纳推荐
    improvements: [String]              // 期望改进
  },
  
  status: String,                       // 状态：active/archived/obsolete
  createdAt: Date,                      // 创建时间
  updatedAt: Date,                      // 更新时间
  expiresAt: Date                       // 过期时间
}
```

### Nutritionist 模型
营养师信息，包含专业资质和服务内容。

```javascript
{
  _id: ObjectId,                        // 营养师ID
  userId: ObjectId,                     // 关联用户ID
  specialties: [String],                // 专长领域
  certification: {                      // 资质认证
    certificationName: String,          // 证书名称
    issuingBody: String,                // 发证机构
    certificationNumber: String,        // 证书编号
    issueDate: Date,                    // 发证日期
    expiryDate: Date,                   // 有效期
    verificationStatus: String          // 验证状态
  },
  experience: Number,                   // 从业年限
  biography: String,                    // 个人简介
  consultationTypes: [String],          // 咨询类型
  consultationFees: {                   // 咨询费用
    singleSession: Number,              // 单次咨询
    package: Number,                    // 套餐价格
    currency: String                    // 货币类型
  },
  availability: Object,                 // 可用时间段
  clients: [ObjectId],                  // 客户列表
  ratings: {                            // 评分信息
    average: Number,                    // 平均评分
    count: Number                       // 评价数量
  },
  createdAt: Date,                      // 创建时间
  updatedAt: Date                       // 更新时间
}
```

## 四、商家相关模型

### MerchantType 枚举模型
商家类型枚举，定义系统支持的商家类型常量和相关属性。

```javascript
{
  // 商家类型枚举常量
  merchantTypes: {
    // 健身房类型
    gym: {
      value: 'gym',                     // 类型值
      label: '健身房',                   // 显示标签
      description: String,              // 类型描述
      features: [String],               // 支持特性
      allowCustomMeals: Boolean         // 是否允许定制餐
    },
    
    // 月子中心类型
    maternityCenter: {
      value: 'maternityCenter',
      label: '月子中心',
      description: String,
      features: [String],
      allowCustomMeals: Boolean
    },
    
    // 营养餐厅类型
    restaurant: {
      value: 'restaurant',
      label: '营养餐厅',
      description: String,
      features: [String],
      allowCustomMeals: Boolean
    },
    
    // 团体用户类型（学校、公司等）
    schoolCompany: {
      value: 'schoolCompany',
      label: '团体用户',
      description: String,
      features: [String],
      allowCustomMeals: Boolean
    }
  },
  
  // 辅助函数和属性
  merchantTypeValues: [String],         // 所有类型值数组
  merchantTypeLabels: Object,           // 类型值到显示标签的映射
  getFeaturesByType: Function,          // 根据类型获取特性的函数
  isValidMerchantType: Function,        // 验证类型是否有效的函数
  getMerchantTypeLabel: Function        // 获取类型显示标签的函数
}
```

### Merchant 模型
商家信息，包含餐厅基本信息和运营数据。

```javascript
{
  _id: ObjectId,                        // 商家ID
  name: String,                         // 商家名称
  type: String,                         // 商家类型（枚举值）
  userId: ObjectId,                     // 关联用户ID
  businessLicense: {                    // 营业执照信息
    licenseNumber: String,              // 执照号码
    issueDate: Date,                    // 发证日期
    expiryDate: Date,                   // 有效期
    businessScope: String,              // 经营范围
    legalRepresentative: String         // 法定代表人
  },
  contactInfo: {                        // 联系信息
    phone: String,                      // 联系电话
    email: String,                      // 邮箱
    website: String,                    // 网站
    address: Object                     // 地址信息
  },
  operatingHours: [Object],             // 营业时间
  logo: String,                         // 商标URL
  description: String,                  // 商家描述
  cuisine: [String],                    // 菜系分类
  specialFeatures: [String],            // 特色服务
  certifications: [Object],             // 认证信息
  status: String,                       // 状态：active/suspended/deactivated
  createdAt: Date,                      // 创建时间
  updatedAt: Date                       // 更新时间
}
```

### ProductDish 模型
菜品信息，包含菜品的营养成分、健康特性和适用人群。

```javascript
{
  _id: ObjectId,                        // 菜品ID
  name: String,                         // 菜品名称
  description: String,                  // 菜品描述
  imageUrl: String,                     // 菜品图片URL
  price: Number,                        // 原始价格
  discountedPrice: Number,              // 折扣价
  category: String,                     // 菜品类别
  subCategory: String,                  // 子类别
  tags: [String],                       // 标签
  
  // 营养成分
  nutritionFacts: {
    calories: Number,                   // 卡路里
    protein: Number,                    // 蛋白质含量（克）
    fat: Number,                        // 脂肪含量（克）
    carbohydrates: Number,              // 碳水化合物含量（克）
    fiber: Number,                      // 膳食纤维含量（克）
    sugar: Number,                      // 糖分含量（克）
    sodium: Number,                     // 钠含量（毫克）
    cholesterol: Number,                // 胆固醇含量（毫克）
    vitaminA: Number,                   // 维生素A（国际单位）
    vitaminC: Number,                   // 维生素C（毫克）
    vitaminD: Number,                   // 维生素D（国际单位）
    vitaminE: Number,                   // 维生素E（毫克）
    vitaminK: Number,                   // 维生素K（微克）
    vitaminB6: Number,                  // 维生素B6（毫克）
    vitaminB12: Number,                 // 维生素B12（微克）
    calcium: Number,                    // 钙含量（毫克）
    iron: Number,                       // 铁含量（毫克）
    magnesium: Number,                  // 镁含量（毫克）
    potassium: Number,                  // 钾含量（毫克）
    zinc: Number                        // 锌含量（毫克）
  },
  
  // 营养属性（用于快速筛选和推荐）
  nutritionAttributes: [String],        // 营养属性标签
  ingredients: [String],                // 食材列表
  allergens: [String],                  // 过敏原
  spicyLevel: Number,                   // 辣度等级
  preparationTime: Number,              // 准备时间（分钟）
  
  // 地区和季节适应性
  regions: [String],                    // 适用地区
  seasons: [String],                    // 适用季节
  
  // 套餐信息
  isPackage: Boolean,                   // 是否为套餐
  packageDishes: [{                     // 套餐包含的菜品
    dishId: ObjectId,                   // 菜品ID
    quantity: Number                    // 数量
  }],
  
  // 商家类型适应性
  suitableMerchantTypes: [String],      // 适合的商家类型
  
  // 健康特性
  healthBenefits: [{                    // 健康益处
    targetCondition: String,            // 目标健康状况
    benefitDescription: String          // 益处描述
  }],
  
  createdAt: Date,                      // 创建时间
  updatedAt: Date                       // 更新时间
}
```

## 五、订单相关模型

### Order 模型
订单信息，记录用户下单的详细信息和状态。

```javascript
{
  _id: ObjectId,                        // 订单ID
  orderNumber: String,                  // 订单编号
  userId: ObjectId,                     // 下单用户ID
  merchantId: ObjectId,                 // 商家ID
  merchantType: String,                 // 商家类型
  
  // 菜品信息
  items: [{                             // 订单项目
    dishId: ObjectId,                   // 菜品ID
    name: String,                       // 菜品名称
    price: Number,                      // 菜品单价
    quantity: Number,                   // 菜品数量
    customizations: [{                  // 定制选项
      optionName: String,               // 选项名称
      optionValue: String,              // 选项值
      additionalPrice: Number           // 额外费用
    }],
    specialInstructions: String,        // 特殊要求
    itemTotal: Number                   // 菜品总价
  }],
  
  // 营养相关
  nutritionProfileId: ObjectId,         // 营养档案ID
  aiRecommendationId: ObjectId,         // AI推荐ID
  
  // 订单状态和类型
  status: String,                       // 订单状态
  orderType: String,                    // 订单类型
  source: String,                       // 订单来源
  
  // 支付信息
  payment: {
    method: String,                     // 支付方式
    status: String,                     // 支付状态
    transactionId: String,              // 交易ID
    paymentTime: Date,                  // 支付时间
    refundId: String,                   // 退款ID
    refundTime: Date                    // 退款时间
  },
  
  // 价格明细
  priceDetails: {
    subtotal: Number,                   // 小计金额
    tax: Number,                        // 税费
    deliveryFee: Number,                // 配送费
    serviceFee: Number,                 // 服务费
    tip: Number,                        // 小费
    discount: Number,                   // 折扣金额
    discountCode: String,               // 折扣码
    total: Number                       // 总金额
  },
  
  // 配送信息
  delivery: Object,                     // 配送详情
  
  // 其他信息
  specialRequirements: String,          // 特殊要求
  feedback: Object,                     // 用户反馈
  createdAt: Date,                      // 创建时间
  updatedAt: Date                       // 更新时间
}
```

### Subscription 模型
订阅计划，支持用户定期订购营养餐。

```javascript
{
  _id: ObjectId,                        // 订阅ID
  userId: ObjectId,                     // 用户ID
  merchantId: ObjectId,                 // 商家ID
  plan: {                               // 订阅计划
    name: String,                       // 计划名称
    description: String,                // 计划描述
    frequency: String,                  // 频率
    mealCount: Number,                  // 餐食数量
    price: Number,                      // 价格
    includedDishes: [ObjectId]          // 包含的菜品
  },
  status: String,                       // 状态
  startDate: Date,                      // 开始日期
  endDate: Date,                        // 结束日期
  nextDeliveryDate: Date,               // 下次配送日期
  paymentMethod: String,                // 支付方式
  paymentDetails: Object,               // 支付详情
  deliveryAddress: Object,              // 配送地址
  nutritionProfileId: ObjectId,         // 关联的营养档案
  createdAt: Date,                      // 创建时间
  updatedAt: Date                       // 更新时间
}
```

## 六、社区互动模块

### ForumTag 模型
社区论坛标签，用于分类和组织论坛内容。

```javascript
{
  _id: ObjectId,                        // 标签唯一标识
  name: String,                         // 标签名称
  slug: String,                         // 标签别名（URL友好）
  description: String,                  // 标签描述
  iconUrl: String,                      // 标签图标URL
  color: String,                        // 标签颜色（十六进制）
  category: String,                     // 标签类别：nutrition/health/recipe等
  postCount: Number,                    // 使用该标签的帖子数量
  isRecommended: Boolean,               // 是否为推荐标签
  isSystem: Boolean,                    // 是否为系统标签
  relatedTags: [ObjectId],              // 相关标签ID
  createdBy: ObjectId,                  // 创建者ID
  createdByType: String,                // 创建者类型：User/Admin/System
  status: String,                       // 状态：active/inactive/pending
  moderation: {                         // 审核信息
    isModerated: Boolean,               // 是否已审核
    moderatedBy: ObjectId,              // 审核人ID
    moderatedAt: Date,                  // 审核时间
    rejectionReason: String             // 拒绝原因
  },
  metadata: {                           // 元数据
    aiGenerated: Boolean,               // 是否由AI生成
    aiConfidence: Number,               // AI生成置信度(0-1)
    nutritionRelevance: Number,         // 与营养相关度(0-100)
    healthRelevance: Number             // 与健康相关度(0-100)
  },
  createdAt: Date,                      // 创建时间
  updatedAt: Date                       // 更新时间
}
```

### ForumPost 模型
社区帖子，用于用户分享饮食经验和健康心得。

```javascript
{
  _id: ObjectId,                        // 帖子唯一标识
  authorId: ObjectId,                   // 作者ID（关联用户）
  authorName: String,                   // 作者名称
  title: String,                        // 帖子标题
  content: String,                      // 正文内容
  images: [String],                     // 附图URL列表
  tags: [ObjectId],                     // 关联的标签ID（ForumTag）
  category: String,                     // 分类名称
  visibility: String,                   // 可见性：public/private/hidden
  status: String,                       // 状态：active/archived/deleted
  isPinned: Boolean,                    // 是否置顶
  isHighlighted: Boolean,               // 是否加精
  likes: Number,                        // 点赞数
  comments: Number,                     // 评论数
  bookmarks: Number,                    // 收藏数
  viewCount: Number,                    // 浏览量
  moderation: {
    isModerated: Boolean,               // 是否已审核
    moderatedBy: ObjectId,
    moderatedAt: Date,
    rejectionReason: String
  },
  metadata: {
    aiGenerated: Boolean,
    aiConfidence: Number
  },
  createdAt: Date,
  updatedAt: Date
}
```

## 七、通知模块

### UserNotificationStatus 模型
用户通知状态模型，跟踪用户的通知偏好设置和未读状态。

```javascript
{
  _id: ObjectId,                        // 唯一标识
  userId: ObjectId,                     // 用户ID
  preferences: {                        // 通知偏好设置
    enabledTypes: {                     // 通知类型开关
      system: Boolean,                  // 系统通知
      order: Boolean,                   // 订单通知
      payment: Boolean,                 // 支付通知
      health: Boolean,                  // 健康通知
      reminder: Boolean,                // 提醒通知
      forum: Boolean,                   // 论坛通知
      promotion: Boolean,               // 促销通知
      security: Boolean,                // 安全通知
      subscription: Boolean,            // 订阅通知
      recommendation: Boolean,          // 推荐通知
      alert: Boolean                    // 警报通知
    },
    channelPreferences: {               // 渠道偏好
      system: {                         // 系统通知渠道
        app: Boolean,                   // 应用内推送
        sms: Boolean,                   // 短信通知
        email: Boolean,                 // 邮件通知
        wechat: Boolean                 // 微信通知
      },
      // 其他类型的渠道偏好...
    },
    doNotDisturbSettings: {             // 免打扰设置
      enabled: Boolean,                 // 是否启用
      startTime: String,                // 开始时间
      endTime: String,                  // 结束时间
      exceptTypes: [String],            // 例外的通知类型
      exceptPriorities: [String]        // 例外的优先级
    },
    deviceSettings: {                   // 设备设置
      pushToken: String,                // 推送令牌
      deviceType: String,               // 设备类型
      lastUpdated: Date                 // 最后更新时间
    },
    batchSettings: {                    // 批量通知设置
      deliveryFrequency: String,        // 投递频率
      digestEnabled: Boolean,           // 是否启用摘要
      digestFrequency: String,          // 摘要频率
      digestTime: String                // 摘要时间
    }
  },
  statistics: {                         // 通知统计
    unreadCounts: {                     // 未读计数
      total: Number,                    // 总未读数
      byType: {                         // 按类型统计
        system: Number,                 // 系统通知未读数
        // 其他类型的未读数...
      }
    },
    interactionStats: {                 // 互动统计
      totalReceived: Number,            // 总接收数
      totalRead: Number,                // 总已读数
      totalClicked: Number,             // 总点击数
      readRate: Number,                 // 阅读率
      clickRate: Number,                // 点击率
      averageReadTime: Number           // 平均阅读时间
    },
    recentReadHistory: [{               // 最近阅读历史
      notificationId: ObjectId,         // 通知ID
      readAt: Date,                     // 阅读时间
      notificationType: String,         // 通知类型
      title: String                     // 通知标题
    }],
    lastUpdated: Date                   // 最后更新时间
  },
  lastSyncTime: Date,                   // 最后同步时间
  createdAt: Date,                      // 创建时间
  updatedAt: Date                       // 更新时间
}
```

### Notification 模型
系统通知模型，用于存储系统生成的通知消息内容。

```javascript
{
  _id: ObjectId,                        // 通知唯一标识
  type: String,                         // 通知类型，如 system/order/payment 等
  title: String,                        // 通知标题
  message: String,                      // 通知正文内容
  linkUrl: String,                      // 跳转链接（可选）
  imageUrl: String,                     // 图片封面URL（可选）
  priority: Number,                     // 优先级（1-10，数值越大越重要）
  status: String,                       // 状态：active/inactive/deleted
  targetUserIds: [ObjectId],            // 被推送的用户ID列表（支持群发）
  targetRoles: [String],                // 可选：按角色推送
  platform: [String],                   // 推送平台（app/sms/email/wechat）
  isGlobal: Boolean,                    // 是否全局通知（所有用户可见）
  scheduledAt: Date,                    // 定时推送时间（可为空）
  sentAt: Date,                         // 实际发送时间
  createdBy: ObjectId,                  // 创建人
  createdByType: String,                // 创建者类型：Admin/System
  createdAt: Date,                      // 创建时间
  updatedAt: Date                       // 更新时间
}
```

## 八、用户行为分析模块

### UsageLog 模型
用户行为日志模型，用于记录用户在应用中的各种操作和行为数据。

```javascript
{
  _id: ObjectId,                       // 唯一标识
  userId: ObjectId,                    // 用户ID，未登录用户为null
  sessionId: String,                   // 会话ID
  anonymousId: String,                 // 匿名用户ID
  
  eventType: String,                   // 事件类型，如page_view、button_click等
  eventName: String,                   // 事件名称
  eventCategory: String,               // 事件分类
  eventData: Object,                   // 事件附加数据
  
  context: {                           // 上下文信息
    page: {                            // 页面信息
      url: String,                     // 页面URL
      path: String,                    // 页面路径
      title: String,                   // 页面标题
      referrer: String                 // 来源页面
    },
    app: Object,                       // 应用信息
    device: Object,                    // 设备信息
    os: Object,                        // 操作系统信息
    browser: Object,                   // 浏览器信息
    locale: String,                    // 用户语言设置
    userAgent: String,                 // 用户代理
    ip: String,                        // 用户IP
    location: Object                   // 位置信息
  },
  
  performance: {                       // 性能数据
    loadTime: Number,                  // 页面加载时间
    responseTime: Number,              // 服务器响应时间
    renderTime: Number,                // 页面渲染时间
    totalTime: Number                  // 总耗时
  },
  
  createdAt: Date,                     // 事件发生时间
  isProcessed: Boolean,                // 是否已处理
  processedAt: Date                    // 处理时间
}
```

## 九、咨询相关模型

### Consultation 模型
营养咨询会话记录，连接用户和营养师。

```javascript
{
  _id: ObjectId,                       // 咨询ID
  userId: ObjectId,                    // 用户ID
  nutritionistId: ObjectId,            // 营养师ID
  title: String,                       // 咨询标题
  description: String,                 // 咨询描述
  status: String,                      // 状态：scheduled/completed/cancelled
  type: String,                        // 类型：online/inPerson
  startTime: Date,                     // 开始时间
  endTime: Date,                       // 结束时间
  duration: Number,                    // 持续时间（分钟）
  notes: String,                       // 备注
  attachments: [String],               // 附件URL
  fee: Number,                         // 咨询费用
  paymentStatus: String,               // 支付状态
  feedback: {                          // 反馈
    rating: Number,                    // 评分
    comment: String,                   // 评论
    isSatisfied: Boolean               // 是否满意
  },
  createdAt: Date,                     // 创建时间
  updatedAt: Date                      // 更新时间
}
```

## 十、数据冻结与维护

### 冻结范围
1. **核心架构**: modelFactory.js, modelRegistrar.js 的核心架构和设计
2. **目录结构**: 各业务领域的模型分类和目录结构
3. **模型关系**: 主要模型之间的依赖和关系
4. **主要模型字段**: 本文档中描述的模型结构及其关键字段
5. **验证规则**: 主要字段的验证规则和约束条件

### 不包含在冻结范围内
1. 模型的具体实现细节和业务逻辑
2. 非关键字段的增删改
3. 索引配置和优化（但需遵循本文档的推荐索引）
4. 缓存策略的调整

### 模型关系图
主要模型关系如下：

```
                     ┌───► ForumPost
                     │
User ──────┬───► NutritionProfile ◄───► AiRecommendation
           │         │
           │         └───► Consultation ◄─┐
           │                              │
           ├───► Order ◄───── Merchant    │
           │        │        │            │
           │        └───► ProductDish     │
           │                 ▲            │
           │                 │            │
           └────► Nutritionist ───────────┘
                     │
                     └───► Notification
```

### 更新与维护指南
1. **添加新字段**:
   - 非关键字段可直接添加，但需注意字段命名与现有风格保持一致
   - 关键字段添加需提交变更申请，评估对关联模型的影响
   - 添加字段时需要考虑向后兼容性，建议使用default值

2. **添加新模型**:
   - 新模型应放置在对应的业务目录下
   - 使用 modelRegistrar 进行注册
   - 在 index.js 中导出
   - 需要编写完整的验证规则和索引配置

3. **性能优化**:
   - 索引优化需进行性能测试并记录基准测试结果
   - 缓存策略调整需评估内存占用和命中率
   - 对于大容量集合，考虑使用TTL索引或分片策略

## 十一、数据迁移策略

### 版本控制
1. **模型版本管理**:
   - 每个模型结构变更应标记版本号
   - 使用 MongoDB 的 Schema Versioning 来管理版本迁移
   - 版本迁移脚本存放在 `migrations/` 目录

### 数据迁移流程
1. **前向迁移**:
   - 制定模型升级计划和回滚策略
   - 设计并测试数据转换脚本
   - 阶段性部署，先在测试环境验证
   - 生产环境执行前进行数据备份

2. **迁移验证**:
   - 确保数据完整性检查，避免数据丢失
   - 自动化测试验证数据一致性
   - 性能监控，确保迁移过程不影响系统可用性

3. **回滚机制**:
   - 每次迁移都应包含相应的回滚脚本
   - 关键迁移操作需保留原始数据备份
   - 定义明确的回滚触发条件和流程

### 数据归档与清理
1. **数据归档策略**:
   - 超过 2 年的历史数据考虑归档到冷存储
   - 使用 MongoDB 时间序列集合存储历史分析数据
   - 归档数据需保留关键索引以支持查询

2. **数据清理规则**:
   - 定期清理临时数据和日志（如 UsageLog 超过 90 天）
   - 定期合并分析数据，保留聚合结果
   - 对无效数据执行软删除，保留审计记录

## 十二、MongoDB优化与最佳实践

### 索引优化策略
1. **索引设计原则**:
   - 高查询频率字段优先建立索引
   - 避免在低基数字段上建立单一索引
   - 对于排序字段，建立复合索引并匹配排序方向
   - 定期使用 `explain()` 分析查询性能

2. **索引类型选择**:
   - 单字段索引：频繁单字段过滤查询
   - 复合索引：多字段联合查询条件和排序
   - 地理空间索引：位置相关查询（商家距离计算）
   - 文本索引：全文搜索场景（菜品描述、论坛帖子）
   - TTL索引：自动过期数据（临时验证码、会话记录）

### 分片策略
1. **分片键选择**:
   - User集合：按地理区域或用户ID范围分片
   - Order集合：按时间范围或商家ID分片
   - UsageLog集合：按时间范围分片
   - Notification集合：按用户ID范围分片

2. **分片集群配置**:
   - 生产环境建议至少3个分片服务器
   - 每个分片服务器配置为3节点复制集
   - 配置服务器使用3节点复制集
   - mongos路由服务器根据负载适量部署

### 查询优化
1. **查询模式优化**:
   - 避免大规模无索引查询
   - 限制查询结果集大小，使用分页
   - 投影仅需要的字段，减少网络传输
   - 使用聚合管道替代多次查询
   - 批量操作使用bulkWrite提高效率

2. **高级优化技术**:
   - 读写分离：读操作分发到从节点
   - 预聚合：使用定时任务提前计算统计结果
   - 冷热数据分离：活跃数据与历史数据分库存储
   - 数据压缩：启用WiredTiger存储引擎压缩

### 性能监控
1. **关键监控指标**:
   - 查询响应时间
   - 索引命中率
   - 连接数
   - 读写操作比例
   - 内存使用率
   - 磁盘I/O

2. **监控工具**:
   - MongoDB Compass
   - MongoDB Atlas监控
   - 自定义Prometheus+Grafana仪表盘

## 十三、变更历史记录

| 版本 | 日期 | 变更内容 | 负责人 |
|-----|------|---------|-------|
| 4.0 | 2025-05-20 | 初始冻结版本 | 数据库架构组 |
| 4.1 | 2025-05-25 | 完善字段定义和验证规则 | 数据库架构组 |
| 4.2 | 2025-06-10 | 添加架构映射和MongoDB优化策略 | 系统架构组 |
