/**
 * 认证信息控制器
 * 处理用户认证相关的所有请求，包括登录、注册、验证码、重置密码等
 * @module controllers/user/authController
 */
// ✅ 命名风格：camelCase
// ✅ 所有方法为 async / await
// ✅ 错误处理统一使用 handleError / handleValidationError

const authService = require('../../services/user/authService');
const { handleError, handleUnauthorized, handleValidationError } = require('../../utils/errors/errorHandler');

// 注册功能已废弃，所有用户通过登录时自动注册
// exports.createAuth 已移除

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
    
    if (!phone || !password) {
      return handleValidationError(res, new Error('手机号和密码不能为空'));
    }
    
    const authData = await authService.login(phone, password);
    
    // 直接返回authService提供的格式，符合前端期望
    res.status(200).json({
      success: true,
      message: '登录成功',
      token: authData.token,
      user: authData.user
    });
  } catch (error) {
    handleError(res, error, error.statusCode || 500);
  }
};

/**
 * 验证码登录（不存在用户时自动注册）
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含用户信息和token的JSON响应
 */
exports.loginWithCode = async (req, res) => {
  req.body.authType = 'code'; // Ensure authType is always 'code' for this flow
  try {
    const { phone, code } = req.body;
    
    if (!phone || !code) {
      return handleValidationError(res, new Error('手机号和验证码不能为空'));
    }
    
    const authData = await authService.loginOrRegisterWithCode(phone, code);
    
    // authData现在包含{user, token}结构
    
    return res.status(200).json({
      success: true,
      message: '验证码登录成功',
      token: authData.token,
      user: authData.user
    });
  } catch (error) {
    handleError(res, error, error.statusCode || 500);
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
    
    if (!phone) {
      return handleValidationError(res, new Error('手机号不能为空'));
    }
    
    // 根据不同类型调用不同的服务方法
    if (type === 'reset') {
      await authService.sendPasswordResetCode(phone);
    } else {
      // 假设默认为登录/注册验证码
      await authService.sendVerificationCode(phone);
    }
    
    res.status(200).json({
      success: true,
      message: '验证码已发送'
    });
  } catch (error) {
    handleError(res, error, error.statusCode || 500);
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
    
    if (!phone || !code || !newPassword) {
      return handleValidationError(res, new Error('手机号、验证码和新密码不能为空'));
    }
    
    const result = await authService.resetPassword(phone, code, newPassword);
    
    res.status(200).json({
      success: result,
      message: '密码重置成功',
    });
  } catch (error) {
    handleError(res, error, error.statusCode || 500);
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
      return handleUnauthorized(res, '未提供令牌');
    }
    
    const decoded = authService.verifyToken(token);
    
    res.status(200).json({
      success: true,
      message: '令牌有效',
      data: decoded
    });
  } catch (error) {
    handleError(res, error, error.statusCode || 500);
  }
};

/**
 * 验证码登录（兼容旧版前端路径，支持自动注册）
 * 与loginWithCode完全相同，仅是为了支持旧版前端路径
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含用户信息和token的JSON响应
 */
// FIXME: 建议移除 loginWithCodeLegacy，统一 login 路由后再做兼容性处理
exports.loginWithCodeLegacy = exports.loginWithCode;
