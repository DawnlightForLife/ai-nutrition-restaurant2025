/**
 * 自定义错误类
 * 提供统一的错误处理机制
 */

class BaseError extends Error {
  constructor(message, statusCode = 500) {
    super(message);
    this.name = this.constructor.name;
    this.statusCode = statusCode;
    this.isOperational = true;
    
    Error.captureStackTrace(this, this.constructor);
  }
}

/**
 * 验证错误 - 400
 */
class ValidationError extends BaseError {
  constructor(message = '请求参数验证失败') {
    super(message, 400);
  }
}

/**
 * 认证错误 - 401
 */
class AuthenticationError extends BaseError {
  constructor(message = '身份认证失败') {
    super(message, 401);
  }
}

/**
 * 授权错误 - 403
 */
class AuthorizationError extends BaseError {
  constructor(message = '权限不足') {
    super(message, 403);
  }
}

/**
 * 资源未找到错误 - 404
 */
class NotFoundError extends BaseError {
  constructor(message = '请求的资源不存在') {
    super(message, 404);
  }
}

/**
 * 业务逻辑错误 - 422
 */
class BusinessError extends BaseError {
  constructor(message = '业务处理失败') {
    super(message, 422);
  }
}

/**
 * 服务器内部错误 - 500
 */
class InternalServerError extends BaseError {
  constructor(message = '服务器内部错误') {
    super(message, 500);
  }
}

/**
 * 服务不可用错误 - 503
 */
class ServiceUnavailableError extends BaseError {
  constructor(message = '服务暂时不可用') {
    super(message, 503);
  }
}

/**
 * 请求过于频繁错误 - 429
 */
class TooManyRequestsError extends BaseError {
  constructor(message = '请求过于频繁，请稍后再试') {
    super(message, 429);
  }
}

/**
 * 冲突错误 - 409
 */
class ConflictError extends BaseError {
  constructor(message = '请求冲突') {
    super(message, 409);
  }
}

/**
 * 检查是否为操作性错误
 * @param {Error} error 
 * @returns {boolean}
 */
function isOperationalError(error) {
  if (error instanceof BaseError) {
    return error.isOperational;
  }
  return false;
}

module.exports = {
  BaseError,
  ValidationError,
  AuthenticationError,
  AuthorizationError,
  NotFoundError,
  BusinessError,
  InternalServerError,
  ServiceUnavailableError,
  TooManyRequestsError,
  ConflictError,
  isOperationalError
};