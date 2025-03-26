const mongoose = require('mongoose');

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
});

// 创建索引
aiRecommendationSchema.index({ user_id: 1, created_at: -1 });
aiRecommendationSchema.index({ nutrition_profile_id: 1 });
aiRecommendationSchema.index({ recommendation_type: 1 });
aiRecommendationSchema.index({ status: 1 });
aiRecommendationSchema.index({ 'recommended_dishes.dish_id': 1 });
aiRecommendationSchema.index({ 'recommended_dishes.merchant_id': 1 });
aiRecommendationSchema.index({ 'access_grants.granted_to': 1, 'access_grants.granted_to_type': 1 });
aiRecommendationSchema.index({ 'feedback.rating': 1 });
aiRecommendationSchema.index({ 'nutritionist_review.reviewed_by': 1 });
// 添加TTL索引，使推荐数据7天后自动过期删除
aiRecommendationSchema.index({ expires_at: 1 }, { expireAfterSeconds: 0 });
// 添加部分索引，仅对完成且未被用户喜欢的推荐创建索引，用于记录不受欢迎的推荐
aiRecommendationSchema.index(
  { created_at: -1 },
  { partialFilterExpression: { status: 'completed', 'feedback.liked': false } }
);
// 为位置信息创建索引以支持地理位置搜索
aiRecommendationSchema.index({ 'location.coordinates': '2dsphere' });

// 更新前自动更新时间和设置过期时间
aiRecommendationSchema.pre('save', function(next) {
  const now = Date.now();
  this.updated_at = now;
  
  // 如果是新创建的且未设置过期时间，则默认设置为7天后
  if (this.isNew && !this.expires_at) {
    const expiry = new Date();
    expiry.setDate(expiry.getDate() + 7);
    this.expires_at = expiry;
  }
  
  next();
});

// 授权访问方法
aiRecommendationSchema.methods.grantAccess = function(granteeId, granteeType, validUntil, accessLevel = 'read') {
  if (!this.access_grants) {
    this.access_grants = [];
  }
  
  // 检查是否已存在授权
  const existingGrant = this.access_grants.find(
    g => g.granted_to.equals(granteeId) && g.granted_to_type === granteeType && !g.revoked
  );
  
  if (existingGrant) {
    // 更新现有授权
    existingGrant.valid_until = validUntil;
    existingGrant.access_level = accessLevel;
  } else {
    // 创建新授权
    this.access_grants.push({
      granted_to: granteeId,
      granted_to_type: granteeType,
      granted_at: Date.now(),
      valid_until: validUntil,
      access_level: accessLevel
    });
  }
};

// 撤销授权方法
aiRecommendationSchema.methods.revokeAccess = function(granteeId, granteeType) {
  if (!this.access_grants) return false;
  
  let found = false;
  this.access_grants.forEach(grant => {
    if (grant.granted_to.equals(granteeId) && grant.granted_to_type === granteeType && !grant.revoked) {
      grant.revoked = true;
      grant.revoked_at = Date.now();
      found = true;
    }
  });
  
  return found;
};

// 记录访问方法
aiRecommendationSchema.methods.logAccess = async function(userId, userType, ipAddress, action) {
  if (!this.access_log) {
    this.access_log = [];
  }
  
  // 保持日志大小合理
  if (this.access_log.length >= 20) {
    this.access_log = this.access_log.slice(-19);
  }
  
  // 添加新的访问记录
  this.access_log.push({
    timestamp: Date.now(),
    accessed_by: userId,
    accessed_by_type: userType,
    ip_address: ipAddress,
    action: action
  });
  
  await this.save();
};

// 添加营养师审核
aiRecommendationSchema.methods.addNutritionistReview = function(nutritionistId, approvalStatus, comments, modifications = []) {
  this.nutritionist_review = {
    reviewed_by: nutritionistId,
    reviewed_at: Date.now(),
    approval_status: approvalStatus,
    modifications: modifications,
    comments: comments
  };
};

// 根据推荐创建订单
aiRecommendationSchema.methods.createOrder = async function(merchantId, userSelectedDishes = []) {
  try {
    // 如果用户未选择具体菜品，使用推荐的所有菜品
    const dishItems = userSelectedDishes.length > 0 
      ? userSelectedDishes 
      : this.recommended_dishes.map(dish => ({
          dish_id: dish.dish_id,
          name: dish.dish_name,
          price: dish.price,
          quantity: 1,
          item_total: dish.price
        }));
    
    if (dishItems.length === 0) {
      throw new Error('没有可用的菜品创建订单');
    }
    
    // 获取商家信息
    const Merchant = mongoose.model('Merchant');
    const merchant = await Merchant.findById(merchantId);
    if (!merchant) {
      throw new Error('商家不存在');
    }
    
    // 计算订单总价
    const subtotal = dishItems.reduce((sum, item) => sum + item.item_total, 0);
    
    // 创建订单对象
    const Order = mongoose.model('Order');
    const newOrder = new Order({
      user_id: this.user_id,
      merchant_id: merchantId,
      merchant_type: merchant.business_type,
      items: dishItems,
      nutrition_profile_id: this.nutrition_profile_id,
      ai_recommendation_id: this._id,
      order_type: 'delivery', // 默认设置，可根据用户选择调整
      payment: {
        method: 'credit_card', // 默认设置，可根据用户选择调整
        status: 'pending'
      },
      price_details: {
        subtotal: subtotal,
        tax: subtotal * 0.06, // 假设6%的税率
        service_fee: 0,
        delivery_fee: 5, // 默认配送费
        tip: 0,
        discount: 0,
        total: subtotal * 1.06 + 5 // 包含税费和配送费
      },
      privacy_level: this.privacy_level
    });
    
    // 保存订单
    const savedOrder = await newOrder.save();
    
    // 将订单ID添加到推荐的相关订单中
    if (!this.related_orders) {
      this.related_orders = [];
    }
    this.related_orders.push(savedOrder._id);
    
    // 更新推荐的反馈状态
    this.feedback = {
      ...this.feedback,
      follow_through: 'ordered',
      followed_at: Date.now()
    };
    
    await this.save();
    
    return savedOrder;
  } catch (error) {
    console.error('根据推荐创建订单时出错:', error);
    throw error;
  }
};

// 安全查询方法 - 考虑访问控制
aiRecommendationSchema.statics.findWithPermissionCheck = async function(query = {}, options = {}, user) {
  // 如果是用户查询自己的推荐，直接返回
  if (user && query.user_id && user._id.equals(query.user_id)) {
    return this.find(query, options);
  }
  
  // 如果是营养师，检查是否有授权
  if (user && user.role === 'nutritionist') {
    const nutritionistId = user._id;
    
    // 扩展查询条件，添加权限检查
    const permissionQuery = {
      ...query,
      $or: [
        // 用户授权给这个营养师的推荐
        { 'access_grants.granted_to': nutritionistId, 'access_grants.granted_to_type': 'Nutritionist', 'access_grants.revoked': false },
        // 用户在隐私设置中分享给营养师的推荐
        { privacy_level: 'share_with_nutritionist' },
        // 这个营养师审核过的推荐
        { 'nutritionist_review.reviewed_by': nutritionistId }
      ]
    };
    
    return this.find(permissionQuery, options);
  }
  
  // 如果是商家，只能查看与自己相关的推荐
  if (user && user.role === 'merchant') {
    const merchantId = user._id;
    
    const permissionQuery = {
      ...query,
      $or: [
        // 推荐中包含此商家的菜品
        { 'recommended_dishes.merchant_id': merchantId },
        // 用户授权给这个商家的推荐
        { 'access_grants.granted_to': merchantId, 'access_grants.granted_to_type': 'Merchant', 'access_grants.revoked': false },
        // 用户在隐私设置中分享给商家的推荐
        { privacy_level: 'share_with_merchant' }
      ]
    };
    
    return this.find(permissionQuery, options);
  }
  
  // 如果是管理员，直接返回结果
  if (user && (user.role === 'admin' || user.role === 'super_admin')) {
    return this.find(query, options);
  }
  
  // 其他情况，返回空结果
  return [];
};

const AiRecommendation = mongoose.model('AiRecommendation', aiRecommendationSchema);

module.exports = AiRecommendation; 