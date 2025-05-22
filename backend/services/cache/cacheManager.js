/**
 * 缓存管理器服务
 * 提供应用级的缓存管理功能
 * @module services/cache/cacheManager
 */

const redis = require('redis');
const { promisify } = require('util');
const config = require('../../config');
const logger = require('../../utils/logger/winstonLogger');

// 创建Redis客户端连接
let client;
let connected = false;

// 检查是否配置了Redis
const useRedis = config.redis && config.redis.host;

// 如果没有配置Redis，使用内存缓存
const memoryCache = new Map();
const memoryCacheExpiry = new Map();

/**
 * 初始化Redis客户端连接
 */
function initRedisClient() {
  if (!useRedis) {
    logger.info('使用内存缓存模式，未配置Redis');
    return;
  }

  client = redis.createClient({
    host: config.redis.host,
    port: config.redis.port || 6379,
    password: config.redis.password,
    db: config.redis.db || 0,
    retry_strategy: function(options) {
      if (options.error && options.error.code === 'ECONNREFUSED') {
        logger.error('Redis服务器拒绝连接');
        return 5000;
      }
      if (options.total_retry_time > 1000 * 60 * 60) {
        logger.error('重试Redis连接超时');
        return new Error('重试Redis连接超时');
      }
      if (options.attempt > 10) {
        logger.warn('Redis连接尝试次数过多，将使用内存缓存模式');
        return undefined;
      }
      return Math.min(options.attempt * 100, 3000);
    }
  });

  client.on('connect', () => {
    connected = true;
    logger.info('已连接到Redis服务器');
  });

  client.on('error', (err) => {
    connected = false;
    logger.error(`Redis连接错误: ${err.message}`);
  });

  client.on('end', () => {
    connected = false;
    logger.info('Redis连接已关闭');
  });
}

// 初始化Redis客户端
initRedisClient();

// Promisify Redis命令
const asyncGet = useRedis && client ? promisify(client.get).bind(client) : null;
const asyncSet = useRedis && client ? promisify(client.set).bind(client) : null;
const asyncDel = useRedis && client ? promisify(client.del).bind(client) : null;
const asyncExpire = useRedis && client ? promisify(client.expire).bind(client) : null;
const asyncKeys = useRedis && client ? promisify(client.keys).bind(client) : null;

// 定期清理内存缓存过期项
if (!useRedis) {
  setInterval(() => {
    const now = Date.now();
    for (const [key, expiry] of memoryCacheExpiry.entries()) {
      if (expiry <= now) {
        memoryCache.delete(key);
        memoryCacheExpiry.delete(key);
      }
    }
  }, 60000); // 每分钟检查一次
}

/**
 * 缓存管理器
 */
const cacheManager = {
  /**
   * 设置缓存项
   * @param {string} key - 缓存键名
   * @param {*} value - 缓存的值
   * @param {number} ttl - 缓存生存时间(秒)
   * @returns {Promise<boolean>} 操作成功状态
   */
  async set(key, value, ttl = 3600) {
    try {
      if (!key) {
        return false;
      }

      const valueStr = typeof value === 'string' ? value : JSON.stringify(value);

      if (useRedis && connected && asyncSet) {
        if (ttl > 0) {
          await asyncSet(key, valueStr, 'EX', ttl);
        } else {
          await asyncSet(key, valueStr);
        }
      } else {
        // 使用内存缓存
        memoryCache.set(key, valueStr);
        if (ttl > 0) {
          memoryCacheExpiry.set(key, Date.now() + (ttl * 1000));
        } else {
          memoryCacheExpiry.set(key, Infinity);
        }
      }
      return true;
    } catch (error) {
      logger.error(`缓存设置失败: ${error.message}`, { key, error });
      return false;
    }
  },

  /**
   * 获取缓存项
   * @param {string} key - 缓存键名
   * @param {boolean} parse - 是否解析JSON
   * @returns {Promise<*>} 缓存的值，不存在则返回null
   */
  async get(key, parse = true) {
    try {
      if (!key) {
        return null;
      }

      let value;
      
      if (useRedis && connected && asyncGet) {
        value = await asyncGet(key);
      } else {
        // 使用内存缓存
        if (memoryCache.has(key)) {
          const expiry = memoryCacheExpiry.get(key) || 0;
          if (expiry > Date.now()) {
            value = memoryCache.get(key);
          } else {
            // 已过期
            memoryCache.delete(key);
            memoryCacheExpiry.delete(key);
          }
        }
      }

      if (!value) {
        return null;
      }

      return parse && value && value.startsWith('{') ? JSON.parse(value) : value;
    } catch (error) {
      logger.error(`缓存获取失败: ${error.message}`, { key, error });
      return null;
    }
  },

  /**
   * 删除缓存项
   * @param {string} key - 缓存键名
   * @returns {Promise<boolean>} 操作成功状态
   */
  async del(key) {
    try {
      if (!key) {
        return false;
      }

      if (useRedis && connected && asyncDel) {
        await asyncDel(key);
      } else {
        // 使用内存缓存
        memoryCache.delete(key);
        memoryCacheExpiry.delete(key);
      }
      return true;
    } catch (error) {
      logger.error(`缓存删除失败: ${error.message}`, { key, error });
      return false;
    }
  },

  /**
   * 批量删除符合模式的缓存键
   * @param {string} pattern - 键名匹配模式
   * @returns {Promise<number>} 删除的键数量
   */
  async delByPattern(pattern) {
    try {
      if (!pattern) {
        return 0;
      }

      if (useRedis && connected && asyncKeys && asyncDel) {
        const keys = await asyncKeys(pattern);
        if (keys && keys.length > 0) {
          await asyncDel(keys);
          return keys.length;
        }
        return 0;
      } else {
        // 使用内存缓存，简单字符串匹配
        const patternRegex = new RegExp(pattern.replace('*', '.*'));
        let count = 0;
        for (const key of memoryCache.keys()) {
          if (patternRegex.test(key)) {
            memoryCache.delete(key);
            memoryCacheExpiry.delete(key);
            count++;
          }
        }
        return count;
      }
    } catch (error) {
      logger.error(`批量删除缓存失败: ${error.message}`, { pattern, error });
      return 0;
    }
  },

  /**
   * 清空所有缓存
   * @returns {Promise<boolean>} 操作成功状态
   */
  async clear() {
    try {
      if (useRedis && connected && client) {
        await new Promise((resolve, reject) => {
          client.flushdb((err, succeeded) => {
            if (err) reject(err);
            else resolve(succeeded);
          });
        });
      } else {
        // 使用内存缓存
        memoryCache.clear();
        memoryCacheExpiry.clear();
      }
      return true;
    } catch (error) {
      logger.error(`清空缓存失败: ${error.message}`, { error });
      return false;
    }
  },

  /**
   * 获取缓存统计信息
   * @returns {Promise<Object>} 缓存统计信息
   */
  async getStats() {
    try {
      if (useRedis && connected && client) {
        const info = await new Promise((resolve, reject) => {
          client.info((err, info) => {
            if (err) reject(err);
            else resolve(info);
          });
        });
        
        // 解析Redis INFO命令返回的信息
        const stats = {};
        info.split('\r\n').forEach(line => {
          const parts = line.split(':');
          if (parts.length === 2) {
            stats[parts[0]] = parts[1];
          }
        });
        
        return {
          type: 'redis',
          connected,
          ...stats
        };
      } else {
        // 内存缓存统计
        return {
          type: 'memory',
          keys: memoryCache.size,
          memory_used: process.memoryUsage().heapUsed
        };
      }
    } catch (error) {
      logger.error(`获取缓存统计信息失败: ${error.message}`, { error });
      return {
        type: useRedis ? 'redis' : 'memory',
        error: error.message,
        connected: useRedis ? connected : true
      };
    }
  }
};

module.exports = cacheManager; 