const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const shardAccessService = require('../../services/database/shardAccessService.js');

// 导入需要的模型做延迟加载
let Order, NutritionProfile, AiRecommendation, Consultation, Nutritionist;

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
    sensitivityLevel: 2,
    description: '用户手机号'
  },
  password: {
    type: String,
    required: function () {
      return this.authType === 'password';
    },
    description: '用户密码（加密存储）'
  },
  authType: {
    type: String,
    enum: ['password', 'code', 'oauth'],
    default: 'password',
    description: '登录方式类型（password 密码登录，code 验证码登录，oauth 第三方登录）'
  },
  // 验证码相关
  verification: {
    code: {
      type: String,
      default: null,
      description: '验证码'
    },
    expiresAt: {
      type: Date,
      default: null,
      description: '验证码过期时间'
    }
  },
  // 用户角色
  role: {
    type: String,
    enum: ['customer', 'store_manager', 'store_staff', 'nutritionist', 'admin', 'super_admin', 'area_manager', 'system'],
    default: 'customer',
    description: '用户角色'
  },
  // 关联加盟店（仅限店员工）
  franchiseStoreId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'FranchiseStore',
    description: '所属加盟店ID（仅店长、店员、营养师需要）'
  },
  // 管理的加盟店（区域经理）
  managedStores: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'FranchiseStore',
    description: '管理的加盟店列表（区域经理）'
  }],
  // 用户基本信息
  nickname: {
    type: String,
    default: '',
    sensitivityLevel: 3,
    description: '用户昵称'
  },
  realName: {
    type: String,
    default: '',
    sensitivityLevel: 2,
    description: '真实姓名'
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
    sensitivityLevel: 2,
    description: '用户邮箱'
  },
  avatarUrl: {
    type: String,
    default: '',
    sensitivityLevel: 3,
    description: '头像URL'
  },
  height: {
    type: Number,
    default: 0,
    sensitivityLevel: 2,
    description: '身高（cm）'
  },
  weight: {
    type: Number, 
    default: 0,
    sensitivityLevel: 2,
    description: '体重（kg）'
  },
  age: {
    type: Number,
    default: 0,
    sensitivityLevel: 2,
    description: '年龄'
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other',
    sensitivityLevel: 2,
    description: '性别'
  },
  activityLevel: {
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
    default: 'moderate',
    sensitivityLevel: 3,
    description: '活动水平'
  },
  // 地区信息
  region: {
    province: {
      type: String,
      default: '',
      sensitivityLevel: 3,
      description: '省份'
    },
    city: {
      type: String,
      default: '',
      sensitivityLevel: 3,
      description: '城市'
    }
  },
  // 饮食偏好
  dietaryPreferences: {
    cuisinePreference: {
      type: String,
      enum: ['north', 'south', 'east', 'west', 'sichuan', 'cantonese', 'hunan', 'other'],
      default: 'other',
      sensitivityLevel: 3,
      description: '偏好菜系'
    },
    allergies: [{
      type: String,
      sensitivityLevel: 2,
      description: '过敏原'
    }],
    avoidedIngredients: [{
      type: String,
      sensitivityLevel: 3,
      description: '避免食材'
    }],
    spicyPreference: {
      type: String,
      enum: ['none', 'mild', 'medium', 'hot', 'extra_hot'],
      default: 'medium',
      sensitivityLevel: 3,
      description: '辣度偏好'
    }
  },
  // 营养师认证信息
  nutritionistCertification: {
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected', ''],
      default: '',
      description: '认证状态'
    },
    rejectionReason: {
      type: String,
      default: '',
      description: '拒绝原因'
    }
  },
  // 商家认证信息
  merchantCertification: {
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected', ''],
      default: '',
      description: '认证状态'
    },
    rejectionReason: {
      type: String,
      default: '',
      description: '拒绝原因'
    }
  },
  // 微信相关
  wechatOpenId: {
    type: String,
    sparse: true,
    unique: true,
    sensitivityLevel: 2,
    description: '微信 openid'
  },
  // 支付宝相关
  alipayUserId: {
    type: String,
    sparse: true,
    unique: true,
    sensitivityLevel: 2,
    description: '支付宝 userId'
  },
  // 隐私设置
  privacySettings: {
    shareNutritionDataWithNutritionist: {
      type: Boolean,
      default: false,
      description: '是否与营养师共享营养数据'
    },
    shareOrderHistoryWithMerchant: {
      type: Boolean,
      default: false,
      description: '是否与商家共享订单历史'
    },
    shareProfileInCommunity: {
      type: Boolean,
      default: true,
      description: '是否在社区展示个人资料'
    },
    allowRecommendationBasedOnHistory: {
      type: Boolean,
      default: true,
      description: '是否允许基于历史数据推荐'
    },
    dataDeletionRequested: {
      type: Boolean,
      default: false,
      description: '是否申请数据删除'
    }
  },
  // 数据可访问性控制
  dataAccessControls: [{
    grantedToRole: {
      type: String,
      enum: ['nutritionist', 'merchant', 'admin'],
      description: '被授权角色'
    },
    grantedToId: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'dataAccessControls.grantedToRole',
      description: '被授权对象ID'
    },
    resourceType: {
      type: String,
      enum: ['nutritionData', 'nutritionProfile', 'orderHistory', 'all'],
      description: '资源类型'
    },
    allowedOperations: [{
      type: String,
      enum: ['read', 'write', 'delete', 'recommend'],
      description: '允许操作'
    }],
    validUntil: {
      type: Date,
      description: '授权有效期'
    },
    createdAt: {
      type: Date,
      default: Date.now,
      description: '授权创建时间'
    }
  }],
  // 账户状态
  accountStatus: {
    type: String,
    enum: ['active', 'suspended', 'deactivated', 'pendingDeletion'],
    default: 'active',
    description: '账户状态'
  },
  // 用户资料是否完成
  profileCompleted: {
    type: Boolean,
    default: false,
    description: '用户资料是否填写完成'
  },
  // 是否是自动注册的用户
  autoRegistered: {
    type: Boolean,
    default: false,
    description: '是否通过自动注册创建'
  },
  // 用户同意的服务条款版本
  termsVersion: {
    type: String,
    default: '1.0',
    description: '同意的服务条款版本'
  },
  termsAgreedAt: {
    type: Date,
    default: Date.now,
    description: '同意服务条款时间'
  },
  // 最后登录时间和IP
  lastLogin: {
    time: { type: Date, description: '最后登录时间' },
    ip: { type: String, description: '最后登录IP' },
    device: { type: String, description: '设备信息' }
  },
  // 反规范化缓存字段 - 减少关联查询
  cachedData: {
    // 订单统计 - 用于快速展示用户订单概况
    orderStats: {
      totalOrders: { type: Number, default: 0, description: '总订单数' },
      totalSpent: { type: Number, default: 0, description: '总消费金额' },
      lastOrderDate: { type: Date, description: '最近订单时间' },
      favoriteMerchantId: { type: mongoose.Schema.Types.ObjectId, description: '最常消费商家ID' },
      favoriteMerchantName: { type: String, description: '最常消费商家名称' },
      lastUpdated: { type: Date, description: '订单统计最近更新时间' }
    },
    // 营养数据概览 - 用于快速获取用户营养状态
    nutritionOverview: {
      currentBmi: { type: Number, description: '当前BMI' },
      nutritionScore: { type: Number, description: '营养评分' },
      nutritionTags: { type: [String], description: '营养标签' },
      lastUpdated: { type: Date, description: '营养数据最近更新时间' }
    },
    // 营养师互动 - 缓存用户与营养师的互动信息
    nutritionistInteraction: {
      hasActiveNutritionist: { type: Boolean, description: '是否有活跃营养师' },
      activeNutritionistId: { type: mongoose.Schema.Types.ObjectId, description: '活跃营养师ID' },
      activeNutritionistName: { type: String, description: '活跃营养师名称' },
      lastConsultationDate: { type: Date, description: '最近咨询时间' },
      lastUpdated: { type: Date, description: '互动信息最近更新时间' }
    },
    // 推荐统计 - 用于快速查看用户的推荐使用情况
    recommendationStats: {
      totalRecommendationsReceived: { type: Number, default: 0, description: '收到的推荐总数' },
      recommendationsFollowed: { type: Number, default: 0, description: '跟随推荐的次数' },
      conversionRate: { type: Number, default: 0, description: '转化率' },
      lastUpdated: { type: Date, description: '推荐统计最近更新时间' }
    },
    // 积分和奖励 - 用于快速查看用户的积分和奖励情况
    rewards: {
      points: { type: Number, default: 0, description: '积分' },
      level: { type: String, default: 'bronze', description: '等级' },
      availableCoupons: { type: Number, default: 0, description: '可用优惠券数' },
      lastUpdated: { type: Date, description: '奖励最近更新时间' }
    }
  }
}, {
  timestamps: true,
  versionKey: false,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引以优化查询性能 (修复重复索引问题)
// 唯一索引，确保关键字段唯一性
userSchema.index({ phone: 1 }, { unique: true });
userSchema.index({ email: 1 }, { sparse: true, unique: true }); // sparse允许为空
userSchema.index({ wechatOpenId: 1 }, { sparse: true, unique: true });
userSchema.index({ alipayUserId: 1 }, { sparse: true, unique: true });

// 常用查询索引
userSchema.index({ role: 1 });
userSchema.index({ accountStatus: 1 });
userSchema.index({ 'region.province': 1, 'region.city': 1 });
userSchema.index({ createdAt: -1 }); // 按创建时间排序

// 复合索引，支持按角色和账户状态的组合查询
userSchema.index({ role: 1, accountStatus: 1, createdAt: -1 });

// 部分索引，只为活跃用户创建索引，提高查询效率
userSchema.index(
  { lastLogin: -1 },
  { partialFilterExpression: { accountStatus: 'active' } }
);

// 添加虚拟字段
userSchema.virtual('fullName').get(function() {
  return this.realName || this.nickname || '';
});

userSchema.virtual('bmi').get(function() {
  if (!this.height || !this.weight || this.height <= 0) return null;
  const heightInMeters = this.height / 100;
  return parseFloat((this.weight / (heightInMeters * heightInMeters)).toFixed(1));
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
  // 如果用户使用验证码或第三方登录，不需要密码
  if (this.authType === 'code' || this.authType === 'oauth') {
    // 确保password字段为undefined，而不是空字符串或null
    this.password = undefined;
    return next();
  }
  
  // 如果密码被修改则重新哈希
  if (this.isModified('password') && this.password) {
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
    currentRole: this.currentRole,
    profileCompleted: this.profileCompleted,
    autoRegistered: this.autoRegistered
  };
};

// 检查用户资料是否完成
userSchema.methods.checkProfileCompletion = function() {
  // 必填项：真实姓名、年龄、性别、身高、体重
  const isComplete = !!(
    this.realName &&
    this.age > 0 &&
    this.gender &&
    this.gender !== 'other' &&
    this.height > 0 &&
    this.weight > 0
  );
  
  // 更新资料完成状态
  if (this.profileCompleted !== isComplete) {
    this.profileCompleted = isComplete;
  }
  
  return isComplete;
};

// 添加静态方法
userSchema.statics.findByPhone = function(phone) {
  return this.findOne({ phone });
};

userSchema.statics.findByEmail = function(email) {
  return this.findOne({ email });
};

userSchema.statics.findByWechatOpenId = function(wechatOpenId) {
  return this.findOne({ wechatOpenId: wechatOpenId });
};

// 创建索引
userSchema.index({ email: 1 }, { unique: true, sparse: true }); // 唯一索引，防止重复注册，但允许为空
userSchema.index({ phoneNumber: 1 }, { unique: true, sparse: true }); // 唯一索引，允许为空
userSchema.index({ username: 1 }); // 用户名索引，加快查询
userSchema.index({ 'roles.role': 1 }); // 角色索引，加快查询管理员、营养师、商家等
// userSchema.index({ createdAt: -1 }); // 让最近创建的用户查询更快（已由timestamps自动管理）
// userSchema.index({ lastLoginAt: -1 }); // 登录时间索引，用于分析用户活跃度（已由timestamps自动管理）
userSchema.index({ 'accountStatus.isActive': 1 }); // 账号状态索引，快速筛选活跃/非活跃用户

// 复合索引，支持按角色和活跃度的组合查询
userSchema.index({ 'roles.role': 1, 'accountStatus.isActive': 1, createdAt: -1 });

// 部分索引，只为活跃用户创建索引，提高查询效率
userSchema.index(
  { lastActiveAt: -1 },
  { partialFilterExpression: { 'accountStatus.isActive': true } }
);

// 更新前自动更新 updatedAt 字段
// 已由timestamps自动管理，无需手动设置updatedAt

// 确保密码在返回JSON时被排除
userSchema.set('toJSON', {
  transform: function(doc, ret) {
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

// -- 缓存更新方法移动到文件靠后处 --

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
    const { getShardName } = require('../../utils/shardingConfig');
    const dbManager = require('../../config/modules/db.config');
    
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

// 查询用户的订单历史
userSchema.methods.getOrderHistory = async function() {
  if (!Order) Order = require('./orderModel');
  return await Order.find({ userId: this._id }).sort({ createdAt: -1 });
};

// 获取用户的营养档案
userSchema.methods.getNutritionProfile = async function() {
  if (!NutritionProfile) NutritionProfile = require('../nutrition/nutritionProfileModel.js');
  return await NutritionProfile.findOne({ userId: this._id });
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
    avatarUrl: this.avatarUrl,
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
    
    // 营养数据概览（如已授权）
    if (this.settings?.shareNutritionData) {
      profile.nutritionOverview = this.cachedData.nutritionOverview || {};
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
      nutritionAlerts: true
    }
  };
  
  // 合并默认配置和用户自定义配置
  const userConfig = { ...defaultConfig, ...this.notificationSettings };
  
  return userConfig;
};

// 将schema也导出，以便在其他地方可以直接访问
userSchema.statics.getSchema = function() {
  return userSchema;
};

// 使用modelRegistrar创建模型
const User = require('../modelRegistrar')('User', userSchema, {
  timestamps: true,
  optimizedIndexes: {
    frequentFields: ['phone', 'email', 'wechatOpenId', 'alipayUserId'],
    compound: [
      // 按角色查询用户
      {
        fields: { role: 1, currentRole: 1, createdAt: -1 },
        name: 'user_role_idx'
      },
      // 地区查询索引
      {
        fields: { 'region.province': 1, 'region.city': 1 },
        name: 'user_region_idx'
      }
    ],
    partial: [
      // 商家认证用户索引
      {
        fields: { 'merchantVerification.isVerified': 1, currentRole: 1 },
        filter: { 'merchantVerification.isVerified': true },
        name: 'verified_merchant_idx'
      },
      // 营养师认证用户索引
      {
        fields: { 'nutritionistVerification.isVerified': 1, currentRole: 1 },
        filter: { 'nutritionistVerification.isVerified': true },
        name: 'verified_nutritionist_idx'
      }
    ],
    text: [
      'nickname',
      'realName',
      'email',
      'phone'
    ]
  },
  // 查询助手方法
  query: {
    // 基本用户信息
    basicProfile: function() {
      return this.select('nickname phone email avatarUrl gender');
    },
    // 完整用户信息
    fullProfile: function() {
      return this.select('nickname phone email avatarUrl gender height weight age region dietaryPreferences');
    },
    // 营养师视图
    nutritionistView: function() {
      return this.select('nickname gender height weight age nutritionData region dietaryPreferences');
    },
    // 商家视图
    merchantView: function() {
      return this.select('nickname gender region dietaryPreferences');
    }
  }
});

// 确保User是构造函数
console.log('User模型类型:', typeof User);
if (typeof User === 'function') {
  console.log('User模型已成功导出为构造函数');
} else {
  console.error('警告: User模型不是构造函数，可能导致实例化失败');
}

// 为防止循环依赖问题，确保即使通过require获取此模块时也能正确返回User构造函数
if (require.main !== module) {
  // 这表示此文件被其他模块require，而不是直接运行
  console.log('User模型被其他模块引用，确保导出正确类型');
}

// 确保mongoose能正确识别这个模型
try {
  const mongoose = require('mongoose');
  // 将模型全局注册到mongoose，确保可以通过mongoose.model('User')获取
  if (!mongoose.models.User && typeof User === 'function') {
    mongoose.model('User', User.schema);
    console.log('已将User模型全局注册到mongoose');
  }
} catch (err) {
  console.error('全局注册User模型时出错:', err.message);
}

module.exports = User;
// ==============================
// 缓存数据更新方法（统一放在文件靠后处）
// ==============================

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

// 更新营养数据概览
userSchema.methods.updateNutritionOverview = async function() {
  try {
    // 获取最新的营养数据
    if (!NutritionProfile) NutritionProfile = require('../nutrition/nutritionProfileModel.js');
    const latestNutritionData = await NutritionProfile.findOne({
      userId: this._id
    }).sort({ createdAt: -1 });

    if (!latestNutritionData) return null;

    // 计算BMI
    let bmi = null;
    if (latestNutritionData.basicMetrics?.height && latestNutritionData.basicMetrics?.weight) {
      const heightInMeters = latestNutritionData.basicMetrics.height / 100;
      bmi = latestNutritionData.basicMetrics.weight / (heightInMeters * heightInMeters);
    }

    // 创建营养标签
    const nutritionTags = [];

    // 根据BMI分类
    if (bmi !== null) {
      if (bmi < 18.5) nutritionTags.push('underweight');
      else if (bmi < 24.9) nutritionTags.push('normalWeight');
      else if (bmi < 29.9) nutritionTags.push('overweight');
      else nutritionTags.push('obese');
    }

    // 根据血压分类
    if (latestNutritionData.basicMetrics?.bloodPressure) {
      const systolic = latestNutritionData.basicMetrics.bloodPressure.systolic;
      const diastolic = latestNutritionData.basicMetrics.bloodPressure.diastolic;

      if (systolic < 120 && diastolic < 80) nutritionTags.push('normalBp');
      else if (systolic < 130 && diastolic < 80) nutritionTags.push('elevatedBp');
      else if (systolic < 140 || diastolic < 90) nutritionTags.push('hypertensionStage1');
      else nutritionTags.push('hypertensionStage2');
    }

    // 计算营养得分 (简化版 0-100)
    let nutritionScore = 70; // 默认起始分

    // 基于BMI调整
    if (bmi !== null) {
      if (bmi >= 18.5 && bmi <= 24.9) nutritionScore += 10; // 理想BMI
      else if (bmi < 18.5 || bmi > 30) nutritionScore -= 10; // 非健康BMI
      else nutritionScore -= 5; // 轻度超重
    }

    // 基于血压调整
    if (latestNutritionData.basicMetrics?.bloodPressure) {
      const systolic = latestNutritionData.basicMetrics.bloodPressure.systolic;
      const diastolic = latestNutritionData.basicMetrics.bloodPressure.diastolic;

      if (systolic < 120 && diastolic < 80) nutritionScore += 10; // 理想血压
      else if (systolic >= 140 || diastolic >= 90) nutritionScore -= 10; // 高血压
    }

    // 确保得分在0-100范围内
    nutritionScore = Math.max(0, Math.min(100, nutritionScore));

    // 更新健康数据缓存
    this.cachedData = this.cachedData || {};
    this.cachedData.nutritionOverview = {
      currentBmi: bmi,
      nutritionScore: nutritionScore,
      nutritionTags: nutritionTags,
      lastUpdated: new Date()
    };

    await this.save();
    return this.cachedData.nutritionOverview;
  } catch (error) {
    console.error('更新用户营养概览数据时出错:', error);
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
        if (!Nutritionist) Nutritionist = require('../nutrition/nutritionistModel.js');
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
      this.updateNutritionOverview(),
      this.updateRecommendationStats(),
      this.updateNutritionistInteraction()
    ]);

    return this.cachedData;
  } catch (error) {
    console.error('刷新用户缓存数据时出错:', error);
    throw error;
  }
};