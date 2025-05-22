/**
 * 饮食偏好模型
 * 用于存储用户的饮食偏好数据
 * @module models/nutrition/dietaryPreferenceModel
 */
const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

/**
 * 饮食偏好模式定义
 */
const dietaryPreferenceSchema = new mongoose.Schema({
  // 用户ID关联
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
    description: '关联的用户ID'
  },
  
  // 饮食类型
  dietType: {
    type: String,
    enum: ['omnivore', 'vegetarian', 'vegan', 'pescatarian', 'flexitarian', 'keto', 'paleo', 'mediterranean', 'other'],
    default: 'omnivore',
    description: '饮食类型'
  },
  
  // 自定义饮食类型
  customDietType: {
    type: String,
    description: '自定义饮食类型描述'
  },
  
  // 食物过敏
  allergies: [{
    allergen: {
      type: String,
      description: '过敏原名称'
    },
    severity: {
      type: String,
      enum: ['mild', 'moderate', 'severe'],
      default: 'moderate',
      description: '过敏严重程度'
    }
  }],
  
  // 食物不耐受
  intolerances: [{
    type: String,
    description: '不耐受食物'
  }],
  
  // 禁忌食物
  avoidFoods: [{
    type: String,
    description: '需要避免的食物'
  }],
  
  // 喜好食物
  preferredFoods: [{
    type: String,
    description: '偏好食物'
  }],
  
  // 营养限制
  nutritionalRestrictions: {
    lowSodium: {
      type: Boolean,
      default: false,
      description: '低钠'
    },
    lowSugar: {
      type: Boolean,
      default: false,
      description: '低糖'
    },
    lowFat: {
      type: Boolean,
      default: false,
      description: '低脂'
    },
    lowCarb: {
      type: Boolean,
      default: false,
      description: '低碳水化合物'
    },
    highProtein: {
      type: Boolean,
      default: false,
      description: '高蛋白'
    },
    lowCalorie: {
      type: Boolean,
      default: false,
      description: '低热量'
    }
  },
  
  // 宗教或文化饮食限制
  culturalRestrictions: {
    type: String,
    description: '基于宗教或文化的饮食限制'
  },
  
  // 用餐频率偏好
  mealFrequency: {
    type: Number,
    min: 1,
    max: 10,
    default: 3,
    description: '每日餐次偏好'
  },
  
  // 饮食习惯备注
  notes: {
    type: String,
    description: '其他饮食习惯备注'
  },

  source: {
    type: String,
    enum: ['user', 'nutritionist', 'imported'],
    default: 'user',
    description: '饮食偏好信息来源（用户填写/营养师指定/系统导入）'
  },

  isActive: {
    type: Boolean,
    default: true,
    description: '是否为当前活跃偏好（用于多份记录管理）'
  },
  
  // 时间戳
  createdAt: {
    type: Date,
    default: Date.now,
    description: '创建时间'
  },
  
  updatedAt: {
    type: Date,
    default: Date.now,
    description: '更新时间'
  }
}, {
  timestamps: true
});

// 更新前处理
dietaryPreferenceSchema.pre('save', function(next) {
  this.updatedAt = new Date();
  next();
});

// 使用ModelFactory注册模型
const DietaryPreference = require('../modelRegistrar')('DietaryPreference', dietaryPreferenceSchema, {
  timestamps: true,
  optimizedIndexes: {
    frequentFields: ['userId'],
    compound: [
      {
        fields: { userId: 1, dietType: 1 },
        name: 'user_diet_type_idx',
        options: { background: true }
      }
    ]
  }
});

module.exports = DietaryPreference; 