/**
 * 用户服务模块（userService）
 * 提供用户的核心业务逻辑处理，包括创建、查询、更新、删除等操作
 * 支持邮箱去重校验、分页查询、模糊搜索、个体详情读取、字段安全选择等机制
 * 依赖 userModel 中的 profile 查询助手方法（basicProfile / fullProfile）
 * @module services/core/userService
 */
const logger = require('../../utils/logger/winstonLogger.js');
const User = require('../../models/user/userModel');

/**
 * 创建新用户
 * @async
 * @param {Object} userData - 用户数据对象
 * @returns {Promise<Object>} 创建的用户对象
 * @throws {Error} 如果邮箱已存在或创建失败
 */
const createUser = async (userData) => {
  try {
    // 检查邮箱是否已经注册
    if (userData.email) {
      const existingUser = await User.findOne({ email: userData.email });
      if (existingUser) {
        const error = new Error('该邮箱已注册');
        error.statusCode = 400;
        throw error;
      }
    }
    
    // 创建新用户
    const user = new User(userData);
    await user.save();
    return user;
  } catch (error) {
    logger.error('创建用户失败', { error });
    if (!error.statusCode) {
      error.statusCode = 500;
    }
    throw error;
  }
};

/**
 * 获取用户列表
 * @async
 * @param {Object} filters - 过滤条件
 * @param {number} page - 页码
 * @param {number} limit - 每页数量
 * @returns {Promise<Object>} 用户列表和分页信息
 */
const getUserList = async (filters, page, limit) => {
  try {
    const pageNum = parseInt(page, 10) || 1;
    const limitNum = parseInt(limit, 10) || 10;
    const skip = (pageNum - 1) * limitNum;
    
    // 构建查询条件
    const query = {};
    
    // 应用过滤器
    if (filters.role) query.role = filters.role;
    if (filters.account_status) query.account_status = filters.account_status;
    if (filters.email) query.email = { $regex: filters.email, $options: 'i' };
    if (filters.phone) query.phone = { $regex: filters.phone, $options: 'i' };
    if (filters.nickname) query.nickname = { $regex: filters.nickname, $options: 'i' };
    
    // 执行查询，使用 basicProfile 查询助手方法获取基本用户信息
    const users = await User.find(query)
      .basicProfile() // 使用查询助手获取基本信息
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limitNum);
    
    // 获取总数
    const total = await User.countDocuments(query);
    
    return {
      data: users,
      pagination: {
        total,
        page: pageNum,
        limit: limitNum,
        pages: Math.ceil(total / limitNum)
      }
    };
  } catch (error) {
    logger.error('获取用户列表失败', { error });
    error.statusCode = 500;
    throw error;
  }
};

/**
 * 根据ID获取用户详情
 * @async
 * @param {string} userId - 用户ID
 * @returns {Promise<Object>} 用户对象
 */
const getUserById = async (userId) => {
  try {
    // 使用 fullProfile 查询助手方法获取完整用户信息
    const user = await User.findById(userId).fullProfile();
    return user;
  } catch (error) {
    logger.error('获取用户详情失败', { error });
    error.statusCode = 500;
    throw error;
  }
};

/**
 * 更新用户信息
 * @async
 * @param {string} userId - 用户ID
 * @param {Object} updateData - 更新的数据
 * @returns {Promise<Object>} 更新后的用户对象
 */
const updateUser = async (userId, updateData) => {
  try {
    // 检查邮箱是否存在
    if (updateData.email) {
      const existingUser = await User.findOne({ 
        email: updateData.email,
        _id: { $ne: userId }
      });
      
      if (existingUser) {
        const error = new Error('该邮箱已被其他用户使用');
        error.statusCode = 400;
        throw error;
      }
    }
    
    // 先获取用户实例
    const user = await User.findById(userId);
    if (!user) {
      const error = new Error('用户不存在');
      error.statusCode = 404;
      throw error;
    }
    
    // 更新用户信息
    Object.assign(user, updateData);
    
    // 检查资料是否完成
    user.checkProfileCompletion();
    
    // 保存更新
    await user.save();
    
    // 返回不含密码的用户信息
    const userObject = user.toObject();
    delete userObject.password;
    
    return userObject;
  } catch (error) {
    logger.error('更新用户信息失败', { error });
    if (!error.statusCode) {
      error.statusCode = 500;
    }
    throw error;
  }
};

/**
 * 删除用户
 * @async
 * @param {string} userId - 用户ID
 * @returns {Promise<boolean>} 删除成功返回true
 */
const deleteUser = async (userId) => {
  try {
    const result = await User.findByIdAndDelete(userId);
    return !!result;
  } catch (error) {
    logger.error('删除用户失败', { error });
    error.statusCode = 500;
    throw error;
  }
};

module.exports = {
  createUser,
  getUserList,
  getUserById,
  updateUser,
  deleteUser
};