/**
 * ✅ 模块名：securityMiddleware.js
 * ✅ 命名风格统一：camelCase
 * ✅ 功能概览：
 *   - 安全 HTTP 响应头（helmet）
 *   - XSS 清理（xss-clean）
 *   - MongoDB 注入过滤（express-mongo-sanitize）
 *   - HPP 参数污染防护（hpp）
 *   - 请求来源白名单校验（validateOrigin）
 *   - 敏感字段过滤（filterSensitiveData）
 * ✅ 所有中间件均为独立函数，支持按需引入组合
 * ✅ 推荐 future：
 *   - 敏感字段支持字段路径（如 user.password）
 *   - 动态白名单来源列表从数据库加载
 *   - 多语言响应错误提示
 */

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
    contentSecurityPolicy: { // 内容安全策略
        directives: {
            defaultSrc: ["'self'"], // 默认资源来源
            scriptSrc: ["'self'", "'unsafe-inline'"], // 允许的脚本来源
            styleSrc: ["'self'", "'unsafe-inline'"], // 允许的样式来源
            imgSrc: ["'self'", "data:", "https:"], // 允许的图片来源
            connectSrc: ["'self'", "https://api.example.com"], // 允许的 API 连接来源
        },
    },
    crossOriginEmbedderPolicy: false, // 关闭跨域嵌入策略
    crossOriginResourcePolicy: { policy: "cross-origin" }, // 允许跨域资源
    crossOriginOpenerPolicy: { policy: "same-origin" }, // 同源 opener 策略
    dnsPrefetchControl: { allow: false }, // 禁用 DNS 预取
    frameguard: { action: "deny" }, // 禁止页面被 iframe 嵌套
    hidePoweredBy: true, // 隐藏 X-Powered-By 头
    hsts: { maxAge: 31536000, includeSubDomains: true, preload: true }, // 强制 HTTPS
    ieNoOpen: true, // 防止 IE 打开下载的内容
    noSniff: true, // 防止 MIME 类型嗅探
    referrerPolicy: { policy: "strict-origin-when-cross-origin" }, // 引用来源策略
    xssFilter: true // 启用 XSS 过滤（已废弃，部分浏览器支持）
});

// XSS防护
const xssProtection = xss();

// MongoDB注入防护
const mongoSanitization = mongoSanitize();

// 允许重复参数白名单（避免 HPP 误伤分页、排序等字段）
const parameterPollution = hpp({
    whitelist: [
        'page',
        'limit',
        'sort',
        'fields',
        'filter'
    ]
});

/**
 * 过滤请求体中的敏感字段（如 password、token 等）
 * - 防止敏感数据意外存储或记录日志
 */
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

/**
 * 验证请求来源是否在白名单内
 * - 支持通过环境变量 ALLOWED_ORIGINS 设置多个来源
 * - 若来源非法则直接返回 403 错误
 */
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