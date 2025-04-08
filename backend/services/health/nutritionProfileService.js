const NutritionProfile = require('../../models/health/nutritionProfileModel');

/**
 * 营养档案服务 - 负责处理用户营养档案的创建、查询、更新和删除
 * 提供用户营养状况管理和健康数据关联功能
 */
const nutritionProfileService = {
  /**
   * 创建新的营养档案
   * @param {Object} profileData - 营养档案数据
   * @returns {Promise<Object>} - 创建的营养档案
   */
  async createProfile(profileData) {
    try {
      const nutritionProfile = new NutritionProfile(profileData);
      await nutritionProfile.save();
      return nutritionProfile;
    } catch (error) {
      throw new Error(`创建营养档案失败: ${error.message}`);
    }
  },

  /**
   * 通过ID获取营养档案
   * @param {String} profileId - 营养档案ID
   * @returns {Promise<Object>} - 营养档案信息
   */
  async getProfileById(profileId) {
    try {
      const profile = await NutritionProfile.findById(profileId);
      if (!profile) {
        throw new Error('营养档案不存在');
      }
      return profile;
    } catch (error) {
      throw new Error(`获取营养档案失败: ${error.message}`);
    }
  },

  /**
   * 获取用户的所有营养档案
   * @param {String} userId - 用户ID
   * @returns {Promise<Array>} - 用户的营养档案列表
   */
  async getUserProfiles(userId) {
    try {
      return await NutritionProfile.find({ userId });
    } catch (error) {
      throw new Error(`获取用户营养档案列表失败: ${error.message}`);
    }
  },

  /**
   * 获取用户的主营养档案
   * @param {String} userId - 用户ID
   * @returns {Promise<Object>} - 用户的主营养档案
   */
  async getPrimaryProfile(userId) {
    try {
      const primaryProfile = await NutritionProfile.findOne({ 
        userId: userId,
        isPrimary: true 
      });
      
      if (!primaryProfile) {
        // 如果没有找到主档案，尝试获取用户的任意一个档案
        const anyProfile = await NutritionProfile.findOne({ userId });
        return anyProfile;
      }
      
      return primaryProfile;
    } catch (error) {
      throw new Error(`获取主营养档案失败: ${error.message}`);
    }
  },

  /**
   * 更新营养档案
   * @param {String} profileId - 营养档案ID
   * @param {Object} updateData - 更新的数据
   * @returns {Promise<Object>} - 更新后的营养档案
   */
  async updateProfile(profileId, updateData) {
    try {
      const profile = await NutritionProfile.findByIdAndUpdate(
        profileId,
        { 
          $set: { ...updateData },
          $inc: { version: 1 } // 增加版本号
        },
        { new: true, runValidators: true }
      );
      
      if (!profile) {
        throw new Error('营养档案不存在');
      }
      
      return profile;
    } catch (error) {
      throw new Error(`更新营养档案失败: ${error.message}`);
    }
  },

  /**
   * 删除营养档案
   * @param {String} profileId - 营养档案ID
   * @returns {Promise<Boolean>} - 删除操作结果
   */
  async deleteProfile(profileId) {
    try {
      const result = await NutritionProfile.findByIdAndDelete(profileId);
      if (!result) {
        throw new Error('营养档案不存在');
      }
      return true;
    } catch (error) {
      throw new Error(`删除营养档案失败: ${error.message}`);
    }
  },

  /**
   * 设置主营养档案
   * @param {String} userId - 用户ID
   * @param {String} profileId - 要设为主档案的ID
   * @returns {Promise<Object>} - 设置后的主营养档案
   */
  async setPrimaryProfile(userId, profileId) {
    try {
      // 先将用户所有档案设为非主档案
      await NutritionProfile.updateMany(
        { userId: userId },
        { isPrimary: false }
      );
      
      // 将指定档案设为主档案
      const primaryProfile = await NutritionProfile.findByIdAndUpdate(
        profileId,
        { isPrimary: true },
        { new: true }
      );
      
      if (!primaryProfile) {
        throw new Error('指定的营养档案不存在');
      }
      
      return primaryProfile;
    } catch (error) {
      throw new Error(`设置主营养档案失败: ${error.message}`);
    }
  },

  /**
   * 更新营养档案的健康指标
   * @param {String} profileId - 营养档案ID
   * @param {Object} healthMetrics - 健康指标数据
   * @returns {Promise<Object>} - 更新后的营养档案
   */
  async updateHealthMetrics(profileId, healthMetrics) {
    try {
      const profile = await NutritionProfile.findByIdAndUpdate(
        profileId,
        { 
          $set: { health_metrics: healthMetrics },
          $inc: { version: 1 }
        },
        { new: true }
      );
      
      if (!profile) {
        throw new Error('营养档案不存在');
      }
      
      return profile;
    } catch (error) {
      throw new Error(`更新健康指标失败: ${error.message}`);
    }
  },

  /**
   * 更新营养目标
   * @param {String} profileId - 营养档案ID
   * @param {Object} nutritionTargets - 营养目标数据
   * @returns {Promise<Object>} - 更新后的营养档案
   */
  async updateNutritionTargets(profileId, nutritionTargets) {
    try {
      const profile = await NutritionProfile.findByIdAndUpdate(
        profileId,
        { 
          $set: { nutrition_targets: nutritionTargets },
          $inc: { version: 1 }
        },
        { new: true }
      );
      
      if (!profile) {
        throw new Error('营养档案不存在');
      }
      
      return profile;
    } catch (error) {
      throw new Error(`更新营养目标失败: ${error.message}`);
    }
  },

  /**
   * 授权访问营养档案
   * @param {String} profileId - 营养档案ID
   * @param {Object} grantData - 授权数据
   * @returns {Promise<Object>} - 更新后的营养档案
   */
  async grantAccess(profileId, grantData) {
    try {
      const profile = await NutritionProfile.findByIdAndUpdate(
        profileId,
        { 
          $push: { access_grants: grantData },
          $inc: { version: 1 }
        },
        { new: true }
      );
      
      if (!profile) {
        throw new Error('营养档案不存在');
      }
      
      return profile;
    } catch (error) {
      throw new Error(`授权访问营养档案失败: ${error.message}`);
    }
  },

  /**
   * 撤销授权访问
   * @param {String} profileId - 营养档案ID
   * @param {String} grantId - 授权记录ID
   * @returns {Promise<Object>} - 更新后的营养档案
   */
  async revokeAccess(profileId, grantId) {
    try {
      const profile = await NutritionProfile.findOneAndUpdate(
        { 
          _id: profileId, 
          'access_grants._id': grantId
        },
        { 
          $set: { 
            'access_grants.$.revoked': true,
            'access_grants.$.revoked_at': new Date()
          },
          $inc: { version: 1 }
        },
        { new: true }
      );
      
      if (!profile) {
        throw new Error('营养档案或授权记录不存在');
      }
      
      return profile;
    } catch (error) {
      throw new Error(`撤销授权失败: ${error.message}`);
    }
  }
};

module.exports = nutritionProfileService; 