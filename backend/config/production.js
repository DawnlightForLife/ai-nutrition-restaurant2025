/**
 * 生产环境配置
 */

module.exports = {
  // 生产环境数据库配置
  database: {
    // 生产环境数据库URI通过环境变量配置
    uri: process.env.MONGODB_URI,
    // 启用读写分离提高性能
    useSplitConnections: true,
    readUri: process.env.MONGODB_READ_URI,
    // 较大的连接池处理高并发
    poolSize: 50,
    // 较短的连接超时
    connectTimeoutMS: 10000,
    // 生产环境禁用连接日志
    logConnection: false
  },
  
  // 生产环境调试配置
  debug: {
    // 禁用调试功能
    enabled: false,
    // 不记录普通查询
    logQueries: false,
    // 仅记录非常慢的查询
    slowQueryThreshold: 1000,
    // 不返回详细错误信息给客户端
    verboseErrors: false,
    // 限制堆栈跟踪长度
    stackTraceLimit: 10,
    // 生产环境禁用调试端点
    debugEndpoints: false
  },
  
  // 生产环境安全配置
  security: {
    // 较严格的速率限制
    rateLimitWindowMs: 15 * 60 * 1000,
    rateLimitMax: 200,
    // 强制启用CSRF保护
    csrfProtection: true,
    // 高强度密码哈希
    hashRounds: 12,
    // 启用请求验证
    validateRequests: true,
    // 安全头设置
    securityHeaders: {
      contentSecurityPolicy: true,
      xssProtection: true,
      noSniff: true,
      frameGuard: true
    }
  },
  
  // 生产环境缓存配置
  cache: {
    // 较长的缓存时间提高性能
    ttl: 3600,
    // 使用Redis分布式缓存
    useRedis: true,
    // Redis集群配置
    redis: {
      // 通过环境变量配置Redis连接
      host: process.env.REDIS_HOST,
      port: process.env.REDIS_PORT,
      password: process.env.REDIS_PASSWORD,
      // 启用TLS连接
      tls: true,
      // 启用集群模式
      cluster: true,
      nodes: process.env.REDIS_CLUSTER_NODES
    },
    // 启动时不清除缓存
    clearOnStartup: false
  },
  
  // 生产环境支付配置
  payment: {
    // 使用真实支付环境
    sandbox: false,
    // 禁用模拟支付
    useMock: false,
    // 仅记录必要的支付日志
    detailedLogs: false,
    // 支付安全设置
    security: {
      verifyWebhooks: true,
      validateIPs: true
    }
  },
  
  // 生产特定配置
  production: {
    // 禁用热重载
    hotReload: false,
    // 禁用模拟延迟
    simulatedLatency: 0,
    // 静态资源配置
    staticAssets: {
      // 禁用源映射
      sourceMaps: false,
      // 压缩静态资源
      compress: true,
      // 使用CDN
      useCDN: true,
      cdnBase: process.env.CDN_URL
    },
    // 服务器配置
    server: {
      port: process.env.PORT || 8080,
      // 绑定到非公开IP
      host: process.env.HOST || '127.0.0.1',
      // 启用集群模式
      cluster: true,
      // 工作进程数量
      workers: 'auto'
    },
    // CORS配置，仅允许指定域名
    cors: {
      enabled: true,
      allowedOrigins: process.env.ALLOWED_ORIGINS ? process.env.ALLOWED_ORIGINS.split(',') : []
    },
    // 日志配置
    logging: {
      // 日志级别
      level: 'info',
      // 使用结构化日志格式
      format: 'json',
      // 日志持久化
      persistence: true,
      // 日志轮转
      rotate: true
    }
  }
}; 