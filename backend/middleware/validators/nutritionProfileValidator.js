/**
 * 营养档案数据验证中间件
 * 提供营养档案创建和更新时的数据验证
 * @module middleware/validators/nutritionProfileValidator
 */

const { 
  ETHNIC_DIETARY, 
  RELIGIOUS_DIETARY, 
  DIETARY_TYPES,
  EXERCISE_TYPES,
  TRAINING_INTENSITY,
  HEALTH_GOALS,
  TASTE_INTENSITY
} = require('../../constants/dietaryRestrictions');
const { ALL_CUISINES } = require('../../constants/cuisineTypes');

/**
 * 验证基础信息字段
 */
const validateBasicInfo = (data) => {
  const errors = [];

  // 验证性别
  if (data.gender && !['male', 'female', 'other'].includes(data.gender)) {
    errors.push({
      field: 'gender',
      message: '性别必须是 male、female 或 other'
    });
  }

  // 验证年龄段
  const validAgeGroups = ['under18', '18to25', '26to35', '36to45', '46to55', '56to65', 'above65'];
  if (data.ageGroup && !validAgeGroups.includes(data.ageGroup)) {
    errors.push({
      field: 'ageGroup',
      message: '年龄段无效'
    });
  }

  // 验证身高
  if (data.height !== undefined) {
    if (isNaN(data.height) || data.height <= 0 || data.height > 300) {
      errors.push({
        field: 'height',
        message: '身高必须是0-300之间的有效数字'
      });
    }
  }

  // 验证体重
  if (data.weight !== undefined) {
    if (isNaN(data.weight) || data.weight <= 0 || data.weight > 500) {
      errors.push({
        field: 'weight',
        message: '体重必须是0-500之间的有效数字'
      });
    }
  }

  // 验证活动水平
  const validActivityLevels = ['sedentary', 'light', 'moderate', 'active', 'very_active', 'professional'];
  if (data.activityLevel && !validActivityLevels.includes(data.activityLevel)) {
    errors.push({
      field: 'activityLevel',
      message: '活动水平无效'
    });
  }

  return errors;
};

/**
 * 验证饮食偏好字段
 */
const validateDietaryPreferences = (dietaryPreferences) => {
  const errors = [];

  if (!dietaryPreferences) return errors;

  // 验证饮食类型
  if (dietaryPreferences.dietaryType && 
      !Object.values(DIETARY_TYPES).includes(dietaryPreferences.dietaryType)) {
    errors.push({
      field: 'dietaryPreferences.dietaryType',
      message: '饮食类型无效'
    });
  }

  // 验证菜系偏好
  if (dietaryPreferences.cuisinePreferences) {
    const invalidCuisines = dietaryPreferences.cuisinePreferences.filter(
      cuisine => !Object.values(ALL_CUISINES).includes(cuisine)
    );
    if (invalidCuisines.length > 0) {
      errors.push({
        field: 'dietaryPreferences.cuisinePreferences',
        message: `无效的菜系: ${invalidCuisines.join(', ')}`
      });
    }
  }

  // 验证民族饮食习惯
  if (dietaryPreferences.ethnicDietary && 
      !Object.values(ETHNIC_DIETARY).includes(dietaryPreferences.ethnicDietary)) {
    errors.push({
      field: 'dietaryPreferences.ethnicDietary',
      message: '民族饮食习惯无效'
    });
  }

  // 验证宗教饮食要求
  if (dietaryPreferences.religiousDietary && 
      !Object.values(RELIGIOUS_DIETARY).includes(dietaryPreferences.religiousDietary)) {
    errors.push({
      field: 'dietaryPreferences.religiousDietary',
      message: '宗教饮食要求无效'
    });
  }

  // 验证口味偏好强度
  if (dietaryPreferences.tastePreferences) {
    const tastePrefs = dietaryPreferences.tastePreferences;
    
    // 验证辣度偏好
    if (tastePrefs.spicy !== undefined && 
        (tastePrefs.spicy < 0 || tastePrefs.spicy > 4)) {
      errors.push({
        field: 'dietaryPreferences.tastePreferences.spicy',
        message: '辣度偏好必须在0-4之间'
      });
    }

    // 验证其他口味偏好
    ['salty', 'sweet', 'sour', 'oily'].forEach(taste => {
      if (tastePrefs[taste] !== undefined && 
          (tastePrefs[taste] < 0 || tastePrefs[taste] > 2)) {
        errors.push({
          field: `dietaryPreferences.tastePreferences.${taste}`,
          message: `${taste}偏好必须在0-2之间`
        });
      }
    });
  }

  return errors;
};

/**
 * 验证生活方式字段
 */
const validateLifestyle = (lifestyle) => {
  const errors = [];

  if (!lifestyle) return errors;

  // 验证睡眠时长
  if (lifestyle.sleepDuration !== undefined) {
    if (isNaN(lifestyle.sleepDuration) || 
        lifestyle.sleepDuration < 0 || 
        lifestyle.sleepDuration > 24) {
      errors.push({
        field: 'lifestyle.sleepDuration',
        message: '睡眠时长必须在0-24小时之间'
      });
    }
  }

  // 验证运动类型
  if (lifestyle.exerciseTypes) {
    const invalidTypes = lifestyle.exerciseTypes.filter(
      type => !Object.values(EXERCISE_TYPES).includes(type)
    );
    if (invalidTypes.length > 0) {
      errors.push({
        field: 'lifestyle.exerciseTypes',
        message: `无效的运动类型: ${invalidTypes.join(', ')}`
      });
    }
  }

  // 验证训练强度
  if (lifestyle.trainingIntensity && 
      !Object.values(TRAINING_INTENSITY).includes(lifestyle.trainingIntensity)) {
    errors.push({
      field: 'lifestyle.trainingIntensity',
      message: '训练强度无效'
    });
  }

  // 验证每周运动时间
  if (lifestyle.weeklyExerciseHours !== undefined) {
    if (isNaN(lifestyle.weeklyExerciseHours) || 
        lifestyle.weeklyExerciseHours < 0 || 
        lifestyle.weeklyExerciseHours > 168) {
      errors.push({
        field: 'lifestyle.weeklyExerciseHours',
        message: '每周运动时间必须在0-168小时之间'
      });
    }
  }

  return errors;
};

/**
 * 验证营养目标
 */
const validateNutritionGoals = (nutritionGoals) => {
  const errors = [];

  if (!nutritionGoals || !Array.isArray(nutritionGoals)) {
    return errors;
  }

  const invalidGoals = nutritionGoals.filter(
    goal => !Object.values(HEALTH_GOALS).includes(goal)
  );

  if (invalidGoals.length > 0) {
    errors.push({
      field: 'nutritionGoals',
      message: `无效的营养目标: ${invalidGoals.join(', ')}`
    });
  }

  return errors;
};

/**
 * 验证健康目标详细配置
 */
const validateHealthGoalDetails = (healthGoalDetails, nutritionGoals) => {
  const errors = [];

  if (!healthGoalDetails) return errors;

  // 验证血糖控制配置
  if (healthGoalDetails.bloodSugarControl) {
    const bsc = healthGoalDetails.bloodSugarControl;
    
    if (bsc.fastingGlucose !== undefined && 
        (bsc.fastingGlucose < 0 || bsc.fastingGlucose > 30)) {
      errors.push({
        field: 'healthGoalDetails.bloodSugarControl.fastingGlucose',
        message: '空腹血糖值超出合理范围'
      });
    }

    if (bsc.hba1c !== undefined && 
        (bsc.hba1c < 0 || bsc.hba1c > 20)) {
      errors.push({
        field: 'healthGoalDetails.bloodSugarControl.hba1c',
        message: '糖化血红蛋白值超出合理范围'
      });
    }
  }

  // 验证血压管理配置
  if (healthGoalDetails.bloodPressureControl) {
    const bpc = healthGoalDetails.bloodPressureControl;
    
    if (bpc.systolic !== undefined && 
        (bpc.systolic < 50 || bpc.systolic > 300)) {
      errors.push({
        field: 'healthGoalDetails.bloodPressureControl.systolic',
        message: '收缩压值超出合理范围'
      });
    }

    if (bpc.diastolic !== undefined && 
        (bpc.diastolic < 30 || bpc.diastolic > 200)) {
      errors.push({
        field: 'healthGoalDetails.bloodPressureControl.diastolic',
        message: '舒张压值超出合理范围'
      });
    }
  }

  // 验证体重管理配置
  if (healthGoalDetails.weightManagement) {
    const wm = healthGoalDetails.weightManagement;
    
    if (wm.targetWeight !== undefined && 
        (wm.targetWeight < 20 || wm.targetWeight > 500)) {
      errors.push({
        field: 'healthGoalDetails.weightManagement.targetWeight',
        message: '目标体重超出合理范围'
      });
    }

    if (wm.targetBodyFat !== undefined && 
        (wm.targetBodyFat < 5 || wm.targetBodyFat > 50)) {
      errors.push({
        field: 'healthGoalDetails.weightManagement.targetBodyFat',
        message: '目标体脂率超出合理范围'
      });
    }
  }

  return errors;
};

/**
 * 营养档案创建验证中间件
 */
const validateProfileCreation = (req, res, next) => {
  const errors = [];
  const data = req.body;

  // 验证必填字段
  const requiredFields = ['profileName', 'gender', 'ageGroup', 'height', 'weight'];
  requiredFields.forEach(field => {
    if (!data[field]) {
      errors.push({
        field,
        message: `${field} 是必填字段`
      });
    }
  });

  // 验证各个模块
  errors.push(...validateBasicInfo(data));
  errors.push(...validateDietaryPreferences(data.dietaryPreferences));
  errors.push(...validateLifestyle(data.lifestyle));
  errors.push(...validateNutritionGoals(data.nutritionGoals));
  errors.push(...validateHealthGoalDetails(data.healthGoalDetails, data.nutritionGoals));

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: '数据验证失败',
      errors
    });
  }

  next();
};

/**
 * 营养档案更新验证中间件
 */
const validateProfileUpdate = (req, res, next) => {
  const errors = [];
  const data = req.body;

  // 验证各个模块（更新时不强制要求必填字段）
  errors.push(...validateBasicInfo(data));
  errors.push(...validateDietaryPreferences(data.dietaryPreferences));
  errors.push(...validateLifestyle(data.lifestyle));
  errors.push(...validateNutritionGoals(data.nutritionGoals));
  errors.push(...validateHealthGoalDetails(data.healthGoalDetails, data.nutritionGoals));

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: '数据验证失败',
      errors
    });
  }

  next();
};

/**
 * 健康目标详细配置验证中间件
 */
const validateHealthGoalDetailsUpdate = (req, res, next) => {
  const errors = [];
  const { healthGoalDetails } = req.body;

  if (!healthGoalDetails) {
    return res.status(400).json({
      success: false,
      message: 'healthGoalDetails 字段是必需的'
    });
  }

  errors.push(...validateHealthGoalDetails(healthGoalDetails));

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: '健康目标详细配置验证失败',
      errors
    });
  }

  next();
};

module.exports = {
  validateProfileCreation,
  validateProfileUpdate,
  validateHealthGoalDetailsUpdate,
  validateBasicInfo,
  validateDietaryPreferences,
  validateLifestyle,
  validateNutritionGoals,
  validateHealthGoalDetails
};