/**
 * 管理员控制器
 * 处理管理员相关的所有请求，包括管理员管理、权限分配等
 * @module controllers/user/adminController
 *
 * ✅ 命名风格：camelCase
 * ✅ 所有方法为 async / await
 * ✅ 返回结构预期统一为 { success, data, message }
 */

const logger = require('../../utils/logger/winstonLogger');
const AppError = require('../../utils/errors/appError');
const userService = require('../../services/user/userService');
const adminService = require('../../services/user/adminService');
const { auditLogService } = require('../../services');
const catchAsync = require('../../utils/errors/catchAsync');

/**
 * 创建管理员
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建管理员的JSON响应
 */
exports.createAdmin = catchAsync(async (req, res) => {
  const { phone, nickname, role, password } = req.body;

  // 验证角色值
  const validRoles = ['admin', 'super_admin'];
  if (!validRoles.includes(role)) {
    return res.status(400).json({
      success: false,
      message: '无效的管理员角色'
    });
  }

  // 创建用户
  const userData = {
    phone,
    nickname,
    role,
    password: password || 'Admin@123', // 默认密码
    profileCompleted: true,
    account_status: 'active'
  };

  const newUser = await userService.createUser(userData);

  // 记录审计日志
  if (req.user && req.user.id) {
    await auditLogService.logAction({
      action: 'create_admin',
      entityType: 'user',
      entityId: newUser._id,
      userId: req.user.id,
      details: {
        phone,
        nickname,
        role
      }
    });
  }

  res.status(201).json({
    success: true,
    message: '管理员创建成功',
    data: {
      _id: newUser._id,
      phone: newUser.phone,
      nickname: newUser.nickname,
      role: newUser.role,
      createdAt: newUser.created_at
    }
  });
});

/**
 * 获取管理员列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含管理员列表的JSON响应
 */
exports.getAdminList = catchAsync(async (req, res) => {
  const { page = 1, limit = 20, role, search } = req.query;

  // 构建筛选条件
  const filters = {};
  if (role) {
    // 支持多个角色，如 'admin,super_admin'
    const roles = role.split(',').map(r => r.trim());
    filters.role = { $in: roles };
  } else {
    // 默认只返回管理员角色
    filters.role = { $in: ['admin', 'super_admin'] };
  }
  
  if (search) {
    filters.search = search;
  }

  // 获取用户列表
  const result = await adminService.getSystemUsers(filters, {
    page: parseInt(page),
    limit: parseInt(limit)
  });

  res.status(200).json({
    success: true,
    message: '获取管理员列表成功',
    data: result.users,
    pagination: result.pagination
  });
});

/**
 * 获取单个管理员详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含单个管理员的JSON响应
 */
exports.getAdminById = catchAsync(async (req, res) => {
  const { id } = req.params;

  const user = await userService.getUserById(id);
  
  if (!user) {
    return res.status(404).json({
      success: false,
      message: '管理员不存在'
    });
  }

  // 验证是否为管理员
  if (!['admin', 'super_admin'].includes(user.role)) {
    return res.status(403).json({
      success: false,
      message: '该用户不是管理员'
    });
  }

  res.status(200).json({
    success: true,
    message: '获取管理员信息成功',
    data: user
  });
});

/**
 * 更新管理员
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新后管理员的JSON响应
 */
exports.updateAdmin = catchAsync(async (req, res) => {
  const { id } = req.params;
  const { nickname, role } = req.body;

  // 验证角色值
  if (role && !['admin', 'super_admin'].includes(role)) {
    return res.status(400).json({
      success: false,
      message: '无效的管理员角色'
    });
  }

  // 更新用户信息
  const updateData = {};
  if (nickname) updateData.nickname = nickname;
  
  const updatedUser = await userService.updateUserProfile(id, updateData);

  // 如果需要更新角色
  if (role && role !== updatedUser.role) {
    await adminService.updateUserRole(id, role, req.user.id);
  }

  // 记录审计日志
  if (req.user && req.user.id) {
    await auditLogService.logAction({
      action: 'update_admin',
      entityType: 'user',
      entityId: id,
      userId: req.user.id,
      details: {
        nickname,
        role
      }
    });
  }

  res.status(200).json({
    success: true,
    message: '管理员信息更新成功',
    data: await userService.getUserById(id)
  });
});

/**
 * 删除管理员
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.deleteAdmin = catchAsync(async (req, res) => {
  const { id } = req.params;

  // 获取用户信息
  const user = await userService.getUserById(id);
  
  if (!user) {
    return res.status(404).json({
      success: false,
      message: '管理员不存在'
    });
  }

  // 验证是否为管理员
  if (!['admin', 'super_admin'].includes(user.role)) {
    return res.status(403).json({
      success: false,
      message: '该用户不是管理员'
    });
  }

  // 防止删除自己
  if (user._id.toString() === req.user.id) {
    return res.status(400).json({
      success: false,
      message: '不能删除自己的账号'
    });
  }

  // 软删除：将账号状态设置为suspended
  await adminService.updateUserStatus(id, 'suspended', req.user.id, '管理员账号删除');

  // 记录审计日志
  if (req.user && req.user.id) {
    await auditLogService.logAction({
      action: 'delete_admin',
      entityType: 'user',
      entityId: id,
      userId: req.user.id,
      details: {
        deletedAdmin: {
          phone: user.phone,
          nickname: user.nickname,
          role: user.role
        }
      }
    });
  }

  res.status(200).json({
    success: true,
    message: '管理员删除成功'
  });
});
