/**
 * ✅ 模块名：requestValidationMiddleware.js
 * ✅ 命名风格统一：camelCase
 * ✅ 功能概览：
 *   - 提供请求校验中间件（validateBody, validateQuery, validateParams 等）
 *   - 支持自定义 Joi 验证规则（commonRules + customRules）
 *   - 支持文件上传验证 validateFileUpload
 * ✅ 支持的验证范围：
 *   - body、query、params、headers
 *   - 文件大小、类型、数量限制
 * ✅ 错误处理：
 *   - 所有验证失败均使用统一 AppError 抛出，错误类型为 VALIDATION_ERROR
 * ✅ 建议 future：
 *   - 添加多语言支持（错误信息国际化）
 *   - 支持每个字段的本地化字段名映射提示（如 password → “密码”）
 */

const Joi = require('joi');
const { logger } = require('../core/loggingMiddleware');
const { AppError, ErrorTypes } = require('../core/errorHandlingMiddleware');

/**
 * 请求验证中间件集合
 * 提供高级请求验证功能，包括：
 * - 完整请求验证（body, query, params, headers）
 * - 针对不同请求部分的单独验证
 * - 文件上传验证
 * - 通用验证规则
 */

// 通用验证规则
const commonRules = {
    id: Joi.string().required().min(24).max(24),
    page: Joi.number().integer().min(1).default(1),
    limit: Joi.number().integer().min(1).max(100).default(10),
    sort: Joi.string().valid('asc', 'desc').default('desc'),
    search: Joi.string().min(2).max(100),
    date: Joi.date().iso(),
    email: Joi.string().email().required(),
    password: Joi.string().min(8).max(32).required(),
    phone: Joi.string().pattern(/^[0-9]{11}$/).required(),
    url: Joi.string().uri(),
    boolean: Joi.boolean(),
    number: Joi.number(),
    string: Joi.string(),
    array: Joi.array(),
    object: Joi.object()
};

// 请求验证中间件
const validateRequest = (schema) => {
    return (req, res, next) => {
        // 只包含已定义的schema部分，避免undefined值
        const validationSchema = {};
        const requestData = {};

        if (schema.body) {
            validationSchema.body = schema.body;
            requestData.body = req.body;
        }
        if (schema.query) {
            validationSchema.query = schema.query;
            requestData.query = req.query;
        }
        if (schema.params) {
            validationSchema.params = schema.params;
            requestData.params = req.params;
        }
        if (schema.headers) {
            validationSchema.headers = schema.headers;
            requestData.headers = req.headers;
        }

        // stripUnknown: true 会剥离未在 schema 中定义的字段
        // allowUnknown: true 允许对象中存在未校验字段（不抛错）
        const validationResult = Joi.object(validationSchema).validate(requestData, {
            abortEarly: false,
            allowUnknown: true,
            stripUnknown: true
        });

        if (validationResult.error) {
            const errors = validationResult.error.details.map(detail => ({
                field: detail.path.join('.'),
                message: detail.message,
                type: detail.type
            }));

            logger.warn('Request validation failed:', {
                path: req.path,
                method: req.method,
                errors
            });

            throw new AppError(
                '请求验证失败',
                400,
                ErrorTypes.VALIDATION_ERROR,
                { errors }
            );
        }

        // 更新请求对象为验证后的数据
        req.body = validationResult.value.body;
        req.query = validationResult.value.query;
        req.params = validationResult.value.params;
        req.headers = validationResult.value.headers;

        next();
    };
};

// 请求体验证中间件
const validateBody = (schema) => {
    return validateRequest({ body: schema });
};

// 查询参数验证中间件
const validateQuery = (schema) => {
    return validateRequest({ query: schema });
};

// 路径参数验证中间件
const validateParams = (schema) => {
    return validateRequest({ params: schema });
};

// 请求头验证中间件
const validateHeaders = (schema) => {
    return validateRequest({ headers: schema });
};

// 文件上传验证中间件
const validateFileUpload = (options = {}) => {
    const {
        maxSize = 5 * 1024 * 1024, // 5MB
        allowedTypes = ['image/jpeg', 'image/png', 'image/gif'],
        maxFiles = 1
    } = options;

    // TODO: 支持通过配置动态控制上传限制（如每个用户上传配额）

    return (req, res, next) => {
        if (!req.files) {
            throw new AppError(
                '没有上传文件',
                400,
                ErrorTypes.VALIDATION_ERROR,
                { field: 'files' }
            );
        }

        const files = Array.isArray(req.files) ? req.files : [req.files];
        
        if (files.length > maxFiles) {
            throw new AppError(
                `最多只能上传${maxFiles}个文件`,
                400,
                ErrorTypes.VALIDATION_ERROR,
                { field: 'files' }
            );
        }

        for (const file of files) {
            if (file.size > maxSize) {
                throw new AppError(
                    `文件大小不能超过${maxSize / (1024 * 1024)}MB`,
                    400,
                    ErrorTypes.VALIDATION_ERROR,
                    { field: file.fieldname }
                );
            }

            if (!allowedTypes.includes(file.mimetype)) {
                throw new AppError(
                    `不支持的文件类型: ${file.mimetype}`,
                    400,
                    ErrorTypes.VALIDATION_ERROR,
                    { field: file.fieldname }
                );
            }
        }

        next();
    };
};

// 自定义验证规则
const customRules = {
    // 密码强度验证
    // 密码强度校验：必须包含大小写字母、数字、特殊字符
    strongPassword: Joi.string()
        .min(8)
        .max(32)
        .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/)
        .message('密码必须包含大小写字母、数字和特殊字符'),

    // 手机号验证
    chinesePhone: Joi.string()
        .pattern(/^1[3-9]\d{9}$/)
        .message('无效的中国手机号'),

    // URL验证
    secureUrl: Joi.string()
        .uri({ scheme: ['http', 'https'] })
        .message('无效的URL'),

    // 日期范围验证
    dateRange: Joi.object({
        start: Joi.date().iso().required(),
        end: Joi.date().iso().min(Joi.ref('start')).required()
    }),

    // 分页参数验证
    pagination: Joi.object({
        page: commonRules.page,
        limit: commonRules.limit,
        sort: commonRules.sort
    }),

    // 搜索参数验证
    search: Joi.object({
        query: commonRules.search,
        filters: Joi.object(),
        sort: commonRules.sort,
        page: commonRules.page,
        limit: commonRules.limit
    })
};

module.exports = {
    validateRequest,
    validateBody,
    validateQuery,
    validateParams,
    validateHeaders,
    validateFileUpload,
    commonRules,
    customRules
};