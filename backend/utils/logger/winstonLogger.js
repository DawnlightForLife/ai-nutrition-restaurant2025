/**
 * 日志工具模块
 * 用于统一管理应用程序日志，支持不同格式和不同存储方式
 * 基于 winston 构建，支持控制台输出、文件输出、按日期分割等功能
 */

const winston = require('winston');
const { format, transports, createLogger } = winston;
const path = require('path');
const fs = require('fs');
const config = require('../../config');

// 确保日志目录存在，避免写入文件时出错
const logDir = path.resolve(config.logging.logPath || 'logs');
if (!fs.existsSync(logDir)) {
  fs.mkdirSync(logDir, { recursive: true });
}

/**
 * 自定义格式化器 - 添加额外的上下文信息
 * 用于开发环境下日志的美化输出，包含时间戳、日志级别、消息和上下文信息
 */
const customFormat = format.printf(({ level, message, timestamp, context, ...meta }) => {
  // 基本日志格式
  let log = `${timestamp} [${level.toUpperCase()}]: ${message}`;
  
  // 添加上下文信息（如果有）
  if (context) {
    log += ` [${context}]`;
  }
  
  // 添加其他元数据（额外字段）
  if (Object.keys(meta).length > 0) {
    log += ` ${JSON.stringify(meta)}`;
  }
  
  return log;
});

/**
 * 自定义JSON格式 - 生产环境使用
 * 以 JSON 格式输出，方便日志聚合和搜索
 */
const jsonFormat = format.combine(
  format.timestamp(),
  format.json()
);

/**
 * 开发环境日志格式（着色和详细输出）
 * 包含颜色、高亮、格式化时间戳和自定义格式化器
 */
const developmentFormat = format.combine(
  format.colorize(),
  format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
  format.splat(),
  customFormat
);

/**
 * 默认日志配置
 * 根据环境选择不同格式，默认日志级别从配置文件读取
 * 默认输出到控制台，支持错误级别输出到 stderr
 */
const defaultOptions = {
  level: config.logging.level || 'info',
  format: process.env.NODE_ENV === 'production' ? jsonFormat : developmentFormat,
  transports: [
    // 控制台输出，错误和致命级别输出到 stderr，警告级别特殊处理
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
  
  // 如果配置了按日期生成日志文件，使用 winston-daily-rotate-file
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
 * 负责所有日志的统一管理和输出
 */
const logger = createLogger(defaultOptions);

/**
 * 创建一个带有上下文的子日志器
 * 用于不同模块或功能区分日志来源，方便定位和过滤
 * @param {string} context - 日志上下文名称
 * @returns {object} 日志实例，包含常用日志方法
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
 * 专门记录数据库相关的日志，方便性能监控和故障排查
 */
const dbLogger = createContextLogger('database');

/**
 * HTTP请求日志器
 * 记录 HTTP 请求相关的日志信息
 */
const httpLogger = createContextLogger('http');

/**
 * 身份验证日志器
 * 专门记录身份验证和授权相关的日志
 */
const authLogger = createContextLogger('auth');

/**
 * 记录慢查询
 * 用于 MongoDB 查询超时等场景的性能监控
 * @param {string} collection - MongoDB 集合名称
 * @param {string} operation - 操作类型（如 find、update 等）
 * @param {Object} query - 查询条件
 * @param {number} duration - 查询耗时（毫秒）
 */
function logSlowQuery(collection, operation, query, duration) {
  // 为避免日志中嵌套对象过于冗长，格式化为带缩进的 JSON 字符串
  const formattedQuery = typeof query === 'object' ? JSON.stringify(query, null, 2) : query;
  dbLogger.warn(`慢查询 [${duration}ms] ${collection}.${operation}`, {
    collection,
    operation,
    query: formattedQuery,
    duration
  });
}

// 主导出对象
// 提供基础日志函数、子模块日志器（db/http/auth）和自定义上下文日志器构造器
module.exports = {
  // 基础日志方法（不带上下文）
  debug: (...args) => logger.debug(...args),
  info: (...args) => logger.info(...args),
  warn: (...args) => logger.warn(...args),
  error: (...args) => logger.error(...args),
  log: (...args) => logger.log(...args),

  // 子 logger，用于创建带有特定上下文的日志实例
  child: (options) => logger.child(options),
  createContextLogger,

  // 内置模块日志器，方便直接使用
  db: dbLogger,
  http: httpLogger,
  auth: authLogger,

  // 慢查询记录，专门用于性能监控的日志方法
  logSlowQuery
};