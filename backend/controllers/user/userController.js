/**
 * 用户控制器模块（userController）
 * 处理用户创建、查询、更新、删除等相关操作
 * 支持基于角色的差异化信息返回（如营养师/商家视图）
 * @module controllers/user/userController
 */

// ✅ 命名风格统一（camelCase）
// ✅ 所有函数为 async / await
// ✅ 所有接口返回结构包含 success/message/data
// ✅ 使用 handleError / handleValidationError / handleNotFound

const User = require('../../models/user/userModel');
const { validateUserRegistration, validateUserUpdate } = require('../../utils/validators/userValidator');
// const logger = require('../../utils/logger/winstonLogger.js'); // 结构化日志记录（可选）
const { handleError, handleValidationError, handleNotFound } = require('../../utils/errors/errorHandler');

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
    const { error } = validateUserRegistration(req.body);
    if (error) {
      return handleValidationError(res, error);
    }

    // 检查邮箱是否已存在
    const existingUser = await User.findOne({ email: req.body.email });
    if (existingUser) {
      return res.status(400).json({ 
        success: false,
        message: '该邮箱已被注册' 
      });
    }

    // 创建新用户
    const user = new User(req.body);
    await user.save();

    // 返回创建的用户（不包含敏感信息）
    const userResponse = user.toObject();
    delete userResponse.password;
    delete userResponse.__v;

    res.status(201).json({
      success: true,
      message: '用户创建成功',
      data: userResponse
    });
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
    const { page = 1, limit = 10, sort = '-createdAt' } = req.query;
    
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
      success: true,
      message: '用户列表获取成功',
      data: {
        users,
        totalPages: Math.ceil(total / limit),
        currentPage: Number(page),
        total
      }
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
    let user;
    
    // 安全获取请求者的角色，增加防御性编程
    // 修复：添加空值检查，如果req.user未定义或currentRole未定义，使用默认值'user'
    const requestRole = req.user ? (req.user.currentRole || req.user.role || 'user') : 'user';
    
    if (requestRole === 'nutritionist') {
      // 营养师视角 - 查看用户健康数据相关信息
      user = await User.findById(req.params.id).nutritionistView();
    } else if (requestRole === 'merchant') {
      // 商家视角 - 查看用户偏好相关信息
      user = await User.findById(req.params.id).merchantView();
    } else {
      // 默认使用基本信息视图
      // NOTE: 若无认证身份信息，则默认以普通用户角色视图展示
      user = await User.findById(req.params.id)
        .select('-password -__v');
    }

    if (!user) {
      return handleNotFound(res, '用户不存在');
    }

    res.json({
      success: true,
      data: user
    });
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
    console.log('updateUser 开始处理，req.file:', req.file ? '存在' : '不存在');
    console.log('updateUser req.body:', req.body);
    
    // 检查用户是否存在
    const user = await User.findById(req.params.id);
    if (!user) {
      return handleNotFound(res, '用户不存在');
    }

    // 处理头像上传
    if (req.file) {
      console.log('检测到上传文件:', req.file.filename);
      // 构建头像URL
      const avatarUrl = `/uploads/avatars/${req.file.filename}`;
      req.body.avatarUrl = avatarUrl;
      console.log('设置头像URL:', avatarUrl);
    } else {
      console.log('没有检测到上传文件');
    }

    // 只更新允许的字段
    const allowedUpdates = ['nickname', 'bio', 'avatarUrl'];
    const updates = {};
    
    allowedUpdates.forEach(field => {
      if (req.body[field] !== undefined) {
        updates[field] = req.body[field];
      }
    });

    // 简单验证昵称长度
    if (updates.nickname && (updates.nickname.length < 1 || updates.nickname.length > 50)) {
      return res.status(400).json({
        success: false,
        message: '昵称长度应在1-50个字符之间'
      });
    }

    // 简单验证简介长度
    if (updates.bio && updates.bio.length > 500) {
      return res.status(400).json({
        success: false,
        message: '个人简介不能超过500个字符'
      });
    }

    // 如果更新邮箱，检查新邮箱是否已被使用
    if (req.body.email && req.body.email !== user.email) {
      const existingUser = await User.findOne({ email: req.body.email });
      if (existingUser) {
        return res.status(400).json({ 
          success: false,
          message: '该邮箱已被使用' 
        });
      }
      updates.email = req.body.email;
    }

    // 更新用户信息
    Object.assign(user, updates);
    
    // 检查资料是否完成
    if (user.checkProfileCompletion) {
      user.checkProfileCompletion();
    }
    
    // 保存更新
    await user.save();
    
    // 去除敏感信息
    const userObject = user.toObject();
    delete userObject.password;
    delete userObject.__v;

    res.json({
      success: true,
      message: '用户信息更新成功',
      data: userObject
    });
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
      return handleNotFound(res, '用户不存在');
    }

    // 检查是否是最后一个管理员
    if (user.role === 'admin') {
      const adminCount = await User.countDocuments({ role: 'admin' });
      if (adminCount <= 1) {
        return res.status(400).json({ 
          success: false,
          message: '不能删除最后一个管理员账户' 
        });
      }
    }

    await User.findByIdAndDelete(req.params.id);
    res.json({ 
      success: true,
      message: '用户已删除' 
    });
  } catch (error) {
    handleError(res, error);
  }
};
