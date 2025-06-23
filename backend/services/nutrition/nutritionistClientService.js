/**
 * 营养师客户管理服务模块
 * 提供营养师管理客户的核心业务逻辑
 * @module services/nutrition/nutritionistClientService
 */

const NutritionistClient = require('../../models/nutrition/nutritionistClientModel');
const User = require('../../models/user/userModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const Consultation = require('../../models/consult/consultationModel');
const mongoose = require('mongoose');
const logger = require('../../config/modules/logger');

const nutritionistClientService = {
  /**
   * 获取营养师的客户列表
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 筛选选项
   * @returns {Promise<Object>} 客户列表
   */
  async getNutritionistClients(nutritionistId, options = {}) {
    try {
      if (!mongoose.Types.ObjectId.isValid(nutritionistId)) {
        return { success: false, message: '无效的营养师ID' };
      }

      const result = await NutritionistClient.getNutritionistClients(nutritionistId, options);
      
      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取营养师客户列表失败', { error, nutritionistId, options });
      return {
        success: false,
        message: `获取客户列表失败: ${error.message}`
      };
    }
  },

  /**
   * 获取客户详情
   * @param {string} nutritionistId - 营养师ID
   * @param {string} clientUserId - 客户用户ID
   * @returns {Promise<Object>} 客户详情
   */
  async getClientDetail(nutritionistId, clientUserId) {
    try {
      if (!mongoose.Types.ObjectId.isValid(nutritionistId) || 
          !mongoose.Types.ObjectId.isValid(clientUserId)) {
        return { success: false, message: '无效的ID参数' };
      }

      const client = await NutritionistClient.getClientDetail(nutritionistId, clientUserId);
      
      if (!client) {
        return { success: false, message: '客户不存在或无权访问' };
      }

      // 获取客户的咨询历史
      const consultations = await Consultation.find({
        $or: [
          { userId: clientUserId, nutritionistId: nutritionistId },
          { userId: clientUserId, assignedNutritionistId: nutritionistId }
        ]
      })
      .sort({ createdAt: -1 })
      .limit(10)
      .select('topic consultationType status createdAt startTime endTime userRating');

      const result = {
        ...client.toObject(),
        recentConsultations: consultations
      };

      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取客户详情失败', { error, nutritionistId, clientUserId });
      return {
        success: false,
        message: `获取客户详情失败: ${error.message}`
      };
    }
  },

  /**
   * 添加客户
   * @param {Object} clientData - 客户数据
   * @returns {Promise<Object>} 添加结果
   */
  async addClient(clientData) {
    try {
      const { nutritionistId, clientUserId } = clientData;

      // 验证用户是否存在
      const user = await User.findById(clientUserId);
      if (!user) {
        return { success: false, message: '用户不存在' };
      }

      // 检查是否已存在客户关系
      const existingClient = await NutritionistClient.findOne({
        nutritionistId,
        clientUserId
      });

      if (existingClient) {
        return { success: false, message: '该用户已是您的客户' };
      }

      // 创建客户关系
      const client = new NutritionistClient(clientData);
      await client.save();

      // 更新咨询统计
      await client.updateConsultationStats();

      // 返回详细信息
      const populatedClient = await NutritionistClient.findById(client._id)
        .populate('clientUser', 'username nickname avatar gender age email');

      return {
        success: true,
        data: populatedClient,
        message: '客户添加成功'
      };
    } catch (error) {
      logger.error('添加客户失败', { error, clientData });
      return {
        success: false,
        message: `添加客户失败: ${error.message}`
      };
    }
  },

  /**
   * 更新客户信息
   * @param {string} nutritionistId - 营养师ID
   * @param {string} clientUserId - 客户用户ID
   * @param {Object} updateData - 更新数据
   * @returns {Promise<Object>} 更新结果
   */
  async updateClientInfo(nutritionistId, clientUserId, updateData) {
    try {
      const client = await NutritionistClient.findOne({
        nutritionistId,
        clientUserId
      });

      if (!client) {
        return { success: false, message: '客户不存在' };
      }

      // 允许更新的字段
      const allowedFields = [
        'clientTags',
        'nutritionistNotes',
        'healthOverview',
        'relationshipStatus'
      ];

      Object.keys(updateData).forEach(key => {
        if (allowedFields.includes(key)) {
          if (key === 'healthOverview') {
            // 合并健康概况数据
            client.healthOverview = {
              ...client.healthOverview,
              ...updateData[key],
              lastUpdated: new Date()
            };
          } else {
            client[key] = updateData[key];
          }
        }
      });

      await client.save();

      return {
        success: true,
        data: client,
        message: '客户信息更新成功'
      };
    } catch (error) {
      logger.error('更新客户信息失败', { error, nutritionistId, clientUserId, updateData });
      return {
        success: false,
        message: `更新客户信息失败: ${error.message}`
      };
    }
  },

  /**
   * 添加客户进展记录
   * @param {string} nutritionistId - 营养师ID
   * @param {string} clientUserId - 客户用户ID
   * @param {Object} progressData - 进展数据
   * @returns {Promise<Object>} 添加结果
   */
  async addProgressEntry(nutritionistId, clientUserId, progressData) {
    try {
      const client = await NutritionistClient.findOne({
        nutritionistId,
        clientUserId
      });

      if (!client) {
        return { success: false, message: '客户不存在' };
      }

      await client.addProgressEntry(progressData);

      return {
        success: true,
        data: client,
        message: '进展记录添加成功'
      };
    } catch (error) {
      logger.error('添加客户进展记录失败', { error, nutritionistId, clientUserId, progressData });
      return {
        success: false,
        message: `添加进展记录失败: ${error.message}`
      };
    }
  },

  /**
   * 设置客户目标
   * @param {string} nutritionistId - 营养师ID
   * @param {string} clientUserId - 客户用户ID
   * @param {Object} goalData - 目标数据
   * @returns {Promise<Object>} 设置结果
   */
  async setClientGoal(nutritionistId, clientUserId, goalData) {
    try {
      const client = await NutritionistClient.findOne({
        nutritionistId,
        clientUserId
      });

      if (!client) {
        return { success: false, message: '客户不存在' };
      }

      client.progressTracking.goals.push({
        ...goalData,
        createdAt: new Date()
      });

      await client.save();

      return {
        success: true,
        data: client,
        message: '客户目标设置成功'
      };
    } catch (error) {
      logger.error('设置客户目标失败', { error, nutritionistId, clientUserId, goalData });
      return {
        success: false,
        message: `设置客户目标失败: ${error.message}`
      };
    }
  },

  /**
   * 更新目标进度
   * @param {string} nutritionistId - 营养师ID
   * @param {string} clientUserId - 客户用户ID
   * @param {string} goalId - 目标ID
   * @param {number} currentValue - 当前值
   * @param {string} notes - 备注
   * @returns {Promise<Object>} 更新结果
   */
  async updateGoalProgress(nutritionistId, clientUserId, goalId, currentValue, notes) {
    try {
      const client = await NutritionistClient.findOne({
        nutritionistId,
        clientUserId
      });

      if (!client) {
        return { success: false, message: '客户不存在' };
      }

      await client.updateGoalProgress(goalId, currentValue, notes);

      return {
        success: true,
        data: client,
        message: '目标进度更新成功'
      };
    } catch (error) {
      logger.error('更新目标进度失败', { error, nutritionistId, clientUserId, goalId });
      return {
        success: false,
        message: `更新目标进度失败: ${error.message}`
      };
    }
  },

  /**
   * 添加客户提醒
   * @param {string} nutritionistId - 营养师ID
   * @param {string} clientUserId - 客户用户ID
   * @param {Object} reminderData - 提醒数据
   * @returns {Promise<Object>} 添加结果
   */
  async addClientReminder(nutritionistId, clientUserId, reminderData) {
    try {
      const client = await NutritionistClient.findOne({
        nutritionistId,
        clientUserId
      });

      if (!client) {
        return { success: false, message: '客户不存在' };
      }

      await client.addReminder(reminderData);

      return {
        success: true,
        data: client,
        message: '客户提醒添加成功'
      };
    } catch (error) {
      logger.error('添加客户提醒失败', { error, nutritionistId, clientUserId, reminderData });
      return {
        success: false,
        message: `添加客户提醒失败: ${error.message}`
      };
    }
  },

  /**
   * 完成客户提醒
   * @param {string} nutritionistId - 营养师ID
   * @param {string} clientUserId - 客户用户ID
   * @param {string} reminderId - 提醒ID
   * @returns {Promise<Object>} 完成结果
   */
  async completeClientReminder(nutritionistId, clientUserId, reminderId) {
    try {
      const client = await NutritionistClient.findOne({
        nutritionistId,
        clientUserId
      });

      if (!client) {
        return { success: false, message: '客户不存在' };
      }

      await client.completeReminder(reminderId);

      return {
        success: true,
        data: client,
        message: '提醒完成成功'
      };
    } catch (error) {
      logger.error('完成客户提醒失败', { error, nutritionistId, clientUserId, reminderId });
      return {
        success: false,
        message: `完成提醒失败: ${error.message}`
      };
    }
  },

  /**
   * 获取客户统计数据
   * @param {string} nutritionistId - 营养师ID
   * @returns {Promise<Object>} 统计数据
   */
  async getClientStats(nutritionistId) {
    try {
      if (!mongoose.Types.ObjectId.isValid(nutritionistId)) {
        return { success: false, message: '无效的营养师ID' };
      }

      const stats = await NutritionistClient.aggregate([
        { $match: { nutritionistId: mongoose.Types.ObjectId(nutritionistId) } },
        {
          $group: {
            _id: null,
            totalClients: { $sum: 1 },
            activeClients: {
              $sum: { $cond: [{ $eq: ['$relationshipStatus', 'active'] }, 1, 0] }
            },
            inactiveClients: {
              $sum: { $cond: [{ $eq: ['$relationshipStatus', 'inactive'] }, 1, 0] }
            },
            totalConsultations: { $sum: '$consultationStats.totalConsultations' },
            averageRelationshipDuration: { $avg: '$relationshipDuration' },
            clientsWithPendingReminders: {
              $sum: { $cond: [{ $gt: ['$pendingReminders', 0] }, 1, 0] }
            }
          }
        }
      ]);

      // 获取最近活跃的客户
      const recentActiveClients = await NutritionistClient.find({
        nutritionistId,
        'consultationStats.lastConsultationDate': {
          $gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000) // 最近30天
        }
      })
      .populate('clientUser', 'username nickname avatar')
      .sort({ 'consultationStats.lastConsultationDate': -1 })
      .limit(5);

      // 获取需要关注的客户（长时间未咨询）
      const clientsNeedingAttention = await NutritionistClient.find({
        nutritionistId,
        relationshipStatus: 'active',
        'consultationStats.lastConsultationDate': {
          $lt: new Date(Date.now() - 60 * 24 * 60 * 60 * 1000) // 超过60天未咨询
        }
      })
      .populate('clientUser', 'username nickname avatar')
      .sort({ 'consultationStats.lastConsultationDate': 1 })
      .limit(5);

      const result = {
        overview: stats[0] || {
          totalClients: 0,
          activeClients: 0,
          inactiveClients: 0,
          totalConsultations: 0,
          averageRelationshipDuration: 0,
          clientsWithPendingReminders: 0
        },
        recentActiveClients,
        clientsNeedingAttention
      };

      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取客户统计失败', { error, nutritionistId });
      return {
        success: false,
        message: `获取客户统计失败: ${error.message}`
      };
    }
  },

  /**
   * 搜索潜在客户
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 搜索选项
   * @returns {Promise<Object>} 搜索结果
   */
  async searchPotentialClients(nutritionistId, options = {}) {
    try {
      const { keyword, limit = 10 } = options;

      // 获取已有的客户ID列表
      const existingClients = await NutritionistClient.find({
        nutritionistId
      }).select('clientUserId');

      const existingClientIds = existingClients.map(client => client.clientUserId);

      // 搜索用户，排除已有客户
      const query = {
        _id: { $nin: existingClientIds }
      };

      if (keyword) {
        query.$or = [
          { username: { $regex: keyword, $options: 'i' } },
          { nickname: { $regex: keyword, $options: 'i' } },
          { email: { $regex: keyword, $options: 'i' } }
        ];
      }

      const potentialClients = await User.find(query)
        .select('username nickname avatar email gender age')
        .limit(limit);

      return {
        success: true,
        data: potentialClients
      };
    } catch (error) {
      logger.error('搜索潜在客户失败', { error, nutritionistId, options });
      return {
        success: false,
        message: `搜索潜在客户失败: ${error.message}`
      };
    }
  },

  /**
   * 获取客户营养计划历史
   * @param {string} nutritionistId - 营养师ID
   * @param {string} clientUserId - 客户用户ID
   * @returns {Promise<Object>} 营养计划历史
   */
  async getClientNutritionPlanHistory(nutritionistId, clientUserId) {
    try {
      const client = await NutritionistClient.findOne({
        nutritionistId,
        clientUserId
      }).populate('nutritionPlanHistory.planId');

      if (!client) {
        return { success: false, message: '客户不存在' };
      }

      return {
        success: true,
        data: client.nutritionPlanHistory
      };
    } catch (error) {
      logger.error('获取客户营养计划历史失败', { error, nutritionistId, clientUserId });
      return {
        success: false,
        message: `获取营养计划历史失败: ${error.message}`
      };
    }
  },

  /**
   * 根据客户ID数组获取客户信息
   * @param {Array<string>} clientIds - 客户ID数组
   * @param {string} nutritionistId - 营养师ID（可选，用于验证权限）
   * @returns {Promise<Array>} 客户列表
   */
  async getClientsByIds(clientIds, nutritionistId = null) {
    try {
      if (!Array.isArray(clientIds) || clientIds.length === 0) {
        return [];
      }

      // 验证所有ID格式
      const validIds = clientIds.filter(id => mongoose.Types.ObjectId.isValid(id));
      if (validIds.length === 0) {
        return [];
      }

      // 构建查询条件
      const query = { clientUserId: { $in: validIds } };
      
      // 如果提供了营养师ID，则添加权限验证
      if (nutritionistId && mongoose.Types.ObjectId.isValid(nutritionistId)) {
        query.nutritionistId = nutritionistId;
      }

      const clients = await NutritionistClient.find(query)
        .populate('clientUserId', 'nickname phone email profilePhoto')
        .populate('nutritionistId', 'personalInfo.name')
        .select('nutritionistId clientUserId relationshipStatus healthOverview consultationStats')
        .lean();

      return clients;
    } catch (error) {
      logger.error('根据ID数组获取客户失败', { error, clientIds, nutritionistId });
      return [];
    }
  }
};

module.exports = nutritionistClientService;