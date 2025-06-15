/**
 * 扩展营养档案功能测试脚本
 * 测试新增的字段和功能
 */

const mongoose = require('mongoose');
const NutritionProfile = require('../../models/nutrition/nutritionProfileModel');
const nutritionProfileService = require('../../services/nutrition/nutritionProfileService');
const { 
  DIETARY_TYPES, 
  HEALTH_GOALS, 
  EXERCISE_TYPES 
} = require('../../constants/dietaryRestrictions');
const { ALL_CUISINES } = require('../../constants/cuisineTypes');

// 测试数据
const testUserId = new mongoose.Types.ObjectId();

const sampleProfileData = {
  userId: testUserId,
  profileName: '测试营养档案',
  gender: 'male',
  ageGroup: '26to35',
  height: 175,
  weight: 70,
  activityLevel: 'moderate',
  
  // 扩展的饮食偏好
  dietaryPreferences: {
    dietaryType: DIETARY_TYPES.OMNIVORE,
    cuisinePreferences: [ALL_CUISINES.SICHUAN, ALL_CUISINES.CANTONESE],
    ethnicDietary: 'han',
    tastePreferences: {
      spicy: 2,
      salty: 1,
      sweet: 1,
      sour: 1,
      oily: 1
    },
    taboos: ['香菜', '榴莲'],
    allergies: ['花生'],
    specialRequirements: ['低钠饮食']
  },

  // 扩展的生活方式
  lifestyle: {
    smoking: false,
    drinking: false,
    sleepDuration: 7.5,
    exerciseFrequency: 'regular',
    exerciseTypes: [EXERCISE_TYPES.RUNNING, EXERCISE_TYPES.GYM],
    trainingIntensity: 'moderate',
    weeklyExerciseHours: 5,
    preferredExerciseTime: 'evening'
  },

  // 营养目标
  nutritionGoals: [
    HEALTH_GOALS.WEIGHT_LOSS,
    HEALTH_GOALS.MUSCLE_GAIN,
    HEALTH_GOALS.IMMUNITY_BOOST
  ],

  // 健康目标详细配置
  healthGoalDetails: {
    weightManagement: {
      targetWeight: 65,
      targetBodyFat: 15,
      targetType: 'loss',
      targetSpeed: 'moderate',
      targetDate: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000) // 3个月后
    },
    sportsNutrition: {
      sportTypes: [EXERCISE_TYPES.RUNNING, EXERCISE_TYPES.GYM],
      trainingPhase: 'off_season',
      supplementUse: [
        {
          name: '蛋白粉',
          dosage: '30g',
          timing: '训练后'
        }
      ]
    }
  },

  region: {
    province: '广东省',
    city: '深圳市'
  },
  
  occupation: 'officeWorker'
};

async function runTests() {
  console.log('🚀 开始测试扩展营养档案功能...\n');

  try {
    // 连接数据库
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/smart_nutrition_test');
    console.log('✅ 数据库连接成功');

    // 测试1: 创建扩展营养档案
    console.log('\n📝 测试1: 创建扩展营养档案');
    const createdProfile = await nutritionProfileService.createProfile(sampleProfileData);
    console.log(`✅ 档案创建成功，ID: ${createdProfile._id}`);
    console.log(`📊 BMI: ${createdProfile.bmi}`);

    // 测试2: 验证字段
    console.log('\n🔍 测试2: 验证扩展字段');
    console.log(`✅ 饮食类型: ${createdProfile.dietaryPreferences.dietaryType}`);
    console.log(`✅ 菜系偏好: ${createdProfile.dietaryPreferences.cuisinePreferences.join(', ')}`);
    console.log(`✅ 辣度偏好: ${createdProfile.dietaryPreferences.tastePreferences.spicy}/4`);
    console.log(`✅ 运动类型: ${createdProfile.lifestyle.exerciseTypes.join(', ')}`);
    console.log(`✅ 营养目标: ${createdProfile.nutritionGoals.join(', ')}`);

    // 测试3: 计算完成度
    console.log('\n📈 测试3: 计算档案完成度');
    const completeness = nutritionProfileService.calculateCompleteness(createdProfile);
    console.log(`✅ 档案完成度: ${completeness}%`);

    // 测试4: 更新健康目标详细配置
    console.log('\n🎯 测试4: 更新健康目标详细配置');
    const updatedHealthGoals = {
      bloodSugarControl: {
        fastingGlucose: 5.5,
        hba1c: 5.8,
        diabetesType: 'none',
        medicationStatus: 'none',
        monitoringFrequency: 'monthly'
      }
    };
    
    const updatedProfile = await nutritionProfileService.updateHealthGoalDetails(
      createdProfile._id,
      updatedHealthGoals
    );
    console.log('✅ 健康目标详细配置更新成功');

    // 测试5: 验证目标一致性
    console.log('\n⚖️ 测试5: 验证目标一致性');
    const consistencyError = nutritionProfileService.validateGoalConsistency(
      [HEALTH_GOALS.WEIGHT_LOSS], // 只有减重目标
      { bloodSugarControl: updatedHealthGoals.bloodSugarControl } // 但有血糖控制配置
    );
    
    if (consistencyError) {
      console.log(`⚠️ 检测到一致性问题: ${consistencyError.message}`);
    } else {
      console.log('✅ 目标配置一致性验证通过');
    }

    // 测试6: 获取档案（验证查询）
    console.log('\n🔎 测试6: 获取档案');
    const retrievedProfile = await nutritionProfileService.getProfileById(createdProfile._id);
    console.log(`✅ 档案获取成功: ${retrievedProfile.profileName}`);

    // 测试7: 删除测试数据
    console.log('\n🗑️ 测试7: 清理测试数据');
    await nutritionProfileService.deleteProfile(createdProfile._id);
    console.log('✅ 测试数据清理完成');

    console.log('\n🎉 所有测试完成！');

  } catch (error) {
    console.error('❌ 测试失败:', error.message);
    console.error(error.stack);
  } finally {
    await mongoose.connection.close();
    console.log('📦 数据库连接已关闭');
  }
}

// 如果直接运行此文件
if (require.main === module) {
  runTests().catch(console.error);
}

module.exports = { runTests, sampleProfileData };