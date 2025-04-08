const Redis = require('ioredis');
const { promisify } = require('util');

/**
 * 缓存中间件集合
 * 提供基本的Redis缓存功能，包括：
 * - 请求结果缓存
 * - 缓存清理
 * - 缓存统计
 */

// Redis客户端配置
const redis = new Redis({
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
    password: process.env.REDIS_PASSWORD,
    retryStrategy: (times) => {
        const delay = Math.min(times * 50, 2000);
        return delay;
    }
});

// 错误处理
redis.on('error', (err) => {
    console.error('[ERROR] Redis connection error:', err);
});

// 缓存中间件
const cache = (duration) => {
    return async (req, res, next) => {
        // 只缓存GET请求
        if (req.method !== 'GET') {
            return next();
        }

        const key = `cache:${req.originalUrl}`;

        try {
            // 尝试从缓存获取数据
            const cachedData = await redis.get(key);
            
            if (cachedData) {
                return res.json(JSON.parse(cachedData));
            }

            // 如果没有缓存，重写res.json方法
            const originalJson = res.json;
            res.json = function(data) {
                // 设置缓存
                redis.setex(key, duration, JSON.stringify(data));
                // 调用原始的json方法
                return originalJson.call(this, data);
            };

            next();
        } catch (error) {
            console.error('[ERROR] Cache middleware error:', error);
            next();
        }
    };
};

// 清除缓存中间件
const clearCache = (pattern) => {
    return async (req, res, next) => {
        try {
            const keys = await redis.keys(pattern);
            if (keys.length > 0) {
                await redis.del(keys);
                console.log(`[INFO] Cleared cache for pattern: ${pattern}`);
            }
            next();
        } catch (error) {
            console.error('[ERROR] Clear cache error:', error);
            next();
        }
    };
};

// 缓存统计中间件
const cacheStats = async (req, res, next) => {
    try {
        const info = await redis.info();
        const stats = {
            hits: info.match(/keyspace_hits:(\d+)/)[1],
            misses: info.match(/keyspace_misses:(\d+)/)[1],
            memory: info.match(/used_memory_human:(\S+)/)[1],
            connectedClients: info.match(/connected_clients:(\d+)/)[1]
        };
        console.log('[INFO] Cache stats:', stats);
        next();
    } catch (error) {
        console.error('[ERROR] Cache stats error:', error);
        next();
    }
};

module.exports = {
    cache,
    clearCache,
    cacheStats,
    redis
}; 