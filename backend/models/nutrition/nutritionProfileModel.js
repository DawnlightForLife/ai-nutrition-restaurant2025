/**
 * 营养档案模型
 * 定义用户的营养档案数据结构
 * @module models/nutrition/nutritionProfileModel
 */
const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const { 
  ETHNIC_DIETARY, 
  RELIGIOUS_DIETARY, 
  DIETARY_TYPES,
  EXERCISE_TYPES,
  TRAINING_INTENSITY,
  ACTIVITY_LEVEL_DETAILS,
  HEALTH_GOALS
} = require('../../constants/dietaryRestrictions');
const { ALL_CUISINES } = require('../../constants/cuisineTypes');

// 食物偏好子模式
const dietaryPreferenceSchema = new Schema({
  // 饮食类型
  dietaryType: {
    type: String,
    enum: Object.values(DIETARY_TYPES),
    default: DIETARY_TYPES.OMNIVORE,
    description: '饮食类型'
  },
  // 菜系偏好（支持多选）
  cuisinePreferences: [{
    type: String,
    enum: Object.values(ALL_CUISINES),
    description: '菜系偏好'
  }],
  // 民族饮食习惯
  ethnicDietary: {
    type: String,
    enum: Object.values(ETHNIC_DIETARY),
    default: undefined,
    description: '民族饮食习惯'
  },
  // 宗教饮食要求
  religiousDietary: {
    type: String,
    enum: Object.values(RELIGIOUS_DIETARY),
    default: undefined,
    description: '宗教饮食要求'
  },
  // 口味偏好（带强度级别）
  tastePreferences: {
    spicy: {
      type: Number,
      min: 0,
      max: 4,
      default: 1,
      description: '辣度偏好(0-4)'
    },
    salty: {
      type: Number,
      min: 0,
      max: 2,
      default: 1,
      description: '咸淡偏好(0-2)'
    },
    sweet: {
      type: Number,
      min: 0,
      max: 2,
      default: 1,
      description: '甜度偏好(0-2)'
    },
    sour: {
      type: Number,
      min: 0,
      max: 2,
      default: 1,
      description: '酸度偏好(0-2)'
    },
    oily: {
      type: Number,
      min: 0,
      max: 2,
      default: 1,
      description: '油腻程度(0-2)'
    }
  },
  // 忌口食材
  taboos: [{
    type: String,
    description: '忌口食材'
  }],
  // 过敏食材
  allergies: [{
    type: String,
    description: '过敏食材'
  }],
  // 特殊饮食需求
  specialRequirements: [{
    type: String,
    description: '特殊饮食需求'
  }]
}, { _id: false });

// 健康状况子模式
const healthStatusSchema = new Schema({
  chronicDiseases: {
    type: [String],
    default: [],
    description: '慢性疾病列表'
  },
  specialConditions: {
    type: [String],
    default: [],
    description: '特殊健康状况'
  },
  allergies: {
    type: [String],
    default: [],
    description: '过敏物列表'
  },
  notes: {
    type: String,
    description: '健康状态备注'
  }
});

const nutritionStatusSchema = new Schema({
  chronicDiseases: {
    type: [String],
    default: [],
    description: '慢性疾病列表',
    sensitive: true
  },
  specialConditions: {
    type: [String],
    default: [],
    description: '特殊健康状况',
    sensitive: true
  },
  allergies: {
    type: [String],
    default: [],
    description: '过敏物列表',
    sensitive: true
  },
  notes: {
    type: String,
    description: '营养状态备注',
    sensitive: true
  },
  // 添加进阶营养指标
  nutritionalBiomarkers: {
    type: Map,
    of: new Schema({
      value: Number,
      unit: String,
      date: Date,
      reference: new Schema({ 
        min: Number, 
        max: Number 
      }, { _id: false })
    }, { _id: false }),
    description: '营养生物标志物数据',
    sensitive: true
  },
  micronutrientStatus: {
    type: Map,
    of: new Schema({
      value: Number,
      unit: String,
      date: Date,
      status: { 
        type: String, 
        enum: ['deficient', 'suboptimal', 'optimal', 'excess']
      }
    }, { _id: false }),
    description: '微量营养素状态评估',
    sensitive: true
  },
  metabolicIndicators: {
    type: new Schema({
      bloodGlucose: {
        fasting: Number,
        postprandial: Number,
        hba1c: Number,
        lastUpdated: Date
      },
      lipidProfile: {
        totalCholesterol: Number,
        hdl: Number,
        ldl: Number,
        triglycerides: Number,
        lastUpdated: Date
      }
    }, { _id: false }),
    description: '代谢健康指标',
    sensitive: true
  },
  bodyComposition: {
    type: new Schema({
      bodyFatPercentage: Number,
      muscleMass: Number,
      visceralFat: Number,
      boneDensity: Number,
      lastUpdated: Date
    }, { _id: false }),
    description: '身体成分分析',
    sensitive: true
  }
}, { _id: false });

// 生活方式子模式
const lifestyleSchema = new Schema({
  smoking: {
    type: Boolean,
    default: false,
    description: '是否吸烟'
  },
  drinking: {
    type: Boolean,
    default: false,
    description: '是否饮酒'
  },
  sleepDuration: {
    type: Number,
    min: 0,
    max: 24,
    default: 7,
    description: '睡眠时长（小时）'
  },
  // 运动相关
  exerciseFrequency: {
    type: String,
    enum: ['none', 'occasional', 'regular', 'intense', 'frequent', 'daily'],
    default: 'occasional',
    description: '运动频率'
  },
  exerciseTypes: [{
    type: String,
    enum: Object.values(EXERCISE_TYPES),
    description: '运动类型'
  }],
  trainingIntensity: {
    type: String,
    enum: Object.values(TRAINING_INTENSITY),
    description: '训练强度'
  },
  weeklyExerciseHours: {
    type: Number,
    min: 0,
    max: 168,
    description: '每周运动时间（小时）'
  },
  preferredExerciseTime: {
    type: String,
    enum: ['morning', 'noon', 'afternoon', 'evening', 'night'],
    description: '偏好运动时段'
  }
}, { _id: false });

// 地区子模式
const regionSchema = new Schema({
  province: {
    type: String,
    default: '',
    description: '省份'
  },
  city: {
    type: String,
    default: '',
    description: '城市'
  }
}, { _id: false });

// 健康目标详细配置子模式
const healthGoalDetailsSchema = new Schema({
  // 血糖控制
  bloodSugarControl: {
    fastingGlucose: {
      type: Number,
      description: '空腹血糖(mmol/L)'
    },
    postprandialGlucose: {
      type: Number,
      description: '餐后2小时血糖(mmol/L)'
    },
    hba1c: {
      type: Number,
      description: '糖化血红蛋白(%)'
    },
    diabetesType: {
      type: String,
      enum: ['type1', 'type2', 'gestational', 'none'],
      description: '糖尿病类型'
    },
    medicationStatus: {
      type: String,
      enum: ['insulin', 'oral', 'diet_only', 'none'],
      description: '用药情况'
    },
    monitoringFrequency: {
      type: String,
      enum: ['daily', 'weekly', 'monthly'],
      description: '监测频率'
    }
  },
  // 血压管理
  bloodPressureControl: {
    systolic: {
      type: Number,
      description: '收缩压(mmHg)'
    },
    diastolic: {
      type: Number,
      description: '舒张压(mmHg)'
    },
    hypertensionGrade: {
      type: String,
      enum: ['normal', 'elevated', 'stage1', 'stage2', 'stage3'],
      description: '高血压分级'
    },
    medications: [{
      type: String,
      description: '降压药物'
    }],
    hasComplication: {
      type: Boolean,
      description: '是否有并发症'
    }
  },
  // 血脂管理
  cholesterolManagement: {
    totalCholesterol: {
      type: Number,
      description: '总胆固醇(mmol/L)'
    },
    triglycerides: {
      type: Number,
      description: '甘油三酯(mmol/L)'
    },
    ldlCholesterol: {
      type: Number,
      description: '低密度脂蛋白(mmol/L)'
    },
    hdlCholesterol: {
      type: Number,
      description: '高密度脂蛋白(mmol/L)'
    },
    onStatins: {
      type: Boolean,
      description: '是否服用他汀类药物'
    }
  },
  // 体重管理
  weightManagement: {
    targetWeight: {
      type: Number,
      description: '目标体重(kg)'
    },
    targetBodyFat: {
      type: Number,
      description: '目标体脂率(%)'
    },
    targetType: {
      type: String,
      enum: ['loss', 'gain', 'maintain', 'recomposition'],
      description: '目标类型'
    },
    targetSpeed: {
      type: String,
      enum: ['conservative', 'moderate', 'aggressive'],
      description: '目标速度'
    },
    targetDate: {
      type: Date,
      description: '目标日期'
    },
    weightHistory: [{
      date: Date,
      weight: Number
    }]
  },
  // 运动营养
  sportsNutrition: {
    sportTypes: [{
      type: String,
      enum: Object.values(EXERCISE_TYPES)
    }],
    trainingPhase: {
      type: String,
      enum: ['off_season', 'pre_season', 'competition', 'recovery'],
      description: '训练阶段'
    },
    competitionDate: {
      type: Date,
      description: '比赛日期'
    },
    supplementUse: [{
      name: String,
      dosage: String,
      timing: String
    }]
  },
  // 特殊生理期
  specialPhysiological: {
    pregnancyWeek: {
      type: Number,
      min: 0,
      max: 42,
      description: '孕周'
    },
    lactationMonth: {
      type: Number,
      description: '哺乳月数'
    },
    menopauseStage: {
      type: String,
      enum: ['pre', 'peri', 'post'],
      description: '更年期阶段'
    },
    fertilityPlanning: {
      type: Boolean,
      description: '备孕计划'
    }
  },
  // 消化健康
  digestiveHealth: {
    symptoms: [{
      type: String,
      enum: ['bloating', 'constipation', 'diarrhea', 'acid_reflux', 'ibs', 'ibd']
    }],
    foodIntolerances: [{
      type: String,
      description: '食物不耐受'
    }],
    hPyloriStatus: {
      type: String,
      enum: ['positive', 'negative', 'unknown'],
      description: '幽门螺杆菌状态'
    },
    gutMicrobiomeTest: {
      tested: Boolean,
      testDate: Date,
      results: String
    }
  },
  // 免疫与抗炎
  immunityBoost: {
    allergens: [{
      type: String,
      description: '过敏原'
    }],
    autoimmuneDiseases: [{
      type: String,
      description: '自体免疫疾病'
    }],
    inflammationMarkers: {
      crp: Number,
      esr: Number
    },
    infectionFrequency: {
      type: String,
      enum: ['rare', 'occasional', 'frequent'],
      description: '感染频率'
    }
  }
}, { _id: false });

// 营养档案主模式
const nutritionProfileSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true,
    description: '所属用户ID'
  },
  profileName: {
    type: String,
    required: true,
    trim: true,
    description: '档案名称'
  },
  gender: {
    type: String,
    enum: ['male', 'female', 'other'],
    default: 'other',
    description: '性别'
  },
  ageGroup: {
    type: String,
    enum: ['under18', '18to25', '26to35', '36to45', '46to55', '56to65', 'above65'],
    default: '26to35',
    description: '年龄段'
  },
  height: {
    type: Number,
    min: 0,
    max: 300,
    default: 170,
    description: '身高（cm）'
  },
  weight: {
    type: Number,
    min: 0,
    max: 500,
    default: 60,
    description: '体重（kg）'
  },
  activityLevel: {
    type: String,
    enum: ['sedentary','light','moderate','active','very_active','professional'],
    default: 'moderate',
    description: '日常活动水平'
  },
  // 活动水平详细说明
  activityLevelDetail: {
    type: String,
    enum: Object.values(ACTIVITY_LEVEL_DETAILS),
    description: '每天活动时长'
  },
  dailyCalorieTarget: {
    type: Number,
    description: '每日热量目标(kcal)'
  },
  bodyFatPercentage: {
    type: Number,
    min: 0,
    max: 100,
    description: '体脂率 (%)'
  },
  macroRatios: {
    type: new Schema({
      protein: { type: Number, min: 0, max: 1 },
      fat:     { type: Number, min: 0, max: 1 },
      carbs:   { type: Number, min: 0, max: 1 }
    }, { _id: false }),
    description: '三大营养素比例，合计应为 1'
  },
  hydrationGoal: {
    type: Number,
    description: '每日目标饮水量 (ml)'
  },
  mealFrequency: {
    type: Number,
    default: 3,
    description: '每日用餐次数'
  },
  preferredMealTimes: [{
    type: String,
    enum: ['breakfast','lunch','dinner','snack'],
    description: '可选用餐时段'
  }],
  fastingWindow: {
    type: new Schema({
      start: { type: String },
      end:   { type: String }
    }, { _id: false }),
    description: '断食时间窗，包含开始和结束时间，格式 HH:mm'
  },
  microTargets: {
    type: Map,
    of: Number,
    description: '微量营养素目标，如 vitaminD: IU, calcium: mg'
  },
  medicalConditions: [{
    type: String,
    description: '影响推荐的慢性病或特殊状况'
  }],
  targetWeight: {
    type: Number,
    description: '目标体重 (kg)'
  },
  cookingTimeBudget: {
    type: Number,
    description: '每餐可接受的准备时间 (分钟)'
  },
  region: {
    type: regionSchema,
    default: {},
    description: '地区信息'
  },
  occupation: {
    type: String,
    enum: ['student', 'officeWorker', 'physicalWorker', 'retired', 'other'],
    default: 'other',
    description: '职业'
  },
  nutritionStatus: {
    type: nutritionStatusSchema,
    description: '营养健康状态'
  },
  dietaryPreferences: {
    type: dietaryPreferenceSchema,
    default: () => ({}),
    description: '饮食偏好'
  },
  lifestyle: {
    type: lifestyleSchema,
    default: () => ({}),
    description: '生活方式'
  },
  nutritionGoals: [{
    type: String,
    enum: Object.values(HEALTH_GOALS),
    description: '营养目标'
  }],
  // 健康目标详细配置
  healthGoalDetails: {
    type: healthGoalDetailsSchema,
    default: () => ({}),
    description: '健康目标详细配置'
  },
  isPrimary: {
    type: Boolean,
    default: false,
    description: '是否为主要档案'
  },
  archived: {
    type: Boolean,
    default: false,
    description: '是否已归档'
  },
  relatedHealthRecords: [{
    type: Schema.Types.ObjectId,
    ref: 'HealthRecord',
    description: '关联的健康记录'
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
