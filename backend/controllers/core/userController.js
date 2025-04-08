/**
 * 用户控制器
 * 处理用户信息相关的所有请求，包括获取、更新用户信息等
 * @module controllers/core/userController
 */
const User = require('../../models/core/userModel');
const { validateUser } = require('../../utils/validators/userValidator');
const { handleError } = require('../../utils/errorHandler');

/**
 * 创建新用户
 * @route POST /api/users
 * @param {Object} req - 请求对象
 * @param {Object} res - 响应对象
 * @returns {Object} 创建的用户对象
 */
exports.createUser = async (req, res) => {
  try {
    // 验证请求数据
    const { error } = validateUser(req.body);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    // 检查邮箱是否已存在
    const existingUser = await User.findOne({ email: req.body.email });
    if (existingUser) {
      return res.status(400).json({ error: '该邮箱已被注册' });
    }

    // 创建新用户
    const user = new User(req.body);
    await user.save();

    // 返回创建的用户（不包含敏感信息）
    const userResponse = user.toObject();
    delete userResponse.password;
    delete userResponse.__v;

    res.status(201).json(userResponse);
  } catch (error) {
    handleError(res, error);
  }
};

/**
 * 获取用户列表
 * @route GET /api/users
 * @param {Object} req - 请求对象
 * @param {Object} res - 响应对象
 * @returns {Array} 用户列表
 */
exports.getUserList = async (req, res) => {
  try {
    const { page = 1, limit = 10, sort = '-created_at' } = req.query;
    
    // 构建查询条件
    const query = {};
    if (req.query.role) query.role = req.query.role;
    if (req.query.status) query.status = req.query.status;

    // 执行查询
    const users = await User.find(query)
      .select('-password -__v')
      .sort(sort)
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .exec();

    // 获取总数
    const total = await User.countDocuments(query);

    res.json({
      users,
      totalPages: Math.ceil(total / limit),
      currentPage: page,
      total
    });
  } catch (error) {
    handleError(res, error);
  }
};

/**
 * 获取用户详情
 * @route GET /api/users/:id
 * @param {Object} req - 请求对象
 * @param {Object} res - 响应对象
 * @returns {Object} 用户详情
 */
exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id)
      .select('-password -__v');

    if (!user) {
      return res.status(404).json({ error: '用户不存在' });
    }

    res.json(user);
  } catch (error) {
    handleError(res, error);
  }
};

/**
 * 更新用户信息
 * @route PUT /api/users/:id
 * @param {Object} req - 请求对象
 * @param {Object} res - 响应对象
 * @returns {Object} 更新后的用户对象
 */
exports.updateUser = async (req, res) => {
  try {
    // 验证请求数据
    const { error } = validateUser(req.body, true);
    if (error) {
      return res.status(400).json({ error: error.details[0].message });
    }

    // 检查用户是否存在
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: '用户不存在' });
    }

    // 如果更新邮箱，检查新邮箱是否已被使用
    if (req.body.email && req.body.email !== user.email) {
      const existingUser = await User.findOne({ email: req.body.email });
      if (existingUser) {
        return res.status(400).json({ error: '该邮箱已被使用' });
      }
    }

    // 更新用户信息
    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      { $set: req.body },
      { new: true, runValidators: true }
    ).select('-password -__v');

    res.json(updatedUser);
  } catch (error) {
    handleError(res, error);
  }
};

/**
 * 删除用户
 * @route DELETE /api/users/:id
 * @param {Object} req - 请求对象
 * @param {Object} res - 响应对象
 * @returns {Object} 删除结果
 */
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ error: '用户不存在' });
    }

    // 检查是否是最后一个管理员
    if (user.role === 'admin') {
      const adminCount = await User.countDocuments({ role: 'admin' });
      if (adminCount <= 1) {
        return res.status(400).json({ error: '不能删除最后一个管理员账户' });
      }
    }

    await User.findByIdAndDelete(req.params.id);
    res.json({ message: '用户已删除' });
  } catch (error) {
    handleError(res, error);
  }
};
