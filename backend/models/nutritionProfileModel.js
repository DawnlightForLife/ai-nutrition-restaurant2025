const mongoose = require('mongoose');

const nutritionProfileSchema = new mongoose.Schema({
  ownerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  name: {
    type: String,
    required: true
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other'
  },
  age: {
    type: Number,
    min: 0,
    max: 120
  },
  height: {
    type: Number,
    min: 50,
    max: 250
  },
  weight: {
    type: Number,
    min: 20,
    max: 300
  },
  activityLevel: {
    type: String,
    enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
    default: 'moderate'
  },
  // 健康状况
  healthConditions: [{
    type: String
  }],
  // 饮食偏好
  dietaryPreferences: {
    cuisinePreference: {
      type: String,
      enum: ['north', 'south', 'east', 'west', 'sichuan', 'cantonese', 'hunan', 'other'],
      default: 'other'
    },
    spicyPreference: {
      type: String,
      enum: ['none', 'mild', 'medium', 'hot', 'extra_hot'],
      default: 'medium'
    },
    allergies: [{
      type: String
    }],
    avoidedIngredients: [{
      type: String
    }]
  },
  // 目标
  goals: {
    type: String,
    enum: ['weight_loss', 'weight_gain', 'maintenance', 'muscle_gain', 'health_improvement'],
    default: 'health_improvement'
  },
  // 创建时间
  createdAt: {
    type: Date,
    default: Date.now
  },
  // 更新时间
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// 更新前自动更新时间
nutritionProfileSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

const NutritionProfile = mongoose.model('NutritionProfile', nutritionProfileSchema);

module.exports = NutritionProfile; 