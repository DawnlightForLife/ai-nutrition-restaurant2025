/**
 * 用户服务
 * 提供用户相关的业务逻辑处理
 * @module services/core/userService
 */
const User = require('../../models/core/userModel');

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
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '创建用户失败';
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
    
    // 执行查询
    const users = await User.find(query)
      .select('-password') // 排除密码字段
      .sort({ created_at: -1 })
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
    error.statusCode = 500;
    error.message = '获取用户列表失败';
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
    const user = await User.findById(userId).select('-password');
    return user;
  } catch (error) {
    error.statusCode = 500;
    error.message = '获取用户详情失败';
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
    
    // 更新用户信息
    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { $set: updateData },
      { new: true, runValidators: true }
    ).select('-password');
    
    return updatedUser;
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '更新用户信息失败';
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
    error.statusCode = 500;
    error.message = '删除用户失败';
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