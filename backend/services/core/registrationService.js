const User = require('../../models/core/userModel');
const NutritionProfile = require('../../models/health/nutritionProfileModel');
const { validateUser } = require('../../utils/validators/userValidator');
const logger = require('../../utils/logger');

/**
 * 注册服务 - 处理用户注册相关的所有操作
 * 包括用户信息验证、创建用户账号、初始化营养档案等
 */
const registrationService = {
  /**
   * 验证注册信息
   * @param {Object} userData - 用户注册数据
   * @returns {Object} - 验证结果
   */
  async validateRegistration(userData) {
    try {
      const { error } = validateUser(userData);
      if (error) {
        return { isValid: false, error: error.details[0].message };
      }

      // 检查邮箱是否已存在
      const existingUser = await User.findOne({ email: userData.email });
      if (existingUser) {
        return { isValid: false, error: '该邮箱已被注册' };
      }

      // 检查手机号是否已存在
      const existingPhone = await User.findOne({ phone: userData.phone });
      if (existingPhone) {
        return { isValid: false, error: '该手机号已被注册' };
      }

      return { isValid: true };
    } catch (error) {
      logger.error(`Error validating registration: ${error.message}`, { error });
      throw error;
    }
  },

  /**
   * 创建新用户
   * @param {Object} userData - 用户注册数据
   * @returns {Promise<Object>} - 创建的用户对象
   */
  async createUser(userData) {
    try {
      // 验证注册信息
      const validation = await this.validateRegistration(userData);
      if (!validation.isValid) {
        throw new Error(validation.error);
      }

      // 创建用户
      const user = new User(userData);
      await user.save();

      // 创建初始营养档案
      const nutritionProfile = new NutritionProfile({
        user_id: user._id,
        userId: user.userId,
        profileName: '默认营养档案',
        gender: userData.gender || 'other',
        ageGroup: this.calculateAgeGroup(userData.birthDate),
        isPrimary: true,
        privacy_settings: {
          share_with_nutritionist: false,
          use_for_ai_recommendation: true,
          use_for_merchants: false
        }
      });
      await nutritionProfile.save();

      // 返回创建的用户（不包含敏感信息）
      const userResponse = user.toObject();
      delete userResponse.password;
      delete userResponse.__v;

      return {
        user: userResponse,
        nutritionProfile: nutritionProfile
      };
    } catch (error) {
      logger.error(`Error creating user: ${error.message}`, { error });
      throw error;
    }
  },

  /**
   * 计算年龄组
   * @param {Date} birthDate - 出生日期
   * @returns {String} - 年龄组
   */
  calculateAgeGroup(birthDate) {
    if (!birthDate) return '18_30';

    const age = new Date().getFullYear() - new Date(birthDate).getFullYear();
    
    if (age < 18) return 'under_18';
    if (age <= 30) return '18_30';
    if (age <= 45) return '31_45';
    if (age <= 60) return '46_60';
    return 'above_60';
  },

  /**
   * 完成注册流程
   * @param {String} userId - 用户ID
   * @param {Object} additionalData - 补充信息
   * @returns {Promise<Object>} - 更新后的用户信息
   */
  async completeRegistration(userId, additionalData) {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new Error('用户不存在');
      }

      // 更新用户信息
      const updatedUser = await User.findByIdAndUpdate(
        userId,
        { 
          $set: { 
            ...additionalData,
            registration_completed: true,
            registration_completed_at: new Date()
          }
        },
        { new: true }
      ).select('-password -__v');

      return updatedUser;
    } catch (error) {
      logger.error(`Error completing registration: ${error.message}`, { error });
      throw error;
    }
  }
};

module.exports = registrationService; 