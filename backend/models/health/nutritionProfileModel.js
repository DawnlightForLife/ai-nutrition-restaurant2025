const mongoose = require('mongoose');
const modelFactory = require('../modelFactory');
const { shardingService } = require('../../services/core/shardingService');

// 定义营养档案模型的结构
const nutritionProfileSchema = new mongoose.Schema({
  // 基本关联
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  userId: {
    type: String,
    required: true,
    index: true,
  },
  // 档案基本信息
  profileName: {
    type: String,
    required: true,
    trim: true
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other'
  },
  ageGroup: {
    type: String,
    enum: ['under_18', '18_30', '31_45', '46_60', 'above_60'],
    required: true
  },
  height: {
    type: Number, // 单位：厘米
    min: 50,
    max: 250
  },
  weight: {
    type: Number, // 单位：公斤
    min: 0,
    max: 300
  },
  region: {
    province: String,
    city: String,
    district: String
  },
  occupation: {
    type: String,
    enum: ['student', 'office_worker', 'physical_worker', 'retired', 'other']
  },
  // 健康状况
  healthStatus: {
    chronicDiseases: [{
      type: String,
      enum: ['hypertension', 'diabetes', 'gout', 'heart_disease', 'none']
    }],
    specialConditions: [{
      type: String,
      enum: ['pregnancy', 'lactation', 'menopause', 'none']
    }]
  },
  // 饮食偏好
  dietaryPreferences: {
    isVegetarian: {
      type: Boolean,
      default: false
    },
    tastePreference: [{
      type: String,
      enum: ['light', 'spicy', 'sour', 'sweet', 'salty']
    }],
    taboos: [{
      type: String
    }],
    cuisine: {
      type: String,
      enum: ['chinese', 'western', 'japanese', 'korean', 'other'],
      default: 'chinese'
    },
    allergies: [{
      type: String
    }]
  },
  // 生活方式
  lifestyle: {
    smoking: {
      type: Boolean,
      default: false
    },
    drinking: {
      type: Boolean,
      default: false
    },
    sleepDuration: {
      type: Number,
      min: 0,
      max: 24
    },
    exerciseFrequency: {
      type: String,
      enum: ['none', 'occasional', 'regular', 'frequent', 'daily']
    }
  },
  // 营养目标
  nutritionGoals: [{
    type: String,
    enum: [
      'weight_loss',
      'weight_gain',
      'muscle_gain',
      'blood_sugar_control',
      'blood_pressure_control',
      'immunity_boost',
      'energy_boost',
      'general_health'
    ]
  }],
  // 活动水平 (保留原字段以兼容现有数据)
  activity_level: {
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
    default: 'moderate'
  },
  // 健康指标
  health_metrics: {
    bmi: {
      type: Number,
      min: 0,
      max: 50
    },
    blood_pressure: {
      systolic: {
        type: Number,
        min: 0,
        max: 300
      },
      diastolic: {
        type: Number,
        min: 0,
        max: 200
      },
      measured_at: {
        type: Date
      }
    },
    blood_glucose: {
      value: {
        type: Number,
        min: 0,
        max: 500
      },
      measured_at: {
        type: Date
      }
    }
  },
  // 目标热量和宏量素 (保留原字段以兼容现有数据)
  nutrition_targets: {
    calories: {
      type: Number,
      min: 0
    },
    protein_percentage: {
      type: Number,
      min: 0,
      max: 100
    },
    carbs_percentage: {
      type: Number,
      min: 0,
      max: 100
    },
    fat_percentage: {
      type: Number,
      min: 0,
      max: 100
    }
  },
  // 备注
  notes: {
    type: String,
    default: '',
  },
  // 是否为主档案
  isPrimary: {
    type: Boolean,
    default: false
  },
  // 档案隐私设置
  privacy_settings: {
    // 是否共享给营养师
    share_with_nutritionist: {
      type: Boolean,
      default: false
    },
    // 是否用于AI推荐
    use_for_ai_recommendation: {
      type: Boolean,
      default: true
    },
    // 是否在餐厅/商家下单时使用
    use_for_merchants: {
      type: Boolean,
      default: false
    }
  },
  // 授权记录
  access_grants: [{
    granted_to: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_grants.granted_to_type'
    },
    granted_to_type: {
      type: String,
      enum: ['Nutritionist', 'Merchant']
    },
    granted_at: {
      type: Date,
      default: Date.now
    },
    valid_until: {
      type: Date
    },
    reason: {
      type: String
    },
    revoked: {
      type: Boolean,
      default: false
    },
    revoked_at: {
      type: Date
    }
  }],
  // 关联的健康数据
  related_health_data: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'HealthData'
  }],
  // 关联的AI推荐历史
  recommendation_history: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AiRecommendation'
  }],
  // 档案版本和审计
  version: {
    type: Number,
    default: 1
  },
  modification_history: [{
    modified_at: {
      type: Date,
      default: Date.now
    },
    modified_by: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    modified_by_type: {
      type: String,
      enum: ['user', 'nutritionist', 'admin'],
      default: 'user'
    },
    change_description: String,
    changed_fields: [String]
  }],
  // 营养师注释
  nutritionist_notes: [{
    nutritionist_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    note: {
      type: String,
    },
    created_at: {
      type: Date,
      default: Date.now
    },
    updated_at: {
      type: Date,
      default: Date.now
    }
  }],
  // 创建和更新时间
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  },
  // 元数据
  metadata: {
    created_by: String, // 创建者: user, nutritionist, system
    last_updated_by: String, // 最后更新者
    version: {
      type: Number,
      default: 1
    },
    revision_history: [{
      timestamp: Date,
      changed_by: String,
      changes: Object
    }]
  },
  // 敏感度映射作为文档元数据，而不是Schema字段
  data_sensitivity: {
    type: Map,
    of: Number // 1-高敏感，2-中敏感，3-低敏感
  }
}, {
    timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' },
    versionKey: false,
    toJSON: { virtuals: true },
    toObject: { virtuals: true }
});

// 增强索引以优化查询性能
nutritionProfileSchema.index({ user_id: 1 });
nutritionProfileSchema.index({ userId: 1 });
nutritionProfileSchema.index({ 'healthStatus.chronicDiseases': 1 });
nutritionProfileSchema.index({ 'dietaryPreferences.cuisine': 1 });
nutritionProfileSchema.index({ 'lifestyle.exerciseFrequency': 1 });
nutritionProfileSchema.index({ nutritionGoals: 1 });
nutritionProfileSchema.index({ isPrimary: 1, user_id: 1 });
nutritionProfileSchema.index({ 'access_grants.granted_to': 1, 'access_grants.granted_to_type': 1 });
nutritionProfileSchema.index({ 'access_grants.valid_until': 1 });
nutritionProfileSchema.index({ createdAt: -1 });

// 虚拟字段
nutritionProfileSchema.virtual('bmi').get(function() {
  if (!this.height || !this.weight) return null;
  
  // 转换高度为米
  const heightInMeters = this.height / 100;
  // 计算BMI：体重(kg) / 身高(m)²
  return Math.round((this.weight / (heightInMeters * heightInMeters)) * 10) / 10;
});

nutritionProfileSchema.virtual('bmi_category').get(function() {
  const bmi = this.bmi;
  if (!bmi) return null;
  
  if (bmi < 18.5) return 'underweight';
  if (bmi < 24.9) return 'normal';
  if (bmi < 29.9) return 'overweight';
  return 'obese';
});

nutritionProfileSchema.virtual('estimated_daily_calories').get(function() {
  // 基于年龄组估算年龄
  let estimatedAge = 30; // 默认中间值
  
  switch(this.ageGroup) {
    case 'under_18':
      estimatedAge = 16;
      break;
    case '18_30':
      estimatedAge = 25;
      break;
    case '31_45':
      estimatedAge = 38;
      break;
    case '46_60':
      estimatedAge = 53;
      break;
    case 'above_60':
      estimatedAge = 65;
      break;
  }
  
  if (!this.gender || !this.weight || !this.height || !estimatedAge || !this.activity_level) {
    return this.nutrition_targets?.calories || null;
  }
  
  // 基础代谢率 (BMR) 计算 - 使用修正的Harris-Benedict公式
  let bmr = 0;
  if (this.gender === 'male') {
    // 男性: BMR = 88.362 + (13.397 × 体重kg) + (4.799 × 身高cm) - (5.677 × 年龄)
    bmr = 88.362 + (13.397 * this.weight) + (4.799 * this.height) - (5.677 * estimatedAge);
  } else {
    // 女性: BMR = 447.593 + (9.247 × 体重kg) + (3.098 × 身高cm) - (4.330 × 年龄)
    bmr = 447.593 + (9.247 * this.weight) + (3.098 * this.height) - (4.330 * estimatedAge);
  }
  
  // 根据活动水平调整
  const activityMultipliers = {
    'sedentary': 1.2,       // 久坐不动
    'light': 1.375,         // 轻度活动(每周1-3天)
    'moderate': 1.55,       // 中度活动(每周3-5天)
    'active': 1.725,        // 较多活动(每周6-7天)
    'very_active': 1.9      // 非常活跃(每天多次高强度运动)
  };
  
  const multiplier = activityMultipliers[this.activity_level] || 1.55;
  const tdee = Math.round(bmr * multiplier); // 总能量消耗
  
  // 根据目标调整卡路里
  let targetCalories = tdee;
  
  if (this.nutritionGoals && this.nutritionGoals.length > 0) {
    const primaryGoal = this.nutritionGoals[0];
    
    switch(primaryGoal) {
      case 'weight_loss':
        targetCalories = Math.round(tdee * 0.8); // 减少20%卡路里
        break;
      case 'weight_gain':
      case 'muscle_gain':
        targetCalories = Math.round(tdee * 1.1); // 增加10%卡路里
        break;
      default:
        targetCalories = tdee; // 维持相同卡路里
    }
  }
  
  return targetCalories;
});

// 转换为年龄区间显示
nutritionProfileSchema.virtual('ageGroup_display').get(function() {
  if (!this.ageGroup) return null;
  
  const ageGroupMap = {
    'under_18': '18岁以下',
    '18_30': '18-30岁',
    '31_45': '31-45岁',
    '46_60': '46-60岁',
    'above_60': '60岁以上'
  };
  
  return ageGroupMap[this.ageGroup] || this.ageGroup;
});

nutritionProfileSchema.virtual('user', {
  ref: 'User',
  localField: 'user_id',
  foreignField: '_id',
  justOne: true
});

nutritionProfileSchema.virtual('active_grants').get(function() {
  if (!this.access_grants) return [];
  
  const now = new Date();
  return this.access_grants.filter(grant => 
    !grant.revoked && (!grant.valid_until || new Date(grant.valid_until) > now)
  );
});

// 计算营养目标的实例方法
nutritionProfileSchema.methods.calculateNutritionTargets = function() {
  // 获取日常卡路里需求
  const dailyCalories = this.estimated_daily_calories;
  
  if (!dailyCalories) return null;
  
  // 根据目标设定宏量素比例
  let proteinPercentage, carbsPercentage, fatPercentage;
  
  const primaryGoal = this.nutritionGoals && this.nutritionGoals.length > 0 ? 
                     this.nutritionGoals[0] : 'general_health';
  
  switch(primaryGoal) {
    case 'weight_loss':
      proteinPercentage = 30; // 高蛋白有助于保持饱腹感和肌肉
      carbsPercentage = 40;
      fatPercentage = 30;
      break;
    case 'weight_gain':
      proteinPercentage = 25;
      carbsPercentage = 50;
      fatPercentage = 25;
      break;
    case 'muscle_gain':
      proteinPercentage = 35; // 高蛋白促进肌肉生长
      carbsPercentage = 45;
      fatPercentage = 20;
      break;
    case 'blood_sugar_control':
      proteinPercentage = 30;
      carbsPercentage = 35; // 降低碳水以控制血糖
      fatPercentage = 35;
      break;
    default:
      proteinPercentage = 25;
      carbsPercentage = 50;
      fatPercentage = 25;
  }
  
  // 计算每日各宏量素的克数
  // 蛋白质和碳水每克4卡路里，脂肪每克9卡路里
  const dailyProtein = Math.round((dailyCalories * (proteinPercentage / 100)) / 4);
  const dailyCarbs = Math.round((dailyCalories * (carbsPercentage / 100)) / 4);
  const dailyFat = Math.round((dailyCalories * (fatPercentage / 100)) / 9);
  
  return {
    calories: dailyCalories,
    protein: dailyProtein,
    carbs: dailyCarbs,
    fat: dailyFat,
    protein_percentage: proteinPercentage,
    carbs_percentage: carbsPercentage,
    fat_percentage: fatPercentage
  };
};

// 预保存中间件
nutritionProfileSchema.pre('save', function(next) {
  this.updated_at = new Date();
  
  // 更新健康指标
  if (this.height && this.weight) {
    const heightInMeters = this.height / 100;
    this.health_metrics = this.health_metrics || {};
    this.health_metrics.bmi = Math.round((this.weight / (heightInMeters * heightInMeters)) * 10) / 10;
  }
  
  next();
});

// 授权访问方法
nutritionProfileSchema.methods.grantAccess = function(granteeId, granteeType, validUntil = null, reason = null) {
  if (!this.access_grants) {
    this.access_grants = [];
  }
  
  // 检查是否已有授权
  const existingGrantIndex = this.access_grants.findIndex(
    grant => grant.granted_to.toString() === granteeId.toString() && 
             grant.granted_to_type === granteeType &&
             !grant.revoked
  );
  
  if (existingGrantIndex !== -1) {
    // 更新现有授权
    this.access_grants[existingGrantIndex].valid_until = validUntil;
    this.access_grants[existingGrantIndex].reason = reason || this.access_grants[existingGrantIndex].reason;
  } else {
    // 创建新授权
    this.access_grants.push({
      granted_to: granteeId,
      granted_to_type: granteeType,
      granted_at: new Date(),
      valid_until: validUntil,
      reason: reason
    });
  }
  
  return this;
};

// 撤销授权方法
nutritionProfileSchema.methods.revokeAccess = function(granteeId, granteeType) {
  if (!this.access_grants) return false;
  
  let hasRevoked = false;
  
  this.access_grants.forEach(grant => {
    if (grant.granted_to.toString() === granteeId.toString() && 
        grant.granted_to_type === granteeType && 
        !grant.revoked) {
      grant.revoked = true;
      grant.revoked_at = new Date();
      hasRevoked = true;
    }
  });
  
  return hasRevoked;
};

// 匹配食物与喜好和限制
nutritionProfileSchema.methods.checkFoodCompatibility = function(food) {
  if (!food) return { compatible: false, reasons: ['无效的食物数据'] };
  
  const reasons = [];
  let compatible = true;
  
  // 检查过敏原
  if (this.dietaryPreferences && this.dietaryPreferences.allergies && 
      food.allergens && this.dietaryPreferences.allergies.length > 0) {
    
    const allergicTo = this.dietaryPreferences.allergies.filter(allergy => 
      food.allergens.includes(allergy)
    );
    
    if (allergicTo.length > 0) {
      compatible = false;
      reasons.push(`含有过敏原: ${allergicTo.join(', ')}`);
    }
  }
  
  // 检查忌口食物
  if (this.dietaryPreferences && this.dietaryPreferences.taboos && 
      food.ingredients && this.dietaryPreferences.taboos.length > 0) {
    
    const avoidedIngredients = this.dietaryPreferences.taboos.filter(ingredient => 
      food.ingredients.some(foodIngredient => 
        foodIngredient.toLowerCase().includes(ingredient.toLowerCase())
      )
    );
    
    if (avoidedIngredients.length > 0) {
      compatible = false;
      reasons.push(`含有忌口食物: ${avoidedIngredients.join(', ')}`);
    }
  }
  
  // 检查素食
  if (this.dietaryPreferences && this.dietaryPreferences.isVegetarian && 
      food.is_vegetarian === false) {
    compatible = false;
    reasons.push('不适合素食者');
  }
  
  // 检查口味偏好
  if (this.dietaryPreferences && this.dietaryPreferences.tastePreference && 
      this.dietaryPreferences.tastePreference.length > 0 && food.taste) {
    
    const hasMatchingTaste = this.dietaryPreferences.tastePreference.some(taste => 
      food.taste.includes(taste)
    );
    
    if (!hasMatchingTaste) {
      reasons.push('口味可能与偏好不匹配');
    }
  }
  
  // 健康状况相关检查
  if (this.healthStatus && this.healthStatus.chronicDiseases && this.healthStatus.chronicDiseases.length > 0) {
    // 糖尿病检查高碳水
    if (this.healthStatus.chronicDiseases.includes('diabetes') && 
        food.nutrition_facts && food.nutrition_facts.carbohydrates > 30) {
      reasons.push('碳水含量高，糖尿病患者应注意控制摄入量');
    }
    
    // 高血压检查高钠
    if (this.healthStatus.chronicDiseases.includes('hypertension') && 
        food.nutrition_facts && food.nutrition_facts.sodium > 500) {
      reasons.push('钠含量高，高血压患者应注意控制摄入量');
    }
    
    // 心脏疾病检查高饱和脂肪
    if (this.healthStatus.chronicDiseases.includes('heart_disease') && 
        food.nutrition_facts && food.nutrition_facts.saturated_fat > 5) {
      reasons.push('饱和脂肪含量高，心脏病患者应注意控制摄入量');
    }
  }
  
  return {
    compatible,
    reasons: reasons.length > 0 ? reasons : ['符合饮食偏好与限制']
  };
};

// 版本控制方法 - 记录修改历史
nutritionProfileSchema.methods.trackChanges = function(changedFields, changeDescription, modifiedBy, modifiedByType = 'user') {
  this.version = (this.version || 0) + 1;
  
  if (!this.modification_history) {
    this.modification_history = [];
  }
  
  this.modification_history.push({
    modified_at: new Date(),
    modified_by: modifiedBy,
    modified_by_type: modifiedByType,
    change_description: changeDescription,
    changed_fields: changedFields
  });
  
  return this;
};

// 添加营养师备注
nutritionProfileSchema.methods.addNutritionistNote = function(nutritionistId, note) {
  if (!this.nutritionist_notes) {
    this.nutritionist_notes = [];
  }
  
  this.nutritionist_notes.push({
    nutritionist_id: nutritionistId,
    note: note,
    created_at: new Date(),
    updated_at: new Date()
  });
  
  return this;
};

// 静态方法
nutritionProfileSchema.statics.findByUserId = function(userId) {
  return this.find({ user_id: userId }).sort({ createdAt: -1 });
};

nutritionProfileSchema.statics.findByGrantedAccess = function(granteeId, granteeType) {
  const now = new Date();
  
  return this.find({
    'access_grants.granted_to': granteeId,
    'access_grants.granted_to_type': granteeType,
    'access_grants.revoked': { $ne: true },
    $or: [
      { 'access_grants.valid_until': { $gt: now } },
      { 'access_grants.valid_until': null }
    ]
  });
};

// 模型转换为RESTful API响应的格式化函数
nutritionProfileSchema.methods.toAPI = function(excludeSensitive = false) {
  const obj = this.toObject();
  
  // 计算附加信息
  obj.bmi = this.bmi;
  obj.bmi_category = this.bmi_category;
  obj.estimated_daily_calories = this.estimated_daily_calories;
  obj.nutrition_targets = this.calculateNutritionTargets();
  
  // 移除敏感字段
  if (excludeSensitive) {
    for (const [key, value] of Object.entries(obj)) {
      if (value && typeof value === 'object' && value.sensitivity_level === 1) {
        delete obj[key];
      }
    }
  }
  
  return obj;
};

// 为数据字段添加敏感度信息（作为静态属性而非schema字段）
nutritionProfileSchema.statics.sensitivityMap = {
  'profilename': 3, // 低度敏感
  'gender': 2, // 中度敏感
  'ageGroup': 2, // 中度敏感
  'height': 2, // 中度敏感
  'weight': 2, // 中度敏感
  'region': 2, // 中度敏感
  'occupation': 3, // 低度敏感
  'healthStatus.chronicDiseases': 1, // 高度敏感
  'healthStatus.specialConditions': 1, // 高度敏感
  'dietaryPreferences.isVegetarian': 3, // 低度敏感
  'dietaryPreferences.tastePreference': 3, // 低度敏感
  'dietaryPreferences.taboos': 3, // 低度敏感
  'dietaryPreferences.cuisine': 3, // 低度敏感
  'dietaryPreferences.allergies': 1, // 高度敏感
  'lifestyle.smoking': 3, // 低度敏感
  'lifestyle.drinking': 3, // 低度敏感
  'lifestyle.sleepDuration': 3, // 低度敏感
  'lifestyle.exerciseFrequency': 3, // 低度敏感
  'nutritionGoals': 3, // 低度敏感
  'activity_level': 3, // 低度敏感
  'health_metrics.bmi': 2, // 中度敏感
  'health_metrics.blood_pressure.systolic': 2, // 中度敏感
  'health_metrics.blood_pressure.diastolic': 2, // 中度敏感
  'health_metrics.blood_glucose.value': 1 // 高度敏感
};

// 创建模型
const NutritionProfile = modelFactory.model('NutritionProfile', nutritionProfileSchema);

module.exports = NutritionProfile; 