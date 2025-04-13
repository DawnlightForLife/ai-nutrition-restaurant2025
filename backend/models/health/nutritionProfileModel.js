/**
 * 营养档案模型
 * 定义用户的营养档案数据结构
 * @module models/health/nutritionProfileModel
 */
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// 食物偏好子模式
const dietaryPreferenceSchema = new Schema({
  isVegetarian: {
    type: Boolean,
    default: false
  },
  tastePreference: [{
    type: String,
    enum: ['light', 'spicy', 'sweet', 'sour', 'bitter'],
    default: ['light']
  }],
  taboos: [{
    type: String
  }],
  cuisine: {
    type: String,
    enum: ['chinese', 'western', 'japanese', 'korean', 'southeast_asian', 'other'],
    default: 'chinese'
  },
  allergies: [{
    type: String
  }]
}, { _id: false });

// 健康状况子模式
const healthStatusSchema = new Schema({
  chronicDiseases: [{
    type: String,
    enum: ['none', 'diabetes', 'hypertension', 'heart_disease', 'obesity', 'other'],
    default: ['none']
  }],
  specialConditions: [{
    type: String,
    enum: ['none', 'pregnancy', 'lactation', 'post_surgery', 'other'],
    default: ['none']
  }]
}, { _id: false });

// 生活方式子模式
const lifestyleSchema = new Schema({
  smoking: {
    type: Boolean,
    default: false
  },
  drinking: {
    type: Boolean,
    default: false
  },
  sleepDuration: {
    type: Number,
    min: 0,
    max: 24,
    default: 7
  },
  exerciseFrequency: {
    type: String,
    enum: ['none', 'occasional', 'regular', 'intense'],
    default: 'occasional'
  }
}, { _id: false });

// 地区子模式
const regionSchema = new Schema({
  province: {
    type: String,
    default: ''
  },
  city: {
    type: String,
    default: ''
  }
}, { _id: false });

// 营养档案主模式
const nutritionProfileSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  profileName: {
    type: String,
    required: true,
    trim: true
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other'
  },
  ageGroup: {
    type: String,
    enum: ['under_18', '18_30', '31_45', '46_60', 'above_60'],
    default: '18_30'
  },
  height: {
    type: Number,
    min: 0,
    max: 300,
    default: 170
  },
  weight: {
    type: Number,
    min: 0,
    max: 500,
    default: 60
  },
  region: {
    type: regionSchema,
    default: {}
  },
  occupation: {
    type: String,
    enum: ['student', 'office_worker', 'physical_worker', 'retired', 'other'],
    default: 'other'
  },
  healthStatus: {
    type: healthStatusSchema,
    default: () => ({})
  },
  dietaryPreferences: {
    type: dietaryPreferenceSchema,
    default: () => ({})
  },
  lifestyle: {
    type: lifestyleSchema,
    default: () => ({})
  },
  nutritionGoals: [{
    type: String,
    enum: ['weight_loss', 'weight_gain', 'muscle_building', 'general_health', 'disease_management', 'energy_boost'],
    default: ['general_health']
  }],
  isPrimary: {
    type: Boolean,
    default: false
  },
  archived: {
    type: Boolean,
    default: false
  },
  healthMetrics: {
    type: Map,
    of: mongoose.Schema.Types.Mixed,
    default: {}
  },
  relatedHealthData: [{
    type: Schema.Types.ObjectId,
    ref: 'HealthData'
  }]
}, {
  timestamps: true,
  versionKey: false
});

// 添加虚拟字段 - BMI
nutritionProfileSchema.virtual('bmi').get(function() {
  if (!this.height || !this.weight || this.height <= 0) return null;
  const heightInMeters = this.height / 100;
  return (this.weight / (heightInMeters * heightInMeters)).toFixed(1);
});

// 创建模型
const NutritionProfile = mongoose.model('NutritionProfile', nutritionProfileSchema);

module.exports = NutritionProfile;
