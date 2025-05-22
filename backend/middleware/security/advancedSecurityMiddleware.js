/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 高级安全中间件集合
 * ✅ 提供核心功能：
 *   - 密码加密与校验（bcrypt）
 *   - JWT生成与验证（jsonwebtoken）
 *   - 请求签名验证（防止中间人攻击）
 *   - SQL注入拦截（正则匹配危险字符）
 *   - XSS清理（过滤<script>标签）
 *   - 敏感字段 AES-GCM 加密
 * ✅ 支持模块化调用，每个方法均为独立安全中间件或工具函数
 * ✅ 建议 future：
 *   - XSS使用 DOMPurify / xss 库替代正则清理
 *   - 请求签名支持回放检测机制（缓存timestamp）
 *   - 敏感字段支持字段路径嵌套（如 user.address.phone）
 */
const crypto = require('crypto');
const { promisify } = require('util');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { logger, securityLogger } = require('../core/loggingMiddleware');


// 密码哈希配置
const SALT_ROUNDS = 10;

/**
 * hashPassword
 * - 使用 bcrypt 对明文密码加盐哈希
 */
const hashPassword = async (password) => {
    return bcrypt.hash(password, SALT_ROUNDS);
};

/**
 * verifyPassword
 * - 校验明文密码与哈希是否匹配
 */
const verifyPassword = async (password, hash) => {
    return bcrypt.compare(password, hash);
};

// 生成随机令牌
const generateToken = (length = 32) => {
    return crypto.randomBytes(length).toString('hex');
};

/**
 * generateJWT / verifyJWT
 * - 用于生成与验证登录令牌（默认24小时有效期）
 */
const generateJWT = (payload, secret, options = {}) => {
    return jwt.sign(payload, secret, {
        expiresIn: options.expiresIn || '24h',
        ...options
    });
};

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

/**
 * requestSignatureVerification
 * - 防止中间人攻击
 * - 检查签名 + 时间戳是否过期
 * - 默认超时限制为 5分钟
 */
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

/**
 * sqlInjectionProtection
 * - 简单正则匹配拦截非法 SQL 特征输入
 */
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

/**
 * enhancedXSSProtection
 * - 替换 request 中的<script>标签，防止XSS
 */
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

/**
 * sensitiveDataEncryption(fields)
 * - 动态加密 req.body 中指定字段
 * - 使用 AES-256-GCM 算法（附带 iv 与 authTag）
 */
const sensitiveDataEncryption = (fields) => {
    return (req, res, next) => {
        // TODO: 支持递归嵌套字段（如 user.profile.phone）
        // TODO: 添加 decryptSensitiveData() 解密中间件用于调试与开发模式
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
    sqlInjectionProtection,
    enhancedXSSProtection,
    sensitiveDataEncryption
}; 