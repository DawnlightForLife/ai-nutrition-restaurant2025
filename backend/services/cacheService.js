/**
 * 多级缓存服务
 * 提供内存缓存和Redis分布式缓存功能
 */

const redis = require('redis');
const { promisify } = require('util');
const NodeCache = require('node-cache');

class CacheService {
  constructor() {
    // 内存缓存配置
    this.memoryCache = new NodeCache({
      stdTTL: 60, // 默认缓存有效期60秒
      checkperiod: 120, // 定期检查过期的间隔
      useClones: false, // 不使用对象克隆，提高性能
      maxKeys: 10000 // 最大缓存键数量
    });
    
    // Redis客户端配置
    this.redisClient = null;
    this.redisEnabled = false;
    
    // 缓存命中计数器
    this.stats = {
      hits: 0,
      misses: 0,
      memoryHits: 0,
      redisHits: 0
    };
  }
  
  /**
   * 初始化Redis连接
   * @param {Object} options Redis连接选项
   * @returns {Promise<Boolean>} 初始化结果
   */
  async initRedis(options = {}) {
    try {
      const defaultOptions = {
        host: process.env.REDIS_HOST || 'localhost',
        port: process.env.REDIS_PORT || 6379,
        password: process.env.REDIS_PASSWORD || '',
        db: process.env.REDIS_DB || 0,
        retry_strategy: (options) => {
          if (options.error && options.error.code === 'ECONNREFUSED') {
            return new Error('Redis服务器拒绝连接');
          }
          if (options.total_retry_time > 1000 * 60 * 60) {
            return new Error('Redis重试时间已用尽');
          }
          if (options.attempt > 10) {
            return undefined; // 停止重试
          }
          // 指数退避策略
          return Math.min(options.attempt * 100, 3000);
        }
      };
      
      const redisOptions = { ...defaultOptions, ...options };
      
      this.redisClient = redis.createClient(redisOptions);
      
      // 将Redis客户端回调方法转为Promise
      this.getAsync = promisify(this.redisClient.get).bind(this.redisClient);
      this.setAsync = promisify(this.redisClient.set).bind(this.redisClient);
      this.delAsync = promisify(this.redisClient.del).bind(this.redisClient);
      this.expireAsync = promisify(this.redisClient.expire).bind(this.redisClient);
      this.flushallAsync = promisify(this.redisClient.flushall).bind(this.redisClient);
      
      // 监听Redis事件
      this.redisClient.on('error', (error) => {
        console.error('Redis连接错误:', error);
        this.redisEnabled = false;
      });
      
      this.redisClient.on('ready', () => {
        console.log('Redis连接就绪');
        this.redisEnabled = true;
      });
      
      return true;
    } catch (error) {
      console.error('初始化Redis客户端出错:', error);
      this.redisEnabled = false;
      return false;
    }
  }
  
  /**
   * 从缓存中获取数据
   * @param {String} key 缓存键
   * @param {Function} fetchFn 数据获取函数
   * @param {Object} options 缓存选项
   * @returns {Promise<any>} 缓存的数据
   */
  async get(key, fetchFn = null, options = {}) {
    const { 
      ttl = 60, // 默认缓存60秒
      useRedis = true, // 是否使用Redis
      useMemory = true, // 是否使用内存缓存
      forceRefresh = false // 是否强制刷新
    } = options;
    
    // 强制刷新忽略缓存
    if (forceRefresh) {
      return this._fetchAndStore(key, fetchFn, ttl, useRedis, useMemory);
    }
    
    // 首先尝试从内存缓存获取
    if (useMemory) {
      const memValue = this.memoryCache.get(key);
      if (memValue !== undefined) {
        this.stats.hits++;
        this.stats.memoryHits++;
        return memValue;
      }
    }
    
    // 然后尝试从Redis获取
    if (useRedis && this.redisEnabled) {
      try {
        const redisValue = await this.getAsync(key);
        if (redisValue) {
          // 解析Redis存储的JSON字符串
          const value = JSON.parse(redisValue);
          
          // 同时更新内存缓存
          if (useMemory) {
            this.memoryCache.set(key, value, ttl);
          }
          
          this.stats.hits++;
          this.stats.redisHits++;
          return value;
        }
      } catch (error) {
        console.error(`从Redis获取缓存出错 [${key}]:`, error);
        // Redis出错时继续流程，不阻塞
      }
    }
    
    // 缓存未命中，执行获取函数
    this.stats.misses++;
    return this._fetchAndStore(key, fetchFn, ttl, useRedis, useMemory);
  }
  
  /**
   * 获取数据并存储到缓存
   * @private
   */
  async _fetchAndStore(key, fetchFn, ttl, useRedis, useMemory) {
    if (!fetchFn) {
      return null;
    }
    
    try {
      // 执行获取函数
      const value = await fetchFn();
      
      // 存储到内存缓存
      if (useMemory) {
        this.memoryCache.set(key, value, ttl);
      }
      
      // 存储到Redis
      if (useRedis && this.redisEnabled) {
        try {
          await this.setAsync(key, JSON.stringify(value), 'EX', ttl);
        } catch (error) {
          console.error(`将数据存储到Redis出错 [${key}]:`, error);
        }
      }
      
      return value;
    } catch (error) {
      console.error(`获取数据出错 [${key}]:`, error);
      throw error;
    }
  }
  
  /**
   * 直接设置缓存值
   * @param {String} key 缓存键
   * @param {any} value 缓存值
   * @param {Object} options 缓存选项
   */
  async set(key, value, options = {}) {
    const { 
      ttl = 60,
      useRedis = true,
      useMemory = true
    } = options;
    
    // 存储到内存缓存
    if (useMemory) {
      this.memoryCache.set(key, value, ttl);
    }
    
    // 存储到Redis
    if (useRedis && this.redisEnabled) {
      try {
        await this.setAsync(key, JSON.stringify(value), 'EX', ttl);
      } catch (error) {
        console.error(`将数据存储到Redis出错 [${key}]:`, error);
      }
    }
  }
  
  /**
   * 删除缓存项
   * @param {String} key 缓存键
   * @param {Object} options 删除选项
   */
  async del(key, options = {}) {
    const { 
      useRedis = true,
      useMemory = true
    } = options;
    
    if (useMemory) {
      this.memoryCache.del(key);
    }
    
    if (useRedis && this.redisEnabled) {
      try {
        await this.delAsync(key);
      } catch (error) {
        console.error(`从Redis删除数据出错 [${key}]:`, error);
      }
    }
  }
  
  /**
   * 清除指定前缀的所有缓存
   * @param {String} prefix 缓存键前缀
   */
  async delByPrefix(prefix) {
    // 清除内存缓存中符合前缀的键
    const memoryKeys = this.memoryCache.keys().filter(key => key.startsWith(prefix));
    if (memoryKeys.length > 0) {
      this.memoryCache.del(memoryKeys);
    }
    
    // Redis没有直接按前缀删除的方法，需要使用SCAN命令
    // 这里简化处理，生产环境中应使用SCAN命令实现
    if (this.redisEnabled) {
      console.warn(`Redis缓存按前缀删除功能需要使用SCAN命令实现，前缀: ${prefix}`);
    }
  }
  
  /**
   * 清除所有缓存
   */
  async flush() {
    // 清除内存缓存
    this.memoryCache.flushAll();
    
    // 清除Redis缓存
    if (this.redisEnabled) {
      try {
        await this.flushallAsync();
      } catch (error) {
        console.error('清除Redis缓存出错:', error);
      }
    }
    
    // 重置统计数据
    this.resetStats();
  }
  
  /**
   * 重置缓存统计数据
   */
  resetStats() {
    this.stats = {
      hits: 0,
      misses: 0,
      memoryHits: 0,
      redisHits: 0
    };
  }
  
  /**
   * 获取缓存统计信息
   * @returns {Object} 缓存统计信息
   */
  getStats() {
    const total = this.stats.hits + this.stats.misses;
    const hitRate = total > 0 ? (this.stats.hits / total) * 100 : 0;
    
    return {
      ...this.stats,
      total,
      hitRate: parseFloat(hitRate.toFixed(2)),
      memoryItems: this.memoryCache.keys().length,
      redisEnabled: this.redisEnabled
    };
  }
}

// 创建单例实例
const cacheService = new CacheService();

module.exports = cacheService; 