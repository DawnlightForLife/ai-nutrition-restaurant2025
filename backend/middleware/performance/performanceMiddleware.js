/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 提供两类基础性能中间件：
 *    1. compressionMiddleware：压缩响应内容，提升网络传输效率
 *    2. requestTimerMiddleware：记录请求耗时，识别慢请求
 * ✅ 默认压缩级别为6，开启最小阈值为1KB
 * ✅ 支持通过 x-no-compression 头手动跳过压缩
 * ✅ 当请求耗时超过 1000ms 时，自动输出 SLOW REQUEST 警告
 * ✅ 建议 future：支持动态调整阈值、记录慢请求详情、集成统计系统
 */

const compression = require('compression');

/**
 * compressionMiddleware
 * - 使用 zlib 压缩 HTTP 响应内容
 * - 默认压缩级别：6，压缩阈值：1KB
 * - 可通过请求头 x-no-compression 跳过压缩
 */
// 响应压缩中间件 - 压缩HTTP响应，降低传输大小
const compressionMiddleware = compression({
  level: 6, // 压缩级别 (0-9)，越高压缩比越大但也更耗CPU
  threshold: 1024, // 超过1KB的响应才进行压缩
  filter: (req, res) => {
    // 不压缩已经压缩的文件类型
    if (req.headers['x-no-compression']) {
      return false;
    }
    // 使用默认的compression过滤函数
    return compression.filter(req, res);
  }
});

/**
 * requestTimerMiddleware
 * - 为每个请求记录处理耗时
 * - 超过1000ms视为慢请求，输出警告日志
 * - 记录起止时间存入 res.locals.timer 中
 */
// 请求计时中间件 - 测量请求处理时间
const requestTimerMiddleware = (req, res, next) => {
  // 记录请求开始时间
  const start = Date.now();
  
  // 在响应对象上添加计时器
  res.locals.timer = {
    start,
    end: null,
    duration: null
  };
  
  // 在响应结束时记录时间
  res.on('finish', () => {
    const end = Date.now();
    const duration = end - start;
    
    res.locals.timer.end = end;
    res.locals.timer.duration = duration;
    
    // 记录耗时超过阈值的请求
    if (duration > 1000) { // 超过1秒的请求
      console.warn(`[SLOW REQUEST] ${req.method} ${req.originalUrl} - ${duration}ms`);
    }
  });
  
  next();
};

// TODO: 支持动态调整慢请求阈值（通过环境变量或配置中心）
// TODO: 将慢请求记录写入 DB 或日志系统供可视化平台使用

module.exports = {
  compressionMiddleware,
  requestTimerMiddleware
}; 