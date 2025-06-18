/**
 * 食材营养成分模型
 * 定义食材详细营养信息和营养元素含量
 * @module models/nutrition/ingredientNutritionModel
 */
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// 食材分类枚举
const INGREDIENT_CATEGORIES = {
  // 蛋白质来源
  MEAT: 'meat',                    // 肉类
  POULTRY: 'poultry',             // 禽类
  SEAFOOD: 'seafood',             // 海鲜
  EGGS: 'eggs',                   // 蛋类
  DAIRY: 'dairy',                 // 乳制品
  LEGUMES: 'legumes',             // 豆类
  NUTS_SEEDS: 'nuts_seeds',       // 坚果种子
  
  // 碳水化合物来源
  GRAINS: 'grains',               // 谷物
  TUBERS: 'tubers',               // 薯类
  FRUITS: 'fruits',               // 水果
  
  // 脂肪来源
  OILS: 'oils',                   // 油脂
  
  // 维生素矿物质来源
  VEGETABLES: 'vegetables',        // 蔬菜
  HERBS_SPICES: 'herbs_spices',   // 香料调料
  MUSHROOMS: 'mushrooms',         // 菌类
  
  // 其他
  BEVERAGES: 'beverages',         // 饮品
  CONDIMENTS: 'condiments',       // 调味品
  SUPPLEMENTS: 'supplements'       // 营养补充剂
};

// 食材新鲜度等级
const FRESHNESS_LEVELS = {
  FRESH: 'fresh',                 // 新鲜
  FROZEN: 'frozen',               // 冷冻
  DRIED: 'dried',                 // 干制
  CANNED: 'canned',               // 罐装
  PROCESSED: 'processed'          // 加工
};

// 营养密度等级
const NUTRITION_DENSITY = {
  VERY_HIGH: 'very_high',         // 极高
  HIGH: 'high',                   // 高
  MODERATE: 'moderate',           // 中等
  LOW: 'low',                     // 低
  VERY_LOW: 'very_low'            // 极低
};

// 单个营养元素含量子模式
const nutritionContentSchema = new Schema({
  element: {
    type: String,
    required: true,
    description: '营养元素名称'
  },
  amount: {
    type: Number,
    required: true,
    min: 0,
    description: '含量'
  },
  unit: {
    type: String,
    required: true,
    description: '单位'
  },
  dailyValuePercentage: {
    type: Number,
    min: 0,
    max: 10000, // 允许超过100%
    description: '占每日推荐摄入量百分比'
  },
  bioavailability: {
    type: Number,
    min: 0,
    max: 100,
    default: 100,
    description: '生物利用度百分比'
  },
  isEstimated: {
    type: Boolean,
    default: false,
    description: '是否为估算值'
  },
  lastTested: {
    type: Date,
    description: '最后检测时间'
  },
  testMethod: {
    type: String,
    description: '检测方法'
  }
}, { _id: false });

// 季节性变化子模式
const seasonalVariationSchema = new Schema({
  spring: {
    availability: { type: Number, min: 0, max: 100, description: '春季可得性%' },
    qualityScore: { type: Number, min: 0, max: 10, description: '春季品质评分' },
    nutritionMultiplier: { type: Number, min: 0.5, max: 2, default: 1, description: '营养倍数' }
  },
  summer: {
    availability: { type: Number, min: 0, max: 100, description: '夏季可得性%' },
    qualityScore: { type: Number, min: 0, max: 10, description: '夏季品质评分' },
    nutritionMultiplier: { type: Number, min: 0.5, max: 2, default: 1, description: '营养倍数' }
  },
  autumn: {
    availability: { type: Number, min: 0, max: 100, description: '秋季可得性%' },
    qualityScore: { type: Number, min: 0, max: 10, description: '秋季品质评分' },
    nutritionMultiplier: { type: Number, min: 0.5, max: 2, default: 1, description: '营养倍数' }
  },
  winter: {
    availability: { type: Number, min: 0, max: 100, description: '冬季可得性%' },
    qualityScore: { type: Number, min: 0, max: 10, description: '冬季品质评分' },
    nutritionMultiplier: { type: Number, min: 0.5, max: 2, default: 1, description: '营养倍数' }
  }
}, { _id: false });

// 存储条件子模式
const storageConditionsSchema = new Schema({
  temperature: {
    min: { type: Number, description: '最低存储温度(°C)' },
    max: { type: Number, description: '最高存储温度(°C)' },
    optimal: { type: Number, description: '最佳存储温度(°C)' }
  },
  humidity: {
    min: { type: Number, min: 0, max: 100, description: '最低湿度%' },
    max: { type: Number, min: 0, max: 100, description: '最高湿度%' },
    optimal: { type: Number, min: 0, max: 100, description: '最佳湿度%' }
  },
  lightExposure: {
    type: String,
    enum: ['none', 'minimal', 'moderate', 'full'],
    description: '光照要求'
  },
  shelfLife: {
    fresh: { type: Number, description: '新鲜状态保质期(天)' },
    refrigerated: { type: Number, description: '冷藏保质期(天)' },
    frozen: { type: Number, description: '冷冻保质期(天)' }
  },
  nutritionDegradation: [{
    element: { type: String, description: '营养元素' },
    degradationRate: { type: Number, min: 0, max: 100, description: '每天损失率%' },
    halfLife: { type: Number, description: '半衰期(天)' }
  }]
}, { _id: false });

// 食材营养成分主模式
const ingredientNutritionSchema = new Schema({
  // 基本信息
  name: {
    type: String,
    required: true,
    trim: true,
    description: '食材名称'
  },
  chineseName: {
    type: String,
    required: true,
    trim: true,
    description: '中文名称'
  },
  scientificName: {
    type: String,
    trim: true,
    description: '学名'
  },
  commonNames: [{
    type: String,
    description: '常用别名'
  }],
  
  // 分类信息
  category: {
    type: String,
    enum: Object.values(INGREDIENT_CATEGORIES),
    required: true,
    description: '食材类别'
  },
  subCategory: {
    type: String,
    description: '子类别'
  },
  
  // 基本属性
  servingSize: {
    amount: {
      type: Number,
      required: true,
      min: 0,
      description: '标准份量'
    },
    unit: {
      type: String,
      enum: ['g', 'ml', 'piece', 'cup', 'tablespoon', 'teaspoon'],
      required: true,
      description: '份量单位'
    },
    description: {
      type: String,
      description: '份量描述'
    }
  },
  
  // 营养密度评级
  nutritionDensity: {
    overall: {
      type: String,
      enum: Object.values(NUTRITION_DENSITY),
      description: '整体营养密度'
    },
    protein: {
      type: String,
      enum: Object.values(NUTRITION_DENSITY),
      description: '蛋白质密度'
    },
    micronutrients: {
      type: String,
      enum: Object.values(NUTRITION_DENSITY),
      description: '微营养素密度'
    },
    antioxidants: {
      type: String,
      enum: Object.values(NUTRITION_DENSITY),
      description: '抗氧化剂密度'
    }
  },
  
  // 详细营养成分
  nutritionContent: [{
    type: nutritionContentSchema,
    description: '营养元素含量列表'
  }],
  
  // 宏量营养素快速访问
  macronutrients: {
    calories: {
      type: Number,
      min: 0,
      description: '热量(kcal/100g)'
    },
    protein: {
      type: Number,
      min: 0,
      description: '蛋白质(g/100g)'
    },
    carbohydrates: {
      total: { type: Number, min: 0, description: '总碳水化合物(g/100g)' },
      fiber: { type: Number, min: 0, description: '膳食纤维(g/100g)' },
      sugars: { type: Number, min: 0, description: '糖类(g/100g)' },
      starch: { type: Number, min: 0, description: '淀粉(g/100g)' }
    },
    fats: {
      total: { type: Number, min: 0, description: '总脂肪(g/100g)' },
      saturated: { type: Number, min: 0, description: '饱和脂肪(g/100g)' },
      monounsaturated: { type: Number, min: 0, description: '单不饱和脂肪(g/100g)' },
      polyunsaturated: { type: Number, min: 0, description: '多不饱和脂肪(g/100g)' },
      trans: { type: Number, min: 0, description: '反式脂肪(g/100g)' },
      cholesterol: { type: Number, min: 0, description: '胆固醇(mg/100g)' }
    },
    water: {
      type: Number,
      min: 0,
      max: 100,
      description: '水分含量(%)'
    },
    alcohol: {
      type: Number,
      min: 0,
      description: '酒精含量(g/100g)'
    }
  },
  
  // 氨基酸谱
  aminoAcidProfile: {
    complete: {
      type: Boolean,
      description: '是否为完全蛋白质'
    },
    limitingAminoAcid: {
      type: String,
      description: '限制性氨基酸'
    },
    aminoAcids: [{
      name: { type: String, description: '氨基酸名称' },
      amount: { type: Number, description: '含量(mg/g蛋白质)' },
      essential: { type: Boolean, description: '是否必需氨基酸' }
    }],
    biologicalValue: {
      type: Number,
      min: 0,
      max: 100,
      description: '生物价'
    },
    proteinDigestibilityScore: {
      type: Number,
      min: 0,
      max: 1,
      description: '蛋白质消化率评分'
    }
  },
  
  // 脂肪酸谱
  fattyAcidProfile: [{
    name: { type: String, description: '脂肪酸名称' },
    percentage: { type: Number, min: 0, max: 100, description: '占总脂肪百分比' },
    category: { 
      type: String, 
      enum: ['saturated', 'monounsaturated', 'polyunsaturated', 'trans'],
      description: '脂肪酸类型' 
    },
    essential: { type: Boolean, description: '是否必需脂肪酸' }
  }],
  
  // 抗营养因子
  antinutrients: [{
    name: { type: String, description: '抗营养因子名称' },
    amount: { type: Number, description: '含量' },
    unit: { type: String, description: '单位' },
    effect: { type: String, description: '对营养吸收的影响' },
    reductionMethods: [{ type: String, description: '减少方法' }]
  }],
  
  // 生物活性化合物
  bioactiveCompounds: [{
    name: { type: String, description: '化合物名称' },
    category: { 
      type: String, 
      enum: ['polyphenols', 'carotenoids', 'flavonoids', 'glucosinolates', 'alkaloids', 'terpenes'],
      description: '化合物类别' 
    },
    amount: { type: Number, description: '含量' },
    unit: { type: String, description: '单位' },
    healthBenefits: [{ type: String, description: '健康益处' }]
  }],
  
  // 血糖指数相关
  glycemicResponse: {
    glycemicIndex: {
      type: Number,
      min: 0,
      max: 150,
      description: '血糖指数'
    },
    glycemicLoad: {
      type: Number,
      min: 0,
      description: '血糖负荷'
    },
    insulinIndex: {
      type: Number,
      min: 0,
      description: '胰岛素指数'
    }
  },
  
  // 新鲜度和处理状态
  freshnessLevel: {
    type: String,
    enum: Object.values(FRESHNESS_LEVELS),
    default: FRESHNESS_LEVELS.FRESH,
    description: '新鲜度等级'
  },
  
  // 季节性变化
  seasonalVariation: {
    type: seasonalVariationSchema,
    description: '季节性营养变化'
  },
  
  // 存储条件
  storageConditions: {
    type: storageConditionsSchema,
    description: '存储条件和营养保持'
  },
  
  // 产地信息
  originInfo: {
    regions: [{
      type: String,
      description: '主要产地'
    }],
    organicAvailable: {
      type: Boolean,
      default: false,
      description: '是否有有机版本'
    },
    wildHarvested: {
      type: Boolean,
      default: false,
      description: '是否为野生采集'
    }
  },
  
  // 可持续性评分
  sustainabilityScore: {
    environmental: {
      type: Number,
      min: 0,
      max: 10,
      description: '环境影响评分'
    },
    social: {
      type: Number,
      min: 0,
      max: 10,
      description: '社会影响评分'
    },
    economic: {
      type: Number,
      min: 0,
      max: 10,
      description: '经济影响评分'
    }
  },
  
  // 过敏原信息
  allergenInfo: {
    commonAllergens: [{
      type: String,
      enum: ['milk', 'eggs', 'fish', 'shellfish', 'nuts', 'peanuts', 'wheat', 'soy', 'sesame'],
      description: '常见过敏原'
    }],
    crossReactivity: [{
      type: String,
      description: '交叉反应过敏原'
    }]
  },
  
  // 数据来源和质量
  dataSource: {
    primary: {
      type: String,
      description: '主要数据来源'
    },
    references: [{
      type: String,
      description: '参考文献'
    }],
    lastVerified: {
      type: Date,
      description: '最后验证时间'
    },
    dataQuality: {
      type: String,
      enum: ['high', 'medium', 'low', 'estimated'],
      description: '数据质量等级'
    }
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
ingredientNutritionSchema.index({ name: 1 });
ingredientNutritionSchema.index({ chineseName: 1 });
ingredientNutritionSchema.index({ category: 1 });
ingredientNutritionSchema.index({ 'nutritionDensity.overall': 1 });
ingredientNutritionSchema.index({ 'nutritionContent.element': 1 });
ingredientNutritionSchema.index({ isActive: 1 });

// 复合索引
ingredientNutritionSchema.index({ category: 1, 'nutritionDensity.overall': 1 });
ingredientNutritionSchema.index({ 'allergenInfo.commonAllergens': 1 });

// 虚拟字段 - 蛋白质质量评分
ingredientNutritionSchema.virtual('proteinQualityScore').get(function() {
  if (!this.aminoAcidProfile.biologicalValue || !this.aminoAcidProfile.proteinDigestibilityScore) {
    return null;
  }
  return (this.aminoAcidProfile.biologicalValue * this.aminoAcidProfile.proteinDigestibilityScore) / 100;
});

// 虚拟字段 - 营养密度总分
ingredientNutritionSchema.virtual('nutritionScore').get(function() {
  const densityScores = {
    'very_high': 5,
    'high': 4,
    'moderate': 3,
    'low': 2,
    'very_low': 1
  };
  
  const overall = densityScores[this.nutritionDensity.overall] || 0;
  const protein = densityScores[this.nutritionDensity.protein] || 0;
  const micronutrients = densityScores[this.nutritionDensity.micronutrients] || 0;
  const antioxidants = densityScores[this.nutritionDensity.antioxidants] || 0;
  
  return (overall + protein + micronutrients + antioxidants) / 4;
});

// 实例方法 - 获取特定营养元素含量
ingredientNutritionSchema.methods.getNutrientAmount = function(elementName) {
  const nutrient = this.nutritionContent.find(n => n.element === elementName);
  return nutrient ? nutrient.amount : 0;
};

// 实例方法 - 计算指定重量的营养含量
ingredientNutritionSchema.methods.calculateNutritionForAmount = function(amount, unit = 'g') {
  const standardAmount = this.servingSize.amount;
  const ratio = amount / standardAmount;
  
  return this.nutritionContent.map(nutrient => ({
    element: nutrient.element,
    amount: nutrient.amount * ratio,
    unit: nutrient.unit,
    dailyValuePercentage: nutrient.dailyValuePercentage * ratio
  }));
};

// 实例方法 - 检查过敏原
ingredientNutritionSchema.methods.hasAllergen = function(allergen) {
  return this.allergenInfo.commonAllergens.includes(allergen) ||
         this.allergenInfo.crossReactivity.includes(allergen);
};

// 静态方法 - 按营养密度查找
ingredientNutritionSchema.statics.findByNutritionDensity = function(density, category = null) {
  const query = { 'nutritionDensity.overall': density, isActive: true };
  if (category) query.category = category;
  return this.find(query);
};

// 静态方法 - 按营养元素含量查找
ingredientNutritionSchema.statics.findRichInNutrient = function(element, minAmount = 0) {
  return this.find({
    'nutritionContent': {
      $elemMatch: {
        element: element,
        amount: { $gte: minAmount }
      }
    },
    isActive: true
  });
};

// 静态方法 - 无过敏原食材
ingredientNutritionSchema.statics.findAllergenFree = function(allergens) {
  return this.find({
    'allergenInfo.commonAllergens': { $nin: allergens },
    'allergenInfo.crossReactivity': { $nin: allergens },
    isActive: true
  });
};

// 创建模型
const IngredientNutrition = mongoose.model('IngredientNutrition', ingredientNutritionSchema);

module.exports = {
  IngredientNutrition,
  INGREDIENT_CATEGORIES,
  FRESHNESS_LEVELS,
  NUTRITION_DENSITY
};