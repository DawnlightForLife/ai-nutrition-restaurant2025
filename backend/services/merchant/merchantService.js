const Merchant = require('../../models/merchant/merchantModel');
const mongoose = require('mongoose');

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
      
      return { success: true, data: merchant };
    } catch (error) {
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
        limit = 10, 
        skip = 0, 
        sort = { 'stats.avgRating': -1 } 
      } = options;

      const query = { 'verification.isVerified': true, 'accountStatus.isActive': true };
      
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
      if (!mongoose.Types.ObjectId.isValid(id)) {
        return { success: false, message: '无效的商家ID' };
      }
      
      const merchant = await Merchant.findById(id);
      
      if (!merchant) {
        return { success: false, message: '找不到指定的商家' };
      }
      
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
      
      await merchant.save();
      
      return { success: true, data: merchant };
    } catch (error) {
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
      
      return { success: true, data: merchant };
    } catch (error) {
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
      return { success: false, message: `更新商家评分失败: ${error.message}` };
    }
  }
};

module.exports = merchantService;