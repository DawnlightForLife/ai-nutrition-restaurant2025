/**
 * 生成模拟健康数据
 * 用于测试和开发的模拟数据生成器
 */

const mongoose = require('mongoose');
const dotenv = require('dotenv');
const { faker } = require('@faker-js/faker/locale/zh_CN');

// 加载环境变量
dotenv.config();

// 数据库连接
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('数据库连接成功'))
.catch(err => {
  console.error('数据库连接失败:', err);
  process.exit(1);
});

// 导入模型
const User = require('../models/core/userModel');
const NutritionProfile = require('../models/health/nutritionProfileModel');
const HealthData = require('../models/health/healthDataModel');

// 随机从数组中选择一个元素
const randomChoice = (array) => {
  return array[Math.floor(Math.random() * array.length)];
};

// 随机生成健康数据
async function generateHealthData(userId, nutritionProfileId = null) {
  // 随机性别
  const gender = randomChoice(['male', 'female', 'other']);
  // 随机年龄段
  const ageGroup = randomChoice(['under_18', '18_30', '31_45', '46_60', 'above_60']);
  
  // 随机身高体重
  let height, weight;
  if (gender === 'male') {
    height = faker.number.int({ min: 160, max: 190 });
    weight = faker.number.int({ min: 55, max: 90 });
  } else {
    height = faker.number.int({ min: 150, max: 175 });
    weight = faker.number.int({ min: 45, max: 75 });
  }
  
  // 计算BMI
  const bmi = Number((weight / ((height / 100) ** 2)).toFixed(1));
  
  // 随机血压
  const systolic = faker.number.int({ min: 100, max: 150 });
  const diastolic = faker.number.int({ min: 60, max: 100 });
  
  // 随机心率
  const heartRate = faker.number.int({ min: 60, max: 100 });
  
  // 随机慢性病 (20%概率有慢性病)
  const chronicDiseases = [];
  if (Math.random() < 0.2) {
    const diseases = ['hypertension', 'diabetes', 'gout', 'heart_disease'];
    const disease = randomChoice(diseases);
    chronicDiseases.push(disease);
  } else {
    chronicDiseases.push('none');
  }
  
  // 随机特殊状况 (10%概率有特殊状况)
  const specialConditions = [];
  if (gender === 'female' && Math.random() < 0.1) {
    const conditions = ['pregnancy', 'lactation', 'menopause'];
    const condition = randomChoice(conditions);
    specialConditions.push(condition);
  } else {
    specialConditions.push('none');
  }
  
  // 随机饮食偏好
  const isVegetarian = Math.random() < 0.1; // 10%概率是素食者
  const tastePreference = [];
  ['light', 'spicy', 'sour', 'sweet', 'salty'].forEach(taste => {
    if (Math.random() < 0.3) { // 30%概率喜欢某种口味
      tastePreference.push(taste);
    }
  });
  
  // 随机食物禁忌 (30%概率有禁忌)
  const taboos = [];
  if (Math.random() < 0.3) {
    const allTaboos = ['seafood', 'nuts', 'dairy', 'gluten', 'pork', 'beef'];
    const tabooCount = faker.number.int({ min: 1, max: 2 });
    for (let i = 0; i < tabooCount; i++) {
      taboos.push(randomChoice(allTaboos));
    }
  }
  
  // 随机菜系偏好
  const cuisine = randomChoice(['chinese', 'western', 'japanese', 'korean', 'other']);
  
  // 随机过敏源 (20%概率有过敏)
  const allergies = [];
  if (Math.random() < 0.2) {
    const allAllergies = ['eggs', 'milk', 'peanuts', 'tree nuts', 'shellfish', 'wheat', 'soy'];
    const allergyCount = faker.number.int({ min: 1, max: 2 });
    for (let i = 0; i < allergyCount; i++) {
      allergies.push(randomChoice(allAllergies));
    }
  }
  
  // 随机生活方式
  const smoking = Math.random() < 0.2; // 20%概率吸烟
  const drinking = Math.random() < 0.3; // 30%概率饮酒
  const sleepDuration = faker.number.int({ min: 5, max: 9 });
  const exerciseFrequency = randomChoice(['none', 'occasional', 'regular', 'frequent', 'daily']);
  
  // 随机营养目标
  const goals = ['weight_loss', 'weight_gain', 'muscle_gain', 'heart_health', 'diabetes_management', 'energy_boost'];
  const nutritionGoals = [];
  const goalCount = faker.number.int({ min: 1, max: 2 });
  for (let i = 0; i < goalCount; i++) {
    nutritionGoals.push(randomChoice(goals));
  }
  
  // 随机血液指标 (50%概率有血液指标)
  let bloodMetrics = null;
  if (Math.random() < 0.5) {
    bloodMetrics = {
      cholesterol: {
        total: faker.number.int({ min: 150, max: 250 }).toString(),
        hdl: faker.number.int({ min: 40, max: 80 }).toString(),
        ldl: faker.number.int({ min: 70, max: 160 }).toString(),
        triglycerides: faker.number.int({ min: 50, max: 200 }).toString()
      },
      glucose: {
        fasting: faker.number.int({ min: 70, max: 110 }).toString(),
        after_meal: faker.number.int({ min: 100, max: 180 }).toString(),
        hba1c: (Math.random() * 2 + 4).toFixed(1)
      },
      liver: {
        alt: faker.number.int({ min: 10, max: 50 }),
        ast: faker.number.int({ min: 10, max: 40 }),
        alp: faker.number.int({ min: 40, max: 130 })
      },
      kidney: {
        creatinine: (Math.random() * 0.8 + 0.5).toFixed(2),
        urea: (Math.random() * 5 + 2).toFixed(2)
      },
      electrolytes: {
        sodium: faker.number.int({ min: 135, max: 145 }),
        potassium: (Math.random() * 2 + 3.5).toFixed(1),
        calcium: (Math.random() * 1 + 8.5).toFixed(1),
        magnesium: (Math.random() * 0.6 + 1.7).toFixed(1)
      },
      blood_count: {
        wbc: (Math.random() * 5 + 4).toFixed(1),
        rbc: (Math.random() * 2 + 4).toFixed(2),
        hemoglobin: (Math.random() * 5 + 12).toFixed(1),
        platelets: faker.number.int({ min: 150, max: 400 })
      }
    };
  }
  
  // 随机医疗报告 (30%概率有医疗报告)
  let medicalReport = null;
  if (Math.random() < 0.3) {
    medicalReport = {
      ocr_image_url: faker.image.url(),
      ocr_processing_status: randomChoice(['pending', 'processing', 'completed', 'failed']),
      ocr_raw_text: faker.lorem.paragraphs(2),
      report_date: faker.date.past({ years: 1 }),
      hospital_name: `${faker.location.city()}${randomChoice(['人民医院', '中心医院', '协和医院', '第一医院'])}`,
      diagnosis: faker.lorem.sentences(2)
    };
  }
  
  // 区域信息
  const province = faker.location.state();
  const city = faker.location.city();
  const district = `${randomChoice(['东', '西', '南', '北', '中'])}城区`;
  
  // 随机职业
  const occupation = randomChoice(['student', 'office_worker', 'physical_worker', 'retired', 'other']);
  
  // 创建健康数据对象
  const healthData = new HealthData({
    user_id: userId,
    userId: userId.toString(),
    nutrition_profile_id: nutritionProfileId,
    nutritionProfileId: nutritionProfileId ? nutritionProfileId.toString() : null,
    profile_info: {
      nickname: faker.person.lastName() + faker.person.firstName(),
      gender,
      age_group: ageGroup,
      region: {
        province,
        city,
        district
      },
      occupation
    },
    basic_metrics: {
      height,
      weight,
      bmi,
      blood_pressure: {
        systolic,
        diastolic
      },
      heart_rate: heartRate
    },
    health_status: {
      chronic_diseases: chronicDiseases,
      special_conditions: specialConditions
    },
    dietary_preferences: {
      is_vegetarian: isVegetarian,
      taste_preference: tastePreference,
      taboos,
      cuisine,
      allergies
    },
    lifestyle: {
      smoking,
      drinking,
      sleep_duration: sleepDuration,
      exercise_frequency: exerciseFrequency
    },
    nutrition_goals: nutritionGoals,
    blood_metrics: bloodMetrics,
    medical_report: medicalReport,
    privacy_level: randomChoice(['high', 'medium', 'low']),
    synced_to_profile: nutritionProfileId ? true : false,
    health_advice: {
      nutrition_suggestions: [],
      lifestyle_changes: [],
      exercise_plan: '',
      diet_restrictions: [],
      recommended_supplements: [],
      monitoring_plan: ''
    },
    analysis_history: [],
    sync_history: nutritionProfileId ? [
      {
        synced_at: new Date(),
        profile_id: nutritionProfileId,
        sync_type: 'automatic',
        sync_status: 'success',
        sync_details: '初始化时自动同步'
      }
    ] : [],
    data_source: {
      source_type: 'manual',
      device_info: '',
      app_version: '1.0.0',
      import_file: ''
    },
    validation: {
      is_validated: false,
      validated_by: '',
      validation_date: null,
      validation_method: ''
    }
  });
  
  // 保存健康数据
  const savedHealthData = await healthData.save();
  console.log(`已创建健康数据: ${savedHealthData._id}`);
  
  // 如果有关联的营养档案，更新档案的相关字段
  if (nutritionProfileId) {
    const relatedProfile = await NutritionProfile.findById(nutritionProfileId);
    if (relatedProfile) {
      relatedProfile.related_health_data = relatedProfile.related_health_data || [];
      relatedProfile.related_health_data.push(savedHealthData._id);
      await relatedProfile.save();
      console.log(`已更新营养档案 ${nutritionProfileId} 的关联健康数据`);
    }
  }
  
  // 自动生成健康建议
  await savedHealthData.analyzeAndGenerateAdvice();
  console.log(`已为健康数据 ${savedHealthData._id} 生成健康建议`);
  
  return savedHealthData;
}

// 为每个用户生成健康数据
async function generateDataForAllUsers(count = 3) {
  try {
    // 清除现有的健康数据
    await HealthData.deleteMany({});
    console.log('已清除现有的健康数据');
    
    // 查找所有用户
    const users = await User.find();
    console.log(`找到 ${users.length} 个用户`);
    
    for (const user of users) {
      console.log(`为用户 ${user.username} (${user._id}) 生成健康数据`);
      
      // 查找用户的营养档案
      const profiles = await NutritionProfile.find({ user_id: user._id });
      console.log(`