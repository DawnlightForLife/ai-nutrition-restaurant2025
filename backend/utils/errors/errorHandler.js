/**
 * 错误处理工具
 * 提供统一的 API 错误处理响应函数
 * @module utils/errorHandler
 */
const logger = require('../logger/winstonLogger');

/**
 * 处理通用服务器错误（500）
 * 用于捕捉未分类的运行时异常
 * @param {Object} res - Express response 对象
 * @param {Error} error - 异常对象
 * @param {number} statusCode - HTTP 状态码，默认为 500
 * @returns {Object} - JSON 格式的错误响应
 */
exports.handleError = (res, error, statusCode = 500) => {
  logger.error(`❌ API错误: ${error.message}`, error);

  return res.status(statusCode).json({
    success: false,
    message: error.message || 'Internal server error',
    error: process.env.NODE_ENV === 'production' ? {} : error
  });
};

/**
 * 处理校验类错误（如 Joi 或 Mongoose 校验失败）
 * 用于数据入参验证失败场景
 * @param {Object} res - Express response 对象
 * @param {Error} error - 校验错误对象
 * @returns {Object} - JSON 格式的错误响应
 */
exports.handleValidationError = (res, error) => {
  logger.warn(`⚠️ 校验错误: ${error.message}`, error);

  let errorMessage = error.message;
  let errorDetails = {};

  // Joi 校验错误格式
  if (error.details && Array.isArray(error.details)) {
    errorMessage = error.details[0]?.message || '参数校验失败';
    errorDetails = error.details;
  }

  // Mongoose 校验错误格式
  if (error.errors) {
    errorMessage = Object.values(error.errors)
      .map(err => err.message)
      .join(', ') || '数据验证失败';
    errorDetails = error.errors;
  }

  return res.status(400).json({
    success: false,
    message: errorMessage,
    error: errorDetails
  });
};

/**
 * 处理资源不存在的错误（404）
 * 常用于路由或查询不到数据的情况
 * @param {Object} res - Express response 对象
 * @param {string} message - 自定义提示信息
 * @returns {Object} - JSON 格式的错误响应
 */
exports.handleNotFound = (res, message = 'Resource not found') => {
  return res.status(404).json({
    success: false,
    message
  });
};

/**
 * 处理未授权访问错误（401）
 * 用于用户未登录或身份无效
 * @param {Object} res - Express response 对象
 * @param {string} message - 自定义提示信息
 * @returns {Object} - JSON 格式的错误响应
 */
exports.handleUnauthorized = (res, message = 'Unauthorized access') => {
  return res.status(401).json({
    success: false,
    message
  });
};

/**
 * 处理禁止访问错误（403）
 * 用于用户权限不足场景
 * @param {Object} res - Express response 对象
 * @param {string} message - 自定义提示信息
 * @returns {Object} - JSON 格式的错误响应
 */
exports.handleForbidden = (res, message = 'Access forbidden') => {
  return res.status(403).json({
    success: false,
    message
  });
};