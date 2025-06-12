const User = require('../../models/user/userModel');
const UserPermission = require('../../models/user/userPermissionModel');
const PermissionHistory = require('../../models/admin/permissionHistoryModel');
const responseHelper = require('../../utils/responseHelper');

/**
 * 获取已授权用户列表
 */
exports.getAuthorizedUsers = async (req, res) => {
  try {
    const { permissions, page = 1, limit = 20 } = req.query;
    
    const query = {};
    
    // 如果指定了权限类型，筛选相应用户
    if (permissions) {
      const permissionArray = permissions.split(',');
      query.$or = [
        { role: { $in: permissionArray } },
        { 'permissions.permissionType': { $in: permissionArray } }
      ];
    } else {
      // 获取所有有权限的用户（不是普通用户）
      query.$or = [
        { role: { $in: ['merchant', 'nutritionist', 'admin', 'super_admin'] } },
        { 'permissions.0': { $exists: true } }
      ];
    }

    const skip = (page - 1) * limit;
    
    const users = await User.find(query)
      .select('nickname phone realName role permissions createdAt lastLogin')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit))
      .lean();

    const total = await User.countDocuments(query);

    // 处理用户权限数据
    const processedUsers = users.map(user => ({
      ...user,
      permissions: _extractUserPermissions(user)
    }));

    return responseHelper.success(res, {
      users: processedUsers,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        hasMore: skip + users.length < total
      }
    }, '获取已授权用户成功');
    
  } catch (error) {
    console.error('[UserPermissionController] 获取已授权用户失败:', error);
    return responseHelper.error(res, '获取已授权用户失败');
  }
};

/**
 * 搜索用户
 */
exports.searchUsers = async (req, res) => {
  try {
    const { q: query, limit = 10 } = req.query;
    
    if (!query || query.trim().length < 2) {
      return responseHelper.success(res, [], '搜索关键词太短');
    }
    
    const searchRegex = new RegExp(query.trim(), 'i');
    
    const users = await User.find({
      $or: [
        { nickname: searchRegex },
        { phone: searchRegex },
        { realName: searchRegex }
      ]
    })
    .select('nickname phone realName role permissions createdAt')
    .limit(parseInt(limit))
    .lean();

    const processedUsers = users.map(user => ({
      ...user,
      permissions: _extractUserPermissions(user)
    }));

    return responseHelper.success(res, processedUsers, '搜索用户成功');
    
  } catch (error) {
    console.error('[UserPermissionController] 搜索用户失败:', error);
    return responseHelper.error(res, '搜索用户失败');
  }
};

/**
 * 授权用户
 */
exports.grantPermission = async (req, res) => {
  try {
    const { userId } = req.params;
    const { permission, reason } = req.body;
    
    if (!permission || !['merchant', 'nutritionist'].includes(permission)) {
      return responseHelper.badRequest(res, '权限类型无效');
    }

    const user = await User.findById(userId);
    if (!user) {
      return responseHelper.notFound(res, '用户不存在');
    }

    // 检查用户是否已有该权限
    const hasPermission = _checkUserPermission(user, permission);
    if (hasPermission) {
      return responseHelper.badRequest(res, '用户已拥有该权限');
    }

    // 创建权限记录
    const userPermission = new UserPermission({
      userId,
      permissionType: permission,
      status: 'approved',
      grantedBy: req.user.id,
      grantedAt: new Date(),
      applicationData: {
        reason: reason || `管理员直接授权${permission === 'merchant' ? '加盟商' : '营养师'}权限`
      }
    });

    await userPermission.save();

    // 更新用户角色（如果需要）
    if (user.role === 'user') {
      user.role = permission;
      await user.save();
    }

    // 记录权限变更历史
    await _recordPermissionHistory({
      userId,
      permissionType: permission,
      action: 'grant',
      operatorId: req.user.id,
      reason: reason || '管理员直接授权'
    });

    return responseHelper.success(res, {
      userId,
      permission,
      grantedAt: new Date()
    }, '权限授予成功');
    
  } catch (error) {
    console.error('[UserPermissionController] 授权失败:', error);
    return responseHelper.error(res, '授权失败');
  }
};

/**
 * 撤销权限
 */
exports.revokePermission = async (req, res) => {
  try {
    const { userId, permissionType } = req.params;
    const { reason } = req.body;
    
    if (!['merchant', 'nutritionist'].includes(permissionType)) {
      return responseHelper.badRequest(res, '权限类型无效');
    }

    const user = await User.findById(userId);
    if (!user) {
      return responseHelper.notFound(res, '用户不存在');
    }

    // 检查用户是否有该权限
    const hasPermission = _checkUserPermission(user, permissionType);
    if (!hasPermission) {
      return responseHelper.badRequest(res, '用户没有该权限');
    }

    // 撤销权限记录
    await UserPermission.updateMany(
      { 
        userId, 
        permissionType, 
        status: 'approved' 
      },
      { 
        $set: {
          status: 'revoked',
          'reviewData.reviewedBy': req.user.id,
          'reviewData.reviewedAt': new Date(),
          'reviewData.reviewComment': reason || '管理员撤销权限'
        }
      }
    );

    // 更新用户角色
    const remainingPermissions = await UserPermission.find({
      userId,
      status: 'approved',
      permissionType: { $ne: permissionType }
    });

    if (remainingPermissions.length === 0) {
      user.role = 'user';
    } else {
      // 设置为剩余权限中的第一个
      user.role = remainingPermissions[0].permissionType;
    }
    
    await user.save();

    // 记录权限变更历史
    await _recordPermissionHistory({
      userId,
      permissionType,
      action: 'revoke',
      operatorId: req.user.id,
      reason: reason || '管理员撤销权限'
    });

    return responseHelper.success(res, {
      userId,
      permissionType,
      revokedAt: new Date()
    }, '权限撤销成功');
    
  } catch (error) {
    console.error('[UserPermissionController] 撤销权限失败:', error);
    return responseHelper.error(res, '撤销权限失败');
  }
};

/**
 * 获取权限历史记录
 */
exports.getPermissionHistory = async (req, res) => {
  try {
    const { page = 1, limit = 20, userId, permissionType } = req.query;
    
    const query = {};
    if (userId) query.userId = userId;
    if (permissionType) query.permissionType = permissionType;
    
    const skip = (page - 1) * limit;
    
    const history = await PermissionHistory.find(query)
      .populate('userId', 'nickname phone realName')
      .populate('operatorId', 'nickname')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit))
      .lean();

    const total = await PermissionHistory.countDocuments(query);

    return responseHelper.success(res, {
      history,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        hasMore: skip + history.length < total
      }
    }, '获取权限历史成功');
    
  } catch (error) {
    console.error('[UserPermissionController] 获取权限历史失败:', error);
    return responseHelper.error(res, '获取权限历史失败');
  }
};

/**
 * 获取用户权限历史记录
 */
exports.getUserPermissionHistory = async (req, res) => {
  try {
    const { userId } = req.params;
    const { page = 1, limit = 10 } = req.query;
    
    const skip = (page - 1) * limit;
    
    const history = await PermissionHistory.find({ userId })
      .populate('operatorId', 'nickname')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit))
      .lean();

    const total = await PermissionHistory.countDocuments({ userId });

    return responseHelper.success(res, {
      history,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        hasMore: skip + history.length < total
      }
    }, '获取用户权限历史成功');
    
  } catch (error) {
    console.error('[UserPermissionController] 获取用户权限历史失败:', error);
    return responseHelper.error(res, '获取用户权限历史失败');
  }
};

// ============ 私有辅助函数 ============

/**
 * 提取用户权限列表
 */
function _extractUserPermissions(user) {
  const permissions = [];
  
  // 从role字段提取
  if (user.role && ['merchant', 'nutritionist'].includes(user.role)) {
    permissions.push(user.role);
  }
  
  // 从permissions数组提取
  if (user.permissions && Array.isArray(user.permissions)) {
    user.permissions.forEach(permission => {
      if (permission.permissionType && !permissions.includes(permission.permissionType)) {
        permissions.push(permission.permissionType);
      }
    });
  }
  
  return permissions;
}

/**
 * 检查用户是否有特定权限
 */
function _checkUserPermission(user, permissionType) {
  const permissions = _extractUserPermissions(user);
  return permissions.includes(permissionType);
}

/**
 * 记录权限变更历史
 */
async function _recordPermissionHistory(data) {
  try {
    await PermissionHistory.recordAction({
      userId: data.userId,
      permissionType: data.permissionType,
      action: data.action,
      operatorId: data.operatorId,
      reason: data.reason,
      operatorType: 'admin',
      newStatus: data.action === 'grant' ? 'approved' : 'revoked',
      previousStatus: data.action === 'grant' ? 'none' : 'approved'
    });
  } catch (error) {
    console.error('[记录权限历史失败]', error);
  }
}