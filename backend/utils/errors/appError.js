/**
 * 应用错误类
 * 用于统一处理应用程序中的错误
 * @module utils/appError
 */

/**
 * ✅ 模块名：appError.js
 * ✅ 功能说明：
 *   - 封装统一错误处理类 AppError，扩展自原生 Error。
 *   - 提供状态码、错误类型（如 VALIDATION_ERROR、UNAUTHORIZED）与附加元数据。
 *   - 用于控制哪些错误应传递至客户端，哪些应隐藏。
 * ✅ 典型用法：
 *   throw new AppError('资源未找到', 404)
 *   throw new AppError('参数不合法', 400, { field: 'email' })
 */

/**
 * 应用程序错误类
 * 扩展Error类，添加状态码和错误类型
 */
// ✅ 应用程序通用错误类，用于代替原生 Error 统一抛出可控异常
class AppError extends Error {
  /**
   * 创建应用错误实例
   * @param {string} message - 错误消息
   * @param {number} statusCode - HTTP状态码
   * @param {Object} metadata - 附加错误元数据
   */
  constructor(message, statusCode = 500, metadata = {}) {
    super(message);
    
    // HTTP 状态描述（4xx 为 fail，5xx 为 error）
    this.statusCode = statusCode;
    this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';

    // 是否为预期内错误（用于过滤未知系统异常）
    this.isOperational = true;
    this.metadata = metadata;
    
    // 错误类型映射：根据状态码判断错误语义（用于日志与响应判断）
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