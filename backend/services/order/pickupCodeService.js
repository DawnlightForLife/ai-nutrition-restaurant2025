const PickupCode = require('../../models/order/pickupCodeModel');
const Order = require('../../models/order/orderModel');
const User = require('../../models/user/userModel');
const logger = require('../../config/modules/logger');
const { ValidationError, NotFoundError, BusinessError } = require('../../utils/errors');

class PickupCodeService {
  /**
   * 为订单创建取餐码
   * @param {string} orderId - 订单ID
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 取餐码信息
   */
  async createPickupCode(orderId, options = {}) {
    try {
      // 获取订单信息
      const order = await Order.findById(orderId)
        .populate('userId', 'username phone')
        .populate('storeId', 'name address');

      if (!order) {
        throw new NotFoundError('订单不存在');
      }

      // 检查订单状态
      if (!['confirmed', 'preparing', 'ready'].includes(order.status)) {
        throw new BusinessError('订单状态不允许生成取餐码');
      }

      // 检查是否已有活跃的取餐码
      const existingCode = await PickupCode.findOne({
        orderId,
        status: 'active'
      });

      if (existingCode) {
        return {
          success: true,
          data: {
            code: existingCode.code,
            orderId: existingCode.orderId,
            orderNumber: existingCode.orderNumber,
            expiresAt: existingCode.expiresAt,
            isExisting: true
          }
        };
      }

      // 创建取餐码
      const pickupCode = await PickupCode.createForOrder({
        orderId: order._id,
        orderNumber: order.orderNumber,
        storeId: order.storeId._id,
        userId: order.userId._id,
        customerName: order.customerInfo?.name || order.userId.username,
        customerPhone: order.customerInfo?.phone || order.userId.phone,
        specialNotes: options.specialNotes
      });

      // 发送通知（这里可以集成短信/推送服务）
      await this.sendPickupCodeNotification(pickupCode, order);

      logger.info('取餐码创建成功', {
        orderId,
        code: pickupCode.code,
        storeId: order.storeId._id
      });

      return {
        success: true,
        data: {
          code: pickupCode.code,
          orderId: pickupCode.orderId,
          orderNumber: pickupCode.orderNumber,
          expiresAt: pickupCode.expiresAt,
          isExisting: false
        }
      };

    } catch (error) {
      logger.error('创建取餐码失败', { error: error.message, orderId });
      throw error;
    }
  }

  /**
   * 验证取餐码
   * @param {string} code - 取餐码
   * @param {string} storeId - 门店ID
   * @param {Object} options - 验证选项
   * @returns {Promise<Object>} 验证结果
   */
  async verifyPickupCode(code, storeId, options = {}) {
    try {
      if (!code || code.length !== 6) {
        throw new ValidationError('取餐码格式不正确');
      }

      const pickupCode = await PickupCode.verifyCode(code, storeId, {
        ipAddress: options.ipAddress,
        userAgent: options.userAgent
      });

      if (!pickupCode) {
        return {
          success: false,
          error: '取餐码无效、已使用或已过期',
          data: null
        };
      }

      // 获取订单详细信息
      const orderDetails = await Order.findById(pickupCode.orderId)
        .populate('userId', 'username phone')
        .select('orderNumber items totalAmount customerInfo status');

      return {
        success: true,
        data: {
          code: pickupCode.code,
          orderId: pickupCode.orderId,
          orderNumber: pickupCode.orderNumber,
          customerInfo: {
            name: pickupCode.pickupPerson.name,
            phone: pickupCode.pickupPerson.phone,
            isOriginalCustomer: pickupCode.pickupPerson.isOriginalCustomer
          },
          orderDetails: {
            items: orderDetails.items,
            totalAmount: orderDetails.totalAmount,
            status: orderDetails.status
          },
          generatedAt: pickupCode.generatedAt,
          expiresAt: pickupCode.expiresAt,
          specialNotes: pickupCode.specialNotes
        }
      };

    } catch (error) {
      logger.error('验证取餐码失败', { error: error.message, code, storeId });
      throw error;
    }
  }

  /**
   * 使用取餐码
   * @param {string} code - 取餐码
   * @param {string} storeId - 门店ID
   * @param {string} staffUserId - 门店员工ID
   * @param {Object} options - 使用选项
   * @returns {Promise<Object>} 使用结果
   */
  async usePickupCode(code, storeId, staffUserId, options = {}) {
    try {
      // 先验证取餐码
      const verifyResult = await this.verifyPickupCode(code, storeId, options);
      if (!verifyResult.success) {
        throw new BusinessError(verifyResult.error);
      }

      // 获取取餐码记录
      const pickupCode = await PickupCode.findOne({
        code: code.toUpperCase(),
        storeId,
        status: 'active'
      });

      if (!pickupCode) {
        throw new BusinessError('取餐码状态异常');
      }

      // 验证员工权限
      const staff = await User.findById(staffUserId);
      if (!staff || !staff.roles.includes('store_staff')) {
        throw new BusinessError('只有门店员工可以确认取餐');
      }

      // 标记取餐码为已使用
      await pickupCode.markAsUsed(staffUserId, {
        verificationMethod: options.verificationMethod || 'manual',
        deviceId: options.deviceId,
        deviceType: options.deviceType,
        ipAddress: options.ipAddress,
        pickupPerson: options.pickupPerson
      });

      // 更新订单状态为已取餐
      await Order.findByIdAndUpdate(pickupCode.orderId, {
        status: 'completed',
        completedAt: new Date(),
        pickupInfo: {
          pickupCode: code,
          pickupAt: new Date(),
          staffId: staffUserId,
          pickupPerson: options.pickupPerson || pickupCode.pickupPerson
        }
      });

      logger.info('取餐码使用成功', {
        code,
        orderId: pickupCode.orderId,
        staffUserId,
        storeId
      });

      return {
        success: true,
        message: '取餐确认成功',
        data: {
          orderId: pickupCode.orderId,
          orderNumber: pickupCode.orderNumber,
          pickupTime: new Date(),
          staffId: staffUserId
        }
      };

    } catch (error) {
      logger.error('使用取餐码失败', { error: error.message, code, storeId, staffUserId });
      throw error;
    }
  }

  /**
   * 获取门店的取餐码列表
   * @param {string} storeId - 门店ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Object>} 取餐码列表
   */
  async getStorePickupCodes(storeId, options = {}) {
    try {
      const { 
        page = 1, 
        limit = 20, 
        status, 
        date,
        search 
      } = options;
      
      const skip = (page - 1) * limit;
      
      const query = { storeId };
      
      // 状态筛选
      if (status) {
        query.status = status;
      }
      
      // 日期筛选
      if (date) {
        const startDate = new Date(date);
        startDate.setHours(0, 0, 0, 0);
        const endDate = new Date(date);
        endDate.setHours(23, 59, 59, 999);
        
        query.generatedAt = {
          $gte: startDate,
          $lte: endDate
        };
      }
      
      // 搜索条件
      if (search) {
        query.$or = [
          { code: { $regex: search, $options: 'i' } },
          { orderNumber: { $regex: search, $options: 'i' } },
          { 'pickupPerson.name': { $regex: search, $options: 'i' } },
          { 'pickupPerson.phone': { $regex: search, $options: 'i' } }
        ];
      }

      const [codes, total] = await Promise.all([
        PickupCode.find(query)
          .populate('orderId', 'orderNumber totalAmount items')
          .populate('userId', 'username phone')
          .sort({ generatedAt: -1 })
          .skip(skip)
          .limit(limit),
        PickupCode.countDocuments(query)
      ]);

      return {
        success: true,
        data: {
          codes: codes.map(code => ({
            code: code.code,
            orderId: code.orderId,
            orderNumber: code.orderNumber,
            customerInfo: code.pickupPerson,
            status: code.status,
            generatedAt: code.generatedAt,
            expiresAt: code.expiresAt,
            usedAt: code.usageRecord?.usedAt,
            orderInfo: code.orderId ? {
              totalAmount: code.orderId.totalAmount,
              itemCount: code.orderId.items?.length || 0
            } : null
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
      logger.error('获取门店取餐码列表失败', { error: error.message, storeId });
      throw error;
    }
  }

  /**
   * 取消取餐码
   * @param {string} codeId - 取餐码ID
   * @param {string} operatorId - 操作者ID
   * @param {string} reason - 取消原因
   * @returns {Promise<Object>} 取消结果
   */
  async cancelPickupCode(codeId, operatorId, reason) {
    try {
      const pickupCode = await PickupCode.findById(codeId);
      if (!pickupCode) {
        throw new NotFoundError('取餐码不存在');
      }

      if (pickupCode.status !== 'active') {
        throw new BusinessError('只能取消有效的取餐码');
      }

      // 验证操作权限
      const operator = await User.findById(operatorId);
      if (!operator || (!operator.roles.includes('store_staff') && !operator.roles.includes('admin'))) {
        throw new BusinessError('无权限取消取餐码');
      }

      await pickupCode.cancel(reason);

      logger.info('取餐码取消成功', {
        code: pickupCode.code,
        orderId: pickupCode.orderId,
        operatorId,
        reason
      });

      return {
        success: true,
        message: '取餐码取消成功'
      };

    } catch (error) {
      logger.error('取消取餐码失败', { error: error.message, codeId, operatorId });
      throw error;
    }
  }

  /**
   * 延长取餐码有效期
   * @param {string} codeId - 取餐码ID
   * @param {string} operatorId - 操作者ID
   * @param {number} additionalHours - 延长小时数
   * @returns {Promise<Object>} 延长结果
   */
  async extendPickupCode(codeId, operatorId, additionalHours = 1) {
    try {
      const pickupCode = await PickupCode.findById(codeId);
      if (!pickupCode) {
        throw new NotFoundError('取餐码不存在');
      }

      // 验证操作权限
      const operator = await User.findById(operatorId);
      if (!operator || (!operator.roles.includes('store_staff') && !operator.roles.includes('admin'))) {
        throw new BusinessError('无权限延长取餐码有效期');
      }

      const oldExpiryTime = pickupCode.expiresAt;
      await pickupCode.extendExpiry(additionalHours);

      logger.info('取餐码有效期延长成功', {
        code: pickupCode.code,
        orderId: pickupCode.orderId,
        operatorId,
        oldExpiryTime,
        newExpiryTime: pickupCode.expiresAt,
        additionalHours
      });

      return {
        success: true,
        message: '取餐码有效期延长成功',
        data: {
          newExpiryTime: pickupCode.expiresAt
        }
      };

    } catch (error) {
      logger.error('延长取餐码有效期失败', { error: error.message, codeId, operatorId });
      throw error;
    }
  }

  /**
   * 获取门店取餐码统计
   * @param {string} storeId - 门店ID
   * @param {string} date - 日期 (YYYY-MM-DD)
   * @returns {Promise<Object>} 统计数据
   */
  async getStoreStats(storeId, date = null) {
    try {
      const targetDate = date ? new Date(date) : new Date();
      const stats = await PickupCode.getStoreStats(storeId, targetDate);

      // 计算额外统计
      const activeRate = stats.total > 0 ? (stats.active / stats.total * 100).toFixed(2) : 0;
      const usageRate = stats.total > 0 ? (stats.used / stats.total * 100).toFixed(2) : 0;
      const expiredRate = stats.total > 0 ? (stats.expired / stats.total * 100).toFixed(2) : 0;

      return {
        success: true,
        data: {
          ...stats,
          rates: {
            active: activeRate,
            usage: usageRate,
            expired: expiredRate
          },
          date: targetDate.toISOString().split('T')[0]
        }
      };

    } catch (error) {
      logger.error('获取门店取餐码统计失败', { error: error.message, storeId, date });
      throw error;
    }
  }

  /**
   * 发送取餐码通知
   * @private
   * @param {Object} pickupCode - 取餐码对象
   * @param {Object} order - 订单对象
   */
  async sendPickupCodeNotification(pickupCode, order) {
    try {
      // 这里可以集成短信、邮件、推送等通知服务
      // 示例：发送短信通知
      
      const message = `您的订单${order.orderNumber}已准备就绪，取餐码：${pickupCode.code}，请在${pickupCode.expiresAt.toLocaleString()}前到${order.storeId.name}取餐。`;
      
      // TODO: 集成短信服务
      // await smsService.send(order.userId.phone, message);
      
      // 标记通知状态
      pickupCode.notificationStatus.smsNotified = true;
      pickupCode.notificationStatus.lastNotificationAt = new Date();
      await pickupCode.save();

      logger.info('取餐码通知发送成功', {
        orderId: order._id,
        code: pickupCode.code,
        phone: order.userId.phone
      });

    } catch (error) {
      logger.error('发送取餐码通知失败', { error: error.message, orderId: order._id });
      // 通知失败不影响取餐码创建
    }
  }

  /**
   * 批量处理过期取餐码
   * @returns {Promise<Object>} 处理结果
   */
  async processExpiredCodes() {
    try {
      const expiredCodes = await PickupCode.find({
        status: 'active',
        expiresAt: { $lte: new Date() }
      });

      let processedCount = 0;
      for (const code of expiredCodes) {
        code.status = 'expired';
        await code.save();
        processedCount++;
      }

      logger.info('过期取餐码处理完成', {
        processedCount,
        totalExpired: expiredCodes.length
      });

      return {
        success: true,
        data: {
          processedCount
        }
      };

    } catch (error) {
      logger.error('处理过期取餐码失败', { error: error.message });
      throw error;
    }
  }
}

module.exports = new PickupCodeService();