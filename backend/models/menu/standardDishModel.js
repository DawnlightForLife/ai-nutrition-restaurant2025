const mongoose = require('mongoose');
const { MAIN_CATEGORIES, MEAL_TYPES, NUTRITION_TAGS } = require('../../constants/menuCategories');

// 营养成分子模式
const nutritionSchema = new mongoose.Schema({
  calories: {
    type: Number,
    required: true,
    min: 0,
    description: '热量(千卡)'
  },
  protein: {
    type: Number,
    required: true,
    min: 0,
    description: '蛋白质(克)'
  },
  carbohydrates: {
    type: Number,
    required: true,
    min: 0,
    description: '碳水化合物(克)'
  },
  fat: {
    type: Number,
    required: true,
    min: 0,
    description: '脂肪(克)'
  },
  fiber: {
    type: Number,
    min: 0,
    description: '膳食纤维(克)'
  },
  sugar: {
    type: Number,
    min: 0,
    description: '糖分(克)'
  },
  sodium: {
    type: Number,
    min: 0,
    description: '钠(毫克)'
  },
  cholesterol: {
    type: Number,
    min: 0,
    description: '胆固醇(毫克)'
  },
  // 维生素
  vitamins: {
    vitaminA: { type: Number, description: '维生素A(微克)' },
    vitaminC: { type: Number, description: '维生素C(毫克)' },
    vitaminD: { type: Number, description: '维生素D(微克)' },
    vitaminE: { type: Number, description: '维生素E(毫克)' },
    vitaminB1: { type: Number, description: '维生素B1(毫克)' },
    vitaminB2: { type: Number, description: '维生素B2(毫克)' },
    vitaminB6: { type: Number, description: '维生素B6(毫克)' },
    vitaminB12: { type: Number, description: '维生素B12(微克)' }
  },
  // 矿物质
  minerals: {
    calcium: { type: Number, description: '钙(毫克)' },
    iron: { type: Number, description: '铁(毫克)' },
    zinc: { type: Number, description: '锌(毫克)' },
    magnesium: { type: Number, description: '镁(毫克)' },
    potassium: { type: Number, description: '钾(毫克)' }
  }
}, { _id: false });

// 标准菜品模型
const standardDishSchema = new mongoose.Schema({
  // 基本信息
  dishCode: {
    type: String,
    required: true,
    unique: true,
    description: '菜品编码（如: YQ-FIT-001）'
  },
  dishName: {
    type: String,
    required: true,
    description: '菜品名称'
  },
  description: {
    type: String,
    required: true,
    description: '菜品描述'
  },
  
  // 分类信息
  category: {
    main: {
      type: String,
      required: true,
      enum: Object.keys(MAIN_CATEGORIES).map(k => MAIN_CATEGORIES[k].value),
      description: '主分类'
    },
    sub: {
      type: String,
      required: true,
      description: '子分类'
    }
  },
  mealType: {
    type: String,
    required: true,
    enum: Object.keys(MEAL_TYPES).map(k => MEAL_TYPES[k].value),
    description: '餐次类型'
  },
  
  // 营养信息
  nutrition: {
    type: nutritionSchema,
    required: true,
    description: '营养成分'
  },
  nutritionTags: [{
    type: String,
    enum: Object.keys(NUTRITION_TAGS),
    description: '营养标签'
  }],
  
  // 原料信息
  ingredients: [{
    name: {
      type: String,
      required: true,
      description: '原料名称'
    },
    amount: {
      type: Number,
      required: true,
      description: '用量'
    },
    unit: {
      type: String,
      required: true,
      description: '单位'
    },
    allergen: {
      type: Boolean,
      default: false,
      description: '是否为过敏原'
    }
  }],
  
  // 过敏原信息
  allergens: [{
    type: String,
    enum: ['gluten', 'dairy', 'eggs', 'soy', 'peanuts', 'tree_nuts', 'fish', 'shellfish', 'sesame'],
    description: '过敏原'
  }],
  
  // 制作信息
  preparation: {
    prepTime: {
      type: Number,
      required: true,
      description: '准备时间(分钟)'
    },
    cookTime: {
      type: Number,
      required: true,
      description: '烹饪时间(分钟)'
    },
    difficulty: {
      type: String,
      enum: ['easy', 'medium', 'hard'],
      default: 'medium',
      description: '制作难度'
    },
    instructions: [{
      step: {
        type: Number,
        required: true,
        description: '步骤号'
      },
      description: {
        type: String,
        required: true,
        description: '步骤描述'
      }
    }]
  },
  
  // 定价信息
  pricing: {
    basePrice: {
      type: Number,
      required: true,
      min: 0,
      description: '基础价格'
    },
    cost: {
      type: Number,
      required: true,
      min: 0,
      description: '成本'
    },
    recommendedPrice: {
      type: Number,
      required: true,
      min: 0,
      description: '建议零售价'
    }
  },
  
  // 适用人群
  targetAudience: [{
    type: String,
    enum: ['fitness_enthusiast', 'pregnant', 'postpartum', 'student', 'office_worker', 'elderly', 'athlete', 'weight_loss', 'diabetes', 'hypertension'],
    description: '适用人群'
  }],
  
  // 媒体资源
  media: {
    mainImage: {
      type: String,
      required: true,
      description: '主图URL'
    },
    images: [{
      type: String,
      description: '其他图片URL'
    }],
    nutritionFactsImage: {
      type: String,
      description: '营养成分表图片'
    }
  },
  
  // 状态信息
  status: {
    isActive: {
      type: Boolean,
      default: true,
      description: '是否上架'
    },
    isRecommended: {
      type: Boolean,
      default: false,
      description: '是否推荐'
    },
    isSeasonal: {
      type: Boolean,
      default: false,
      description: '是否季节性'
    },
    seasonalPeriod: {
      start: {
        type: String,
        description: '季节开始月份'
      },
      end: {
        type: String,
        description: '季节结束月份'
      }
    }
  },
  
  // SEO信息
  seo: {
    keywords: [{
      type: String,
      description: 'SEO关键词'
    }],
    metaDescription: {
      type: String,
      description: 'META描述'
    }
  },
  
  // 评分统计
  ratings: {
    averageRating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
      description: '平均评分'
    },
    totalRatings: {
      type: Number,
      default: 0,
      description: '评分总数'
    },
    nutritionScore: {
      type: Number,
      min: 0,
      max: 100,
      description: '营养评分'
    }
  },
  
  // 供应链信息
  supply: {
    supplier: {
      type: String,
      description: '主要供应商'
    },
    shelfLife: {
      type: Number,
      description: '保质期(天)'
    },
    storageConditions: {
      type: String,
      description: '储存条件'
    }
  },
  
  // 创建者信息
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '创建者'
  },
  lastUpdatedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    description: '最后更新者'
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 索引
standardDishSchema.index({ dishCode: 1 });
standardDishSchema.index({ dishName: 'text' });
standardDishSchema.index({ 'category.main': 1, 'category.sub': 1 });
standardDishSchema.index({ mealType: 1 });
standardDishSchema.index({ 'status.isActive': 1 });
standardDishSchema.index({ 'ratings.averageRating': -1 });
standardDishSchema.index({ targetAudience: 1 });

// 虚拟字段
standardDishSchema.virtual('totalTime').get(function() {
  return this.preparation.prepTime + this.preparation.cookTime;
});

standardDishSchema.virtual('profitMargin').get(function() {
  if (this.pricing.cost === 0) return 0;
  return ((this.pricing.basePrice - this.pricing.cost) / this.pricing.cost * 100).toFixed(2);
});

// 实例方法
standardDishSchema.methods.calculateNutritionScore = function() {
  const nutrition = this.nutrition;
  let score = 100;
  
  // 基于营养均衡性计算分数
  // 蛋白质占比理想范围: 15-25%
  const proteinCalories = nutrition.protein * 4;
  const totalCalories = nutrition.calories;
  const proteinRatio = proteinCalories / totalCalories;
  
  if (proteinRatio < 0.15 || proteinRatio > 0.25) {
    score -= 10;
  }
  
  // 脂肪占比理想范围: 20-35%
  const fatCalories = nutrition.fat * 9;
  const fatRatio = fatCalories / totalCalories;
  
  if (fatRatio < 0.20 || fatRatio > 0.35) {
    score -= 10;
  }
  
  // 钠含量评分
  if (nutrition.sodium > 800) {
    score -= 15;
  }
  
  // 纤维含量加分
  if (nutrition.fiber >= 5) {
    score += 5;
  }
  
  this.ratings.nutritionScore = Math.max(0, Math.min(100, score));
  return this.ratings.nutritionScore;
};

// 静态方法
standardDishSchema.statics.findByCategory = function(mainCategory, subCategory) {
  const query = { 'category.main': mainCategory };
  if (subCategory) {
    query['category.sub'] = subCategory;
  }
  return this.find(query).where('status.isActive').equals(true);
};

standardDishSchema.statics.findForTargetAudience = function(audience) {
  return this.find({
    targetAudience: audience,
    'status.isActive': true
  }).sort('-ratings.averageRating');
};

const StandardDish = mongoose.model('StandardDish', standardDishSchema);

module.exports = StandardDish;