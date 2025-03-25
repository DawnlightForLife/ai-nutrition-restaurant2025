const mongoose = require('mongoose');

// 定义用户模型的结构
const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true // 手机号唯一
  },
  password: {
    type: String,
    required: true
  },
  // 用户基本信息
  nickname: {
    type: String,
    default: ''
  },
  height: {
    type: Number,
    default: 0
  },
  weight: {
    type: Number, 
    default: 0
  },
  age: {
    type: Number,
    default: 0
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other'
  },
  activityLevel: {
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
    default: 'moderate'
  },
  // 地区信息
  region: {
    province: {
      type: String,
      default: ''
    },
    city: {
      type: String,
      default: ''
    }
  },
  // 饮食偏好
  dietaryPreferences: {
    cuisinePreference: {
      type: String,
      enum: ['north', 'south', 'east', 'west', 'sichuan', 'cantonese', 'hunan', 'other'],
      default: 'other'
    },
    allergies: [{
      type: String
    }],
    avoidedIngredients: [{
      type: String
    }],
    spicyPreference: {
      type: String,
      enum: ['none', 'mild', 'medium', 'hot', 'extra_hot'],
      default: 'medium'
    }
  },
  // 健康数据
  healthData: {
    hasRecentMedicalReport: {
      type: Boolean,
      default: false
    },
    medicalReportUrl: {
      type: String,
      default: ''
    },
    healthIssues: [{
      type: String
    }]
  },
  // 微信相关
  wechatOpenId: {
    type: String,
    sparse: true,
    unique: true
  },
  // 创建和更新时间
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// 更新前自动更新 updatedAt 字段
userSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

// 导出模型
const User = mongoose.model('User', userSchema);

module.exports = User;