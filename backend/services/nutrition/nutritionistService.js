/**
 * 营养师服务模块（nutritionistService）
 * 提供对营养师资料的完整管理，包括创建、查询、修改、删除、审核、评分等功能
 * 与 nutritionistModel 模型配合，为用户提供认证、咨询、推荐等服务基础
 * 通过 userId 支持跨模型联合查询，支持分页筛选与专业字段过滤
 * 所有方法返回统一的 { success, data, message } 结构
 * @module services/nutrition/nutritionistService
 */
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const mongoose = require('mongoose');
const User = require('../../models/user/userModel');
const logger = require('../../utils/logger/winstonLogger.js');

const nutritionistService = {
  /**
   * 创建营养师
   * 
   * @param {Object} data - 营养师数据
   * @returns {Promise<Object>} 创建的营养师
   */
  async createNutritionist(data) {
    try {
      // 检查是否已存在
      const existingNutritionist = await Nutritionist.findOne({ userId: data.userId });
      
      if (existingNutritionist) {
        return { success: false, message: '该用户已经有营养师资料' };
      }
      
      const nutritionist = new Nutritionist(data);
      await nutritionist.save();
      
      return { success: true, data: nutritionist };
    } catch (error) {
      logger.error('创建营养师失败', { error, data });
      return { success: false, message: `创建营养师失败: ${error.message}` };
    }
  },

  /**
   * 获取营养师列表
   * 
   * @param {Object} options - 过滤选项
   * @returns {Promise<Object>} 营养师列表
   */
  async getNutritionists(options = {}) {
    try {
      const { 
        specialization, 
        minRating,
        consultationFeeRange,
        limit = 10, 
        skip = 0, 
        sort = { 'ratings.averageRating': -1 } 
      } = options;

      const query = { status: 'active' };
      
      if (specialization) {
        query['professionalInfo.specializations'] = specialization;
      }
      
      if (minRating) {
        query['ratings.averageRating'] = { $gte: minRating };
      }
      
      if (consultationFeeRange) {
        query['serviceInfo.consultationFee'] = { 
          $gte: consultationFeeRange.min || 0,
          $lte: consultationFeeRange.max || Number.MAX_SAFE_INTEGER
        };
      }

      const [nutritionists, total] = await Promise.all([
        Nutritionist.find(query)
          .populate('user', 'username email')
          .sort(sort)
          .skip(skip)
          .limit(limit),
        Nutritionist.countDocuments(query)
      ]);

      return {
        success: true,
        data: nutritionists,
        pagination: {
          total,
          limit,
          skip,
          hasMore: total > skip + limit
        }
      };
    } catch (error) {
      logger.error('获取营养师列表失败', { error, options });
      return { success: false, message: `获取营养师列表失败: ${error.message}` };
    }
  },

  /**
   * 根据ID获取营养师
   * 
   * @param {string} id - 营养师ID
   * @returns {Promise<Object>} 营养师详情
   */
  async getNutritionistById(id) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的营养师ID' };
      }
      
      const nutritionist = await Nutritionist.findById(id)
        .populate('user', 'username email profileImage');
      
      if (!nutritionist) {
        return { success: false, message: '找不到指定的营养师' };
      }
      
      return { success: true, data: nutritionist };
    } catch (error) {
      logger.error('获取营养师详情失败', { error, id });
      return { success: false, message: `获取营养师详情失败: ${error.message}` };
    }
  },

  /**
   * 更新营养师
   * 
   * @param {string} id - 营养师ID
   * @param {Object} data - 更新数据
   * @returns {Promise<Object>} 更新后的营养师
   */
  async updateNutritionist(id, data) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的营养师ID' };
      }
      
      const nutritionist = await Nutritionist.findById(id);
      
      if (!nutritionist) {
        return { success: false, message: '找不到指定的营养师' };
      }
      
      // 更新可修改的字段
      if (data.personalInfo) {
        Object.assign(nutritionist.personalInfo, data.personalInfo);
      }
      
      if (data.qualifications) {
        Object.assign(nutritionist.qualifications, data.qualifications);
      }
      
      if (data.professionalInfo) {
        Object.assign(nutritionist.professionalInfo, data.professionalInfo);
      }
      
      if (data.serviceInfo) {
        Object.assign(nutritionist.serviceInfo, data.serviceInfo);
      }
      
      if (data.affiliations) {
        nutritionist.affiliations = data.affiliations;
      }
      
      await nutritionist.save();
      
      return { success: true, data: nutritionist };
    } catch (error) {
      logger.error('更新营养师失败', { error, id, data });
      return { success: false, message: `更新营养师失败: ${error.message}` };
    }
  },

  /**
   * 删除营养师
   * 
   * @param {string} id - 营养师ID
   * @returns {Promise<Object>} 操作结果
   */
  async deleteNutritionist(id) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的营养师ID' };
      }
      
      const result = await Nutritionist.findByIdAndDelete(id);
      
      if (!result) {
        return { success: false, message: '找不到指定的营养师' };
      }
      
      return { success: true, message: '营养师信息已成功删除' };
    } catch (error) {
      logger.error('删除营养师失败', { error, id });
      return { success: false, message: `删除营养师失败: ${error.message}` };
    }
  },

  /**
   * 审核营养师资质
   * 
   * @param {string} id - 营养师ID
   * @param {Object} verificationData - 审核数据
   * @returns {Promise<Object>} 更新后的营养师
   */
  async verifyNutritionist(id, verificationData) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的营养师ID' };
      }
      
      const nutritionist = await Nutritionist.findById(id);
      
      if (!nutritionist) {
        return { success: false, message: '找不到指定的营养师' };
      }
      
      // 更新审核信息
      if (!nutritionist.verification) {
        nutritionist.verification = {};
      }
      
      nutritionist.verification.verificationStatus = verificationData.verificationStatus;
      
      if (verificationData.rejectedReason) {
        nutritionist.verification.rejectedReason = verificationData.rejectedReason;
      }
      
      nutritionist.verification.reviewedBy = verificationData.reviewedBy;
      nutritionist.verification.reviewedAt = verificationData.reviewedAt;
      
      // 根据审核结果更新状态
      if (verificationData.verificationStatus === 'approved') {
        nutritionist.status = 'active';
        nutritionist.qualifications.verified = true;
      } else if (verificationData.verificationStatus === 'rejected') {
        nutritionist.status = 'inactive';
      }
      
      await nutritionist.save();
      
      return { success: true, data: nutritionist };
    } catch (error) {
      logger.error('审核营养师失败', { error, id, verificationData });
      return { success: false, message: `审核营养师失败: ${error.message}` };
    }
  },

  /**
   * 根据用户ID获取营养师
   * 
   * @param {string} userId - 用户ID
   * @returns {Promise<Object>} 营养师详情
   */
  async getNutritionistByUserId(userId) {
    try {
      if (!mongoose.Types.ObjectId.isValid(userId)) {
        return { success: false, message: '无效的用户ID' };
      }
      
      // 先查找用户信息，使用User模型的fullProfile查询助手
      const user = await User.findById(userId).fullProfile();
      if (!user) {
        return { success: false, message: '找不到用户' };
      }
      
      const nutritionist = await Nutritionist.findOne({ userId });
      
      if (!nutritionist) {
        return { success: false, message: '找不到此用户的营养师资料' };
      }
      
      // 将用户信息附加到营养师对象上
      nutritionist.userProfile = user;
      
      return { success: true, data: nutritionist };
    } catch (error) {
      logger.error('根据用户ID获取营养师失败', { error, userId });
      return { success: false, message: `获取营养师详情失败: ${error.message}` };
    }
  },

  /**
   * 更新营养师评分
   * 
   * @param {string} id - 营养师ID
   * @param {number} rating - 新评分
   * @returns {Promise<Object>} 更新后的营养师
   */
  async updateNutritionistRating(id, rating) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的营养师ID' };
      }
      
      const nutritionist = await Nutritionist.findById(id);
      
      if (!nutritionist) {
        return { success: false, message: '找不到指定的营养师' };
      }
      
      // 更新评分
      const oldTotal = nutritionist.ratings.averageRating * nutritionist.ratings.totalReviews;
      nutritionist.ratings.totalReviews += 1;
      nutritionist.ratings.averageRating = (oldTotal + rating) / nutritionist.ratings.totalReviews;
      
      await nutritionist.save();
      
      return { success: true, data: nutritionist };
    } catch (error) {
      logger.error('更新营养师评分失败', { error, id, rating });
      return { success: false, message: `更新营养师评分失败: ${error.message}` };
    }
  }
};

module.exports = nutritionistService;