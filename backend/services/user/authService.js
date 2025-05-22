/**
 * 用户认证服务模块
 * 提供注册、密码登录、验证码登录、密码重置、JWT令牌生成与验证等功能
 * 支持手机号为唯一标识，允许自动注册机制，支持开发环境调试模式
 * @module services/user/authService
 */
/**
 * 认证服务
 * 提供用户注册、登录、密码重置等认证相关功能
 * @module services/user/authService
 */
const User = require('../../models/user/userModel');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const config = require('../../config');
const AppError = require('../../utils/errors/appError');
const logger = require('../../utils/logger/winstonLogger.js');

// 检查User模型是否正确导入
if (!User || typeof User !== 'function') {
  logger.error('严重错误: User模型不是构造函数类型，当前类型:', typeof User);
  
  // 尝试直接从mongoose获取模型
  try {
    const mongoose = require('mongoose');
    const UserFromMongoose = mongoose.model('User');
    
    if (UserFromMongoose && typeof UserFromMongoose === 'function') {
      logger.info('成功: 从mongoose直接获取User模型');
      // 注意：这里只是替换局部变量，不修改模块导出
      global._cachedUserModel = UserFromMongoose;
    } else {
      logger.error('错误: 无法从mongoose获取User模型');
    }
  } catch (err) {
    logger.error('尝试从mongoose获取User模型失败:', err.message);
  }
}

// 获取User模型的函数，确保总是返回有效的构造函数
function getUserModel() {
  // 首先尝试使用正常导入的User模型
  if (User && typeof User === 'function') {
    return User;
  }
  
  // 其次尝试使用全局缓存的模型
  if (global._cachedUserModel && typeof global._cachedUserModel === 'function') {
    logger.info('使用全局缓存的User模型');
    return global._cachedUserModel;
  }
  
  // 最后尝试从mongoose重新获取
  try {
    const mongoose = require('mongoose');
    return mongoose.model('User');
  } catch (err) {
    logger.error('获取User模型失败，这可能导致严重错误');
    // 抛出更有意义的错误
    const error = new Error('系统错误: 无法加载用户模型');
    error.statusCode = 500;
    throw error;
  }
}

// 临时存储验证码的映射 (仅在开发环境使用)
const tempVerificationCodes = new Map();

/**
 * 验证临时验证码
 * @async
 * @param {string} phone - 手机号
 * @param {string} code - 验证码
 * @returns {Promise<boolean>} 验证码是否有效
 */
const validateTempCode = async (phone, code) => {
  try {
    // 开发环境测试码处理
    if (process.env.NODE_ENV === 'development' && code === '123456') {
      logger.info('开发环境中使用测试验证码');
      return true;
    }
    
    // 检查数据库中的验证码
    const UserModel = getUserModel();
    const user = await UserModel.findOne({ phone });
    
    if (user && user.verification && user.verification.code) {
      // 验证码是否过期
      const isExpired = user.verification.expiresAt < new Date();
      
      // 验证码是否匹配
      if (!isExpired && user.verification.code === code) {
        return true;
      }
    }
    
    // 检查临时存储的验证码
    const tempCodeData = tempVerificationCodes.get(phone);
    if (tempCodeData && tempCodeData.code === code) {
      const isExpired = tempCodeData.expiresAt < new Date();
      
      if (!isExpired) {
        return true;
      }
    }
    
    return false;
  } catch (error) {
    logger.error('验证临时验证码失败:', { error });
    return false;
  }
};

/**
 * 清除临时验证码
 * @async
 * @param {string} phone - 手机号
 * @returns {Promise<void>}
 */
const clearTempCode = async (phone) => {
  try {
    // 清除临时存储的验证码
    tempVerificationCodes.delete(phone);
    
    // 清除数据库中的验证码
    const UserModel = getUserModel();
    const user = await UserModel.findOne({ phone });
    
    if (user && user.verification) {
      if (typeof user.save === 'function') {
        user.verification.code = null;
        user.verification.expiresAt = null;
        await user.save();
        logger.info(`成功清除用户${phone}的验证码`);
      } else {
        // 使用findOneAndUpdate作为备选方案
        await UserModel.findOneAndUpdate(
          { phone },
          { 
            $set: { 
              'verification.code': null, 
              'verification.expiresAt': null 
            }
          }
        );
        logger.info(`使用findOneAndUpdate清除用户${phone}的验证码`);
      }
    }
  } catch (error) {
    logger.error(`清除临时验证码失败: ${phone}`, { error });
  }
};

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
    const existingUser = await getUserModel().findOne({ phone: userData.phone });
    if (existingUser) {
      // 如果登录类型是验证码登录，直接返回现有用户
      if (userData.authType === 'code') {
        const userObject = existingUser.toObject();
        delete userObject.password;
        return userObject;
      }
      const error = new Error('该手机号已注册');
      error.statusCode = 400;
      throw error;
    }
    
    // 如果未提供昵称，使用默认值
    if (!userData.nickname) {
      userData.nickname = `用户${userData.phone.substring(userData.phone.length - 4)}`;
    }
    
    // 解构用户数据，确保 authType 默认值
    const {
      phone,
      password,
      nickname,
      authType = 'password'
    } = userData;
    
    // 获取用户模型
    const UserModel = getUserModel();
    if (typeof UserModel !== 'function') {
      const error = new Error(`User模型不是构造函数，当前类型: ${typeof UserModel}`);
      error.statusCode = 500;
      throw error;
    }
    
    // 创建新用户
    const user = new UserModel({
      phone,
      password,
      nickname,
      authType,
      accountStatus: 'active' // 确保账户状态为active
    });
    
    // 对验证码登录的用户设置空密码
    if (authType === 'code') {
      user.password = undefined;
    }
    
    // 确保user是Mongoose文档并有save方法
    if (!user || typeof user.save !== 'function') {
      logger.error('错误: 创建的user对象不是有效的mongoose文档', { userType: typeof user });
      // 尝试使用Model.create方法代替new Model()
      const newUser = await UserModel.create({
        phone,
        password: authType === 'code' ? undefined : password,
        nickname,
        authType,
        accountStatus: 'active'
      });
      
      logger.info(`使用Model.create方法创建用户成功: ${newUser._id}`);
      const newUserObject = newUser.toObject();
      delete newUserObject.password;
      return newUserObject;
    }
    
    // 正常保存
    await user.save();
    logger.info(`用户注册成功, ID: ${user._id}, 类型: ${typeof user}`);
    
    // 去除敏感信息
    const userObject = user.toObject();
    delete userObject.password;
    
    return userObject;
  } catch (error) {
    logger.error('注册用户失败', { error });
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
    const user = await getUserModel().findOne({ phone });
    if (!user) {
      const error = new Error('用户不存在');
      error.statusCode = 401;
      throw error;
    }
    
    // 检查用户状态
    if (user.accountStatus !== 'active') {
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
    user.lastLogin = new Date();
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
 * 手机验证码登录
 * @async
 * @param {string} phone - 手机号
 * @param {string} code - 验证码
 * @returns {Promise<Object>} 登录用户信息与token
 * @throws {Error} 如果验证码无效或登录失败
 */
const loginWithCode = async (phone, code) => {
  try {
    const isValid = await validateTempCode(phone, code);
    if (!isValid) {
      const error = new Error('验证码无效或已过期');
      error.statusCode = 401;
      throw error;
    }

    // 查找用户
    const UserModel = getUserModel();
    let user = await UserModel.findOne({ phone });
    
    logger.info(`验证码登录-查询用户结果: ${user ? '找到用户' : '未找到用户'}`);

    // 验证通过后清除验证码
    await clearTempCode(phone);
    
    // 如果用户不存在，创建新用户
    if (!user) {
      logger.info(`用户${phone}不存在，通过验证码注册新用户`);
      const userData = {
        phone,
        authType: 'code', // 标记是通过验证码注册
      };
      
      const newUser = await register(userData);
      logger.info(`验证码注册返回结果:`, { type: typeof newUser, id: newUser && newUser._id ? newUser._id : 'ID未定义' });
      
      // 确保newUser是一个有效对象
      if (!newUser) {
        const error = new Error('用户创建失败');
        error.statusCode = 500;
        throw error;
      }
      
      // 如果register返回的是普通对象而不是mongoose文档
      if (!newUser.save || typeof newUser.save !== 'function') {
        // 使用ID重新查询用户
        if (newUser._id) {
          logger.info(`重新查询用户: ${newUser._id}`);
          user = await UserModel.findById(newUser._id);
        } else {
          logger.info(`通过手机号查询新注册用户: ${phone}`);
          user = await UserModel.findOne({ phone });
        }
        
        if (!user) {
          logger.error('无法找到刚注册的用户');
          const error = new Error('用户登录失败');
          error.statusCode = 500;
          throw error;
        }
      } else {
        // 如果register返回的是mongoose文档
        user = newUser;
      }
    }
    
    // 标记登录时间
    if (user && typeof user.save === 'function') {
      user.lastLoginAt = new Date();
      await user.save();
    } else if (user) {
      // 备选方案：使用findOneAndUpdate
      logger.info('使用findOneAndUpdate更新最后登录时间');
      await UserModel.findOneAndUpdate(
        { _id: user._id || user.id }, 
        { $set: { lastLoginAt: new Date() } }
      );
      // 重新获取更新后的用户
      user = await UserModel.findById(user._id || user.id);
    }

    // 确保返回的是普通对象
    const userObject = user.toObject ? user.toObject() : { ...user };
    delete userObject.password;
    
    // 生成用户token
    const token = generateToken(user);
    logger.info(`为用户 ${phone} 生成token成功`);
    
    // 返回用户信息和token，与login方法保持一致的响应结构
    return {
      user: userObject,
      token
    };
  } catch (error) {
    logger.error('验证码登录失败:', { error });
    if (!error.statusCode) {
      error.statusCode = 500;
    }
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
    
    logger.info(`为手机号 ${phone} 生成验证码: ${code}`);

    // 查找用户
    let user = await getUserModel().findOne({ phone });
    
    // 存储验证码到临时Map中
    tempVerificationCodes.set(phone, {
      code,
      expiresAt
    });
    logger.info(`临时存储验证码: ${code} 到 ${phone}`);

    if (user) {
      // 更新用户的验证码信息
      user.verification = {
        code,
        expiresAt
      };
      await user.save();
      logger.info(`更新用户 ${user._id} 的验证码信息`);
    }

    // 在真实环境中，这里会调用短信服务发送验证码
    if (process.env.NODE_ENV === 'production') {
      // TODO: 集成SMS服务
      logger.info(`生产环境: 应该发送短信到 ${phone} 验证码: ${code}`);
    } else {
      logger.info(`开发环境: 模拟发送验证码到 ${phone}: ${code}`);
    }

    return {
      success: true,
      message: '验证码已发送',
      // 仅在开发环境返回验证码
      ...(process.env.NODE_ENV === 'development' && { code })
    };
  } catch (error) {
    logger.error('发送验证码失败:', { error });
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
    const user = await getUserModel().findOne({ phone });
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
    logger.info(`为用户 ${phone} 发送验证码: ${resetCode}`);
    
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
    const user = await getUserModel().findOne({ phone });
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

/**
 * 手机号验证码登录（不存在则自动注册）
 * @async
 * @param {string} phone - 手机号
 * @param {string} code - 验证码
 * @returns {Promise<Object>} 登录用户信息与token
 */
const loginOrRegisterWithCode = async (phone, code) => {
  try {
    const isValid = await validateTempCode(phone, code);
    if (!isValid) {
      throw new AppError('验证码无效或已过期', 401);
    }

    const UserModel = getUserModel();
    let user = await UserModel.findOne({ phone });

    if (!user) {
      // 自动注册流程
      const userData = {
        phone,
        authType: 'code'
      };
      user = await register(userData);
    }

    await clearTempCode(phone);

    // 更新最后登录时间
    if (typeof user.save === 'function') {
      user.lastLogin = new Date();
      await user.save();
    } else {
      await UserModel.findOneAndUpdate(
        { _id: user._id || user.id },
        { $set: { lastLogin: new Date() } }
      );
      user = await UserModel.findById(user._id || user.id);
    }

    const userObject = user.toObject ? user.toObject() : { ...user };
    delete userObject.password;

    const token = generateToken(user);
    return { user: userObject, token };
  } catch (error) {
    logger.error('验证码登录失败:', { error });
    throw new AppError(error.message || '登录失败', error.statusCode || 500);
  }
};

// 模块导出
module.exports = {
  register,
  login,
  loginWithCode,
  loginOrRegisterWithCode,
  sendVerificationCode,
  sendPasswordResetCode,
  resetPassword,
  verifyToken
};