/**
 * 营养元素模型
 * 定义营养元素分类体系和详细信息
 * @module models/nutrition/nutritionElementModel
 */
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// 营养元素分类枚举
const NUTRITION_CATEGORIES = {
  MACRONUTRIENTS: 'macronutrients',      // 宏量营养素
  VITAMINS: 'vitamins',                  // 维生素
  MINERALS: 'minerals',                  // 矿物质
  AMINO_ACIDS: 'amino_acids',            // 氨基酸
  FATTY_ACIDS: 'fatty_acids',            // 脂肪酸
  ANTIOXIDANTS: 'antioxidants',          // 抗氧化剂
  PHYTONUTRIENTS: 'phytonutrients',      // 植物营养素
  PROBIOTICS: 'probiotics',              // 益生菌
  FIBER: 'fiber',                        // 膳食纤维
  WATER: 'water'                         // 水分
};

// 营养元素单位枚举
const NUTRITION_UNITS = {
  GRAM: 'g',
  MILLIGRAM: 'mg',
  MICROGRAM: 'mcg',
  INTERNATIONAL_UNIT: 'IU',
  MILLIEQUIVALENT: 'mEq',
  MILLILITER: 'ml',
  LITER: 'l',
  KCAL: 'kcal',
  KJ: 'kJ',
  PERCENT: '%'
};

// 营养元素重要性等级
const IMPORTANCE_LEVEL = {
  ESSENTIAL: 'essential',        // 必需
  IMPORTANT: 'important',        // 重要
  BENEFICIAL: 'beneficial',      // 有益
  OPTIONAL: 'optional'           // 可选
};

// 营养元素功能分类
const FUNCTION_CATEGORIES = {
  ENERGY_METABOLISM: 'energy_metabolism',           // 能量代谢
  IMMUNE_FUNCTION: 'immune_function',               // 免疫功能
  BONE_HEALTH: 'bone_health',                       // 骨骼健康
  CARDIOVASCULAR: 'cardiovascular',                 // 心血管健康
  COGNITIVE_FUNCTION: 'cognitive_function',         // 认知功能
  MUSCLE_FUNCTION: 'muscle_function',               // 肌肉功能
  SKIN_HEALTH: 'skin_health',                       // 皮肤健康
  DIGESTIVE_HEALTH: 'digestive_health',             // 消化健康
  ANTIOXIDANT_PROTECTION: 'antioxidant_protection', // 抗氧化保护
  HORMONE_REGULATION: 'hormone_regulation',         // 激素调节
  BLOOD_SUGAR_CONTROL: 'blood_sugar_control',       // 血糖控制
  WEIGHT_MANAGEMENT: 'weight_management'            // 体重管理
};

// 年龄特定需求子模式
const ageSpecificNeedsSchema = new Schema({
  infants: { // 0-1岁
    min: { type: Number, description: '最小需求量' },
    max: { type: Number, description: '最大安全量' },
    rda: { type: Number, description: '推荐摄入量' }
  },
  toddlers: { // 1-3岁
    min: { type: Number, description: '最小需求量' },
    max: { type: Number, description: '最大安全量' },
    rda: { type: Number, description: '推荐摄入量' }
  },
  children: { // 4-8岁
    min: { type: Number, description: '最小需求量' },
    max: { type: Number, description: '最大安全量' },
    rda: { type: Number, description: '推荐摄入量' }
  },
  adolescents: { // 9-18岁
    min: { type: Number, description: '最小需求量' },
    max: { type: Number, description: '最大安全量' },
    rda: { type: Number, description: '推荐摄入量' }
  },
  adults: { // 19-50岁
    min: { type: Number, description: '最小需求量' },
    max: { type: Number, description: '最大安全量' },
    rda: { type: Number, description: '推荐摄入量' }
  },
  elderly: { // 51+岁
    min: { type: Number, description: '最小需求量' },
    max: { type: Number, description: '最大安全量' },
    rda: { type: Number, description: '推荐摄入量' }
  }
}, { _id: false });

// 特殊情况需求子模式
const specialConditionNeedsSchema = new Schema({
  pregnancy: {
    trimester1: { type: Number, description: '怀孕前3个月' },
    trimester2: { type: Number, description: '怀孕4-6个月' },
    trimester3: { type: Number, description: '怀孕7-9个月' }
  },
  lactation: {
    months1to6: { type: Number, description: '哺乳前6个月' },
    months7to12: { type: Number, description: '哺乳7-12个月' }
  },
  athletes: {
    endurance: { type: Number, description: '耐力运动员' },
    strength: { type: Number, description: '力量运动员' },
    team_sports: { type: Number, description: '团队运动员' }
  },
  medical_conditions: {
    diabetes: { type: Number, description: '糖尿病患者' },
    hypertension: { type: Number, description: '高血压患者' },
    kidney_disease: { type: Number, description: '肾病患者' },
    liver_disease: { type: Number, description: '肝病患者' },
    cardiovascular: { type: Number, description: '心血管疾病' },
    osteoporosis: { type: Number, description: '骨质疏松' }
  }
}, { _id: false });

// 营养元素主模式
const nutritionElementSchema = new Schema({
  // 基本信息
  name: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    description: '营养元素名称'
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
    description: '科学名称'
  },
  aliases: [{
    type: String,
    description: '别名'
  }],
  
  // 分类信息
  category: {
    type: String,
    enum: Object.values(NUTRITION_CATEGORIES),
    required: true,
    description: '营养元素类别'
  },
  subCategory: {
    type: String,
    description: '子类别'
  },
  
  // 基本属性
  unit: {
    type: String,
    enum: Object.values(NUTRITION_UNITS),
    required: true,
    description: '测量单位'
  },
  importance: {
    type: String,
    enum: Object.values(IMPORTANCE_LEVEL),
    default: IMPORTANCE_LEVEL.BENEFICIAL,
    description: '重要性等级'
  },
  
  // 功能分类
  functions: [{
    type: String,
    enum: Object.values(FUNCTION_CATEGORIES),
    description: '功能分类'
  }],
  
  // 健康益处
  healthBenefits: [{
    type: String,
    description: '健康益处描述'
  }],
  
  // 缺乏症状
  deficiencySymptoms: [{
    type: String,
    description: '缺乏症状'
  }],
  
  // 过量风险
  overdoseRisks: [{
    type: String,
    description: '过量摄入风险'
  }],
  
  // 推荐摄入量 - 按年龄和性别
  recommendedIntake: {
    male: {
      type: ageSpecificNeedsSchema,
      description: '男性推荐摄入量'
    },
    female: {
      type: ageSpecificNeedsSchema,
      description: '女性推荐摄入量'
    }
  },
  
  // 特殊情况需求
  specialConditionNeeds: {
    type: specialConditionNeedsSchema,
    description: '特殊情况营养需求'
  },
  
  // 吸收和代谢
  absorption: {
    enhancers: [{
      element: { type: String, description: '促进吸收的营养素' },
      mechanism: { type: String, description: '促进机制' }
    }],
    inhibitors: [{
      element: { type: String, description: '抑制吸收的营养素' },
      mechanism: { type: String, description: '抑制机制' }
    }],
    optimalTiming: {
      type: String,
      enum: ['with_meal', 'empty_stomach', 'bedtime', 'morning', 'anytime'],
      description: '最佳摄入时间'
    },
    bioavailability: {
      type: Number,
      min: 0,
      max: 100,
      description: '生物利用度百分比'
    }
  },
  
  // 食物来源
  foodSources: [{
    category: {
      type: String,
      enum: ['meat', 'fish', 'dairy', 'eggs', 'vegetables', 'fruits', 'grains', 'nuts', 'legumes', 'oils', 'herbs'],
      description: '食物类别'
    },
    examples: [{
      type: String,
      description: '具体食物示例'
    }],
    contentLevel: {
      type: String,
      enum: ['very_high', 'high', 'moderate', 'low'],
      description: '含量水平'
    }
  }],
  
  // 烹饪影响
  cookingEffects: {
    heatSensitive: {
      type: Boolean,
      default: false,
      description: '是否对热敏感'
    },
    lightSensitive: {
      type: Boolean,
      default: false,
      description: '是否对光敏感'
    },
    oxygenSensitive: {
      type: Boolean,
      default: false,
      description: '是否对氧气敏感'
    },
    waterSoluble: {
      type: Boolean,
      default: false,
      description: '是否水溶性'
    },
    retentionRates: {
      boiling: { type: Number, min: 0, max: 100, description: '水煮保留率%' },
      steaming: { type: Number, min: 0, max: 100, description: '蒸制保留率%' },
      frying: { type: Number, min: 0, max: 100, description: '油炸保留率%' },
      baking: { type: Number, min: 0, max: 100, description: '烘烤保留率%' },
      grilling: { type: Number, min: 0, max: 100, description: '烧烤保留率%' },
      raw: { type: Number, default: 100, description: '生食保留率%' }
    }
  },
  
  // 相互作用
  interactions: {
    synergistic: [{ // 协同作用
      element: { type: String, description: '协同营养素' },
      effect: { type: String, description: '协同效果' }
    }],
    antagonistic: [{ // 拮抗作用
      element: { type: String, description: '拮抗营养素' },
      effect: { type: String, description: '拮抗效果' }
    }],
    medications: [{ // 药物相互作用
      medication: { type: String, description: '药物名称' },
      interaction: { type: String, description: '相互作用描述' },
      severity: { 
        type: String, 
        enum: ['mild', 'moderate', 'severe'],
        description: '严重程度'
      }
    }]
  },
  
  // 科学研究支持
  researchSupport: {
    evidenceLevel: {
      type: String,
      enum: ['high', 'moderate', 'limited', 'insufficient'],
      description: '科学证据等级'
    },
    studyCount: {
      type: Number,
      description: '相关研究数量'
    },
    lastReviewed: {
      type: Date,
      description: '最后审查日期'
    }
  },
  
  // 实验室检测信息
  labTesting: {
    testMethods: [{
      type: String,
      description: '检测方法'
    }],
    normalRanges: {
      serum: {
        min: Number,
        max: Number,
        unit: String
      },
      urine: {
        min: Number,
        max: Number,
        unit: String
      }
    },
    testingFrequency: {
      type: String,
      enum: ['annual', 'biannual', 'quarterly', 'monthly', 'as_needed'],
      description: '建议检测频率'
    }
  },
  
  // 补充剂信息
  supplementation: {
    availableForms: [{
      type: String,
      description: '可用补充剂形式'
    }],
    optimalDosage: {
      therapeutic: { type: Number, description: '治疗剂量' },
      maintenance: { type: Number, description: '维持剂量' },
      maximum: { type: Number, description: '最大安全剂量' }
    },
    contraindications: [{
      type: String,
      description: '禁忌症'
    }]
  },
  
  // 状态标识
  isActive: {
    type: Boolean,
    default: true,
    description: '是否启用'
  },
  lastUpdated: {
    type: Date,
    default: Date.now,
    description: '最后更新时间'
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
nutritionElementSchema.index({ name: 1 });
nutritionElementSchema.index({ category: 1 });
nutritionElementSchema.index({ importance: 1 });
nutritionElementSchema.index({ 'functions': 1 });
nutritionElementSchema.index({ isActive: 1 });

// 虚拟字段 - 完整显示名称
nutritionElementSchema.virtual('displayName').get(function() {
  return `${this.chineseName} (${this.name})`;
});

// 实例方法 - 获取推荐摄入量
nutritionElementSchema.methods.getRecommendedIntake = function(gender, ageGroup, condition = null) {
  const genderData = this.recommendedIntake[gender];
  if (!genderData || !genderData[ageGroup]) return null;
  
  // 如果有特殊情况，返回特殊需求量
  if (condition && this.specialConditionNeeds[condition]) {
    return this.specialConditionNeeds[condition];
  }
  
  return genderData[ageGroup];
};

// 实例方法 - 计算烹饪后保留量
nutritionElementSchema.methods.calculateRetentionAfterCooking = function(cookingMethod, originalAmount) {
  const retentionRate = this.cookingEffects.retentionRates[cookingMethod];
  if (retentionRate === undefined) return originalAmount;
  
  return originalAmount * (retentionRate / 100);
};

// 静态方法 - 按类别查找
nutritionElementSchema.statics.findByCategory = function(category) {
  return this.find({ category, isActive: true });
};

// 静态方法 - 按功能查找
nutritionElementSchema.statics.findByFunction = function(functionCategory) {
  return this.find({ functions: functionCategory, isActive: true });
};

// 创建模型
const NutritionElement = mongoose.model('NutritionElement', nutritionElementSchema);

module.exports = {
  NutritionElement,
  NUTRITION_CATEGORIES,
  NUTRITION_UNITS,
  IMPORTANCE_LEVEL,
  FUNCTION_CATEGORIES
};