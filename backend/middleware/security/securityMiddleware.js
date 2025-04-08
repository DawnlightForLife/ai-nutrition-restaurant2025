const helmet = require('helmet');
const xss = require('xss-clean');
const mongoSanitize = require('express-mongo-sanitize');
const hpp = require('hpp');

/**
 * 基础安全中间件集合
 * 提供Web应用的基本安全防护，包括：
 * - HTTP安全头部配置
 * - XSS防护
 * - MongoDB注入防护
 * - 参数污染防护
 * - 请求来源验证
 */

// 安全头部配置
const securityHeaders = helmet({
    contentSecurityPolicy: {
        directives: {
            defaultSrc: ["'self'"],
            scriptSrc: ["'self'", "'unsafe-inline'"],
            styleSrc: ["'self'", "'unsafe-inline'"],
            imgSrc: ["'self'", "data:", "https:"],
            connectSrc: ["'self'", "https://api.example.com"],
        },
    },
    crossOriginEmbedderPolicy: false,
    crossOriginResourcePolicy: { policy: "cross-origin" },
    crossOriginOpenerPolicy: { policy: "same-origin" },
    dnsPrefetchControl: { allow: false },
    frameguard: { action: "deny" },
    hidePoweredBy: true,
    hsts: { maxAge: 31536000, includeSubDomains: true, preload: true },
    ieNoOpen: true,
    noSniff: true,
    referrerPolicy: { policy: "strict-origin-when-cross-origin" },
    xssFilter: true
});

// XSS防护
const xssProtection = xss();

// MongoDB注入防护
const mongoSanitization = mongoSanitize();

// 参数污染防护
const parameterPollution = hpp({
    whitelist: [
        'page',
        'limit',
        'sort',
        'fields',
        'filter'
    ]
});

// 敏感数据过滤中间件
const filterSensitiveData = (req, res, next) => {
    // 过滤掉敏感字段
    if (req.body) {
        const sensitiveFields = ['password', 'token', 'secret', 'apiKey'];
        sensitiveFields.forEach(field => {
            if (req.body[field]) {
                delete req.body[field];
            }
        });
    }
    next();
};

// 请求来源验证中间件
const validateOrigin = (req, res, next) => {
    const allowedOrigins = process.env.ALLOWED_ORIGINS?.split(',') || ['http://localhost:3000'];
    const origin = req.headers.origin;
    
    if (origin && !allowedOrigins.includes(origin)) {
        return res.status(403).json({
            success: false,
            error: 'ForbiddenOrigin',
            message: '请求来源不被允许'
        });
    }
    
    next();
};

module.exports = {
    securityHeaders,
    xssProtection,
    mongoSanitization,
    parameterPollution,
    filterSensitiveData,
    validateOrigin
}; 