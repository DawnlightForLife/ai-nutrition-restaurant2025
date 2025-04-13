const mongoose = require('mongoose');
const crypto = require('crypto');
const modelFactory = require('../modelFactory');

// 用于加密敏感健康数据的密钥和IV
const ENCRYPTION_KEY = process.env.HEALTH_DATA_ENCRYPTION_KEY || 'default_key_please_change_in_production';
const ENCRYPTION_IV = process.env.HEALTH_DATA_ENCRYPTION_IV || 'default_iv_12345';

// 加密函数
const encrypt = (text) => {
  if (!text) return null;
  try {
    const cipher = crypto.createCipheriv('aes-256-cbc', 
      Buffer.from(ENCRYPTION_KEY), 
      Buffer.from(ENCRYPTION_IV.slice(0, 16)));
    let encrypted = cipher.update(text);
    encrypted = Buffer.concat([encrypted, cipher.final()]);
    return encrypted.toString('hex');
  } catch (err) {
    console.error('加密失败:', err);
    return null;
  }
};

// 解密函数
const decrypt = (encryptedText) => {
  if (!encryptedText) return null;
  try {
    const decipher = crypto.createDecipheriv('aes-256-cbc', 
      Buffer.from(ENCRYPTION_KEY), 
      Buffer.from(ENCRYPTION_IV.slice(0, 16)));
    let decrypted = decipher.update(Buffer.from(encryptedText, 'hex'));
    decrypted = Buffer.concat([decrypted, decipher.final()]);
    return decrypted.toString();
  } catch (err) {
    console.error('解密失败:', err);
    return null;
  }
};

const healthDataSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  nutritionProfileId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile'
  },
  // 基本档案信息
  profileInfo: {
    profilename: {
      type: String
    },
    gender: {
      type: String,
      enum: ['male', 'female', 'other']
    },
    ageGroup: {
      type: String,
      enum: ['under_18', '18_30', '31_45', '46_60', 'above_60']
    },
    region: {
      province: String,
      city: String,
      district: String
    },
    occupation: {
      type: String,
      enum: ['student', 'office_worker', 'physical_worker', 'retired', 'other']
    }
  },
  // 基本健康数据
  basicMetrics: {
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
    bmi: {
      type: Number,
      min: 10,
      max: 50
    },
    bloodPressure: {
      systolic: {
        type: Number,
        min: 50,
        max: 250
      },
      diastolic: {
        type: Number,
        min: 30,
        max: 150
      }
    },
    heartRate: {
      type: Number,
      min: 40,
      max: 220
    }
  },
  // 健康状况
  healthStatus: {
    chronicDiseases: [{
      type: String,
      enum: ['hypertension', 'diabetes', 'gout', 'heart_disease', 'none']
    }],
    specialConditions: [{
      type: String,
      enum: ['pregnancy', 'lactation', 'menopause', 'none']
    }]
  },
  // 饮食偏好
  dietaryPreferences: {
    isVegetarian: {
      type: Boolean,
      default: false
    },
    tastePreference: [{
      type: String,
      enum: ['light', 'spicy', 'sour', 'sweet', 'salty']
    }],
    taboos: [{
      type: String
    }],
    cuisine: {
      type: String,
      enum: ['chinese', 'western', 'japanese', 'korean', 'other'],
      default: 'chinese'
    },
    allergies: [{
      type: String
    }]
  },
  // 生活方式
  lifestyle: {
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
      max: 24
    },
    exerciseFrequency: {
      type: String,
      enum: ['none', 'occasional', 'regular', 'frequent', 'daily']
    }
  },
  // 营养目标
  nutritionGoals: [{
    type: String
  }],
  // 血液指标
  bloodMetrics: {
    cholesterol: {
      total: String,
      hdl: String,
      ldl: String,
      triglycerides: String
    },
    glucose: {
      fasting: String,
      afterMeal: String,
      hba1c: String
    },
    liver: {
      alt: Number,
      ast: Number,
      alp: Number
    },
    kidney: {
      creatinine: Number,
      urea: Number
    },
    electrolytes: {
      sodium: Number,
      potassium: Number,
      calcium: Number,
      magnesium: Number
    },
    bloodCount: {
      wbc: Number,
      rbc: Number,
      hemoglobin: Number,
      platelets: Number
    }
  },
  // 医疗报告
  medicalReport: {
    ocrImageUrl: String,
    ocrProcessingStatus: {
      type: String,
      enum: ['pending', 'processing', 'completed', 'failed'],
      default: 'pending'
    },
    ocrRawText: String,
    reportUrl: String,
    reportDate: Date,
    hospitalName: String,
    diagnosis: String,
    aiAnalysis: {
      type: Map,
      of: mongoose.Schema.Types.Mixed,
      default: {}
    }
  },
  // 健康建议
  healthAdvice: {
    nutritionSuggestions: [String],
    lifestyleChanges: [String],
    exercisePlan: String,
    dietRestrictions: [String],
    recommendedSupplements: [String],
    monitoringPlan: String
  },
  // 分析历史
  analysisHistory: [{
    analyzedAt: {
      type: Date,
      default: Date.now
    },
    analyzerType: {
      type: String,
      enum: ['ai', 'human']
    },
    analyzerId: String,
    results: String,
    recommendations: String
  }],
  // 隐私级别
  privacyLevel: {
    type: String,
    enum: ['high', 'medium', 'low'],
    default: 'high'
  },
  // 同步状态
  syncedToProfile: {
    type: Boolean,
    default: false
  },
  // 同步历史
  syncHistory: [{
    syncedAt: {
      type: Date,
      default: Date.now
    },
    profileId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'NutritionProfile'
    },
    syncType: {
      type: String,
      enum: ['manual', 'automatic', 'migration', 'legacy']
    },
    syncStatus: {
      type: String,
      enum: ['success', 'failed']
    },
    syncDetails: String
  }],
  // 数据来源
  dataSource: {
    sourceType: {
      type: String,
      enum: ['manual', 'import', 'device'],
      default: 'manual'
    },
    deviceInfo: String,
    appVersion: String,
    importFile: String
  },
  // 验证信息
  validation: {
    isValidated: {
      type: Boolean,
      default: false
    },
    validatedBy: {
      type: String,
      enum: ['system', 'professional', 'user', '']
    },
    validationDate: Date,
    validationMethod: String
  }
}, { 
  timestamps: true,
  versionKey: false,
  toJSON: { virtuals: true },
  toObject: { virtuals: true } 
});

// 数据敏感度映射（作为静态属性，不是schema的一部分）
healthDataSchema.statics.sensitivityMap = {
  'profileInfo.profilename': 3, // 低度敏感
  'profileInfo.gender': 2, // 中度敏感
  'profileInfo.ageGroup': 2, // 中度敏感
  'profileInfo.region': 3, // 低度敏感
  'profileInfo.occupation': 3, // 低度敏感
  'basicMetrics.height': 2, // 中度敏感
  'basicMetrics.weight': 2, // 中度敏感
  'basicMetrics.bmi': 2, // 中度敏感
  'basicMetrics.bloodPressure': 1, // 高度敏感
  'basicMetrics.heartRate': 1, // 高度敏感
  'healthStatus.chronicDiseases': 1, // 高度敏感
  'healthStatus.specialConditions': 1, // 高度敏感
  'dietaryPreferences.isVegetarian': 3, // 低度敏感
  'dietaryPreferences.tastePreference': 3, // 低度敏感
  'dietaryPreferences.taboos': 2, // 中度敏感
  'dietaryPreferences.cuisine': 3, // 低度敏感
  'dietaryPreferences.allergies': 1, // 高度敏感
  'lifestyle.smoking': 2, // 中度敏感
  'lifestyle.drinking': 2, // 中度敏感
  'lifestyle.sleepDuration': 3, // 低度敏感
  'lifestyle.exerciseFrequency': 3, // 低度敏感
  'nutritionGoals': 3, // 低度敏感
  'bloodMetrics': 1, // 高度敏感
  'medicalReport': 1, // 高度敏感
};

// 创建模型实例的同步到营养档案方法
healthDataSchema.methods.syncToNutritionProfile = async function() {
  try {
    const NutritionProfile = mongoose.model('NutritionProfile');
    
    if (!this.nutritionProfileId) {
      throw new Error('没有关联的营养档案ID');
    }
    
    // 查找关联的营养档案
    const profile = await NutritionProfile.findById(this.nutritionProfileId);
    if (!profile) {
      throw new Error('未找到营养档案');
    }
    
    // 更新营养档案的相关字段
    if (this.profileInfo.gender) {
      profile.gender = this.profileInfo.gender;
    }
    
    if (this.basicMetrics.height) {
      profile.height = this.basicMetrics.height;
    }
    
    if (this.basicMetrics.weight) {
      profile.weight = this.basicMetrics.weight;
    }
    
    if (this.profileInfo.region) {
      profile.region = this.profileInfo.region;
    }
    
    if (this.profileInfo.occupation) {
      profile.occupation = this.profileInfo.occupation;
    }
    
    // 更新健康状况
    if (this.healthStatus) {
      profile.healthStatus = {
        chronicDiseases: this.healthStatus.chronicDiseases,
        specialConditions: this.healthStatus.specialConditions
      };
    }
    
    // 更新饮食偏好
    if (this.dietaryPreferences) {
      profile.dietaryPreferences = {
        isVegetarian: this.dietaryPreferences.isVegetarian,
        tastePreference: this.dietaryPreferences.tastePreference,
        taboos: this.dietaryPreferences.taboos,
        cuisine: this.dietaryPreferences.cuisine,
        allergies: this.dietaryPreferences.allergies
      };
    }
    
    // 更新生活方式
    if (this.lifestyle) {
      profile.lifestyle = {
        smoking: this.lifestyle.smoking,
        drinking: this.lifestyle.drinking,
        sleepDuration: this.lifestyle.sleepDuration,
        exerciseFrequency: this.lifestyle.exerciseFrequency
      };
    }
    
    // 更新健康指标
    if (this.basicMetrics) {
      if (!profile.healthMetrics) {
        profile.healthMetrics = {};
      }
      
      if (this.basicMetrics.bmi) {
        profile.healthMetrics.bmi = this.basicMetrics.bmi;
      }
      
      if (this.basicMetrics.bloodPressure) {
        profile.healthMetrics.bloodPressure = {
          systolic: this.basicMetrics.bloodPressure.systolic,
          diastolic: this.basicMetrics.bloodPressure.diastolic,
          measuredAt: new Date()
        };
      }
      
      if (this.bloodMetrics && this.bloodMetrics.glucose && this.bloodMetrics.glucose.fasting) {
        profile.healthMetrics.bloodGlucose = {
          value: parseFloat(this.bloodMetrics.glucose.fasting),
          measuredAt: new Date()
        };
      }
    }
    
    // 更新营养目标
    if (this.nutritionGoals && this.nutritionGoals.length > 0) {
      profile.nutritionGoals = this.nutritionGoals;
    }
    
    // 记录关联
    if (!profile.relatedHealthData) {
      profile.relatedHealthData = [];
    }
    
    if (!profile.relatedHealthData.includes(this._id)) {
      profile.relatedHealthData.push(this._id);
    }
    
    // 保存更新后的档案
    await profile.save();
    
    // 添加同步历史记录
    this.syncHistory = this.syncHistory || [];
    this.syncHistory.push({
      syncedAt: new Date(),
      profileId: profile._id,
      syncType: 'automatic',
      syncStatus: 'success',
      syncDetails: '已同步健康数据到营养档案'
    });
    
    // 标记为已同步
    this.syncedToProfile = true;
    await this.save();
    
    console.log(`健康数据已成功同步到营养档案(ID: ${this.nutritionProfileId})`);
    return true;
  } catch (error) {
    console.error('同步健康数据到营养档案时出错:', error);
    
    // 记录失败的同步尝试
    this.syncHistory = this.syncHistory || [];
    this.syncHistory.push({
      syncedAt: new Date(),
      profileId: this.nutritionProfileId,
      syncType: 'automatic',
      syncStatus: 'failed',
      syncDetails: `同步失败: ${error.message}`
    });
    
    await this.save();
    return false;
  }
};

// 生成健康建议方法
healthDataSchema.methods.analyzeAndGenerateAdvice = async function() {
  try {
    // 分析健康指标并生成健康建议
    const suggestions = [];
    const lifestyleChanges = [];
    
    // 基于BMI的建议
    if (this.basicMetrics && this.basicMetrics.bmi) {
      const bmi = this.basicMetrics.bmi;
      if (bmi < 18.5) {
        suggestions.push('增加蛋白质摄入，如鸡胸肉、鱼、豆类等');
        suggestions.push('适当增加健康脂肪，如坚果、橄榄油等');
        lifestyleChanges.push('增加阻力训练，帮助肌肉生长');
      } else if (bmi >= 25 && bmi < 30) {
        suggestions.push('控制碳水化合物摄入，减少精制糖和白面');
        suggestions.push('增加蔬菜水果摄入');
        lifestyleChanges.push('每周至少进行150分钟中等强度有氧运动');
      } else if (bmi >= 30) {
        suggestions.push('建议咨询营养师制定个性化的减重饮食计划');
        suggestions.push('严格控制热量摄入，每天减少500-1000卡路里');
        lifestyleChanges.push('增加日常活动量，考虑每天步行10000步');
        lifestyleChanges.push('每周进行3-5次有氧运动，每次30-60分钟');
      }
    }
    
    // 基于血压的建议
    if (this.basicMetrics && this.basicMetrics.bloodPressure) {
      const systolic = this.basicMetrics.bloodPressure.systolic;
      const diastolic = this.basicMetrics.bloodPressure.diastolic;
      
      if (systolic >= 140 || diastolic >= 90) {
        suggestions.push('减少钠盐摄入，每日不超过5克');
        suggestions.push('采用DASH饮食法，增加钾、镁、钙的摄入');
        suggestions.push('增加全谷物、蔬菜和水果的摄入');
        lifestyleChanges.push('避免过度饮酒，戒烟');
        lifestyleChanges.push('管理压力，尝试冥想或瑜伽');
      }
    }
    
    // 基于慢性疾病的建议
    if (this.healthStatus && this.healthStatus.chronicDiseases) {
      if (this.healthStatus.chronicDiseases.includes('diabetes')) {
        suggestions.push('选择低升糖指数的食物，如全谷物、豆类');
        suggestions.push('控制碳水化合物的摄入量和分配');
        suggestions.push('增加高纤维食物摄入');
        lifestyleChanges.push('每餐后进行短时间步行');
      }
      
      if (this.healthStatus.chronicDiseases.includes('hypertension')) {
        suggestions.push('增加富含钾的食物，如香蕉、土豆和菠菜');
        suggestions.push('限制咖啡因摄入');
      }
      
      if (this.healthStatus.chronicDiseases.includes('gout')) {
        suggestions.push('避免高嘌呤食物，如动物内脏、海鲜和啤酒');
        suggestions.push('限制红肉摄入');
        suggestions.push('多喝水，每天保持2000-3000毫升水分摄入');
      }
    }
    
    // 生成运动计划
    let exercisePlan = '';
    if (this.lifestyle && this.lifestyle.exerciseFrequency) {
      switch (this.lifestyle.exerciseFrequency) {
        case 'none':
          exercisePlan = '开始进行每天10-15分钟的轻度活动，如步行；逐渐增加到30分钟';
          break;
        case 'occasional':
          exercisePlan = '每周进行3-4次30分钟的中等强度活动，如快走、骑自行车或游泳';
          break;
        case 'regular':
          exercisePlan = '维持每周3-4次有氧运动，添加每周2天的力量训练';
          break;
        case 'frequent':
        case 'daily':
          exercisePlan = '保持当前的活动水平，但确保运动的多样性，包括有氧、力量和柔韧性训练';
          break;
      }
    }
    
    // 生成健康监测计划
    let monitoringPlan = '';
    if (this.healthStatus && this.healthStatus.chronicDiseases && 
        this.healthStatus.chronicDiseases.some(d => d !== 'none')) {
      monitoringPlan = '每月测量一次基本健康指标，如体重、血压；每3-6个月进行一次完整的健康检查';
    } else {
      monitoringPlan = '每3个月监测一次体重和BMI；每6个月测量一次血压；每年进行一次全面体检';
    }
    
    // 更新健康建议
    const healthAdvice = {
      nutritionSuggestions: suggestions,
      lifestyleChanges: lifestyleChanges,
      exercisePlan: exercisePlan,
      dietRestrictions: [],
      recommendedSupplements: [],
      monitoringPlan: monitoringPlan
    };
    
    // 添加分析历史记录
    this.analysisHistory = this.analysisHistory || [];
    this.analysisHistory.push({
      analyzedAt: new Date(),
      analyzerType: 'ai',
      analyzerId: 'system',
      results: '基于健康数据的自动分析',
      recommendations: suggestions.join('; ')
    });
    
    // 更新健康建议字段
    this.healthAdvice = healthAdvice;
    await this.save();
    
    return healthAdvice;
  } catch (error) {
    console.error('生成健康建议时出错:', error);
    return null;
  }
};

// 创建模型
const HealthData = modelFactory.model('HealthData', healthDataSchema, 'health_data');

module.exports = HealthData;