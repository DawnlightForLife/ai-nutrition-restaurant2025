/**
 * 烹饪方式营养影响模型
 * 定义不同烹饪方法对营养素的影响系数
 * @module models/nutrition/cookingMethodModel
 */
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// 烹饪方法分类
const COOKING_CATEGORIES = {
  WET_HEAT: 'wet_heat',           // 湿热法
  DRY_HEAT: 'dry_heat',           // 干热法
  COMBINATION: 'combination',      // 混合法
  RAW_PREPARATION: 'raw_preparation', // 生食处理
  FERMENTATION: 'fermentation',    // 发酵法
  SMOKING: 'smoking',             // 熏制法
  DEHYDRATION: 'dehydration'      // 脱水法
};

// 烹饪方法枚举
const COOKING_METHODS = {
  // 湿热法
  BOILING: 'boiling',             // 水煮
  STEAMING: 'steaming',           // 蒸制
  POACHING: 'poaching',           // 水波煮
  SIMMERING: 'simmering',         // 炖煮
  BLANCHING: 'blanching',         // 焯水
  PRESSURE_COOKING: 'pressure_cooking', // 高压煮
  SLOW_COOKING: 'slow_cooking',   // 慢炖
  SOUS_VIDE: 'sous_vide',         // 真空低温烹调
  
  // 干热法
  ROASTING: 'roasting',           // 烘烤
  BAKING: 'baking',               // 烘焙
  GRILLING: 'grilling',           // 烧烤
  BROILING: 'broiling',           // 炙烤
  FRYING: 'frying',               // 油炸
  STIR_FRYING: 'stir_frying',     // 爆炒
  SAUTEING: 'sauteing',           // 煎炒
  PAN_FRYING: 'pan_frying',       // 平底锅煎
  DEEP_FRYING: 'deep_frying',     // 深度油炸
  AIR_FRYING: 'air_frying',       // 空气炸
  
  // 混合法
  BRAISING: 'braising',           // 红烧
  STEWING: 'stewing',             // 炖煮
  CASSEROLING: 'casseroling',     // 砂锅煮
  
  // 生食处理
  RAW: 'raw',                     // 生食
  MARINATING: 'marinating',       // 腌制
  CURING: 'curing',               // 腌渍
  PICKLING: 'pickling',           // 泡菜
  
  // 发酵法
  FERMENTATION: 'fermentation',    // 发酵
  
  // 熏制法
  HOT_SMOKING: 'hot_smoking',     // 热熏
  COLD_SMOKING: 'cold_smoking',   // 冷熏
  
  // 脱水法
  DEHYDRATING: 'dehydrating',     // 脱水
  FREEZE_DRYING: 'freeze_drying'  // 冻干
};

// 温度范围枚举
const TEMPERATURE_RANGES = {
  COLD: 'cold',                   // 冷藏 (0-4°C)
  ROOM: 'room',                   // 室温 (20-25°C)
  WARM: 'warm',                   // 温热 (40-60°C)
  LOW: 'low',                     // 低温 (60-100°C)
  MEDIUM: 'medium',               // 中温 (100-150°C)
  HIGH: 'high',                   // 高温 (150-200°C)
  VERY_HIGH: 'very_high'          // 极高温 (>200°C)
};

// 营养素影响类型
const IMPACT_TYPES = {
  RETENTION: 'retention',         // 保留
  LOSS: 'loss',                   // 损失
  ENHANCEMENT: 'enhancement',     // 增强
  TRANSFORMATION: 'transformation' // 转化
};

// 单个营养素影响子模式
const nutrientImpactSchema = new Schema({
  nutrient: {
    type: String,
    required: true,
    description: '营养素名称'
  },
  impactType: {
    type: String,
    enum: Object.values(IMPACT_TYPES),
    required: true,
    description: '影响类型'
  },
  retentionRate: {
    type: Number,
    min: 0,
    max: 200, // 允许营养素增加
    description: '保留率百分比'
  },
  variationRange: {
    min: { type: Number, description: '最小保留率' },
    max: { type: Number, description: '最大保留率' }
  },
  influencingFactors: [{
    factor: { type: String, description: '影响因素' },
    impact: { type: String, description: '影响描述' }
  }],
  mechanism: {
    type: String,
    description: '影响机制说明'
  },
  timeDependent: {
    type: Boolean,
    default: false,
    description: '是否时间依赖性'
  },
  timeCurve: [{
    time: { type: Number, description: '时间(分钟)' },
    retentionRate: { type: Number, description: '保留率%' }
  }]
}, { _id: false });

// 温度时间曲线子模式
const temperatureTimeCurveSchema = new Schema({
  temperature: {
    type: Number,
    required: true,
    description: '温度(°C)'
  },
  timePoints: [{
    time: { type: Number, description: '时间(分钟)' },
    overallNutritionRetention: { type: Number, description: '整体营养保留率%' },
    specificNutrients: [{
      nutrient: { type: String, description: '特定营养素' },
      retention: { type: Number, description: '保留率%' }
    }]
  }]
}, { _id: false });

// 食材适用性子模式
const ingredientApplicabilitySchema = new Schema({
  category: {
    type: String,
    description: '食材类别'
  },
  specificIngredients: [{
    type: String,
    description: '特定食材'
  }],
  effectiveness: {
    type: String,
    enum: ['excellent', 'good', 'fair', 'poor', 'not_recommended'],
    description: '适用效果'
  },
  specialConsiderations: [{
    type: String,
    description: '特殊注意事项'
  }],
  nutritionModifiers: [{
    nutrient: { type: String, description: '营养素' },
    modifier: { type: Number, description: '修正系数' },
    reason: { type: String, description: '修正原因' }
  }]
}, { _id: false });

// 烹饪方式主模式
const cookingMethodSchema = new Schema({
  // 基本信息
  name: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    description: '烹饪方法名称'
  },
  chineseName: {
    type: String,
    required: true,
    trim: true,
    description: '中文名称'
  },
  description: {
    type: String,
    description: '详细描述'
  },
  aliases: [{
    type: String,
    description: '别名'
  }],
  
  // 分类信息
  category: {
    type: String,
    enum: Object.values(COOKING_CATEGORIES),
    required: true,
    description: '烹饪类别'
  },
  method: {
    type: String,
    enum: Object.values(COOKING_METHODS),
    required: true,
    description: '具体方法'
  },
  
  // 技术参数
  technicalParameters: {
    temperatureRange: {
      type: String,
      enum: Object.values(TEMPERATURE_RANGES),
      description: '温度范围分类'
    },
    minTemperature: {
      type: Number,
      description: '最低温度(°C)'
    },
    maxTemperature: {
      type: Number,
      description: '最高温度(°C)'
    },
    optimalTemperature: {
      type: Number,
      description: '最佳温度(°C)'
    },
    typicalCookingTime: {
      min: { type: Number, description: '最短时间(分钟)' },
      max: { type: Number, description: '最长时间(分钟)' },
      optimal: { type: Number, description: '最佳时间(分钟)' }
    },
    moistureLevel: {
      type: String,
      enum: ['very_dry', 'dry', 'moderate', 'moist', 'very_moist'],
      description: '湿度水平'
    },
    oxygenExposure: {
      type: String,
      enum: ['none', 'minimal', 'moderate', 'high'],
      description: '氧气接触程度'
    },
    lightExposure: {
      type: String,
      enum: ['none', 'minimal', 'moderate', 'high'],
      description: '光照接触程度'
    }
  },
  
  // 营养影响
  nutritionImpacts: [{
    type: nutrientImpactSchema,
    description: '营养素影响列表'
  }],
  
  // 整体营养保留率
  overallNutritionRetention: {
    average: {
      type: Number,
      min: 0,
      max: 150,
      description: '平均营养保留率%'
    },
    range: {
      min: { type: Number, description: '最低保留率%' },
      max: { type: Number, description: '最高保留率%' }
    },
    factors: [{
      factor: { type: String, description: '影响因素' },
      impact: { type: String, description: '影响程度' }
    }]
  },
  
  // 温度时间曲线
  temperatureTimeCurves: [{
    type: temperatureTimeCurveSchema,
    description: '不同温度下的时间曲线'
  }],
  
  // 食材适用性
  ingredientApplicability: [{
    type: ingredientApplicabilitySchema,
    description: '对不同食材的适用性'
  }],
  
  // 营养增强效果
  nutritionEnhancements: [{
    nutrient: { type: String, description: '营养素' },
    enhancement: { type: String, description: '增强效果' },
    mechanism: { type: String, description: '增强机制' },
    conditions: [{ type: String, description: '增强条件' }]
  }],
  
  // 有害物质生成
  harmfulCompounds: [{
    compound: { type: String, description: '有害化合物' },
    conditions: [{ type: String, description: '生成条件' }],
    prevention: [{ type: String, description: '预防方法' }],
    healthRisk: {
      type: String,
      enum: ['low', 'moderate', 'high', 'very_high'],
      description: '健康风险等级'
    }
  }],
  
  // 消化性影响
  digestibilityImpact: {
    proteinDigestibility: {
      change: { type: Number, description: '蛋白质消化率变化%' },
      mechanism: { type: String, description: '影响机制' }
    },
    starchDigestibility: {
      change: { type: Number, description: '淀粉消化率变化%' },
      mechanism: { type: String, description: '影响机制' }
    },
    fatDigestibility: {
      change: { type: Number, description: '脂肪消化率变化%' },
      mechanism: { type: String, description: '影响机制' }
    },
    overallDigestibility: {
      type: String,
      enum: ['much_better', 'better', 'same', 'worse', 'much_worse'],
      description: '整体消化性变化'
    }
  },
  
  // 抗营养因子影响
  antinutrientImpact: [{
    antinutrient: { type: String, description: '抗营养因子' },
    reductionRate: { type: Number, min: 0, max: 100, description: '减少率%' },
    conditions: [{ type: String, description: '减少条件' }]
  }],
  
  // 生物活性化合物影响
  bioactiveImpact: [{
    compound: { type: String, description: '生物活性化合物' },
    change: { type: Number, description: '变化率%' },
    newFormation: { type: Boolean, description: '是否形成新化合物' },
    activityChange: { type: String, description: '活性变化' }
  }],
  
  // 设备和工具要求
  equipmentRequirements: {
    essential: [{
      type: String,
      description: '必需设备'
    }],
    optional: [{
      type: String,
      description: '可选设备'
    }],
    energyConsumption: {
      type: String,
      enum: ['very_low', 'low', 'moderate', 'high', 'very_high'],
      description: '能耗水平'
    }
  },
  
  // 技能要求
  skillRequirements: {
    difficultyLevel: {
      type: String,
      enum: ['beginner', 'intermediate', 'advanced', 'expert'],
      description: '难度等级'
    },
    criticalTechniques: [{
      type: String,
      description: '关键技巧'
    }],
    commonMistakes: [{
      mistake: { type: String, description: '常见错误' },
      nutritionImpact: { type: String, description: '对营养的影响' },
      prevention: { type: String, description: '预防方法' }
    }]
  },
  
  // 成本和时间效率
  efficiency: {
    timeEfficiency: {
      type: String,
      enum: ['very_fast', 'fast', 'moderate', 'slow', 'very_slow'],
      description: '时间效率'
    },
    energyEfficiency: {
      type: String,
      enum: ['very_high', 'high', 'moderate', 'low', 'very_low'],
      description: '能源效率'
    },
    costEffectiveness: {
      type: String,
      enum: ['very_high', 'high', 'moderate', 'low', 'very_low'],
      description: '成本效益'
    },
    nutritionEfficiency: {
      type: String,
      enum: ['excellent', 'good', 'fair', 'poor'],
      description: '营养效率'
    }
  },
  
  // 科学研究支持
  researchSupport: {
    studyCount: {
      type: Number,
      description: '相关研究数量'
    },
    evidenceLevel: {
      type: String,
      enum: ['high', 'moderate', 'limited', 'insufficient'],
      description: '科学证据等级'
    },
    lastReviewed: {
      type: Date,
      description: '最后审查日期'
    },
    keyFindings: [{
      type: String,
      description: '主要研究发现'
    }]
  },
  
  // 状态标识
  isActive: {
    type: Boolean,
    default: true,
    description: '是否启用'
  },
  version: {
    type: Number,
    default: 1,
    description: '数据版本'
  }
}, {
  timestamps: true,
  versionKey: false
});

// 创建索引
cookingMethodSchema.index({ name: 1 });
cookingMethodSchema.index({ category: 1 });
cookingMethodSchema.index({ method: 1 });
cookingMethodSchema.index({ 'technicalParameters.temperatureRange': 1 });
cookingMethodSchema.index({ 'overallNutritionRetention.average': 1 });
cookingMethodSchema.index({ 'efficiency.nutritionEfficiency': 1 });
cookingMethodSchema.index({ isActive: 1 });

// 复合索引
cookingMethodSchema.index({ category: 1, 'efficiency.nutritionEfficiency': 1 });
cookingMethodSchema.index({ 'skillRequirements.difficultyLevel': 1, 'efficiency.timeEfficiency': 1 });

// 实例方法 - 获取特定营养素的保留率
cookingMethodSchema.methods.getNutrientRetention = function(nutrientName) {
  const impact = this.nutritionImpacts.find(n => n.nutrient === nutrientName);
  return impact ? impact.retentionRate : this.overallNutritionRetention.average;
};

// 实例方法 - 计算指定时间和温度下的营养保留
cookingMethodSchema.methods.calculateRetentionAtConditions = function(temperature, time) {
  const curve = this.temperatureTimeCurves.find(c => 
    Math.abs(c.temperature - temperature) <= 10
  );
  
  if (!curve) return this.overallNutritionRetention.average;
  
  // 找到最接近的时间点
  const timePoint = curve.timePoints.reduce((closest, point) => 
    Math.abs(point.time - time) < Math.abs(closest.time - time) ? point : closest
  );
  
  return timePoint ? timePoint.overallNutritionRetention : this.overallNutritionRetention.average;
};

// 实例方法 - 检查是否适用于特定食材
cookingMethodSchema.methods.isApplicableFor = function(ingredientCategory) {
  const applicability = this.ingredientApplicability.find(a => 
    a.category === ingredientCategory || a.specificIngredients.includes(ingredientCategory)
  );
  
  return applicability ? applicability.effectiveness : 'fair';
};

// 静态方法 - 按营养保留率查找最佳方法
cookingMethodSchema.statics.findBestForNutrition = function(minRetention = 80) {
  return this.find({
    'overallNutritionRetention.average': { $gte: minRetention },
    isActive: true
  }).sort({ 'overallNutritionRetention.average': -1 });
};

// 静态方法 - 按难度等级查找
cookingMethodSchema.statics.findByDifficulty = function(difficulty) {
  return this.find({
    'skillRequirements.difficultyLevel': difficulty,
    isActive: true
  });
};

// 静态方法 - 按效率查找
cookingMethodSchema.statics.findByEfficiency = function(timeEff, nutritionEff) {
  return this.find({
    'efficiency.timeEfficiency': timeEff,
    'efficiency.nutritionEfficiency': nutritionEff,
    isActive: true
  });
};

// 创建模型
const CookingMethod = mongoose.model('CookingMethod', cookingMethodSchema);

module.exports = {
  CookingMethod,
  COOKING_CATEGORIES,
  COOKING_METHODS,
  TEMPERATURE_RANGES,
  IMPACT_TYPES
};