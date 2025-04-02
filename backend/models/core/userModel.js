const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const shardAccessService = require('../../services/shardAccessService');

// 导入需要的模型做延迟加载
let Order, HealthData, AiRecommendation, Consultation, Nutritionist;

// 定义用户模型的结构
const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    validate: {
      validator: function(v) {
        return /^1[3-9]\d{9}$/.test(v);
      },
      message: props => `${props.value} 不是有效的手机号!`
    },
    sensitivity_level: 2 // 中度敏感数据
  },
  password: {
    type: String,
    required: true
  },
  // 用户角色
  role: {
    type: String,
    enum: ['user', 'admin', 'nutritionist', 'merchant'],
    default: 'user'
  },
  // 当前活跃角色
  active_role: {
    type: String,
    enum: ['user', 'nutritionist', 'merchant'],
    default: 'user'
  },
  // 用户基本信息
  nickname: {
    type: String,
    default: '',
    sensitivity_level: 3 // 低度敏感数据
  },
  real_name: {
    type: String,
    default: '',
    sensitivity_level: 2 // 中度敏感数据
  },
  email: {
    type: String,
    sparse: true,
    unique: true,
    trim: true,
    validate: {
      validator: function(v) {
        return /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(v);
      },
      message: props => `${props.value} 不是有效的邮箱地址!`
    },
    sensitivity_level: 2 // 中度敏感数据
  },
  avatar_url: {
    type: String,
    default: '',
    sensitivity_level: 3 // 低度敏感数据
  },
  height: {
    type: Number,
    default: 0,
    sensitivity_level: 2 // 中度敏感数据
  },
  weight: {
    type: Number, 
    default: 0,
    sensitivity_level: 2 // 中度敏感数据
  },
  age: {
    type: Number,
    default: 0,
    sensitivity_level: 2 // 中度敏感数据
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other',
    sensitivity_level: 2 // 中度敏感数据
  },
  activity_level: {
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
    default: 'moderate',
    sensitivity_level: 3 // 低度敏感数据
  },
  // 地区信息
  region: {
    province: {
      type: String,
      default: '',
      sensitivity_level: 3 // 低度敏感数据
    },
    city: {
      type: String,
      default: '',
      sensitivity_level: 3 // 低度敏感数据
    }
  },
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
      sensitivity_level: 2 // 中度敏感数据
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
    }
  },
  // 健康数据
  health_data: {
    has_recent_medical_report: {
      type: Boolean,
      default: false,
      sensitivity_level: 2 // 中度敏感数据
    },
    medical_report_url: {
      type: String,
      default: '',
      sensitivity_level: 1 // 高度敏感数据
    },
    health_issues: [{
      type: String,
      sensitivity_level: 1 // 高度敏感数据
    }]
  },
  // 营养师认证信息
  nutritionist_verification: {
    is_verified: {
      type: Boolean,
      default: false
    },
    verification_status: {
      type: String,
      enum: ['pending', 'approved', 'rejected', ''],
      default: ''
    },
    rejection_reason: {
      type: String,
      default: ''
    }
  },
  // 商家认证信息
  merchant_verification: {
    is_verified: {
      type: Boolean,
      default: false
    },
    verification_status: {
      type: String,
      enum: ['pending', 'approved', 'rejected', ''],
      default: ''
    },
    rejection_reason: {
      type: String,
      default: ''
    }
  },
  // 微信相关
  wechat_openid: {
    type: String,
    sparse: true,
    unique: true,
    sensitivity_level: 2 // 中度敏感数据
  },
  // 支付宝相关
  alipay_userid: {
    type: String,
    sparse: true,
    unique: true,
    sensitivity_level: 2 // 中度敏感数据
  },
  // 隐私设置
  privacy_settings: {
    share_health_data_with_nutritionist: {
      type: Boolean,
      default: false
    },
    share_order_history_with_merchant: {
      type: Boolean,
      default: false
    },
    share_profile_in_community: {
      type: Boolean,
      default: true
    },
    allow_recommendation_based_on_history: {
      type: Boolean,
      default: true
    },
    data_deletion_requested: {
      type: Boolean,
      default: false
    }
  },
  // 数据可访问性控制
  data_access_controls: [{
    granted_to_role: {
      type: String,
      enum: ['nutritionist', 'merchant', 'admin']
    },
    granted_to_id: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'data_access_controls.granted_to_role'
    },
    resource_type: {
      type: String,
      enum: ['health_data', 'nutrition_profile', 'order_history', 'all']
    },
    allowed_operations: [{
      type: String,
      enum: ['read', 'write', 'delete', 'recommend']
    }],
    valid_until: {
      type: Date
    },
    created_at: {
      type: Date,
      default: Date.now
    }
  }],
  // 账户状态
  account_status: {
    type: String,
    enum: ['active', 'suspended', 'deactivated', 'pending_deletion'],
    default: 'active'
  },
  // 用户同意的服务条款版本
  terms_agreed_version: {
    type: String,
    default: '1.0'
  },
  terms_agreed_at: {
    type: Date,
    default: Date.now
  },
  // 创建和更新时间
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  },
  // 最后登录时间和IP
  last_login: {
    time: Date,
    ip: String,
    device: String
  },
  // 反规范化缓存字段 - 减少关联查询
  cached_data: {
    // 订单统计 - 用于快速展示用户订单概况
    order_stats: {
      total_orders: { type: Number, default: 0 },
      total_spent: { type: Number, default: 0 },
      last_order_date: Date,
      favorite_merchant_id: mongoose.Schema.Types.ObjectId,
      favorite_merchant_name: String,
      last_updated: Date
    },
    // 健康数据概览 - 用于快速获取用户健康状态
    health_overview: {
      current_bmi: Number,
      health_score: Number,
      health_tags: [String],
      last_updated: Date
    },
    // 营养师互动 - 缓存用户与营养师的互动信息
    nutritionist_interaction: {
      has_active_nutritionist: Boolean,
      active_nutritionist_id: mongoose.Schema.Types.ObjectId,
      active_nutritionist_name: String,
      last_consultation_date: Date,
      last_updated: Date
    },
    // 推荐统计 - 用于快速查看用户的推荐使用情况
    recommendation_stats: {
      total_recommendations_received: { type: Number, default: 0 },
      recommendations_followed: { type: Number, default: 0 },
      conversion_rate: { type: Number, default: 0 },
      last_updated: Date
    },
    // 积分和奖励 - 用于快速查看用户的积分和奖励情况
    rewards: {
      points: { type: Number, default: 0 },
      level: { type: String, default: 'bronze' },
      available_coupons: { type: Number, default: 0 },
      last_updated: Date
    }
  }
}, {
  timestamps: true,
  versionKey: false,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引以优化查询性能
userSchema.index({ phone: 1 }, { unique: true });
userSchema.index({ email: 1 }, { sparse: true, unique: true });
userSchema.index({ role: 1 });
userSchema.index({ wechat_openid: 1 }, { sparse: true, unique: true });
userSchema.index({ alipay_userid: 1 }, { sparse: true, unique: true });
userSchema.index({ account_status: 1 });
userSchema.index({ 'region.province': 1, 'region.city': 1 });

// 添加虚拟字段
userSchema.virtual('full_name').get(function() {
  return this.real_name || this.nickname || '';
});

userSchema.virtual('bmi').get(function() {
  if (!this.height || !this.weight || this.height <= 0) return null;
  const heightInMeters = this.height / 100;
  return (this.weight / (heightInMeters * heightInMeters)).toFixed(1);
});

userSchema.virtual('age_group').get(function() {
  if (!this.age) return null;
  if (this.age < 18) return 'child';
  if (this.age < 30) return 'young_adult';
  if (this.age < 50) return 'middle_adult';
  return 'senior';
});

// 添加密码哈希方法
userSchema.pre('save', async function(next) {
  // 如果密码被修改则重新哈希
  if (this.isModified('password')) {
    try {
      const salt = await bcrypt.genSalt(10);
      this.password = await bcrypt.hash(this.password, salt);
    } catch (error) {
      return next(error);
    }
  }
  next();
});

// 添加实例方法
userSchema.methods.comparePassword = async function(candidatePassword) {
  try {
    return await bcrypt.compare(candidatePassword, this.password);
  } catch (error) {
    throw error;
  }
};

userSchema.methods.getBasicProfile = function() {
  return {
    id: this._id,
    nickname: this.nickname,
    avatar_url: this.avatar_url,
    role: this.role,
    active_role: this.active_role
  };
};

// 添加静态方法
userSchema.statics.findByPhone = function(phone) {
  return this.findOne({ phone });
};

userSchema.statics.findByEmail = function(email) {
  return this.findOne({ email });
};

userSchema.statics.findByWechatOpenId = function(wechatOpenId) {
  return this.findOne({ wechat_openid: wechatOpenId });
};

// 创建索引
userSchema.index({ email: 1 }, { unique: true, sparse: true }); // 唯一索引，防止重复注册，但允许为空
userSchema.index({ phone_number: 1 }, { unique: true, sparse: true }); // 唯一索引，允许为空
userSchema.index({ username: 1 }); // 用户名索引，加快查询
userSchema.index({ 'roles.role': 1 }); // 角色索引，加快查询管理员、营养师、商家等
userSchema.index({ created_at: -1 }); // 让最近创建的用户查询更快
userSchema.index({ last_login_at: -1 }); // 登录时间索引，用于分析用户活跃度
userSchema.index({ 'account_status.is_active': 1 }); // 账号状态索引，快速筛选活跃/非活跃用户

// 复合索引，支持按角色和活跃度的组合查询
userSchema.index({ 'roles.role': 1, 'account_status.is_active': 1, created_at: -1 });

// 部分索引，只为活跃用户创建索引，提高查询效率
userSchema.index(
  { last_active_at: -1 },
  { partialFilterExpression: { 'account_status.is_active': true } }
);

// 更新前自动更新 updated_at 字段
userSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 确保密码在返回JSON时被排除
userSchema.set('toJSON', {
  transform: function(doc, ret, options) {
    delete ret.password;
    return ret;
  }
});

// 添加检查权限是否过期的方法
userSchema.methods.hasValidAccessFor = function(roleId, resourceType, operation) {
  const now = new Date();
  
  const accessControl = this.data_access_controls.find(control => {
    return control.granted_to_id.equals(roleId) && 
           (control.resource_type === resourceType || control.resource_type === 'all') && 
           control.allowed_operations.includes(operation) && 
           (control.valid_until === null || control.valid_until > now);
  });
  
  return !!accessControl;
};

// 添加撤销权限的方法
userSchema.methods.revokeAccess = function(roleId, resourceType) {
  this.data_access_controls = this.data_access_controls.filter(control => {
    return !(control.granted_to_id.equals(roleId) && 
            (control.resource_type === resourceType || resourceType === 'all'));
  });
};

// 优化静态方法：高效查询用户
userSchema.statics.findActiveByRole = function(role, options = {}) {
  return this.find({ 
    'roles.role': role, 
    'account_status.is_active': true 
  }, options).lean();
};

// 获取用户基本信息（只返回必要字段，优化查询性能）
userSchema.statics.getBasicInfo = function(userId) {
  return this.findById(userId)
    .select('username email profile.display_name profile.avatar roles')
    .lean();
};

// 更新用户缓存数据方法
userSchema.methods.updateOrderStats = async function() {
  try {
    // 获取所有完成的订单
    if (!Order) Order = require('./orderModel');
    const orderAggregation = await Order.aggregate([
      { $match: { 
        user_id: this._id, 
        status: { $in: ['completed', 'delivered'] } 
      }},
      { $group: {
        _id: null,
        total_orders: { $sum: 1 },
        total_spent: { $sum: '$price_details.total' },
        last_order_date: { $max: '$created_at' }
      }}
    ]);
    
    const orderStats = orderAggregation[0] || {
      total_orders: 0,
      total_spent: 0,
      last_order_date: null
    };
    
    // 获取最常光顾的商家
    const favoriteMerchantAgg = await Order.aggregate([
      { $match: { user_id: this._id } },
      { $group: {
        _id: { 
          merchant_id: '$merchant_id',
          merchant_name: '$merchant_name' // 假设订单中有merchant_name字段
        },
        order_count: { $sum: 1 }
      }},
      { $sort: { order_count: -1 } },
      { $limit: 1 }
    ]);
    
    // 更新订单统计缓存
    this.cached_data = this.cached_data || {};
    this.cached_data.order_stats = {
      total_orders: orderStats.total_orders,
      total_spent: orderStats.total_spent,
      last_order_date: orderStats.last_order_date,
      favorite_merchant_id: favoriteMerchantAgg[0]?._id.merchant_id || null,
      favorite_merchant_name: favoriteMerchantAgg[0]?._id.merchant_name || null,
      last_updated: new Date()
    };
    
    await this.save();
    return this.cached_data.order_stats;
  } catch (error) {
    console.error('更新用户订单统计数据时出错:', error);
    throw error;
  }
};

// 更新健康数据概览
userSchema.methods.updateHealthOverview = async function() {
  try {
    // 获取最新的健康数据
    if (!HealthData) HealthData = require('../health/healthDataModel');
    const latestHealthData = await HealthData.findOne({ 
      user_id: this._id 
    }).sort({ created_at: -1 });
    
    if (!latestHealthData) return null;
    
    // 计算BMI
    let bmi = null;
    if (latestHealthData.basic_metrics?.height && latestHealthData.basic_metrics?.weight) {
      const heightInMeters = latestHealthData.basic_metrics.height / 100;
      bmi = latestHealthData.basic_metrics.weight / (heightInMeters * heightInMeters);
    }
    
    // 创建健康标签
    const healthTags = [];
    
    // 根据BMI分类
    if (bmi !== null) {
      if (bmi < 18.5) healthTags.push('underweight');
      else if (bmi < 24.9) healthTags.push('normal_weight');
      else if (bmi < 29.9) healthTags.push('overweight');
      else healthTags.push('obese');
    }
    
    // 根据血压分类
    if (latestHealthData.basic_metrics?.blood_pressure) {
      const systolic = latestHealthData.basic_metrics.blood_pressure.systolic;
      const diastolic = latestHealthData.basic_metrics.blood_pressure.diastolic;
      
      if (systolic < 120 && diastolic < 80) healthTags.push('normal_bp');
      else if (systolic < 130 && diastolic < 80) healthTags.push('elevated_bp');
      else if (systolic < 140 || diastolic < 90) healthTags.push('hypertension_stage1');
      else healthTags.push('hypertension_stage2');
    }
    
    // 计算健康得分 (简化版 0-100)
    let healthScore = 70; // 默认起始分
    
    // 基于BMI调整
    if (bmi !== null) {
      if (bmi >= 18.5 && bmi <= 24.9) healthScore += 10; // 理想BMI
      else if (bmi < 18.5 || bmi > 30) healthScore -= 10; // 非健康BMI
      else healthScore -= 5; // 轻度超重
    }
    
    // 基于血压调整
    if (latestHealthData.basic_metrics?.blood_pressure) {
      const systolic = latestHealthData.basic_metrics.blood_pressure.systolic;
      const diastolic = latestHealthData.basic_metrics.blood_pressure.diastolic;
      
      if (systolic < 120 && diastolic < 80) healthScore += 10; // 理想血压
      else if (systolic >= 140 || diastolic >= 90) healthScore -= 10; // 高血压
    }
    
    // 确保得分在0-100范围内
    healthScore = Math.max(0, Math.min(100, healthScore));
    
    // 更新健康数据缓存
    this.cached_data = this.cached_data || {};
    this.cached_data.health_overview = {
      current_bmi: bmi,
      health_score: healthScore,
      health_tags: healthTags,
      last_updated: new Date()
    };
    
    await this.save();
    return this.cached_data.health_overview;
  } catch (error) {
    console.error('更新用户健康概览数据时出错:', error);
    throw error;
  }
};

// 更新推荐统计数据
userSchema.methods.updateRecommendationStats = async function() {
  try {
    // 获取推荐统计数据
    if (!AiRecommendation) AiRecommendation = require('./aiRecommendationModel');
    const recommendationAgg = await AiRecommendation.aggregate([
      { $match: { user_id: this._id } },
      { $group: {
        _id: null,
        total_recommendations: { $sum: 1 },
        followed_recommendations: { 
          $sum: { 
            $cond: [{ $eq: ['$feedback.follow_through', 'ordered'] }, 1, 0] 
          }
        }
      }}
    ]);
    
    const stats = recommendationAgg[0] || {
      total_recommendations: 0,
      followed_recommendations: 0
    };
    
    // 计算转化率
    const conversionRate = stats.total_recommendations > 0 
      ? (stats.followed_recommendations / stats.total_recommendations) 
      : 0;
    
    // 更新推荐统计缓存
    this.cached_data = this.cached_data || {};
    this.cached_data.recommendation_stats = {
      total_recommendations_received: stats.total_recommendations,
      recommendations_followed: stats.followed_recommendations,
      conversion_rate: conversionRate,
      last_updated: new Date()
    };
    
    await this.save();
    return this.cached_data.recommendation_stats;
  } catch (error) {
    console.error('更新用户推荐统计数据时出错:', error);
    throw error;
  }
};

// 更新营养师互动数据
userSchema.methods.updateNutritionistInteraction = async function() {
  try {
    // 查找最新的咨询记录
    if (!Consultation) Consultation = require('./consultationModel');
    const latestConsultation = await Consultation.findOne({
      user_id: this._id
    }).sort({ created_at: -1 })
      .populate('nutritionist_id', 'real_name');
    
    // 查询是否有活跃的营养师
    const hasActiveNutritionist = this.data_access_controls.some(control => 
      control.granted_to_type === 'Nutritionist' && 
      !control.revoked && 
      (!control.valid_until || control.valid_until > new Date())
    );
    
    let activeNutritionistId = null;
    let activeNutritionistName = null;
    
    if (hasActiveNutritionist) {
      // 获取有效期最长的营养师授权
      const activeGrant = this.data_access_controls
        .filter(control => 
          control.granted_to_type === 'Nutritionist' && 
          !control.revoked && 
          (!control.valid_until || control.valid_until > new Date())
        )
        .sort((a, b) => 
          (!b.valid_until ? Infinity : b.valid_until.getTime()) - 
          (!a.valid_until ? Infinity : a.valid_until.getTime())
        )[0];
      
      if (activeGrant) {
        activeNutritionistId = activeGrant.granted_to_id;
        
        // 获取营养师名称
        if (!Nutritionist) Nutritionist = require('./nutritionistModel');
        const nutritionist = await Nutritionist.findById(activeNutritionistId);
        if (nutritionist) {
          activeNutritionistName = nutritionist.real_name;
        }
      }
    }
    
    // 更新营养师互动缓存
    this.cached_data = this.cached_data || {};
    this.cached_data.nutritionist_interaction = {
      has_active_nutritionist: hasActiveNutritionist,
      active_nutritionist_id: activeNutritionistId,
      active_nutritionist_name: activeNutritionistName,
      last_consultation_date: latestConsultation?.created_at || null,
      last_updated: new Date()
    };
    
    await this.save();
    return this.cached_data.nutritionist_interaction;
  } catch (error) {
    console.error('更新用户营养师互动数据时出错:', error);
    throw error;
  }
};

// 批量更新所有缓存数据
userSchema.methods.refreshAllCachedData = async function() {
  try {
    await Promise.all([
      this.updateOrderStats(),
      this.updateHealthOverview(),
      this.updateRecommendationStats(),
      this.updateNutritionistInteraction()
    ]);
    
    return this.cached_data;
  } catch (error) {
    console.error('刷新用户缓存数据时出错:', error);
    throw error;
  }
};

// 使用分片访问服务查找用户
userSchema.statics.findByIdFromShards = async function(id) {
  if (!id) return null;
  
  try {
    // 获取用户的分片名称
    const shardName = shardAccessService.getUserShardName(id);
    
    // 查询分片
    let user = await shardAccessService.findById(id, shardName);
    
    // 如果在分片中找到，返回结果
    if (user) return user;
    
    // 降级到原始集合
    return await this.findById(id).lean();
  } catch (err) {
    console.error(`用户分片查询错误: ${err.message}`);
    // 降级到原始集合
    return await this.findById(id).lean();
  }
};

// 添加从分片中按字段查询用户的方法
userSchema.statics.findOneFromShards = async function(query) {
  if (!query) return null;
  
  try {
    const { getDb } = require('../../utils/db');
    const { getShardName } = require('../../utils/shardingConfig');
    const dbManager = require('../../config/database');
    
    // 确定要查询的分片名称
    // 如果有手机号，使用手机号确定分片
    let shardName = 'users'; // 默认集合名
    if (query.phone) {
      shardName = getShardName('user', { phone: query.phone });
    } else if (query._id) {
      // 如果有ID，使用ID确定分片
      shardName = shardAccessService.getUserShardName(query._id);
    }
    
    // 查询分片
    const db = await dbManager.getPrimaryConnection();
    let user = await db.collection(shardName).findOne(query);
    
    // 如果在分片中找到，返回结果
    if (user) return user;
    
    // 降级到原始集合
    return await this.findOne(query).lean();
  } catch (err) {
    console.error(`用户分片查询错误: ${err.message}`);
    // 降级到原始集合
    return await this.findOne(query).lean();
  }
};

// 保存用户到分片
userSchema.methods.saveToShard = async function() {
  try {
    // 获取文档的原始对象
    const userDoc = this.toObject();
    
    // 获取用户的分片名称
    const shardName = shardAccessService.getUserShardName(this._id);
    
    // 保存到分片
    const success = await shardAccessService.saveToShard(userDoc, shardName);
    
    // 无论是否成功保存到分片，都保存到原始集合以保持兼容性
    return await this.save();
  } catch (err) {
    console.error(`保存用户到分片错误: ${err.message}`);
    // 降级到标准保存
    return await this.save();
  }
};

// 查询所有分片中的用户
userSchema.statics.findAcrossShards = async function(query, options = {}) {
  try {
    // 获取所有可能的用户分片名称
    const shardNames = [];
    // 用户分片配置：3个分片
    const USER_SHARDS = 3;
    const USER_SHARD_PREFIX = 'user_shard_';
    
    for (let i = 0; i < USER_SHARDS; i++) {
      shardNames.push(`${USER_SHARD_PREFIX}${i}`);
    }
    
    // 查询多个分片
    return await shardAccessService.findAcrossShards(shardNames, query, options);
  } catch (err) {
    console.error(`跨分片查询用户错误: ${err.message}`);
    // 降级到原始集合
    return await this.find(query)
      .sort(options.sort || {})
      .skip(options.skip || 0)
      .limit(options.limit || 0)
      .lean();
  }
};

// 使用Mongoose直接创建模型
const User = mongoose.model('User', userSchema);

// 查询用户的订单历史
userSchema.methods.getOrderHistory = async function() {
  if (!Order) Order = require('./orderModel');
  return await Order.find({ user_id: this._id }).sort({ created_at: -1 });
};

// 获取用户的健康数据
userSchema.methods.getHealthData = async function() {
  if (!HealthData) HealthData = require('../health/healthDataModel');
  return await HealthData.find({ user_id: this._id }).sort({ recorded_at: -1 });
};

// 获取用户的AI推荐历史
userSchema.methods.getAiRecommendations = async function(limit = 10) {
  if (!AiRecommendation) AiRecommendation = require('./aiRecommendationModel');
  return await AiRecommendation.find({ user_id: this._id })
    .sort({ created_at: -1 })
    .limit(limit);
};

// 获取用户的咨询记录
userSchema.methods.getConsultations = async function() {
  if (!Consultation) Consultation = require('./consultationModel');
  return await Consultation.find({ user_id: this._id }).sort({ scheduled_at: -1 });
};

// 获取用户咨询过的营养师
userSchema.methods.getConsultedNutritionists = async function() {
  if (!Consultation) Consultation = require('./consultationModel');
  if (!Nutritionist) Nutritionist = require('./nutritionistModel');
  const consultations = await Consultation.find({ user_id: this._id });
  const nutritionistIds = [...new Set(consultations.map(c => c.nutritionist_id))];
  return await Nutritionist.find({ _id: { $in: nutritionistIds } });
};

module.exports = User;