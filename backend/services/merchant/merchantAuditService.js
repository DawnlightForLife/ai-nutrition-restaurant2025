/**
 * 商家审核历史服务
 * 处理商家审核流程的历史记录和管理
 * @module services/merchant/merchantAuditService
 */

const MerchantAudit = require('../../models/merchant/merchantAuditModel');
const Merchant = require('../../models/merchant/merchantModel');
const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger');

const merchantAuditService = {
  /**
   * 创建审核记录
   * @param {Object} auditData - 审核数据
   * @returns {Promise<Object>} 创建的审核记录
   */
  async createAuditRecord(auditData) {
    try {
      // 获取商家数据快照
      const merchant = await Merchant.findById(auditData.merchantId);
      if (!merchant) {
        return { success: false, message: '找不到指定的商家' };
      }

      // 创建审核记录
      const auditRecord = new MerchantAudit({
        ...auditData,
        merchantDataSnapshot: merchant.toObject(),
        auditCycle: {
          startTime: new Date()
        }
      });

      // 添加初始时间线记录
      auditRecord.addTimelineEntry(
        '审核开始',
        auditData.auditor?.adminName || 'System',
        `开始${auditData.auditType}审核`
      );

      await auditRecord.save();

      logger.info('审核记录创建成功', {
        auditId: auditRecord._id,
        merchantId: auditData.merchantId,
        auditType: auditData.auditType
      });

      return { success: true, data: auditRecord };

    } catch (error) {
      logger.error('创建审核记录失败', { error, auditData });
      return { success: false, message: `创建审核记录失败: ${error.message}` };
    }
  },

  /**
   * 更新审核状态
   * @param {string} auditId - 审核记录ID
   * @param {Object} updateData - 更新数据
   * @returns {Promise<Object>} 更新结果
   */
  async updateAuditStatus(auditId, updateData) {
    try {
      if (!mongoose.Types.ObjectId.isValid(auditId)) {
        return { success: false, message: '无效的审核记录ID' };
      }

      const auditRecord = await MerchantAudit.findById(auditId);
      if (!auditRecord) {
        return { success: false, message: '找不到指定的审核记录' };
      }

      // 更新审核状态
      if (updateData.auditStatus) {
        auditRecord.auditStatus = updateData.auditStatus;
      }

      // 更新审核人信息
      if (updateData.auditor) {
        Object.assign(auditRecord.auditor, updateData.auditor);
      }

      // 更新审核结果
      if (updateData.auditResult) {
        Object.assign(auditRecord.auditResult, updateData.auditResult);
      }

      // 更新审核详情
      if (updateData.auditDetails) {
        Object.assign(auditRecord.auditDetails, updateData.auditDetails);
      }

      // 如果审核完成，设置结束时间和耗时
      if (updateData.auditStatus && ['approved', 'rejected'].includes(updateData.auditStatus)) {
        const endTime = new Date();
        auditRecord.auditCycle.endTime = endTime;
        auditRecord.auditCycle.duration = Math.floor(
          (endTime - auditRecord.auditCycle.startTime) / (1000 * 60)
        ); // 分钟

        // 添加完成时间线记录
        auditRecord.addTimelineEntry(
          '审核完成',
          updateData.auditor?.adminName || 'System',
          `审核结果: ${updateData.auditStatus === 'approved' ? '通过' : '拒绝'}`
        );
      }

      await auditRecord.save();

      logger.info('审核状态更新成功', {
        auditId: auditRecord._id,
        merchantId: auditRecord.merchantId,
        newStatus: updateData.auditStatus
      });

      return { success: true, data: auditRecord };

    } catch (error) {
      logger.error('更新审核状态失败', { error, auditId, updateData });
      return { success: false, message: `更新审核状态失败: ${error.message}` };
    }
  },

  /**
   * 获取商家审核历史
   * @param {string} merchantId - 商家ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Object>} 审核历史列表
   */
  async getMerchantAuditHistory(merchantId, options = {}) {
    try {
      if (!mongoose.Types.ObjectId.isValid(merchantId)) {
        return { success: false, message: '无效的商家ID' };
      }

      const audits = await MerchantAudit.getAuditHistory(merchantId, options);
      const total = await MerchantAudit.countDocuments({ merchantId });

      return {
        success: true,
        data: audits,
        pagination: {
          total,
          limit: options.limit || 10,
          skip: options.skip || 0,
          hasMore: total > (options.skip || 0) + (options.limit || 10)
        }
      };

    } catch (error) {
      logger.error('获取审核历史失败', { error, merchantId });
      return { success: false, message: `获取审核历史失败: ${error.message}` };
    }
  },

  /**
   * 获取审核记录详情
   * @param {string} auditId - 审核记录ID
   * @returns {Promise<Object>} 审核记录详情
   */
  async getAuditRecord(auditId) {
    try {
      if (!mongoose.Types.ObjectId.isValid(auditId)) {
        return { success: false, message: '无效的审核记录ID' };
      }

      const auditRecord = await MerchantAudit.findById(auditId)
        .populate('merchantId', 'businessName businessType contact')
        .populate('userId', 'username email')
        .populate('auditor.adminId', 'username email');

      if (!auditRecord) {
        return { success: false, message: '找不到指定的审核记录' };
      }

      return { success: true, data: auditRecord };

    } catch (error) {
      logger.error('获取审核记录详情失败', { error, auditId });
      return { success: false, message: `获取审核记录详情失败: ${error.message}` };
    }
  },

  /**
   * 添加审核沟通记录
   * @param {string} auditId - 审核记录ID
   * @param {Object} communication - 沟通记录
   * @returns {Promise<Object>} 更新结果
   */
  async addCommunication(auditId, communication) {
    try {
      if (!mongoose.Types.ObjectId.isValid(auditId)) {
        return { success: false, message: '无效的审核记录ID' };
      }

      const auditRecord = await MerchantAudit.findById(auditId);
      if (!auditRecord) {
        return { success: false, message: '找不到指定的审核记录' };
      }

      auditRecord.addCommunication(
        communication.type,
        communication.direction,
        communication.content,
        communication.sender,
        communication.recipient
      );

      await auditRecord.save();

      logger.info('审核沟通记录添加成功', { auditId, communicationType: communication.type });

      return { success: true, data: auditRecord };

    } catch (error) {
      logger.error('添加审核沟通记录失败', { error, auditId });
      return { success: false, message: `添加沟通记录失败: ${error.message}` };
    }
  },

  /**
   * 获取审核统计数据
   * @param {Object} timeRange - 时间范围
   * @returns {Promise<Object>} 统计数据
   */
  async getAuditStatistics(timeRange = {}) {
    try {
      const stats = await MerchantAudit.getAuditStats(timeRange);

      // 计算总体统计
      const totalStats = {
        totalAudits: 0,
        approvedCount: 0,
        rejectedCount: 0,
        pendingCount: 0,
        avgProcessingTime: 0
      };

      let totalDuration = 0;
      let completedAudits = 0;

      stats.forEach(stat => {
        totalStats.totalAudits += stat.total;
        
        if (stat._id === 'approved') {
          totalStats.approvedCount = stat.total;
        } else if (stat._id === 'rejected') {
          totalStats.rejectedCount = stat.total;
        } else if (stat._id === 'pending') {
          totalStats.pendingCount = stat.total;
        }

        // 计算平均处理时间
        stat.types.forEach(type => {
          if (type.avgDuration) {
            totalDuration += type.avgDuration * type.count;
            completedAudits += type.count;
          }
        });
      });

      if (completedAudits > 0) {
        totalStats.avgProcessingTime = Math.round(totalDuration / completedAudits);
      }

      return {
        success: true,
        data: {
          summary: totalStats,
          details: stats
        }
      };

    } catch (error) {
      logger.error('获取审核统计失败', { error });
      return { success: false, message: `获取审核统计失败: ${error.message}` };
    }
  },

  /**
   * 批量处理待审核记录
   * @param {Array} auditIds - 审核记录ID数组
   * @param {Object} batchAction - 批量操作
   * @returns {Promise<Object>} 处理结果
   */
  async batchProcessAudits(auditIds, batchAction) {
    try {
      const results = {
        success: [],
        failed: []
      };

      for (const auditId of auditIds) {
        try {
          const result = await this.updateAuditStatus(auditId, batchAction);
          if (result.success) {
            results.success.push(auditId);
          } else {
            results.failed.push({ auditId, error: result.message });
          }
        } catch (error) {
          results.failed.push({ auditId, error: error.message });
        }
      }

      logger.info('批量审核处理完成', {
        totalCount: auditIds.length,
        successCount: results.success.length,
        failedCount: results.failed.length
      });

      return {
        success: true,
        data: results
      };

    } catch (error) {
      logger.error('批量审核处理失败', { error });
      return { success: false, message: `批量处理失败: ${error.message}` };
    }
  }
};

module.exports = merchantAuditService;