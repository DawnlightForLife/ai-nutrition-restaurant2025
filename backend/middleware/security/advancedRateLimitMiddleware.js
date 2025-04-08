const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');
const Redis = require('ioredis');
const { logger } = require('../core/loggingMiddleware');

/**
 * 高级请求限流中间件集合
 * 提供更复杂的限流功能，包括：
 * - 基于用户角色的限流
 * - 基于路径的限流
 * - 基于IP的限流
 * - 组合限流策略
 */

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

// 基础限流配置
const baseConfig = {
    store: new RedisStore({
        client: redis,
        prefix: 'rate-limit:',
        resetExpiryOnChange: true
    }),
    standardHeaders: true,
    legacyHeaders: false,
    skipSuccessfulRequests: false,
    keyGenerator: (req) => {
        return `${req.ip}-${req.path}`;
    },
    handler: (req, res) => {
        logger.warn('Rate limit exceeded', {
            ip: req.ip,
            path: req.path,
            limit: req.rateLimit.limit,
            remaining: req.rateLimit.remaining,
            resetTime: req.rateLimit.resetTime
        });
        res.status(429).json({
            error: 'Too many requests, please try again later.',
            retryAfter: Math.ceil((req.rateLimit.resetTime - Date.now()) / 1000)
        });
    }
};

// 动态限流配置生成器
const createDynamicLimiter = (options = {}) => {
    const {
        windowMs = 15 * 60 * 1000, // 15分钟
        max = 100, // 默认最大请求数
        skipFailedRequests = false,
        keyPrefix = '',
        customKeyGenerator,
        customHandler
    } = options;

    return rateLimit({
        ...baseConfig,
        windowMs,
        max,
        skipFailedRequests,
        keyGenerator: customKeyGenerator || ((req) => `${keyPrefix}-${req.ip}-${req.path}`),
        handler: customHandler || baseConfig.handler
    });
};

// 基于用户角色的限流器
const roleBasedLimiter = (roles) => {
    const limits = {
        admin: { windowMs: 60 * 1000, max: 1000 },
        manager: { windowMs: 60 * 1000, max: 500 },
        user: { windowMs: 60 * 1000, max: 100 }
    };

    return (req, res, next) => {
        const userRole = req.user?.role || 'user';
        const limit = limits[userRole] || limits.user;
        
        return createDynamicLimiter({
            windowMs: limit.windowMs,
            max: limit.max,
            keyPrefix: `role-${userRole}`
        })(req, res, next);
    };
};

// 基于路径的限流器
const pathBasedLimiter = (paths) => {
    return (req, res, next) => {
        const path = req.path;
        const limit = paths[path] || paths['*'] || { windowMs: 15 * 60 * 1000, max: 100 };
        
        return createDynamicLimiter({
            windowMs: limit.windowMs,
            max: limit.max,
            keyPrefix: `path-${path}`
        })(req, res, next);
    };
};

// 基于IP的限流器
const ipBasedLimiter = (options = {}) => {
    const {
        windowMs = 60 * 60 * 1000, // 1小时
        max = 1000,
        blockDuration = 24 * 60 * 60 * 1000 // 24小时
    } = options;

    return createDynamicLimiter({
        windowMs,
        max,
        keyPrefix: 'ip',
        customHandler: (req, res) => {
            const blockUntil = Date.now() + blockDuration;
            redis.set(`blocked:${req.ip}`, blockUntil, 'PX', blockDuration);
            
            logger.warn('IP blocked due to rate limit exceeded', {
                ip: req.ip,
                blockUntil: new Date(blockUntil),
                path: req.path
            });

            res.status(429).json({
                error: 'IP blocked due to too many requests',
                retryAfter: Math.ceil(blockDuration / 1000)
            });
        }
    });
};

// 组合限流器
const combinedLimiter = (limiters) => {
    return (req, res, next) => {
        let currentLimiter = 0;
        
        const nextLimiter = () => {
            if (currentLimiter >= limiters.length) {
                return next();
            }
            
            limiters[currentLimiter](req, res, (err) => {
                if (err) {
                    return next(err);
                }
                currentLimiter++;
                nextLimiter();
            });
        };
        
        nextLimiter();
    };
};

// 导出限流器
module.exports = {
    createDynamicLimiter,
    roleBasedLimiter,
    pathBasedLimiter,
    ipBasedLimiter,
    combinedLimiter,
    redis // 导出redis实例以供其他中间件使用
}; 