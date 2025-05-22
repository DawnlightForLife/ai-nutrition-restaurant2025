require('dotenv').config();

const db = {
  // MongoDB连接URI
  mongoURI: process.env.MONGO_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant',
  
  // MongoDB连接选项
  options: {
    serverSelectionTimeoutMS: 30000, // 服务器选择超时时间
    socketTimeoutMS: 30000, // Socket超时时间
    connectTimeoutMS: 30000, // 连接超时时间
    maxPoolSize: 10, // 连接池大小
    minPoolSize: 5, // 最小连接池大小
    retryWrites: true, // 启用重试写入
    w: 'majority', // 写入确认级别
    readPreference: 'secondaryPreferred' // 读取偏好
  },
  
  // 根据环境确定是否启用调试模式
  debug: process.env.NODE_ENV === 'development',
  
  // 数据加密密钥（用于健康数据等敏感信息）
  encryptionKey: process.env.DB_ENCRYPTION_KEY || 'default_encryption_key_for_development',
  encryptionIV: process.env.DB_ENCRYPTION_IV || 'default_iv_12345',
  
  // 模型特定配置
  modelConfig: {
    // 用户相关
    user: {
      passwordResetExpiry: 24 * 60 * 60 * 1000, // 24小时，以毫秒为单位
      verificationCodeExpiry: 1 * 60 * 60 * 1000, // 1小时
      sessionTimeout: 7 * 24 * 60 * 60 * 1000, // 7天
      maxLoginAttempts: 5,
      lockoutTime: 30 * 60 * 1000 // 30分钟
    },
    
    // 营养数据相关
    nutritionData: {
      defaultRetentionPeriod: 3650, // 10年（天数）
      autoDeleteExpiredData: false
    },
    
    // 支付相关
    payment: {
      transactionTimeout: 15 * 60 * 1000, // 15分钟
      refundPeriod: 7 * 24 * 60 * 60 * 1000 // 7天
    },
    
    // AI相关
    ai: {
      recommendationCacheTime: 24 * 60 * 60 * 1000, // 24小时
      modelUpdateInterval: 7 * 24 * 60 * 60 * 1000 // 7天
    },
    
    // 订单相关
    order: {
      autoConfirmTime: 10 * 60 * 1000, // 10分钟
      autoCompleteTime: 24 * 60 * 60 * 1000 // 24小时
    },
    
    // 审计日志相关
    auditLog: {
      retentionPeriod: 365, // 1年（天数）
      sensitiveActions: ['user_delete', 'user_password_reset', 'nutrition_data_access', 'admin_login']
    }
  },
  
  // 读写分离配置
  replicaSet: {
    primary: process.env.MONGO_PRIMARY_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant',
    replicas: [
      process.env.MONGO_REPLICA_1_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant'
    ]
  },
  
  // 是否启用分片
  enableSharding: process.env.ENABLE_SHARDING === 'true',
  
  // 连接池优化 (新增)
  pool: {
    enableAdaptivePool: process.env.ENABLE_ADAPTIVE_POOL === 'true', // 启用自适应连接池
    minPoolSize: parseInt(process.env.DB_MIN_POOL_SIZE || '5'), // 最小连接池大小
    maxPoolSize: parseInt(process.env.DB_MAX_POOL_SIZE || '20'), // 最大连接池大小
    absoluteMaxPoolSize: parseInt(process.env.DB_ABSOLUTE_MAX_POOL_SIZE || '100'), // 绝对最大连接池大小
    readPoolSize: parseInt(process.env.DB_READ_POOL_SIZE || '15') // 读连接池大小
  },
  
  // 缓存配置 (新增)
  cache: {
    enabled: process.env.ENABLE_DB_CACHE === 'true', // 启用数据库缓存
    defaultTTL: parseInt(process.env.DB_CACHE_TTL || '300'), // 默认缓存时间 (秒)
    redisUrl: process.env.REDIS_URL || 'redis://localhost:6379', // Redis连接
    excludedCollections: process.env.DB_CACHE_EXCLUDED_COLLECTIONS 
      ? process.env.DB_CACHE_EXCLUDED_COLLECTIONS.split(',') 
      : ['auditLogs', 'dbMetrics', 'sessions'], // 排除缓存的集合
    disableCacheInDev: process.env.DISABLE_CACHE_IN_DEV === 'true' // 开发环境禁用缓存
  },
  
  // 批处理配置 (新增)
  batch: {
    enableBatchProcessing: process.env.ENABLE_BATCH_PROCESSING !== 'false', // 默认启用批处理
    batchSize: parseInt(process.env.DB_BATCH_SIZE || '1000'), // 批处理大小
    batchTimeoutMs: parseInt(process.env.DB_BATCH_TIMEOUT || '2000'), // 批处理超时时间(毫秒)
    excludedOperations: process.env.DB_BATCH_EXCLUDED_OPERATIONS
      ? process.env.DB_BATCH_EXCLUDED_OPERATIONS.split(',')
      : [] // 排除批处理的操作
  },
  
  // 事务配置 (新增)
  transaction: {
    enabled: process.env.ENABLE_TRANSACTIONS !== 'false', // 默认启用事务
    defaultTimeout: parseInt(process.env.TRANSACTION_TIMEOUT || '30000'), // 事务超时时间(毫秒)
    maxRetries: parseInt(process.env.TRANSACTION_MAX_RETRIES || '3') // 事务最大重试次数
  },
  
  // 性能监控配置 (新增)
  monitoring: {
    slowQueryThreshold: parseInt(process.env.SLOW_QUERY_THRESHOLD || '500'), // 慢查询阈值(毫秒)
    logSlowQueries: process.env.LOG_SLOW_QUERIES !== 'false', // 默认记录慢查询
    sampleRate: parseFloat(process.env.DB_MONITOR_SAMPLE_RATE || '0.1'), // 监控采样率(0~1)
    collectExplainData: process.env.COLLECT_EXPLAIN_DATA === 'true', // 收集explain数据
    retentionDays: parseInt(process.env.MONITORING_RETENTION_DAYS || '30') // 监控数据保留天数
  },
  
  // 数据库敏感数据配置 (新增)
  security: {
    encryptSensitiveData: process.env.ENCRYPT_SENSITIVE_DATA !== 'false', // 默认加密敏感数据
    encryptionAlgorithm: process.env.DB_ENCRYPTION_ALGORITHM || 'aes-256-cbc', // 加密算法
    sensitivityLevels: {
      high: ['medicalData', 'password', 'payment'], // 高度敏感字段
      medium: ['email', 'phone', 'address'], // 中度敏感字段
      low: ['preferences', 'settings'] // 低度敏感字段
    }
  }
};

module.exports = db; 