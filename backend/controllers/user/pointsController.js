const pointsService = require('../../services/user/pointsService');
const { successResponse, errorResponse } = require('../../utils/responseHelper');
const { ValidationError, NotFoundError, BusinessError } = require('../../utils/errors');

/**
 * 积分控制器
 */
class PointsController {
  /**
   * 处理订单积分（内部调用，订单完成时触发）
   */
  async processOrderPoints(req, res) {
    try {
      const { orderId } = req.params;
      const { customValue } = req.body;

      const options = {
        customValue
      };

      const result = await pointsService.processOrderPoints(orderId, options);

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '处理订单积分失败', 500);
    }
  }

  /**
   * 用户签到获取积分
   */
  async checkinPoints(req, res) {
    try {
      const userId = req.user.id;
      
      const options = {
        deviceInfo: {
          userAgent: req.get('User-Agent'),
          ipAddress: req.ip
        }
      };

      const result = await pointsService.processCheckinPoints(userId, options);

      if (!result.success) {
        return errorResponse(res, result.message, 400, result.data);
      }

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '签到失败', 500);
    }
  }

  /**
   * 使用积分
   */
  async spendPoints(req, res) {
    try {
      const userId = req.user.id;
      const { 
        amount, 
        type = 'spend_order', 
        description, 
        relatedObject,
        storeId 
      } = req.body;

      if (!amount || amount <= 0) {
        return errorResponse(res, '使用积分数量必须大于0', 400);
      }

      const options = {
        type,
        description,
        relatedObject,
        storeInfo: storeId ? { storeId } : undefined,
        deviceInfo: {
          userAgent: req.get('User-Agent'),
          ipAddress: req.ip
        }
      };

      const result = await pointsService.spendPoints(userId, amount, options);

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof ValidationError || error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '使用积分失败', 500);
    }
  }

  /**
   * 管理员调整用户积分
   */
  async adjustPoints(req, res) {
    try {
      const { userId } = req.params;
      const { amount, reason } = req.body;
      const adminId = req.user.id;

      if (!amount || amount === 0) {
        return errorResponse(res, '调整数量不能为0', 400);
      }

      if (!reason) {
        return errorResponse(res, '调整原因不能为空', 400);
      }

      const result = await pointsService.adjustPoints(
        userId, 
        amount, 
        adminId, 
        reason
      );

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof ValidationError || error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '调整积分失败', 500);
    }
  }

  /**
   * 获取用户积分历史
   */
  async getPointsHistory(req, res) {
    try {
      const { userId } = req.params;
      const { 
        page, 
        limit, 
        type, 
        startDate, 
        endDate 
      } = req.query;

      // 权限检查：用户只能查看自己的积分历史，管理员可以查看任何用户的
      if (userId !== req.user.id && !req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      const options = {
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 20,
        type,
        startDate,
        endDate
      };

      const result = await pointsService.getUserPointsHistory(userId, options);

      return successResponse(res, result.data);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      return errorResponse(res, '获取积分历史失败', 500);
    }
  }

  /**
   * 获取用户积分统计
   */
  async getPointsStats(req, res) {
    try {
      const { userId } = req.params;
      const { startDate, endDate } = req.query;

      // 权限检查
      if (userId !== req.user.id && !req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      const options = {
        startDate,
        endDate
      };

      const result = await pointsService.getUserPointsStats(userId, options);

      return successResponse(res, result.data);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      return errorResponse(res, '获取积分统计失败', 500);
    }
  }

  /**
   * 获取当前用户积分余额
   */
  async getCurrentBalance(req, res) {
    try {
      const userId = req.user.id;
      
      // 简化实现，直接查询用户模型
      const User = require('../../models/user/userModel');
      const user = await User.findById(userId).select('points username');
      
      if (!user) {
        return errorResponse(res, '用户不存在', 404);
      }

      return successResponse(res, {
        userId: user._id,
        username: user.username,
        currentBalance: user.points || 0
      });

    } catch (error) {
      return errorResponse(res, '获取积分余额失败', 500);
    }
  }

  /**
   * 创建积分规则（管理员功能）
   */
  async createPointsRule(req, res) {
    try {
      const ruleData = req.body;
      const creatorId = req.user.id;

      const result = await pointsService.createPointsRule(ruleData, creatorId);

      return successResponse(res, result.data, result.message, 201);

    } catch (error) {
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 403);
      }
      if (error instanceof ValidationError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '创建积分规则失败', 500);
    }
  }

  /**
   * 获取积分规则列表
   */
  async getPointsRules(req, res) {
    try {
      const { type, status, page, limit } = req.query;

      // 非管理员只能查看活跃规则
      const options = {
        type,
        status: req.user.roles.includes('admin') ? status : 'active',
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 20
      };

      const result = await pointsService.getPointsRules(options);

      return successResponse(res, result.data);

    } catch (error) {
      return errorResponse(res, '获取积分规则失败', 500);
    }
  }

  /**
   * 更新积分规则（管理员功能）
   */
  async updatePointsRule(req, res) {
    try {
      const { ruleId } = req.params;
      const updateData = req.body;

      if (!req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      // 这里需要添加更新规则的服务方法
      // 暂时返回基础响应
      return errorResponse(res, '功能开发中', 501);

    } catch (error) {
      return errorResponse(res, '更新积分规则失败', 500);
    }
  }

  /**
   * 处理过期积分（定时任务）
   */
  async processExpiredPoints(req, res) {
    try {
      if (!req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      const result = await pointsService.processExpiredPoints();

      return successResponse(res, result.data, '过期积分处理完成');

    } catch (error) {
      return errorResponse(res, '处理过期积分失败', 500);
    }
  }

  /**
   * 获取积分排行榜
   */
  async getPointsLeaderboard(req, res) {
    try {
      const { period = 'all', limit = 50 } = req.query;

      // 这里需要添加排行榜的服务方法
      // 暂时返回基础响应
      return errorResponse(res, '功能开发中', 501);

    } catch (error) {
      return errorResponse(res, '获取排行榜失败', 500);
    }
  }

  /**
   * 批量处理订单积分（管理员功能）
   */
  async batchProcessOrderPoints(req, res) {
    try {
      const { orderIds } = req.body;

      if (!req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      if (!Array.isArray(orderIds) || orderIds.length === 0) {
        return errorResponse(res, '订单ID列表不能为空', 400);
      }

      if (orderIds.length > 100) {
        return errorResponse(res, '单次最多处理100个订单', 400);
      }

      const results = [];
      for (const orderId of orderIds) {
        try {
          const result = await pointsService.processOrderPoints(orderId);
          results.push({ 
            orderId, 
            success: true, 
            data: result.data 
          });
        } catch (error) {
          results.push({ 
            orderId, 
            success: false, 
            error: error.message 
          });
        }
      }

      const successCount = results.filter(r => r.success).length;

      return successResponse(res, {
        results,
        summary: {
          total: orderIds.length,
          success: successCount,
          failed: orderIds.length - successCount
        }
      }, `批量处理完成，成功${successCount}个`);

    } catch (error) {
      return errorResponse(res, '批量处理失败', 500);
    }
  }

  /**
   * 积分兑换预览
   */
  async previewRedemption(req, res) {
    try {
      const { amount, redeemType } = req.body;
      const userId = req.user.id;

      if (!amount || amount <= 0) {
        return errorResponse(res, '兑换积分数量必须大于0', 400);
      }

      // 获取用户当前积分
      const User = require('../../models/user/userModel');
      const user = await User.findById(userId).select('points');
      
      if (!user) {
        return errorResponse(res, '用户不存在', 404);
      }

      if (user.points < amount) {
        return errorResponse(res, '积分余额不足', 400);
      }

      // 计算兑换价值（这里可以根据业务规则计算）
      const exchangeRate = 100; // 假设100积分=1元
      const value = (amount / exchangeRate).toFixed(2);

      return successResponse(res, {
        amount,
        redeemType,
        value: parseFloat(value),
        currentBalance: user.points,
        balanceAfter: user.points - amount,
        exchangeRate
      });

    } catch (error) {
      return errorResponse(res, '兑换预览失败', 500);
    }
  }

  /**
   * 导出积分数据
   */
  async exportPointsData(req, res) {
    try {
      const { userId } = req.params;
      const { startDate, endDate, format = 'json' } = req.query;

      // 权限检查
      if (userId !== req.user.id && !req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      const options = {
        page: 1,
        limit: 1000, // 导出限制
        startDate,
        endDate
      };

      const result = await pointsService.getUserPointsHistory(userId, options);

      if (format === 'csv') {
        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', 'attachment; filename=points_history.csv');
        
        const csvData = this.convertToCSV(result.data.transactions);
        return res.send(csvData);
      }

      return successResponse(res, result.data);

    } catch (error) {
      return errorResponse(res, '导出数据失败', 500);
    }
  }

  /**
   * 转换为CSV格式
   * @private
   */
  convertToCSV(transactions) {
    const headers = [
      'id', 'type', 'amount', 'description', 
      'balanceAfter', 'createdAt', 'expiresAt', 'tags'
    ];
    
    const csvRows = [headers.join(',')];
    
    transactions.forEach(transaction => {
      const row = [
        transaction.id,
        transaction.type,
        transaction.amount,
        `"${transaction.description}"`, // 用引号包围避免逗号问题
        transaction.balanceAfter,
        transaction.createdAt,
        transaction.expiresAt || '',
        transaction.tags ? transaction.tags.join(';') : ''
      ];
      csvRows.push(row.join(','));
    });
    
    return csvRows.join('\n');
  }
}

module.exports = new PointsController();