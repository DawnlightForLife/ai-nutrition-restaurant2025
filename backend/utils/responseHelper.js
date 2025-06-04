/**
 * 响应助手工具
 * 提供统一的API响应格式
 */

/**
 * 成功响应
 * @param {Object} res - Express响应对象
 * @param {*} data - 响应数据
 * @param {string} message - 响应消息
 * @param {number} statusCode - HTTP状态码
 * @returns {Object} Express响应
 */
function successResponse(res, data = null, message = '操作成功', statusCode = 200) {
  const response = {
    success: true,
    message,
    data,
    timestamp: new Date().toISOString()
  };

  // 如果有分页信息，将其提升到顶层
  if (data && typeof data === 'object' && data.pagination) {
    response.pagination = data.pagination;
    delete data.pagination;
  }

  return res.status(statusCode).json(response);
}

/**
 * 错误响应
 * @param {Object} res - Express响应对象
 * @param {string} message - 错误消息
 * @param {number} statusCode - HTTP状态码
 * @param {*} data - 额外的错误数据
 * @param {Array} errors - 验证错误详情
 * @returns {Object} Express响应
 */
function errorResponse(res, message = '操作失败', statusCode = 500, data = null, errors = null) {
  const response = {
    success: false,
    message,
    timestamp: new Date().toISOString()
  };

  // 添加错误数据（如果有）
  if (data !== null) {
    response.data = data;
  }

  // 添加验证错误详情（如果有）
  if (errors && Array.isArray(errors)) {
    response.errors = errors;
  }

  // 在开发环境中添加错误堆栈
  if (process.env.NODE_ENV === 'development' && statusCode >= 500) {
    response.stack = new Error().stack;
  }

  return res.status(statusCode).json(response);
}

/**
 * 分页响应
 * @param {Object} res - Express响应对象
 * @param {Array} items - 数据项数组
 * @param {Object} pagination - 分页信息
 * @param {string} message - 响应消息
 * @returns {Object} Express响应
 */
function paginatedResponse(res, items = [], pagination = {}, message = '获取成功') {
  const defaultPagination = {
    page: 1,
    limit: 20,
    total: 0,
    pages: 0
  };

  const finalPagination = { ...defaultPagination, ...pagination };

  const response = {
    success: true,
    message,
    data: items,
    pagination: finalPagination,
    timestamp: new Date().toISOString()
  };

  return res.status(200).json(response);
}

/**
 * 验证错误响应
 * @param {Object} res - Express响应对象
 * @param {Array} errors - 验证错误数组
 * @param {string} message - 主错误消息
 * @returns {Object} Express响应
 */
function validationErrorResponse(res, errors = [], message = '请求参数验证失败') {
  return errorResponse(res, message, 400, null, errors);
}

/**
 * 未授权响应
 * @param {Object} res - Express响应对象
 * @param {string} message - 错误消息
 * @returns {Object} Express响应
 */
function unauthorizedResponse(res, message = '未授权访问') {
  return errorResponse(res, message, 401);
}

/**
 * 禁止访问响应
 * @param {Object} res - Express响应对象
 * @param {string} message - 错误消息
 * @returns {Object} Express响应
 */
function forbiddenResponse(res, message = '权限不足') {
  return errorResponse(res, message, 403);
}

/**
 * 资源未找到响应
 * @param {Object} res - Express响应对象
 * @param {string} message - 错误消息
 * @returns {Object} Express响应
 */
function notFoundResponse(res, message = '请求的资源不存在') {
  return errorResponse(res, message, 404);
}

/**
 * 服务器错误响应
 * @param {Object} res - Express响应对象
 * @param {string} message - 错误消息
 * @param {Error} error - 原始错误对象
 * @returns {Object} Express响应
 */
function serverErrorResponse(res, message = '服务器内部错误', error = null) {
  // 在开发环境中记录错误详情
  if (process.env.NODE_ENV === 'development' && error) {
    console.error('Server Error:', error);
  }

  const response = {
    success: false,
    message,
    timestamp: new Date().toISOString()
  };

  // 在开发环境中添加错误堆栈
  if (process.env.NODE_ENV === 'development' && error) {
    response.error = {
      message: error.message,
      stack: error.stack
    };
  }

  return res.status(500).json(response);
}

/**
 * 创建响应对象（不发送）
 * @param {boolean} success - 是否成功
 * @param {string} message - 响应消息
 * @param {*} data - 响应数据
 * @param {Object} pagination - 分页信息
 * @returns {Object} 响应对象
 */
function createResponse(success = true, message = '', data = null, pagination = null) {
  const response = {
    success,
    message,
    timestamp: new Date().toISOString()
  };

  if (data !== null) {
    response.data = data;
  }

  if (pagination) {
    response.pagination = pagination;
  }

  return response;
}

/**
 * 格式化验证错误
 * @param {Object} validationResult - Joi验证结果
 * @returns {Array} 格式化的错误数组
 */
function formatValidationErrors(validationResult) {
  if (!validationResult.error) return [];

  return validationResult.error.details.map(detail => ({
    field: detail.path.join('.'),
    message: detail.message,
    value: detail.context?.value
  }));
}

/**
 * 通用错误处理中间件响应
 * @param {Error} error - 错误对象
 * @param {Object} res - Express响应对象
 * @returns {Object} Express响应
 */
function handleError(error, res) {
  // 如果错误有状态码，使用它
  if (error.statusCode) {
    return errorResponse(res, error.message, error.statusCode);
  }

  // 处理特定类型的错误
  if (error.name === 'ValidationError') {
    return validationErrorResponse(res, formatValidationErrors(error));
  }

  if (error.name === 'UnauthorizedError') {
    return unauthorizedResponse(res, error.message);
  }

  if (error.name === 'CastError') {
    return errorResponse(res, '无效的资源ID格式', 400);
  }

  if (error.code === 11000) {
    return errorResponse(res, '数据重复，违反唯一性约束', 400);
  }

  // 默认服务器错误
  return serverErrorResponse(res, '服务器内部错误', error);
}

module.exports = {
  successResponse,
  errorResponse,
  paginatedResponse,
  validationErrorResponse,
  unauthorizedResponse,
  forbiddenResponse,
  notFoundResponse,
  serverErrorResponse,
  createResponse,
  formatValidationErrors,
  handleError
};