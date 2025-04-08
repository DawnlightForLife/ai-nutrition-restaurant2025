const express = require('express');
const cors = require('cors');
const { connectDB } = require('./models');
const userRoutes = require('./routes/userRoutes');
const nutritionProfileRoutes = require('./routes/nutritionProfileRoutes');
const dishRoutes = require('./routes/dishRoutes');
const storeRoutes = require('./routes/storeRoutes');
const recommendationRoutes = require('./routes/recommendationRoutes');
const authRoutes = require('./routes/authRoutes');
const healthDataRoutes = require('./routes/healthDataRoutes');
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

const app = express();
const API_PREFIX = '/api';

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

// 安全中间件
app.use(securityHeaders);
app.use(xssProtection);
app.use(mongoSanitization);
app.use(parameterPollution);
app.use(filterSensitiveData);
app.use(validateOrigin);
app.use(requestSignatureVerification);
app.use(requestFrequencyLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    message: '请求过于频繁，请稍后再试'
}));
app.use(sqlInjectionProtection);
app.use(enhancedXSSProtection);

// 敏感数据加密
app.use(sensitiveDataEncryption([
    'password',
    'creditCard',
    'ssn',
    'phone',
    'email'
]));

// 基础中间件配置
app.use(cors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-Signature', 'X-Request-Timestamp'],
    credentials: true,
    maxAge: 86400 // 24小时
}));

// 高级限流配置
const pathLimits = {
    '/api/auth/login': { windowMs: 15 * 60 * 1000, max: 5 }, // 登录接口限制
    '/api/auth/register': { windowMs: 60 * 60 * 1000, max: 3 }, // 注册接口限制
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
connectDB().catch(err => {
    logger.error('Database connection failed:', err);
    process.exit(1);
});

// API路由注册 - 按照资源依赖顺序排列
const routes = [
    { 
        path: '/auth', 
        router: authRoutes,
        middleware: [
            securityHeaders,
            xssProtection,
            mongoSanitization,
            parameterPollution,
            filterSensitiveData,
            validateOrigin
        ]
    },
    { 
        path: '/dishes', 
        router: dishRoutes, 
        middleware: [
            queryOptimizer({
                maxLimit: 50,
                defaultLimit: 10,
                allowedFields: ['name', 'price', 'category', 'createdAt', 'updatedAt'],
                defaultSort: { createdAt: -1 },
                maxDepth: 3
            }),
            validateQuery(customRules.search),
            cacheMiddleware({
                ttl: 300, // 5分钟缓存
                prefix: 'dishes:',
                staleWhileRevalidate: true,
                compression: true
            }),
            clearCacheMiddleware(['dishes:*']),
            batchOptimizer({
                maxBatchSize: 1000,
                chunkSize: 100
            })
        ] 
    },
    { 
        path: '/stores', 
        router: storeRoutes, 
        middleware: [
            queryOptimizer({
                maxLimit: 30,
                defaultLimit: 10,
                allowedFields: ['name', 'address', 'rating', 'createdAt', 'updatedAt'],
                defaultSort: { rating: -1 },
                maxDepth: 3
            }),
            validateQuery(customRules.search),
            cacheMiddleware({
                ttl: 300,
                prefix: 'stores:',
                staleWhileRevalidate: true,
                compression: true
            }),
            clearCacheMiddleware(['stores:*']),
            batchOptimizer({
                maxBatchSize: 500,
                chunkSize: 50
            })
        ] 
    },
    { 
        path: '/users', 
        router: userRoutes, 
        middleware: [
            queryOptimizer({
                maxLimit: 20,
                defaultLimit: 10,
                allowedFields: ['username', 'email', 'role', 'createdAt', 'updatedAt'],
                defaultSort: { createdAt: -1 },
                maxDepth: 2
            }),
            validateQuery(customRules.search),
            validateHeaders({
                authorization: commonRules.string.required()
            }),
            cacheMiddleware({
                ttl: 60, // 1分钟缓存
                prefix: 'users:',
                staleWhileRevalidate: false,
                compression: true
            }),
            clearCacheMiddleware(['users:*']),
            batchOptimizer({
                maxBatchSize: 200,
                chunkSize: 20
            })
        ] 
    },
    { 
        path: '/nutrition-profiles', 
        router: nutritionProfileRoutes,
        middleware: [
            authMiddleware,
            queryOptimizer({
                maxLimit: 10,
                defaultLimit: 5,
                allowedFields: ['userId', 'createdAt', 'updatedAt'],
                defaultSort: { createdAt: -1 },
                maxDepth: 2
            }),
            validateQuery(customRules.search),
            validateHeaders({
                authorization: commonRules.string.required(),
                'x-user-id': commonRules.string.required()
            }),
            cacheMiddleware({
                ttl: 60,
                prefix: 'nutrition:',
                staleWhileRevalidate: false,
                compression: true
            }),
            clearCacheMiddleware(['nutrition:*']),
            batchOptimizer({
                maxBatchSize: 100,
                chunkSize: 10
            })
        ]
    },
    { 
        path: '/recommendation', 
        router: recommendationRoutes,
        middleware: [
            authMiddleware,
            queryOptimizer({
                maxLimit: 20,
                defaultLimit: 10,
                allowedFields: ['profileId', 'userId', 'createdAt'],
                defaultSort: { createdAt: -1 },
                maxDepth: 2
            }),
            validateQuery({
                profileId: commonRules.string.optional(),
                userId: commonRules.string.optional()
            }),
            cacheMiddleware({
                ttl: 300, // 5分钟缓存
                prefix: 'recommendation:',
                staleWhileRevalidate: true,
                compression: true
            }),
            clearCacheMiddleware(['recommendation:*']),
        ]
    },
    { 
        path: '/health-data', 
        router: healthDataRoutes,
        middleware: [
            authMiddleware,
            queryOptimizer({
                maxLimit: 20,
                defaultLimit: 10,
                allowedFields: ['user_id', 'createdAt'],
                defaultSort: { createdAt: -1 },
                maxDepth: 2
            }),
            validateQuery({
                user_id: commonRules.string.optional()
            }),
            cacheMiddleware({
                ttl: 60, // 1分钟缓存
                prefix: 'healthData:',
                staleWhileRevalidate: true,
                compression: true
            }),
            clearCacheMiddleware(['healthData:*']),
        ]
    }
];

// 注册所有路由
routes.forEach(({ path, router, middleware }) => {
    logger.info(`Registering route: ${API_PREFIX}${path}`);
    app.use(`${API_PREFIX}${path}`, ...middleware, router);
    
    // 如果是推荐相关的路由，注册旧版兼容路径
    if (path === '/recommendation') {
        logger.info(`Registering legacy route: ${path}`);
        app.use(path, ...middleware, router);
    }
});

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