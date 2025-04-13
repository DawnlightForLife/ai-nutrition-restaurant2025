/**
 * 异步函数错误捕获工具
 * 用于统一处理异步函数中的错误
 * @module utils/catchAsync
 */

/**
 * 包装异步函数，自动捕获并传递错误到错误处理中间件
 * @param {Function} fn - 需要包装的异步函数
 * @returns {Function} 包装后的函数
 */
const catchAsync = fn => {
  return (req, res, next) => {
    // 使用Promise处理异步错误
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};

module.exports = catchAsync; 