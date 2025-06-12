/**
 * 工具函数统一导出
 * 集中导出常用工具函数，便于服务层和控制器层调用
 * @module utils
 */

// 错误处理工具
const AppError = require('./errors/appError');
const catchAsync = require('./errors/catchAsync');
const errorHandler = require('./errors/errorHandler');

// 访问控制工具
const conditionEvaluator = require('./access/conditionEvaluator');

// 缓存工具
const cache = require('./cache/cache');

// 日志工具
const logger = require('./logger/winstonLogger');

// 数据验证工具
const userValidator = require('./validators/userValidator');
const authValidator = require('./validators/authValidator');
const nutritionProfileValidator = require('./validators/nutritionProfileValidator');

// 数据加密工具
const mongooseEncryptionPlugin = require('./encryption/mongooseEncryptionPlugin');

// 数据清洗工具
const sanitizeResponse = require('./sanitize/sanitizeResponse');

// DB工具
const dbUtils = require('./db/db');
const dbPerformanceAnalyzer = require('./db/dbPerformanceAnalyzer');
const dbOptimizationHelper = require('./db/dbOptimizationHelper');
const queryEvolutionScorer = require('./db/queryEvolutionScorer');
const shardingConfig = require('./db/shardingConfig');

// 定时任务工具
const scheduledTasks = require('./scheduler/scheduledTasks');

// 模块加载工具
const dynamicEsmLoader = require('./loader/dynamicEsmLoader');

// 导出所有工具
module.exports = {
  // 错误处理
  AppError,
  catchAsync,
  errorHandler,
  
  // 访问控制
  conditionEvaluator,
  
  // 缓存
  cache,
  
  // 日志
  logger,
  
  // 数据验证
  validators: {
    user: userValidator,
    auth: authValidator,
    nutritionProfile: nutritionProfileValidator
  },
  
  // 数据加密
  encryption: {
    mongoosePlugin: mongooseEncryptionPlugin
  },
  
  // 数据清洗
  sanitize: {
    response: sanitizeResponse
  },
  
  // 数据库相关
  db: {
    ...dbUtils,
    performanceAnalyzer: dbPerformanceAnalyzer,
    optimizationHelper: dbOptimizationHelper,
    queryEvolutionScorer: queryEvolutionScorer,
    shardingConfig: shardingConfig
  },
  
  // 定时任务
  scheduler: {
    scheduledTasks
  },
  
  // 模块加载
  loader: {
    dynamicEsmLoader
  }
}; 