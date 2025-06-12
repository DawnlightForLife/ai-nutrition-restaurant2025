/**
 * 商家服务模块（merchantService）
 * 提供商家相关的业务逻辑处理，包括创建、更新、审核、评分等
 * 支持基于用户ID查询、分页获取、城市/类型筛选、认证审核等功能
 * 所有操作基于 Merchant 模型并包含数据完整性校验
 * 与 storeService、dishService 等模块协作支撑商家端功能
 * @module services/merchant/merchantService
 */
const Merchant = require('../../models/merchant/merchantModel');
const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');
const onMerchantRegistered = require('../../hooks/merchant/onMerchantRegistered');
const onMerchantApproved = require('../../hooks/merchant/onMerchantApproved');
// const merchantAuditService = require('./merchantAuditService');

const merchantService = {
  /**
   * 创建商家
   * 
   * @param {Object} data - 商家数据
   * @returns {Promise<Object>} 创建的商家
   */
  async createMerchant(data) {
    try {
      // 检查是否已存在
      const existingMerchant = await Merchant.findOne({ userId: data.userId });
      
      if (existingMerchant) {
        return { success: false, message: '该用户已经有商家资料' };
      }
      
      const merchant = new Merchant(data);
      await merchant.save();
      
      // 创建初始审核记录
      try {
        // await merchantAuditService.createAuditRecord({
        //   merchantId: merchant._id,
        //   userId: data.userId,
        //   auditType: 'initial_registration',
        //   auditStatus: 'pending'
        // });
      } catch (auditError) {
        logger.error('创建审核记录失败', { auditError, merchantId: merchant._id });
        // 审核记录创建失败不影响主流程
      }

      // 触发商家注册Hook
      try {
        const User = require('../../models/user/userModel');
        const user = await User.findById(data.userId);
        if (user) {
          await onMerchantRegistered(merchant, user);
        }
      } catch (hookError) {
        logger.error('商家注册Hook执行失败', { hookError, merchantId: merchant._id });
        // Hook失败不影响主流程
      }
      
      return { success: true, data: merchant };
    } catch (error) {
      logger.error('创建商家失败', { error });
      return { success: false, message: `创建商家失败: ${error.message}` };
    }
  },


  /**
   * 获取商家列表
   * 
   * @param {Object} options - 过滤选项
   * @returns {Promise<Object>} 商家列表
   */
  async getMerchants(options = {}) {
    try {
      const { 
        businessType, 
        city,
        hasNutritionist,
        specialtyDiet,
        verificationStatus,
        limit = 10, 
        skip = 0, 
        sort = { 'stats.avgRating': -1 } 
      } = options;

      const query = {};
      
      // 如果指定了验证状态，按状态筛选；否则只显示已验证的活跃商家
      if (verificationStatus) {
        query['verification.verificationStatus'] = verificationStatus;
      } else {
        query['verification.isVerified'] = true;
        query['accountStatus.isActive'] = true;
      }
      
      if (businessType) {
        query.businessType = businessType;
      }
      
      if (city) {
        query['address.city'] = city;
      }
      
      if (hasNutritionist === true) {
        query['nutritionFeatures.hasNutritionist'] = true;
      }
      
      if (specialtyDiet) {
        query['nutritionFeatures.specialtyDiets'] = specialtyDiet;
      }

      const [merchants, total] = await Promise.all([
        Merchant.find(query)
          .populate('user', 'username email')
          .sort(sort)
          .skip(skip)
          .limit(limit),
        Merchant.countDocuments(query)
      ]);

      return {
        success: true,
        data: merchants.map(merchant => merchant.getPublicProfile()),
        pagination: {
          total,
          limit,
          skip,
          hasMore: total > skip + limit
        }
      };
    } catch (error) {
      logger.error('获取商家列表失败', { error });
      return { success: false, message: `获取商家列表失败: ${error.message}` };
    }
  },

  /**
   * 根据ID获取商家
   * 
   * @param {string} id - 商家ID
   * @returns {Promise<Object>} 商家详情
   */
  async getMerchantById(id) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的商家ID' };
      }
      
      const merchant = await Merchant.findById(id)
        .populate('user', 'username email profileImage');
      
      if (!merchant) {
        return { success: false, message: '找不到指定的商家' };
      }
      
      return { success: true, data: merchant };
    } catch (error) {
      logger.error('获取商家详情失败', { error });
      return { success: false, message: `获取商家详情失败: ${error.message}` };
    }
  },

  /**
   * 更新商家
   * 
   * @param {string} id - 商家ID
   * @param {Object} data - 更新数据
   * @returns {Promise<Object>} 更新后的商家
   */
  async updateMerchant(id, data) {
    try {
      logger.info('开始更新商家', { merchantId: id, updateData: data });
      
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的商家ID' };
      }
      
      const merchant = await Merchant.findById(id);
      
      if (!merchant) {
        return { success: false, message: '找不到指定的商家' };
      }
      
      logger.info('找到商家，当前状态', { 
        merchantId: id, 
        currentStatus: merchant.verification.verificationStatus,
        newStatus: data.verification?.verificationStatus 
      });
      
      // 检查是否是被拒绝的商家重新提交申请
      const isResubmission = merchant.verification.verificationStatus === 'rejected' && 
                            data.verification && 
                            data.verification.verificationStatus === 'pending';
      
      logger.info('重新提交检查', { 
        isResubmission, 
        currentStatus: merchant.verification.verificationStatus,
        hasVerificationData: !!data.verification,
        newStatus: data.verification?.verificationStatus 
      });

      // 更新各个部分
      if (data.businessName) merchant.businessName = data.businessName;
      if (data.businessType) merchant.businessType = data.businessType;
      if (data.contact) Object.assign(merchant.contact, data.contact);
      if (data.address) Object.assign(merchant.address, data.address);
      if (data.businessProfile) Object.assign(merchant.businessProfile, data.businessProfile);
      if (data.nutritionFeatures) Object.assign(merchant.nutritionFeatures, data.nutritionFeatures);
      if (data.merchantSettings) Object.assign(merchant.merchantSettings, data.merchantSettings);
      if (data.menuSettings) Object.assign(merchant.menuSettings, data.menuSettings);
      if (data.paymentSettings) Object.assign(merchant.paymentSettings, data.paymentSettings);
      if (data.dataSharing) Object.assign(merchant.dataSharing, data.dataSharing);
      
      // 处理验证状态更新（重新提交申请）
      if (data.verification) {
        if (isResubmission) {
          // 重新提交申请时，重置审核状态
          merchant.verification.verificationStatus = 'pending';
          merchant.verification.rejectionReason = null;
          merchant.verification.verifiedBy = null;
          merchant.verification.verifiedAt = null;
          merchant.verification.resubmissionCount = (merchant.verification.resubmissionCount || 0) + 1;
          merchant.verification.lastResubmissionDate = new Date();
          
          logger.info('重新提交状态更新', { 
            merchantId: id,
            newStatus: 'pending',
            resubmissionCount: merchant.verification.resubmissionCount 
          });
        } else {
          // 其他情况下的验证信息更新
          Object.assign(merchant.verification, data.verification);
          logger.info('普通验证状态更新', { merchantId: id, verification: data.verification });
        }
      }
      
      await merchant.save();
      
      logger.info('商家信息保存完成', { 
        merchantId: id, 
        finalStatus: merchant.verification.verificationStatus 
      });
      
      // 如果是重新提交申请，创建新的审核记录并触发Hook
      if (isResubmission) {
        try {
          // 创建新的审核记录
          // await merchantAuditService.createAuditRecord({
          //   merchantId: merchant._id,
          //   userId: merchant.userId,
          //   auditType: 'resubmission',
          //   auditStatus: 'pending',
          //   merchantDataSnapshot: merchant.toObject()
          // });
          
          // 触发重新提交Hook
          const User = require('../../models/user/userModel');
          const user = await User.findById(merchant.userId);
          if (user) {
            await onMerchantRegistered(merchant, user);
          }
          
          logger.info('商家重新提交申请，创建新审核记录并触发通知', { 
            merchantId: merchant._id,
            resubmissionCount: merchant.verification.resubmissionCount 
          });
        } catch (auditError) {
          logger.error('创建重新提交审核记录失败', { auditError, merchantId: merchant._id });
        }
      }
      
      return { success: true, data: merchant };
    } catch (error) {
      logger.error('更新商家失败', { error });
      return { success: false, message: `更新商家失败: ${error.message}` };
    }
  },

  /**
   * 删除商家
   * 
   * @param {string} id - 商家ID
   * @returns {Promise<Object>} 操作结果
   */
  async deleteMerchant(id) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的商家ID' };
      }
      
      const result = await Merchant.findByIdAndDelete(id);
      
      if (!result) {
        return { success: false, message: '找不到指定的商家' };
      }
      
      return { success: true, message: '商家信息已成功删除' };
    } catch (error) {
      logger.error('删除商家失败', { error });
      return { success: false, message: `删除商家失败: ${error.message}` };
    }
  },

  /**
   * 审核商家资质
   * 
   * @param {string} id - 商家ID
   * @param {Object} verificationData - 审核数据
   * @returns {Promise<Object>} 更新后的商家
   */
  async verifyMerchant(id, verificationData) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的商家ID' };
      }
      
      const merchant = await Merchant.findById(id);
      
      if (!merchant) {
        return { success: false, message: '找不到指定的商家' };
      }
      
      // 更新审核信息
      merchant.verification.verificationStatus = verificationData.verificationStatus;
      
      if (verificationData.rejectionReason) {
        merchant.verification.rejectionReason = verificationData.rejectionReason;
      }
      
      merchant.verification.verifiedBy = verificationData.verifiedBy;
      merchant.verification.verifiedAt = verificationData.verifiedAt;
      
      // 根据审核结果更新状态
      if (verificationData.verificationStatus === 'approved') {
        merchant.verification.isVerified = true;
        merchant.accountStatus.isActive = true;
      } else if (verificationData.verificationStatus === 'rejected') {
        merchant.verification.isVerified = false;
      }
      
      await merchant.save();
      
      // 更新审核历史记录
      try {
        const MerchantAudit = require('../../models/merchant/merchantAuditModel');
        const latestAudit = await MerchantAudit.findOne({ 
          merchantId: id, 
          auditStatus: 'pending' 
        }).sort({ createdAt: -1 });

        if (latestAudit) {
          // await merchantAuditService.updateAuditStatus(latestAudit._id, {
          //   auditStatus: verificationData.verificationStatus,
          //   auditor: {
          //     adminId: verificationData.verifiedBy,
          //     auditTime: verificationData.verifiedAt
          //   },
          //   auditResult: {
          //     decision: verificationData.verificationStatus,
          //     rejectionReason: verificationData.rejectionReason
          //   }
          // });
        }
      } catch (auditError) {
        logger.error('更新审核历史失败', { auditError, merchantId: id });
        // 审核历史更新失败不影响主流程
      }
      
      // 如果是审核通过，触发相应Hook
      if (verificationData.verificationStatus === 'approved') {
        try {
          const User = require('../../models/user/userModel');
          const user = await User.findById(merchant.userId);
          if (user) {
            await onMerchantApproved(merchant, user, verificationData);
          }
        } catch (hookError) {
          logger.error('商家审核通过Hook执行失败', { hookError, merchantId: merchant._id });
          // Hook失败不影响主流程
        }
      }
      
      return { success: true, data: merchant };
    } catch (error) {
      logger.error('审核商家失败', { error });
      return { success: false, message: `审核商家失败: ${error.message}` };
    }
  },

  /**
   * 根据用户ID获取商家
   * 
   * @param {string} userId - 用户ID
   * @returns {Promise<Object>} 商家详情
   */
  async getMerchantByUserId(userId) {
    try {
      if (!mongoose.Types.ObjectId.isValid(userId)) {
        return { success: false, message: '无效的用户ID' };
      }
      
      const merchant = await Merchant.findOne({ userId })
        .populate('user', 'username email profileImage');
      
      if (!merchant) {
        return { success: false, message: '找不到此用户的商家资料' };
      }
      
      return { success: true, data: merchant };
    } catch (error) {
      logger.error('通过用户ID获取商家失败', { error });
      return { success: false, message: `获取商家详情失败: ${error.message}` };
    }
  },

  /**
   * 更新商家评分
   * 
   * @param {string} id - 商家ID
   * @param {number} rating - 新评分
   * @returns {Promise<Object>} 更新后的商家
   */
  async updateMerchantRating(id, rating) {
    try {
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的商家ID' };
      }
      
      const merchant = await Merchant.findById(id);
      
      if (!merchant) {
        return { success: false, message: '找不到指定的商家' };
      }
      
      // 更新评分
      const oldTotal = merchant.stats.avgRating * merchant.stats.ratingCount;
      merchant.stats.ratingCount += 1;
      merchant.stats.avgRating = (oldTotal + rating) / merchant.stats.ratingCount;
      
      await merchant.save();
      
      return { success: true, data: merchant };
    } catch (error) {
      logger.error('更新商家评分失败', { error });
      return { success: false, message: `更新商家评分失败: ${error.message}` };
    }
  },

  /**
   * 获取商家统计数据
   * 
   * @returns {Promise<Object>} 商家统计数据
   */
  async getMerchantStats() {
    try {
      const [total, pending, approved, rejected, active] = await Promise.all([
        Merchant.countDocuments(),
        Merchant.countDocuments({ 'verification.verificationStatus': 'pending' }),
        Merchant.countDocuments({ 'verification.verificationStatus': 'approved' }),
        Merchant.countDocuments({ 'verification.verificationStatus': 'rejected' }),
        Merchant.countDocuments({ 'accountStatus.isActive': true })
      ]);

      // 按商家类型统计
      const byType = await Merchant.aggregate([
        {
          $group: {
            _id: '$businessType',
            count: { $sum: 1 }
          }
        }
      ]);

      // 按城市统计
      const byCity = await Merchant.aggregate([
        {
          $group: {
            _id: '$address.city',
            count: { $sum: 1 }
          }
        },
        { $sort: { count: -1 } },
        { $limit: 10 }
      ]);

      // 最近7天新增商家
      const sevenDaysAgo = new Date();
      sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
      const recentNew = await Merchant.countDocuments({
        createdAt: { $gte: sevenDaysAgo }
      });

      return {
        success: true,
        data: {
          total,
          pending,
          approved,
          rejected,
          active,
          recentNew,
          byType: byType.reduce((acc, curr) => {
            acc[curr._id || 'unknown'] = curr.count;
            return acc;
          }, {}),
          topCities: byCity.map(city => ({
            city: city._id || '未知',
            count: city.count
          }))
        }
      };
    } catch (error) {
      logger.error('获取商家统计失败', { error });
      return { success: false, message: `获取商家统计失败: ${error.message}` };
    }
  }
};

module.exports = merchantService;