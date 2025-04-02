const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

// 定义营养档案模型的结构
const nutritionProfileSchema = new mongoose.Schema({
  // 基本关联
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  // 档案名称
  name: {
    type: String,
    required: true,
    trim: true,
    sensitivity_level: 3 // 低度敏感数据
  },
  // 基本信息
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other',
    sensitivity_level: 2 // 中度敏感数据
  },
  age: {
    type: Number,
    min: 0,
    max: 120,
    sensitivity_level: 2 // 中度敏感数据
  },
  height: {
    type: Number, // 单位：厘米
    min: 50,
    max: 250,
    sensitivity_level: 2 // 中度敏感数据
  },
  weight: {
    type: Number, // 单位：公斤
    min: 0,
    max: 300,
    sensitivity_level: 2 // 中度敏感数据
  },
  // 活动水平
  activity_level: {
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
    default: 'moderate',
    sensitivity_level: 3 // 低度敏感数据
  },
  // 健康状况
  health_conditions: [{
    type: String,
    sensitivity_level: 1 // 高度敏感数据
  }],
  // 饮食偏好
  dietary_preferences: {
    cuisine_preference: {
      type: String,
      enum: ['north', 'south', 'east', 'west', 'sichuan', 'cantonese', 'hunan', 'other'],
      default: 'other',
      sensitivity_level: 3 // 低度敏感数据
    },
    allergies: [{
      type: String,
      sensitivity_level: 1 // 高度敏感数据
    }],
    avoided_ingredients: [{
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }],
    spicy_preference: {
      type: String,
      enum: ['none', 'mild', 'medium', 'hot', 'extra_hot'],
      default: 'medium',
      sensitivity_level: 3 // 低度敏感数据
    },
    diet_type: {
      type: String,
      enum: ['omnivore', 'vegetarian', 'vegan', 'pescatarian', 'paleo', 'keto', 'gluten_free', 'dairy_free', 'other'],
      default: 'omnivore',
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 营养目标
  goals: {
    type: String,
    enum: ['weight_loss', 'weight_gain', 'maintenance', 'muscle_gain', 'health_improvement', 'other'],
    default: 'health_improvement',
    sensitivity_level: 3 // 低度敏感数据
  },
  // 目标热量和宏量素
  nutrition_targets: {
    calories: {
      type: Number,
      min: 0,
      sensitivity_level: 3 // 低度敏感数据
    },
    protein_percentage: {
      type: Number,
      min: 0,
      max: 100,
      sensitivity_level: 3 // 低度敏感数据
    },
    carbs_percentage: {
      type: Number,
      min: 0,
      max: 100,
      sensitivity_level: 3 // 低度敏感数据
    },
    fat_percentage: {
      type: Number,
      min: 0,
      max: 100,
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 备注
  notes: {
    type: String,
    default: '',
    sensitivity_level: 2 // 中度敏感数据
  },
  // 是否为家庭成员档案
  is_family_member: {
    type: Boolean,
    default: false,
    sensitivity_level: 3 // 低度敏感数据
  },
  // 家庭成员关系（如果适用）
  family_relationship: {
    type: String,
    default: '',
    sensitivity_level: 2 // 中度敏感数据
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
      sensitivity_level: 2 // 中度敏感数据
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
  // 健康指标
  health_metrics: {
    bmi: {
      type: Number,
      min: 0,
      max: 50,
      sensitivity_level: 2 // 中度敏感数据
    },
    blood_pressure: {
      systolic: {
        type: Number,
        min: 0,
        max: 300,
        sensitivity_level: 2 // 中度敏感数据
      },
      diastolic: {
        type: Number,
        min: 0,
        max: 200,
        sensitivity_level: 2 // 中度敏感数据
      },
      measured_at: {
        type: Date
      }
    },
    blood_glucose: {
      value: {
        type: Number,
        min: 0,
        max: 500,
        sensitivity_level: 1 // 高度敏感数据
      },
      measured_at: {
        type: Date
      }
    }
  },
  // 是否为主档案
  is_primary: {
    type: Boolean,
    default: false,
    sensitivity_level: 3 // 低度敏感数据
  },
  // 创建和更新时间
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
}, {
    timestamps: true,
    versionKey: false,
    toJSON: { virtuals: true },
    toObject: { virtuals: true }
});

// 增强索引以优化查询性能
nutritionProfileSchema.index({ user_id: 1 });
nutritionProfileSchema.index({ 'health_conditions': 1 });
nutritionProfileSchema.index({ 'dietary_preferences.diet_type': 1 });
nutritionProfileSchema.index({ 'goals': 1 });
nutritionProfileSchema.index({ is_family_member: 1, user_id: 1 });
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
  if (!this.gender || !this.weight || !this.height || !this.age || !this.activity_level) {
    return this.nutrition_targets?.calories || null;
  }
  
  // 基础代谢率 (BMR) 计算 - 使用修正的Harris-Benedict公式
  let bmr = 0;
  if (this.gender === 'male') {
    // 男性: BMR = 88.362 + (13.397 × 体重kg) + (4.799 × 身高cm) - (5.677 × 年龄)
    bmr = 88.362 + (13.397 * this.weight) + (4.799 * this.height) - (5.677 * this.age);
  } else {
    // 女性: BMR = 447.593 + (9.247 × 体重kg) + (3.098 × 身高cm) - (4.330 × 年龄)
    bmr = 447.593 + (9.247 * this.weight) + (3.098 * this.height) - (4.330 * this.age);
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
  
  switch(this.goals) {
    case 'weight_loss':
      targetCalories = Math.round(tdee * 0.8); // 减少20%卡路里
      break;
    case 'weight_gain':
    case 'muscle_gain':
      targetCalories = Math.round(tdee * 1.1); // 增加10%卡路里
      break;
    case 'maintenance':
    case 'health_improvement':
    default:
      targetCalories = tdee; // 维持相同卡路里
  }
  
  return targetCalories;
});

nutritionProfileSchema.virtual('age_group').get(function() {
  if (!this.age) return null;
  
  if (this.age < 12) return 'child';
  if (this.age < 18) return 'teenager';
  if (this.age < 30) return 'young_adult';
  if (this.age < 50) return 'adult';
  if (this.age < 70) return 'senior';
  return 'elderly';
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
  // 确保有基本数据
  if (!this.gender || !this.weight || !this.height || !this.age) {
    return null;
  }
  
  // 获取日常卡路里需求
  const dailyCalories = this.estimated_daily_calories;
  
  if (!dailyCalories) return null;
  
  // 根据目标设定宏量素比例
  let proteinPercentage, carbsPercentage, fatPercentage;
  
  switch(this.goals) {
    case 'weight_loss':
      proteinPercentage = 30; // 高蛋白有助于保持饱腹感和肌肉
      carbsPercentage = 40;
      fatPercentage = 30;
      break;
    case 'muscle_gain':
      proteinPercentage = 35; // 肌肉生长需要更多蛋白质
      carbsPercentage = 45;
      fatPercentage = 20;
      break;
    case 'weight_gain':
      proteinPercentage = 20;
      carbsPercentage = 50;
      fatPercentage = 30;
      break;
    case 'health_improvement':
    case 'maintenance':
    default:
      proteinPercentage = 25;
      carbsPercentage = 50;
      fatPercentage = 25;
  }
  
  // 针对特殊饮食习惯进行调整
  if (this.dietary_preferences && this.dietary_preferences.diet_type) {
    switch(this.dietary_preferences.diet_type) {
      case 'keto':
        // 生酮饮食：高脂肪，中蛋白，极低碳水
        proteinPercentage = 25;
        carbsPercentage = 5;
        fatPercentage = 70;
        break;
      case 'paleo':
        // 古饮食：中高蛋白，中脂肪，低碳水
        proteinPercentage = 30;
        carbsPercentage = 30;
        fatPercentage = 40;
        break;
      case 'vegan':
      case 'vegetarian':
        // 素食：适当提高碳水，降低蛋白质
        if (proteinPercentage > 20) {
          const diff = proteinPercentage - 20;
          proteinPercentage = 20;
          carbsPercentage += diff;
        }
        break;
    }
  }
  
  // 针对健康状况进行调整
  if (this.health_conditions && this.health_conditions.length > 0) {
    if (this.health_conditions.includes('diabetes')) {
      // 糖尿病：降低碳水，增加蛋白质和健康脂肪
      carbsPercentage = Math.max(30, carbsPercentage - 15);
      proteinPercentage += 5;
      fatPercentage += 10;
    }
    
    if (this.health_conditions.includes('kidney_disease')) {
      // 肾病：降低蛋白质
      proteinPercentage = Math.min(proteinPercentage, 15);
      carbsPercentage += (25 - proteinPercentage);
    }
    
    if (this.health_conditions.includes('heart_disease')) {
      // 心脏疾病：降低饱和脂肪
      fatPercentage = Math.min(fatPercentage, 25);
      carbsPercentage += (30 - fatPercentage);
    }
  }
  
  // 确保百分比总和为100%
  const total = proteinPercentage + carbsPercentage + fatPercentage;
  if (total !== 100) {
    const factor = 100 / total;
    proteinPercentage = Math.round(proteinPercentage * factor);
    carbsPercentage = Math.round(carbsPercentage * factor);
    fatPercentage = Math.round(fatPercentage * factor);
    
    // 确保舍入后总和仍为100
    const newTotal = proteinPercentage + carbsPercentage + fatPercentage;
    if (newTotal !== 100) {
      carbsPercentage += (100 - newTotal);
    }
  }
  
  // 计算各宏量素的克数
  const proteinCalories = dailyCalories * (proteinPercentage / 100);
  const carbsCalories = dailyCalories * (carbsPercentage / 100);
  const fatCalories = dailyCalories * (fatPercentage / 100);
  
  // 蛋白质和碳水每克4卡路里，脂肪每克9卡路里
  const proteinGrams = Math.round(proteinCalories / 4);
  const carbsGrams = Math.round(carbsCalories / 4);
  const fatGrams = Math.round(fatCalories / 9);
  
  // 设置和保存营养目标
  this.nutrition_targets = {
    calories: dailyCalories,
    protein_percentage: proteinPercentage,
    carbs_percentage: carbsPercentage,
    fat_percentage: fatPercentage,
    protein_grams: proteinGrams,
    carbs_grams: carbsGrams,
    fat_grams: fatGrams
  };
  
  return this.nutrition_targets;
};

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
  if (this.dietary_preferences && this.dietary_preferences.allergies && 
      food.allergens && this.dietary_preferences.allergies.length > 0) {
    
    const allergicTo = this.dietary_preferences.allergies.filter(allergy => 
      food.allergens.includes(allergy)
    );
    
    if (allergicTo.length > 0) {
      compatible = false;
      reasons.push(`含有过敏原: ${allergicTo.join(', ')}`);
    }
  }
  
  // 检查避免的成分
  if (this.dietary_preferences && this.dietary_preferences.avoided_ingredients && 
      food.ingredients && this.dietary_preferences.avoided_ingredients.length > 0) {
    
    const avoidedIngredients = this.dietary_preferences.avoided_ingredients.filter(ingredient => 
      food.ingredients.some(foodIngredient => 
        foodIngredient.toLowerCase().includes(ingredient.toLowerCase())
      )
    );
    
    if (avoidedIngredients.length > 0) {
      compatible = false;
      reasons.push(`含有避免的成分: ${avoidedIngredients.join(', ')}`);
    }
  }
  
  // 检查饮食类型兼容性
  if (this.dietary_preferences && this.dietary_preferences.diet_type && 
      food.suitable_diets && food.suitable_diets.length > 0) {
    
    const dietType = this.dietary_preferences.diet_type;
    
    // 特殊饮食要求检查
    if ((dietType === 'vegetarian' && !food.suitable_diets.includes('vegetarian')) ||
        (dietType === 'vegan' && !food.suitable_diets.includes('vegan')) ||
        (dietType === 'gluten_free' && !food.suitable_diets.includes('gluten_free')) ||
        (dietType === 'dairy_free' && !food.suitable_diets.includes('dairy_free')) ||
        (dietType === 'keto' && !food.suitable_diets.includes('keto')) ||
        (dietType === 'paleo' && !food.suitable_diets.includes('paleo'))) {
      
      compatible = false;
      reasons.push(`不适合${dietType}饮食`);
    }
  }
  
  // 检查辣度偏好
  if (this.dietary_preferences && this.dietary_preferences.spicy_preference && 
      food.spicy_level) {
    
    const spicyPreference = this.dietary_preferences.spicy_preference;
    const spicyLevels = {
      'none': 0,
      'mild': 1,
      'medium': 2,
      'hot': 3,
      'extra_hot': 4
    };
    
    const preferredLevel = spicyLevels[spicyPreference] || 0;
    const foodLevel = spicyLevels[food.spicy_level] || 0;
    
    if (preferredLevel < foodLevel) {
      compatible = false;
      reasons.push(`辣度超过偏好 (食物辣度: ${food.spicy_level}, 偏好: ${spicyPreference})`);
    }
  }
  
  // 健康状况相关检查
  if (this.health_conditions && this.health_conditions.length > 0) {
    // 糖尿病检查高碳水
    if (this.health_conditions.includes('diabetes') && 
        food.nutrition_facts && food.nutrition_facts.carbohydrates > 30) {
      reasons.push('碳水含量高，糖尿病患者应注意控制摄入量');
    }
    
    // 高血压检查高钠
    if (this.health_conditions.includes('hypertension') && 
        food.nutrition_facts && food.nutrition_facts.sodium > 500) {
      reasons.push('钠含量高，高血压患者应注意控制摄入量');
    }
    
    // 心脏疾病检查高饱和脂肪
    if (this.health_conditions.includes('heart_disease') && 
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

nutritionProfileSchema.statics.findFamilyProfiles = function(userId) {
  return this.find({ user_id: userId, is_family_member: true });
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

// 前置钩子 - 自动计算BMI
nutritionProfileSchema.pre('save', function(next) {
  // 如果身高和体重有变化，自动更新BMI
  if (this.isModified('height') || this.isModified('weight')) {
    if (this.height && this.weight) {
      if (!this.health_metrics) this.health_metrics = {};
      
      const heightInMeters = this.height / 100;
      this.health_metrics.bmi = Math.round((this.weight / (heightInMeters * heightInMeters)) * 10) / 10;
    }
  }
  
  // 如果基础信息或健康目标变化，重新计算营养目标
  if (this.isNew || this.isModified('gender') || this.isModified('age') || 
      this.isModified('height') || this.isModified('weight') || 
      this.isModified('activity_level') || this.isModified('goals') ||
      (this.isModified('dietary_preferences') && this.dietary_preferences?.diet_type) ||
      this.isModified('health_conditions')) {
    
    this.calculateNutritionTargets();
  }
  
  next();
});

// 使用ModelFactory.model创建模型
const NutritionProfile = ModelFactory.model('NutritionProfile', nutritionProfileSchema);

module.exports = NutritionProfile; 