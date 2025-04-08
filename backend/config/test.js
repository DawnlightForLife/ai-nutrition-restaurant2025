/**
 * 测试环境配置
 */

module.exports = {
  // 测试环境数据库配置
  database: {
    // 使用专用测试数据库
    uri: process.env.TEST_MONGODB_URI || 'mongodb://localhost:27017/ai_nutrition_test',
    // 测试环境不使用读写分离
    useSplitConnections: false,
    // 较小的连接池
    poolSize: 5,
    // 测试环境需要快速响应
    connectTimeoutMS: 5000
  },
  
  // 测试环境启用一部分调试功能
  debug: {
    enabled: true,
    // 记录所有查询便于调试测试
    logQueries: true,
    // 完整的堆栈跟踪
    stackTraceLimit: 20,
    // 详细错误信息
    verboseErrors: true
  },
  
  // 测试环境安全配置（宽松）
  security: {
    // 测试环境放宽请求限制
    rateLimitWindowMs: 15 * 60 * 1000,
    rateLimitMax: 1000,
    // 测试环境可以禁用CSRF以简化测试
    csrfProtection: false
  },
  
  // 测试环境缓存配置
  cache: {
    // 测试环境缓存时间短
    ttl: 60,
    // 使用内存缓存便于测试
    useRedis: false,
    // 测试时可以清除缓存
    clearOnStartup: true
  },
  
  // 测试环境支付配置
  payment: {
    // 始终使用沙箱环境
    sandbox: true,
    // 测试环境使用模拟支付
    useMock: true
  },
  
  // 测试特定配置
  test: {
    // 启用自动化测试辅助功能
    testHelpers: true,
    // 测试报告配置
    reporting: {
      coverage: true,
      detailed: true,
      outputPath: './test-reports'
    },
    // 数据库相关
    database: {
      // 每次测试清除数据
      cleanupAfterEach: true,
      // 使用内存数据库进行部分测试
      useInMemoryForUnitTests: true
    },
    // 禁用第三方服务，使用模拟
    mockExternalServices: true
  }
}; 