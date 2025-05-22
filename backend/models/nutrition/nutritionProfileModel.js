/**
 * 营养档案模型
 * 定义用户的营养档案数据结构
 * @module models/nutrition/nutritionProfileModel
 */
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// 食物偏好子模式
const dietaryPreferenceSchema = new Schema({
  isVegetarian: {
    type: Boolean,
    default: false,
    description: '是否素食'
  },
  tastePreference: [{
    type: String,
    enum: ['light', 'spicy', 'sweet', 'sour', 'bitter'],
    default: ['light'],
    description: '口味偏好'
  }],
  taboos: [{
    type: String,
    description: '忌口食材'
  }],
  cuisine: {
    type: String,
    enum: ['chinese', 'western', 'japanese', 'korean', 'southeastAsian', 'other'],
    default: 'chinese',
    description: '菜系偏好'
  },
  allergies: [{
    type: String,
    description: '过敏食材'
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
  exerciseFrequency: {
    type: String,
    enum: ['none', 'occasional', 'regular', 'intense', 'frequent', 'daily'],
    default: 'occasional',
    description: '运动频率'
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
    enum: ['under18', '18to30', '31to45', '46to60', 'above60'],
    default: '18to30',
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
    enum: ['sedentary','light','moderate','active','very_active'],
    default: 'moderate',
    description: '日常活动量'
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
    enum: [
      'generalHealth', 'weightLoss', 'weightGain', 'muscleBuilding', 'energyBoost',
      'bloodSugarControl', 'bloodPressureControl', 'immunityBoost',
      'boneHealth', 'heartHealth', 'digestiveHealth', 'diseaseManagement'
    ],
    default: ['generalHealth'],
    description: '营养目标'
  }],
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
