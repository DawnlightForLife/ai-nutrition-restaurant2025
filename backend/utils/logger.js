/**
 * 日志工具模块
 * 用于统一管理应用程序日志，支持不同格式和不同存储方式
 */

const winston = require('winston');
const { format, transports, createLogger } = winston;
const path = require('path');
const fs = require('fs');
const config = require('../config');

// 确保日志目录存在
const logDir = path.resolve(config.logging.logPath || 'logs');
if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir, { recursive: true });
}

/**
 * 自定义格式化器 - 添加额外的上下文信息
 */
const customFormat = format.printf(({ level, message, timestamp, context, ...meta }) => {
  // 基本日志格式
  let log = `${timestamp} [${level.toUpperCase()}]: ${message}`;
  
  // 添加上下文信息（如果有）
  if (context) {
    log += ` [${context}]`;
  }
  
  // 添加其他元数据
  if (Object.keys(meta).length > 0) {
    log += ` ${JSON.stringify(meta)}`;
  }
  
  return log;
});

/**
 * 自定义JSON格式 - 生产环境使用
 */
const jsonFormat = format.combine(
  format.timestamp(),
  format.json()
);

/**
 * 开发环境日志格式（着色和详细输出）
 */
const developmentFormat = format.combine(
  format.colorize(),
  format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  format.splat(),
  customFormat
);

/**
 * 默认日志配置
 */
const defaultOptions = {
  level: config.logging.level || 'info',
  format: process.env.NODE_ENV === 'production' ? jsonFormat : developmentFormat,
  transports: [
    // 控制台输出
    new transports.Console({
      stderrLevels: ['error', 'fatal'],
      consoleWarnLevels: ['warn']
    })
  ]
};

// 添加文件输出（如果配置了文件日志）
if (config.logging.file) {
  defaultOptions.transports.push(
    new transports.File({
      filename: path.join(logDir, 'error.log'),
      level: 'error',
      maxsize: 10 * 1024 * 1024, // 10MB
      maxFiles: 5
    }),
    new transports.File({
      filename: path.join(logDir, 'combined.log'),
      maxsize: 10 * 1024 * 1024, // 10MB
      maxFiles: 10
    })
  );
  
  // 如果配置了按日期生成日志文件
  if (config.logging.filename && config.logging.filename.includes('%DATE%')) {
    const DailyRotateFile = require('winston-daily-rotate-file');
    defaultOptions.transports.push(
      new DailyRotateFile({
        filename: path.join(logDir, config.logging.filename.replace('%DATE%', '%DATE%')),
        datePattern: 'YYYY-MM-DD',
        maxSize: config.logging.maxSize || '20m',
        maxFiles: config.logging.maxFiles || '14d'
      })
    );
  }
}

/**
 * 创建主日志实例
 */
const logger = createLogger(defaultOptions);

/**
 * 创建一个带有上下文的子日志器
 * @param {string} context 日志上下文名称
 * @returns {object} 日志实例
 */
function createContextLogger(context) {
  return {
    debug: (message, meta = {}) => logger.debug(message, { context, ...meta }),
    info: (message, meta = {}) => logger.info(message, { context, ...meta }),
    warn: (message, meta = {}) => logger.warn(message, { context, ...meta }),
    error: (message, meta = {}) => logger.error(message, { context, ...meta }),
    critical: (message, meta = {}) => logger.log('critical', message, { context, ...meta })
  };
}

/**
 * 数据库操作日志器
 */
const dbLogger = createContextLogger('database');

/**
 * HTTP请求日志器
 */
const httpLogger = createContextLogger('http');

/**
 * 身份验证日志器
 */
const authLogger = createContextLogger('auth');

/**
 * 记录慢查询
 * @param {string} collection 集合名称
 * @param {string} operation 操作名称
 * @param {Object} query 查询条件
 * @param {number} duration 执行时间（毫秒）
 */
function logSlowQuery(collection, operation, query, duration) {
  dbLogger.warn(`慢查询 [${duration}ms] ${collection}.${operation}`, {
    collection,
    operation,
    query: typeof query === 'object' ? JSON.stringify(query) : query,
    duration
  });
}

// 导出日志实例
module.exports = {
  ...logger,
  createContextLogger,
  db: dbLogger,
  http: httpLogger,
  auth: authLogger,
  logSlowQuery
}; 