/**
 * 开发环境配置
 */

module.exports = {
  // 开发环境数据库配置
  database: {
    // 本地开发数据库
    uri: process.env.DEV_MONGODB_URI || 'mongodb://localhost:27017/ai_nutrition_dev',
    // 开发环境不需要读写分离
    useSplitConnections: false,
    // 较小的连接池足够本地开发使用
    poolSize: 5,
    // 较长的超时时间，便于调试
    connectTimeoutMS: 30000,
    // 详细的连接日志
    logConnection: true,
    // 连接池配置
    minPoolSize: 5,
    maxPoolSize: 20,
    enableAutoScaling: true,
    
    // 分片配置
    useSharding: true,
    enableAdaptiveSharding: true,
    
    // 批处理配置
    enableBatchProcessing: true,
    batchSize: 500,
    batchDelay: 100,
    
    // 慢查询阈值（毫秒）
    slowQueryThreshold: 500,
    
    // 自动优化设置
    autoOptimize: true
  },
  
  // 开发环境调试配置
  debug: {
    // 启用所有调试功能
    enabled: true,
    // 记录所有数据库查询
    logQueries: true,
    // 慢查询阈值设置低，捕获潜在性能问题
    slowQueryThreshold: 100,
    // 详细错误信息
    verboseErrors: true,
    // 完整的堆栈跟踪
    stackTraceLimit: 20,
    // 开发环境启用调试端点
    debugEndpoints: true,
    logRequests: true,
    logResponses: false,
    logOperations: true,
    logSharding: true,
    logSystemMetrics: true,
    logConnectionPoolStatus: true,
    logDbOperations: true
  },
  
  // 开发环境安全配置
  security: {
    // 放宽速率限制便于开发测试
    rateLimitWindowMs: 15 * 60 * 1000,
    rateLimitMax: 1000,
    // 可选择性启用CSRF，便于API测试
    csrfProtection: false,
    // 开发环境可以降低加密强度提高性能
    hashRounds: 4
  },
  
  // 开发环境缓存配置
  cache: {
    // 较短的缓存时间，便于开发观察变化
    ttl: 60,
    // 默认使用内存缓存，简化开发
    useRedis: false,
    // Redis配置（可选使用）
    redis: {
      host: 'localhost',
      port: 6379,
      password: ''
    },
    // 启动时清除缓存
    clearOnStartup: true,
    enabled: true,
    defaultTTL: 300, // 5分钟
    // 集合特定的TTL设置
    ttlMap: {
      // 用户相关
      User: {
        findById: 600, // 10分钟
        find: 300      // 5分钟
      },
      // 商品相关
      Dish: {
        findById: 1800, // 30分钟
        find: 900       // 15分钟
      }
    },
    // 不缓存的集合
    excludedCollections: [
      'AuditLog',
      'Session',
      'Notification'
    ]
  },
  
  // 开发环境支付配置
  payment: {
    // 使用支付沙箱环境
    sandbox: true,
    // 可以使用模拟支付进行快速测试
    useMock: true,
    // 显示详细的支付日志
    detailedLogs: true
  },
  
  // 开发特定配置
  development: {
    // 热加载配置
    hotReload: true,
    // 延迟API响应模拟网络延迟（毫秒，0表示禁用）
    simulatedLatency: 0,
    // 静态资源配置
    staticAssets: {
      // 启用源映射
      sourceMaps: true,
      // 不压缩静态资源
      compress: false
    },
    // 开发服务器配置
    server: {
      port: process.env.PORT || 3000,
      host: '0.0.0.0'
    },
    // CORS配置
    cors: {
      enabled: true,
      allowedOrigins: ['http://localhost:3000', 'http://localhost:8080']
    }
  },
  
  // 容错配置
  faultTolerance: {
    enabled: true,
    failureThreshold: 5,
    resetTimeout: 30000,
    halfOpenAttempts: 3
  }
}; 