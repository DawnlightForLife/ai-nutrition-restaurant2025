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
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  userId: {
    type: String
  },
  nutrition_profile_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile'
  },
  nutritionProfileId: {
    type: String
  },
  // 基本档案信息
  profile_info: {
    profilename: {
      type: String
    },
    gender: {
      type: String,
      enum: ['male', 'female', 'other']
    },
    age_group: {
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
  basic_metrics: {
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
    blood_pressure: {
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
    heart_rate: {
      type: Number,
      min: 40,
      max: 220
    }
  },
  // 健康状况
  health_status: {
    chronic_diseases: [{
      type: String,
      enum: ['hypertension', 'diabetes', 'gout', 'heart_disease', 'none']
    }],
    special_conditions: [{
      type: String,
      enum: ['pregnancy', 'lactation', 'menopause', 'none']
    }]
  },
  // 饮食偏好
  dietary_preferences: {
    is_vegetarian: {
      type: Boolean,
      default: false
    },
    taste_preference: [{
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
    sleep_duration: {
      type: Number,
      min: 0,
      max: 24
    },
    exercise_frequency: {
      type: String,
      enum: ['none', 'occasional', 'regular', 'frequent', 'daily']
    }
  },
  // 营养目标
  nutrition_goals: [{
    type: String
  }],
  // 血液指标
  blood_metrics: {
    cholesterol: {
      total: String,
      hdl: String,
      ldl: String,
      triglycerides: String
    },
    glucose: {
      fasting: String,
      after_meal: String,
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
    blood_count: {
      wbc: Number,
      rbc: Number,
      hemoglobin: Number,
      platelets: Number
    }
  },
  // 医疗报告
  medical_report: {
    ocr_image_url: String,
    ocr_processing_status: {
      type: String,
      enum: ['pending', 'processing', 'completed', 'failed'],
      default: 'pending'
    },
    ocr_raw_text: String,
    report_date: Date,
    hospital_name: String,
    diagnosis: String
  },
  // 健康建议
  health_advice: {
    nutrition_suggestions: [String],
    lifestyle_changes: [String],
    exercise_plan: String,
    diet_restrictions: [String],
    recommended_supplements: [String],
    monitoring_plan: String
  },
  // 分析历史
  analysis_history: [{
    analyzed_at: {
      type: Date,
      default: Date.now
    },
    analyzer_type: {
      type: String,
      enum: ['ai', 'human']
    },
    analyzer_id: String,
    results: String,
    recommendations: String
  }],
  // 隐私级别
  privacy_level: {
    type: String,
    enum: ['high', 'medium', 'low'],
    default: 'high'
  },
  // 同步状态
  synced_to_profile: {
    type: Boolean,
    default: false
  },
  // 同步历史
  sync_history: [{
    synced_at: {
      type: Date,
      default: Date.now
    },
    profile_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'NutritionProfile'
    },
    sync_type: {
      type: String,
      enum: ['manual', 'automatic', 'migration', 'legacy']
    },
    sync_status: {
      type: String,
      enum: ['success', 'failed']
    },
    sync_details: String
  }],
  // 数据来源
  data_source: {
    source_type: {
      type: String,
      enum: ['manual', 'import', 'device'],
      default: 'manual'
    },
    device_info: String,
    app_version: String,
    import_file: String
  },
  // 验证信息
  validation: {
    is_validated: {
      type: Boolean,
      default: false
    },
    validated_by: {
      type: String,
      enum: ['system', 'professional', 'user', '']
    },
    validation_date: Date,
    validation_method: String
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
}, { 
  versionKey: false,
  toJSON: { virtuals: true },
  toObject: { virtuals: true } 
});

// 数据敏感度映射（作为静态属性，不是schema的一部分）
healthDataSchema.statics.sensitivityMap = {
  'profile_info.profilename': 3, // 低度敏感
  'profile_info.gender': 2, // 中度敏感
  'profile_info.age_group': 2, // 中度敏感
  'profile_info.region': 3, // 低度敏感
  'profile_info.occupation': 3, // 低度敏感
  'basic_metrics.height': 2, // 中度敏感
  'basic_metrics.weight': 2, // 中度敏感
  'basic_metrics.bmi': 2, // 中度敏感
  'basic_metrics.blood_pressure': 1, // 高度敏感
  'basic_metrics.heart_rate': 1, // 高度敏感
  'health_status.chronic_diseases': 1, // 高度敏感
  'health_status.special_conditions': 1, // 高度敏感
  'dietary_preferences.is_vegetarian': 3, // 低度敏感
  'dietary_preferences.taste_preference': 3, // 低度敏感
  'dietary_preferences.taboos': 2, // 中度敏感
  'dietary_preferences.cuisine': 3, // 低度敏感
  'dietary_preferences.allergies': 1, // 高度敏感
  'lifestyle.smoking': 2, // 中度敏感
  'lifestyle.drinking': 2, // 中度敏感
  'lifestyle.sleep_duration': 3, // 低度敏感
  'lifestyle.exercise_frequency': 3, // 低度敏感
  'nutrition_goals': 3, // 低度敏感
  'blood_metrics': 1, // 高度敏感
  'medical_report': 1, // 高度敏感
};

// 创建模型实例的同步到营养档案方法
healthDataSchema.methods.syncToNutritionProfile = async function() {
  try {
    const NutritionProfile = mongoose.model('NutritionProfile');
    
    if (!this.nutrition_profile_id) {
      throw new Error('没有关联的营养档案ID');
    }
    
    // 查找关联的营养档案
    const profile = await NutritionProfile.findById(this.nutrition_profile_id);
    if (!profile) {
      throw new Error('未找到营养档案');
    }
    
    // 更新营养档案的相关字段
    if (this.profile_info.gender) {
      profile.gender = this.profile_info.gender;
    }
    
    if (this.basic_metrics.height) {
      profile.height = this.basic_metrics.height;
    }
    
    if (this.basic_metrics.weight) {
      profile.weight = this.basic_metrics.weight;
    }
    
    if (this.profile_info.region) {
      profile.region = this.profile_info.region;
    }
    
    if (this.profile_info.occupation) {
      profile.occupation = this.profile_info.occupation;
    }
    
    // 更新健康状况
    if (this.health_status) {
      profile.healthStatus = {
        chronicDiseases: this.health_status.chronic_diseases,
        specialConditions: this.health_status.special_conditions
      };
    }
    
    // 更新饮食偏好
    if (this.dietary_preferences) {
      profile.dietaryPreferences = {
        isVegetarian: this.dietary_preferences.is_vegetarian,
        tastePreference: this.dietary_preferences.taste_preference,
        taboos: this.dietary_preferences.taboos,
        cuisine: this.dietary_preferences.cuisine,
        allergies: this.dietary_preferences.allergies
      };
    }
    
    // 更新生活方式
    if (this.lifestyle) {
      profile.lifestyle = {
        smoking: this.lifestyle.smoking,
        drinking: this.lifestyle.drinking,
        sleepDuration: this.lifestyle.sleep_duration,
        exerciseFrequency: this.lifestyle.exercise_frequency
      };
    }
    
    // 更新健康指标
    if (this.basic_metrics) {
      if (!profile.health_metrics) {
        profile.health_metrics = {};
      }
      
      if (this.basic_metrics.bmi) {
        profile.health_metrics.bmi = this.basic_metrics.bmi;
      }
      
      if (this.basic_metrics.blood_pressure) {
        profile.health_metrics.blood_pressure = {
          systolic: this.basic_metrics.blood_pressure.systolic,
          diastolic: this.basic_metrics.blood_pressure.diastolic,
          measured_at: new Date()
        };
      }
      
      if (this.blood_metrics && this.blood_metrics.glucose && this.blood_metrics.glucose.fasting) {
        profile.health_metrics.blood_glucose = {
          value: parseFloat(this.blood_metrics.glucose.fasting),
          measured_at: new Date()
        };
      }
    }
    
    // 更新营养目标
    if (this.nutrition_goals && this.nutrition_goals.length > 0) {
      profile.nutritionGoals = this.nutrition_goals;
    }
    
    // 记录关联
    if (!profile.related_health_data) {
      profile.related_health_data = [];
    }
    
    if (!profile.related_health_data.includes(this._id)) {
      profile.related_health_data.push(this._id);
    }
    
    // 保存更新后的档案
    await profile.save();
    
    // 添加同步历史记录
    this.sync_history = this.sync_history || [];
    this.sync_history.push({
      synced_at: new Date(),
      profile_id: profile._id,
      sync_type: 'automatic',
      sync_status: 'success',
      sync_details: '已同步健康数据到营养档案'
    });
    
    // 标记为已同步
    this.synced_to_profile = true;
    await this.save();
    
    console.log(`健康数据已成功同步到营养档案(ID: ${this.nutrition_profile_id})`);
    return true;
  } catch (error) {
    console.error('同步健康数据到营养档案时出错:', error);
    
    // 记录失败的同步尝试
    this.sync_history = this.sync_history || [];
    this.sync_history.push({
      synced_at: new Date(),
      profile_id: this.nutrition_profile_id,
      sync_type: 'automatic',
      sync_status: 'failed',
      sync_details: `同步失败: ${error.message}`
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
    if (this.basic_metrics && this.basic_metrics.bmi) {
      const bmi = this.basic_metrics.bmi;
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
    if (this.basic_metrics && this.basic_metrics.blood_pressure) {
      const systolic = this.basic_metrics.blood_pressure.systolic;
      const diastolic = this.basic_metrics.blood_pressure.diastolic;
      
      if (systolic >= 140 || diastolic >= 90) {
        suggestions.push('减少钠盐摄入，每日不超过5克');
        suggestions.push('采用DASH饮食法，增加钾、镁、钙的摄入');
        suggestions.push('增加全谷物、蔬菜和水果的摄入');
        lifestyleChanges.push('避免过度饮酒，戒烟');
        lifestyleChanges.push('管理压力，尝试冥想或瑜伽');
      }
    }
    
    // 基于慢性疾病的建议
    if (this.health_status && this.health_status.chronic_diseases) {
      if (this.health_status.chronic_diseases.includes('diabetes')) {
        suggestions.push('选择低升糖指数的食物，如全谷物、豆类');
        suggestions.push('控制碳水化合物的摄入量和分配');
        suggestions.push('增加高纤维食物摄入');
        lifestyleChanges.push('每餐后进行短时间步行');
      }
      
      if (this.health_status.chronic_diseases.includes('hypertension')) {
        suggestions.push('增加富含钾的食物，如香蕉、土豆和菠菜');
        suggestions.push('限制咖啡因摄入');
      }
      
      if (this.health_status.chronic_diseases.includes('gout')) {
        suggestions.push('避免高嘌呤食物，如动物内脏、海鲜和啤酒');
        suggestions.push('限制红肉摄入');
        suggestions.push('多喝水，每天保持2000-3000毫升水分摄入');
      }
    }
    
    // 生成运动计划
    let exercisePlan = '';
    if (this.lifestyle && this.lifestyle.exercise_frequency) {
      switch (this.lifestyle.exercise_frequency) {
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
    if (this.health_status && this.health_status.chronic_diseases && 
        this.health_status.chronic_diseases.some(d => d !== 'none')) {
      monitoringPlan = '每月测量一次基本健康指标，如体重、血压；每3-6个月进行一次完整的健康检查';
    } else {
      monitoringPlan = '每3个月监测一次体重和BMI；每6个月测量一次血压；每年进行一次全面体检';
    }
    
    // 更新健康建议
    const healthAdvice = {
      nutrition_suggestions: suggestions,
      lifestyle_changes: lifestyleChanges,
      exercise_plan: exercisePlan,
      diet_restrictions: [],
      recommended_supplements: [],
      monitoring_plan: monitoringPlan
    };
    
    // 添加分析历史记录
    this.analysis_history = this.analysis_history || [];
    this.analysis_history.push({
      analyzed_at: new Date(),
      analyzer_type: 'ai',
      analyzer_id: 'system',
      results: '基于健康数据的自动分析',
      recommendations: suggestions.join('; ')
    });
    
    // 更新健康建议字段
    this.health_advice = healthAdvice;
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