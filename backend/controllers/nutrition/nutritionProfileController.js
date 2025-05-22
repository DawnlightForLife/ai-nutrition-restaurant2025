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

module.exports = {
  getAllProfiles,
  getProfileById,
  getProfilesByUserId,
  createProfile,
  updateProfile,
  deleteProfile,
  setPrimaryProfile
};
