/**
 * 咨询市场服务模块
 * 提供咨询市场的核心业务逻辑
 * @module services/consult/consultationMarketService
 */

const Consultation = require('../../models/consult/consultationModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const User = require('../../models/user/userModel');
const mongoose = require('mongoose');
const logger = require('../../config/modules/logger');

const consultationMarketService = {
  /**
   * 获取咨询市场列表
   * @param {Object} options - 筛选选项
   * @returns {Promise<Object>} 咨询市场列表
   */
  async getMarketConsultations(options = {}) {
    try {
      const result = await Consultation.getMarketConsultations(options);
      
      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取咨询市场列表失败', { error, options });
      return {
        success: false,
        message: `获取咨询市场列表失败: ${error.message}`
      };
    }
  },

  /**
   * 获取咨询市场统计数据
   * @returns {Promise<Object>} 市场统计数据
   */
  async getMarketStats() {
    try {
      const stats = await Consultation.getMarketStats();
      
      // 添加咨询类型统计
      const typeStats = {};
      if (stats.consultationTypes) {
        stats.consultationTypes.forEach(type => {
          typeStats[type] = (typeStats[type] || 0) + 1;
        });
      }
      
      const result = {
        ...stats,
        consultationTypeBreakdown: typeStats
      };
      
      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取市场统计失败', { error });
      return {
        success: false,
        message: `获取市场统计失败: ${error.message}`
      };
    }
  },

  /**
   * 营养师接受咨询
   * @param {string} consultationId - 咨询ID
   * @param {string} nutritionistId - 营养师ID
   * @returns {Promise<Object>} 接受结果
   */
  async acceptConsultation(consultationId, nutritionistId) {
    try {
      if (!mongoose.Types.ObjectId.isValid(consultationId)) {
        return { success: false, message: '无效的咨询ID' };
      }

      if (!mongoose.Types.ObjectId.isValid(nutritionistId)) {
        return { success: false, message: '无效的营养师ID' };
      }

      // 验证营养师状态
      const nutritionist = await Nutritionist.findById(nutritionistId);
      if (!nutritionist) {
        return { success: false, message: '营养师不存在' };
      }

      if (nutritionist.status !== 'active' || 
          nutritionist.verification.verificationStatus !== 'approved') {
        return { success: false, message: '营养师未通过认证或状态异常' };
      }

      // 检查营养师是否在线
      if (!nutritionist.onlineStatus.isOnline || !nutritionist.onlineStatus.isAvailable) {
        return { success: false, message: '营养师当前不在线或不可用' };
      }

      // 获取咨询信息
      const consultation = await Consultation.findById(consultationId);
      if (!consultation) {
        return { success: false, message: '咨询不存在' };
      }

      // 检查咨询状态
      if (consultation.status !== 'available') {
        return { success: false, message: '该咨询已被其他营养师接受或状态异常' };
      }

      // 检查专业匹配度
      if (!consultation.matchesNutritionistSpecialty(nutritionist.professionalInfo.specializations)) {
        logger.warn('营养师专业领域不匹配', {
          consultationId,
          nutritionistId,
          consultationTags: consultation.tags,
          nutritionistSpecializations: nutritionist.professionalInfo.specializations
        });
      }

      // 接受咨询
      await consultation.acceptByNutritionist(nutritionistId);

      // 发送通知给用户
      await this._notifyUserConsultationAccepted(consultation, nutritionist);

      // 返回更新后的咨询信息
      const updatedConsultation = await Consultation.findById(consultationId)
        .populate('userId', 'username nickname avatar')
        .populate('assignedNutritionistId', 'personalInfo professionalInfo');

      return {
        success: true,
        data: updatedConsultation,
        message: '成功接受咨询'
      };
    } catch (error) {
      logger.error('营养师接受咨询失败', { error, consultationId, nutritionistId });
      return {
        success: false,
        message: `接受咨询失败: ${error.message}`
      };
    }
  },

  /**
   * 获取营养师接受的咨询列表
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 筛选选项
   * @returns {Promise<Object>} 营养师咨询列表
   */
  async getNutritionistConsultations(nutritionistId, options = {}) {
    try {
      if (!mongoose.Types.ObjectId.isValid(nutritionistId)) {
        return { success: false, message: '无效的营养师ID' };
      }

      const result = await Consultation.getNutritionistAcceptedConsultations(nutritionistId, options);
      
      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取营养师咨询列表失败', { error, nutritionistId, options });
      return {
        success: false,
        message: `获取咨询列表失败: ${error.message}`
      };
    }
  },

  /**
   * 发布咨询到市场
   * @param {string} consultationId - 咨询ID
   * @param {string} userId - 用户ID
   * @returns {Promise<Object>} 发布结果
   */
  async publishConsultationToMarket(consultationId, userId) {
    try {
      if (!mongoose.Types.ObjectId.isValid(consultationId)) {
        return { success: false, message: '无效的咨询ID' };
      }

      const consultation = await Consultation.findById(consultationId);
      if (!consultation) {
        return { success: false, message: '咨询不存在' };
      }

      // 验证用户权限
      if (consultation.userId.toString() !== userId) {
        return { success: false, message: '无权发布此咨询' };
      }

      // 发布到市场
      await consultation.publishToMarket();

      return {
        success: true,
        data: consultation,
        message: '咨询已发布到市场'
      };
    } catch (error) {
      logger.error('发布咨询到市场失败', { error, consultationId, userId });
      return {
        success: false,
        message: `发布失败: ${error.message}`
      };
    }
  },

  /**
   * 创建咨询请求并发布到市场
   * @param {Object} consultationData - 咨询数据
   * @returns {Promise<Object>} 创建结果
   */
  async createMarketConsultation(consultationData) {
    try {
      // 验证必需字段
      const requiredFields = ['userId', 'topic', 'consultationType'];
      for (const field of requiredFields) {
        if (!consultationData[field]) {
          return { success: false, message: `缺少必需字段: ${field}` };
        }
      }

      // 创建咨询
      const consultation = new Consultation(consultationData);
      await consultation.save();

      // 发送通知给在线营养师
      await this._notifyOnlineNutritionists(consultation);

      return {
        success: true,
        data: consultation,
        message: '咨询请求已创建并发布到市场'
      };
    } catch (error) {
      logger.error('创建市场咨询失败', { error, consultationData });
      return {
        success: false,
        message: `创建咨询失败: ${error.message}`
      };
    }
  },

  /**
   * 获取咨询详情
   * @param {string} consultationId - 咨询ID
   * @param {Object} userInfo - 用户信息
   * @returns {Promise<Object>} 咨询详情
   */
  async getConsultationDetail(consultationId, userInfo = {}) {
    try {
      if (!mongoose.Types.ObjectId.isValid(consultationId)) {
        return { success: false, message: '无效的咨询ID' };
      }

      const consultation = await Consultation.findById(consultationId)
        .populate('userId', 'username nickname avatar gender age')
        .populate('nutritionistId', 'personalInfo professionalInfo onlineStatus')
        .populate('assignedNutritionistId', 'personalInfo professionalInfo onlineStatus');

      if (!consultation) {
        return { success: false, message: '咨询不存在' };
      }

      // 验证用户权限
      const { userId, nutritionistId } = userInfo;
      const hasAccess = 
        consultation.userId._id.toString() === userId ||
        consultation.nutritionistId?.toString() === nutritionistId ||
        consultation.assignedNutritionistId?._id.toString() === nutritionistId ||
        consultation.isMarketOpen; // 市场中的咨询可被营养师查看

      if (!hasAccess) {
        return { success: false, message: '无权查看此咨询' };
      }

      return {
        success: true,
        data: consultation
      };
    } catch (error) {
      logger.error('获取咨询详情失败', { error, consultationId, userInfo });
      return {
        success: false,
        message: `获取咨询详情失败: ${error.message}`
      };
    }
  },

  /**
   * 搜索咨询市场
   * @param {Object} searchOptions - 搜索选项
   * @returns {Promise<Object>} 搜索结果
   */
  async searchMarketConsultations(searchOptions = {}) {
    try {
      const {
        keyword,
        nutritionistSpecializations = [],
        consultationType,
        priority,
        tags = [],
        minBudget,
        maxBudget,
        sortBy = 'marketPublishedAt',
        sortOrder = 'desc',
        limit = 20,
        skip = 0
      } = searchOptions;

      const query = {
        isMarketOpen: true,
        status: 'available'
      };

      // 关键词搜索
      if (keyword) {
        query.$or = [
          { topic: { $regex: keyword, $options: 'i' } },
          { description: { $regex: keyword, $options: 'i' } },
          { tags: { $regex: keyword, $options: 'i' } }
        ];
      }

      // 其他筛选条件
      if (consultationType) query.consultationType = consultationType;
      if (priority) query.priority = priority;
      if (tags.length > 0) query.tags = { $in: tags };
      
      if (minBudget !== null || maxBudget !== null) {
        query.budget = {};
        if (minBudget !== null) query.budget.$gte = minBudget;
        if (maxBudget !== null) query.budget.$lte = maxBudget;
      }

      // 排序
      const sort = {};
      sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

      const consultations = await Consultation.find(query)
        .sort(sort)
        .skip(skip)
        .limit(limit)
        .populate('userId', 'username nickname avatar gender age');

      // 如果指定了营养师专业领域，进行匹配度筛选
      let filteredConsultations = consultations;
      if (nutritionistSpecializations.length > 0) {
        filteredConsultations = consultations.filter(consultation => 
          consultation.matchesNutritionistSpecialty(nutritionistSpecializations)
        );
      }

      const total = await Consultation.countDocuments(query);

      return {
        success: true,
        data: {
          consultations: filteredConsultations,
          pagination: {
            total,
            limit,
            skip,
            hasMore: total > skip + limit
          }
        }
      };
    } catch (error) {
      logger.error('搜索咨询市场失败', { error, searchOptions });
      return {
        success: false,
        message: `搜索失败: ${error.message}`
      };
    }
  },

  /**
   * 通知用户咨询被接受
   * @private
   * @param {Object} consultation - 咨询对象
   * @param {Object} nutritionist - 营养师对象
   */
  async _notifyUserConsultationAccepted(consultation, nutritionist) {
    try {
      // TODO: 实现推送通知逻辑
      logger.info('通知用户咨询被接受', {
        consultationId: consultation._id,
        userId: consultation.userId,
        nutritionistId: nutritionist._id,
        nutritionistName: nutritionist.personalInfo.realName
      });
    } catch (error) {
      logger.error('通知用户失败', { error });
    }
  },

  /**
   * 通知在线营养师有新的咨询
   * @private
   * @param {Object} consultation - 咨询对象
   */
  async _notifyOnlineNutritionists(consultation) {
    try {
      // 查找匹配的在线营养师
      const matchingNutritionists = await Nutritionist.find({
        'onlineStatus.isOnline': true,
        'onlineStatus.isAvailable': true,
        'verification.verificationStatus': 'approved',
        status: 'active'
      });

      // TODO: 通过WebSocket发送实时通知
      logger.info('通知在线营养师新咨询', {
        consultationId: consultation._id,
        matchingNutritionistsCount: matchingNutritionists.length,
        consultationType: consultation.consultationType,
        priority: consultation.priority
      });
    } catch (error) {
      logger.error('通知营养师失败', { error });
    }
  }
};

module.exports = consultationMarketService;