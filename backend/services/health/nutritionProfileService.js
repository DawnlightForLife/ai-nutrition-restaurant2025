/**
 * 营养档案服务
 * 处理与用户营养档案相关的业务逻辑
 * @module services/health/nutritionProfileService
 */
const NutritionProfile = require("../../models/health/nutritionProfileModel");
const AppError = require("../../utils/appError");
const mongoose = require("mongoose");
const { Types } = mongoose;

const nutritionProfileService = {
  /**
   * 创建新的营养档案
   * @param {Object} profileData - 档案数据
   * @returns {Promise<Object>} 创建的营养档案
   */
  async createProfile(profileData) {
    // 检查用户是否已有主档案，如果没有，将这个设为主档案
    if (profileData.isPrimary === undefined) {
      const existingProfiles = await NutritionProfile.countDocuments({
        userId: profileData.userId
      });
      
      if (existingProfiles === 0) {
        profileData.isPrimary = true;
      }
    }
    
    // 如果这个档案被设置为主档案，需要将其他档案的主档案标识设为false
    if (profileData.isPrimary) {
      await NutritionProfile.updateMany(
        { userId: profileData.userId },
        { $set: { isPrimary: false } }
      );
    }
    
    // 使用create方法创建文档
    const profile = await NutritionProfile.create(profileData);
    return profile;
  },
  
  /**
   * 获取用户的所有营养档案
   * @param {String} userId - 用户ID
   * @param {Object} options - 查询选项(分页、排序等)
   * @returns {Promise<Object>} 档案列表和分页信息
   */
  async getUserProfiles(userId, options = {}) {
    const query = { userId: userId };
    
    // 除非特别指定，否则默认不包含已归档的档案
    if (!options.include_archived) {
      query.archived = { $ne: true };
    }
    
    // 设置分页
    const page = options.page || 1;
    const limit = options.limit || 10;
    const skip = (page - 1) * limit;
    
    // 设置排序
    const sort = options.sort || { createdAt: -1 };
    
    try {
      // 执行查询
      const profiles = await NutritionProfile.find(query)
        .sort(sort)
        .skip(skip)
        .limit(limit);
        
      // 计算总数
      const total = await NutritionProfile.countDocuments(query);
      
      return {
        profiles,
        pagination: {
          total,
          page,
          limit,
          pages: Math.ceil(total / limit)
        }
      };
    } catch (error) {
      console.error("获取档案列表失败:", error);
      throw new AppError("获取档案列表失败", 500);
    }
  },
  
  /**
   * 获取用户的主营养档案
   * @param {String} userId - 用户ID
   * @returns {Promise<Object>} 主营养档案
   */
  async getPrimaryProfile(userId) {
    const profile = await NutritionProfile.findOne({
      userId: userId,
      isPrimary: true,
      archived: { $ne: true }
    });
    
    return profile;
  },
  
  /**
   * 根据ID获取营养档案
   * @param {String} profileId - 档案ID
   * @param {String} userId - 用户ID（可选）
   * @returns {Promise<Object>} 营养档案
   */
  async getProfileById(profileId, userId) {
    try {
      let query = { _id: new Types.ObjectId(profileId) };
      
      // 如果提供了userId，添加到查询条件
      if (userId) {
        query.userId = new Types.ObjectId(userId);
      }
      
      const profile = await NutritionProfile.findOne(query);
      
      if (!profile) {
        throw new AppError("未找到指定的营养档案", 404);
      }
      
      return profile;
    } catch (error) {
      if (error.name === 'CastError') {
        throw new AppError("档案ID格式无效", 400);
      }
      throw error;
    }
  },
  
  /**
   * 更新营养档案
   * @param {String} profileId - 档案ID
   * @param {Object} updateData - 更新数据
   * @returns {Promise<Object>} 更新后的档案
   */
  async updateProfile(profileId, updateData) {
    // 如果设置为主档案，需要将其他档案的主档案标识设为false
    if (updateData.isPrimary) {
      const profile = await NutritionProfile.findById(profileId);
      if (profile) {
        await NutritionProfile.updateMany(
          { userId: profile.userId, _id: { $ne: profileId } },
          { $set: { isPrimary: false } }
        );
      }
    }
    
    const updatedProfile = await NutritionProfile.findByIdAndUpdate(
      profileId,
      updateData,
      { new: true, runValidators: true }
    );
    
    if (!updatedProfile) {
      throw new AppError("未找到指定的营养档案", 404);
    }
    
    return updatedProfile;
  },
  
  /**
   * 删除营养档案
   * @param {String} profileId - 档案ID
   * @param {String} userId - 用户ID（可选）
   * @returns {Promise<boolean>} 删除成功返回true
   */
  async deleteProfile(profileId, userId) {
    try {
      // 构建查询条件
      let query = { _id: new Types.ObjectId(profileId) };
      
      // 如果提供了userId，添加到查询条件以确保安全性
      if (userId) {
        query.userId = new Types.ObjectId(userId);
      }
      
      // 查找要删除的档案（用于检查是否为主档案）
      const profile = await NutritionProfile.findOne(query);
      
      if (!profile) {
        throw new AppError("未找到指定的营养档案", 404);
      }
      
      // 使用findOneAndDelete直接删除文档
      const deletedProfile = await NutritionProfile.findOneAndDelete(query);
      
      if (!deletedProfile) {
        throw new AppError("删除营养档案失败", 500);
      }
      
      // 如果删除的是主档案，需要重新设置一个主档案
      if (profile.isPrimary) {
        const nextProfile = await NutritionProfile.findOne({
          userId: profile.userId,
          archived: { $ne: true }
        });
        
        if (nextProfile) {
          await NutritionProfile.findByIdAndUpdate(
            nextProfile._id,
            { isPrimary: true }
          );
        }
      }
      
      return true;
    } catch (error) {
      if (error.name === 'CastError') {
        throw new AppError("档案ID格式无效", 400);
      }
      throw error;
    }
  },
  
  /**
   * 归档营养档案（软删除）
   * @param {String} profileId - 档案ID
   * @returns {Promise<Object>} 归档后的档案
   */
  async archiveProfile(profileId) {
    const profile = await NutritionProfile.findById(profileId);
    
    if (!profile) {
      throw new AppError("未找到指定的营养档案", 404);
    }
    
    // 如果归档的是主档案，需要重新设置一个主档案
    if (profile.isPrimary) {
      const nextProfile = await NutritionProfile.findOne({
        userId: profile.userId,
        _id: { $ne: profileId },
        archived: { $ne: true }
      });
      
      if (nextProfile) {
        await NutritionProfile.findByIdAndUpdate(
          nextProfile._id,
          { isPrimary: true }
        );
      }
    }
    
    const archivedProfile = await NutritionProfile.findByIdAndUpdate(
      profileId,
      { archived: true, isPrimary: false },
      { new: true }
    );
    
    return archivedProfile;
  },
  
  /**
   * 恢复已归档的营养档案
   * @param {String} profileId - 档案ID
   * @returns {Promise<Object>} 恢复后的档案
   */
  async restoreProfile(profileId) {
    const restoredProfile = await NutritionProfile.findByIdAndUpdate(
      profileId,
      { archived: false },
      { new: true }
    );
    
    if (!restoredProfile) {
      throw new AppError("未找到指定的营养档案", 404);
    }
    
    return restoredProfile;
  },
  
  /**
   * 更新营养目标
   * @param {String} profileId - 档案ID
   * @param {Object} nutritionGoals - 营养目标数据
   * @returns {Promise<Object>} 更新后的档案
   */
  async updateNutritionGoals(profileId, nutritionGoals) {
    const updatedProfile = await NutritionProfile.findByIdAndUpdate(
      profileId,
      { nutritionGoals },
      { new: true, runValidators: true }
    );
    
    if (!updatedProfile) {
      throw new AppError("未找到指定的营养档案", 404);
    }
    
    return updatedProfile;
  },
  
  /**
   * 更新营养目标值
   * @param {String} profileId - 档案ID
   * @param {Object} nutritionTargets - 营养目标值数据
   * @returns {Promise<Object>} 更新后的档案
   */
  async updateNutritionTargets(profileId, nutritionTargets) {
    const updatedProfile = await NutritionProfile.findByIdAndUpdate(
      profileId,
      { nutritionTargets: nutritionTargets },
      { new: true, runValidators: true }
    );
    
    if (!updatedProfile) {
      throw new AppError("未找到指定的营养档案", 404);
    }
    
    return updatedProfile;
  }
};

module.exports = nutritionProfileService;
