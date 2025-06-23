const Redis = require('ioredis');
const logger = require('./logger');

let redisClient;
let isConnected = false;

// Redis 配置
const redisConfig = {
  host: process.env.REDIS_HOST || 'localhost',
  port: process.env.REDIS_PORT || 6379,
  db: process.env.REDIS_DB || 0,
  password: process.env.REDIS_PASSWORD || null,
  retryDelayOnFailover: 100,
  maxRetriesPerRequest: 3,
  lazyConnect: true,
  connectTimeout: 10000,
  commandTimeout: 5000,
};

// 初始化 Redis 连接
function initializeRedis() {
  try {
    redisClient = new Redis(redisConfig);

    redisClient.on('connect', () => {
      logger.info('Redis 连接成功');
      isConnected = true;
    });

    redisClient.on('error', (error) => {
      logger.error('Redis 连接错误:', error);
      isConnected = false;
    });

    redisClient.on('close', () => {
      logger.warn('Redis 连接已关闭');
      isConnected = false;
    });

    redisClient.on('reconnecting', () => {
      logger.info('Redis 重新连接中...');
    });

    // 尝试连接
    redisClient.connect().catch(error => {
      logger.error('Redis 初始连接失败:', error);
      isConnected = false;
    });

  } catch (error) {
    logger.error('Redis 初始化失败:', error);
    isConnected = false;
  }
}

// 缓存服务
const cacheService = {
  // 获取缓存
  async get(key) {
    if (!isConnected || !redisClient) {
      throw new Error('Redis 未连接');
    }
    
    try {
      const data = await redisClient.get(key);
      return data ? JSON.parse(data) : null;
    } catch (error) {
      logger.error('Redis GET 操作失败:', error);
      throw error;
    }
  },

  // 设置缓存
  async set(key, value, ttl = 3600) {
    if (!isConnected || !redisClient) {
      throw new Error('Redis 未连接');
    }
    
    try {
      const data = JSON.stringify(value);
      if (ttl > 0) {
        await redisClient.setex(key, ttl, data);
      } else {
        await redisClient.set(key, data);
      }
      return true;
    } catch (error) {
      logger.error('Redis SET 操作失败:', error);
      throw error;
    }
  },

  // 删除缓存
  async del(key) {
    if (!isConnected || !redisClient) {
      throw new Error('Redis 未连接');
    }
    
    try {
      return await redisClient.del(key);
    } catch (error) {
      logger.error('Redis DEL 操作失败:', error);
      throw error;
    }
  },

  // 批量删除缓存
  async delPattern(pattern) {
    if (!isConnected || !redisClient) {
      throw new Error('Redis 未连接');
    }
    
    try {
      const keys = await redisClient.keys(pattern);
      if (keys.length > 0) {
        return await redisClient.del(...keys);
      }
      return 0;
    } catch (error) {
      logger.error('Redis 批量删除操作失败:', error);
      throw error;
    }
  },

  // 检查连接状态
  isConnected() {
    return isConnected && redisClient && redisClient.status === 'ready';
  },

  // 获取客户端实例
  getClient() {
    return redisClient;
  }
};

// 优雅关闭
process.on('SIGINT', async () => {
  if (redisClient) {
    await redisClient.quit();
    logger.info('Redis 连接已关闭');
  }
});

module.exports = {
  initializeRedis,
  cacheService,
  redisClient: () => redisClient
};