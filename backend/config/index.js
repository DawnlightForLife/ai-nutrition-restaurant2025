/**
 * 主配置文件
 * 根据环境变量加载不同环境的配置
 */

// 加载环境变量
require('dotenv').config();

const env = process.env.NODE_ENV || 'development';

// 基础配置
const config = {
  env,
  port: process.env.PORT || 5000,
  apiPrefix: process.env.API_PREFIX || '/api/v1',
  
  // 静态资源配置
  static: {
    uploadDir: process.env.UPLOAD_DIR || 'uploads',
    maxFileSize: process.env.MAX_FILE_SIZE || 1024 * 1024 * 5, // 5MB
    allowedTypes: ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'application/pdf']
  },
  
  // 数据库配置
  database: {
    uri: process.env.MONGODB_URI || 'mongodb://localhost:27017/ai_nutrition_db',
    writeUri: process.env.MONGODB_WRITE_URI,
    readUri: process.env.MONGODB_READ_URI,
    useSplitConnections: process.env.DB_USE_SPLIT_CONNECTIONS === 'true',
    useSharding: process.env.DB_USE_SHARDING === 'true',
    shardingStrategy: process.env.DB_SHARDING_STRATEGY || 'hash'
  },
  
  // JWT配置
  jwt: {
    secret: process.env.JWT_SECRET || 'your-secret-key',
    expiresIn: process.env.JWT_EXPIRES_IN || '1d',
    refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN || '7d',
  },
  
  // 安全配置
  security: {
    bcryptRounds: parseInt(process.env.BCRYPT_ROUNDS || '10'),
    rateLimitWindowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '60000'),
    rateLimitMax: parseInt(process.env.RATE_LIMIT_MAX || '100')
  },
  
  // 缓存配置
  cache: {
    ttl: parseInt(process.env.CACHE_TTL || '3600'), // 默认缓存1小时
    checkPeriod: parseInt(process.env.CACHE_CHECK_PERIOD || '600'), // 检查过期缓存的周期
    maxItems: parseInt(process.env.CACHE_MAX_ITEMS || '1000'),
    useRedis: process.env.USE_REDIS === 'true',
    redisUrl: process.env.REDIS_URL || 'redis://localhost:6379'
  },
  
  // 推荐系统配置
  recommendation: {
    aiServiceUrl: process.env.AI_SERVICE_URL || 'http://localhost:8000',
    refreshInterval: parseInt(process.env.RECOMMENDATION_REFRESH_INTERVAL || '3600000'), // 1小时
    maxRecommendations: parseInt(process.env.MAX_RECOMMENDATIONS || '20'),
    defaultRadius: parseInt(process.env.DEFAULT_RADIUS || '5000'), // 默认搜索半径（米）
  },
  
  // 通知配置
  notification: {
    email: {
      enabled: process.env.EMAIL_ENABLED === 'true',
      service: process.env.EMAIL_SERVICE || 'smtp.example.com',
      user: process.env.EMAIL_USER,
      password: process.env.EMAIL_PASSWORD,
      from: process.env.EMAIL_FROM || 'noreply@example.com'
    },
    sms: {
      enabled: process.env.SMS_ENABLED === 'true',
      apiKey: process.env.SMS_API_KEY,
      apiSecret: process.env.SMS_API_SECRET,
      from: process.env.SMS_FROM
    },
    push: {
      enabled: process.env.PUSH_ENABLED === 'true',
      vapidPublicKey: process.env.VAPID_PUBLIC_KEY,
      vapidPrivateKey: process.env.VAPID_PRIVATE_KEY
    }
  },
  
  // 支付配置
  payment: {
    providers: {
      alipay: {
        enabled: process.env.ALIPAY_ENABLED === 'true',
        appId: process.env.ALIPAY_APP_ID,
        privateKey: process.env.ALIPAY_PRIVATE_KEY,
        publicKey: process.env.ALIPAY_PUBLIC_KEY
      },
      wechat: {
        enabled: process.env.WECHAT_ENABLED === 'true',
        appId: process.env.WECHAT_APP_ID,
        mchId: process.env.WECHAT_MCH_ID,
        apiKey: process.env.WECHAT_API_KEY
      }
    },
    // 沙箱/生产环境切换
    sandbox: process.env.PAYMENT_SANDBOX === 'true'
  },
  
  // 日志配置
  logging: {
    level: process.env.LOG_LEVEL || (env === 'production' ? 'info' : 'debug'),
    console: process.env.LOG_CONSOLE !== 'false',
    file: process.env.LOG_FILE === 'true',
    logPath: process.env.LOG_PATH || 'logs',
    filename: process.env.LOG_FILENAME || '%DATE%.log',
    maxSize: process.env.LOG_MAX_SIZE || '20m',
    maxFiles: process.env.LOG_MAX_FILES || '14d',
    auditEnabled: process.env.AUDIT_LOGGING === 'true'
  }
};

// 根据环境加载特定配置
const envConfig = require(`./${env}.js`);

// 合并配置
module.exports = { ...config, ...envConfig }; 