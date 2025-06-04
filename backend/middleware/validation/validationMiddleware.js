/**
 * ✅ 模块名：validationMiddleware.js
 * ✅ 命名风格统一：camelCase
 * ✅ 功能概览：
 *   - validate：请求体（req.body）验证
 *   - validateQuery：查询参数（req.query）验证
 *   - validateParams：路径参数（req.params）验证
 * ✅ 使用 Joi 库进行结构化校验
 * ✅ 验证配置：
 *   - abortEarly: false（返回所有错误）
 *   - allowUnknown: true（允许未定义字段）
 *   - stripUnknown: true（移除未定义字段）
 * ✅ 错误响应结构：
 *   - success: false
 *   - error: 'ValidationError'
 *   - message: 错误类型描述
 *   - errors: 字段级错误明细
 * ✅ 推荐 Future：
 *   - 支持 headers 验证
 *   - 错误 message 多语言处理（国际化）
 *   - 每个字段 message 支持本地化字段别名（如 username → 用户名）
 */

const Joi = require('joi');
const { getValidationSchema } = require('./validationSchemas');

/**
 * validate
 * - 校验 req.body 数据结构是否合法
 * - 使用 schema.validate 校验结构
 * - 支持传入 schema 对象或 schema 名称字符串
 */
const validate = (schemaOrName) => {
    return (req, res, next) => {
        // 判断传入的是 schema 对象还是 schema 名称
        let schema;
        if (typeof schemaOrName === 'string') {
            try {
                schema = getValidationSchema(schemaOrName);
            } catch (error) {
                return res.status(500).json({
                    success: false,
                    error: 'InternalError',
                    message: error.message
                });
            }
        } else {
            schema = schemaOrName;
        }
        
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

/**
 * validateQuery
 * - 校验 req.query 查询字符串结构是否合法
 * - 支持传入 schema 对象或 schema 名称字符串
 */
const validateQuery = (schemaOrName) => {
    return (req, res, next) => {
        // 判断传入的是 schema 对象还是 schema 名称
        let schema;
        if (typeof schemaOrName === 'string') {
            try {
                schema = getValidationSchema(schemaOrName);
            } catch (error) {
                return res.status(500).json({
                    success: false,
                    error: 'InternalError',
                    message: error.message
                });
            }
        } else {
            schema = schemaOrName;
        }
        
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

/**
 * validateParams
 * - 校验 req.params 中路径参数是否合法
 * - 支持传入 schema 对象或 schema 名称字符串
 */
const validateParams = (schemaOrName) => {
    return (req, res, next) => {
        // 判断传入的是 schema 对象还是 schema 名称
        let schema;
        if (typeof schemaOrName === 'string') {
            try {
                schema = getValidationSchema(schemaOrName);
            } catch (error) {
                return res.status(500).json({
                    success: false,
                    error: 'InternalError',
                    message: error.message
                });
            }
        } else {
            schema = schemaOrName;
        }
        
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

/**
 * validationMiddleware
 * - 统一的验证中间件，根据配置名称自动选择验证规则
 * - 简化路由中的使用方式
 */
const validationMiddleware = (schemaName) => {
    return validate(schemaName);
};

// Joi：用于外部定义校验 schema
module.exports = {
    validate,
    validateQuery,
    validateParams,
    validationMiddleware,
    Joi
}; 