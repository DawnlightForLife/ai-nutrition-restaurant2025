/**
 * 认证服务
 * 提供用户注册、登录、密码重置等认证相关功能
 * @module services/core/authService
 */
const User = require('../../models/core/userModel');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const config = require('../../config');

/**
 * 用户注册
 * @async
 * @param {Object} userData - 用户注册数据
 * @returns {Promise<Object>} 注册成功的用户对象
 * @throws {Error} 如果手机号已存在或创建失败
 */
const register = async (userData) => {
  try {
    // 检查手机号是否已注册
    const existingUser = await User.findByPhone(userData.phone);
    if (existingUser) {
      const error = new Error('该手机号已注册');
      error.statusCode = 400;
      throw error;
    }
    
    // 创建新用户
    const user = new User(userData);
    await user.save();
    
    // 去除敏感信息
    const userObject = user.toObject();
    delete userObject.password;
    
    return userObject;
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '注册失败';
    }
    throw error;
  }
};

/**
 * 用户登录
 * @async
 * @param {string} phone - 手机号
 * @param {string} password - 密码
 * @returns {Promise<Object>} 包含用户信息和令牌的对象
 * @throws {Error} 如果凭据无效
 */
const login = async (phone, password) => {
  try {
    // 查找用户
    const user = await User.findByPhone(phone);
    if (!user) {
      const error = new Error('用户不存在');
      error.statusCode = 401;
      throw error;
    }
    
    // 检查用户状态
    if (user.account_status !== 'active') {
      const error = new Error('账户已被禁用，请联系管理员');
      error.statusCode = 403;
      throw error;
    }
    
    // 验证密码
    const isValid = await user.comparePassword(password);
    if (!isValid) {
      const error = new Error('密码错误');
      error.statusCode = 401;
      throw error;
    }
    
    // 生成JWT令牌
    const token = generateToken(user);
    
    // 去除敏感信息
    const userObject = user.toObject();
    delete userObject.password;
    
    // 更新最后登录时间
    user.last_login = new Date();
    await user.save();
    
    // 确保返回格式符合前端期望：{token, user}
    return {
      token,
      user: {
        userId: userObject._id,
        phone: userObject.phone,
        username: userObject.username || '',
        nickname: userObject.nickname || '',
        avatar: userObject.avatar || '',
        role: userObject.role
      }
    };
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '登录失败';
    }
    throw error;
  }
};

/**
 * 发送验证码（用于登录或注册）
 * @async
 * @param {string} phone - 用户手机号
 * @returns {Promise<boolean>} 是否成功发送验证码
 * @throws {Error} 如果发送失败
 */
const sendVerificationCode = async (phone) => {
  try {
    // 查找用户（对于注册场景，用户可能不存在）
    const user = await User.findByPhone(phone);
    
    // 生成6位随机验证码
    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
    
    if (user) {
      // 如果用户存在，更新用户的验证码字段
      user.verification_code = verificationCode;
      user.verification_code_expires = Date.now() + 15 * 60 * 1000; // 15分钟有效期
      await user.save();
    } else {
      // 如果用户不存在（注册场景），可以临时存储在缓存或其他地方
      // 在实际项目中，可以使用Redis缓存或其他临时存储
      // 这里简化处理，仅打印日志
      console.log(`为新用户 ${phone} 生成验证码: ${verificationCode}`);
    }
    
    // TODO: 集成短信服务发送验证码
    console.log(`发送验证码到 ${phone}: ${verificationCode}`);
    
    return true;
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '发送验证码失败';
    }
    throw error;
  }
};

/**
 * 发送密码重置验证码
 * @async
 * @param {string} phone - 用户手机号
 * @returns {Promise<boolean>} 是否成功发送验证码
 * @throws {Error} 如果用户不存在或发送失败
 */
const sendPasswordResetCode = async (phone) => {
  try {
    // 查找用户
    const user = await User.findByPhone(phone);
    if (!user) {
      const error = new Error('未找到该手机号关联的账户');
      error.statusCode = 404;
      throw error;
    }
    
    // 生成6位随机验证码
    const resetCode = Math.floor(100000 + Math.random() * 900000).toString();
    
    // 存储验证码和过期时间
    user.reset_code = resetCode;
    user.reset_code_expires = Date.now() + 15 * 60 * 1000; // 15分钟有效期
    await user.save();
    
    // TODO: 集成短信服务发送验证码
    console.log(`为用户 ${phone} 发送验证码: ${resetCode}`);
    
    return true;
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '发送重置验证码失败';
    }
    throw error;
  }
};

/**
 * 重置密码
 * @async
 * @param {string} phone - 手机号
 * @param {string} code - 验证码
 * @param {string} newPassword - 新密码
 * @returns {Promise<boolean>} 是否成功重置密码
 * @throws {Error} 如果验证码无效或重置失败
 */
const resetPassword = async (phone, code, newPassword) => {
  try {
    // 查找用户
    const user = await User.findByPhone(phone);
    if (!user) {
      const error = new Error('未找到该手机号关联的账户');
      error.statusCode = 404;
      throw error;
    }
    
    // 验证重置码
    if (!user.reset_code || 
        user.reset_code !== code || 
        user.reset_code_expires < Date.now()) {
      const error = new Error('验证码无效或已过期');
      error.statusCode = 400;
      throw error;
    }
    
    // 更新密码
    user.password = newPassword;
    user.reset_code = undefined;
    user.reset_code_expires = undefined;
    await user.save();
    
    return true;
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '重置密码失败';
    }
    throw error;
  }
};

/**
 * 验证令牌
 * @param {string} token - JWT令牌
 * @returns {Object} 解码后的令牌载荷
 * @throws {Error} 如果令牌无效
 */
const verifyToken = (token) => {
  try {
    return jwt.verify(token, config.jwt.secret);
  } catch (error) {
    const customError = new Error('无效或过期的令牌');
    customError.statusCode = 401;
    throw customError;
  }
};

/**
 * 生成JWT令牌
 * @private
 * @param {Object} user - 用户对象
 * @returns {string} JWT令牌
 */
const generateToken = (user) => {
  const payload = {
    id: user._id,
    role: user.role,
    phone: user.phone
  };
  
  return jwt.sign(
    payload,
    config.jwt.secret,
    { expiresIn: config.jwt.expiresIn }
  );
};

module.exports = {
  register,
  login,
  sendVerificationCode,
  sendPasswordResetCode,
  resetPassword,
  verifyToken
}; 