/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 日志记录器基于 winston 模块封装
 * ✅ 支持六类日志：通用、请求、错误、性能、安全、数据库
 * ✅ 各日志均按模块生成独立 log 文件，支持大小轮转
 * ✅ 各日志中间件封装清晰，支持链式调用
 * ✅ 推荐后续接入 Graylog / ELK / Loki 等集中日志平台
 */

const winston = require('winston');
const { format } = winston;
const path = require('path');
const os = require('os');

/**
 * 日志中间件集合
 * 提供日志记录功能，包括：
 * - 请求日志记录
 * - 错误日志记录
 * - 性能日志记录
 * - 安全日志记录
 * - 数据库操作日志记录
 */

// 自定义日志格式
const customFormat = format.combine(
    format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
    format.errors({ stack: true }),
    format.splat(),
    format.json()
);

// 创建日志目录
const logDir = path.join(__dirname, '../../../logs');
const fs = require('fs');
if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
}

/**
 * 创建日志记录器
 * @param {string} category - 日志类型（如 'request'、'error'）
 * @param {string} filename - 日志文件名（不含扩展名）
 * @returns {Logger} winston 日志记录器实例
 */
const createLogger = (category, filename) => {
    return winston.createLogger({
        level: process.env.LOG_LEVEL || 'info',
        format: customFormat,
        defaultMeta: {
            service: 'ai-nutrition-restaurant',
            environment: process.env.NODE_ENV || 'development',
            hostname: os.hostname(),
            category
        },
        transports: [
            // 文件传输
            new winston.transports.File({
                filename: path.join(logDir, `${filename}.log`),
                maxsize: 5242880, // 5MB
                maxFiles: 5,
                tailable: true
            }),
            // 错误日志单独存储
            new winston.transports.File({
                filename: path.join(logDir, `${filename}-error.log`),
                level: 'error',
                maxsize: 5242880,
                maxFiles: 5,
                tailable: true
            })
        ]
    });
};

// 创建不同类别的日志记录器
const logger = createLogger('general', 'app');
const requestLogger = createLogger('request', 'request');
const errorLogger = createLogger('error', 'error');
const performanceLogger = createLogger('performance', 'performance');
const securityLogger = createLogger('security', 'security');
const databaseLogger = createLogger('database', 'database');

/**
 * 请求日志中间件
 * - 记录请求方法、路径、参数、响应状态、耗时等
 */
const requestLogMiddleware = (req, res, next) => {
    const start = Date.now();
    
    // 记录请求信息
    requestLogger.info('Incoming request', {
        method: req.method,
        url: req.url,
        query: req.query,
        body: req.body,
        headers: req.headers,
        ip: req.ip,
        userAgent: req.get('user-agent')
    });

    // 响应完成时记录
    res.on('finish', () => {
        const duration = Date.now() - start;
        requestLogger.info('Request completed', {
            method: req.method,
            url: req.url,
            statusCode: res.statusCode,
            duration,
            responseSize: res.get('content-length')
        });
    });

    next();
};

/**
 * 性能日志中间件
 * - 记录超过阈值的慢请求
 */
const performanceLogMiddleware = (req, res, next) => {
    const start = Date.now();
    
    res.on('finish', () => {
        const duration = Date.now() - start;
        if (duration > 1000) { // 记录超过1秒的请求
            performanceLogger.warn('Slow request detected', {
                method: req.method,
                url: req.url,
                duration,
                threshold: 1000
            });
        }
    });

    next();
};

/**
 * 安全日志中间件
 * - 记录可疑请求头信息
 */
const securityLogMiddleware = (req, res, next) => {
    // 记录可疑的请求头
    const suspiciousHeaders = ['x-forwarded-for', 'x-real-ip', 'x-client-ip'];
    const suspiciousValues = req.headers[suspiciousHeaders.find(h => req.headers[h])];
    
    if (suspiciousValues) {
        securityLogger.warn('Suspicious headers detected', {
            method: req.method,
            url: req.url,
            headers: suspiciousHeaders.filter(h => req.headers[h]),
            ip: req.ip
        });
    }

    next();
};

/**
 * 数据库日志中间件
 * - 记录超过阈值的慢数据库操作
 */
const databaseLogMiddleware = (req, res, next) => {
    const start = Date.now();
    
    res.on('finish', () => {
        const duration = Date.now() - start;
        if (duration > 500) { // 记录超过500ms的数据库操作
            databaseLogger.warn('Slow database operation detected', {
                method: req.method,
                url: req.url,
                duration,
                threshold: 500
            });
        }
    });

    next();
};

/**
 * 错误日志中间件
 * - 记录错误信息及请求上下文
 */
const errorLogMiddleware = (err, req, res, next) => {
    errorLogger.error('Error occurred', {
        error: {
            message: err.message,
            stack: err.stack,
            code: err.code,
            details: err.details
        },
        request: {
            method: req.method,
            url: req.url,
            query: req.query,
            body: req.body,
            headers: req.headers
        }
    });

    next(err);
};

// 导出日志工具
module.exports = {
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
}; 