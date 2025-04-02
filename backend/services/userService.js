const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { getShardName } = require('../utils/shardingConfig');
const dbManager = require('../config/database');

// JWT密钥，优先使用环境变量
const JWT_SECRET = process.env.JWT_SECRET || 'smart_nutrition_restaurant_secret';

/**
 * 获取用户分片名称
 * @param {string} phone - 用户手机号
 * @returns {string} 分片名称
 */
function getUserShardName(phone) {
  if (!phone) throw new Error('缺少phone参数用于计算用户分片');
  const shardName = getShardName('user', { phone });
  console.log('[分片] 计算用户分片:', shardName, '手机号:', phone);
  return shardName;
}

/**
 * 根据手机号查找用户
 * @param {string} phone - 用户手机号
 * @returns {Promise<Object|null>} 用户对象或null
 */
async function findUserByPhone(phone) {
  try {
    const db = await dbManager.getPrimaryConnection();
    const shard = getUserShardName(phone);
    console.log('[分片] 读取用户的分片集合:', shard);
    
    // 从分片查询用户
    const user = await db.collection(shard).findOne({ phone });
    
    // 如果分片中没找到，尝试查询默认集合（兼容旧数据）
    if (!user) {
      console.log('[分片] 分片中未找到用户，尝试查询默认集合 users');
      const User = mongoose.model('User');
      return await User.findOne({ phone }).lean();
    }
    
    return user;
  } catch (error) {
    console.error('[分片] 查询用户出错:', error);
    throw error;
  }
}

/**
 * 创建新用户
 * @param {Object} userData - 用户数据
 * @param {string} userData.phone - 手机号
 * @param {string} userData.password - 密码
 * @param {string} userData.nickname - 昵称
 * @param {string} userData.role - 角色
 * @returns {Promise<Object>} 创建的用户对象
 */
async function createUser({ phone, password, nickname, role = 'user' }) {
  try {
    // 对密码进行trim处理
    const trimmedPassword = password.trim();
    console.log('[分片] 创建用户密码长度:', trimmedPassword.length);
    
    // 加密处理后的密码
    const hashedPassword = await bcrypt.hash(trimmedPassword, 10);
    
    // 确定分片名称
    const shard = getUserShardName(phone);
    console.log('[分片] 写入用户的分片集合:', shard);
    
    // 创建用户对象
    const userData = {
      _id: new mongoose.Types.ObjectId(),
      phone,
      password: hashedPassword,
      nickname,
      role,
      createdAt: new Date(),
      updatedAt: new Date()
    };
    
    // 获取数据库连接并写入
    const db = await dbManager.getPrimaryConnection();
    const result = await db.collection(shard).insertOne(userData);
    
    // 同时写入默认集合以兼容旧代码
    console.log('[分片] 同时写入默认集合 users 以兼容旧代码');
    const User = mongoose.model('User');
    const userModel = new User(userData);
    await userModel.save();
    
    return { ...userData, _id: result.insertedId || userData._id };
  } catch (error) {
    console.error('[分片] 创建用户出错:', error);
    throw error;
  }
}

/**
 * 验证用户密码
 * @param {Object} user - 用户对象
 * @param {string} password - 待验证的密码
 * @returns {Promise<boolean>} 验证结果
 */
async function verifyPassword(user, password) {
  try {
    if (!user || !user.password) return false;
    
    // 先用trim后的密码验证
    const trimmedPassword = password.trim();
    console.log('[分片] 验证密码 - 原始密码长度:', password.length);
    console.log('[分片] 验证密码 - Trim后长度:', trimmedPassword.length);
    
    // 首先尝试trim后的密码
    const isValid = await bcrypt.compare(trimmedPassword, user.password);
    console.log('[分片] 密码验证结果:', isValid);
    
    // 如果trim后的验证失败，且原始密码与trim后不同，再尝试原始密码
    if (!isValid && trimmedPassword !== password) {
      const isValidOriginal = await bcrypt.compare(password, user.password);
      console.log('[分片] 原始密码验证结果:', isValidOriginal);
      return isValidOriginal;
    }
    
    return isValid;
  } catch (error) {
    console.error('[分片] 验证密码出错:', error);
    return false;
  }
}

/**
 * 跨分片查找用户
 * @param {Object} query - 查询条件
 * @returns {Promise<Object|null>} 用户对象或null
 */
async function findUserAcrossShards(query) {
  try {
    // 优先使用phone字段确定分片
    if (query.phone) {
      return await findUserByPhone(query.phone);
    }
    
    // 如果有id，使用id查询
    if (query._id) {
      const User = mongoose.model('User');
      return await User.findById(query._id).lean();
    }
    
    // 其他情况，查询默认集合
    console.log('[分片] 无法确定分片，查询默认集合 users');
    const User = mongoose.model('User');
    return await User.findOne(query).lean();
  } catch (error) {
    console.error('[分片] 跨分片查询用户出错:', error);
    throw error;
  }
}

/**
 * 更新用户信息
 * @param {string} userId - 用户ID
 * @param {Object} updateData - 更新数据
 * @param {string} updateData.phone - 手机号（可选）
 * @param {string} updateData.nickname - 昵称（可选）
 * @param {Object} updateData.extraData - 其他字段
 * @returns {Promise<Object>} 更新后的用户对象
 */
async function updateUser(userId, updateData) {
  try {
    // 先获取用户信息以确定分片
    const user = await findUserAcrossShards({ _id: userId });
    if (!user) {
      throw new Error(`用户ID ${userId} 不存在`);
    }
    
    // 准备更新数据
    const dataToUpdate = {
      ...updateData,
      updatedAt: new Date()
    };
    
    // 使用手机号确定分片
    const phone = updateData.phone || user.phone;
    if (!phone) {
      throw new Error('用户没有手机号，无法确定分片');
    }
    
    const shard = getUserShardName(phone);
    console.log('[分片] 更新用户的分片集合:', shard);
    
    // 获取数据库连接并更新
    const db = await dbManager.getPrimaryConnection();
    const result = await db.collection(shard).updateOne(
      { _id: mongoose.Types.ObjectId(userId) },
      { $set: dataToUpdate }
    );
    
    // 同时更新默认集合，确保兼容性
    const User = mongoose.model('User');
    await User.updateOne({ _id: userId }, { $set: dataToUpdate });
    
    // 获取更新后的用户信息
    return await findUserAcrossShards({ _id: userId });
  } catch (error) {
    console.error('[分片] 更新用户信息出错:', error);
    throw error;
  }
}

/**
 * 生成JWT令牌
 * @param {Object} payload - 令牌负载
 * @param {string} payload.userId - 用户ID
 * @param {string} payload.role - 用户角色
 * @param {Object} options - 令牌选项
 * @param {string} options.expiresIn - 过期时间
 * @returns {string} JWT令牌
 */
function generateToken(payload, options = {}) {
  try {
    const { userId, role } = payload;
    if (!userId) throw new Error('生成令牌需要userId');
    
    const expiresIn = options.expiresIn || process.env.JWT_EXPIRES_IN || '7d';
    
    console.log('[令牌] 为用户生成JWT令牌, 用户ID:', userId, '角色:', role || 'user');
    
    const token = jwt.sign(
      { userId, role: role || 'user' },
      JWT_SECRET,
      { expiresIn }
    );
    
    return token;
  } catch (error) {
    console.error('[令牌] 生成JWT令牌出错:', error);
    throw error;
  }
}

// 导出所有方法
module.exports = {
  getUserShardName,
  findUserByPhone,
  createUser,
  verifyPassword,
  findUserAcrossShards,
  updateUser,
  generateToken
}; 