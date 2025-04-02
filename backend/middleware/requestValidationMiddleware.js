const Joi = require('joi');
const { logger } = require('./loggingMiddleware');
const { AppError, ErrorTypes } = require('./errorHandlingMiddleware');

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
        const validationSchema = {
            body: schema.body,
            query: schema.query,
            params: schema.params,
            headers: schema.headers
        };

        const validationResult = Joi.object(validationSchema).validate({
            body: req.body,
            query: req.query,
            params: req.params,
            headers: req.headers
        }, {
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