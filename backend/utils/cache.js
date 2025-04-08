/**
 * 缓存工具
 * 提供应用级别的缓存服务，支持内存缓存和Redis缓存
 * @module utils/cache
 */
const redis = require('redis');
const { promisify } = require('util');

// 内存缓存存储
const memoryCache = new Map();

// Redis客户端
let redisClient = null;
let redisGetAsync = null;
let redisSetAsync = null;
let redisDelAsync = null;
let redisFlushAsync = null;

/**
 * 初始化Redis缓存
 * @returns {Promise<boolean>} 初始化是否成功
 */
const initRedisCache = async () => {
  try {
    // 如果已经初始化，直接返回
    if (redisClient) {
      return true;
    }
    
    // 从环境变量获取Redis配置
    const redisUrl = process.env.REDIS_URL || 'redis://localhost:6379';
    
    // 创建Redis客户端
    redisClient = redis.createClient({
      url: redisUrl,
      retry_strategy: options => {
        // 重试策略
        if (options.error && options.error.code === 'ECONNREFUSED') {
          console.error('Redis连接被拒绝，可能未启动Redis服务');
          return new Error('Redis服务连接失败');
        }
        if (options.total_retry_time > 1000 * 60 * 30) {
          console.error('Redis重试时间超过30分钟，放弃连接');
          return new Error('Redis重试超时');
        }
        if (options.attempt > 10) {
          console.error('Redis已重试10次，放弃连接');
          return new Error('Redis重试次数过多');
        }
        
        // 使用指数退避策略，1s, 2s, 4s, 8s...
        return Math.min(options.attempt * 100, 3000);
      }
    });
    
    // 将回调API转为Promise
    redisGetAsync = promisify(redisClient.get).bind(redisClient);
    redisSetAsync = promisify(redisClient.set).bind(redisClient);
    redisDelAsync = promisify(redisClient.del).bind(redisClient);
    redisFlushAsync = promisify(redisClient.flushdb).bind(redisClient);
    
    // 监听连接事件
    redisClient.on('connect', () => {
      console.log('Redis缓存连接成功');
    });
    
    redisClient.on('error', err => {
      console.error('Redis缓存错误:', err);
    });
    
    return true;
  } catch (error) {
    console.error('初始化Redis缓存失败:', error);
    return false;
  }
};

/**
 * 获取缓存值
 * @param {string} key - 缓存键
 * @returns {Promise<any>} 缓存值
 */
const get = async (key) => {
  // 优先使用Redis
  if (redisClient) {
    try {
      const value = await redisGetAsync(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      console.error(`从Redis获取缓存失败 (${key}):`, error);
      // Redis失败，降级到内存缓存
    }
  }
  
  // 使用内存缓存
  const cacheItem = memoryCache.get(key);
  if (!cacheItem) return null;
  
  // 检查是否过期
  if (cacheItem.expiry && cacheItem.expiry < Date.now()) {
    memoryCache.delete(key);
    return null;
  }
  
  return cacheItem.value;
};

/**
 * 设置缓存值
 * @param {string} key - 缓存键
 * @param {any} value - 缓存值
 * @param {number} ttl - 过期时间(秒)，0表示永不过期
 * @returns {Promise<boolean>} 是否成功设置缓存
 */
const set = async (key, value, ttl = 0) => {
  // 优先使用Redis
  if (redisClient) {
    try {
      const valueStr = JSON.stringify(value);
      if (ttl > 0) {
        await redisSetAsync(key, valueStr, 'EX', ttl);
      } else {
        await redisSetAsync(key, valueStr);
      }
      return true;
    } catch (error) {
      console.error(`设置Redis缓存失败 (${key}):`, error);
      // Redis失败，降级到内存缓存
    }
  }
  
  // 使用内存缓存
  const cacheItem = {
    value,
    expiry: ttl > 0 ? Date.now() + (ttl * 1000) : null
  };
  
  memoryCache.set(key, cacheItem);
  return true;
};

/**
 * 删除缓存值
 * @param {string} key - 缓存键
 * @returns {Promise<boolean>} 是否成功删除缓存
 */
const del = async (key) => {
  let success = true;
  
  // 优先使用Redis
  if (redisClient) {
    try {
      await redisDelAsync(key);
    } catch (error) {
      console.error(`删除Redis缓存失败 (${key}):`, error);
      success = false;
    }
  }
  
  // 同时删除内存缓存
  memoryCache.delete(key);
  
  return success;
};

/**
 * 清空所有缓存
 * @returns {Promise<boolean>} 是否成功清空缓存
 */
const clear = async () => {
  let success = true;
  
  // 清空Redis缓存
  if (redisClient) {
    try {
      await redisFlushAsync();
    } catch (error) {
      console.error('清空Redis缓存失败:', error);
      success = false;
    }
  }
  
  // 清空内存缓存
  memoryCache.clear();
  
  return success;
};

/**
 * 关闭缓存连接
 * @returns {Promise<boolean>} 是否成功关闭连接
 */
const close = async () => {
  if (!redisClient) return true;
  
  return new Promise((resolve) => {
    redisClient.quit((err) => {
      if (err) {
        console.error('关闭Redis连接失败:', err);
        resolve(false);
      } else {
        console.log('Redis连接已关闭');
        redisClient = null;
        redisGetAsync = null;
        redisSetAsync = null;
        redisDelAsync = null;
        redisFlushAsync = null;
        resolve(true);
      }
    });
  });
};

// 导出缓存服务
module.exports = {
  initRedisCache,
  get,
  set,
  del,
  clear,
  close,
  // 缓存状态检查
  isRedisAvailable: () => !!redisClient,
  getCacheStats: () => ({
    memorySize: memoryCache.size,
    redisAvailable: !!redisClient
  })
}; 