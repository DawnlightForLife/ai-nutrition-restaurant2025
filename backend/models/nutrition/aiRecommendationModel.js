const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 推荐菜品项目的子模式
const recommendedDishSchema = new mongoose.Schema({
  dish_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Dish',
    required: true
  },
  dish_name: {
    type: String,
    required: true
  },
  merchant_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant'
  },
  merchant_name: String,
  confidence_score: {
    type: Number,
    min: 0,
    max: 1,
    default: 0.5
  },
  match_reason: {
    type: String
  },
  nutrition_benefit: {
    type: String
  },
  health_benefit: {
    type: String
  },
  price: Number,
  calories: Number,
  protein: Number,
  carbs: Number,
  fat: Number,
  key_nutrients: [{
    name: String,
    amount: Number,
    unit: String,
    daily_value_percentage: Number
  }]
});

// 推荐套餐的子模式
const recommendedMealPlanSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: String,
  duration_days: {
    type: Number,
    default: 1
  },
  target_calories_per_day: Number,
  target_protein_per_day: Number,
  target_carbs_per_day: Number,
  target_fat_per_day: Number,
  daily_plans: [{
    day: Number,
    meals: [{
      meal_type: {
        type: String,
        enum: ['breakfast', 'lunch', 'dinner', 'snack']
      },
      dishes: [recommendedDishSchema]
    }]
  }]
});

const aiRecommendationSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  nutrition_profile_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile',
    required: true
  },
  // 推荐类型
  recommendation_type: {
    type: String,
    enum: ['dish', 'meal', 'meal_plan', 'diet_suggestion'],
    required: true
  },
  // 推荐时间点
  recommendation_time: {
    type: String,
    enum: ['breakfast', 'lunch', 'dinner', 'snack', 'any'],
    default: 'any'
  },
  // 推荐环境背景
  context: {
    location: {
      type: String,
      enum: ['home', 'work', 'restaurant', 'gym', 'travel', 'other'],
      default: 'any'
    },
    weather: String,
    season: String,
    special_occasion: String,
    time_constraint: {
      type: String,
      enum: ['quick', 'normal', 'leisurely', 'any'],
      default: 'any'
    }
  },
  // 筛选条件
  filters: {
    cuisine_preferences: [String],
    max_price: Number,
    merchant_types: [String],
    excluded_ingredients: [String],
    required_ingredients: [String],
    distance_limit: Number, // 公里
    health_focus: [String],
    calorie_range: {
      min: Number,
      max: Number
    },
    specific_nutrients: [{
      nutrient: String,
      min: Number,
      max: Number
    }]
  },
  // 位置信息（用于基于位置的推荐）
  location: {
    city: String,
    coordinates: {
      latitude: Number,
      longitude: Number
    }
  },
  // 推荐结果
  // 单个菜品推荐
  recommended_dishes: [recommendedDishSchema],
  // 套餐推荐
  recommended_meal: {
    meal_type: {
      type: String,
      enum: ['breakfast', 'lunch', 'dinner', 'snack']
    },
    dishes: [recommendedDishSchema],
    combined_nutrition: {
      calories: Number,
      protein: Number,
      carbs: Number,
      fat: Number,
      key_nutrients: [{
        name: String,
        amount: Number,
        unit: String,
        daily_value_percentage: Number
      }]
    },
    estimated_price: Number,
    matching_score: {
      type: Number,
      min: 0,
      max: 100
    }
  },
  // 膳食计划推荐
  recommended_meal_plan: recommendedMealPlanSchema,
  // 饮食建议（文本）
  diet_suggestions: [{
    suggestion: String,
    reasoning: String,
    scientific_basis: String,
    priority: {
      type: Number,
      min: 1,
      max: 5
    }
  }],
  // AI 分析
  analysis: {
    current_diet_analysis: String,
    nutrition_gaps: [String],
    health_insights: [String],
    improvement_areas: [String],
    achievement_recognitions: [String]
  },
  // AI 推荐的总体得分
  overall_score: {
    type: Number,
    min: 0,
    max: 100
  },
  // 推荐算法信息
  algorithm_info: {
    version: String,
    model_used: String,
    features_considered: [String],
    confidence: {
      type: Number,
      min: 0,
      max: 1
    }
  },
  // 推荐状态
  status: {
    type: String,
    enum: ['pending', 'processing', 'completed', 'failed', 'rejected'],
    default: 'pending'
  },
  error_message: String,
  // 用户反馈
  feedback: {
    liked: Boolean,
    rating: {
      type: Number,
      min: 1,
      max: 5
    },
    comments: String,
    follow_through: {
      type: String,
      enum: ['ordered', 'saved', 'ignored', 'unknown'],
      default: 'unknown'
    },
    followed_at: Date
  },
  // 关联的订单（如果用户根据推荐进行了订购）
  related_orders: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Order'
  }],
  // 隐私与访问控制
  privacy_level: {
    type: String,
    enum: ['private', 'share_with_nutritionist', 'share_with_merchant', 'public'],
    default: 'private'
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
    valid_until: Date,
    access_level: {
      type: String,
      enum: ['read', 'read_write'],
      default: 'read'
    },
    revoked: {
      type: Boolean,
      default: false
    },
    revoked_at: Date
  }],
  // 安全和审计
  access_log: [{
    timestamp: {
      type: Date,
      default: Date.now
    },
    accessed_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_log.accessed_by_type'
    },
    accessed_by_type: {
      type: String,
      enum: ['User', 'Nutritionist', 'Merchant', 'Admin', 'System']
    },
    ip_address: String,
    action: {
      type: String,
      enum: ['view', 'generate', 'update', 'delete', 'share', 'order']
    }
  }],
  // 营养师审核（可选）
  nutritionist_review: {
    reviewed_by: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Nutritionist'
    },
    reviewed_at: Date,
    approval_status: {
      type: String,
      enum: ['approved', 'approved_with_modifications', 'rejected'],
    },
    modifications: [{
      original_dish_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Dish'
      },
      replacement_dish_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Dish'
      },
      reason: String
    }],
    comments: String
  },
  // 过期和有效期
  expires_at: {
    type: Date
  },
  // 时间戳
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
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引以优化查询性能
aiRecommendationSchema.index({ user_id: 1, createdAt: -1 });
aiRecommendationSchema.index({ nutrition_profile_id: 1 });
aiRecommendationSchema.index({ recommendation_type: 1 });
aiRecommendationSchema.index({ status: 1 });
aiRecommendationSchema.index({ 'feedback.rating': 1 });
aiRecommendationSchema.index({ 'recommended_dishes.dish_id': 1 });
aiRecommendationSchema.index({ 'recommended_dishes.merchant_id': 1 });
aiRecommendationSchema.index({ privacy_level: 1 });
aiRecommendationSchema.index({ 'access_grants.granted_to': 1, 'access_grants.granted_to_type': 1 });
aiRecommendationSchema.index({ 'related_orders': 1 });
aiRecommendationSchema.index({ 'context.location': 1 });
aiRecommendationSchema.index({ 'context.weather': 1 });
aiRecommendationSchema.index({ 'context.season': 1 });
aiRecommendationSchema.index({ 'recommendation_time': 1 });

// 添加虚拟字段
aiRecommendationSchema.virtual('is_recent').get(function() {
  if (!this.createdAt) return false;
  
  const now = new Date();
  const recDate = new Date(this.createdAt);
  const diffDays = Math.floor((now - recDate) / (1000 * 60 * 60 * 24));
  
  return diffDays < 7; // 7天内的推荐视为近期
});

aiRecommendationSchema.virtual('dishes_count').get(function() {
  return this.recommended_dishes ? this.recommended_dishes.length : 0;
});

aiRecommendationSchema.virtual('has_feedback').get(function() {
  return !!(this.feedback && (this.feedback.rating || this.feedback.comments));
});

aiRecommendationSchema.virtual('meal_plan_days').get(function() {
  if (!this.recommended_meal_plan || !this.recommended_meal_plan.daily_plans) return 0;
  return this.recommended_meal_plan.daily_plans.length;
});

aiRecommendationSchema.virtual('has_been_ordered').get(function() {
  return !!(this.related_orders && this.related_orders.length > 0);
});

// 关联
aiRecommendationSchema.virtual('user', {
  ref: 'User',
  localField: 'user_id',
  foreignField: '_id',
  justOne: true
});

aiRecommendationSchema.virtual('nutrition_profile', {
  ref: 'NutritionProfile',
  localField: 'nutrition_profile_id',
  foreignField: '_id',
  justOne: true
});

aiRecommendationSchema.virtual('orders', {
  ref: 'Order',
  localField: 'related_orders',
  foreignField: '_id'
});

// 实例方法
aiRecommendationSchema.methods.calculateNutritionAlignment = function(nutritionProfile) {
  if (!nutritionProfile || !this.recommended_dishes || this.recommended_dishes.length === 0) {
    return { score: 0, details: '无法计算营养匹配度：缺少必要数据' };
  }
  
  // 获取用户的营养目标
  const targets = nutritionProfile.nutrition_targets || {};
  if (!targets.calories || !targets.protein_percentage || !targets.carbs_percentage || !targets.fat_percentage) {
    return { score: 0, details: '无法计算营养匹配度：缺少营养目标数据' };
  }
  
  // 计算推荐菜品的总营养
  const totalNutrition = {
    calories: 0,
    protein: 0,
    carbs: 0,
    fat: 0
  };
  
  this.recommended_dishes.forEach(dish => {
    totalNutrition.calories += dish.calories || 0;
    totalNutrition.protein += dish.protein || 0;
    totalNutrition.carbs += dish.carbs || 0;
    totalNutrition.fat += dish.fat || 0;
  });
  
  // 计算宏营养素比例
  const totalMacros = totalNutrition.protein + totalNutrition.carbs + totalNutrition.fat;
  let proteinPercentage = 0, carbsPercentage = 0, fatPercentage = 0;
  
  if (totalMacros > 0) {
    proteinPercentage = Math.round((totalNutrition.protein / totalMacros) * 100);
    carbsPercentage = Math.round((totalNutrition.carbs / totalMacros) * 100);
    fatPercentage = Math.round((totalNutrition.fat / totalMacros) * 100);
  }
  
  // 计算与目标的偏差
  const calorieDeviation = Math.abs(totalNutrition.calories - targets.calories) / targets.calories;
  const proteinDeviation = Math.abs(proteinPercentage - targets.protein_percentage) / targets.protein_percentage;
  const carbsDeviation = Math.abs(carbsPercentage - targets.carbs_percentage) / targets.carbs_percentage;
  const fatDeviation = Math.abs(fatPercentage - targets.fat_percentage) / targets.fat_percentage;
  
  // 计算总体匹配分数 (0-100)
  const calorieScore = Math.max(0, 100 - (calorieDeviation * 100));
  const proteinScore = Math.max(0, 100 - (proteinDeviation * 100));
  const carbsScore = Math.max(0, 100 - (carbsDeviation * 100));
  const fatScore = Math.max(0, 100 - (fatDeviation * 100));
  
  const totalScore = Math.round((calorieScore * 0.4) + (proteinScore * 0.3) + (carbsScore * 0.15) + (fatScore * 0.15));
  
  // 生成详细分析
  const details = `
    总热量: ${totalNutrition.calories}卡路里 (目标: ${targets.calories}卡路里, 匹配度: ${calorieScore.toFixed(0)}%)
    蛋白质: ${proteinPercentage}% (目标: ${targets.protein_percentage}%, 匹配度: ${proteinScore.toFixed(0)}%)
    碳水化合物: ${carbsPercentage}% (目标: ${targets.carbs_percentage}%, 匹配度: ${carbsScore.toFixed(0)}%)
    脂肪: ${fatPercentage}% (目标: ${targets.fat_percentage}%, 匹配度: ${fatScore.toFixed(0)}%)
  `;
  
  return {
    score: totalScore,
    details: details,
    nutrition_comparison: {
      actual: {
        calories: totalNutrition.calories,
        protein_percentage: proteinPercentage,
        carbs_percentage: carbsPercentage,
        fat_percentage: fatPercentage
      },
      target: {
        calories: targets.calories,
        protein_percentage: targets.protein_percentage,
        carbs_percentage: targets.carbs_percentage,
        fat_percentage: targets.fat_percentage
      }
    }
  };
};

aiRecommendationSchema.methods.updateFeedback = function(feedbackData) {
  if (!this.feedback) {
    this.feedback = {};
  }
  
  if (feedbackData.liked !== undefined) {
    this.feedback.liked = feedbackData.liked;
  }
  
  if (feedbackData.rating !== undefined) {
    this.feedback.rating = feedbackData.rating;
  }
  
  if (feedbackData.comments !== undefined) {
    this.feedback.comments = feedbackData.comments;
  }
  
  if (feedbackData.follow_through !== undefined) {
    this.feedback.follow_through = feedbackData.follow_through;
    this.feedback.followed_at = new Date();
  }
  
  return this;
};

aiRecommendationSchema.methods.linkOrder = function(orderId) {
  if (!this.related_orders) {
    this.related_orders = [];
  }
  
  // 检查订单是否已经链接
  const orderExists = this.related_orders.some(id => id.toString() === orderId.toString());
  
  if (!orderExists) {
    this.related_orders.push(orderId);
    
    // 更新反馈，标记为已订购
    if (!this.feedback) {
      this.feedback = {};
    }
    
    this.feedback.follow_through = 'ordered';
    this.feedback.followed_at = new Date();
  }
  
  return this;
};

// 授权访问方法
aiRecommendationSchema.methods.grantAccess = function(granteeId, granteeType, validUntil = null, reason = null) {
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
aiRecommendationSchema.methods.revokeAccess = function(granteeId, granteeType) {
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

// 更新推荐状态
aiRecommendationSchema.methods.updateStatus = function(newStatus, errorMessage = null) {
  this.status = newStatus;
  
  if (newStatus === 'failed' && errorMessage) {
    this.error_message = errorMessage;
  }
  
  return this;
};

// 静态方法
aiRecommendationSchema.statics.findByUserId = function(userId) {
  return this.find({ user_id: userId }).sort({ createdAt: -1 });
};

aiRecommendationSchema.statics.findRecentByUserId = function(userId, days = 30) {
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() - days);
  
  return this.find({
    user_id: userId,
    createdAt: { $gte: cutoffDate }
  }).sort({ createdAt: -1 });
};

aiRecommendationSchema.statics.findByType = function(userId, type) {
  return this.find({
    user_id: userId,
    recommendation_type: type,
    status: 'completed'
  }).sort({ createdAt: -1 });
};

aiRecommendationSchema.statics.findByProfileId = function(profileId) {
  return this.find({
    nutrition_profile_id: profileId,
    status: 'completed'
  }).sort({ createdAt: -1 });
};

aiRecommendationSchema.statics.findHighRated = function(userId) {
  return this.find({
    user_id: userId,
    'feedback.rating': { $gte: 4 },
    status: 'completed'
  }).sort({ 'feedback.rating': -1, createdAt: -1 });
};

aiRecommendationSchema.statics.findByDishId = function(dishId) {
  return this.find({
    'recommended_dishes.dish_id': dishId,
    status: 'completed'
  }).sort({ createdAt: -1 });
};

// Pre-save钩子
aiRecommendationSchema.pre('save', function(next) {
  // 如果是膳食计划推荐，自动计算每日总营养
  if (this.recommended_meal_plan && 
      this.recommended_meal_plan.daily_plans && 
      this.recommended_meal_plan.daily_plans.length > 0) {
    
    this.recommended_meal_plan.daily_plans.forEach(day => {
      let dailyCalories = 0;
      let dailyProtein = 0;
      let dailyCarbs = 0;
      let dailyFat = 0;
      
      if (day.meals && day.meals.length > 0) {
        day.meals.forEach(meal => {
          if (meal.dishes && meal.dishes.length > 0) {
            meal.dishes.forEach(dish => {
              dailyCalories += dish.calories || 0;
              dailyProtein += dish.protein || 0;
              dailyCarbs += dish.carbs || 0;
              dailyFat += dish.fat || 0;
            });
          }
        });
      }
      
      // 添加日总计
      day.daily_totals = {
        calories: dailyCalories,
        protein: dailyProtein,
        carbs: dailyCarbs,
        fat: dailyFat
      };
    });
  }
  
  // 如果是单餐推荐，自动计算总营养
  if (this.recommended_meal && 
      this.recommended_meal.dishes && 
      this.recommended_meal.dishes.length > 0) {
    
    let mealCalories = 0;
    let mealProtein = 0;
    let mealCarbs = 0;
    let mealFat = 0;
    let mealPrice = 0;
    
    this.recommended_meal.dishes.forEach(dish => {
      mealCalories += dish.calories || 0;
      mealProtein += dish.protein || 0;
      mealCarbs += dish.carbs || 0;
      mealFat += dish.fat || 0;
      mealPrice += dish.price || 0;
    });
    
    // 更新总计
    this.recommended_meal.combined_nutrition = {
      calories: mealCalories,
      protein: mealProtein,
      carbs: mealCarbs,
      fat: mealFat
    };
    
    this.recommended_meal.estimated_price = mealPrice;
  }
  
  // 如果添加了订单关联，自动更新反馈状态
  if (this.isModified('related_orders') && this.related_orders && this.related_orders.length > 0) {
    if (!this.feedback) {
      this.feedback = {};
    }
    
    this.feedback.follow_through = 'ordered';
    this.feedback.followed_at = new Date();
  }
  
  next();
});

// 使用ModelFactory创建模型
const AiRecommendation = ModelFactory.model('AiRecommendation', aiRecommendationSchema);

module.exports = AiRecommendation; 