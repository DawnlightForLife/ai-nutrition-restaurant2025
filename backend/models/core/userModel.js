const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const shardAccessService = require('../../services/core/shardAccessService');

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
  currentRole: {
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
  realName: {
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
  avatarUrl: {
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
  activityLevel: {
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
  dietaryPreferences: {
    cuisinePreference: {
      type: String,
      enum: ['north', 'south', 'east', 'west', 'sichuan', 'cantonese', 'hunan', 'other'],
      default: 'other',
      sensitivity_level: 3 // 低度敏感数据
    },
    allergies: [{
      type: String,
      sensitivity_level: 2 // 中度敏感数据
    }],
    avoidedIngredients: [{
      type: String,
      sensitivity_level: 3 // 低度敏感数据
    }],
    spicyPreference: {
      type: String,
      enum: ['none', 'mild', 'medium', 'hot', 'extra_hot'],
      default: 'medium',
      sensitivity_level: 3 // 低度敏感数据
    }
  },
  // 健康数据
  healthData: {
    hasRecentMedicalReport: {
      type: Boolean,
      default: false,
      sensitivity_level: 2 // 中度敏感数据
    },
    medicalReportUrl: {
      type: String,
      default: '',
      sensitivity_level: 1 // 高度敏感数据
    },
    healthIssues: [{
      type: String,
      sensitivity_level: 1 // 高度敏感数据
    }]
  },
  // 营养师认证信息
  nutritionistVerification: {
    isVerified: {
      type: Boolean,
      default: false
    },
    verificationStatus: {
      type: String,
      enum: ['pending', 'approved', 'rejected', ''],
      default: ''
    },
    rejectionReason: {
      type: String,
      default: ''
    }
  },
  // 商家认证信息
  merchantVerification: {
    isVerified: {
      type: Boolean,
      default: false
    },
    verificationStatus: {
      type: String,
      enum: ['pending', 'approved', 'rejected', ''],
      default: ''
    },
    rejectionReason: {
      type: String,
      default: ''
    }
  },
  // 微信相关
  wechatOpenid: {
    type: String,
    sparse: true,
    unique: true,
    sensitivity_level: 2 // 中度敏感数据
  },
  // 支付宝相关
  alipayUserid: {
    type: String,
    sparse: true,
    unique: true,
    sensitivity_level: 2 // 中度敏感数据
  },
  // 隐私设置
  privacySettings: {
    shareHealthDataWithNutritionist: {
      type: Boolean,
      default: false
    },
    shareOrderHistoryWithMerchant: {
      type: Boolean,
      default: false
    },
    shareProfileInCommunity: {
      type: Boolean,
      default: true
    },
    allowRecommendationBasedOnHistory: {
      type: Boolean,
      default: true
    },
    dataDeletionRequested: {
      type: Boolean,
      default: false
    }
  },
  // 数据可访问性控制
  dataAccessControls: [{
    grantedToRole: {
      type: String,
      enum: ['nutritionist', 'merchant', 'admin']
    },
    grantedToId: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'dataAccessControls.grantedToRole'
    },
    resourceType: {
      type: String,
      enum: ['healthData', 'nutritionProfile', 'orderHistory', 'all']
    },
    allowedOperations: [{
      type: String,
      enum: ['read', 'write', 'delete', 'recommend']
    }],
    validUntil: {
      type: Date
    },
    createdAt: {
      type: Date,
      default: Date.now
    }
  }],
  // 账户状态
  accountStatus: {
    type: String,
    enum: ['active', 'suspended', 'deactivated', 'pendingDeletion'],
    default: 'active'
  },
  // 用户同意的服务条款版本
  termsVersion: {
    type: String,
    default: '1.0'
  },
  termsAgreedAt: {
    type: Date,
    default: Date.now
  },
  // 创建和更新时间
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  },
  // 最后登录时间和IP
  lastLogin: {
    time: Date,
    ip: String,
    device: String
  },
  // 反规范化缓存字段 - 减少关联查询
  cachedData: {
    // 订单统计 - 用于快速展示用户订单概况
    orderStats: {
      totalOrders: { type: Number, default: 0 },
      totalSpent: { type: Number, default: 0 },
      lastOrderDate: Date,
      favoriteMerchantId: mongoose.Schema.Types.ObjectId,
      favoriteMerchantName: String,
      lastUpdated: Date
    },
    // 健康数据概览 - 用于快速获取用户健康状态
    healthOverview: {
      currentBmi: Number,
      healthScore: Number,
      healthTags: [String],
      lastUpdated: Date
    },
    // 营养师互动 - 缓存用户与营养师的互动信息
    nutritionistInteraction: {
      hasActiveNutritionist: Boolean,
      activeNutritionistId: mongoose.Schema.Types.ObjectId,
      activeNutritionistName: String,
      lastConsultationDate: Date,
      lastUpdated: Date
    },
    // 推荐统计 - 用于快速查看用户的推荐使用情况
    recommendationStats: {
      totalRecommendationsReceived: { type: Number, default: 0 },
      recommendationsFollowed: { type: Number, default: 0 },
      conversionRate: { type: Number, default: 0 },
      lastUpdated: Date
    },
    // 积分和奖励 - 用于快速查看用户的积分和奖励情况
    rewards: {
      points: { type: Number, default: 0 },
      level: { type: String, default: 'bronze' },
      availableCoupons: { type: Number, default: 0 },
      lastUpdated: Date
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
userSchema.index({ wechatOpenid: 1 }, { sparse: true, unique: true });
userSchema.index({ alipayUserid: 1 }, { sparse: true, unique: true });
userSchema.index({ accountStatus: 1 });
userSchema.index({ 'region.province': 1, 'region.city': 1 });

// 添加虚拟字段
userSchema.virtual('fullName').get(function() {
  return this.realName || this.nickname || '';
});

userSchema.virtual('bmi').get(function() {
  if (!this.height || !this.weight || this.height <= 0) return null;
  const heightInMeters = this.height / 100;
  return (this.weight / (heightInMeters * heightInMeters)).toFixed(1);
});

userSchema.virtual('ageGroup').get(function() {
  if (!this.age) return null;
  if (this.age < 18) return 'child';
  if (this.age < 30) return 'youngAdult';
  if (this.age < 50) return 'middleAdult';
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
    avatarUrl: this.avatarUrl,
    role: this.role,
    currentRole: this.currentRole
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
  return this.findOne({ wechatOpenid: wechatOpenId });
};

// 创建索引
userSchema.index({ email: 1 }, { unique: true, sparse: true }); // 唯一索引，防止重复注册，但允许为空
userSchema.index({ phoneNumber: 1 }, { unique: true, sparse: true }); // 唯一索引，允许为空
userSchema.index({ username: 1 }); // 用户名索引，加快查询
userSchema.index({ 'roles.role': 1 }); // 角色索引，加快查询管理员、营养师、商家等
userSchema.index({ createdAt: -1 }); // 让最近创建的用户查询更快
userSchema.index({ lastLoginAt: -1 }); // 登录时间索引，用于分析用户活跃度
userSchema.index({ 'accountStatus.isActive': 1 }); // 账号状态索引，快速筛选活跃/非活跃用户

// 复合索引，支持按角色和活跃度的组合查询
userSchema.index({ 'roles.role': 1, 'accountStatus.isActive': 1, createdAt: -1 });

// 部分索引，只为活跃用户创建索引，提高查询效率
userSchema.index(
  { lastActiveAt: -1 },
  { partialFilterExpression: { 'accountStatus.isActive': true } }
);

// 更新前自动更新 updatedAt 字段
userSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
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
  
  const accessControl = this.dataAccessControls.find(control => {
    return control.grantedToId.equals(roleId) && 
           (control.resourceType === resourceType || control.resourceType === 'all') && 
           control.allowedOperations.includes(operation) && 
           (control.validUntil === null || control.validUntil > now);
  });
  
  return !!accessControl;
};

// 添加撤销权限的方法
userSchema.methods.revokeAccess = function(roleId, resourceType) {
  this.dataAccessControls = this.dataAccessControls.filter(control => {
    return !(control.grantedToId.equals(roleId) && 
            (control.resourceType === resourceType || resourceType === 'all'));
  });
};

// 优化静态方法：高效查询用户
userSchema.statics.findActiveByRole = function(role, options = {}) {
  return this.find({ 
    'roles.role': role, 
    'accountStatus.isActive': true 
  }, options).lean();
};

// 获取用户基本信息（只返回必要字段，优化查询性能）
userSchema.statics.getBasicInfo = function(userId) {
  return this.findById(userId)
    .select('username email profile.displayName profile.avatar roles')
    .lean();
};

// 更新用户缓存数据方法
userSchema.methods.updateOrderStats = async function() {
  try {
    // 获取所有完成的订单
    if (!Order) Order = require('./orderModel');
    const orderAggregation = await Order.aggregate([
      { $match: { 
        userId: this._id, 
        status: { $in: ['completed', 'delivered'] } 
      }},
      { $group: {
        _id: null,
        totalOrders: { $sum: 1 },
        totalSpent: { $sum: '$priceDetails.total' },
        lastOrderDate: { $max: '$createdAt' }
      }}
    ]);
    
    const orderStats = orderAggregation[0] || {
      totalOrders: 0,
      totalSpent: 0,
      lastOrderDate: null
    };
    
    // 获取最常光顾的商家
    const favoriteMerchantAgg = await Order.aggregate([
      { $match: { userId: this._id } },
      { $group: {
        _id: { 
          merchantId: '$merchantId',
          merchantName: '$merchantName' // 假设订单中有merchantName字段
        },
        orderCount: { $sum: 1 }
      }},
      { $sort: { orderCount: -1 } },
      { $limit: 1 }
    ]);
    
    // 更新订单统计缓存
    this.cachedData = this.cachedData || {};
    this.cachedData.orderStats = {
      totalOrders: orderStats.totalOrders,
      totalSpent: orderStats.totalSpent,
      lastOrderDate: orderStats.lastOrderDate,
      favoriteMerchantId: favoriteMerchantAgg[0]?._id.merchantId || null,
      favoriteMerchantName: favoriteMerchantAgg[0]?._id.merchantName || null,
      lastUpdated: new Date()
    };
    
    await this.save();
    return this.cachedData.orderStats;
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
      userId: this._id 
    }).sort({ createdAt: -1 });
    
    if (!latestHealthData) return null;
    
    // 计算BMI
    let bmi = null;
    if (latestHealthData.basicMetrics?.height && latestHealthData.basicMetrics?.weight) {
      const heightInMeters = latestHealthData.basicMetrics.height / 100;
      bmi = latestHealthData.basicMetrics.weight / (heightInMeters * heightInMeters);
    }
    
    // 创建健康标签
    const healthTags = [];
    
    // 根据BMI分类
    if (bmi !== null) {
      if (bmi < 18.5) healthTags.push('underweight');
      else if (bmi < 24.9) healthTags.push('normalWeight');
      else if (bmi < 29.9) healthTags.push('overweight');
      else healthTags.push('obese');
    }
    
    // 根据血压分类
    if (latestHealthData.basicMetrics?.bloodPressure) {
      const systolic = latestHealthData.basicMetrics.bloodPressure.systolic;
      const diastolic = latestHealthData.basicMetrics.bloodPressure.diastolic;
      
      if (systolic < 120 && diastolic < 80) healthTags.push('normalBp');
      else if (systolic < 130 && diastolic < 80) healthTags.push('elevatedBp');
      else if (systolic < 140 || diastolic < 90) healthTags.push('hypertensionStage1');
      else healthTags.push('hypertensionStage2');
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
    if (latestHealthData.basicMetrics?.bloodPressure) {
      const systolic = latestHealthData.basicMetrics.bloodPressure.systolic;
      const diastolic = latestHealthData.basicMetrics.bloodPressure.diastolic;
      
      if (systolic < 120 && diastolic < 80) healthScore += 10; // 理想血压
      else if (systolic >= 140 || diastolic >= 90) healthScore -= 10; // 高血压
    }
    
    // 确保得分在0-100范围内
    healthScore = Math.max(0, Math.min(100, healthScore));
    
    // 更新健康数据缓存
    this.cachedData = this.cachedData || {};
    this.cachedData.healthOverview = {
      currentBmi: bmi,
      healthScore: healthScore,
      healthTags: healthTags,
      lastUpdated: new Date()
    };
    
    await this.save();
    return this.cachedData.healthOverview;
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
      { $match: { userId: this._id } },
      { $group: {
        _id: null,
        totalRecommendations: { $sum: 1 },
        followedRecommendations: { 
          $sum: { 
            $cond: [{ $eq: ['$feedback.followThrough', 'ordered'] }, 1, 0] 
          }
        }
      }}
    ]);
    
    const stats = recommendationAgg[0] || {
      totalRecommendations: 0,
      followedRecommendations: 0
    };
    
    // 计算转化率
    const conversionRate = stats.totalRecommendations > 0 
      ? (stats.followedRecommendations / stats.totalRecommendations) 
      : 0;
    
    // 更新推荐统计缓存
    this.cachedData = this.cachedData || {};
    this.cachedData.recommendationStats = {
      totalRecommendationsReceived: stats.totalRecommendations,
      recommendationsFollowed: stats.followedRecommendations,
      conversionRate: conversionRate,
      lastUpdated: new Date()
    };
    
    await this.save();
    return this.cachedData.recommendationStats;
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
      userId: this._id
    }).sort({ createdAt: -1 })
      .populate('nutritionistId', 'realName');
    
    // 查询是否有活跃的营养师
    const hasActiveNutritionist = this.dataAccessControls.some(control => 
      control.grantedToType === 'Nutritionist' && 
      !control.revoked && 
      (!control.validUntil || control.validUntil > new Date())
    );
    
    let activeNutritionistId = null;
    let activeNutritionistName = null;
    
    if (hasActiveNutritionist) {
      // 获取有效期最长的营养师授权
      const activeGrant = this.dataAccessControls
        .filter(control => 
          control.grantedToType === 'Nutritionist' && 
          !control.revoked && 
          (!control.validUntil || control.validUntil > new Date())
        )
        .sort((a, b) => 
          (!b.validUntil ? Infinity : b.validUntil.getTime()) - 
          (!a.validUntil ? Infinity : a.validUntil.getTime())
        )[0];
      
      if (activeGrant) {
        activeNutritionistId = activeGrant.grantedToId;
        
        // 获取营养师名称
        if (!Nutritionist) Nutritionist = require('../nutrition/nutritionistModel');
        const nutritionist = await Nutritionist.findById(activeNutritionistId);
        if (nutritionist) {
          // 改用用户真实姓名或者从professional_info中获取的信息
          activeNutritionistName = nutritionist.getPublicProfile().bio ? 
            `营养师 (${nutritionist.getPublicProfile().bio.substring(0, 10)}...)` :
            `营养师 #${activeNutritionistId.toString().substring(0, 6)}`;
        }
      }
    }
    
    // 更新营养师互动缓存
    this.cachedData = this.cachedData || {};
    this.cachedData.nutritionistInteraction = {
      hasActiveNutritionist: hasActiveNutritionist,
      activeNutritionistId: activeNutritionistId,
      activeNutritionistName: activeNutritionistName,
      lastConsultationDate: latestConsultation?.createdAt || null,
      lastUpdated: new Date()
    };
    
    await this.save();
    return this.cachedData.nutritionistInteraction;
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
    
    return this.cachedData;
  } catch (error) {
    console.error('刷新用户缓存数据时出错:', error);
    throw error;
  }
};

// 使用分片访问服务查找用户
/**
 * 使用用户ID从对应分片中查找用户
 * 根据用户ID计算分片位置，优先在分片中查询，查询失败则降级到默认集合
 * 
 * @param {string|ObjectId} id - 用户ID
 * @returns {Promise<Object|null>} 用户文档或null
 */
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
/**
 * 从分片中查找单个用户
 * 根据查询条件，决定从哪个分片集合查询用户数据
 * 支持基于手机号和用户ID的分片路由
 * 当分片查询失败时，自动降级到默认集合
 * 
 * @param {Object} query - 查询条件对象，支持phone和_id
 * @returns {Promise<Object|null>} 查询到的用户数据或null
 */
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
      // 基于手机号计算分片
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
/**
 * 保存用户到分片
 * 将当前用户文档保存到对应的分片集合中
 * 无论分片操作是否成功，都会同时保存到默认集合以保持兼容性
 * 
 * @returns {Promise<Document>} 保存后的用户文档
 */
userSchema.methods.saveToShard = async function() {
  try {
    // 获取文档的原始对象
    const userDoc = this.toObject();
    
    // 获取用户的分片名称
    const shardName = shardAccessService.getUserShardName(this._id);
    
    // 保存到分片
    const success = await shardAccessService.saveToShard(userDoc, shardName);
    
    // 记录分片操作结果
    console.log(`[分片] 用户 ${this._id} 保存到分片 ${shardName} ${success ? '成功' : '失败'}`);
    
    // 无论是否成功保存到分片，都保存到原始集合以保持兼容性
    return await this.save();
  } catch (err) {
    console.error(`保存用户到分片错误: ${err.message}`);
    // 降级到标准保存
    return await this.save();
  }
};

// 查询所有分片中的用户
/**
 * 跨分片查询用户
 * 在所有用户分片中执行相同的查询，并合并结果
 * 支持排序、分页等选项
 * 当跨分片查询失败时，降级到默认集合查询
 * 
 * @param {Object} query - 查询条件
 * @param {Object} options - 查询选项，包括sort、skip、limit等
 * @returns {Promise<Array>} 查询结果数组
 */
userSchema.statics.findAcrossShards = async function(query, options = {}) {
  try {
    // 获取所有可能的用户分片名称
    const shardNames = [];
    // 用户分片配置：3个分片
    const USER_SHARDS = 3;
    const USER_SHARD_PREFIX = 'user_shard_';
    
    // 构建所有分片名称列表
    for (let i = 0; i < USER_SHARDS; i++) {
      shardNames.push(`${USER_SHARD_PREFIX}${i}`);
    }
    
    // 查询多个分片并合并结果
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
  return await Order.find({ userId: this._id }).sort({ createdAt: -1 });
};

// 获取用户的健康数据
userSchema.methods.getHealthData = async function() {
  if (!HealthData) HealthData = require('../health/healthDataModel');
  return await HealthData.find({ userId: this._id }).sort({ recordedAt: -1 });
};

// 获取用户的AI推荐历史
userSchema.methods.getAiRecommendations = async function(limit = 10) {
  if (!AiRecommendation) AiRecommendation = require('./aiRecommendationModel');
  return await AiRecommendation.find({ userId: this._id })
    .sort({ createdAt: -1 })
    .limit(limit);
};

// 获取用户的咨询记录
userSchema.methods.getConsultations = async function() {
  if (!Consultation) Consultation = require('./consultationModel');
  return await Consultation.find({ userId: this._id }).sort({ scheduledAt: -1 });
};

// 获取用户咨询过的营养师
userSchema.methods.getConsultedNutritionists = async function() {
  if (!Consultation) Consultation = require('./consultationModel');
  if (!Nutritionist) Nutritionist = require('./nutritionistModel');
  const consultations = await Consultation.find({ userId: this._id });
  const nutritionistIds = [...new Set(consultations.map(c => c.nutritionistId))];
  return await Nutritionist.find({ _id: { $in: nutritionistIds } });
};

/**
 * 检查用户是否拥有指定的权限
 * @param {string} permission - 权限名称
 * @returns {boolean} 是否拥有权限
 */
userSchema.methods.hasPermission = function(permission) {
  if (!this.role) return false;
  if (this.role === 'admin') return true;
  
  // 检查用户角色是否有此权限
  return this.permissions && this.permissions.includes(permission);
};

/**
 * 将用户数据转换为安全的公开格式
 * 移除敏感字段，返回适合前端显示的用户数据
 * 
 * @returns {Object} 公开的用户资料
 */
userSchema.methods.toPublicProfile = function() {
  const profile = {
    id: this._id,
    username: this.username,
    email: this.email,
    firstName: this.firstName,
    lastName: this.lastName,
    avatar: this.avatar,
    phoneVerified: !!this.phoneVerified,
    emailVerified: !!this.emailVerified,
    role: this.role,
    createdAt: this.createdAt,
    bio: this.bio || '',
    location: this.location || '',
    preferences: this.preferences || {}
  };
  
  // 如果有缓存数据，加入缓存数据
  if (this.cachedData) {
    profile.stats = {
      ordersCount: this.cachedData.ordersCount || 0,
      recommCount: this.cachedData.recommCount || 0,
      favoritesCount: this.cachedData.favoritesCount || 0,
      lastActiveAt: this.cachedData.lastActiveAt
    };
    
    // 健康数据概览（如已授权）
    if (this.settings?.shareHealthData) {
      profile.healthOverview = this.cachedData.healthOverview || {};
    }
  }
  
  return profile;
};

/**
 * 生成用户通知配置
 * 合并默认配置和用户自定义配置
 * 
 * @returns {Object} 通知配置
 */
userSchema.methods.getNotificationConfig = function() {
  // 默认通知配置
  const defaultConfig = {
    email: {
      marketing: false,
      orderUpdates: true,
      accountSecurity: true,
      recommendations: true
    },
    push: {
      orderUpdates: true,
      chats: true,
      recommendations: true,
      healthAlerts: true
    }
  };
  
  // 合并默认配置和用户自定义配置
  const userConfig = { ...defaultConfig, ...this.notificationSettings };
  
  return userConfig;
};

module.exports = User;