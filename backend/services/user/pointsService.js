const PointsTransaction = require('../../models/user/pointsTransactionModel');
const PointsRule = require('../../models/user/pointsRuleModel');
const User = require('../../models/user/userModel');
const Order = require('../../models/order/orderModel');
const logger = require('../../config/modules/logger');
const { ValidationError, NotFoundError, BusinessError } = require('../../utils/errors');

class PointsService {
  /**
   * 处理订单完成后的积分奖励
   * @param {string} orderId - 订单ID
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 积分处理结果
   */
  async processOrderPoints(orderId, options = {}) {
    try {
      // 获取订单信息
      const order = await Order.findById(orderId)
        .populate('userId', 'points membershipLevel registrationDate')
        .populate('storeId', 'name');

      if (!order) {
        throw new NotFoundError('订单不存在');
      }

      if (order.status !== 'completed') {
        throw new BusinessError('只有已完成的订单才能获得积分');
      }

      // 检查是否已经处理过积分
      const existingTransaction = await PointsTransaction.findOne({
        'relatedObject.objectId': orderId,
        'relatedObject.objectType': 'order',
        type: 'earn_order'
      });

      if (existingTransaction) {
        return {
          success: true,
          message: '该订单积分已处理',
          data: {
            alreadyProcessed: true,
            transactionId: existingTransaction._id
          }
        };
      }

      // 获取适用的积分规则
      const user = order.userId;
      const context = {
        type: 'order_completion',
        userId: user._id,
        orderAmount: order.totalAmount,
        storeId: order.storeId._id,
        userMembershipLevel: user.membershipLevel,
        userRegistrationDate: user.registrationDate,
        userOrderCount: await Order.countDocuments({ userId: user._id, status: 'completed' })
      };

      const applicableRules = await PointsRule.getApplicableRules(context);

      if (applicableRules.length === 0) {
        logger.info('订单未匹配到积分规则', { orderId, userId: user._id });
        return {
          success: true,
          message: '该订单不符合积分规则',
          data: {
            pointsEarned: 0,
            rulesApplied: []
          }
        };
      }

      // 应用最高优先级的规则
      const rule = applicableRules[0];
      const pointsToEarn = rule.calculatePoints({
        orderAmount: order.totalAmount,
        customValue: options.customValue || 0
      });

      if (pointsToEarn <= 0) {
        return {
          success: true,
          message: '该订单不产生积分',
          data: {
            pointsEarned: 0,
            rulesApplied: [rule.name]
          }
        };
      }

      // 计算积分有效期
      const expiresAt = new Date();
      expiresAt.setDate(expiresAt.getDate() + rule.validity.pointsValidityDays);

      // 创建积分交易记录
      const transaction = await PointsTransaction.createTransaction({
        userId: user._id,
        type: 'earn_order',
        amount: pointsToEarn,
        description: `订单完成获得积分 - ${order.orderNumber}`,
        relatedObject: {
          objectType: 'order',
          objectId: orderId,
          objectNumber: order.orderNumber,
          objectTitle: `订单 ${order.orderNumber}`
        },
        ruleInfo: {
          ruleId: rule._id,
          ruleName: rule.name,
          ruleType: rule.type,
          multiplier: rule.pointsConfig.multiplier,
          baseAmount: pointsToEarn / (rule.pointsConfig.multiplier || 1)
        },
        storeInfo: {
          storeId: order.storeId._id,
          storeName: order.storeId.name
        },
        expiresAt
      });

      // 记录规则使用统计
      await rule.recordUsage(pointsToEarn);

      logger.info('订单积分处理成功', {
        orderId,
        userId: user._id,
        pointsEarned: pointsToEarn,
        ruleName: rule.name,
        transactionId: transaction._id
      });

      return {
        success: true,
        message: `获得${pointsToEarn}积分`,
        data: {
          pointsEarned: pointsToEarn,
          currentBalance: transaction.balanceAfter,
          rulesApplied: [rule.name],
          expiresAt,
          transactionId: transaction._id
        }
      };

    } catch (error) {
      logger.error('处理订单积分失败', { error: error.message, orderId });
      throw error;
    }
  }

  /**
   * 处理用户签到积分
   * @param {string} userId - 用户ID
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 签到积分结果
   */
  async processCheckinPoints(userId, options = {}) {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new NotFoundError('用户不存在');
      }

      // 检查今日是否已签到
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);

      const todayCheckin = await PointsTransaction.findOne({
        userId,
        type: 'earn_checkin',
        createdAt: {
          $gte: today,
          $lt: tomorrow
        }
      });

      if (todayCheckin) {
        return {
          success: false,
          message: '今日已签到',
          data: {
            alreadyCheckedIn: true,
            checkinTime: todayCheckin.createdAt
          }
        };
      }

      // 获取签到积分规则
      const context = {
        type: 'daily_checkin',
        userId,
        userMembershipLevel: user.membershipLevel,
        userRegistrationDate: user.registrationDate
      };

      const applicableRules = await PointsRule.getApplicableRules(context);
      if (applicableRules.length === 0) {
        throw new BusinessError('签到积分规则未配置');
      }

      const rule = applicableRules[0];
      const pointsToEarn = rule.calculatePoints({});

      // 检查连续签到天数
      const consecutiveDays = await this.getConsecutiveCheckinDays(userId);
      let bonusPoints = 0;

      // 连续签到奖励逻辑
      if (consecutiveDays >= 7) {
        bonusPoints = Math.floor(pointsToEarn * 0.5); // 连续7天额外50%积分
      } else if (consecutiveDays >= 3) {
        bonusPoints = Math.floor(pointsToEarn * 0.2); // 连续3天额外20%积分
      }

      const totalPoints = pointsToEarn + bonusPoints;

      // 计算积分有效期
      const expiresAt = new Date();
      expiresAt.setDate(expiresAt.getDate() + rule.validity.pointsValidityDays);

      // 创建积分交易记录
      const transaction = await PointsTransaction.createTransaction({
        userId,
        type: 'earn_checkin',
        amount: totalPoints,
        description: `每日签到获得积分${bonusPoints > 0 ? ` (连续${consecutiveDays + 1}天奖励)` : ''}`,
        ruleInfo: {
          ruleId: rule._id,
          ruleName: rule.name,
          ruleType: rule.type,
          baseAmount: pointsToEarn
        },
        tags: bonusPoints > 0 ? ['consecutive_bonus'] : [],
        expiresAt
      });

      // 记录规则使用统计
      await rule.recordUsage(totalPoints);

      logger.info('签到积分处理成功', {
        userId,
        pointsEarned: totalPoints,
        consecutiveDays: consecutiveDays + 1,
        bonusPoints,
        transactionId: transaction._id
      });

      return {
        success: true,
        message: `签到成功，获得${totalPoints}积分`,
        data: {
          pointsEarned: totalPoints,
          basePoints: pointsToEarn,
          bonusPoints,
          consecutiveDays: consecutiveDays + 1,
          currentBalance: transaction.balanceAfter,
          expiresAt,
          transactionId: transaction._id
        }
      };

    } catch (error) {
      logger.error('处理签到积分失败', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * 使用积分
   * @param {string} userId - 用户ID
   * @param {number} amount - 使用积分数量
   * @param {Object} options - 使用选项
   * @returns {Promise<Object>} 使用结果
   */
  async spendPoints(userId, amount, options = {}) {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new NotFoundError('用户不存在');
      }

      if (amount <= 0) {
        throw new ValidationError('使用积分数量必须大于0');
      }

      if (user.points < amount) {
        throw new BusinessError('积分余额不足');
      }

      const { type = 'spend_order', description, relatedObject } = options;

      // 创建积分消费记录
      const transaction = await PointsTransaction.createTransaction({
        userId,
        type,
        amount: -amount,
        description: description || '积分消费',
        relatedObject,
        storeInfo: options.storeInfo,
        deviceInfo: options.deviceInfo
      });

      logger.info('积分使用成功', {
        userId,
        pointsSpent: amount,
        currentBalance: transaction.balanceAfter,
        transactionId: transaction._id
      });

      return {
        success: true,
        message: `成功使用${amount}积分`,
        data: {
          pointsSpent: amount,
          currentBalance: transaction.balanceAfter,
          transactionId: transaction._id
        }
      };

    } catch (error) {
      logger.error('使用积分失败', { error: error.message, userId, amount });
      throw error;
    }
  }

  /**
   * 管理员调整积分
   * @param {string} userId - 用户ID
   * @param {number} amount - 调整数量（正数为增加，负数为减少）
   * @param {string} adminId - 管理员ID
   * @param {string} reason - 调整原因
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 调整结果
   */
  async adjustPoints(userId, amount, adminId, reason, options = {}) {
    try {
      const user = await User.findById(userId);
      if (!user) {
        throw new NotFoundError('用户不存在');
      }

      const admin = await User.findById(adminId);
      if (!admin || !admin.roles.includes('admin')) {
        throw new BusinessError('只有管理员可以调整积分');
      }

      if (amount === 0) {
        throw new ValidationError('调整数量不能为0');
      }

      // 检查余额（如果是减少积分）
      if (amount < 0 && user.points < Math.abs(amount)) {
        throw new BusinessError('用户积分余额不足，无法扣除');
      }

      // 创建积分调整记录
      const transaction = await PointsTransaction.createTransaction({
        userId,
        type: 'adjust_admin',
        amount,
        description: `管理员调整积分: ${reason}`,
        operator: {
          operatorId: adminId,
          operatorName: admin.username,
          operatorRole: 'admin',
          reason
        },
        tags: ['admin_adjustment']
      });

      logger.info('管理员积分调整成功', {
        userId,
        amount,
        adminId,
        reason,
        newBalance: transaction.balanceAfter,
        transactionId: transaction._id
      });

      return {
        success: true,
        message: `积分调整成功，${amount > 0 ? '增加' : '减少'}${Math.abs(amount)}积分`,
        data: {
          adjustment: amount,
          currentBalance: transaction.balanceAfter,
          transactionId: transaction._id
        }
      };

    } catch (error) {
      logger.error('管理员积分调整失败', { error: error.message, userId, amount, adminId });
      throw error;
    }
  }

  /**
   * 获取用户积分历史
   * @param {string} userId - 用户ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Object>} 积分历史
   */
  async getUserPointsHistory(userId, options = {}) {
    try {
      const { 
        page = 1, 
        limit = 20, 
        type, 
        startDate, 
        endDate 
      } = options;
      
      const skip = (page - 1) * limit;
      
      const query = { userId };
      
      if (type) {
        query.type = type;
      }
      
      if (startDate || endDate) {
        query.createdAt = {};
        if (startDate) query.createdAt.$gte = new Date(startDate);
        if (endDate) query.createdAt.$lte = new Date(endDate);
      }

      const [transactions, total, user] = await Promise.all([
        PointsTransaction.find(query)
          .sort({ createdAt: -1 })
          .skip(skip)
          .limit(limit)
          .populate('ruleInfo.ruleId', 'name type'),
        PointsTransaction.countDocuments(query),
        User.findById(userId).select('points username')
      ]);

      if (!user) {
        throw new NotFoundError('用户不存在');
      }

      return {
        success: true,
        data: {
          currentBalance: user.points,
          transactions: transactions.map(t => ({
            id: t._id,
            type: t.type,
            amount: t.amount,
            description: t.description,
            balanceAfter: t.balanceAfter,
            createdAt: t.createdAt,
            expiresAt: t.expiresAt,
            relatedObject: t.relatedObject,
            ruleInfo: t.ruleInfo,
            tags: t.tags
          })),
          pagination: {
            page,
            limit,
            total,
            pages: Math.ceil(total / limit)
          }
        }
      };

    } catch (error) {
      logger.error('获取用户积分历史失败', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * 获取用户积分统计
   * @param {string} userId - 用户ID
   * @param {Object} options - 统计选项
   * @returns {Promise<Object>} 积分统计
   */
  async getUserPointsStats(userId, options = {}) {
    try {
      const user = await User.findById(userId).select('points username');
      if (!user) {
        throw new NotFoundError('用户不存在');
      }

      // 获取积分统计
      const stats = await PointsTransaction.getUserPointsStats(userId, options);

      // 获取即将过期的积分
      const expiringPoints = await PointsTransaction.find({
        userId,
        amount: { $gt: 0 },
        expiresAt: {
          $gte: new Date(),
          $lte: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000) // 30天内过期
        },
        isExpired: false
      }).sort({ expiresAt: 1 });

      // 获取本月积分趋势
      const trend = await PointsTransaction.getPointsTrend(userId, 30);

      return {
        success: true,
        data: {
          currentBalance: user.points,
          stats: stats.reduce((acc, stat) => {
            acc[stat._id] = {
              totalAmount: stat.totalAmount,
              count: stat.count,
              avgAmount: Math.round(stat.avgAmount),
              monthlyData: stat.monthlyData
            };
            return acc;
          }, {}),
          expiringPoints: {
            total: expiringPoints.reduce((sum, t) => sum + t.amount, 0),
            items: expiringPoints.map(t => ({
              amount: t.amount,
              expiresAt: t.expiresAt,
              description: t.description
            }))
          },
          trend: trend.map(t => ({
            date: `${t._id.year}-${t._id.month.toString().padStart(2, '0')}-${t._id.day.toString().padStart(2, '0')}`,
            earned: t.earned,
            spent: t.spent,
            net: t.earned - t.spent
          }))
        }
      };

    } catch (error) {
      logger.error('获取用户积分统计失败', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * 处理积分过期
   * @returns {Promise<Object>} 处理结果
   */
  async processExpiredPoints() {
    try {
      const expiredResults = await PointsTransaction.processExpiredPoints();

      logger.info('积分过期处理完成', {
        processedCount: expiredResults.length,
        totalExpiredAmount: expiredResults.reduce((sum, result) => sum + result.expiredAmount, 0)
      });

      return {
        success: true,
        data: {
          processedCount: expiredResults.length,
          expiredResults
        }
      };

    } catch (error) {
      logger.error('处理积分过期失败', { error: error.message });
      throw error;
    }
  }

  /**
   * 获取连续签到天数
   * @private
   * @param {string} userId - 用户ID
   * @returns {Promise<number>} 连续签到天数
   */
  async getConsecutiveCheckinDays(userId) {
    try {
      const checkinTransactions = await PointsTransaction.find({
        userId,
        type: 'earn_checkin'
      }).sort({ createdAt: -1 }).limit(30); // 最多查询30天

      if (checkinTransactions.length === 0) {
        return 0;
      }

      let consecutiveDays = 0;
      let currentDate = new Date();
      currentDate.setHours(0, 0, 0, 0);

      for (const transaction of checkinTransactions) {
        const transactionDate = new Date(transaction.createdAt);
        transactionDate.setHours(0, 0, 0, 0);

        // 检查是否是前一天
        const expectedDate = new Date(currentDate);
        expectedDate.setDate(expectedDate.getDate() - 1);

        if (transactionDate.getTime() === expectedDate.getTime()) {
          consecutiveDays++;
          currentDate = expectedDate;
        } else {
          break;
        }
      }

      return consecutiveDays;

    } catch (error) {
      logger.error('获取连续签到天数失败', { error: error.message, userId });
      return 0;
    }
  }

  /**
   * 创建积分规则
   * @param {Object} ruleData - 规则数据
   * @param {string} creatorId - 创建者ID
   * @returns {Promise<Object>} 创建结果
   */
  async createPointsRule(ruleData, creatorId) {
    try {
      const creator = await User.findById(creatorId);
      if (!creator || !creator.roles.includes('admin')) {
        throw new BusinessError('只有管理员可以创建积分规则');
      }

      const rule = new PointsRule({
        ...ruleData,
        createdBy: creatorId
      });

      await rule.save();

      logger.info('积分规则创建成功', {
        ruleId: rule._id,
        ruleName: rule.name,
        ruleType: rule.type,
        creatorId
      });

      return {
        success: true,
        message: '积分规则创建成功',
        data: {
          ruleId: rule._id,
          ruleName: rule.name,
          ruleType: rule.type
        }
      };

    } catch (error) {
      logger.error('创建积分规则失败', { error: error.message, creatorId });
      throw error;
    }
  }

  /**
   * 获取积分规则列表
   * @param {Object} options - 查询选项
   * @returns {Promise<Object>} 规则列表
   */
  async getPointsRules(options = {}) {
    try {
      const { type, status, page = 1, limit = 20 } = options;
      const skip = (page - 1) * limit;

      const query = {};
      if (type) query.type = type;
      if (status) query.status = status;

      const [rules, total] = await Promise.all([
        PointsRule.find(query)
          .populate('createdBy', 'username')
          .sort({ priority: -1, createdAt: -1 })
          .skip(skip)
          .limit(limit),
        PointsRule.countDocuments(query)
      ]);

      return {
        success: true,
        data: {
          rules: rules.map(rule => ({
            id: rule._id,
            name: rule.name,
            type: rule.type,
            status: rule.status,
            priority: rule.priority,
            pointsConfig: rule.pointsConfig,
            conditions: rule.conditions,
            frequency: rule.frequency,
            validity: rule.validity,
            usageStats: rule.usageStats,
            createdBy: rule.createdBy,
            createdAt: rule.createdAt
          })),
          pagination: {
            page,
            limit,
            total,
            pages: Math.ceil(total / limit)
          }
        }
      };

    } catch (error) {
      logger.error('获取积分规则列表失败', { error: error.message });
      throw error;
    }
  }
}

module.exports = new PointsService();