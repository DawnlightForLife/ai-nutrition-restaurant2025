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
    
    const permissionQuery = { status: 'approved' };
    
    // 如果指定了权限类型，筛选相应权限
    if (permissions) {
      const permissionArray = permissions.split(',');
      permissionQuery.permissionType = { $in: permissionArray };
    }

    const skip = (page - 1) * limit;
    
    // 从UserPermission表查询已授权的用户
    const userPermissions = await UserPermission.find(permissionQuery)
      .populate('userId', 'nickname phone realName role createdAt lastLogin')
      .sort({ grantedAt: -1 })
      .skip(skip)
      .limit(parseInt(limit))
      .lean();

    const total = await UserPermission.countDocuments(permissionQuery);

    // 处理用户数据，按用户分组权限
    const userMap = new Map();
    
    userPermissions.forEach(permission => {
      if (!permission.userId) return; // 跳过用户不存在的权限记录
      
      const userId = permission.userId._id || permission.userId.id;
      if (!userMap.has(userId)) {
        userMap.set(userId, {
          ...permission.userId,
          id: userId,
          permissions: [],
          permissionDetails: []
        });
      }
      
      const user = userMap.get(userId);
      user.permissions.push(permission.permissionType);
      user.permissionDetails.push({
        type: permission.permissionType,
        grantedAt: permission.grantedAt,
        grantedBy: permission.grantedBy
      });
    });

    const processedUsers = Array.from(userMap.values());

    return responseHelper.success(res, {
      users: processedUsers,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        hasMore: skip + userPermissions.length < total
      }
    }, '获取已授权用户成功');
    
  } catch (error) {
    console.error('[UserPermissionController] 获取已授权用户失败:', error);
    return responseHelper.error(res, '获取已授权用户失败');
  }
};

/**
 * 获取所有用户列表（用于授权选择）
 */
exports.getAllUsers = async (req, res) => {
  try {
    console.log('[UserPermissionController] 开始获取用户列表');
    const { page = 1, limit = 50 } = req.query;
    
    // 检查模型是否正确加载
    if (!User) {
      console.error('[UserPermissionController] User 模型未正确加载');
      return responseHelper.error(res, 'User 模型未正确加载');
    }
    
    // 简化查询，不排除任何角色
    const query = {};
    
    // 计算分页
    const skip = (parseInt(page) - 1) * parseInt(limit);
    
    console.log('[UserPermissionController] 执行查询，page:', page, 'limit:', limit, 'skip:', skip);
    
    const users = await User.find(query)
      .select('nickname phone realName role createdAt')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit))
      .lean();

    const total = await User.countDocuments(query);
    
    console.log(`[UserPermissionController] 找到 ${users.length} 个用户，总共 ${total} 个`);
    
    // 简化处理，暂时不提取复杂的权限
    const processedUsers = users.map(user => ({
      ...user,
      permissions: [] // 暂时简化
    }));

    return responseHelper.success(res, {
      users: processedUsers,
      total: total,
      page: parseInt(page),
      limit: parseInt(limit)
    }, '获取用户列表成功');
    
  } catch (error) {
    console.error('[UserPermissionController] 获取用户列表失败，详细错误:', error.message);
    console.error('[UserPermissionController] 错误堆栈:', error.stack);
    return responseHelper.error(res, '获取用户列表失败: ' + error.message);
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
    .select('nickname phone realName role createdAt')
    .limit(parseInt(limit))
    .lean();

    // 为每个用户获取权限信息
    const processedUsers = await Promise.all(users.map(async (user) => {
      const userPermissions = await UserPermission.find({
        userId: user._id,
        status: 'approved'
      }).select('permissionType').lean();
      
      return {
        ...user,
        permissions: userPermissions.map(p => p.permissionType)
      };
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
    console.log('[UserPermissionController] 开始授权流程');
    const { userId } = req.params;
    const { permission, reason } = req.body;
    
    console.log('[UserPermissionController] 授权参数:', { userId, permission, reason });
    
    if (!permission || !['merchant', 'nutritionist'].includes(permission)) {
      console.log('[UserPermissionController] 权限类型无效:', permission);
      return responseHelper.error(res, '权限类型无效', 400);
    }
    
    // 检查模型是否正确加载
    if (!User || !UserPermission) {
      console.error('[UserPermissionController] 模型未正确加载 - User:', !!User, 'UserPermission:', !!UserPermission);
      return responseHelper.error(res, '模型未正确加载');
    }

    console.log('[UserPermissionController] 查找用户:', userId);
    const user = await User.findById(userId);
    if (!user) {
      console.log('[UserPermissionController] 用户不存在:', userId);
      return responseHelper.notFound(res, '用户不存在');
    }
    
    console.log('[UserPermissionController] 找到用户:', user.nickname);

    // 检查用户是否已有该权限（任何状态）
    console.log('[UserPermissionController] 检查已有权限');
    const existingPermission = await UserPermission.findOne({
      userId,
      permissionType: permission
    });
    
    if (existingPermission) {
      console.log('[UserPermissionController] 用户已有该权限记录，状态:', existingPermission.status);
      
      if (existingPermission.status === 'approved') {
        return responseHelper.error(res, '用户已拥有该权限', 400);
      } else if (existingPermission.status === 'pending') {
        // 如果是待审核状态，直接更新为已批准
        console.log('[UserPermissionController] 更新待审核权限为已批准');
        existingPermission.status = 'approved';
        existingPermission.grantedBy = req.user.id;
        existingPermission.grantedAt = new Date();
        existingPermission.applicationData.reason = reason || `管理员直接授权${permission === 'merchant' ? '加盟商' : '营养师'}权限`;
        
        await existingPermission.save();
        
        // 记录权限变更历史
        await _recordPermissionHistory({
          userId,
          permissionType: permission,
          action: 'approve',
          operatorId: req.user.id,
          reason: reason || '管理员直接批准'
        });
        
        return responseHelper.success(res, {
          userId,
          permission,
          grantedAt: new Date()
        }, '权限授予成功');
      } else {
        // 如果是被拒绝或撤销的状态，创建新的记录
        console.log('[UserPermissionController] 删除旧权限记录，创建新记录');
        await UserPermission.deleteOne({ _id: existingPermission._id });
      }
    }

    // 检查当前用户信息
    if (!req.user || !req.user.id) {
      console.error('[UserPermissionController] 当前用户信息不完整:', req.user);
      return responseHelper.error(res, '当前用户信息不完整');
    }

    console.log('[UserPermissionController] 创建权限记录');
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

    console.log('[UserPermissionController] 保存权限记录');
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
    console.error('[UserPermissionController] 授权失败，详细错误:', error.message);
    console.error('[UserPermissionController] 错误堆栈:', error.stack);
    return responseHelper.error(res, '授权失败: ' + error.message);
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
      return responseHelper.error(res, '权限类型无效', 400);
    }

    const user = await User.findById(userId);
    if (!user) {
      return responseHelper.error(res, '用户不存在', 404);
    }

    // 检查用户是否有该权限
    const existingPermission = await UserPermission.findOne({
      userId,
      permissionType,
      status: 'approved'
    });
    
    if (!existingPermission) {
      return responseHelper.error(res, '用户没有该权限', 400);
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

    // 注意：用户角色(role)不需要修改，它应该保持原有角色
    // 权限通过UserPermission表独立管理

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
    console.error('[UserPermissionController] 错误详情:', error.message);
    console.error('[UserPermissionController] 错误堆栈:', error.stack);
    return responseHelper.error(res, '撤销权限失败: ' + error.message);
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