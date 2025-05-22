/**
 * ✅ 模块名：rateLimitMiddleware.js
 * ✅ 命名风格统一：camelCase
 * ✅ 功能概述：
 *   - 提供不同类型的限流中间件，包括：
 *     - defaultLimiter：全局通用限流器
 *     - apiLimiter：API接口专属限流器
 *     - authLimiter：认证操作限流器（登录等）
 *     - uploadLimiter：上传接口限流器
 *     - createDynamicLimiter：自定义限流器生成器
 *     - dynamicRateLimit：支持用户/IP/异常行为组合限流
 *     - resourceRateLimit：细粒度资源级别限流器
 * ✅ 使用 RedisStore 管理共享状态，支持分布式限流
 * ✅ 高级特性：
 *   - 支持异常分数与访问轨迹自动封禁
 *   - 支持 header 反馈限流状态
 * ✅ 推荐 Future 优化：
 *   - 将限流策略配置抽离为外部 JSON 配置项
 *   - 支持基于 path + method 的更细粒度策略
 */

const rateLimit = require('express-rate-limit');
const RedisStore = require('rate-limit-redis');
const Redis = require('ioredis');
const redis = require('redis');
const { promisify } = require('util');
const logger = require('../../utils/logger/winstonLogger.js');
const { getAccessTrackingService } = require('./accessTrackingMiddleware');

/**
 * defaultLimiter
 * - 通用限流策略（15分钟内最多100次）
 */
// Redis连接配置
const redisClient = new Redis({
    host: process.env.REDIS_HOST || 'localhost',
    port: process.env.REDIS_PORT || 6379,
    password: process.env.REDIS_PASSWORD,
    keyPrefix: 'rate-limit:'
});

// 通用限流配置
const defaultLimiter = rateLimit({
    store: new RedisStore({
        client: redisClient,
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
        client: redisClient,
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

/**
 * authLimiter
 * - 限制登录等敏感操作的请求频率（1小时最多5次）
 */
// 认证限流配置
const authLimiter = rateLimit({
    store: new RedisStore({
        client: redisClient,
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

/**
 * uploadLimiter
 * - 限制上传行为的频率（1小时最多10次）
 */
// 文件上传限流配置
const uploadLimiter = rateLimit({
    store: new RedisStore({
        client: redisClient,
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

    // TODO: 支持按 user-agent / referer / method 设置不同限流器

    return rateLimit({
        store: new RedisStore({
            client: redisClient,
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

// Redis客户端
let redisCommands = null;

/**
 * Redis初始化封装
 * - 提供基础 Redis 操作能力（get/set/incr 等）
 * - 用于动态限流逻辑中读写访问计数器
 */
/**
 * 初始化Redis客户端
 * @param {String} redisUrl - Redis连接URL
 * @returns {Promise<Object>} Redis命令对象
 */
const initRedis = async (redisUrl = process.env.REDIS_URL || 'redis://localhost:6379') => {
  if (redisCommands) {
    return redisCommands;
  }
  
  logger.debug(`正在连接Redis: ${redisUrl}`);
  
  try {
    // 创建Redis客户端
    const redisClient = redis.createClient({
      url: redisUrl
    });
    
    // 包装Redis命令为Promise
    redisCommands = {
      get: promisify(redisClient.get).bind(redisClient),
      set: promisify(redisClient.set).bind(redisClient),
      setEx: promisify(redisClient.setex).bind(redisClient),
      incr: promisify(redisClient.incr).bind(redisClient),
      expire: promisify(redisClient.expire).bind(redisClient),
      del: promisify(redisClient.del).bind(redisClient)
    };
    
    // 设置错误处理
    redisClient.on('error', (error) => {
      logger.error('Redis连接错误:', error);
    });
    
    logger.info('Redis客户端创建成功');
    return redisCommands;
  } catch (error) {
    logger.error('连接Redis失败:', error);
    throw error;
  }
};

/**
 * dynamicRateLimit
 * - 综合评估用户身份/IP/异常分数动态调整限流级别
 * - 支持接入 accessTrackingService 进行自动封禁
 */
/**
 * 动态限流中间件
 * @param {Object} options - 限流配置选项
 * @returns {Function} Express中间件函数
 */
const dynamicRateLimit = (options = {}) => {
  const defaultOptions = {
    // 窗口大小（秒）
    windowSize: parseInt(process.env.RATE_LIMIT_WINDOW || '60', 10),
    // 默认限制
    defaultLimit: parseInt(process.env.RATE_LIMIT_DEFAULT || '100', 10),
    // IP限制
    ipLimit: parseInt(process.env.RATE_LIMIT_IP || '60', 10),
    // 用户限制
    userLimit: parseInt(process.env.RATE_LIMIT_USER || '120', 10),
    // 匿名用户限制
    anonymousLimit: parseInt(process.env.RATE_LIMIT_ANONYMOUS || '30', 10),
    // 异常用户限制（有异常分数的用户）
    anomalyUserLimit: parseInt(process.env.RATE_LIMIT_ANOMALY || '20', 10),
    // Redis键前缀
    keyPrefix: process.env.RATE_LIMIT_KEY_PREFIX || 'ratelimit:',
    // 是否使用访问轨迹服务
    useAccessTracking: true,
    // 异常分数阈值
    anomalyThreshold: parseInt(process.env.RATE_LIMIT_ANOMALY_THRESHOLD || '30', 10),
    // 封禁IP的请求阈值
    banThreshold: parseInt(process.env.RATE_LIMIT_BAN_THRESHOLD || '150', 10),
    // 封禁时长（秒）
    banDuration: parseInt(process.env.RATE_LIMIT_BAN_DURATION || '3600', 10)
  };
  
  // 合并选项
  const config = { ...defaultOptions, ...options };
  
  // 初始化Redis
  const redisPromise = initRedis(options.redisUrl);
  
  // 获取访问轨迹服务
  const accessTrackingService = config.useAccessTracking ? getAccessTrackingService() : null;
  
  return async (req, res, next) => {
    let redis;
    
    try {
      redis = await redisPromise;
    } catch (error) {
      logger.error('获取Redis客户端失败，跳过限流:', error);
      return next();
    }
    
    // 获取IP地址
    const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    
    // 获取用户ID（如果已认证）
    const userId = req.user ? req.user.id : null;
    
    // 检查是否需要使用访问轨迹服务
    let anomalyScore = 0;
    if (config.useAccessTracking && accessTrackingService) {
      try {
        // 检查IP是否被封禁
        const banInfo = await accessTrackingService.checkIPBan(ip);
        if (banInfo) {
          logger.info(`拒绝访问: IP ${ip} 已被封禁`, banInfo);
          return res.status(429).json({
            success: false,
            error: 'rate_limit_exceeded',
            message: '您的访问已被暂时限制，请稍后再试',
            expiresAt: banInfo.expiresAt
          });
        }
        
        // 如果有用户ID，获取用户的异常分数
        if (userId) {
          // 查询最近的访问记录以获取异常分数
          const recentTracks = await accessTrackingService.getUserAccessHistory(userId, { limit: 5 });
          
          if (recentTracks && recentTracks.length > 0) {
            // 计算最近记录的平均异常分数
            anomalyScore = recentTracks.reduce((sum, track) => sum + (track.anomalyScore || 0), 0) / recentTracks.length;
          }
        }
      } catch (error) {
        logger.error('获取访问轨迹信息失败:', error);
      }
    }
    
    // 确定适用的限制
    let limit = config.defaultLimit;
    
    if (anomalyScore >= config.anomalyThreshold) {
      // 有异常行为的用户使用严格限制
      limit = config.anomalyUserLimit;
      logger.debug(`用户 ${userId} 异常分数 ${anomalyScore}，应用严格限制: ${limit}`);
    } else if (userId) {
      // 已认证用户
      limit = config.userLimit;
    } else {
      // 匿名用户
      limit = config.anonymousLimit;
    }
    
    // 构建限流键
    const now = Math.floor(Date.now() / 1000);
    const windowKey = Math.floor(now / config.windowSize) * config.windowSize;
    
    // IP限流键
    const ipKey = `${config.keyPrefix}ip:${ip}:${windowKey}`;
    
    // 用户限流键（如果有用户ID）
    const userKey = userId ? `${config.keyPrefix}user:${userId}:${windowKey}` : null;
    
    try {
      // 增加IP计数器
      const ipCount = await redis.incr(ipKey);
      await redis.expire(ipKey, config.windowSize * 2); // 2倍窗口时间，确保过期
      
      // 获取用户计数器（如果有用户ID）
      let userCount = 0;
      if (userKey) {
        userCount = await redis.incr(userKey);
        await redis.expire(userKey, config.windowSize * 2);
      }
      
      // 检查是否超过限制
      const ipLimitExceeded = ipCount > config.ipLimit;
      const userLimitExceeded = userKey && userCount > limit;
      
      // 如果超过限制，返回429响应
      if (ipLimitExceeded || userLimitExceeded) {
        logger.info(`限流触发: IP=${ip}, 用户=${userId}, IP计数=${ipCount}, 用户计数=${userCount}, 限制=${limit}`);
        
        // 检查是否需要封禁IP（严重超限）
        if (config.useAccessTracking && accessTrackingService && ipCount > config.banThreshold) {
          try {
            // 自动封禁IP
            await accessTrackingService.banIP(
              ip,
              config.banDuration,
              `自动封禁: 速率限制严重超限 (${ipCount}/${config.banThreshold})`
            );
            
            logger.warn(`已自动封禁IP ${ip}，请求计数: ${ipCount}/${config.banThreshold}`);
          } catch (error) {
            logger.error('自动封禁IP失败:', error);
          }
        }
        
        // 设置响应头
        res.set('X-RateLimit-Limit', limit);
        res.set('X-RateLimit-Remaining', 0);
        res.set('X-RateLimit-Reset', windowKey + config.windowSize);
        
        return res.status(429).json({
          success: false,
          error: 'rate_limit_exceeded',
          message: '请求频率过高，请稍后再试',
          details: {
            retryAfter: windowKey + config.windowSize - now
          }
        });
      }
      
      // 设置响应头
      res.set('X-RateLimit-Limit', limit);
      res.set('X-RateLimit-Remaining', limit - (userKey ? userCount : ipCount));
      res.set('X-RateLimit-Reset', windowKey + config.windowSize);
      
      next();
    } catch (error) {
      logger.error('应用限流失败:', error);
      next(); // 出错时继续处理请求
    }
  };
};

/**
 * resourceRateLimit
 * - 针对特定资源ID的访问限流（如 forumPost、recommendation 等）
 */
/**
 * 针对特定资源的限流中间件
 * @param {String} resourceType - 资源类型
 * @param {Object} options - 限流配置选项
 * @returns {Function} Express中间件函数
 */
const resourceRateLimit = (resourceType, options = {}) => {
  const defaultOptions = {
    // 窗口大小（秒）
    windowSize: parseInt(process.env.RESOURCE_RATE_LIMIT_WINDOW || '300', 10),
    // 资源访问限制
    resourceLimit: parseInt(process.env.RESOURCE_RATE_LIMIT || '60', 10),
    // Redis键前缀
    keyPrefix: process.env.RATE_LIMIT_KEY_PREFIX || 'ratelimit:',
  };
  
  // 合并选项
  const config = { ...defaultOptions, ...options };
  
  // 初始化Redis
  const redisPromise = initRedis(options.redisUrl);
  
  return async (req, res, next) => {
    let redis;
    
    try {
      redis = await redisPromise;
    } catch (error) {
      logger.error('获取Redis客户端失败，跳过资源限流:', error);
      return next();
    }
    
    // 获取IP地址
    const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    
    // 获取用户ID（如果已认证）
    const userId = req.user ? req.user.id : null;
    
    // 获取资源ID
    const resourceId = req.resourceId || req.params.id || req.query.id;
    
    // 如果没有资源ID，跳过资源限流
    if (!resourceId) {
      return next();
    }
    
    // 构建限流键
    const now = Math.floor(Date.now() / 1000);
    const windowKey = Math.floor(now / config.windowSize) * config.windowSize;
    
    // 用户-资源限流键
    const resourceKey = userId
      ? `${config.keyPrefix}${resourceType}:${resourceId}:user:${userId}:${windowKey}`
      : `${config.keyPrefix}${resourceType}:${resourceId}:ip:${ip}:${windowKey}`;
    
    try {
      // 增加资源访问计数器
      const resourceCount = await redis.incr(resourceKey);
      await redis.expire(resourceKey, config.windowSize * 2); // 2倍窗口时间，确保过期
      
      // 检查是否超过资源访问限制
      if (resourceCount > config.resourceLimit) {
        logger.info(`资源限流触发: 类型=${resourceType}, ID=${resourceId}, 用户=${userId || ip}, 计数=${resourceCount}, 限制=${config.resourceLimit}`);
        
        // 设置响应头
        res.set('X-RateLimit-Limit', config.resourceLimit);
        res.set('X-RateLimit-Remaining', 0);
        res.set('X-RateLimit-Reset', windowKey + config.windowSize);
        
        return res.status(429).json({
          success: false,
          error: 'resource_rate_limit_exceeded',
          message: `对资源 ${resourceType} 的访问频率过高，请稍后再试`,
          details: {
            retryAfter: windowKey + config.windowSize - now
          }
        });
      }
      
      // 设置响应头
      res.set('X-RateLimit-Limit', config.resourceLimit);
      res.set('X-RateLimit-Remaining', config.resourceLimit - resourceCount);
      res.set('X-RateLimit-Reset', windowKey + config.windowSize);
      
      next();
    } catch (error) {
      logger.error('应用资源限流失败:', error);
      next(); // 出错时继续处理请求
    }
  };
};

module.exports = {
    defaultLimiter,
    apiLimiter,
    authLimiter,
    uploadLimiter,
    createDynamicLimiter,
    dynamicRateLimit,
    resourceRateLimit
};