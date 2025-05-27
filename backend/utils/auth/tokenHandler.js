/**
 * JWT令牌处理工具
 * 提供令牌的生成、验证、刷新等功能
 * @module utils/auth/tokenHandler
 */

const jwt = require('jsonwebtoken');
const config = require('../../config');
const logger = require('../logger/winstonLogger');

/**
 * 生成JWT访问令牌
 * @param {Object} user - 用户对象或用户ID
 * @param {Object} additionalClaims - 额外添加到令牌中的声明
 * @returns {string} JWT令牌
 */
exports.createToken = (user, additionalClaims = {}) => {
  try {
    // 准备payload
    const payload = {
      sub: typeof user === 'object' ? user._id : user,
      role: user.role || 'customer',
      ...additionalClaims
    };

    // 生成JWT令牌
    const token = jwt.sign(
      payload, 
      config.jwt.secret, 
      { expiresIn: config.jwt.expiresIn }
    );

    return token;
  } catch (error) {
    logger.error(`JWT令牌生成失败: ${error.message}`, { error });
    throw new Error('令牌生成失败');
  }
};

/**
 * 生成刷新令牌
 * @param {Object} user - 用户对象或用户ID
 * @returns {string} 刷新令牌
 */
exports.createRefreshToken = (user) => {
  try {
    const payload = {
      sub: typeof user === 'object' ? user._id : user,
      type: 'refresh'
    };

    // 生成更长有效期的刷新令牌
    const refreshToken = jwt.sign(
      payload, 
      config.jwt.secret, 
      { expiresIn: config.jwt.refreshExpiresIn }
    );

    return refreshToken;
  } catch (error) {
    logger.error(`刷新令牌生成失败: ${error.message}`, { error });
    throw new Error('刷新令牌生成失败');
  }
};

/**
 * 验证JWT令牌
 * @param {string} token - JWT令牌
 * @returns {Object} 解码后的令牌负载，验证失败时返回null
 */
exports.verifyToken = (token) => {
  try {
    // 验证并解码令牌
    const decoded = jwt.verify(token, config.jwt.secret);
    return decoded;
  } catch (error) {
    // 记录不同类型的令牌错误
    if (error.name === 'TokenExpiredError') {
      logger.warn('JWT令牌已过期');
    } else if (error.name === 'JsonWebTokenError') {
      logger.warn(`JWT令牌无效: ${error.message}`);
    } else {
      logger.error(`JWT令牌验证失败: ${error.message}`, { error });
    }
    return null;
  }
};

/**
 * 刷新访问令牌
 * @param {string} refreshToken - 刷新令牌
 * @returns {Object} 包含新访问令牌的对象，刷新失败时返回null
 */
exports.refreshAccessToken = (refreshToken) => {
  try {
    // 验证刷新令牌
    const decoded = jwt.verify(refreshToken, config.jwt.secret);
    
    // 确保是刷新令牌
    if (decoded.type !== 'refresh') {
      logger.warn('无效的刷新令牌类型');
      return null;
    }

    // 生成新的访问令牌
    const newAccessToken = exports.createToken({ _id: decoded.sub });
    
    return {
      accessToken: newAccessToken,
      userId: decoded.sub
    };
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      logger.warn('刷新令牌已过期');
    } else {
      logger.error(`刷新令牌验证失败: ${error.message}`, { error });
    }
    return null;
  }
};

/**
 * 解码令牌（不验证签名）
 * 用于调试和日志记录，不应用于身份验证
 * @param {string} token - JWT令牌
 * @returns {Object} 解码后的令牌负载，解码失败时返回null
 */
exports.decodeToken = (token) => {
  try {
    // 只解码不验证
    const decoded = jwt.decode(token);
    return decoded;
  } catch (error) {
    logger.error(`令牌解码失败: ${error.message}`, { error });
    return null;
  }
};
