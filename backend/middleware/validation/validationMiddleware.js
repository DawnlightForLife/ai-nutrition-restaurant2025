const Joi = require('joi');

/**
 * 数据验证中间件集合
 * 使用Joi库提供数据验证功能，包括：
 * - 请求体验证
 * - 查询参数验证
 * - 路径参数验证
 */

// 通用验证中间件
const validate = (schema) => {
    return (req, res, next) => {
        const { error } = schema.validate(req.body, {
            abortEarly: false,
            allowUnknown: true,
            stripUnknown: true
        });

        if (error) {
            const errors = error.details.map(detail => ({
                field: detail.path.join('.'),
                message: detail.message
            }));

            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: '请求数据验证失败',
                errors
            });
        }

        next();
    };
};

// 查询参数验证中间件
const validateQuery = (schema) => {
    return (req, res, next) => {
        const { error } = schema.validate(req.query, {
            abortEarly: false,
            allowUnknown: true,
            stripUnknown: true
        });

        if (error) {
            const errors = error.details.map(detail => ({
                field: detail.path.join('.'),
                message: detail.message
            }));

            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: '查询参数验证失败',
                errors
            });
        }

        next();
    };
};

// 路径参数验证中间件
const validateParams = (schema) => {
    return (req, res, next) => {
        const { error } = schema.validate(req.params, {
            abortEarly: false,
            allowUnknown: true,
            stripUnknown: true
        });

        if (error) {
            const errors = error.details.map(detail => ({
                field: detail.path.join('.'),
                message: detail.message
            }));

            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: '路径参数验证失败',
                errors
            });
        }

        next();
    };
};

module.exports = {
    validate,
    validateQuery,
    validateParams,
    Joi
}; 