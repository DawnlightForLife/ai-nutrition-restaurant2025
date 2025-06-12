const userPermissionService = require('../../services/user/userPermissionService');
const { responseHelper } = require('../../utils');

/**
 * 用户权限管理控制器
 */
class UserPermissionController {
  
  /**
   * 申请权限
   */
  async applyPermission(req, res) {
    try {
      const { permissionType, reason, contactInfo, qualifications } = req.body;
      const userId = req.user.id;
      
      // 验证必要字段
      if (!permissionType || !['merchant', 'nutritionist'].includes(permissionType)) {
        return responseHelper.error(res, '无效的权限类型', 400);
      }
      
      if (!reason || reason.trim().length === 0) {
        return responseHelper.error(res, '申请原因不能为空', 400);
      }
      
      const applicationData = {
        reason: reason.trim(),
        contactInfo: contactInfo || {},
        qualifications: qualifications || ''
      };
      
      const permission = await userPermissionService.applyPermission(
        userId,
        permissionType,
        applicationData
      );
      
      return responseHelper.success(res, permission, '权限申请已提交，请等待审核');
    } catch (error) {
      return responseHelper.error(res, error.message, 400);
    }
  }
  
  /**
   * 获取用户自己的权限状态
   */
  async getUserPermissions(req, res) {
    try {
      const userId = req.user.id;
      
      const permissions = await userPermissionService.getUserPermissionDetails(userId);
      
      return responseHelper.success(res, permissions);
    } catch (error) {
      return responseHelper.error(res, error.message, 500);
    }
  }
  
  /**
   * 检查用户权限
   */
  async checkPermission(req, res) {
    try {
      const { permissionType } = req.params;
      const userId = req.user.id;
      
      if (!['merchant', 'nutritionist'].includes(permissionType)) {
        return responseHelper.error(res, '无效的权限类型', 400);
      }
      
      const hasPermission = await userPermissionService.checkPermission(userId, permissionType);
      
      return responseHelper.success(res, {
        hasPermission,
        permissionType
      });
    } catch (error) {
      return responseHelper.error(res, error.message, 500);
    }
  }
  
  // ========== 管理员功能 ==========
  
  /**
   * 获取待审核的权限申请列表
   */
  async getPendingApplications(req, res) {
    try {
      const {
        permissionType,
        page = 1,
        limit = 20,
        sortBy = 'createdAt',
        sortOrder = 'desc'
      } = req.query;
      
      const options = {
        permissionType,
        page: parseInt(page),
        limit: parseInt(limit),
        sortBy,
        sortOrder: sortOrder === 'desc' ? -1 : 1
      };
      
      const result = await userPermissionService.getPendingApplications(options);
      
      return responseHelper.success(res, result);
    } catch (error) {
      return responseHelper.error(res, error.message, 500);
    }
  }
  
  /**
   * 审核权限申请
   */
  async reviewApplication(req, res) {
    try {
      const { permissionId } = req.params;
      const { action, comment = '' } = req.body;
      const adminId = req.user.id;
      
      if (!['approve', 'reject'].includes(action)) {
        return responseHelper.error(res, '无效的操作类型', 400);
      }
      
      const permission = await userPermissionService.reviewApplication(
        permissionId,
        action,
        adminId,
        comment
      );
      
      const message = action === 'approve' ? '权限申请已批准' : '权限申请已拒绝';
      return responseHelper.success(res, permission, message);
    } catch (error) {
      return responseHelper.error(res, error.message, 400);
    }
  }
  
  /**
   * 批量审核权限申请
   */
  async batchReviewApplications(req, res) {
    try {
      const { permissionIds, action, comment = '' } = req.body;
      const adminId = req.user.id;
      
      if (!Array.isArray(permissionIds) || permissionIds.length === 0) {
        return responseHelper.error(res, '请选择要处理的申请', 400);
      }
      
      if (!['approve', 'reject'].includes(action)) {
        return responseHelper.error(res, '无效的操作类型', 400);
      }
      
      const result = await userPermissionService.batchReviewApplications(
        permissionIds,
        action,
        adminId,
        comment
      );
      
      const message = action === 'approve' ? 
        `已批准 ${result.matchedCount} 个权限申请` : 
        `已拒绝 ${result.matchedCount} 个权限申请`;
        
      return responseHelper.success(res, result, message);
    } catch (error) {
      return responseHelper.error(res, error.message, 400);
    }
  }
  
  /**
   * 撤销用户权限
   */
  async revokePermission(req, res) {
    try {
      const { userId, permissionType } = req.params;
      const { reason = '' } = req.body;
      const adminId = req.user.id;
      
      if (!['merchant', 'nutritionist'].includes(permissionType)) {
        return responseHelper.error(res, '无效的权限类型', 400);
      }
      
      const permission = await userPermissionService.revokePermission(
        userId,
        permissionType,
        adminId,
        reason
      );
      
      return responseHelper.success(res, permission, '权限已撤销');
    } catch (error) {
      return responseHelper.error(res, error.message, 400);
    }
  }
  
  /**
   * 直接授予权限（管理员特权）
   */
  async grantPermission(req, res) {
    try {
      const { userId, permissionType, comment = '' } = req.body;
      const adminId = req.user.id;
      
      if (!['merchant', 'nutritionist'].includes(permissionType)) {
        return responseHelper.error(res, '无效的权限类型', 400);
      }
      
      // 创建一个申请记录然后立即批准
      const applicationData = {
        reason: '管理员直接授权',
        contactInfo: {},
        qualifications: comment
      };
      
      const permission = await userPermissionService.applyPermission(
        userId,
        permissionType,
        applicationData
      );
      
      // 立即批准
      await userPermissionService.reviewApplication(
        permission._id,
        'approve',
        adminId,
        comment || '管理员直接授权'
      );
      
      return responseHelper.success(res, permission, '权限已直接授予');
    } catch (error) {
      return responseHelper.error(res, error.message, 400);
    }
  }
  
  /**
   * 获取权限统计信息
   */
  async getPermissionStats(req, res) {
    try {
      const stats = await userPermissionService.getPermissionStats();
      
      return responseHelper.success(res, stats);
    } catch (error) {
      return responseHelper.error(res, error.message, 500);
    }
  }
  
  /**
   * 获取指定用户的权限详情（管理员）
   */
  async getUserPermissionDetails(req, res) {
    try {
      const { userId } = req.params;
      
      const permissions = await userPermissionService.getUserPermissionDetails(userId);
      
      return responseHelper.success(res, permissions);
    } catch (error) {
      return responseHelper.error(res, error.message, 500);
    }
  }
}

module.exports = new UserPermissionController();