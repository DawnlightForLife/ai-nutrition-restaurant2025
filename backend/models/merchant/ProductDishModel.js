const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 营养成分的子模式
const nutritionFactsSchema = new mongoose.Schema({
  calories: {
    type: Number,
    default: 0
  },
  protein: {
    type: Number, // 克
    default: 0
  },
  fat: {
    type: Number, // 克
    default: 0
  },
  carbohydrates: {
    type: Number, // 克
    default: 0
  },
  fiber: {
    type: Number, // 克
    default: 0
  },
  sugar: {
    type: Number, // 克
    default: 0
  },
  sodium: {
    type: Number, // 毫克
    default: 0
  },
  cholesterol: {
    type: Number, // 毫克
    default: 0
  },
  vitamins: {
    a: Number, // 国际单位
    c: Number, // 毫克
    d: Number, // 国际单位
    e: Number, // 毫克
    k: Number, // 微克
    b6: Number, // 毫克
    b12: Number, // 微克
  },
  minerals: {
    calcium: Number, // 毫克
    iron: Number, // 毫克
    magnesium: Number, // 毫克
    potassium: Number, // 毫克
    zinc: Number, // 毫克
  }
});

const dishSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true
  },
  description: {
    type: String,
    required: true
  },
  imageUrl: {
    type: String
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  discountedPrice: {
    type: Number,
    min: 0
  },
  category: {
    type: String,
    enum: ['main_course', 'appetizer', 'soup', 'salad', 'dessert', 'beverage', 'package_meal', 'other'],
    required: true
  },
  subCategory: {
    type: String
  },
  tags: [{
    type: String
  }],
  // 营养成分
  nutritionFacts: nutritionFactsSchema,
  // 新增营养信息字段，包含基本营养数据
  nutritionInfo: {
    calories: {
      type: Number,
      default: 0
    },
    protein: {
      type: Number,
      default: 0
    },
    fat: {
      type: Number,
      default: 0
    },
    carbs: {
      type: Number,
      default: 0
    },
    sodium: {
      type: Number,
      default: 0
    }
  },
  // 营养属性（用于快速筛选和推荐）
  nutritionAttributes: [{
    type: String,
    enum: ['high_protein', 'low_fat', 'low_carb', 'high_fiber', 'low_sodium', 'keto_friendly', 'gluten_free', 'dairy_free', 'vegan', 'vegetarian', 'paleo_friendly', 'diabetic_friendly', 'high_calcium', 'high_iron', 'low_calorie', 'high_vitamin']
  }],
  // 食材列表
  ingredients: [{
    type: String
  }],
  allergens: [{
    type: String,
    enum: ['gluten', 'dairy', 'nuts', 'eggs', 'soy', 'fish', 'shellfish', 'peanuts', 'sesame', 'sulphites']
  }],
  spicyLevel: {
    type: Number,
    min: 0,
    max: 5,
    default: 0
  },
  preparationTime: {
    type: Number, // 分钟
    min: 0
  },
  // 地区和季节适应性
  regions: [{
    type: String,
    enum: ['north', 'south', 'east', 'west', 'northeast', 'northwest', 'southeast', 'southwest', 'central']
  }],
  seasons: [{
    type: String,
    enum: ['spring', 'summer', 'autumn', 'winter', 'all_year']
  }],
  // 如果是套餐，包含的菜品
  isPackage: {
    type: Boolean,
    default: false
  },
  packageDishes: [{
    dishId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Dish'
    },
    quantity: {
      type: Number,
      min: 1,
      default: 1
    }
  }],
  // 商家类型适应性
  suitableMerchantTypes: [{
    type: String,
    enum: ['restaurant', 'gym', 'maternity_center', 'school_company', 'all'],
    default: 'all'
  }],
  // 健康特性
  healthBenefits: [{
    targetCondition: {
      type: String,
      enum: ['weight_loss', 'diabetes', 'heart_health', 'pregnancy', 'muscle_gain', 'immune_support', 'general_health', 'other']
    },
    benefitDescription: String
  }],
  // 适合的饮食计划
  suitableDiets: [{
    type: String,
    enum: ['regular', 'keto', 'low_carb', 'mediterranean', 'dash', 'vegetarian', 'vegan', 'paleo', 'gluten_free', 'diabetic', 'pregnancy']
  }],
  // 适合的活动水平
  suitableActivityLevels: [{
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active', 'all']
  }],
  // 适合的年龄段
  suitableAgeGroups: [{
    type: String,
    enum: ['infant', 'child', 'teen', 'adult', 'senior', 'all']
  }],
  // 原产地/生产商信息
  origin: {
    country: String,
    region: String,
    producer: String
  },
  // 统计与评价
  isActive: {
    type: Boolean,
    default: true
  },
  ratings: {
    average: {
      type: Number,
      default: 0
    },
    count: {
      type: Number,
      default: 0
    }
  },
  // 访问控制与安全
  visibility: {
    type: String,
    enum: ['public', 'merchant_only', 'private'],
    default: 'public'
  },
  // 元数据信息
  metadata: {
    version: {
      type: String,
      default: '1.0'
    },
    revisionHistory: [{
      version: String,
      changes: [String],
      updatedAt: {
        type: Date,
        default: Date.now
      }
    }]
  },
  // 审计追踪
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  modifiedBy: [{
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    modifiedAt: {
      type: Date,
      default: Date.now
    },
    changes: [String]
  }],
  // 数据完整性验证
  verifiedNutritionData: {
    type: Boolean,
    default: false
  },
  nutritionDataVerifiedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Nutritionist'
  },
  nutritionDataVerifiedAt: Date
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
    attributes.add('high_protein');
  } else if (attributes.has('high_protein')) {
    attributes.delete('high_protein');
  }
  
  // 低脂肪检查 (<10g)
  if (nutrition.fat !== undefined && nutrition.fat < 10) {
    attributes.add('low_fat');
  } else if (attributes.has('low_fat')) {
    attributes.delete('low_fat');
  }
  
  // 低碳水检查 (<20g)
  if (nutrition.carbohydrates !== undefined && nutrition.carbohydrates < 20) {
    attributes.add('low_carb');
  } else if (attributes.has('low_carb')) {
    attributes.delete('low_carb');
  }
  
  // 高纤维检查 (>5g)
  if (nutrition.fiber !== undefined && nutrition.fiber > 5) {
    attributes.add('high_fiber');
  } else if (attributes.has('high_fiber')) {
    attributes.delete('high_fiber');
  }
  
  // 低钠检查 (<500mg)
  if (nutrition.sodium !== undefined && nutrition.sodium < 500) {
    attributes.add('low_sodium');
  } else if (attributes.has('low_sodium')) {
    attributes.delete('low_sodium');
  }
  
  // 低卡路里检查 (<300卡)
  if (nutrition.calories !== undefined && nutrition.calories < 300) {
    attributes.add('low_calorie');
  } else if (attributes.has('low_calorie')) {
    attributes.delete('low_calorie');
  }
  
  // 更新营养属性
  this.nutritionAttributes = Array.from(attributes);
  
  // 同步更新nutritionInfo字段
  if (this.nutritionFacts) {
    this.nutritionInfo = {
      calories: this.nutritionFacts.calories || 0,
      protein: this.nutritionFacts.protein || 0,
      fat: this.nutritionFacts.fat || 0,
      carbs: this.nutritionFacts.carbohydrates || 0,
      sodium: this.nutritionFacts.sodium || 0
    };
  }
  
  next();
});

// 计算并更新菜品的营养属性
dishSchema.methods.calculateNutritionAttributes = function() {
  const nutrition = this.nutritionFacts;
  const attributes = [];
  
  if (!nutrition) return attributes;
  
  // 高蛋白
  if (nutrition.protein >= 15) {
    attributes.push('high_protein');
  }
  
  // 低脂肪
  if (nutrition.fat <= 3) {
    attributes.push('low_fat');
  }
  
  // 低碳水
  if (nutrition.carbohydrates <= 10) {
    attributes.push('low_carb');
  }
  
  // 高纤维
  if (nutrition.fiber >= 5) {
    attributes.push('high_fiber');
  }
  
  // 低钠
  if (nutrition.sodium <= 140) {
    attributes.push('low_sodium');
  }
  
  // 低卡路里
  if (nutrition.calories <= 200) {
    attributes.push('low_calorie');
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
      case 'weight_loss': targetCondition = 'weight_loss'; break;
      case 'weight_gain': targetCondition = 'muscle_gain'; break;
      case 'muscle_gain': targetCondition = 'muscle_gain'; break;
      case 'health_improvement': targetCondition = 'general_health'; break;
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
    filterConditions.push({
      $or: [
        { suitableActivityLevels: nutritionProfile.activityLevel },
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
const ProductDish = ModelFactory.createModel('Dish', dishSchema);

module.exports = ProductDish; 