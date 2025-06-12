/**
 * 数据加密工具
 * 用于敏感信息的加密和解密处理
 */

const crypto = require('crypto');

// Graceful logger handling
let logger = {
  debug: console.log,
  info: console.log,
  warn: console.warn,
  error: console.error
};

// Graceful config handling
let config = {};
try {
  config = require('../config');
} catch (err) {
  config = { security: {} };
}

// 从环境变量获取加密密钥，如果没有则使用默认值（生产环境应该设置）
const ENCRYPTION_KEY = process.env.ENCRYPTION_KEY || config.security?.encryptionKey || 'default-key-32-characters-long!!';
const ALGORITHM = 'aes-256-cbc';

class DataEncryption {
  /**
   * 加密数据
   * @param {String} text - 需要加密的文本
   * @returns {String} 加密后的字符串（包含iv和authTag）
   */
  static encrypt(text) {
    try {
      if (!text || typeof text !== 'string') {
        throw new Error('待加密数据必须是非空字符串');
      }

      // 生成随机初始化向量
      const iv = crypto.randomBytes(16);
      
      // 创建加密器 (ensure key is 32 bytes for AES-256)
      const key = crypto.scryptSync(ENCRYPTION_KEY, 'salt', 32);
      const cipher = crypto.createCipheriv(ALGORITHM, key, iv);
      
      // 加密数据
      let encrypted = cipher.update(text, 'utf8', 'hex');
      encrypted += cipher.final('hex');
      
      // 组合iv和加密数据
      const result = iv.toString('hex') + ':' + encrypted;
      
      logger.debug('数据加密成功', { 
        originalLength: text.length,
        encryptedLength: result.length
      });
      
      return result;
      
    } catch (error) {
      logger.error('数据加密失败', { error: error.message });
      throw new Error('数据加密失败');
    }
  }

  /**
   * 解密数据
   * @param {String} encryptedData - 加密的数据
   * @returns {String} 解密后的原始文本
   */
  static decrypt(encryptedData) {
    try {
      if (!encryptedData || typeof encryptedData !== 'string') {
        throw new Error('待解密数据必须是非空字符串');
      }

      // 分解iv和加密数据
      const parts = encryptedData.split(':');
      if (parts.length !== 2) {
        throw new Error('加密数据格式无效');
      }

      const iv = Buffer.from(parts[0], 'hex');
      const encrypted = parts[1];

      // 创建解密器 (ensure key is 32 bytes for AES-256)
      const key = crypto.scryptSync(ENCRYPTION_KEY, 'salt', 32);
      const decipher = crypto.createDecipheriv(ALGORITHM, key, iv);

      // 解密数据
      let decrypted = decipher.update(encrypted, 'hex', 'utf8');
      decrypted += decipher.final('utf8');

      logger.debug('数据解密成功', { 
        encryptedLength: encryptedData.length,
        decryptedLength: decrypted.length
      });

      return decrypted;
      
    } catch (error) {
      logger.error('数据解密失败', { error: error.message });
      throw new Error('数据解密失败');
    }
  }

  /**
   * 哈希数据（用于不需要解密的敏感数据）
   * @param {String} text - 需要哈希的文本
   * @param {String} salt - 盐值（可选）
   * @returns {String} 哈希后的字符串
   */
  static hash(text, salt = '') {
    try {
      if (!text || typeof text !== 'string') {
        throw new Error('待哈希数据必须是非空字符串');
      }

      const hash = crypto.createHash('sha256');
      hash.update(text + salt);
      const result = hash.digest('hex');
      
      logger.debug('数据哈希成功', { 
        originalLength: text.length,
        hashLength: result.length
      });
      
      return result;
      
    } catch (error) {
      logger.error('数据哈希失败', { error: error.message });
      throw new Error('数据哈希失败');
    }
  }

  /**
   * 生成随机盐值
   * @param {Number} length - 盐值长度
   * @returns {String} 随机盐值
   */
  static generateSalt(length = 16) {
    return crypto.randomBytes(length).toString('hex');
  }

  /**
   * 数据脱敏显示
   * @param {String} data - 原始数据
   * @param {String} type - 数据类型 ('idNumber', 'phone', 'email', 'name')
   * @returns {String} 脱敏后的数据
   */
  static mask(data, type = 'default') {
    if (!data || typeof data !== 'string') {
      return '';
    }

    switch (type) {
      case 'idNumber':
        // 身份证号：显示前6位和后4位
        if (data.length >= 10) {
          return data.substring(0, 6) + '*'.repeat(data.length - 10) + data.substring(data.length - 4);
        }
        break;
        
      case 'phone':
        // 手机号：显示前3位和后4位
        if (data.length >= 7) {
          return data.substring(0, 3) + '*'.repeat(data.length - 7) + data.substring(data.length - 4);
        }
        break;
        
      case 'email':
        // 邮箱：显示用户名前2位和域名
        const atIndex = data.indexOf('@');
        if (atIndex > 2) {
          return data.substring(0, 2) + '*'.repeat(atIndex - 2) + data.substring(atIndex);
        }
        break;
        
      case 'name':
        // 姓名：显示首字和末字
        if (data.length > 2) {
          return data.charAt(0) + '*'.repeat(data.length - 2) + data.charAt(data.length - 1);
        } else if (data.length === 2) {
          return data.charAt(0) + '*';
        }
        break;
        
      default:
        // 默认：显示前2位和后2位
        if (data.length > 4) {
          return data.substring(0, 2) + '*'.repeat(data.length - 4) + data.substring(data.length - 2);
        }
    }
    
    return '*'.repeat(data.length);
  }
}

module.exports = DataEncryption;