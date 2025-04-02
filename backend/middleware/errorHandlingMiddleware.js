const { logger } = require('./loggingMiddleware');

// 自定义错误类
class AppError extends Error {
    constructor(message, statusCode = 500, errorCode = 'INTERNAL_ERROR', details = null) {
        super(message);
        this.statusCode = statusCode;
        this.errorCode = errorCode;
        this.details = details;
        this.timestamp = new Date();
        this.stack = this.stack || new Error().stack;
    }
}

// 错误类型定义
const ErrorTypes = {
    VALIDATION_ERROR: 'VALIDATION_ERROR',
    AUTHENTICATION_ERROR: 'AUTHENTICATION_ERROR',
    AUTHORIZATION_ERROR: 'AUTHORIZATION_ERROR',
    NOT_FOUND_ERROR: 'NOT_FOUND_ERROR',
    CONFLICT_ERROR: 'CONFLICT_ERROR',
    RATE_LIMIT_ERROR: 'RATE_LIMIT_ERROR',
    DATABASE_ERROR: 'DATABASE_ERROR',
    CACHE_ERROR: 'CACHE_ERROR',
    EXTERNAL_SERVICE_ERROR: 'EXTERNAL_SERVICE_ERROR',
    INTERNAL_ERROR: 'INTERNAL_ERROR'
};

// 错误处理中间件
const errorHandler = (err, req, res, next) => {
    // 确保响应没有被发送
    if (res.headersSent) {
        return next(err);
    }

    // 记录错误日志
    logger.error('Error occurred:', {
        error: {
            message: err.message,
            stack: err.stack,
            code: err.errorCode,
            details: err.details
        },
        request: {
            method: req.method,
            path: req.path,
            query: req.query,
            body: req.body,
            headers: req.headers
        }
    });

    // 当前时间戳
    const timestamp = new Date().toISOString();

    // 如果是自定义错误
    if (err instanceof AppError) {
        return res.status(err.statusCode).json({
            success: false,
            error: {
                code: err.errorCode,
                message: err.message,
                details: err.details,
                timestamp: timestamp
            }
        });
    }

    // 处理Mongoose验证错误
    if (err.name === 'ValidationError') {
        const validationErrors = Object.values(err.errors).map(error => ({
            field: error.path,
            message: error.message
        }));

        return res.status(400).json({
            success: false,
            error: {
                code: ErrorTypes.VALIDATION_ERROR,
                message: 'Validation failed',
                details: validationErrors,
                timestamp: timestamp
            }
        });
    }

    // 处理Mongoose重复键错误
    if (err.code === 11000) {
        return res.status(409).json({
            success: false,
            error: {
                code: ErrorTypes.CONFLICT_ERROR,
                message: '数据冲突错误',
                details: err.keyValue,
                timestamp: timestamp
            }
        });
    }

    // 处理JWT错误
    if (err.name === 'JsonWebTokenError') {
        return res.status(401).json({
            success: false,
            error: {
                code: ErrorTypes.AUTHENTICATION_ERROR,
                message: '无效的令牌',
                details: err.message,
                timestamp: timestamp
            }
        });
    }

    // 处理数据库连接错误
    if (err.name === 'MongoError' && (err.code === 'ECONNREFUSED' || err.message.includes('connect'))) {
        return res.status(503).json({
            success: false,
            error: {
                code: ErrorTypes.DATABASE_ERROR,
                message: '数据库连接错误',
                details: '无法连接到数据库',
                timestamp: timestamp
            }
        });
    }

    // 处理Redis连接错误
    if (err.name === 'RedisError') {
        return res.status(503).json({
            success: false,
            error: {
                code: ErrorTypes.CACHE_ERROR,
                message: '缓存服务错误',
                details: err.message,
                timestamp: timestamp
            }
        });
    }

    // 处理外部服务错误
    if (err.name === 'AxiosError') {
        return res.status(502).json({
            success: false,
            error: {
                code: ErrorTypes.EXTERNAL_SERVICE_ERROR,
                message: '外部服务错误',
                details: err.response?.data || err.message,
                timestamp: timestamp
            }
        });
    }

    // 处理SyntaxError（如JSON解析错误）
    if (err instanceof SyntaxError && err.message.includes('JSON')) {
        return res.status(400).json({
            success: false,
            error: {
                code: ErrorTypes.VALIDATION_ERROR,
                message: '无效的请求格式',
                details: '请求体必须是有效的JSON格式',
                timestamp: timestamp
            }
        });
    }

    // 处理其他错误
    return res.status(500).json({
        success: false,
        error: {
            code: ErrorTypes.INTERNAL_ERROR,
            message: process.env.NODE_ENV === 'production' 
                ? '服务器内部错误' 
                : err.message,
            details: process.env.NODE_ENV === 'production' 
                ? null 
                : err.stack,
            timestamp: timestamp
        }
    });
};

// 404处理中间件
const notFoundHandler = (req, res, next) => {
    // 直接返回JSON响应而不是传递错误
    return res.status(404).json({
        success: false,
        error: {
            code: ErrorTypes.NOT_FOUND_ERROR,
            message: `接口不存在: ${req.originalUrl}`,
            timestamp: new Date().toISOString()
        }
    });
};

// 异步处理包装器
const asyncHandler = (fn) => {
    return (req, res, next) => {
        Promise.resolve(fn(req, res, next)).catch(next);
    };
};

// 错误类型检查器
const isErrorType = (error, type) => {
    return error instanceof AppError && error.errorCode === type;
};

// 导出错误处理工具
module.exports = {
    AppError,
    ErrorTypes,
    errorHandler,
    notFoundHandler,
    asyncHandler,
    isErrorType
}; 