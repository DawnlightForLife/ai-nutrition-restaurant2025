const UserPermission = require('../../models/user/userPermissionModel');
const User = require('../../models/user/userModel');
const logger = require('../../config/modules/logger');

/**
 * 用户权限管理服务
 */
class UserPermissionService {
  
  /**
   * 申请权限
   * @param {string} userId - 用户ID
   * @param {string} permissionType - 权限类型 (merchant/nutritionist)
   * @param {Object} applicationData - 申请数据
   * @returns {Promise<Object>}
   */
  async applyPermission(userId, permissionType, applicationData) {
    try {
      // 检查是否已有相同类型的权限申请
      const existingPermission = await UserPermission.findOne({
        userId,
        permissionType
      });
      
      if (existingPermission) {
        if (existingPermission.status === 'approved') {
          throw new Error('用户已拥有此权限');
        }
        if (existingPermission.status === 'pending') {
          throw new Error('已有待审核的申请，请等待处理');
        }
        // 如果是被拒绝或撤销的，可以重新申请
        if (existingPermission.status === 'rejected' || existingPermission.status === 'revoked') {
          existingPermission.status = 'pending';
          existingPermission.applicationData = {
            ...applicationData,
            appliedAt: new Date()
          };
          await existingPermission.save();
          return existingPermission;
        }
      }
      
      // 创建新的权限申请
      const permission = new UserPermission({
        userId,
        permissionType,
        status: 'pending',
        applicationData: {
          ...applicationData,
          appliedAt: new Date()
        }
      });
      
      await permission.save();
      logger.info(`用户 ${userId} 申请 ${permissionType} 权限`);
      
      return permission;
    } catch (error) {
      logger.error('申请权限失败:', error);
      throw error;
    }
  }
  
  /**
   * 获取待审核的权限申请列表
   * @param {Object} options - 查询选项
   * @returns {Promise<Array>}
   */
  async getPendingApplications(options = {}) {
    try {
      const {
        permissionType,
        page = 1,
        limit = 20,
        sortBy = 'createdAt',
        sortOrder = -1
      } = options;
      
      const query = { status: 'pending' };
      if (permissionType) {
        query.permissionType = permissionType;
      }
      
      const skip = (page - 1) * limit;
      const sort = { [sortBy]: sortOrder };
      
      const [applications, total] = await Promise.all([
        UserPermission.find(query)
          .populate('userId', 'nickname phone realName role')
          .sort(sort)
          .skip(skip)
          .limit(limit)
          .lean(),
        UserPermission.countDocuments(query)
      ]);
      
      return {
        applications,
        pagination: {
          current: page,
          total: Math.ceil(total / limit),
          count: applications.length,
          totalCount: total
        }
      };
    } catch (error) {
      logger.error('获取待审核申请失败:', error);
      throw error;
    }
  }
  
  /**
   * 审核权限申请
   * @param {string} permissionId - 权限申请ID
   * @param {string} action - 操作 (approve/reject)
   * @param {string} adminId - 管理员ID
   * @param {string} comment - 审核意见
   * @returns {Promise<Object>}
   */
  async reviewApplication(permissionId, action, adminId, comment = '') {
    try {
      const permission = await UserPermission.findById(permissionId);
      if (!permission) {
        throw new Error('权限申请不存在');
      }
      
      if (permission.status !== 'pending') {
        throw new Error('该申请已被处理');
      }
      
      if (action === 'approve') {
        await permission.grant(adminId, comment);
        logger.info(`管理员 ${adminId} 批准了权限申请 ${permissionId}`);
      } else if (action === 'reject') {
        await permission.reject(adminId, comment);
        logger.info(`管理员 ${adminId} 拒绝了权限申请 ${permissionId}`);
      } else {
        throw new Error('无效的操作类型');
      }
      
      return permission;
    } catch (error) {
      logger.error('审核权限申请失败:', error);
      throw error;
    }
  }
  
  /**
   * 批量审核权限申请
   * @param {Array} permissionIds - 权限申请ID列表
   * @param {string} action - 操作 (approve/reject)
   * @param {string} adminId - 管理员ID
   * @param {string} comment - 审核意见
   * @returns {Promise<Object>}
   */
  async batchReviewApplications(permissionIds, action, adminId, comment = '') {
    try {
      if (action === 'approve') {
        const result = await UserPermission.batchGrant(permissionIds, adminId, comment);
        logger.info(`管理员 ${adminId} 批量批准了 ${result.matchedCount} 个权限申请`);
        return result;
      } else if (action === 'reject') {
        const result = await UserPermission.updateMany(
          { _id: { $in: permissionIds }, status: 'pending' },
          {
            $set: {
              status: 'rejected',
              'reviewData.reviewComment': comment,
              'reviewData.reviewedAt': new Date(),
              'reviewData.reviewedBy': adminId
            }
          }
        );
        logger.info(`管理员 ${adminId} 批量拒绝了 ${result.matchedCount} 个权限申请`);
        return result;
      } else {
        throw new Error('无效的操作类型');
      }
    } catch (error) {
      logger.error('批量审核权限申请失败:', error);
      throw error;
    }
  }
  
  /**
   * 撤销用户权限
   * @param {string} userId - 用户ID
   * @param {string} permissionType - 权限类型
   * @param {string} adminId - 管理员ID
   * @param {string} reason - 撤销原因
   * @returns {Promise<Object>}
   */
  async revokePermission(userId, permissionType, adminId, reason = '') {
    try {
      const permission = await UserPermission.findOne({
        userId,
        permissionType,
        status: 'approved'
      });
      
      if (!permission) {
        throw new Error('用户没有此权限');
      }
      
      await permission.revoke(adminId, reason);
      logger.info(`管理员 ${adminId} 撤销了用户 ${userId} 的 ${permissionType} 权限`);
      
      return permission;
    } catch (error) {
      logger.error('撤销权限失败:', error);
      throw error;
    }
  }
  
  /**
   * 检查用户权限
   * @param {string} userId - 用户ID
   * @param {string} permissionType - 权限类型
   * @returns {Promise<boolean>}
   */
  async checkPermission(userId, permissionType) {
    try {
      return await UserPermission.hasPermission(userId, permissionType);
    } catch (error) {
      logger.error('检查权限失败:', error);
      return false;
    }
  }
  
  /**
   * 获取用户的所有权限
   * @param {string} userId - 用户ID
   * @returns {Promise<Array>}
   */
  async getUserPermissions(userId) {
    try {
      return await UserPermission.getUserPermissions(userId);
    } catch (error) {
      logger.error('获取用户权限失败:', error);
      throw error;
    }
  }
  
  /**
   * 获取用户权限详情
   * @param {string} userId - 用户ID
   * @returns {Promise<Array>}
   */
  async getUserPermissionDetails(userId) {
    try {
      console.log('[UserPermissionService] 开始查询用户权限:', userId);
      
      const permissions = await UserPermission.find({ userId })
        .sort({ createdAt: -1 })
        .lean();
      
      console.log('[UserPermissionService] 查询到权限数量:', permissions.length);
      
      return permissions;
    } catch (error) {
      console.error('[UserPermissionService] 获取用户权限详情失败:', error);
      logger.error('获取用户权限详情失败:', error);
      throw error;
    }
  }
  
  /**
   * 获取权限统计信息
   * @returns {Promise<Object>}
   */
  async getPermissionStats() {
    try {
      const [merchantStats, nutritionistStats] = await Promise.all([
        UserPermission.aggregate([
          { $match: { permissionType: 'merchant' } },
          { $group: { _id: '$status', count: { $sum: 1 } } }
        ]),
        UserPermission.aggregate([
          { $match: { permissionType: 'nutritionist' } },
          { $group: { _id: '$status', count: { $sum: 1 } } }
        ])
      ]);
      
      const formatStats = (stats) => {
        const result = { pending: 0, approved: 0, rejected: 0, revoked: 0 };
        stats.forEach(stat => {
          result[stat._id] = stat.count;
        });
        return result;
      };
      
      return {
        merchant: formatStats(merchantStats),
        nutritionist: formatStats(nutritionistStats)
      };
    } catch (error) {
      logger.error('获取权限统计失败:', error);
      throw error;
    }
  }
}

module.exports = new UserPermissionService();