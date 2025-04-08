/**
 * 认证信息控制器
 * 处理用户认证相关的所有请求，包括登录、注册、验证码、重置密码等
 * @module controllers/core/authController
 */
const authService = require('../../services/core/authService');

/**
 * 用户注册
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建用户信息的JSON响应
 */
exports.createAuth = async (req, res) => {
  try {
    const userData = req.body;
    const newUser = await authService.register(userData);
    
    res.status(201).json({
      success: true,
      message: '用户注册成功',
      data: newUser
    });
  } catch (error) {
    res.status(error.statusCode || 500).json({
      success: false,
      message: error.message || '注册失败',
      error: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }
};

/**
 * 用户登录
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含用户信息和token的JSON响应
 */
exports.login = async (req, res) => {
  try {
    const { phone, password } = req.body;
    const authData = await authService.login(phone, password);
    
    // 直接返回authService提供的格式，符合前端期望
    res.status(200).json({
      success: true,
      token: authData.token,
      user: authData.user
    });
  } catch (error) {
    res.status(error.statusCode || 500).json({
      success: false,
      message: error.message || '登录失败',
      error: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }
};

/**
 * 发送手机验证码（用于登录和注册）
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.sendVerificationCode = async (req, res) => {
  try {
    const { phone, type } = req.body;
    
    // 根据不同类型调用不同的服务方法
    let result = false;
    if (type === 'reset') {
      result = await authService.sendPasswordResetCode(phone);
    } else {
      // 假设默认为登录/注册验证码
      result = await authService.sendVerificationCode(phone);
    }
    
    res.status(200).json({
      success: true,
      message: '验证码已发送'
    });
  } catch (error) {
    res.status(error.statusCode || 500).json({
      success: false,
      message: error.message || '发送验证码失败',
      error: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }
};

/**
 * 重置密码
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.updateAuth = async (req, res) => {
  try {
    const { phone, code, newPassword } = req.body;
    const result = await authService.resetPassword(phone, code, newPassword);
    
    res.status(200).json({
      success: result,
      message: '密码重置成功',
    });
  } catch (error) {
    res.status(error.statusCode || 500).json({
      success: false,
      message: error.message || '密码重置失败',
      error: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }
};

/**
 * 验证令牌
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含令牌验证结果的JSON响应
 */
exports.verifyToken = async (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    
    if (!token) {
      return res.status(401).json({
        success: false,
        message: '未提供令牌'
      });
    }
    
    const decoded = authService.verifyToken(token);
    
    res.status(200).json({
      success: true,
      message: '令牌有效',
      data: decoded
    });
  } catch (error) {
    res.status(error.statusCode || 500).json({
      success: false,
      message: error.message || '令牌验证失败',
      error: process.env.NODE_ENV === 'development' ? error.stack : undefined
    });
  }
};
