const GuestProfile = require('../../models/user/guestProfileModel');
const User = require('../../models/user/userModel');
const logger = require('../../config/modules/logger');
const { ValidationError, NotFoundError, BusinessError } = require('../../utils/errors');

class GuestProfileService {
  /**
   * 创建游客档案
   * @param {Object} profileData - 档案数据
   * @param {string} createdBy - 创建者ID
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 创建的游客档案
   */
  async createGuestProfile(profileData, createdBy, options = {}) {
    try {
      // 验证创建者权限
      const creator = await User.findById(createdBy);
      if (!creator) {
        throw new ValidationError('创建者不存在');
      }

      // 验证营养师权限
      if (!creator.roles.includes('nutritionist') && !creator.roles.includes('admin')) {
        throw new BusinessError('只有营养师可以创建游客档案');
      }

      // 验证档案数据
      this.validateProfileData(profileData);

      // 创建游客档案
      const guestProfile = await GuestProfile.createGuestProfile(
        profileData, 
        createdBy, 
        options
      );

      logger.info('游客档案创建成功', {
        guestId: guestProfile.guestId,
        createdBy,
        profileDataKeys: Object.keys(profileData)
      });

      return {
        success: true,
        data: {
          guestId: guestProfile.guestId,
          bindingToken: guestProfile.bindingToken,
          expiresAt: guestProfile.expiresAt,
          profileData: guestProfile.profileData
        }
      };

    } catch (error) {
      logger.error('创建游客档案失败', { error: error.message, createdBy });
      throw error;
    }
  }

  /**
   * 通过游客ID获取档案
   * @param {string} guestId - 游客ID
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 游客档案信息
   */
  async getGuestProfile(guestId, options = {}) {
    try {
      const guestProfile = await GuestProfile.findOne({ 
        guestId,
        isDeleted: false
      }).populate('createdBy', 'username email roles');

      if (!guestProfile) {
        throw new NotFoundError('游客档案不存在');
      }

      // 检查是否过期
      if (guestProfile.expiresAt <= new Date()) {
        throw new BusinessError('游客档案已过期');
      }

      // 记录访问日志
      if (options.logAccess) {
        await guestProfile.logAccess('viewed', {
          ipAddress: options.ipAddress,
          userAgent: options.userAgent
        });
      }

      return {
        success: true,
        data: {
          guestId: guestProfile.guestId,
          profileData: guestProfile.profileData,
          bindingStatus: guestProfile.bindingStatus,
          createdBy: guestProfile.createdBy,
          createdAt: guestProfile.createdAt,
          expiresAt: guestProfile.expiresAt,
          nutritionNeeds: guestProfile.calculateNutritionNeeds()
        }
      };

    } catch (error) {
      logger.error('获取游客档案失败', { error: error.message, guestId });
      throw error;
    }
  }

  /**
   * 更新游客档案
   * @param {string} guestId - 游客ID
   * @param {Object} updateData - 更新数据
   * @param {string} operatorId - 操作者ID
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 更新结果
   */
  async updateGuestProfile(guestId, updateData, operatorId, options = {}) {
    try {
      const guestProfile = await GuestProfile.findOne({ 
        guestId,
        isDeleted: false
      });

      if (!guestProfile) {
        throw new NotFoundError('游客档案不存在');
      }

      // 检查权限
      const operator = await User.findById(operatorId);
      if (!operator || (!operator.roles.includes('nutritionist') && !operator.roles.includes('admin'))) {
        throw new BusinessError('无权限修改游客档案');
      }

      // 验证更新数据
      if (updateData.profileData) {
        this.validateProfileData(updateData.profileData);
      }

      // 更新档案数据
      if (updateData.profileData) {
        guestProfile.profileData = { ...guestProfile.profileData, ...updateData.profileData };
      }

      // 记录访问日志
      await guestProfile.logAccess('updated', {
        ipAddress: options.ipAddress,
        userAgent: options.userAgent
      });

      await guestProfile.save();

      logger.info('游客档案更新成功', {
        guestId,
        operatorId,
        updateKeys: Object.keys(updateData)
      });

      return {
        success: true,
        data: {
          guestId: guestProfile.guestId,
          profileData: guestProfile.profileData,
          nutritionNeeds: guestProfile.calculateNutritionNeeds()
        }
      };

    } catch (error) {
      logger.error('更新游客档案失败', { error: error.message, guestId, operatorId });
      throw error;
    }
  }

  /**
   * 通过绑定令牌获取档案
   * @param {string} bindingToken - 绑定令牌
   * @returns {Promise<Object>} 游客档案信息
   */
  async getProfileByBindingToken(bindingToken) {
    try {
      const guestProfile = await GuestProfile.findByBindingToken(bindingToken);

      if (!guestProfile) {
        throw new NotFoundError('绑定令牌无效或已过期');
      }

      return {
        success: true,
        data: {
          guestId: guestProfile.guestId,
          profileData: guestProfile.profileData,
          createdBy: guestProfile.createdBy,
          nutritionNeeds: guestProfile.calculateNutritionNeeds()
        }
      };

    } catch (error) {
      logger.error('通过绑定令牌获取档案失败', { error: error.message });
      throw error;
    }
  }

  /**
   * 绑定游客档案到正式用户
   * @param {string} bindingToken - 绑定令牌
   * @param {string} userId - 用户ID
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 绑定结果
   */
  async bindToUser(bindingToken, userId, options = {}) {
    try {
      const guestProfile = await GuestProfile.findByBindingToken(bindingToken);
      if (!guestProfile) {
        throw new NotFoundError('绑定令牌无效或已过期');
      }

      // 检查用户是否存在
      const user = await User.findById(userId);
      if (!user) {
        throw new NotFoundError('用户不存在');
      }

      // 检查用户是否已有营养档案
      const existingProfile = await User.findById(userId).select('nutritionProfile');
      if (existingProfile && existingProfile.nutritionProfile) {
        // 如果用户已有档案，合并数据
        await this.mergeProfileData(userId, guestProfile.profileData);
      } else {
        // 如果用户没有档案，直接设置
        await User.findByIdAndUpdate(userId, {
          nutritionProfile: guestProfile.profileData
        });
      }

      // 绑定游客档案
      await guestProfile.bindToUser(userId, options);

      logger.info('游客档案绑定成功', {
        guestId: guestProfile.guestId,
        userId,
        bindingToken
      });

      return {
        success: true,
        data: {
          userId,
          guestId: guestProfile.guestId,
          profileData: guestProfile.profileData
        }
      };

    } catch (error) {
      logger.error('绑定游客档案失败', { error: error.message, userId });
      throw error;
    }
  }

  /**
   * 获取营养师创建的游客档案列表
   * @param {string} nutritionistId - 营养师ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Object>} 档案列表
   */
  async getNutritionistGuestProfiles(nutritionistId, options = {}) {
    try {
      const { page = 1, limit = 20, status, search } = options;
      const skip = (page - 1) * limit;

      const query = {
        createdBy: nutritionistId,
        isDeleted: false
      };

      // 状态筛选
      if (status) {
        query.bindingStatus = status;
      }

      // 搜索条件
      if (search) {
        query.$or = [
          { guestId: { $regex: search, $options: 'i' } },
          { 'profileData.healthGoals': { $in: [search] } }
        ];
      }

      const [profiles, total] = await Promise.all([
        GuestProfile.find(query)
          .select('guestId profileData bindingStatus createdAt expiresAt')
          .sort({ createdAt: -1 })
          .skip(skip)
          .limit(limit),
        GuestProfile.countDocuments(query)
      ]);

      return {
        success: true,
        data: {
          profiles: profiles.map(profile => ({
            guestId: profile.guestId,
            profileData: profile.profileData,
            bindingStatus: profile.bindingStatus,
            createdAt: profile.createdAt,
            expiresAt: profile.expiresAt,
            isExpired: profile.expiresAt <= new Date()
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
      logger.error('获取营养师游客档案列表失败', { error: error.message, nutritionistId });
      throw error;
    }
  }

  /**
   * 删除游客档案
   * @param {string} guestId - 游客ID
   * @param {string} operatorId - 操作者ID
   * @param {string} reason - 删除原因
   * @returns {Promise<Object>} 删除结果
   */
  async deleteGuestProfile(guestId, operatorId, reason) {
    try {
      const guestProfile = await GuestProfile.findOne({ 
        guestId,
        isDeleted: false
      });

      if (!guestProfile) {
        throw new NotFoundError('游客档案不存在');
      }

      // 检查权限
      const operator = await User.findById(operatorId);
      if (!operator) {
        throw new NotFoundError('操作者不存在');
      }

      // 只有创建者或管理员可以删除
      if (guestProfile.createdBy.toString() !== operatorId && !operator.roles.includes('admin')) {
        throw new BusinessError('无权限删除此游客档案');
      }

      // 软删除
      guestProfile.isDeleted = true;
      guestProfile.deletion = {
        deletedAt: new Date(),
        deletedBy: operatorId,
        reason
      };

      await guestProfile.save();

      logger.info('游客档案删除成功', {
        guestId,
        operatorId,
        reason
      });

      return {
        success: true,
        message: '游客档案删除成功'
      };

    } catch (error) {
      logger.error('删除游客档案失败', { error: error.message, guestId, operatorId });
      throw error;
    }
  }

  /**
   * 验证档案数据
   * @private
   * @param {Object} profileData - 档案数据
   */
  validateProfileData(profileData) {
    const required = ['age', 'gender', 'height', 'weight'];
    const missing = required.filter(field => !profileData[field]);
    
    if (missing.length > 0) {
      throw new ValidationError(`缺少必填字段: ${missing.join(', ')}`);
    }

    // 数据范围验证
    if (profileData.age < 0 || profileData.age > 150) {
      throw new ValidationError('年龄必须在0-150之间');
    }

    if (profileData.height < 50 || profileData.height > 300) {
      throw new ValidationError('身高必须在50-300cm之间');
    }

    if (profileData.weight < 20 || profileData.weight > 500) {
      throw new ValidationError('体重必须在20-500kg之间');
    }

    // BMI合理性检查
    const bmi = profileData.weight / Math.pow(profileData.height / 100, 2);
    if (bmi < 10 || bmi > 50) {
      throw new ValidationError('身高体重数据不合理，请检查输入');
    }
  }

  /**
   * 合并档案数据到用户
   * @private
   * @param {string} userId - 用户ID
   * @param {Object} guestProfileData - 游客档案数据
   */
  async mergeProfileData(userId, guestProfileData) {
    const user = await User.findById(userId);
    const existingProfile = user.nutritionProfile || {};

    // 智能合并逻辑：游客档案数据优先，但保留用户已有的特殊设置
    const mergedProfile = {
      ...existingProfile,
      ...guestProfileData,
      // 保留用户的历史偏好设置
      dietaryPreferences: [
        ...(existingProfile.dietaryPreferences || []),
        ...(guestProfileData.dietaryPreferences || [])
      ].filter((item, index, arr) => arr.indexOf(item) === index), // 去重
      
      allergies: [
        ...(existingProfile.allergies || []),
        ...(guestProfileData.allergies || [])
      ]
    };

    await User.findByIdAndUpdate(userId, {
      nutritionProfile: mergedProfile
    });
  }

  /**
   * 获取游客档案统计
   * @param {string} nutritionistId - 营养师ID（可选）
   * @returns {Promise<Object>} 统计数据
   */
  async getProfileStats(nutritionistId = null) {
    try {
      const query = nutritionistId ? { createdBy: nutritionistId } : {};
      const now = new Date();

      const [totalCount, activeCount, expiredCount, boundCount] = await Promise.all([
        GuestProfile.countDocuments({ ...query, isDeleted: false }),
        GuestProfile.countDocuments({ 
          ...query, 
          isDeleted: false, 
          bindingStatus: 'pending',
          expiresAt: { $gt: now }
        }),
        GuestProfile.countDocuments({ 
          ...query, 
          isDeleted: false, 
          expiresAt: { $lte: now }
        }),
        GuestProfile.countDocuments({ 
          ...query, 
          isDeleted: false, 
          bindingStatus: 'bound'
        })
      ]);

      return {
        success: true,
        data: {
          total: totalCount,
          active: activeCount,
          expired: expiredCount,
          bound: boundCount,
          bindingRate: totalCount > 0 ? (boundCount / totalCount * 100).toFixed(2) : 0
        }
      };

    } catch (error) {
      logger.error('获取游客档案统计失败', { error: error.message, nutritionistId });
      throw error;
    }
  }
}

module.exports = new GuestProfileService();