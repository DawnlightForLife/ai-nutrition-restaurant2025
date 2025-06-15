/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 所有方法为 async 函数，已包含权限校验
 * ✅ 返回结构统一：{ success, message, data? }
 * ✅ 接入服务层处理业务逻辑
 * ✅ 保护字段如 userId / isPrimary 已处理
 * ✅ 删除主档案时自动迁移主档逻辑完善
 *
 * 营养档案控制器
 * 处理与用户营养档案相关的请求
 * @module controllers/nutrition/nutritionProfileController
 */

const NutritionProfile = require('../../models/nutrition/nutritionProfileModel');
const nutritionProfileService = require('../../services/nutrition/nutritionProfileService');
const logger = require('../../utils/logger/winstonLogger.js');

// NOTE: getAllProfiles 仅管理员可访问
/**
 * 获取所有营养档案（仅管理员使用）
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const getAllProfiles = async (req, res) => {
  try {
    // 检查是否是管理员
    if (!req.user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: '权限不足，仅管理员可访问所有档案'
      });
    }

    const profiles = await NutritionProfile.find()
      .sort({ updatedAt: -1 })
      .limit(100);

    res.json({
      success: true,
      profiles
    });
  } catch (error) {
    logger.error('获取所有营养档案失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，获取档案失败',
      error: error.message
    });
  }
};

// NOTE: getProfileById 获取单个档案，校验用户或管理员权限
/**
 * 根据ID获取营养档案
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const getProfileById = async (req, res) => {
  try {
    const profileId = req.params.id;
    const userId = req.user.id;

    const profile = await NutritionProfile.findById(profileId);

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: '未找到指定的营养档案'
      });
    }

    // 验证用户是否有权限访问此档案
    if (profile.userId.toString() !== userId && !req.user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: '您无权访问此档案'
      });
    }

    res.json({
      success: true,
      profile
    });
  } catch (error) {
    logger.error(`获取营养档案(ID: ${req.params.id})失败:`, error);
    res.status(500).json({
      success: false,
      message: '服务器错误，获取档案失败',
      error: error.message
    });
  }
};

// NOTE: getProfilesByUserId 用于“我的档案”页面，按 isPrimary 排序
/**
 * 获取用户的所有营养档案
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const getProfilesByUserId = async (req, res) => {
  try {
    const userId = req.params.userId;
    const requestingUserId = req.user.id;

    // 验证用户是否有权限访问
    if (userId !== requestingUserId && !req.user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: '您无权访问此用户的档案'
      });
    }

    const profiles = await NutritionProfile.find({ userId })
      .sort({ isPrimary: -1, updatedAt: -1 });

    res.json({
      success: true,
      profiles
    });
  } catch (error) {
    logger.error(`获取用户(ID: ${req.params.userId})的营养档案失败:`, error);
    res.status(500).json({
      success: false,
      message: '服务器错误，获取档案失败',
      error: error.message
    });
  }
};

// NOTE: createProfile 自动补充 userId 字段，调用服务封装逻辑
/**
 * 创建新的营养档案
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const createProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const profileData = req.body;

    // 添加必要字段
    profileData.userId = userId;
    
    // 使用服务创建档案
    const nutritionProfileService = require('../../services/nutrition/nutritionProfileService');
    const newProfile = await nutritionProfileService.createProfile(profileData);

    res.status(201).json({
      success: true,
      message: '营养档案创建成功',
      profile: newProfile
    });
  } catch (error) {
    logger.error('创建营养档案失败:', error);
    res.status(500).json({
      success: false,
      message: error.statusCode === 400 ? error.message : '服务器错误，创建档案失败',
      error: error.message
    });
  }
};

// NOTE: updateProfile 禁止修改 userId，仅支持非敏感字段更新
/**
 * 更新营养档案
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const updateProfile = async (req, res) => {
  try {
    const profileId = req.params.id;
    const userId = req.user.id;
    const updateData = req.body;

    // 查找档案
    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      return res.status(404).json({
        success: false,
        message: '未找到指定的营养档案'
      });
    }

    // 验证用户是否有权限更新此档案
    if (profile.userId.toString() !== userId && !req.user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: '您无权更新此档案'
      });
    }

    // 防止修改关键字段
    delete updateData.userId;
    
    // 使用服务更新档案
    const nutritionProfileService = require('../../services/nutrition/nutritionProfileService');
    const updatedProfile = await nutritionProfileService.updateProfile(profileId, updateData);

    res.json({
      success: true,
      message: '营养档案更新成功',
      profile: updatedProfile
    });
  } catch (error) {
    logger.error(`更新营养档案(ID: ${req.params.id})失败:`, error);
    res.status(500).json({
      success: false,
      message: error.statusCode === 400 ? error.message : '服务器错误，更新档案失败',
      error: error.message
    });
  }
};

// NOTE: deleteProfile 若为主档案则自动迁移主档（updatedAt 最新）
/**
 * 删除营养档案
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const deleteProfile = async (req, res) => {
  try {
    const profileId = req.params.id;
    const userId = req.user.id;

    // 查找档案
    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      return res.status(404).json({
        success: false,
        message: '未找到指定的营养档案'
      });
    }

    // 验证用户是否有权限删除此档案
    if (profile.userId.toString() !== userId && !req.user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: '您无权删除此档案'
      });
    }

    // 检查是否是主档案
    if (profile.isPrimary) {
      // 寻找另一个档案设为主档案
      const alternativeProfile = await NutritionProfile.findOne({
        userId: profile.userId,
        _id: { $ne: profileId }
      }).sort({ updatedAt: -1 });

      if (alternativeProfile) {
        alternativeProfile.isPrimary = true;
        await alternativeProfile.save();
      }
    }

    // 删除档案
    await NutritionProfile.findByIdAndDelete(profileId);

    res.json({
      success: true,
      message: '营养档案删除成功'
    });
  } catch (error) {
    logger.error(`删除营养档案(ID: ${req.params.id})失败:`, error);
    res.status(500).json({
      success: false,
      message: '服务器错误，删除档案失败',
      error: error.message
    });
  }
};

// NOTE: setPrimaryProfile 会重置该用户全部档案的 isPrimary = false，再更新目标档案为 true
/**
 * 设置为主要营养档案
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const setPrimaryProfile = async (req, res) => {
  try {
    const profileId = req.params.id;
    const userId = req.user.id;

    // 查找档案
    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      return res.status(404).json({
        success: false,
        message: '未找到指定的营养档案'
      });
    }

    // 验证用户是否有权限修改此档案
    if (profile.userId.toString() !== userId && !req.user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: '您无权修改此档案'
      });
    }

    // 将所有档案设为非主档案
    await NutritionProfile.updateMany(
      { userId: profile.userId },
      { $set: { isPrimary: false, updatedAt: new Date() } }
    );

    // 将当前档案设为主档案
    profile.isPrimary = true;
    profile.updatedAt = new Date();
    await profile.save();

    res.json({
      success: true,
      message: '已成功设置为主要营养档案',
      profile
    });
  } catch (error) {
    logger.error(`设置主要营养档案(ID: ${req.params.id})失败:`, error);
    res.status(500).json({
      success: false,
      message: '服务器错误，设置主要档案失败',
      error: error.message
    });
  }
};

/**
 * 营养档案完成度计算
 */
const calculateCompletionPercentage = (profile) => {
  const requiredFields = [
    'profileName', 'gender', 'height', 'weight', 'activityLevel',
    'nutritionGoals'
  ];
  
  const optionalButImportantFields = [
    'targetWeight', 'dietaryPreferences', 'medicalConditions',
    'dailyCalorieTarget', 'hydrationGoal'
  ];

  let totalFields = requiredFields.length + optionalButImportantFields.length;
  let completedFields = 0;

  // 检查必填字段
  requiredFields.forEach(field => {
    if (profile[field] && 
        (Array.isArray(profile[field]) ? profile[field].length > 0 : true)) {
      completedFields++;
    }
  });

  // 检查重要可选字段
  optionalButImportantFields.forEach(field => {
    if (field === 'dietaryPreferences') {
      const prefs = profile.dietaryPreferences;
      if (prefs && (
        prefs.allergies?.length > 0 || 
        prefs.taboos?.length > 0 || 
        prefs.tastePreference?.length > 0
      )) {
        completedFields++;
      }
    } else if (profile[field] && 
               (Array.isArray(profile[field]) ? profile[field].length > 0 : true)) {
      completedFields++;
    }
  });

  return Math.round((completedFields / totalFields) * 100);
};

/**
 * 数据验证函数
 */
const validateNutritionProfile = (data) => {
  const errors = [];

  // BMI合理性检查
  if (data.height && data.weight) {
    const bmi = data.weight / Math.pow(data.height / 100, 2);
    if (bmi < 10 || bmi > 60) {
      errors.push('BMI值不在合理范围内，请检查身高体重数据');
    }
  }

  // 年龄组和目标体重合理性
  if (data.targetWeight && data.weight) {
    const weightDiff = Math.abs(data.targetWeight - data.weight);
    if (weightDiff > 50) {
      errors.push('目标体重与当前体重差异过大，请重新评估');
    }
  }

  // 热量目标合理性
  if (data.dailyCalorieTarget) {
    if (data.dailyCalorieTarget < 800 || data.dailyCalorieTarget > 5000) {
      errors.push('每日热量目标不在合理范围内(800-5000kcal)');
    }
  }

  // 饮水目标合理性
  if (data.hydrationGoal) {
    if (data.hydrationGoal < 500 || data.hydrationGoal > 5000) {
      errors.push('每日饮水目标不在合理范围内(500-5000ml)');
    }
  }

  return errors;
};

/**
 * 获取档案完成度统计
 */
const getCompletionStats = async (req, res) => {
  try {
    const userId = req.user.id;

    const profile = await NutritionProfile.findOne({ 
      userId, 
      isPrimary: true
    });

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: '未找到主要营养档案'
      });
    }

    const completionPercentage = calculateCompletionPercentage(profile);
    
    // 分析缺失的重要信息
    const missingInfo = [];
    
    if (!profile.targetWeight) missingInfo.push('目标体重');
    if (!profile.dailyCalorieTarget) missingInfo.push('每日热量目标');
    if (!profile.hydrationGoal) missingInfo.push('饮水目标');
    if (!profile.dietaryPreferences?.allergies?.length) missingInfo.push('过敏信息');
    if (!profile.medicalConditions?.length) missingInfo.push('健康状况');

    res.status(200).json({
      success: true,
      data: {
        completionPercentage,
        missingInfo,
        profileId: profile._id,
        lastUpdated: profile.updatedAt
      }
    });
  } catch (error) {
    logger.error('获取档案完成度统计失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，获取完成度统计失败',
      error: error.message
    });
  }
};

/**
 * 为AI推荐准备数据
 */
const getProfileForAI = async (req, res) => {
  try {
    const userId = req.user.id;

    const profile = await NutritionProfile.findOne({ 
      userId, 
      isPrimary: true
    }).select('-nutritionStatus -relatedHealthRecords'); // 排除敏感信息

    if (!profile) {
      return res.status(404).json({
        success: false,
        message: '未找到营养档案，请先完善基础信息'
      });
    }

    // 准备AI推荐所需的数据结构
    const aiData = {
      basicInfo: {
        gender: profile.gender,
        ageGroup: profile.ageGroup,
        height: profile.height,
        weight: profile.weight,
        targetWeight: profile.targetWeight,
        activityLevel: profile.activityLevel,
        bmi: profile.bmi
      },
      goals: {
        nutritionGoals: profile.nutritionGoals,
        dailyCalorieTarget: profile.dailyCalorieTarget,
        hydrationGoal: profile.hydrationGoal
      },
      preferences: {
        dietaryPreferences: profile.dietaryPreferences,
        mealFrequency: profile.mealFrequency,
        preferredMealTimes: profile.preferredMealTimes,
        cookingTimeBudget: profile.cookingTimeBudget
      },
      restrictions: {
        medicalConditions: profile.medicalConditions,
        allergies: profile.dietaryPreferences?.allergies || [],
        taboos: profile.dietaryPreferences?.taboos || []
      },
      region: profile.region,
      lifestyle: profile.lifestyle
    };

    res.status(200).json({
      success: true,
      data: aiData,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    logger.error('获取AI推荐数据失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，获取AI推荐数据失败',
      error: error.message
    });
  }
};

/**
 * 验证营养档案数据
 */
const validateProfile = async (req, res) => {
  try {
    const validationErrors = validateNutritionProfile(req.body);
    
    res.status(200).json({
      success: true,
      isValid: validationErrors.length === 0,
      errors: validationErrors
    });
  } catch (error) {
    logger.error('验证营养档案数据失败:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误，数据验证失败',
      error: error.message
    });
  }
};

/**
 * 更新健康目标详细配置
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const updateHealthGoalDetails = async (req, res) => {
  try {
    const profileId = req.params.id;
    const { healthGoalDetails } = req.body;

    // 获取档案以验证权限和目标一致性
    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      return res.status(404).json({
        success: false,
        message: '未找到指定的营养档案'
      });
    }

    // 验证用户权限
    if (profile.userId.toString() !== req.user.id && !req.user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: '您无权更新此档案'
      });
    }

    // 验证健康目标配置的一致性
    const consistencyError = nutritionProfileService.validateGoalConsistency(
      profile.nutritionGoals, 
      healthGoalDetails
    );
    
    if (consistencyError) {
      return res.status(400).json({
        success: false,
        message: consistencyError.message,
        field: consistencyError.field
      });
    }

    // 更新健康目标详细配置
    const updatedProfile = await nutritionProfileService.updateHealthGoalDetails(
      profileId, 
      healthGoalDetails
    );

    res.json({
      success: true,
      message: '健康目标详细配置更新成功',
      profile: updatedProfile
    });
  } catch (error) {
    logger.error(`更新健康目标详细配置(ID: ${req.params.id})失败:`, error);
    res.status(500).json({
      success: false,
      message: '服务器错误，更新健康目标详细配置失败',
      error: error.message
    });
  }
};

/**
 * 获取营养档案完成度详情
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 */
const getProfileCompleteness = async (req, res) => {
  try {
    const profileId = req.params.id;
    
    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      return res.status(404).json({
        success: false,
        message: '未找到指定的营养档案'
      });
    }

    // 验证用户权限
    if (profile.userId.toString() !== req.user.id && !req.user.isAdmin) {
      return res.status(403).json({
        success: false,
        message: '您无权查看此档案'
      });
    }

    // 计算完成度
    const completeness = nutritionProfileService.calculateCompleteness(profile);
    
    res.json({
      success: true,
      data: {
        profileId: profile._id,
        completeness: completeness,
        recommendations: completeness < 80 ? [
          '建议完善饮食偏好信息',
          '建议添加运动习惯信息',
          '建议设置健康目标详细配置'
        ] : []
      }
    });
  } catch (error) {
    logger.error(`获取营养档案完成度(ID: ${req.params.id})失败:`, error);
    res.status(500).json({
      success: false,
      message: '服务器错误，获取完成度失败',
      error: error.message
    });
  }
};

module.exports = {
  getAllProfiles,
  getProfileById,
  getProfilesByUserId,
  createProfile,
  updateProfile,
  deleteProfile,
  setPrimaryProfile,
  getCompletionStats,
  getProfileForAI,
  validateProfile,
  calculateCompletionPercentage,
  validateNutritionProfile,
  updateHealthGoalDetails,
  getProfileCompleteness
};
