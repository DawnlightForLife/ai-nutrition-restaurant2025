const express = require('express');
const cors = require('cors');
const { connectDB } = require('./models');
const userRoutes = require('./routes/userRoutes');
const nutritionProfileRoutes = require('./routes/nutritionProfileRoutes');
const dishRoutes = require('./routes/dishRoutes');
const storeRoutes = require('./routes/storeRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');
const authRoutes = require('./routes/authRoutes');
const adminRoutes = require('./routes/adminRoutes');
const schemaAdminRoutes = require('./routes/schemaAdminRoutes');
const authMiddleware = require('./middleware/auth/authMiddleware');
const { performanceMonitor, resourceMonitor } = require('./middleware/performance/performanceMiddleware');
const {
    queryMonitor,
    queryOptimizer,
    queryCache,
    batchOptimizer,
    queryMonitorInstance,
    queryCacheInstance,
    batchOptimizerInstance
} = require('./middleware/performance/dbOptimizationMiddleware');
const {
    createDynamicLimiter,
    roleBasedLimiter,
    pathBasedLimiter,
    ipBasedLimiter,
    combinedLimiter
} = require('./middleware/security/advancedRateLimitMiddleware');
const {
    securityHeaders,
    xssProtection,
    mongoSanitization,
    parameterPollution,
    filterSensitiveData,
    validateOrigin
} = require('./middleware/security/securityMiddleware');
const {
    advancedPerformanceMonitor,
    performanceReport,
    resetMetrics,
    metrics
} = require('./middleware/performance/advancedPerformanceMiddleware');
const {
    logger,
    requestLogger,
    errorLogger,
    performanceLogger,
    securityLogger,
    databaseLogger,
    requestLogMiddleware,
    performanceLogMiddleware,
    securityLogMiddleware,
    databaseLogMiddleware,
    errorLogMiddleware
} = require('./middleware/core/loggingMiddleware');
const {
    requestSignatureVerification,
    requestFrequencyLimit,
    sqlInjectionProtection,
    enhancedXSSProtection,
    sensitiveDataEncryption
} = require('./middleware/security/advancedSecurityMiddleware');
const {
    AppError,
    ErrorTypes,
    errorHandler,
    notFoundHandler,
    asyncHandler,
    isErrorType
} = require('./middleware/core/errorHandlingMiddleware');
const {
    cacheMiddleware,
    clearCacheMiddleware,
    cacheStatsMiddleware,
    cacheManager
} = require('./middleware/performance/cacheOptimizationMiddleware');
const {
    validateRequest,
    validateBody,
    validateQuery,
    validateParams,
    validateHeaders,
    validateFileUpload,
    commonRules,
    customRules
} = require('./middleware/validation/requestValidationMiddleware');
const helmet = require('helmet');
const { defaultLimiter } = require('./middleware/security/rateLimitMiddleware');
const { accessTrackingMiddleware, initAccessTrackingService } = require('./middleware/access/accessTrackingMiddleware');
const { dynamicRateLimit } = require('./middleware/security/rateLimitMiddleware');
const mongoose = require('mongoose');
const config = require('./config');
const morgan = require('morgan');
const compression = require('compression');
const nutritionMetricsRoutes = require('./routes/nutrition/nutritionMetricsRoutes');
const sanitizeResponse = require('./utils/sanitizeResponse');

const app = express();
const API_PREFIX = '/api';

// 设置环境变量(如果未定义)
if (!process.env.NODE_ENV) {
  process.env.NODE_ENV = 'development';
  console.log('环境变量NODE_ENV设置为:', process.env.NODE_ENV);
}

// 性能监控
app.use(performanceMonitor({ threshold: 1000, logLevel: 'warn' }));
app.use(resourceMonitor({ interval: 60000, threshold: 0.9 }));
app.use(advancedPerformanceMonitor({
    interval: 30000, // 30秒更新一次资源统计
    logLevel: process.env.LOG_LEVEL || 'info',
    threshold: {
        responseTime: 1000,
        cpuUsage: 80,
        memoryUsage: 85
    }
}));

// 性能报告端点
app.use(performanceReport);
app.use(resetMetrics);

// 缓存统计端点
app.use(cacheStatsMiddleware);

// 数据库查询监控
app.use(queryMonitor());

// 日志中间件配置
app.use(requestLogMiddleware);
app.use(performanceLogMiddleware);
app.use(securityLogMiddleware);
app.use(databaseLogMiddleware);

// 应用敏感数据过滤中间件
app.use(sanitizeResponse);

// 定期记录系统状态
setInterval(() => {
    const systemStatus = {
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        cpu: process.cpuUsage(),
        activeHandles: process._getActiveHandles().length
    };
    
    logger.info('System status:', systemStatus);
}, 300000); // 每5分钟记录一次

// 定期记录性能指标
setInterval(() => {
    const performanceMetrics = {
        requests: {
            total: metrics.getTotalRequests(),
            errors: metrics.getErrorCount(),
            averageResponseTime: metrics.getAverageResponseTime()
        },
        resources: {
            cpu: metrics.getCPUUsage(),
            memory: metrics.getMemoryUsage()
        },
        database: {
            queries: metrics.getDatabaseQueries(),
            slowQueries: metrics.getSlowQueries()
        },
        cache: {
            hits: metrics.getCacheHits(),
            misses: metrics.getCacheMisses()
        }
    };
    
    performanceLogger.info('Performance metrics:', performanceMetrics);
}, 60000); // 每分钟记录一次

// 定期记录安全事件
setInterval(() => {
    const securityMetrics = {
        failedLogins: metrics.getFailedLogins(),
        blockedIPs: metrics.getBlockedIPs(),
        suspiciousRequests: metrics.getSuspiciousRequests()
    };
    
    securityLogger.info('Security metrics:', securityMetrics);
}, 300000); // 每5分钟记录一次

// 定期记录数据库状态
setInterval(() => {
    const dbStatus = {
        connections: mongoose.connection.readyState,
        collections: Object.keys(mongoose.connection.collections),
        indexes: Object.keys(mongoose.connection.db.indexes())
    };
    
    databaseLogger.info('Database status:', dbStatus);
}, 300000); // 每5分钟记录一次

// 应用安全中间件
app.use(helmet());
app.use(cors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-Signature', 'X-Request-Timestamp'],
    credentials: true,
    maxAge: 86400 // 24小时
}));
app.use(defaultLimiter);

// 初始化并应用访问轨迹追踪
if (process.env.ACCESS_TRACKING_ENABLED === 'true') {
  // 异步初始化访问轨迹服务
  initAccessTrackingService()
    .then(() => {
      logger.info('访问轨迹追踪服务初始化成功');
    })
    .catch(error => {
      logger.error('访问轨迹追踪服务初始化失败:', error);
    });
  
  // 应用访问轨迹中间件
  app.use(accessTrackingMiddleware());
  
  // 应用动态限流中间件
  app.use(dynamicRateLimit({
    useAccessTracking: true
  }));
  
  logger.info('已启用访问轨迹追踪和动态限流');
}

// 高级限流配置
const pathLimits = {
    '/api/auth/login': { windowMs: 15 * 60 * 1000, max: 5 }, // 登录接口限制
    '/api/users': { windowMs: 60 * 1000, max: 30 }, // 用户接口限制
    '/api/dishes': { windowMs: 60 * 1000, max: 100 }, // 菜品接口限制
    '/api/stores': { windowMs: 60 * 1000, max: 50 }, // 餐厅接口限制
    '/api/nutrition-profiles': { windowMs: 60 * 1000, max: 20 }, // 营养档案接口限制
    '*': { windowMs: 15 * 60 * 1000, max: 100 } // 默认限制
};

// 组合限流中间件
app.use(combinedLimiter([
    ipBasedLimiter({ // IP基础限流
        windowMs: 60 * 60 * 1000, // 1小时
        max: 1000,
        blockDuration: 24 * 60 * 60 * 1000 // 24小时封禁
    }),
    pathBasedLimiter(pathLimits), // 路径限流
    roleBasedLimiter() // 角色限流
]));

// 请求体解析配置
app.use(express.json({ 
    limit: '10mb',
    verify: (req, res, buf, encoding) => {
        try {
            JSON.parse(buf);
        } catch(e) {
            res.status(400).json({ 
                success: false, 
                error: 'InvalidJSON',
                message: '无效的JSON格式' 
            });
        }
    }
}));
app.use(express.urlencoded({ 
    extended: true, 
    limit: '10mb',
    parameterLimit: 1000
}));

// 请求日志中间件
app.use(requestLogger);

// 健康检查端点
app.get('/', asyncHandler(async (req, res) => {
    const healthCheck = {
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        environment: process.env.NODE_ENV || 'development',
        services: {
            database: await checkDatabaseHealth(),
            cache: await checkCacheHealth()
        }
    };

    if (!healthCheck.services.database || !healthCheck.services.cache) {
        throw new AppError(
            'Service health check failed',
            503,
            ErrorTypes.INTERNAL_ERROR,
            healthCheck.services
        );
    }

    res.json(healthCheck);
}));

// 数据库健康检查
const checkDatabaseHealth = async () => {
    try {
        const db = mongoose.connection;
        return db.readyState === 1;
    } catch (error) {
        logger.error('Database health check failed:', error);
        return false;
    }
};

// 缓存健康检查
const checkCacheHealth = async () => {
    try {
        await redis.ping();
        return true;
    } catch (error) {
        logger.error('Cache health check failed:', error);
        return false;
    }
};

// 初始化数据库连接
mongoose.connect(config.mongoURI, config.options)
  .then(() => {
    logger.info('成功连接到MongoDB数据库');
    
    // 初始化查询监控
    queryMonitor.initQueryMonitor();

    // 当数据库连接成功时验证模型
    mongoose.connection.once('open', async () => {
      logger.info('数据库连接成功，验证核心模型...');
      
      // 确保核心模型可以作为构造函数使用
      try {
        // 检查User模型
        const User = require('./models/user/userModel');
        if (typeof User !== 'function') {
          logger.error('警告: User模型不是构造函数，尝试从mongoose获取');
          try {
            const UserFromMongoose = mongoose.model('User');
            if (typeof UserFromMongoose === 'function') {
              logger.info('成功: 从mongoose获取了User构造函数');
              // 全局注册
              global._cachedUserModel = UserFromMongoose;
            }
          } catch (err) {
            logger.error('从mongoose获取User模型失败:', err.message);
          }
        } else {
          logger.info('User模型验证成功，可以作为构造函数使用');
          // 测试创建实例
          try {
            const testUser = new User({ phone: 'test-validate-only' });
            logger.info('测试创建User实例成功');
          } catch (err) {
            logger.error('测试创建User实例失败:', err.message);
          }
        }
      } catch (err) {
        logger.error('验证User模型时出错:', err);
      }
    });
  })
  .catch(err => {
    logger.error('连接数据库失败:', err);
    process.exit(1);
  });

// 注册API路由
app.use('/api/users', require('./routes/api/users'));
app.use('/api/nutrition-profiles', require('./routes/api/nutritionProfiles'));
app.use('/api/dishes', require('./routes/api/dishes'));
app.use('/api/stores', require('./routes/api/stores'));
app.use('/api/recommendations', require('./routes/api/recommendations'));
app.use('/api/auth', require('./routes/user/authRoutes'));
app.use('/api/admin', require('./routes/api/admin'));
app.use('/api/schema', require('./routes/api/schema'));
app.use('/api/access-tracking', require('./routes/api/accessTracking'));
app.use('/api/nutrition/nutrition-metrics', nutritionMetricsRoutes);

// 添加ping接口，用于健康检查
app.get(`${API_PREFIX}/ping`, (req, res) => {
    res.status(200).json({
        success: true,
        message: 'pong',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// 旧版接口健康检查
app.get('/ping', (req, res) => {
    res.status(200).json({
        success: true,
        message: 'pong',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// 确保非API路由也返回JSON (如/favicon.ico等浏览器自动请求)
app.use('*', (req, res, next) => {
    // 如果请求不是API前缀开头，并且不是根路径健康检查，也不是旧版推荐路径
    if (!req.originalUrl.startsWith(API_PREFIX) && 
        req.originalUrl !== '/' && 
        req.originalUrl !== '/ping' &&
        !req.originalUrl.startsWith('/recommendation')) {
        logger.warn(`非API请求: ${req.originalUrl}`);
        return res.status(404).json({
            success: false,
            error: {
                code: 'RESOURCE_NOT_FOUND',
                message: `接口不存在: ${req.originalUrl}`
            },
            timestamp: new Date().toISOString()
        });
    }
    next();
});

// 404处理中间件
app.use(notFoundHandler);

// 错误处理中间件
app.use(errorLogMiddleware);
app.use(errorHandler);

// 确保任何遗漏的错误也返回JSON格式
app.use((err, req, res, next) => {
    console.error('[全局错误处理-最终捕获]', err.stack);
    // 如果响应已经发送，不做处理
    if (res.headersSent) {
        return next(err);
    }
    
    res.status(err.status || 500).json({
        success: false,
        message: err.message || '服务器内部错误',
        code: err.code || 'INTERNAL_ERROR',
        timestamp: new Date().toISOString()
    });
});

// 启动服务器
const PORT = process.env.PORT || 3000;
const server = http.createServer(app);

// 应用初始化与启动
(async () => {
  try {
    // 连接数据库
    await connectDB();
    console.log('MongoDB连接成功');
    
    // 初始化缓存服务
    await redis.ping();
    console.log('缓存服务初始化成功');
    
    // 初始化分片同步任务
    const userService = require('./services/userService');
    userService.setupShardMigrationTask();
    console.log('分片同步任务已启动');
    
    // 启动服务器
    server.listen(PORT, () => {
      console.log(`服务器运行在端口: ${PORT}`);
    });
  } catch (error) {
    console.error('服务启动错误:', error);
    process.exit(1);
  }
})(); 