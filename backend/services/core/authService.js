/**
 * 认证服务
 * 提供用户注册、登录、密码重置等认证相关功能
 * @module services/core/authService
 */
const User = require('../../models/core/userModel');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const config = require('../../config');

// 临时存储验证码的映射 (仅在开发环境使用)
const tempVerificationCodes = new Map();

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
    
    // 如果未提供昵称，使用默认值
    if (!userData.nickname) {
      userData.nickname = `用户${userData.phone.substring(userData.phone.length - 4)}`;
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
 * 使用验证码登录
 * @param {string} phone - 用户手机号
 * @param {string} code - 验证码
 * @returns {Promise<Object>} - 返回用户信息和token
 */
const loginWithCode = async (phone, code) => {
  try {
    console.log(`尝试使用验证码登录: 手机号=${phone}, 验证码=${code}`);
    
    // 开发环境测试码处理
    if (process.env.NODE_ENV === 'development' && code === '123456') {
      console.log('开发环境中使用测试验证码登录');
      const user = await User.findOne({ phone });
      
      if (user) {
        const token = generateToken(user);
        return { user, token };
      } else {
        // 创建新用户
        const newUser = await User.create({
          phone,
          username: `user_${phone.slice(-4)}`,
          role: 'user'
        });
        
        const token = generateToken(newUser);
        return { user: newUser, token };
      }
    }

    // 查找用户
    let user = await User.findOne({ phone });
    console.log(`用户查找结果: ${user ? '已找到' : '未找到'}`);

    // 检查验证码
    let isValidCode = false;
    
    // 检查数据库中的验证码
    if (user && user.verification && user.verification.code) {
      console.log(`数据库中的验证码: ${user.verification.code}, 过期时间: ${user.verification.expiresAt}`);
      // 验证码是否过期
      const isExpired = user.verification.expiresAt < new Date();
      console.log(`验证码是否过期: ${isExpired}`);
      
      // 验证码是否匹配
      isValidCode = !isExpired && user.verification.code === code;
      console.log(`验证码是否匹配: ${isValidCode}`);
    }
    
    // 检查临时存储的验证码
    if (!isValidCode) {
      const tempCodeData = tempVerificationCodes.get(phone);
      if (tempCodeData && tempCodeData.code === code) {
        const isExpired = tempCodeData.expiresAt < new Date();
        console.log(`临时验证码是否过期: ${isExpired}`);
        
        if (!isExpired) {
          isValidCode = true;
          console.log('使用临时存储的验证码验证成功');
          
          // 如果用户不存在，创建新用户
          if (!user) {
            user = await User.create({
              phone,
              username: `user_${phone.slice(-4)}`,
              role: 'user'
            });
            console.log(`创建了新用户: ${user._id}`);
          }
        }
      }
    }

    // 验证码无效
    if (!isValidCode) {
      console.log('验证码无效或已过期');
      throw new AppError('验证码无效或已过期', 401);
    }

    // 验证码验证成功，清除验证码
    if (user.verification) {
      user.verification.code = null;
      user.verification.expiresAt = null;
      await user.save();
    }
    
    // 清除临时验证码
    tempVerificationCodes.delete(phone);
    
    console.log(`验证成功，生成token`);
    const token = generateToken(user);
    return { user, token };
  } catch (error) {
    console.error('验证码登录失败:', error);
    throw error;
  }
};

/**
 * 发送手机验证码
 * @param {string} phone - 用户手机号
 * @returns {Promise<Object>} - 返回发送结果
 */
const sendVerificationCode = async (phone) => {
  try {
    // 生成6位随机验证码
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000); // 10分钟后过期
    
    console.log(`为手机号 ${phone} 生成验证码: ${code}`);

    // 查找用户
    let user = await User.findOne({ phone });
    
    // 存储验证码到临时Map中
    tempVerificationCodes.set(phone, {
      code,
      expiresAt
    });
    console.log(`临时存储验证码: ${code} 到 ${phone}`);

    if (user) {
      // 更新用户的验证码信息
      user.verification = {
        code,
        expiresAt
      };
      await user.save();
      console.log(`更新用户 ${user._id} 的验证码信息`);
    }

    // 在真实环境中，这里会调用短信服务发送验证码
    if (process.env.NODE_ENV === 'production') {
      // TODO: 集成SMS服务
      console.log(`生产环境: 应该发送短信到 ${phone} 验证码: ${code}`);
    } else {
      console.log(`开发环境: 模拟发送验证码到 ${phone}: ${code}`);
    }

    return {
      success: true,
      message: '验证码已发送',
      // 仅在开发环境返回验证码
      ...(process.env.NODE_ENV === 'development' && { code })
    };
  } catch (error) {
    console.error('发送验证码失败:', error);
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
      // 开发环境下，接受测试验证码"123456"
      if (!(process.env.NODE_ENV === 'development' && code === '123456')) {
        const error = new Error('验证码无效或已过期');
        error.statusCode = 400;
        throw error;
      }
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
    userId: user._id,
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
  loginWithCode,
  sendVerificationCode,
  sendPasswordResetCode,
  resetPassword,
  verifyToken
}; 