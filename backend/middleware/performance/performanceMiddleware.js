const compression = require('compression');

/**
 * 性能优化中间件集合
 * 提供基本的性能优化功能，包括：
 * - HTTP响应压缩
 * - 请求计时测量
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

module.exports = {
  compressionMiddleware,
  requestTimerMiddleware
}; 