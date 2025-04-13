/**
 * 健康指标模型
 * 定义用户健康指标数据结构，如体重、BMI、血压等
 * @module models/health/healthMetricsModel
 */
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// 健康指标模式
const healthMetricsSchema = new Schema({
  // 用户ID
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  // 指标类型
  metricType: {
    type: String,
    enum: [
      'weight', 'height', 'bmi', 'bloodPressure', 'bloodGlucose',
      'heartRate', 'cholesterol', 'sleep', 'steps', 'water',
      'temperature', 'oxygenSaturation', 'exercise', 'moodRating',
      'calorieIntake', 'macronutrients', 'micronutrients', 'bodyMeasurements',
      'bodyFatPercentage', 'custom'
    ],
    required: true,
    index: true
  },
  // 指标值（数值型指标）
  value: {
    type: Number,
    default: null
  },
  // 复合型指标值（如血压含有收缩压和舒张压）
  compoundValue: {
    type: Map,
    of: Number,
    default: null
  },
  // 文本型指标值（如运动记录描述）
  textValue: {
    type: String,
    default: null
  },
  // 记录时间
  recordedAt: {
    type: Date,
    default: Date.now,
    index: true
  },
  // 单位
  unit: {
    type: String,
    default: null
  },
  // 相关标签
  tags: [{
    type: String
  }],
  // 备注
  notes: {
    type: String,
    default: null
  },
  // 关联的营养档案
  nutritionProfileId: {
    type: Schema.Types.ObjectId,
    ref: 'NutritionProfile',
    default: null
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
}, {
  timestamps: true,
  versionKey: false
});

// 添加复合索引
healthMetricsSchema.index({ userId: 1, metricType: 1, recordedAt: -1 });

// 添加更新时间钩子
healthMetricsSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

// 创建模型
const HealthMetrics = mongoose.model('HealthMetrics', healthMetricsSchema);

module.exports = HealthMetrics; 