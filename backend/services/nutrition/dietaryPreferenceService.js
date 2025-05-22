/**
 * 饮食偏好服务模块（dietaryPreferenceService）
 * 提供用户饮食偏好的查询与更新功能
 * 支持按 userId 获取与 upsert 操作，自动更新时间戳
 * 与 dietaryPreferenceModel 模型配合，服务于营养档案与推荐系统
 * @module services/nutrition/dietaryPreferenceService
 */
const DietaryPreference = require('../../models/nutrition/dietaryPreferenceModel');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 饮食偏好服务对象
 */
const dietaryPreferenceService = {
  /**
   * 获取用户饮食偏好
   * @async
   * @param {string} userId - 用户ID
   * @returns {Promise<Object>} 用户饮食偏好
   */
  async getUserDietaryPreferences(userId) {
    try {
      const preferences = await DietaryPreference.findOne({ userId });
      return preferences;
    } catch (error) {
      logger.error('获取用户饮食偏好失败', { userId, error });
      throw new Error('获取饮食偏好失败');
    }
  },

  /**
   * 创建或更新用户饮食偏好
   * @async
   * @param {string} userId - 用户ID
   * @param {Object} preferenceData - 偏好数据
   * @returns {Promise<Object>} 创建或更新的饮食偏好
   */
  async updateDietaryPreferences(userId, preferenceData) {
    try {
      const preferences = await DietaryPreference.findOneAndUpdate(
        { userId },
        { ...preferenceData, updatedAt: new Date() },
        { new: true, upsert: true }
      );
      
      logger.info('用户饮食偏好已更新', { userId });
      return preferences;
    } catch (error) {
      logger.error('更新用户饮食偏好失败', { userId, error });
      throw new Error('更新饮食偏好失败');
    }
  }
};

module.exports = dietaryPreferenceService;
