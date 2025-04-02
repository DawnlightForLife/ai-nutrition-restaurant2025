const crypto = require('crypto');
const { promisify } = require('util');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { logger, securityLogger } = require('./loggingMiddleware');

// 密码哈希配置
const SALT_ROUNDS = 10;

// 密码哈希函数
const hashPassword = async (password) => {
    return bcrypt.hash(password, SALT_ROUNDS);
};

// 密码验证函数
const verifyPassword = async (password, hash) => {
    return bcrypt.compare(password, hash);
};

// 生成随机令牌
const generateToken = (length = 32) => {
    return crypto.randomBytes(length).toString('hex');
};

// 生成JWT令牌
const generateJWT = (payload, secret, options = {}) => {
    return jwt.sign(payload, secret, {
        expiresIn: options.expiresIn || '24h',
        ...options
    });
};

// 验证JWT令牌
const verifyJWT = (token, secret) => {
    try {
        return jwt.verify(token, secret);
    } catch (error) {
        securityLogger({
            type: 'JWT_VERIFICATION_FAILED',
            error: error.message,
            token: token.substring(0, 10) + '...'
        });
        return null;
    }
};

// 请求签名验证中间件
const requestSignatureVerification = (req, res, next) => {
    const signature = req.headers['x-request-signature'];
    const timestamp = req.headers['x-request-timestamp'];
    
    if (!signature || !timestamp) {
        securityLogger({
            type: 'MISSING_SIGNATURE',
            path: req.path,
            method: req.method
        });
        return res.status(401).json({
            success: false,
            error: 'InvalidSignature',
            message: '请求签名验证失败'
        });
    }
    
    // 验证时间戳是否在5分钟内
    const now = Date.now();
    const requestTime = parseInt(timestamp);
    if (Math.abs(now - requestTime) > 5 * 60 * 1000) {
        securityLogger({
            type: 'EXPIRED_TIMESTAMP',
            path: req.path,
            method: req.method,
            timestamp: requestTime,
            currentTime: now
        });
        return res.status(401).json({
            success: false,
            error: 'ExpiredRequest',
            message: '请求已过期'
        });
    }
    
    // 验证签名
    const data = `${req.method}${req.path}${timestamp}${JSON.stringify(req.body)}`;
    const expectedSignature = crypto
        .createHmac('sha256', process.env.API_SECRET)
        .update(data)
        .digest('hex');
    
    if (signature !== expectedSignature) {
        securityLogger({
            type: 'INVALID_SIGNATURE',
            path: req.path,
            method: req.method
        });
        return res.status(401).json({
            success: false,
            error: 'InvalidSignature',
            message: '请求签名验证失败'
        });
    }
    
    next();
};

// 请求频率限制中间件
const requestFrequencyLimit = (options = {}) => {
    const {
        windowMs = 15 * 60 * 1000, // 15分钟
        max = 100, // 限制每个IP 15分钟内最多100个请求
        message = '请求过于频繁，请稍后再试'
    } = options;
    
    const requests = new Map();
    
    return (req, res, next) => {
        const ip = req.ip;
        const now = Date.now();
        
        // 清理过期的请求记录
        for (const [key, value] of requests.entries()) {
            if (now - value.timestamp > windowMs) {
                requests.delete(key);
            }
        }
        
        // 检查请求频率
        const requestData = requests.get(ip);
        if (requestData) {
            if (requestData.count >= max) {
                securityLogger({
                    type: 'RATE_LIMIT_EXCEEDED',
                    ip,
                    path: req.path,
                    method: req.method
                });
                return res.status(429).json({
                    success: false,
                    error: 'TooManyRequests',
                    message
                });
            }
            requestData.count++;
            requestData.timestamp = now;
        } else {
            requests.set(ip, {
                count: 1,
                timestamp: now
            });
        }
        
        next();
    };
};

// SQL注入防护中间件
const sqlInjectionProtection = (req, res, next) => {
    const sqlInjectionPattern = /(\%27)|(\')|(\-\-)|(\%23)|(#)/i;
    
    const checkValue = (value) => {
        if (typeof value === 'string') {
            return sqlInjectionPattern.test(value);
        }
        if (typeof value === 'object') {
            return Object.values(value).some(checkValue);
        }
        return false;
    };
    
    if (checkValue(req.query) || checkValue(req.body) || checkValue(req.params)) {
        securityLogger({
            type: 'SQL_INJECTION_ATTEMPT',
            path: req.path,
            method: req.method,
            ip: req.ip
        });
        return res.status(400).json({
            success: false,
            error: 'InvalidInput',
            message: '检测到潜在的SQL注入攻击'
        });
    }
    
    next();
};

// XSS防护增强中间件
const enhancedXSSProtection = (req, res, next) => {
    const xssPattern = /<script[^>]*>[\s\S]*?<\/script>/gi;
    
    const sanitizeValue = (value) => {
        if (typeof value === 'string') {
            return value.replace(xssPattern, '');
        }
        if (typeof value === 'object') {
            return Object.entries(value).reduce((acc, [key, val]) => {
                acc[key] = sanitizeValue(val);
                return acc;
            }, {});
        }
        return value;
    };
    
    req.body = sanitizeValue(req.body);
    req.query = sanitizeValue(req.query);
    req.params = sanitizeValue(req.params);
    
    next();
};

// 敏感数据加密中间件
const sensitiveDataEncryption = (fields) => {
    return (req, res, next) => {
        const encryptValue = (value) => {
            if (!value) return value;
            
            const algorithm = 'aes-256-gcm';
            const key = crypto.scryptSync(process.env.ENCRYPTION_KEY, 'salt', 32);
            const iv = crypto.randomBytes(16);
            
            const cipher = crypto.createCipheriv(algorithm, key, iv);
            let encrypted = cipher.update(value, 'utf8', 'hex');
            encrypted += cipher.final('hex');
            
            const authTag = cipher.getAuthTag();
            
            return {
                encrypted,
                iv: iv.toString('hex'),
                authTag: authTag.toString('hex')
            };
        };
        
        const encryptFields = (obj, fields) => {
            fields.forEach(field => {
                if (obj[field]) {
                    obj[field] = encryptValue(obj[field]);
                }
            });
        };
        
        encryptFields(req.body, fields);
        next();
    };
};

module.exports = {
    hashPassword,
    verifyPassword,
    generateToken,
    generateJWT,
    verifyJWT,
    requestSignatureVerification,
    requestFrequencyLimit,
    sqlInjectionProtection,
    enhancedXSSProtection,
    sensitiveDataEncryption
}; 