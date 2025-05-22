/**
 * 路由日志中间件（仅用于开发环境）
 * 记录所有请求路由信息，帮助调试
 */
module.exports = (options = {}) => {
    return (req, res, next) => {
      console.log(`[DEV] ${req.method} ${req.path}`);
      next();
    };
  };