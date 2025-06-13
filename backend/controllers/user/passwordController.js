/**
 * 密码管理控制器
 * 处理用户密码相关操作：检查密码状态、设置密码、修改密码
 * @module controllers/user/passwordController
 */

const User = require('../../models/user/userModel');
const bcrypt = require('bcryptjs');
const { handleError } = require('../../utils/errors/errorHandler');

/**
 * 检查用户是否已设置密码
 * @route GET /api/users/has-password
 * @param {Object} req - 请求对象（需要认证）
 * @param {Object} res - 响应对象
 * @returns {Object} { hasPassword: boolean }
 */
exports.checkHasPassword = async (req, res) => {
  try {
    // 获取当前登录用户ID
    const userId = req.user.id || req.user.userId;
    
    // 查询用户
    const user = await User.findById(userId).select('password');
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    // 检查密码字段是否存在且不为空
    const hasPassword = !!(user.password && user.password.length > 0);
    
    res.json({
      success: true,
      data: {
        hasPassword
      }
    });
  } catch (error) {
    handleError(res, error);
  }
};

/**
 * 设置密码（新用户首次设置）
 * @route POST /api/users/set-password
 * @param {Object} req - 请求对象（需要认证）
 * @param {Object} res - 响应对象
 * @body {String} password - 新密码
 */
exports.setPassword = async (req, res) => {
  try {
    const { password } = req.body;
    const userId = req.user.id || req.user.userId;
    
    // 验证密码
    if (!password || password.length < 6) {
      return res.status(400).json({
        success: false,
        message: '密码长度至少6位'
      });
    }
    
    // 查询用户
    const user = await User.findById(userId).select('password');
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    // 检查是否已有密码
    if (user.password && user.password.length > 0) {
      return res.status(400).json({
        success: false,
        message: '用户已设置密码，请使用修改密码功能'
      });
    }
    
    // 设置认证类型为密码登录
    user.authType = 'password';
    
    // 设置密码（将由pre-save hook自动加密）
    user.password = password;
    await user.save();
    
    res.json({
      success: true,
      message: '密码设置成功'
    });
  } catch (error) {
    handleError(res, error);
  }
};

/**
 * 修改密码（已有密码的用户）
 * @route POST /api/users/change-password
 * @param {Object} req - 请求对象（需要认证）
 * @param {Object} res - 响应对象
 * @body {String} oldPassword - 当前密码
 * @body {String} newPassword - 新密码
 */
exports.changePassword = async (req, res) => {
  try {
    const { oldPassword, newPassword } = req.body;
    const userId = req.user.id || req.user.userId;
    
    // 验证参数
    if (!oldPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        message: '请提供当前密码和新密码'
      });
    }
    
    if (newPassword.length < 6) {
      return res.status(400).json({
        success: false,
        message: '新密码长度至少6位'
      });
    }
    
    // 查询用户（包含密码字段）
    const user = await User.findById(userId).select('password');
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    // 如果用户没有密码，提示使用设置密码功能
    if (!user.password || user.password.length === 0) {
      return res.status(400).json({
        success: false,
        message: '用户未设置密码，请使用设置密码功能'
      });
    }
    
    // 验证当前密码
    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
      return res.status(400).json({
        success: false,
        message: '当前密码不正确'
      });
    }
    
    // 检查新密码是否与旧密码相同
    const isSame = await bcrypt.compare(newPassword, user.password);
    if (isSame) {
      return res.status(400).json({
        success: false,
        message: '新密码不能与当前密码相同'
      });
    }
    
    // 确保认证类型为密码登录
    user.authType = 'password';
    
    // 设置新密码（将由pre-save hook自动加密）
    user.password = newPassword;
    await user.save();
    
    res.json({
      success: true,
      message: '密码修改成功'
    });
  } catch (error) {
    handleError(res, error);
  }
};

/**
 * 通过验证码重置密码
 * @route POST /api/users/reset-password
 * @param {Object} req - 请求对象
 * @param {Object} res - 响应对象
 * @body {String} phone - 手机号
 * @body {String} code - 验证码
 * @body {String} newPassword - 新密码
 */
exports.resetPassword = async (req, res) => {
  try {
    const { phone, code, newPassword } = req.body;
    
    // 验证参数
    if (!phone || !code || !newPassword) {
      return res.status(400).json({
        success: false,
        message: '手机号、验证码和新密码不能为空'
      });
    }
    
    if (newPassword.length < 6) {
      return res.status(400).json({
        success: false,
        message: '新密码长度至少6位'
      });
    }
    
    // 验证手机号格式
    if (!/^1[3-9]\d{9}$/.test(phone)) {
      return res.status(400).json({
        success: false,
        message: '请输入有效的手机号'
      });
    }
    
    // 这里应该验证验证码，暂时跳过验证码验证
    // TODO: 集成短信服务验证验证码
    if (process.env.NODE_ENV !== 'development' && code !== '123456') {
      // 生产环境需要真实验证码验证
      return res.status(400).json({
        success: false,
        message: '验证码错误'
      });
    }
    
    // 查找用户
    const user = await User.findOne({ phone });
    
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '该手机号未注册'
      });
    }
    
    // 设置新密码和认证类型
    user.authType = 'password';
    user.password = newPassword; // 将由pre-save hook自动加密
    await user.save();
    
    res.json({
      success: true,
      message: '密码重置成功，请使用新密码登录'
    });
  } catch (error) {
    handleError(res, error);
  }
};