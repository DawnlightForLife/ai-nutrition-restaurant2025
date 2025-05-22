const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 推荐菜品项目的子模式
const recommendedDishSchema = new mongoose.Schema({
  dishId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Dish',
    required: true,
    description: '菜品ID'
  },
  dishName: {
    type: String,
    required: true,
    description: '菜品名称'
  },
  merchantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    description: '商家ID'
  },
  merchantName: {
    type: String,
    description: '商家名称'
  },
  confidenceScore: {
    type: Number,
    min: 0,
    max: 1,
    default: 0.5,
    description: '推荐置信度（0-1）'
  },
  matchReason: {
    type: String,
    description: '匹配原因'
  },
  nutritionBenefit: {
    type: String,
    description: '营养益处'
  },
  healthBenefit: {
    type: String,
    description: '健康益处'
  },
  price: {
    type: Number,
    description: '价格'
  },
  calories: {
    type: Number,
    description: '卡路里'
  },
  protein: {
    type: Number,
    description: '蛋白质(g)'
  },
  carbs: {
    type: Number,
    description: '碳水化合物(g)'
  },
  fat: {
    type: Number,
    description: '脂肪(g)'
  },
  keyNutrients: [{
    name: {
      type: String,
      description: '营养素名称'
    },
    amount: {
      type: Number,
      description: '含量'
    },
    unit: {
      type: String,
      description: '单位'
    },
    dailyValuePercentage: {
      type: Number,
      description: '每日推荐值百分比'
    }
  }]
});

// 推荐套餐的子模式
const recommendedMealPlanSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    description: '套餐名称'
  },
  description: {
    type: String,
    description: '套餐描述'
  },
  durationDays: {
    type: Number,
    default: 1,
    description: '持续天数'
  },
  targetCaloriesPerDay: {
    type: Number,
    description: '每日目标卡路里'
  },
  targetProteinPerDay: {
    type: Number,
    description: '每日目标蛋白质(g)'
  },
  targetCarbsPerDay: {
    type: Number,
    description: '每日目标碳水化合物(g)'
  },
  targetFatPerDay: {
    type: Number,
    description: '每日目标脂肪(g)'
  },
  dailyPlans: [{
    day: {
      type: Number,
      description: '第几天'
    },
    meals: [{
      mealType: {
        type: String,
        enum: ['breakfast', 'lunch', 'dinner', 'snack'],
        description: '餐点类型'
      },
      dishes: [recommendedDishSchema]
    }]
  }]
});

const aiRecommendationSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
    description: '所属用户ID'
  },
  profileId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile',
    required: true,
    index: true,
    description: '对应的营养档案ID'
  },
  // 推荐类型
  recommendationType: {
    type: String,
    enum: ['meal_plan', 'nutrition_goal', 'alert', 'custom', 'dish', 'meal', 'diet_suggestion'],
    required: true,
    description: '推荐类型'
  },
  // 推荐时间点
  recommendationTime: {
    type: String,
    enum: ['breakfast', 'lunch', 'dinner', 'snack', 'any'],
    default: 'any',
    description: '推荐时间点'
  },
  // 推荐环境背景
  context: {
    location: {
      type: String,
      enum: ['home', 'work', 'restaurant', 'gym', 'travel', 'other'],
      default: 'any',
      description: '位置类型'
    },
    weather: {
      type: String,
      description: '天气'
    },
    season: {
      type: String,
      description: '季节'
    },
    specialOccasion: {
      type: String,
      description: '特殊场合'
    },
    timeConstraint: {
      type: String,
      enum: ['quick', 'normal', 'leisurely', 'any'],
      default: 'any',
      description: '时间限制'
    }
  },
  // 位置信息（用于基于位置的推荐）
  location: {
    city: {
      type: String,
      description: '城市'
    },
    coordinates: {
      latitude: {
        type: Number,
        description: '纬度'
      },
      longitude: {
        type: Number,
        description: '经度'
      }
    }
  },
  // 推荐结果数据结构化
  recommendationData: {
    // 单个菜品推荐
    dishes: [recommendedDishSchema],
    // 套餐推荐
    meal: {
      mealType: {
        type: String,
        enum: ['breakfast', 'lunch', 'dinner', 'snack'],
        description: '餐点类型'
      },
      dishes: [recommendedDishSchema],
      combinedNutrition: {
        calories: {
          type: Number,
          description: '总卡路里'
        },
        protein: {
          type: Number,
          description: '总蛋白质(g)'
        },
        carbs: {
          type: Number,
          description: '总碳水化合物(g)'
        },
        fat: {
          type: Number,
          description: '总脂肪(g)'
        },
        keyNutrients: [{
          name: {
            type: String,
            description: '营养素名称'
          },
          amount: {
            type: Number,
            description: '含量'
          },
          unit: {
            type: String,
            description: '单位'
          },
          dailyValuePercentage: {
            type: Number,
            description: '每日推荐值百分比'
          }
        }]
      },
      estimatedPrice: {
        type: Number,
        description: '估计价格'
      },
      matchingScore: {
        type: Number,
        min: 0,
        max: 100,
        description: '匹配得分(0-100)'
      }
    },
    // 膳食计划推荐
    mealPlan: recommendedMealPlanSchema,
    // 饮食建议（文本）
    dietSuggestions: [{
      suggestion: {
        type: String,
        description: '建议内容'
      },
      reasoning: {
        type: String,
        description: '建议理由'
      },
      scientificBasis: {
        type: String,
        description: '科学依据'
      },
      priority: {
        type: Number,
        min: 1,
        max: 5,
        default: 3,
        description: '优先级(1-5)'
      }
    }],
    // 摘要信息
    summary: {
      dailyCalories: {
        type: Number,
        description: '每日卡路里'
      },
      proteinPercentage: {
        type: Number,
        description: '蛋白质百分比'
      },
      carbsPercentage: {
        type: Number,
        description: '碳水化合物百分比'
      },
      fatPercentage: {
        type: Number,
        description: '脂肪百分比'
      },
      keyBenefits: {
        type: [String],
        description: '关键益处'
      },
      estimatedTotalCost: {
        type: Number,
        description: '预计总成本'
      }
    }
  },
  // 兼容之前的字段（为了保持兼容性）
  recommendedDishes: [recommendedDishSchema],
  recommendedMeal: {
    mealType: {
      type: String,
      enum: ['breakfast', 'lunch', 'dinner', 'snack'],
      description: '餐点类型'
    },
    dishes: [recommendedDishSchema],
    combinedNutrition: {
      calories: {
        type: Number,
        description: '总卡路里'
      },
      protein: {
        type: Number,
        description: '总蛋白质(g)'
      },
      carbs: {
        type: Number,
        description: '总碳水化合物(g)'
      },
      fat: {
        type: Number,
        description: '总脂肪(g)'
      },
      keyNutrients: [{
        name: {
          type: String,
          description: '营养素名称'
        },
        amount: {
          type: Number,
          description: '含量'
        },
        unit: {
          type: String,
          description: '单位'
        },
        dailyValuePercentage: {
          type: Number,
          description: '每日推荐值百分比'
        }
      }]
    },
    estimatedPrice: {
      type: Number,
      description: '估计价格'
    },
    matchingScore: {
      type: Number,
      min: 0,
      max: 100,
      description: '匹配得分(0-100)'
    }
  },
  recommendedMealPlan: recommendedMealPlanSchema,
  // AI 分析
  analysis: {
    currentDietAnalysis: {
      type: String,
      description: '当前饮食分析'
    },
    nutritionGaps: {
      type: [String],
      description: '营养缺口'
    },
    healthInsights: {
      type: [String],
      description: '健康洞察'
    },
    improvementAreas: {
      type: [String],
      description: '需改进领域'
    },
    achievementRecognitions: {
      type: [String],
      description: '已取得成就'
    }
  },
  // AI 推荐的总体得分
  overallScore: {
    type: Number,
    min: 0,
    max: 100,
    description: '总体得分(0-100)'
  },
  // 推荐算法信息
  algorithmInfo: {
    version: {
      type: String,
      description: '算法版本'
    },
    modelUsed: {
      type: String,
      description: '使用的模型'
    },
    featuresConsidered: {
      type: [String],
      description: '考虑的特征'
    },
    confidence: {
      type: Number,
      min: 0,
      max: 1,
      description: '置信度(0-1)'
    }
  },
  // 推荐状态
  status: {
    type: String,
    enum: ['pending', 'processing', 'generated', 'completed', 'failed', 'rejected', 'archived'],
    default: 'pending',
    description: '推荐状态'
  },
  errorMessage: {
    type: String,
    description: '错误信息'
  },
  // 用户反馈结构化
  feedback: {
    liked: {
      type: Boolean,
      description: '是否喜欢'
    },
    rating: {
      type: Number,
      min: 1,
      max: 5,
      default: null,
      description: '评分(1-5)'
    },
    comment: {
      type: String,
      description: '评论'
    },
    submittedAt: {
      type: Date,
      default: null,
      description: '提交时间'
    },
    followThrough: {
      type: String,
      enum: ['ordered', 'saved', 'ignored', 'unknown'],
      default: 'unknown',
      description: '后续行动'
    },
    followedAt: {
      type: Date,
      description: '行动时间'
    }
  },
  // 反馈状态
  feedbackStatus: {
    type: String,
    enum: ['pending', 'accepted', 'rejected', 'ignored'],
    default: 'pending',
    description: '反馈状态'
  },
  // 关联的订单（如果用户根据推荐进行了订购）
  relatedOrders: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Order',
    description: '关联订单'
  }],
  // 隐私与访问控制
  privacyLevel: {
    type: String,
    enum: ['private', 'share_with_nutritionist', 'share_with_merchant', 'public'],
    default: 'private',
    description: '隐私级别'
  },
  // 授权记录
  accessGrants: [{
    grantedTo: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'accessGrants.grantedToType',
      description: '被授权者ID'
    },
    grantedToType: {
      type: String,
      enum: ['Nutritionist', 'Merchant'],
      description: '被授权者类型'
    },
    grantedAt: {
      type: Date,
      default: Date.now,
      description: '授权时间'
    },
    validUntil: {
      type: Date,
      description: '有效期至'
    },
    accessLevel: {
      type: String,
      enum: ['read', 'read_write'],
      default: 'read',
      description: '访问级别'
    },
    revoked: {
      type: Boolean,
      default: false,
      description: '是否已撤销'
    },
    revokedAt: {
      type: Date,
      description: '撤销时间'
    }
  }],
  // 安全和审计
  accessLog: [{
    timestamp: {
      type: Date,
      default: Date.now,
      description: '访问时间'
    },
    accessedBy: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'accessLog.accessedByType',
      description: '访问者ID'
    },
    accessedByType: {
      type: String,
      enum: ['User', 'Nutritionist', 'Merchant', 'Admin', 'System'],
      description: '访问者类型'
    },
    ipAddress: {
      type: String,
      description: 'IP地址'
    },
    action: {
      type: String,
      enum: ['view', 'generate', 'update', 'delete', 'share', 'order'],
      description: '操作类型'
    }
  }],
  // 营养师审核（可选）
  nutritionistReview: {
    reviewedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Nutritionist',
      description: '审核营养师'
    },
    reviewedAt: {
      type: Date,
      description: '审核时间'
    },
    approvalStatus: {
      type: String,
      enum: ['approved', 'approved_with_modifications', 'rejected'],
      description: '批准状态'
    },
    modifications: [{
      originalDishId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Dish',
        description: '原菜品ID'
      },
      replacementDishId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Dish',
        description: '替换菜品ID'
      },
      reason: {
        type: String,
        description: '替换原因'
      }
    }],
    comments: {
      type: String,
      description: '评论'
    }
  },
  // 过期和有效期
  expiresAt: {
    type: Date,
    description: '过期时间'
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引以优化查询性能
aiRecommendationSchema.index({ userId: 1, createdAt: -1 });
aiRecommendationSchema.index({ profileId: 1 });
aiRecommendationSchema.index({ recommendationType: 1 });
aiRecommendationSchema.index({ status: 1 });
aiRecommendationSchema.index({ 'feedback.rating': 1 });
aiRecommendationSchema.index({ 'recommendedDishes.dishId': 1 });
aiRecommendationSchema.index({ 'recommendedDishes.merchantId': 1 });
aiRecommendationSchema.index({ privacyLevel: 1 });
aiRecommendationSchema.index({ 'accessGrants.grantedTo': 1, 'accessGrants.grantedToType': 1 });
aiRecommendationSchema.index({ 'relatedOrders': 1 });
aiRecommendationSchema.index({ 'context.location': 1 });
aiRecommendationSchema.index({ 'context.weather': 1 });
aiRecommendationSchema.index({ 'context.season': 1 });
aiRecommendationSchema.index({ 'recommendationTime': 1 });

// 添加虚拟字段
aiRecommendationSchema.virtual('isRecent').get(function() {
  if (!this.createdAt) return false;
  
  const now = new Date();
  const recDate = new Date(this.createdAt);
  const diffDays = Math.floor((now - recDate) / (1000 * 60 * 60 * 24));
  
  return diffDays < 7; // 7天内的推荐视为近期
});

aiRecommendationSchema.virtual('dishesCount').get(function() {
  return this.recommendedDishes ? this.recommendedDishes.length : 0;
});

aiRecommendationSchema.virtual('hasFeedback').get(function() {
  return !!(this.feedback && (this.feedback.rating || this.feedback.comment));
});

aiRecommendationSchema.virtual('mealPlanDays').get(function() {
  if (!this.recommendedMealPlan || !this.recommendedMealPlan.dailyPlans) return 0;
  return this.recommendedMealPlan.dailyPlans.length;
});

aiRecommendationSchema.virtual('hasBeenOrdered').get(function() {
  return !!(this.relatedOrders && this.relatedOrders.length > 0);
});

// 关联
aiRecommendationSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true
});

aiRecommendationSchema.virtual('nutritionProfile', {
  ref: 'NutritionProfile',
  localField: 'profileId',
  foreignField: '_id',
  justOne: true
});

aiRecommendationSchema.virtual('orders', {
  ref: 'Order',
  localField: 'relatedOrders',
  foreignField: '_id'
});

// 实例方法
aiRecommendationSchema.methods.calculateNutritionAlignment = function(nutritionProfile) {
  if (!nutritionProfile || !this.recommendedDishes || this.recommendedDishes.length === 0) {
    return { score: 0, details: '无法计算营养匹配度：缺少必要数据' };
  }
  
  // 获取用户的营养目标
  const targets = nutritionProfile.nutritionTargets || {};
  if (!targets.calories || !targets.proteinPercentage || !targets.carbsPercentage || !targets.fatPercentage) {
    return { score: 0, details: '无法计算营养匹配度：缺少营养目标数据' };
  }
  
  // 计算推荐菜品的总营养
  const totalNutrition = {
    calories: 0,
    protein: 0,
    carbs: 0,
    fat: 0
  };
  
  this.recommendedDishes.forEach(dish => {
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
  const proteinDeviation = Math.abs(proteinPercentage - targets.proteinPercentage) / targets.proteinPercentage;
  const carbsDeviation = Math.abs(carbsPercentage - targets.carbsPercentage) / targets.carbsPercentage;
  const fatDeviation = Math.abs(fatPercentage - targets.fatPercentage) / targets.fatPercentage;
  
  // 计算总体匹配分数 (0-100)
  const calorieScore = Math.max(0, 100 - (calorieDeviation * 100));
  const proteinScore = Math.max(0, 100 - (proteinDeviation * 100));
  const carbsScore = Math.max(0, 100 - (carbsDeviation * 100));
  const fatScore = Math.max(0, 100 - (fatDeviation * 100));
  
  const totalScore = Math.round((calorieScore * 0.4) + (proteinScore * 0.3) + (carbsScore * 0.15) + (fatScore * 0.15));
  
  // 生成详细分析
  const details = `
    总热量: ${totalNutrition.calories}卡路里 (目标: ${targets.calories}卡路里, 匹配度: ${calorieScore.toFixed(0)}%)
    蛋白质: ${proteinPercentage}% (目标: ${targets.proteinPercentage}%, 匹配度: ${proteinScore.toFixed(0)}%)
    碳水化合物: ${carbsPercentage}% (目标: ${targets.carbsPercentage}%, 匹配度: ${carbsScore.toFixed(0)}%)
    脂肪: ${fatPercentage}% (目标: ${targets.fatPercentage}%, 匹配度: ${fatScore.toFixed(0)}%)
  `;
  
  return {
    score: totalScore,
    details: details,
    nutritionComparison: {
      actual: {
        calories: totalNutrition.calories,
        proteinPercentage: proteinPercentage,
        carbsPercentage: carbsPercentage,
        fatPercentage: fatPercentage
      },
      target: {
        calories: targets.calories,
        proteinPercentage: targets.proteinPercentage,
        carbsPercentage: targets.carbsPercentage,
        fatPercentage: targets.fatPercentage
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
  
  if (feedbackData.comment !== undefined) {
    this.feedback.comment = feedbackData.comment;
  }
  
  if (feedbackData.followThrough !== undefined) {
    this.feedback.followThrough = feedbackData.followThrough;
    this.feedback.followedAt = new Date();
  }
  
  // 设置提交时间
  this.feedback.submittedAt = new Date();
  
  return this;
};

aiRecommendationSchema.methods.linkOrder = function(orderId) {
  if (!this.relatedOrders) {
    this.relatedOrders = [];
  }
  
  // 检查订单是否已经链接
  const orderExists = this.relatedOrders.some(id => id.toString() === orderId.toString());
  
  if (!orderExists) {
    this.relatedOrders.push(orderId);
    
    // 更新反馈，标记为已订购
    if (!this.feedback) {
      this.feedback = {};
    }
    
    this.feedback.followThrough = 'ordered';
    this.feedback.followedAt = new Date();
  }
  
  return this;
};

// 授权访问方法
aiRecommendationSchema.methods.grantAccess = function(granteeId, granteeType, validUntil = null, reason = null) {
  if (!this.accessGrants) {
    this.accessGrants = [];
  }
  
  // 检查是否已有授权
  const existingGrantIndex = this.accessGrants.findIndex(
    grant => grant.grantedTo.toString() === granteeId.toString() && 
             grant.grantedToType === granteeType &&
             !grant.revoked
  );
  
  if (existingGrantIndex !== -1) {
    // 更新现有授权
    this.accessGrants[existingGrantIndex].validUntil = validUntil;
    this.accessGrants[existingGrantIndex].reason = reason || this.accessGrants[existingGrantIndex].reason;
  } else {
    // 创建新授权
    this.accessGrants.push({
      grantedTo: granteeId,
      grantedToType: granteeType,
      grantedAt: new Date(),
      validUntil: validUntil,
      reason: reason
    });
  }
  
  return this;
};

// 撤销授权方法
aiRecommendationSchema.methods.revokeAccess = function(granteeId, granteeType) {
  if (!this.accessGrants) return false;
  
  let hasRevoked = false;
  
  this.accessGrants.forEach(grant => {
    if (grant.grantedTo.toString() === granteeId.toString() && 
        grant.grantedToType === granteeType && 
        !grant.revoked) {
      grant.revoked = true;
      grant.revokedAt = new Date();
      hasRevoked = true;
    }
  });
  
  return hasRevoked;
};

// 更新推荐状态
aiRecommendationSchema.methods.updateStatus = function(newStatus, errorMessage = null) {
  this.status = newStatus;
  
  if (newStatus === 'failed' && errorMessage) {
    this.errorMessage = errorMessage;
  }
  
  return this;
};

// 静态方法
aiRecommendationSchema.statics.findByUserId = function(userId) {
  return this.find({ userId: userId }).sort({ createdAt: -1 });
};

aiRecommendationSchema.statics.findRecentByUserId = function(userId, days = 30) {
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() - days);
  
  return this.find({
    userId: userId,
    createdAt: { $gte: cutoffDate }
  }).sort({ createdAt: -1 });
};

aiRecommendationSchema.statics.findByType = function(userId, type) {
  return this.find({
    userId: userId,
    recommendationType: type,
    status: 'completed'
  }).sort({ createdAt: -1 });
};

aiRecommendationSchema.statics.findByProfileId = function(profileId) {
  return this.find({
    profileId: profileId,
    status: 'completed'
  }).sort({ createdAt: -1 });
};

aiRecommendationSchema.statics.findHighRated = function(userId) {
  return this.find({
    userId: userId,
    'feedback.rating': { $gte: 4 },
    status: 'completed'
  }).sort({ 'feedback.rating': -1, createdAt: -1 });
};

aiRecommendationSchema.statics.findByDishId = function(dishId) {
  return this.find({
    'recommendedDishes.dishId': dishId,
    status: 'completed'
  }).sort({ createdAt: -1 });
};

// Pre-save钩子
aiRecommendationSchema.pre('save', function(next) {
  // 如果是膳食计划推荐，自动计算每日总营养
  if (this.recommendedMealPlan && 
      this.recommendedMealPlan.dailyPlans && 
      this.recommendedMealPlan.dailyPlans.length > 0) {
    
    this.recommendedMealPlan.dailyPlans.forEach(day => {
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
      day.dailyTotals = {
        calories: dailyCalories,
        protein: dailyProtein,
        carbs: dailyCarbs,
        fat: dailyFat
      };
    });
  }
  
  // 如果是单餐推荐，自动计算总营养
  if (this.recommendedMeal && 
      this.recommendedMeal.dishes && 
      this.recommendedMeal.dishes.length > 0) {
    
    let mealCalories = 0;
    let mealProtein = 0;
    let mealCarbs = 0;
    let mealFat = 0;
    let mealPrice = 0;
    
    this.recommendedMeal.dishes.forEach(dish => {
      mealCalories += dish.calories || 0;
      mealProtein += dish.protein || 0;
      mealCarbs += dish.carbs || 0;
      mealFat += dish.fat || 0;
      mealPrice += dish.price || 0;
    });
    
    // 更新总计
    this.recommendedMeal.combinedNutrition = {
      calories: mealCalories,
      protein: mealProtein,
      carbs: mealCarbs,
      fat: mealFat
    };
    
    this.recommendedMeal.estimatedPrice = mealPrice;
  }
  
  // 如果添加了订单关联，自动更新反馈状态
  if (this.isModified('relatedOrders') && this.relatedOrders && this.relatedOrders.length > 0) {
    if (!this.feedback) {
      this.feedback = {};
    }
    
    this.feedback.followThrough = 'ordered';
    this.feedback.followedAt = new Date();
  }
  
  next();
});

// 使用ModelFactory创建模型
const AiRecommendation = ModelFactory.createModel('AiRecommendation', aiRecommendationSchema);

module.exports = AiRecommendation; 