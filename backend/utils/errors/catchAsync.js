/**
 * ✅ 模块名：catchAsync.js
 * ✅ 所属工具层：utils
 * ✅ 功能说明：
 *   - 包装异步中间件或控制器函数
 *   - 自动捕获 Promise 异常并传递给全局错误处理器
 * ✅ 使用场景：
 *   - 替代 try-catch 写法，使控制器逻辑更简洁
 * ✅ 示例：
 *   router.get('/example', catchAsync(async (req, res, next) => {
 *     const data = await somethingAsync();
 *     res.json(data);
 *   }));
 */

/**
 * 异步函数错误捕获工具
 * 用于统一处理异步函数中的错误
 * @module utils/catchAsync
 */

/**
 * 高阶函数：接收一个异步函数并返回新的处理函数
 * 自动通过 Promise.resolve 捕获错误并调用 next(err)
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