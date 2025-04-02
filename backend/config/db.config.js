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
    
    // 健康数据相关
    healthData: {
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
      sensitiveActions: ['user_delete', 'user_password_reset', 'health_data_access', 'admin_login']
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
  enableSharding: process.env.ENABLE_SHARDING === 'true'
};

module.exports = db; 