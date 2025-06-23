/**
 * 营养师统计分析服务模块
 * 提供营养师业绩统计、收入分析等功能
 * @module services/nutrition/nutritionistStatsService
 */

const Nutritionist = require('../../models/nutrition/nutritionistModel');
const NutritionistClient = require('../../models/nutrition/nutritionistClientModel');
const Consultation = require('../../models/consult/consultationModel');
const Payment = require('../../models/order/paymentModel');
const mongoose = require('mongoose');
const logger = require('../../config/modules/logger');

const nutritionistStatsService = {
  /**
   * 获取营养师综合统计数据
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 统计选项
   * @returns {Promise<Object>} 统计数据
   */
  async getNutritionistStats(nutritionistId, options = {}) {
    try {
      if (!mongoose.Types.ObjectId.isValid(nutritionistId)) {
        return { success: false, message: '无效的营养师ID' };
      }

      const {
        startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 默认30天前
        endDate = new Date(),
        period = 'month' // 'week', 'month', 'quarter', 'year'
      } = options;

      // 并行获取各项统计数据
      const [
        consultationStats,
        clientStats,
        incomeStats,
        performanceStats,
        reviewStats
      ] = await Promise.all([
        this._getConsultationStats(nutritionistId, startDate, endDate),
        this._getClientStats(nutritionistId, startDate, endDate),
        this._getIncomeStats(nutritionistId, startDate, endDate),
        this._getPerformanceStats(nutritionistId, startDate, endDate),
        this._getReviewStats(nutritionistId, startDate, endDate)
      ]);

      // 获取趋势数据
      const trendData = await this._getTrendData(nutritionistId, period, endDate);

      const result = {
        overview: {
          ...consultationStats,
          ...clientStats,
          ...incomeStats,
          ...performanceStats,
          ...reviewStats
        },
        trends: trendData,
        period: {
          startDate,
          endDate,
          period
        }
      };

      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取营养师统计失败', { error, nutritionistId, options });
      return {
        success: false,
        message: `获取统计数据失败: ${error.message}`
      };
    }
  },

  /**
   * 获取营养师收入详情
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 收入选项
   * @returns {Promise<Object>} 收入详情
   */
  async getNutritionistIncome(nutritionistId, options = {}) {
    try {
      if (!mongoose.Types.ObjectId.isValid(nutritionistId)) {
        return { success: false, message: '无效的营养师ID' };
      }

      const {
        startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
        endDate = new Date(),
        groupBy = 'day' // 'day', 'week', 'month'
      } = options;

      // 获取收入明细
      const incomeDetails = await this._getIncomeDetails(nutritionistId, startDate, endDate, groupBy);
      
      // 获取收入来源分析
      const incomeSourceAnalysis = await this._getIncomeSourceAnalysis(nutritionistId, startDate, endDate);
      
      // 获取收入预测
      const incomeForecast = await this._getIncomeForecast(nutritionistId);

      const result = {
        details: incomeDetails,
        sourceAnalysis: incomeSourceAnalysis,
        forecast: incomeForecast,
        period: {
          startDate,
          endDate,
          groupBy
        }
      };

      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取营养师收入详情失败', { error, nutritionistId, options });
      return {
        success: false,
        message: `获取收入详情失败: ${error.message}`
      };
    }
  },

  /**
   * 获取营养师评价统计
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 评价选项
   * @returns {Promise<Object>} 评价统计
   */
  async getNutritionistReviews(nutritionistId, options = {}) {
    try {
      if (!mongoose.Types.ObjectId.isValid(nutritionistId)) {
        return { success: false, message: '无效的营养师ID' };
      }

      const {
        limit = 20,
        skip = 0,
        sortBy = 'ratedAt',
        sortOrder = -1,
        minRating = null,
        maxRating = null
      } = options;

      // 构建查询条件
      const query = {
        $or: [
          { nutritionistId: nutritionistId },
          { assignedNutritionistId: nutritionistId }
        ],
        'userRating.rating': { $exists: true }
      };

      if (minRating !== null) {
        query['userRating.rating'].$gte = minRating;
      }
      if (maxRating !== null) {
        query['userRating.rating'].$lte = maxRating;
      }

      const [reviews, stats] = await Promise.all([
        // 获取评价列表
        Consultation.find(query)
          .populate('userId', 'username nickname avatar')
          .select('userRating topic consultationType createdAt')
          .sort({ [`userRating.${sortBy}`]: sortOrder })
          .skip(skip)
          .limit(limit),
        
        // 获取评价统计
        Consultation.aggregate([
          { $match: query },
          {
            $group: {
              _id: null,
              totalReviews: { $sum: 1 },
              averageRating: { $avg: '$userRating.rating' },
              ratingDistribution: {
                $push: '$userRating.rating'
              }
            }
          }
        ])
      ]);

      // 计算评分分布
      const ratingDistribution = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
      if (stats[0]?.ratingDistribution) {
        stats[0].ratingDistribution.forEach(rating => {
          ratingDistribution[Math.floor(rating)]++;
        });
      }

      const total = await Consultation.countDocuments(query);

      const result = {
        reviews,
        statistics: {
          totalReviews: stats[0]?.totalReviews || 0,
          averageRating: stats[0]?.averageRating || 0,
          ratingDistribution
        },
        pagination: {
          total,
          limit,
          skip,
          hasMore: total > skip + limit
        }
      };

      return {
        success: true,
        data: result
      };
    } catch (error) {
      logger.error('获取营养师评价统计失败', { error, nutritionistId, options });
      return {
        success: false,
        message: `获取评价统计失败: ${error.message}`
      };
    }
  },

  /**
   * 获取咨询统计
   * @private
   */
  async _getConsultationStats(nutritionistId, startDate, endDate) {
    const consultationStats = await Consultation.aggregate([
      {
        $match: {
          $or: [
            { nutritionistId: mongoose.Types.ObjectId(nutritionistId) },
            { assignedNutritionistId: mongoose.Types.ObjectId(nutritionistId) }
          ],
          createdAt: { $gte: startDate, $lte: endDate }
        }
      },
      {
        $group: {
          _id: null,
          totalConsultations: { $sum: 1 },
          completedConsultations: {
            $sum: { $cond: [{ $eq: ['$status', 'completed'] }, 1, 0] }
          },
          inProgressConsultations: {
            $sum: { $cond: [{ $eq: ['$status', 'inProgress'] }, 1, 0] }
          },
          cancelledConsultations: {
            $sum: { $cond: [{ $eq: ['$status', 'cancelled'] }, 1, 0] }
          },
          avgDuration: { $avg: '$durationMinutes' },
          consultationTypes: { $push: '$consultationType' }
        }
      }
    ]);

    const stats = consultationStats[0] || {};
    
    // 计算完成率
    const completionRate = stats.totalConsultations > 0 
      ? (stats.completedConsultations / stats.totalConsultations) * 100 
      : 0;

    return {
      totalConsultations: stats.totalConsultations || 0,
      completedConsultations: stats.completedConsultations || 0,
      inProgressConsultations: stats.inProgressConsultations || 0,
      cancelledConsultations: stats.cancelledConsultations || 0,
      completionRate: Math.round(completionRate * 100) / 100,
      averageDuration: Math.round((stats.avgDuration || 0) * 100) / 100
    };
  },

  /**
   * 获取客户统计
   * @private
   */
  async _getClientStats(nutritionistId, startDate, endDate) {
    const clientStats = await NutritionistClient.aggregate([
      {
        $match: {
          nutritionistId: mongoose.Types.ObjectId(nutritionistId),
          relationshipStartDate: { $gte: startDate, $lte: endDate }
        }
      },
      {
        $group: {
          _id: null,
          totalClients: { $sum: 1 },
          activeClients: {
            $sum: { $cond: [{ $eq: ['$relationshipStatus', 'active'] }, 1, 0] }
          },
          newClients: { $sum: 1 }, // 在时间范围内的都是新客户
          avgRelationshipDuration: { $avg: '$relationshipDuration' }
        }
      }
    ]);

    const stats = clientStats[0] || {};

    return {
      totalClients: stats.totalClients || 0,
      activeClients: stats.activeClients || 0,
      newClients: stats.newClients || 0,
      averageRelationshipDuration: Math.round((stats.avgRelationshipDuration || 0) * 100) / 100
    };
  },

  /**
   * 获取收入统计
   * @private
   */
  async _getIncomeStats(nutritionistId, startDate, endDate) {
    // 假设有Payment模型记录支付信息
    const incomeStats = await Consultation.aggregate([
      {
        $match: {
          $or: [
            { nutritionistId: mongoose.Types.ObjectId(nutritionistId) },
            { assignedNutritionistId: mongoose.Types.ObjectId(nutritionistId) }
          ],
          status: 'completed',
          createdAt: { $gte: startDate, $lte: endDate },
          'payment.status': 'paid'
        }
      },
      {
        $group: {
          _id: null,
          totalIncome: { $sum: '$payment.amount' },
          totalPaidConsultations: { $sum: 1 },
          avgIncomePerConsultation: { $avg: '$payment.amount' }
        }
      }
    ]);

    const stats = incomeStats[0] || {};

    return {
      totalIncome: stats.totalIncome || 0,
      totalPaidConsultations: stats.totalPaidConsultations || 0,
      averageIncomePerConsultation: Math.round((stats.avgIncomePerConsultation || 0) * 100) / 100
    };
  },

  /**
   * 获取绩效统计
   * @private
   */
  async _getPerformanceStats(nutritionistId, startDate, endDate) {
    const nutritionist = await Nutritionist.findById(nutritionistId);
    if (!nutritionist) return {};

    // 计算响应时间（从在线状态获取）
    const avgResponseTime = nutritionist.onlineStatus.responseTime.average || 0;

    // 计算在线时长（简化计算）
    const onlineHours = 8; // 假设值，实际需要从活动记录计算

    return {
      averageResponseTime: Math.round(avgResponseTime * 100) / 100,
      onlineHoursPerDay: onlineHours,
      currentRating: nutritionist.ratings.averageRating
    };
  },

  /**
   * 获取评价统计
   * @private
   */
  async _getReviewStats(nutritionistId, startDate, endDate) {
    const reviewStats = await Consultation.aggregate([
      {
        $match: {
          $or: [
            { nutritionistId: mongoose.Types.ObjectId(nutritionistId) },
            { assignedNutritionistId: mongoose.Types.ObjectId(nutritionistId) }
          ],
          'userRating.ratedAt': { $gte: startDate, $lte: endDate },
          'userRating.rating': { $exists: true }
        }
      },
      {
        $group: {
          _id: null,
          totalReviews: { $sum: 1 },
          averageRating: { $avg: '$userRating.rating' },
          fiveStarReviews: {
            $sum: { $cond: [{ $eq: ['$userRating.rating', 5] }, 1, 0] }
          }
        }
      }
    ]);

    const stats = reviewStats[0] || {};
    const satisfactionRate = stats.totalReviews > 0 
      ? (stats.fiveStarReviews / stats.totalReviews) * 100 
      : 0;

    return {
      totalReviews: stats.totalReviews || 0,
      averageRating: Math.round((stats.averageRating || 0) * 100) / 100,
      satisfactionRate: Math.round(satisfactionRate * 100) / 100
    };
  },

  /**
   * 获取趋势数据
   * @private
   */
  async _getTrendData(nutritionistId, period, endDate) {
    // 根据period计算时间段
    const periods = this._generatePeriods(period, endDate);
    
    const trendData = await Promise.all(
      periods.map(async ({ start, end, label }) => {
        const [consultations, income] = await Promise.all([
          this._getConsultationStats(nutritionistId, start, end),
          this._getIncomeStats(nutritionistId, start, end)
        ]);

        return {
          period: label,
          startDate: start,
          endDate: end,
          consultations: consultations.totalConsultations,
          income: income.totalIncome,
          completionRate: consultations.completionRate
        };
      })
    );

    return trendData;
  },

  /**
   * 生成时间段
   * @private
   */
  _generatePeriods(period, endDate) {
    const periods = [];
    const end = new Date(endDate);
    
    for (let i = 6; i >= 0; i--) {
      const start = new Date(end);
      const periodEnd = new Date(end);
      
      switch (period) {
        case 'week':
          start.setDate(end.getDate() - (i + 1) * 7);
          periodEnd.setDate(end.getDate() - i * 7);
          break;
        case 'month':
          start.setMonth(end.getMonth() - (i + 1));
          periodEnd.setMonth(end.getMonth() - i);
          break;
        case 'quarter':
          start.setMonth(end.getMonth() - (i + 1) * 3);
          periodEnd.setMonth(end.getMonth() - i * 3);
          break;
        default: // day
          start.setDate(end.getDate() - (i + 1));
          periodEnd.setDate(end.getDate() - i);
      }
      
      periods.push({
        start,
        end: periodEnd,
        label: this._formatPeriodLabel(start, period)
      });
    }
    
    return periods;
  },

  /**
   * 格式化时间段标签
   * @private
   */
  _formatPeriodLabel(date, period) {
    const options = { timeZone: 'Asia/Shanghai' };
    
    switch (period) {
      case 'week':
        return `第${Math.ceil(date.getDate() / 7)}周`;
      case 'month':
        return `${date.getMonth() + 1}月`;
      case 'quarter':
        return `Q${Math.ceil((date.getMonth() + 1) / 3)}`;
      default: // day
        return date.toLocaleDateString('zh-CN', options);
    }
  },

  /**
   * 获取收入明细
   * @private
   */
  async _getIncomeDetails(nutritionistId, startDate, endDate, groupBy) {
    // 实现收入明细查询逻辑
    // 这里简化处理，实际需要根据具体业务逻辑实现
    return [];
  },

  /**
   * 获取收入来源分析
   * @private
   */
  async _getIncomeSourceAnalysis(nutritionistId, startDate, endDate) {
    const sourceAnalysis = await Consultation.aggregate([
      {
        $match: {
          $or: [
            { nutritionistId: mongoose.Types.ObjectId(nutritionistId) },
            { assignedNutritionistId: mongoose.Types.ObjectId(nutritionistId) }
          ],
          status: 'completed',
          createdAt: { $gte: startDate, $lte: endDate },
          'payment.status': 'paid'
        }
      },
      {
        $group: {
          _id: '$consultationType',
          totalIncome: { $sum: '$payment.amount' },
          count: { $sum: 1 }
        }
      }
    ]);

    return sourceAnalysis.map(item => ({
      source: item._id,
      income: item.totalIncome,
      count: item.count,
      percentage: 0 // 需要在获取总收入后计算
    }));
  },

  /**
   * 获取收入预测
   * @private
   */
  async _getIncomeForecast(nutritionistId) {
    // 简化的收入预测逻辑
    // 实际应该基于历史数据使用更复杂的算法
    const lastMonthIncome = await this._getIncomeStats(
      nutritionistId,
      new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
      new Date()
    );

    return {
      nextMonth: lastMonthIncome.totalIncome * 1.1, // 假设10%增长
      nextQuarter: lastMonthIncome.totalIncome * 3 * 1.15,
      confidence: 0.75
    };
  },

  /**
   * 获取收入详细信息
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 查询选项
   * @returns {Object} 收入详细数据
   */
  async getIncomeDetails(nutritionistId, options = {}) {
    const {
      startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
      endDate = new Date(),
      groupBy = 'day'
    } = options;

    return await this._getIncomeDetails(nutritionistId, startDate, endDate, groupBy);
  },

  /**
   * 获取评价统计
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 查询选项
   * @returns {Object} 评价统计数据
   */
  async getReviewStats(nutritionistId, options = {}) {
    const {
      startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
      endDate = new Date()
    } = options;

    // 调用现有的内部方法
    return await this.getNutritionistReviews(nutritionistId, { startDate, endDate });
  },

  /**
   * 获取趋势数据
   * @param {string} nutritionistId - 营养师ID
   * @param {string} period - 时间周期
   * @param {Date} endDate - 结束日期
   * @returns {Array} 趋势数据
   */
  async getTrendData(nutritionistId, period = 'month', endDate = new Date()) {
    return await this._getTrendData(nutritionistId, period, endDate);
  }
};

module.exports = nutritionistStatsService;