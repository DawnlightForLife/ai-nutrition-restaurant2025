const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');
const Redis = require('ioredis');

// Redis连接配置
const redis = new Redis({
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
    password: process.env.REDIS_PASSWORD,
    keyPrefix: 'rate-limit:'
});

// 通用限流配置
const defaultLimiter = rateLimit({
    store: new RedisStore({
        client: redis,
        prefix: 'default:'
    }),
    windowMs: 15 * 60 * 1000, // 15分钟
    max: 100, // 限制每个IP 15分钟内最多100个请求
    message: {
        success: false,
        error: 'TooManyRequests',
        message: '请求过于频繁，请稍后再试'
    }
});

// API限流配置
const apiLimiter = rateLimit({
    store: new RedisStore({
        client: redis,
        prefix: 'api:'
    }),
    windowMs: 60 * 1000, // 1分钟
    max: 60, // 限制每个IP 1分钟内最多60个请求
    message: {
        success: false,
        error: 'ApiRateLimitExceeded',
        message: 'API请求过于频繁，请稍后再试'
    }
});

// 认证限流配置
const authLimiter = rateLimit({
    store: new RedisStore({
        client: redis,
        prefix: 'auth:'
    }),
    windowMs: 60 * 60 * 1000, // 1小时
    max: 5, // 限制每个IP 1小时内最多5次登录尝试
    message: {
        success: false,
        error: 'AuthRateLimitExceeded',
        message: '登录尝试次数过多，请稍后再试'
    }
});

// 文件上传限流配置
const uploadLimiter = rateLimit({
    store: new RedisStore({
        client: redis,
        prefix: 'upload:'
    }),
    windowMs: 60 * 60 * 1000, // 1小时
    max: 10, // 限制每个IP 1小时内最多10次上传
    message: {
        success: false,
        error: 'UploadRateLimitExceeded',
        message: '上传次数过多，请稍后再试'
    }
});

// 动态限流配置生成器
const createDynamicLimiter = (options = {}) => {
    const {
        windowMs = 15 * 60 * 1000,
        max = 100,
        prefix = 'dynamic:',
        message = '请求过于频繁，请稍后再试'
    } = options;

    return rateLimit({
        store: new RedisStore({
            client: redis,
            prefix: prefix
        }),
        windowMs,
        max,
        message: {
            success: false,
            error: 'DynamicRateLimitExceeded',
            message
        }
    });
};

module.exports = {
    defaultLimiter,
    apiLimiter,
    authLimiter,
    uploadLimiter,
    createDynamicLimiter
}; 