/**
 * 系统级配置
 * 定义系统运行模式和功能开关
 */

require('dotenv').config();

const systemConfig = {
  // 是否启用调试模式
  debugMode: process.env.DEBUG_MODE === 'true',
  
  // 是否启用缓存功能
  enableCache: process.env.ENABLE_CACHE !== 'false',
  
  // 是否启用数据分片功能
  enableSharding: process.env.ENABLE_SHARDING === 'true',
  
  // 是否启用查询监控功能
  enableQueryMonitor: process.env.ENABLE_QUERY_MONITOR === 'true',
  
  // 系统环境
  environment: process.env.NODE_ENV || 'development',
  
  // 系统版本
  version: process.env.APP_VERSION || '1.0.0',
  
  // 系统启动时间
  startupTime: new Date().toISOString(),
  
  // 请求限制
  requestLimits: {
    maxBodySize: process.env.MAX_BODY_SIZE || '10mb',
    maxFileSize: process.env.MAX_FILE_SIZE || '5mb',
    timeout: parseInt(process.env.REQUEST_TIMEOUT || '30000') // 默认30秒
  },
  
  // 系统安全设置
  security: {
    corsEnabled: process.env.CORS_ENABLED !== 'false',
    allowedOrigins: process.env.ALLOWED_ORIGINS ? process.env.ALLOWED_ORIGINS.split(',') : ['*'],
    xssProtection: process.env.XSS_PROTECTION !== 'false',
    enableCSRF: process.env.ENABLE_CSRF === 'true',
    csrfExcludedRoutes: process.env.CSRF_EXCLUDED_ROUTES ? process.env.CSRF_EXCLUDED_ROUTES.split(',') : ['/api/v1/webhook'],
    httpOnlySession: process.env.HTTP_ONLY_SESSION !== 'false',
    secureCookies: process.env.SECURE_COOKIES === 'true'
  },
  
  // 系统性能配置
  performance: {
    clusterMode: process.env.CLUSTER_MODE === 'true',
    workerCount: process.env.WORKER_COUNT || 'auto',
    maxConcurrentRequests: parseInt(process.env.MAX_CONCURRENT_REQUESTS || '100'),
    responseCompression: process.env.RESPONSE_COMPRESSION !== 'false',
    memoryLimit: process.env.MEMORY_LIMIT || '1024',
    maxCpuUsage: parseFloat(process.env.MAX_CPU_USAGE || '0.8')
  },
  
  // 系统维护配置
  maintenance: {
    enabled: process.env.MAINTENANCE_MODE === 'true',
    allowedIPs: process.env.MAINTENANCE_ALLOWED_IPS ? process.env.MAINTENANCE_ALLOWED_IPS.split(',') : [],
    message: process.env.MAINTENANCE_MESSAGE || '系统正在维护中，请稍后再试'
  },
  
  // 系统监控设置
  monitoring: {
    metricsEnabled: process.env.METRICS_ENABLED !== 'false',
    metricsPath: process.env.METRICS_PATH || '/metrics',
    performanceMonitoring: process.env.PERFORMANCE_MONITORING !== 'false',
    systemHealthCheck: process.env.SYSTEM_HEALTH_CHECK !== 'false',
    healthCheckPath: process.env.HEALTH_CHECK_PATH || '/health',
    errorTracking: process.env.ERROR_TRACKING !== 'false'
  },
  
  // 系统路径配置
  paths: {
    uploads: process.env.UPLOADS_PATH || 'uploads',
    logs: process.env.LOGS_PATH || 'logs',
    temp: process.env.TEMP_PATH || 'temp',
    static: process.env.STATIC_PATH || 'public'
  },
  
  // 系统资源目录
  resources: {
    templates: process.env.TEMPLATES_PATH || 'resources/templates',
    locales: process.env.LOCALES_PATH || 'resources/locales',
    assets: process.env.ASSETS_PATH || 'resources/assets'
  }
};

module.exports = systemConfig;
