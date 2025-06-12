/**
 * Redis 缓存服务模块
 * 提供通用的 Redis 缓存操作功能，特别适用于数据库查询结果的缓存
 * 包括：缓存初始化、读写、删除、按模式清除、统计收集、状态管理
 * 支持自动连接重试、结构化日志输出、缓存命中统计等功能
 * @module services/core/cacheService
 */

const redis = require('redis');
const { promisify } = require('util');
const crypto = require('crypto');
const config = require('../../config');
const logger = require('../../utils/logger/winstonLogger.js');

class CacheService {
  constructor() {
    this.client = null;
    this.enabled = config.cache && config.cache.enabled;
    this.defaultTTL = (config.cache && config.cache.defaultTTL) || 300; // 默认5分钟
    this.initialized = false;
    
    // 缓存统计
    this.stats = {
      hits: 0,
      misses: 0,
      sets: 0,
      errors: 0,
      lastReset: Date.now()
    };
  }

  /**
   * 初始化Redis连接
   * @returns {Promise<boolean>} 连接是否成功
   */
  async initialize() {
    if (!this.enabled) {
      logger.info('缓存服务已禁用');
      return false;
    }
    
    if (this.initialized) {
      return true;
    }
    
    try {
      // 创建Redis客户端
      this.client = redis.createClient({
        url: config.cache.redisUrl || 'redis://localhost:6379',
        password: config.cache.redisPassword || '',
        database: config.cache.redisDb || 0,
        retry_strategy: (options) => {
          if (options.error && options.error.code === 'ECONNREFUSED') {
            // 连接被拒绝，5秒后重试
            return 5000;
          }
          if (options.total_retry_time > 1000 * 60 * 60) {
            // 连接超时（1小时），不再尝试
            return new Error('重试时间已用尽，Redis连接失败');
          }
          // 指数级增长的重试延迟
          return Math.min(options.attempt * 100, 3000);
        }
      });
      
      // 将回调式API转换为Promise风格
      this.getAsync = promisify(this.client.get).bind(this.client);
      this.setAsync = promisify(this.client.set).bind(this.client);
      this.delAsync = promisify(this.client.del).bind(this.client);
      this.keysAsync = promisify(this.client.keys).bind(this.client);
      this.existsAsync = promisify(this.client.exists).bind(this.client);
      this.ttlAsync = promisify(this.client.ttl).bind(this.client);
      this.expireAsync = promisify(this.client.expire).bind(this.client);
      
      // 设置事件监听器
      this.client.on('error', (error) => {
        logger.error('Redis连接错误', { error });
        this.stats.errors++;
      });
      
      this.client.on('ready', () => {
        logger.info('Redis连接已就绪');
        this.initialized = true;
      });
      
      this.client.on('reconnecting', () => {
        logger.info('正在重新连接Redis...');
      });
      
      return true;
    } catch (error) {
      logger.error('初始化Redis客户端失败', { error });
      this.stats.errors++;
      return false;
    }
  }
  
  /**
   * 生成缓存键
   * @param {string} prefix - 键前缀，通常是集合名
   * @param {Object} query - 查询条件对象
   * @param {Object} options - 查询选项，如排序、投影等
   * @returns {string} 缓存键
   */
  generateCacheKey(prefix, query, options = {}) {
    // 创建一个包含所有查询参数的对象
    const cacheObject = {
      query: query || {},
      options: options || {}
    };
    
    // 将对象转换为字符串并生成哈希
    const strValue = JSON.stringify(cacheObject);
    const hash = crypto.createHash('md5').update(strValue).digest('hex');
    
    // 前缀:MD5哈希
    return `${prefix}:${hash}`;
  }
  
  /**
   * 从缓存获取数据
   * @param {string} key - 缓存键
   * @returns {Promise<Object|null>} 缓存的数据或null
   */
  async get(key) {
    if (!this.enabled || !this.initialized) {
      return null;
    }
    
    try {
      const cachedData = await this.getAsync(key);
      
      if (cachedData) {
        this.stats.hits++;
        // 解析JSON数据
        return JSON.parse(cachedData);
      } else {
        this.stats.misses++;
        return null;
      }
    } catch (error) {
      logger.error(`缓存获取错误 [${key}]`, { error });
      this.stats.errors++;
      return null;
    }
  }
  
  /**
   * 将数据存入缓存
   * @param {string} key - 缓存键
   * @param {Object} data - 要缓存的数据
   * @param {number} ttl - 过期时间(秒)
   * @returns {Promise<boolean>} 是否成功
   */
  async set(key, data, ttl = this.defaultTTL) {
    if (!this.enabled || !this.initialized) {
      return false;
    }
    
    try {
      // 将数据转换为JSON字符串
      const jsonData = JSON.stringify(data);
      
      // 设置带过期时间的缓存
      await this.setAsync(key, jsonData, 'EX', ttl);
      
      this.stats.sets++;
      return true;
    } catch (error) {
      logger.error(`缓存设置错误 [${key}]`, { error });
      this.stats.errors++;
      return false;
    }
  }
  
  /**
   * 删除缓存
   * @param {string} key - 缓存键
   * @returns {Promise<boolean>} 是否成功
   */
  async delete(key) {
    if (!this.enabled || !this.initialized) {
      return false;
    }
    
    try {
      await this.delAsync(key);
      return true;
    } catch (error) {
      logger.error(`缓存删除错误 [${key}]`, { error });
      this.stats.errors++;
      return false;
    }
  }
  
  /**
   * 删除缓存 (别名方法，兼容性)
   * @param {string} key - 缓存键
   * @returns {Promise<boolean>} 是否成功
   */
  async del(key) {
    return this.delete(key);
  }
  
  /**
   * 清除指定模式的所有缓存
   * @param {string} pattern - 键模式，如"users:*"
   * @returns {Promise<number>} 删除的键数量
   */
  async clearPattern(pattern) {
    if (!this.enabled || !this.initialized) {
      return 0;
    }
    
    try {
      // 查找匹配模式的键
      const keys = await this.keysAsync(pattern);
      
      if (keys && keys.length > 0) {
        // 批量删除
        await this.delAsync(keys);
        return keys.length;
      }
      
      return 0;
    } catch (error) {
      logger.error(`清除缓存模式错误 [${pattern}]`, { error });
      this.stats.errors++;
      return 0;
    }
  }
  
  /**
   * 获取缓存统计信息
   * @returns {Object} 缓存统计
   */
  getStats() {
    return {
      ...this.stats,
      hitRatio: this.stats.hits + this.stats.misses > 0 
        ? this.stats.hits / (this.stats.hits + this.stats.misses) 
        : 0,
      timestamp: new Date()
    };
  }
  
  /**
   * 重置统计信息
   */
  resetStats() {
    this.stats = {
      hits: 0,
      misses: 0,
      sets: 0,
      errors: 0,
      lastReset: Date.now()
    };
  }
  
  /**
   * 关闭Redis客户端
   */
  async close() {
    if (this.client) {
      this.client.quit();
      this.initialized = false;
      logger.info('Redis客户端已关闭');
    }
  }
}

// 导出单例
module.exports = new CacheService(); 