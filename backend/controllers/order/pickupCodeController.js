const pickupCodeService = require('../../services/order/pickupCodeService');
const { successResponse, errorResponse } = require('../../utils/responseHelper');
const { ValidationError, NotFoundError, BusinessError } = require('../../utils/errors');

/**
 * 取餐码控制器
 */
class PickupCodeController {
  /**
   * 为订单创建取餐码
   */
  async createPickupCode(req, res) {
    try {
      const { orderId } = req.params;
      const { specialNotes } = req.body;
      
      const options = {
        specialNotes
      };

      const result = await pickupCodeService.createPickupCode(orderId, options);

      return successResponse(res, result.data, result.message, 201);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '创建取餐码失败', 500);
    }
  }

  /**
   * 验证取餐码
   */
  async verifyPickupCode(req, res) {
    try {
      const { code } = req.params;
      const { storeId } = req.query;
      
      if (!storeId) {
        return errorResponse(res, '门店ID不能为空', 400);
      }

      const options = {
        ipAddress: req.ip,
        userAgent: req.get('User-Agent')
      };

      const result = await pickupCodeService.verifyPickupCode(code, storeId, options);

      if (!result.success) {
        return errorResponse(res, result.error, 400);
      }

      return successResponse(res, result.data);

    } catch (error) {
      if (error instanceof ValidationError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '验证取餐码失败', 500);
    }
  }

  /**
   * 使用取餐码（门店员工确认取餐）
   */
  async usePickupCode(req, res) {
    try {
      const { code } = req.params;
      const { 
        storeId, 
        verificationMethod = 'manual',
        pickupPerson,
        deviceId,
        deviceType
      } = req.body;
      const staffUserId = req.user.id;

      if (!storeId) {
        return errorResponse(res, '门店ID不能为空', 400);
      }

      const options = {
        verificationMethod,
        pickupPerson,
        deviceId,
        deviceType,
        ipAddress: req.ip,
        userAgent: req.get('User-Agent')
      };

      const result = await pickupCodeService.usePickupCode(
        code, 
        storeId, 
        staffUserId, 
        options
      );

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '确认取餐失败', 500);
    }
  }

  /**
   * 获取门店取餐码列表
   */
  async getStorePickupCodes(req, res) {
    try {
      const { storeId } = req.params;
      const { 
        page, 
        limit, 
        status, 
        date,
        search 
      } = req.query;

      const options = {
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 20,
        status,
        date,
        search
      };

      const result = await pickupCodeService.getStorePickupCodes(storeId, options);

      return successResponse(res, result.data);

    } catch (error) {
      return errorResponse(res, '获取取餐码列表失败', 500);
    }
  }

  /**
   * 取消取餐码
   */
  async cancelPickupCode(req, res) {
    try {
      const { codeId } = req.params;
      const { reason } = req.body;
      const operatorId = req.user.id;

      if (!reason) {
        return errorResponse(res, '取消原因不能为空', 400);
      }

      const result = await pickupCodeService.cancelPickupCode(
        codeId, 
        operatorId, 
        reason
      );

      return successResponse(res, null, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '取消取餐码失败', 500);
    }
  }

  /**
   * 延长取餐码有效期
   */
  async extendPickupCode(req, res) {
    try {
      const { codeId } = req.params;
      const { additionalHours = 1 } = req.body;
      const operatorId = req.user.id;

      if (additionalHours <= 0 || additionalHours > 24) {
        return errorResponse(res, '延长时间必须在1-24小时之间', 400);
      }

      const result = await pickupCodeService.extendPickupCode(
        codeId, 
        operatorId, 
        additionalHours
      );

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '延长有效期失败', 500);
    }
  }

  /**
   * 获取门店取餐码统计
   */
  async getStoreStats(req, res) {
    try {
      const { storeId } = req.params;
      const { date } = req.query;

      const result = await pickupCodeService.getStoreStats(storeId, date);

      return successResponse(res, result.data);

    } catch (error) {
      return errorResponse(res, '获取统计数据失败', 500);
    }
  }

  /**
   * 批量验证取餐码（门店端功能）
   */
  async batchVerifyPickupCodes(req, res) {
    try {
      const { codes, storeId } = req.body;

      if (!Array.isArray(codes) || codes.length === 0) {
        return errorResponse(res, '取餐码列表不能为空', 400);
      }

      if (codes.length > 10) {
        return errorResponse(res, '单次最多验证10个取餐码', 400);
      }

      if (!storeId) {
        return errorResponse(res, '门店ID不能为空', 400);
      }

      const options = {
        ipAddress: req.ip,
        userAgent: req.get('User-Agent')
      };

      const results = [];
      for (const code of codes) {
        try {
          const result = await pickupCodeService.verifyPickupCode(
            code, 
            storeId, 
            options
          );
          results.push({ 
            code, 
            success: result.success, 
            data: result.data,
            error: result.error 
          });
        } catch (error) {
          results.push({ 
            code, 
            success: false, 
            error: error.message 
          });
        }
      }

      const validCount = results.filter(r => r.success).length;

      return successResponse(res, {
        results,
        summary: {
          total: codes.length,
          valid: validCount,
          invalid: codes.length - validCount
        }
      });

    } catch (error) {
      return errorResponse(res, '批量验证失败', 500);
    }
  }

  /**
   * 获取取餐码详情（包含完整信息）
   */
  async getPickupCodeDetails(req, res) {
    try {
      const { codeId } = req.params;
      
      // 这里需要添加获取详情的服务方法
      // 暂时返回基础响应
      return errorResponse(res, '功能开发中', 501);

    } catch (error) {
      return errorResponse(res, '获取详情失败', 500);
    }
  }

  /**
   * 重新发送取餐码通知
   */
  async resendNotification(req, res) {
    try {
      const { codeId } = req.params;
      const { notificationType = 'sms' } = req.body;
      
      // 验证权限
      if (!req.user.roles.includes('store_staff') && !req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      // 这里需要添加重发通知的服务方法
      // 暂时返回基础响应
      return errorResponse(res, '功能开发中', 501);

    } catch (error) {
      return errorResponse(res, '重发通知失败', 500);
    }
  }

  /**
   * 处理过期取餐码（定时任务调用）
   */
  async processExpiredCodes(req, res) {
    try {
      // 验证管理员权限
      if (!req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      const result = await pickupCodeService.processExpiredCodes();

      return successResponse(res, result.data, '过期取餐码处理完成');

    } catch (error) {
      return errorResponse(res, '处理过期取餐码失败', 500);
    }
  }

  /**
   * 导出取餐码数据
   */
  async exportPickupCodes(req, res) {
    try {
      const { storeId } = req.params;
      const { startDate, endDate, format = 'json' } = req.query;

      const options = {
        page: 1,
        limit: 1000, // 导出限制
        date: startDate // 简化处理，使用开始日期
      };

      const result = await pickupCodeService.getStorePickupCodes(storeId, options);

      if (format === 'csv') {
        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', 'attachment; filename=pickup_codes.csv');
        
        const csvData = this.convertToCSV(result.data.codes);
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
  convertToCSV(codes) {
    const headers = [
      'code', 'orderNumber', 'customerName', 'customerPhone', 
      'status', 'generatedAt', 'expiresAt', 'usedAt'
    ];
    
    const csvRows = [headers.join(',')];
    
    codes.forEach(code => {
      const row = [
        code.code,
        code.orderNumber,
        code.customerInfo?.name || '',
        code.customerInfo?.phone || '',
        code.status,
        code.generatedAt,
        code.expiresAt,
        code.usedAt || ''
      ];
      csvRows.push(row.join(','));
    });
    
    return csvRows.join('\n');
  }
}

module.exports = new PickupCodeController();