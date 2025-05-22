/**
 * 查询监控中间件（仅用于开发环境）
 * 记录每次请求中数据库查询的次数、时间等信息
 */
module.exports = () => {
    return (req, res, next) => {
      // TODO: 添加具体查询监控逻辑
      next();
    };
  };