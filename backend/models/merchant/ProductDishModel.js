const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 营养成分的子模式（字段展平、命名统一为camelCase）
const nutritionFactsSchema = new mongoose.Schema({
  calories: {
    type: Number,
    default: 0,
    description: '卡路里'
  },
  protein: {
    type: Number, // 克
    default: 0,
    description: '蛋白质含量（克）'
  },
  fat: {
    type: Number, // 克
    default: 0,
    description: '脂肪含量（克）'
  },
  carbohydrates: {
    type: Number, // 克
    default: 0,
    description: '碳水化合物含量（克）'
  },
  fiber: {
    type: Number, // 克
    default: 0,
    description: '膳食纤维含量（克）'
  },
  sugar: {
    type: Number, // 克
    default: 0,
    description: '糖分含量（克）'
  },
  sodium: {
    type: Number, // 毫克
    default: 0,
    description: '钠含量（毫克）'
  },
  cholesterol: {
    type: Number, // 毫克
    default: 0,
    description: '胆固醇含量（毫克）'
  },
  vitaminA: { type: Number, description: '维生素A（国际单位）' },
  vitaminC: { type: Number, description: '维生素C（毫克）' },
  vitaminD: { type: Number, description: '维生素D（国际单位）' },
  vitaminE: { type: Number, description: '维生素E（毫克）' },
  vitaminK: { type: Number, description: '维生素K（微克）' },
  vitaminB6: { type: Number, description: '维生素B6（毫克）' },
  vitaminB12: { type: Number, description: '维生素B12（微克）' },
  calcium: { type: Number, description: '钙含量（毫克）' },
  iron: { type: Number, description: '铁含量（毫克）' },
  magnesium: { type: Number, description: '镁含量（毫克）' },
  potassium: { type: Number, description: '钾含量（毫克）' },
  zinc: { type: Number, description: '锌含量（毫克）' },
  sensitivityLevel: { type: Number, enum: [1, 2, 3], default: 3 } // 敏感级别：营养字段
});

const dishSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
    description: '菜品名称'
  },
  description: {
    type: String,
    required: true,
    description: '菜品描述'
  },
  imageUrl: {
    type: String,
    description: '菜品图片URL'
  },
  price: {
    type: Number,
    required: true,
    min: 0,
    description: '原始价格'
  },
  discountedPrice: {
    type: Number,
    min: 0,
    description: '折扣价'
  },
  category: {
    type: String,
    enum: ['mainCourse', 'appetizer', 'soup', 'salad', 'dessert', 'beverage', 'packageMeal', 'other'],
    required: true,
    description: '菜品类别'
  },
  subCategory: {
    type: String,
    description: '子类别'
  },
  tags: [{
    type: String,
    description: '标签'
  }],
  // 营养成分
  nutritionFacts: {
    type: nutritionFactsSchema,
    description: '营养成分详细信息',
    sensitivityLevel: { type: Number, enum: [1, 2, 3], default: 3 }
  },
  // nutritionInfo 字段已移除，统一使用 nutritionFacts
  // 营养属性（用于快速筛选和推荐）
  nutritionAttributes: [{
    type: String,
    enum: [
      'highProtein', 'lowFat', 'lowCarb', 'highFiber', 'lowSodium',
      'ketoFriendly', 'glutenFree', 'dairyFree', 'vegan', 'vegetarian',
      'paleoFriendly', 'diabeticFriendly', 'highCalcium', 'highIron',
      'lowCalorie', 'highVitamin'
    ],
    description: '营养属性标签'
  }],
  // 食材列表
  ingredients: [{
    type: String,
    description: '食材'
  }],
  allergens: [{
    type: String,
    enum: [
      'gluten', 'dairy', 'nuts', 'eggs', 'soy', 'fish',
      'shellfish', 'peanuts', 'sesame', 'sulphites'
    ],
    description: '过敏原'
  }],
  spicyLevel: {
    type: Number,
    min: 0,
    max: 5,
    default: 0,
    description: '辣度等级'
  },
  preparationTime: {
    type: Number, // 分钟
    min: 0,
    description: '准备时间（分钟）'
  },
  // 地区和季节适应性
  regions: [{
    type: String,
    enum: [
      'north', 'south', 'east', 'west', 'northeast',
      'northwest', 'southeast', 'southwest', 'central'
    ],
    description: '适用地区'
  }],
  seasons: [{
    type: String,
    enum: ['spring', 'summer', 'autumn', 'winter', 'allYear'],
    description: '适用季节'
  }],
  // 如果是套餐，包含的菜品
  isPackage: {
    type: Boolean,
    default: false,
    description: '是否为套餐'
  },
  packageDishes: [{
    dishId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Dish',
      description: '套餐包含的菜品ID'
    },
    quantity: {
      type: Number,
      min: 1,
      default: 1,
      description: '菜品数量'
    }
  }],
  // 商家类型适应性
  suitableMerchantTypes: [{
    type: String,
    enum: [
      'restaurant', 'gym', 'maternityCenter', 'schoolCompany', 'all'
    ],
    default: 'all',
    description: '适合的商家类型'
  }],
  // 健康特性
  healthBenefits: [{
    targetCondition: {
      type: String,
      enum: [
        'weightLoss', 'diabetes', 'heartHealth', 'pregnancy',
        'muscleGain', 'immuneSupport', 'generalHealth', 'other'
      ],
      description: '目标健康状况'
    },
    benefitDescription: {
      type: String,
      description: '健康益处描述'
    }
  }],
  // 适合的饮食计划
  suitableDiets: [{
    type: String,
    enum: [
      'regular', 'keto', 'lowCarb', 'mediterranean', 'dash',
      'vegetarian', 'vegan', 'paleo', 'glutenFree', 'diabetic', 'pregnancy'
    ],
    description: '适合的饮食计划'
  }],
  // 适合的活动水平
  suitableActivityLevels: [{
    type: String,
    enum: [
      'sedentary', 'light', 'moderate', 'active', 'veryActive', 'all'
    ],
    description: '适合的活动水平'
  }],
  // 适合的年龄段
  suitableAgeGroups: [{
    type: String,
    enum: ['infant', 'child', 'teen', 'adult', 'senior', 'all'],
    description: '适合的年龄段'
  }],
  // 原产地/生产商信息
  origin: {
    country: { type: String, description: '原产国' },
    region: { type: String, description: '原产地区' },
    producer: { type: String, description: '生产商' }
  },
  // 统计与评价
  isActive: {
    type: Boolean,
    default: true,
    description: '是否上架'
  },
  ratings: {
    average: {
      type: Number,
      default: 0,
      description: '平均评分'
    },
    count: {
      type: Number,
      default: 0,
      description: '评分人数'
    }
  },
  // 访问控制与安全
  visibility: {
    type: String,
    enum: ['public', 'merchantOnly', 'private'],
    default: 'public',
    description: '可见性'
  },
  // 元数据信息
  metadata: {
    version: {
      type: String,
      default: '1.0',
      description: '元数据版本'
    },
    revisionHistory: [{
      version: { type: String, description: '版本号' },
      changes: [{ type: String, description: '更改内容' }]
      // updatedAt 字段已移除，由 timestamps 统一管理
    }]
  },
  // 审计追踪
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '创建人',
    sensitivityLevel: 2
  },
  modifiedBy: [{
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      description: '修改人',
      sensitivityLevel: 2
    },
    // modifiedAt 字段移除（由 timestamps 统一管理）
    changes: [{ type: String, description: '变更字段' }]
  }],
  // 数据完整性验证
  verifiedNutritionData: {
    type: Boolean,
    default: false,
    description: '营养数据已验证'
  },
  nutritionDataVerifiedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Nutritionist',
    description: '营养师ID',
    sensitivityLevel: 2
  },
  nutritionDataVerifiedAt: {
    type: Date,
    description: '营养数据验证时间'
  }
}, { 
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引用于搜索
dishSchema.index({ name: 'text', description: 'text', tags: 'text', ingredients: 'text' });
dishSchema.index({ category: 1 });
dishSchema.index({ 'nutritionAttributes': 1 });
dishSchema.index({ 'allergens': 1 });
dishSchema.index({ 'regions': 1 });
dishSchema.index({ 'seasons': 1 });
dishSchema.index({ 'suitableMerchantTypes': 1 });
dishSchema.index({ 'healthBenefits.targetCondition': 1 });
dishSchema.index({ 'suitableDiets': 1 });
dishSchema.index({ isActive: 1 });
dishSchema.index({ visibility: 1 });
dishSchema.index({ createdBy: 1 });
dishSchema.index({ tags: 1 });
dishSchema.index({ 'ratings.average': -1 }); // 用于按评分排序
dishSchema.index({ price: 1 }); // 价格排序
dishSchema.index({ merchantId: 1, isActive: 1 }); // 查询特定商家的活跃菜品

// 添加虚拟字段
dishSchema.virtual('hasDiscount').get(function() {
  return this.discountedPrice && this.discountedPrice < this.price;
});

dishSchema.virtual('discountPercentage').get(function() {
  if (!this.hasDiscount) return 0;
  return Math.round(((this.price - this.discountedPrice) / this.price) * 100);
});

dishSchema.virtual('finalPrice').get(function() {
  if (this.hasDiscount) return this.discountedPrice;
  return this.price;
});

dishSchema.virtual('caloriesPerPrice').get(function() {
  if (!this.nutritionFacts || !this.nutritionFacts.calories) return 0;
  const effectivePrice = this.finalPrice || 1; // 避免除以零
  return Math.round(this.nutritionFacts.calories / effectivePrice);
});

dishSchema.virtual('proteinPerPrice').get(function() {
  if (!this.nutritionFacts || !this.nutritionFacts.protein) return 0;
  const effectivePrice = this.finalPrice || 1; // 避免除以零
  return Math.round(this.nutritionFacts.protein / effectivePrice);
});

// 商家关联
dishSchema.virtual('merchant', {
  ref: 'Merchant',
  localField: 'merchantId',
  foreignField: '_id',
  justOne: true
});

// 实例方法
dishSchema.methods.isAllergicFor = function(allergens) {
  if (!this.allergens || !Array.isArray(allergens)) return false;
  
  // 检查是否有任何过敏原重叠
  return allergens.some(allergen => this.allergens.includes(allergen));
};

dishSchema.methods.isSuitableFor = function(diet) {
  if (!this.suitableDiets) return false;
  return this.suitableDiets.includes(diet);
};

dishSchema.methods.isSuitableForHealthCondition = function(condition) {
  if (!this.healthBenefits) return false;
  return this.healthBenefits.some(benefit => benefit.targetCondition === condition);
};

dishSchema.methods.getNutritionalValue = function() {
  const nutrition = this.nutritionFacts || {};
  
  // 计算宏量素百分比
  let totalMacros = (nutrition.protein || 0) + (nutrition.fat || 0) + (nutrition.carbohydrates || 0);
  totalMacros = totalMacros || 1; // 避免除以零
  
  const proteinPercentage = Math.round(((nutrition.protein || 0) / totalMacros) * 100);
  const fatPercentage = Math.round(((nutrition.fat || 0) / totalMacros) * 100);
  const carbsPercentage = Math.round(((nutrition.carbohydrates || 0) / totalMacros) * 100);
  
  return {
    calories: nutrition.calories || 0,
    protein: nutrition.protein || 0,
    fat: nutrition.fat || 0,
    carbohydrates: nutrition.carbohydrates || 0,
    macroRatio: {
      protein: proteinPercentage,
      fat: fatPercentage,
      carbs: carbsPercentage
    },
    // 为前端生成友好的描述
    nutritionSummary: `${nutrition.calories || 0}卡路里, 蛋白质${proteinPercentage}%, 脂肪${fatPercentage}%, 碳水${carbsPercentage}%`
  };
};

// 静态方法
dishSchema.statics.findByNutritionAttribute = function(attribute) {
  return this.find({ nutritionAttributes: attribute, isActive: true });
};

dishSchema.statics.findBySuitableDiet = function(diet) {
  return this.find({ suitableDiets: diet, isActive: true });
};

dishSchema.statics.findByHealthCondition = function(condition) {
  return this.find({ 
    'healthBenefits.targetCondition': condition,
    isActive: true 
  });
};

dishSchema.statics.findHighProtein = function(proteinThreshold = 20) {
  return this.find({ 
    'nutritionFacts.protein': { $gte: proteinThreshold },
    isActive: true 
  });
};

dishSchema.statics.getTopRated = function(limit = 10) {
  return this.find({ isActive: true })
    .sort({ 'ratings.average': -1 })
    .limit(limit);
};

// 更新前钩子
dishSchema.pre('save', function(next) {
  // 如果不是新文档且有当前用户ID，记录修改信息
  if (!this.isNew && this._current_user_id) {
    const changedFields = this.modifiedPaths().filter(
      path => !path.startsWith('updatedAt') && !path.startsWith('modifiedBy')
    );
    if (changedFields.length > 0) {
      if (!this.modifiedBy) {
        this.modifiedBy = [];
      }
      this.modifiedBy.push({
        userId: this._current_user_id,
        modifiedAt: Date.now(),
        changes: changedFields
      });
    }
  }

  // 自动判断并更新营养属性标签
  const nutrition = this.nutritionFacts || {};
  const attributes = new Set(this.nutritionAttributes || []);

  // 高蛋白质检查 (>20g)
  if (nutrition.protein >= 20) {
    attributes.add('highProtein');
  } else if (attributes.has('highProtein')) {
    attributes.delete('highProtein');
  }

  // 低脂肪检查 (<10g)
  if (nutrition.fat !== undefined && nutrition.fat < 10) {
    attributes.add('lowFat');
  } else if (attributes.has('lowFat')) {
    attributes.delete('lowFat');
  }

  // 低碳水检查 (<20g)
  if (nutrition.carbohydrates !== undefined && nutrition.carbohydrates < 20) {
    attributes.add('lowCarb');
  } else if (attributes.has('lowCarb')) {
    attributes.delete('lowCarb');
  }

  // 高纤维检查 (>5g)
  if (nutrition.fiber !== undefined && nutrition.fiber > 5) {
    attributes.add('highFiber');
  } else if (attributes.has('highFiber')) {
    attributes.delete('highFiber');
  }

  // 低钠检查 (<500mg)
  if (nutrition.sodium !== undefined && nutrition.sodium < 500) {
    attributes.add('lowSodium');
  } else if (attributes.has('lowSodium')) {
    attributes.delete('lowSodium');
  }

  // 低卡路里检查 (<300卡)
  if (nutrition.calories !== undefined && nutrition.calories < 300) {
    attributes.add('lowCalorie');
  } else if (attributes.has('lowCalorie')) {
    attributes.delete('lowCalorie');
  }

  // 更新营养属性
  this.nutritionAttributes = Array.from(attributes);

  // nutritionInfo 字段已废弃，无需同步，仅操作 nutritionFacts
  next();
});

// 计算并更新菜品的营养属性
dishSchema.methods.calculateNutritionAttributes = function() {
  const nutrition = this.nutritionFacts;
  const attributes = [];
  
  if (!nutrition) return attributes;
  
  // 高蛋白
  if (nutrition.protein >= 15) {
    attributes.push('highProtein');
  }
  
  // 低脂肪
  if (nutrition.fat <= 3) {
    attributes.push('lowFat');
  }
  
  // 低碳水
  if (nutrition.carbohydrates <= 10) {
    attributes.push('lowCarb');
  }
  
  // 高纤维
  if (nutrition.fiber >= 5) {
    attributes.push('highFiber');
  }
  
  // 低钠
  if (nutrition.sodium <= 140) {
    attributes.push('lowSodium');
  }
  
  // 低卡路里
  if (nutrition.calories <= 200) {
    attributes.push('lowCalorie');
  }
  
  // 更新营养属性
  this.nutritionAttributes = attributes;
  
  return attributes;
};

// 验证菜品是否适合特定商家类型
dishSchema.methods.isSuitableForMerchantType = function(merchantType) {
  if (!this.suitableMerchantTypes || this.suitableMerchantTypes.length === 0) {
    return true; // 如果未设置，默认适合所有商家类型
  }
  
  return this.suitableMerchantTypes.includes(merchantType) || 
         this.suitableMerchantTypes.includes('all');
};

// 获取套餐总价格
dishSchema.methods.getPackageTotalPrice = async function() {
  if (!this.isPackage || !this.packageDishes || this.packageDishes.length === 0) {
    return this.price;
  }
  
  let totalPrice = 0;
  
  // 计算组成菜品的总价
  for (const item of this.packageDishes) {
    const dish = await this.model('Dish').findById(item.dishId);
    if (dish) {
      totalPrice += (dish.price * item.quantity);
    }
  }
  
  return totalPrice;
};

// 添加营养专家验证
dishSchema.methods.verifyNutritionData = function(nutritionistId) {
  this.verifiedNutritionData = true;
  this.nutritionDataVerifiedBy = nutritionistId;
  this.nutritionDataVerifiedAt = Date.now();
};

// 适合特定用户的静态方法
dishSchema.statics.findSuitableForUser = async function(user, nutritionProfile, options = {}) {
  if (!user || !nutritionProfile) {
    return this.find({ isActive: true, visibility: 'public' }).exec();
  }
  
  // 基础查询条件
  const query = { 
    isActive: true,
    $or: [
      { visibility: 'public' },
      { createdBy: user._id }
    ]
  };
  
  // 添加过滤条件
  const filterConditions = [];
  
  // 1. 考虑饮食偏好
  if (nutritionProfile.dietaryPreferences) {
    // 排除用户过敏食材
    if (nutritionProfile.dietaryPreferences.allergies && 
        nutritionProfile.dietaryPreferences.allergies.length > 0) {
      query.allergens = { $nin: nutritionProfile.dietaryPreferences.allergies };
    }
    
    // 排除用户避免的食材
    if (nutritionProfile.dietaryPreferences.avoidedIngredients && 
        nutritionProfile.dietaryPreferences.avoidedIngredients.length > 0) {
      query.ingredients = { $nin: nutritionProfile.dietaryPreferences.avoidedIngredients };
    }
    
    // 考虑用户的菜系偏好
    if (nutritionProfile.dietaryPreferences.cuisinePreference && 
        nutritionProfile.dietaryPreferences.cuisinePreference !== 'other') {
      // 将用户菜系偏好映射到区域
      let regionPreference;
      switch(nutritionProfile.dietaryPreferences.cuisinePreference) {
        case 'north': regionPreference = ['north', 'northeast', 'northwest']; break;
        case 'south': regionPreference = ['south', 'southeast', 'southwest']; break;
        case 'east': regionPreference = ['east', 'southeast', 'northeast']; break;
        case 'west': regionPreference = ['west', 'southwest', 'northwest']; break;
        case 'sichuan': regionPreference = ['southwest']; break;
        case 'cantonese': regionPreference = ['south']; break;
        case 'hunan': regionPreference = ['central']; break;
        default: regionPreference = null;
      }
      
      if (regionPreference) {
        filterConditions.push({ regions: { $in: regionPreference } });
      }
    }
    
    // 考虑用户的辣度偏好
    if (nutritionProfile.dietaryPreferences.spicyPreference) {
      let spicyLevel;
      switch(nutritionProfile.dietaryPreferences.spicyPreference) {
        case 'none': spicyLevel = 0; break;
        case 'mild': spicyLevel = { $lte: 2 }; break;
        case 'medium': spicyLevel = { $lte: 3 }; break;
        case 'hot': spicyLevel = { $lte: 4 }; break;
        case 'extra_hot': spicyLevel = { $lte: 5 }; break;
        default: spicyLevel = null;
      }
      
      if (spicyLevel !== null) {
        query.spicyLevel = spicyLevel;
      }
    }
  }
  
  // 2. 考虑健康目标
  if (nutritionProfile.goals) {
    let targetCondition;
    switch(nutritionProfile.goals) {
      case 'weight_loss': targetCondition = 'weightLoss'; break;
      case 'weight_gain': targetCondition = 'muscleGain'; break;
      case 'muscle_gain': targetCondition = 'muscleGain'; break;
      case 'health_improvement': targetCondition = 'generalHealth'; break;
      default: targetCondition = null;
    }
    
    if (targetCondition) {
      filterConditions.push({
        'healthBenefits.targetCondition': targetCondition
      });
    }
  }
  
  // 3. 考虑活动水平
  if (nutritionProfile.activityLevel) {
    let mappedLevel = nutritionProfile.activityLevel;
    // 兼容旧值映射
    if (mappedLevel === 'very_active') mappedLevel = 'veryActive';
    filterConditions.push({
      $or: [
        { suitableActivityLevels: mappedLevel },
        { suitableActivityLevels: 'all' }
      ]
    });
  }
  
  // 4. 考虑年龄组
  let ageGroup = 'adult'; // 默认成人
  if (nutritionProfile.age) {
    if (nutritionProfile.age < 13) {
      ageGroup = 'child';
    } else if (nutritionProfile.age < 20) {
      ageGroup = 'teen';
    } else if (nutritionProfile.age >= 65) {
      ageGroup = 'senior';
    }
  }
  
  filterConditions.push({
    $or: [
      { suitableAgeGroups: ageGroup },
      { suitableAgeGroups: 'all' }
    ]
  });
  
  // 如果有过滤条件，使用$and合并
  if (filterConditions.length > 0) {
    // 给基础查询条件添加额外的匹配项，提高相关性
    query.$and = filterConditions;
  }
  
  // 设置排序
  const sort = options.sort || { 'ratings.average': -1 };
  
  // 执行查询
  return this.find(query).sort(sort).exec();
};

// 使用ModelFactory创建支持读写分离的菜品模型
const productDish = ModelFactory.createModel('Dish', dishSchema);

module.exports = productDish;