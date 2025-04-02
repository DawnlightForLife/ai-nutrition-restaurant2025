const helmet = require('helmet');
const xss = require('xss-clean');
const mongoSanitize = require('express-mongo-sanitize');
const hpp = require('hpp');
const { body, validationResult } = require('express-validator');

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

// 输入验证规则
const validationRules = {
    user: {
        create: [
            body('username').trim().isLength({ min: 3, max: 30 }).escape(),
            body('email').isEmail().normalizeEmail(),
            body('password').isLength({ min: 8 }),
            body('phone').matches(/^[0-9]{11}$/),
            body('role').isIn(['user', 'admin', 'merchant'])
        ],
        update: [
            body('username').optional().trim().isLength({ min: 3, max: 30 }).escape(),
            body('email').optional().isEmail().normalizeEmail(),
            body('phone').optional().matches(/^[0-9]{11}$/),
            body('role').optional().isIn(['user', 'admin', 'merchant'])
        ]
    },
    dish: {
        create: [
            body('name').trim().isLength({ min: 2, max: 100 }).escape(),
            body('price').isFloat({ min: 0 }),
            body('category').isIn(['main', 'appetizer', 'dessert', 'beverage']),
            body('ingredients').isArray(),
            body('allergens').optional().isArray(),
            body('nutrition_attributes').isObject()
        ],
        update: [
            body('name').optional().trim().isLength({ min: 2, max: 100 }).escape(),
            body('price').optional().isFloat({ min: 0 }),
            body('category').optional().isIn(['main', 'appetizer', 'dessert', 'beverage']),
            body('ingredients').optional().isArray(),
            body('allergens').optional().isArray(),
            body('nutrition_attributes').optional().isObject()
        ]
    }
};

// 验证结果处理中间件
const validate = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({
            success: false,
            error: 'ValidationError',
            message: '输入数据验证失败',
            errors: errors.array()
        });
    }
    next();
};

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
    validationRules,
    validate,
    filterSensitiveData,
    validateOrigin
}; 