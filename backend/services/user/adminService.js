/**
 * 管理员服务模块
 * 提供系统管理员对用户、角色和配置的管理操作
 * 包括用户状态/角色更新、系统配置的增删改查等功能
 * 所有关键操作记录审计日志
 * @module services/core/adminService
 */
const User = require('../../models/user/userModel');
const AppConfig = require('../../models/core/appConfigModel');
const AuditLog = require('../../models/core/auditLogModel');

/**
 * 获取系统用户列表
 * @async
 * @param {Object} filters - 筛选条件
 * @param {Object} pagination - 分页参数
 * @param {number} pagination.page - 当前页码（默认为 1）
 * @param {number} pagination.limit - 每页数量（默认为 20）
 * @returns {Promise<Object>} 返回对象，包括用户列表 users 和分页信息 pagination（含 total, page, limit, pages）
 * @throws {Error} 包含 statusCode 和错误信息的异常
 */
const getSystemUsers = async (filters = {}, pagination = {}) => {
  try {
    const { page = 1, limit = 20 } = pagination;
    const skip = (page - 1) * limit;
    
    const query = {};
    
    // 应用筛选条件
    if (filters.role) {
      // 如果filters.role已经是一个查询对象（如{ $in: [...] }），直接使用
      query.role = filters.role;
    }
    if (filters.status) query.account_status = filters.status;
    if (filters.search) {
      query.$or = [
        { nickname: { $regex: filters.search, $options: 'i' } },
        { phone: { $regex: filters.search, $options: 'i' } },
        { email: { $regex: filters.search, $options: 'i' } }
      ];
    }
    
    // 执行查询
    const users = await User.find(query)
      .select('-password')
      .sort({ created_at: -1 })
      .skip(skip)
      .limit(limit);
    
    const total = await User.countDocuments(query);
    
    return {
      users,
      pagination: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit)
      }
    };
  } catch (error) {
    const customError = new Error('获取用户列表失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

/**
 * 更新用户状态
 * @async
 * @param {string} userId - 用户ID
 * @param {string} status - 新状态，可选值：active, suspended, locked
 * @param {string} adminId - 管理员ID
 * @param {string} reason - 更新原因
 * @returns {Promise<Object>} 更新后的用户对象
 * @description 记录审计日志 action: update_user_status
 * @throws {Error} 包含 statusCode 和错误信息的异常
 */
const updateUserStatus = async (userId, status, adminId, reason) => {
  try {
    // 验证状态值
    const validStatuses = ['active', 'suspended', 'locked'];
    if (!validStatuses.includes(status)) {
      const error = new Error('无效的用户状态');
      error.statusCode = 400;
      throw error;
    }
    
    // 查找并更新用户
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error('用户不存在');
      error.statusCode = 404;
      throw error;
    }
    
    // 更新状态
    const oldStatus = user.account_status;
    user.account_status = status;
    await user.save();
    
    // 记录审计日志
    await AuditLog.create({
      action: 'update_user_status',
      entity_type: 'user',
      entity_id: userId,
      admin_id: adminId,
      details: {
        previous_status: oldStatus,
        new_status: status,
        reason
      }
    });
    
    // 返回更新后的用户
    const userObject = user.toObject();
    delete userObject.password;
    
    return userObject;
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '更新用户状态失败';
    }
    throw error;
  }
};

/**
 * 更新用户角色
 * @async
 * @param {string} userId - 用户ID
 * @param {string} role - 新角色，可选值：user, merchant, nutritionist, admin
 * @param {string} adminId - 管理员ID
 * @returns {Promise<Object>} 更新后的用户对象
 * @description 记录审计日志 action: update_user_role
 * @throws {Error} 包含 statusCode 和错误信息的异常
 */
const updateUserRole = async (userId, role, adminId) => {
  try {
    // 验证角色值
    const validRoles = ['customer', 'store_manager', 'store_staff', 'nutritionist', 'admin', 'super_admin'];
    if (!validRoles.includes(role)) {
      const error = new Error('无效的用户角色');
      error.statusCode = 400;
      throw error;
    }
    
    // 查找并更新用户
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error('用户不存在');
      error.statusCode = 404;
      throw error;
    }
    
    // 更新角色
    const oldRole = user.role;
    user.role = role;
    await user.save();
    
    // 记录审计日志
    await AuditLog.create({
      action: 'update_user_role',
      entity_type: 'user',
      entity_id: userId,
      admin_id: adminId,
      details: {
        previous_role: oldRole,
        new_role: role
      }
    });
    
    // 返回更新后的用户
    const userObject = user.toObject();
    delete userObject.password;
    
    return userObject;
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '更新用户角色失败';
    }
    throw error;
  }
};

/**
 * 获取系统配置
 * @async
 * @param {string} [key] - 配置键（可选，不提供则返回所有配置）
 * @returns {Promise<Object|Array>} 如果传入 key，返回单项配置对象，否则返回所有配置数组
 * @throws {Error} 包含 statusCode 和错误信息的异常
 */
const getSystemConfig = async (key = null) => {
  try {
    if (key) {
      // 获取单个配置
      const config = await AppConfig.findOne({ key });
      if (!config) {
        return null;
      }
      return config;
    } else {
      // 获取所有配置
      const configs = await AppConfig.find({});
      return configs;
    }
  } catch (error) {
    const customError = new Error('获取系统配置失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

/**
 * 更新系统配置
 * @async
 * @param {string} key - 配置键
 * @param {*} value - 配置值
 * @param {string} adminId - 管理员ID
 * @returns {Promise<Object>} 返回新建或更新的配置对象
 * @throws {Error} 包含 statusCode 和错误信息的异常
 */
const updateSystemConfig = async (key, value, adminId) => {
  try {
    // 查找并更新配置
    let config = await AppConfig.findOne({ key });
    
    if (config) {
      // 更新现有配置
      const oldValue = config.value;
      config.value = value;
      config.updated_at = new Date();
      await config.save();
      
      // 记录审计日志
      await AuditLog.create({
        action: 'update_system_config',
        entity_type: 'app_config',
        entity_id: config._id,
        admin_id: adminId,
        details: {
          key,
          previous_value: oldValue,
          new_value: value
        }
      });
    } else {
      // 创建新配置
      config = await AppConfig.create({
        key,
        value,
        created_at: new Date(),
        updated_at: new Date()
      });
      
      // 记录审计日志
      await AuditLog.create({
        action: 'create_system_config',
        entity_type: 'app_config',
        entity_id: config._id,
        admin_id: adminId,
        details: {
          key,
          value
        }
      });
    }
    
    return config;
  } catch (error) {
    const customError = new Error('更新系统配置失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

/**
 * 删除系统配置
 * @async
 * @param {string} key - 配置键
 * @param {string} adminId - 管理员ID
 * @returns {Promise<boolean>} 是否成功删除，true 表示删除成功，false 表示未找到
 * @description 记录审计日志 action: delete_system_config
 * @throws {Error} 包含 statusCode 和错误信息的异常
 */
const deleteSystemConfig = async (key, adminId) => {
  try {
    // 查找配置
    const config = await AppConfig.findOne({ key });
    if (!config) {
      return false;
    }
    
    // 删除配置
    await AppConfig.deleteOne({ key });
    
    // 记录审计日志
    await AuditLog.create({
      action: 'delete_system_config',
      entity_type: 'app_config',
      entity_id: config._id,
      admin_id: adminId,
      details: {
        key,
        value: config.value
      }
    });
    
    return true;
  } catch (error) {
    const customError = new Error('删除系统配置失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

module.exports = {
  getSystemUsers,
  updateUserStatus,
  updateUserRole,
  getSystemConfig,
  updateSystemConfig,
  deleteSystemConfig
}; 