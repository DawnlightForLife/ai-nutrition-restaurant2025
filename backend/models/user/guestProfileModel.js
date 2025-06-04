const mongoose = require('mongoose');
const { Schema, ObjectId } = mongoose;
const crypto = require('crypto');

const guestProfileSchema = new Schema({
  guestId: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  
  // 营养档案数据
  profileData: {
    // 基本信息
    age: { type: Number, min: 0, max: 150 },
    gender: { type: String, enum: ['male', 'female', 'other'] },
    height: { type: Number, min: 50, max: 300 }, // cm
    weight: { type: Number, min: 20, max: 500 }, // kg
    activityLevel: { 
      type: String, 
      enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
      default: 'moderate'
    },
    
    // 健康目标
    healthGoals: [{
      type: String,
      enum: ['weight_loss', 'weight_gain', 'muscle_gain', 'maintenance', 'health_improvement']
    }],
    
    // 饮食偏好
    dietaryPreferences: [{
      type: String,
      enum: ['vegetarian', 'vegan', 'keto', 'paleo', 'mediterranean', 'low_carb', 'high_protein']
    }],
    
    // 过敏信息
    allergies: [{
      allergen: { type: String, required: true },
      severity: { type: String, enum: ['mild', 'moderate', 'severe'], default: 'moderate' }
    }],
    
    // 疾病史
    medicalConditions: [{
      condition: { type: String, required: true },
      diagnosed: { type: Date },
      severity: { type: String, enum: ['mild', 'moderate', 'severe'] }
    }]
  },
  
  // 创建者信息
  createdBy: {
    type: ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  
  // 绑定令牌（用于游客转正式用户）
  bindingToken: {
    type: String,
    unique: true,
    sparse: true,
    index: true
  },
  
  // 绑定状态
  bindingStatus: {
    type: String,
    enum: ['pending', 'bound', 'expired'],
    default: 'pending'
  },
  
  // 绑定的用户ID
  boundUserId: {
    type: ObjectId,
    ref: 'User',
    sparse: true
  },
  
  // 访问记录
  accessLogs: [{
    timestamp: { type: Date, default: Date.now },
    ipAddress: String,
    userAgent: String,
    action: { type: String, enum: ['created', 'viewed', 'updated', 'bound'] }
  }],
  
  // 自动过期时间（7天后过期）
  expiresAt: {
    type: Date,
    default: () => new Date(Date.now() + 7 * 24 * 60 * 60 * 1000),
    index: { expireAfterSeconds: 0 }
  }
}, {
  timestamps: true,
  collection: 'guest_profiles'
});

// 索引优化
guestProfileSchema.index({ createdBy: 1, createdAt: -1 });
guestProfileSchema.index({ bindingToken: 1 }, { sparse: true });
guestProfileSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

// 生成唯一的游客ID
guestProfileSchema.statics.generateGuestId = function() {
  return 'guest_' + crypto.randomBytes(8).toString('hex');
};

// 生成绑定令牌
guestProfileSchema.statics.generateBindingToken = function() {
  return crypto.randomBytes(32).toString('hex');
};

// 创建游客档案
guestProfileSchema.statics.createGuestProfile = async function(profileData, createdBy, options = {}) {
  const guestId = this.generateGuestId();
  const bindingToken = this.generateBindingToken();
  
  const guestProfile = new this({
    guestId,
    profileData,
    createdBy,
    bindingToken,
    accessLogs: [{
      action: 'created',
      ipAddress: options.ipAddress,
      userAgent: options.userAgent
    }]
  });
  
  return await guestProfile.save();
};

// 通过绑定令牌查找档案
guestProfileSchema.statics.findByBindingToken = async function(token) {
  return await this.findOne({
    bindingToken: token,
    bindingStatus: 'pending',
    expiresAt: { $gt: new Date() }
  }).populate('createdBy', 'username email');
};

// 绑定到正式用户
guestProfileSchema.methods.bindToUser = async function(userId, options = {}) {
  this.boundUserId = userId;
  this.bindingStatus = 'bound';
  this.bindingToken = undefined; // 清除绑定令牌
  
  this.accessLogs.push({
    action: 'bound',
    ipAddress: options.ipAddress,
    userAgent: options.userAgent
  });
  
  return await this.save();
};

// 记录访问日志
guestProfileSchema.methods.logAccess = async function(action, options = {}) {
  this.accessLogs.push({
    action,
    timestamp: new Date(),
    ipAddress: options.ipAddress,
    userAgent: options.userAgent
  });
  
  // 只保留最近20条记录
  if (this.accessLogs.length > 20) {
    this.accessLogs = this.accessLogs.slice(-20);
  }
  
  return await this.save();
};

// 获取营养需求计算
guestProfileSchema.methods.calculateNutritionNeeds = function() {
  const { age, gender, height, weight, activityLevel } = this.profileData;
  
  if (!age || !gender || !height || !weight) {
    return null;
  }
  
  // 基础代谢率计算 (Mifflin-St Jeor方程)
  let bmr;
  if (gender === 'male') {
    bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
  } else {
    bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
  }
  
  // 活动系数
  const activityMultipliers = {
    sedentary: 1.2,
    light: 1.375,
    moderate: 1.55,
    active: 1.725,
    very_active: 1.9
  };
  
  const tdee = bmr * (activityMultipliers[activityLevel] || 1.55);
  
  return {
    bmr: Math.round(bmr),
    tdee: Math.round(tdee),
    protein: Math.round(weight * 0.8), // g
    carbs: Math.round(tdee * 0.45 / 4), // g
    fat: Math.round(tdee * 0.25 / 9), // g
    fiber: Math.round(age < 50 ? (gender === 'male' ? 38 : 25) : (gender === 'male' ? 30 : 21)) // g
  };
};

// 数据验证
guestProfileSchema.pre('save', function(next) {
  // 验证年龄与体重身高的合理性
  if (this.profileData.age && this.profileData.weight && this.profileData.height) {
    const bmi = this.profileData.weight / Math.pow(this.profileData.height / 100, 2);
    if (bmi < 10 || bmi > 50) {
      return next(new Error('身高体重数据不合理，请检查输入'));
    }
  }
  
  next();
});

// 软删除支持
guestProfileSchema.add({
  isDeleted: { type: Boolean, default: false },
  deletedAt: { type: Date },
  deletedBy: { type: ObjectId, ref: 'User' }
});

module.exports = mongoose.model('GuestProfile', guestProfileSchema);