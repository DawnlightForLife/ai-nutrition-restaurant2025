/**
 * 应用错误类
 * 用于统一处理应用程序中的错误
 * @module utils/appError
 */

/**
 * 应用程序错误类
 * 扩展Error类，添加状态码和错误类型
 */
class AppError extends Error {
  /**
   * 创建应用错误实例
   * @param {string} message - 错误消息
   * @param {number} statusCode - HTTP状态码
   * @param {Object} metadata - 附加错误元数据
   */
  constructor(message, statusCode = 500, metadata = {}) {
    super(message);
    
    this.statusCode = statusCode;
    this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
    this.isOperational = true;
    this.metadata = metadata;
    
    // 设置错误类型
    if (statusCode === 400) this.type = 'VALIDATION_ERROR';
    else if (statusCode === 401) this.type = 'UNAUTHORIZED';
    else if (statusCode === 403) this.type = 'FORBIDDEN';
    else if (statusCode === 404) this.type = 'NOT_FOUND';
    else if (statusCode === 409) this.type = 'CONFLICT';
    else if (statusCode === 429) this.type = 'TOO_MANY_REQUESTS';
    else this.type = 'SERVER_ERROR';
    
    // 捕获堆栈跟踪
    Error.captureStackTrace(this, this.constructor);
  }
}

module.exports = AppError; 