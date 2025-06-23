const config = require('../config');
const logger = require('../config/modules/logger');

let cacheService;

try {
  if (config.cache.useRedis) {
    // 使用Redis缓存
    const { cacheService: redisCacheService } = require('../config/modules/redis');
    cacheService = redisCacheService;
    logger.info('使用Redis缓存服务');
  } else {
    // 使用内存缓存作为后备
    const NodeCache = require('node-cache');
    const nodeCache = new NodeCache({
      stdTTL: config.cache.defaultTTL || 300,
      checkperiod: config.cache.checkPeriod || 600,
      maxKeys: config.cache.maxItems || 1000
    });

    cacheService = {
      async get(key) {
        return nodeCache.get(key) || null;
      },

      async set(key, value, ttl) {
        if (ttl) {
          return nodeCache.set(key, value, ttl);
        }
        return nodeCache.set(key, value);
      },

      async del(key) {
        return nodeCache.del(key);
      },

      async delPattern(pattern) {
        const keys = nodeCache.keys().filter(key => key.includes(pattern.replace('*', '')));
        return nodeCache.del(keys);
      },

      isConnected() {
        return true;
      }
    };
    
    logger.info('使用内存缓存服务');
  }
} catch (error) {
  logger.error('缓存服务初始化失败:', error);
  
  // 创建一个空的缓存服务作为降级方案
  cacheService = {
    async get() { return null; },
    async set() { return true; },
    async del() { return true; },
    async delPattern() { return 0; },
    isConnected() { return false; }
  };
}

module.exports = cacheService;