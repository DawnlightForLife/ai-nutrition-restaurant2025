const Redis = require('ioredis');
const { logger } = require('./loggingMiddleware');
const { metrics } = require('./advancedPerformanceMiddleware');

// Redis配置
const redis = new Redis({
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
    password: process.env.REDIS_PASSWORD,
    db: process.env.REDIS_DB || 0,
    retryStrategy: (times) => {
        const delay = Math.min(times * 50, 2000);
        return delay;
    }
});

// 缓存统计类
class CacheStats {
    constructor() {
        this.hits = 0;
        this.misses = 0;
        this.errors = 0;
        this.size = 0;
        this.lastReset = new Date();
    }

    incrementHits() {
        this.hits++;
    }

    incrementMisses() {
        this.misses++;
    }

    incrementErrors() {
        this.errors++;
    }

    updateSize(size) {
        this.size = size;
    }

    reset() {
        this.hits = 0;
        this.misses = 0;
        this.errors = 0;
        this.size = 0;
        this.lastReset = new Date();
    }

    getStats() {
        const total = this.hits + this.misses;
        return {
            hits: this.hits,
            misses: this.misses,
            errors: this.errors,
            hitRate: total > 0 ? (this.hits / total) * 100 : 0,
            size: this.size,
            lastReset: this.lastReset
        };
    }
}

// 缓存管理器类
class CacheManager {
    constructor(options = {}) {
        this.redis = redis;
        this.options = {
            ttl: options.ttl || 300, // 默认5分钟
            prefix: options.prefix || 'cache:',
            staleWhileRevalidate: options.staleWhileRevalidate || false,
            maxSize: options.maxSize || 1000, // 最大缓存条目数
            compression: options.compression || false,
            ...options
        };
        this.stats = new CacheStats();
    }

    async get(key) {
        try {
            const data = await this.redis.get(`${this.options.prefix}${key}`);
            if (data) {
                this.stats.incrementHits();
                return JSON.parse(data);
            }
            this.stats.incrementMisses();
            return null;
        } catch (error) {
            this.stats.incrementErrors();
            logger.error('Cache get error:', error);
            return null;
        }
    }

    async set(key, value, ttl = this.options.ttl) {
        try {
            const serialized = JSON.stringify(value);
            await this.redis.set(
                `${this.options.prefix}${key}`,
                serialized,
                'EX',
                ttl
            );
            await this.updateSize();
            return true;
        } catch (error) {
            this.stats.incrementErrors();
            logger.error('Cache set error:', error);
            return false;
        }
    }

    async delete(key) {
        try {
            await this.redis.del(`${this.options.prefix}${key}`);
            await this.updateSize();
            return true;
        } catch (error) {
            this.stats.incrementErrors();
            logger.error('Cache delete error:', error);
            return false;
        }
    }

    async clear(pattern) {
        try {
            const keys = await this.redis.keys(`${this.options.prefix}${pattern}`);
            if (keys.length > 0) {
                await this.redis.del(keys);
            }
            await this.updateSize();
            return true;
        } catch (error) {
            this.stats.incrementErrors();
            logger.error('Cache clear error:', error);
            return false;
        }
    }

    async updateSize() {
        try {
            const keys = await this.redis.keys(`${this.options.prefix}*`);
            this.stats.updateSize(keys.length);
        } catch (error) {
            logger.error('Cache size update error:', error);
        }
    }

    getStats() {
        return this.stats.getStats();
    }

    resetStats() {
        this.stats.reset();
    }
}

// 创建缓存管理器实例
const cacheManager = new CacheManager();

// 缓存中间件
const cacheMiddleware = (options = {}) => {
    const manager = new CacheManager(options);
    
    return async (req, res, next) => {
        if (req.method !== 'GET') {
            return next();
        }

        const cacheKey = `${req.method}:${req.path}:${JSON.stringify(req.query)}`;
        const cachedData = await manager.get(cacheKey);

        if (cachedData) {
            return res.json(cachedData);
        }

        const originalJson = res.json;
        res.json = function(data) {
            manager.set(cacheKey, data, options.ttl);
            return originalJson.call(this, data);
        };

        next();
    };
};

// 缓存清理中间件
const clearCacheMiddleware = (patterns) => {
    return async (req, res, next) => {
        if (req.method === 'POST' || req.method === 'PUT' || req.method === 'DELETE') {
            try {
                await Promise.all(patterns.map(pattern => cacheManager.clear(pattern)));
                logger.info('Cache cleared for patterns:', patterns);
            } catch (error) {
                logger.error('Cache clear error:', error);
            }
        }
        next();
    };
};

// 缓存统计中间件
const cacheStatsMiddleware = (req, res, next) => {
    if (req.path === '/api/cache/stats') {
        const stats = cacheManager.getStats();
        res.json(stats);
    } else {
        next();
    }
};

// 定期清理过期缓存
setInterval(async () => {
    try {
        const stats = cacheManager.getStats();
        if (stats.size > cacheManager.options.maxSize) {
            await cacheManager.clear('*');
            logger.info('Cache cleared due to size limit');
        }
    } catch (error) {
        logger.error('Cache cleanup error:', error);
    }
}, 3600000); // 每小时清理一次

// 导出中间件和实例
module.exports = {
    cacheMiddleware,
    clearCacheMiddleware,
    cacheStatsMiddleware,
    cacheManager,
    redis
}; 