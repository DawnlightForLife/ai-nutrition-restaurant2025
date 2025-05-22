/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 高级限流中间件集合（基于 express-rate-limit + ioredis）
 * ✅ 功能概览：
 *   - createDynamicLimiter：动态限流器（参数自定义）
 *   - roleBasedLimiter：根据用户角色配置不同限流速率
 *   - pathBasedLimiter：根据接口路径定制限流配置
 *   - ipBasedLimiter：对单个IP进行限流及自动封禁
 *   - combinedLimiter：将多个限流策略组合应用（链式执行）
 * ✅ 特性支持：
 *   - Redis 缓存限流状态，支持多实例共享
 *   - 支持自定义key生成器与handler逻辑
 *   - 支持按角色/路径/IP组合使用
 * ✅ 建议 future：
 *   - 动态从数据库读取角色-限流配置（无需重启）
 *   - 提供可视化管理接口 /metrics/rate-limits
 */

const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');
const Redis = require('ioredis');
const { logger } = require('../core/loggingMiddleware');

// Redis 连接实例，用于共享限流状态
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

// 限流基础配置模板：包含 RedisStore、请求key生成、默认响应处理器等
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

/**
 * createDynamicLimiter
 * - 构建基础限流器，可用于自定义策略配置
 * - 可传入 windowMs、max、keyPrefix、customHandler 等
 */
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

/**
 * roleBasedLimiter
 * - 根据 req.user.role 值动态选取限流配置
 * - 默认支持 admin、manager、user 三种角色
 */
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

/**
 * pathBasedLimiter
 * - 根据 req.path 匹配路径限流配置
 * - 支持通配符 paths['*'] 设置默认策略
 */
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

/**
 * ipBasedLimiter
 * - 基于请求 IP 进行限流
 * - 超过阈值后自动封禁 IP 一段时间（blockDuration）
 */
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

/**
 * combinedLimiter
 * - 串行组合多个限流器，逐个调用
 * - 任一限流器触发限制时会中断请求链
 */
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