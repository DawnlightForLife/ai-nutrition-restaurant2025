/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 核心功能：为 Mongoose Schema 注入动态读取偏好配置
 * ✅ 支持操作级默认偏好、集合级别偏好、查询条件感知、自适应读取优化
 * ✅ 集成查询性能统计机制（查询总数 / 慢查询 / 平均耗时）
 * ✅ 自动记录慢查询日志，支持日志重置周期
 * ✅ 建议 future：将慢查询存入数据库用于长期分析
 */

/**
 * 数据库读取偏好中间件
 * 用于控制MongoDB查询从主节点还是从副本节点读取数据
 * 支持动态读取策略和自适应优化
 */

const config = require('../../config');
const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');

// 读取优先级定义
const READ_PREFERENCE_LEVELS = {
  PRIMARY: 'primary',                      // 只从主节点读取，保证强一致性
  PRIMARY_PREFERRED: 'primaryPreferred',   // 优先从主节点读取，主节点不可用时从副本读取
  SECONDARY: 'secondary',                  // 只从副本节点读取，可能读取到旧数据
  SECONDARY_PREFERRED: 'secondaryPreferred', // 优先从副本节点读取，副本不可用时从主节点读取
  NEAREST: 'nearest'                       // 从网络延迟最低的节点读取
};

/**
 * 不同操作的默认读取偏好
 */
const DEFAULT_READ_PREFERENCES = {
  // 聚合操作默认从副本读取
  aggregate: READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED,
  // 查找操作默认从副本读取
  find: READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED,
  findOne: READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED,
  findById: READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED,
  // 统计操作默认从副本读取
  count: READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED,
  countDocuments: READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED,
  estimatedDocumentCount: READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED,
  // 特定查询从主节点读取，确保最新数据
  findOneAndUpdate: READ_PREFERENCE_LEVELS.PRIMARY,
  findOneAndDelete: READ_PREFERENCE_LEVELS.PRIMARY,
  // 默认读取偏好
  default: READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED
};

/**
 * 时间敏感集合列表
 * 这些集合需要时刻保持数据的一致性，优先从主节点读取
 */
const TIME_SENSITIVE_COLLECTIONS = [
  'payments', 
  'transactions', 
  'orders',
  'notifications',
  'active_sessions',
  'auth_tokens'
];

/**
 * 读取操作性能统计
 */
const readOperationStats = {
  // 按集合记录查询性能
  byCollection: {},
  // 按操作类型记录性能
  byOperation: {},
  // 按读取偏好记录性能
  byReadPreference: {},
  // 总查询次数
  totalQueries: 0,
  // 慢查询计数
  slowQueries: 0,
  // 上次重置统计时间
  lastReset: Date.now()
};

/**
 * 记录查询性能
 * @param {String} collection 集合名称
 * @param {String} operation 操作类型
 * @param {String} readPreference 读取偏好
 * @param {Number} duration 查询耗时(ms)
 */
// TODO: 支持将慢查询记录写入 MongoDB collection，便于后续分析与报警
function recordQueryPerformance(collection, operation, readPreference, duration) {
  // 只在启用性能分析时记录
  if (!config.database.trackQueryPerformance) {
    return;
  }
  
  // 增加总查询计数
  readOperationStats.totalQueries++;
  
  // 是否为慢查询
  const isSlowQuery = duration > (config.database.slowQueryThreshold || 500);
  if (isSlowQuery) {
    readOperationStats.slowQueries++;
  }
  
  // 按集合记录
  if (!readOperationStats.byCollection[collection]) {
    readOperationStats.byCollection[collection] = {
      count: 0, totalDuration: 0, avgDuration: 0, slowQueries: 0
    };
  }
  readOperationStats.byCollection[collection].count++;
  readOperationStats.byCollection[collection].totalDuration += duration;
  readOperationStats.byCollection[collection].avgDuration = 
    readOperationStats.byCollection[collection].totalDuration / readOperationStats.byCollection[collection].count;
  if (isSlowQuery) {
    readOperationStats.byCollection[collection].slowQueries++;
  }
  
  // 按操作类型记录
  if (!readOperationStats.byOperation[operation]) {
    readOperationStats.byOperation[operation] = {
      count: 0, totalDuration: 0, avgDuration: 0, slowQueries: 0
    };
  }
  readOperationStats.byOperation[operation].count++;
  readOperationStats.byOperation[operation].totalDuration += duration;
  readOperationStats.byOperation[operation].avgDuration = 
    readOperationStats.byOperation[operation].totalDuration / readOperationStats.byOperation[operation].count;
  if (isSlowQuery) {
    readOperationStats.byOperation[operation].slowQueries++;
  }
  
  // 按读取偏好记录
  if (!readOperationStats.byReadPreference[readPreference]) {
    readOperationStats.byReadPreference[readPreference] = {
      count: 0, totalDuration: 0, avgDuration: 0, slowQueries: 0
    };
  }
  readOperationStats.byReadPreference[readPreference].count++;
  readOperationStats.byReadPreference[readPreference].totalDuration += duration;
  readOperationStats.byReadPreference[readPreference].avgDuration = 
    readOperationStats.byReadPreference[readPreference].totalDuration / readOperationStats.byReadPreference[readPreference].count;
  if (isSlowQuery) {
    readOperationStats.byReadPreference[readPreference].slowQueries++;
  }
  
  // 每隔一段时间(12小时)重置统计数据
  const STATS_RESET_INTERVAL = 12 * 60 * 60 * 1000; // 12小时
  if (Date.now() - readOperationStats.lastReset > STATS_RESET_INTERVAL) {
    if (config.debug && config.debug.logDbStats) {
      logger.info('重置数据库查询性能统计', JSON.stringify(readOperationStats));
    }
    
    // 保留集合和操作类型的列表，但重置计数器
    Object.keys(readOperationStats.byCollection).forEach(col => {
      readOperationStats.byCollection[col] = {count: 0, totalDuration: 0, avgDuration: 0, slowQueries: 0};
    });
    
    Object.keys(readOperationStats.byOperation).forEach(op => {
      readOperationStats.byOperation[op] = {count: 0, totalDuration: 0, avgDuration: 0, slowQueries: 0};
    });
    
    Object.keys(readOperationStats.byReadPreference).forEach(pref => {
      readOperationStats.byReadPreference[pref] = {count: 0, totalDuration: 0, avgDuration: 0, slowQueries: 0};
    });
    
    readOperationStats.totalQueries = 0;
    readOperationStats.slowQueries = 0;
    readOperationStats.lastReset = Date.now();
  }
}

/**
 * 处理读取偏好的中间件
 * @param {Object} schema - Mongoose Schema对象
 */
function handleReadPreference(schema) {
  if (!config.database.useSplitConnections) {
    return schema; // 如果没有启用读写分离，不需要处理读取偏好
  }

  // 获取当前集合名称
  const collectionName = schema.options.collection || 
                        schema.constructor.name.toLowerCase().replace('schema', '');
  
  // 判断是否为时间敏感集合
  const isTimeSensitive = TIME_SENSITIVE_COLLECTIONS.includes(collectionName);
  
  // 为查询操作添加读取偏好
  ['find', 'findOne', 'findById', 'count', 'countDocuments', 'estimatedDocumentCount', 'aggregate'].forEach(method => {
    schema.pre(method, function() {
      // 记录开始时间(用于性能分析)
      this._queryStartTime = Date.now();
      
      // 获取默认的读取偏好
      let readPreference = DEFAULT_READ_PREFERENCES[method] || DEFAULT_READ_PREFERENCES.default;
      
      // 如果是时间敏感集合，始终从主节点读取
      if (isTimeSensitive) {
        readPreference = READ_PREFERENCE_LEVELS.PRIMARY;
      }
      
      // 检查查询参数，特定参数可能需要实时数据
      const query = this.getQuery();
      if (query && (
          // ID查询通常需要最新数据
          query._id || 
          // 通常表示创建后立即查询的情况
          (query.createdAt && query.createdAt.$gte && 
           new Date(query.createdAt.$gte).getTime() > Date.now() - 60000) ||
          // 显式请求实时数据
          query.$readFromPrimary
      )) {
        readPreference = READ_PREFERENCE_LEVELS.PRIMARY;
        
        // 移除非标准查询参数
        if (query.$readFromPrimary) {
          delete query.$readFromPrimary;
          this.setQuery(query);
        }
      }
      
      // 如果查询选项中有特定的读取偏好，优先使用
      if (this.options && this.options.readPreference) {
        readPreference = this.options.readPreference;
      }
      
      // 系统负载过高时，优先保护主库
      if (global.systemLoadHigh && readPreference === READ_PREFERENCE_LEVELS.PRIMARY_PREFERRED) {
        readPreference = READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED;
      }
      
      // 设置读取偏好
      this.setOptions({ readPreference });
      
      // 在开发环境记录日志
      if (process.env.NODE_ENV === 'development' && config.debug && config.debug.logQueries) {
        logger.debug(`[DB Query] Collection: ${collectionName}, Method: ${method}, ReadPreference: ${readPreference}`);
      }
      
      // 记录查询信息用于后置处理
      this._queryInfo = {
        collection: collectionName,
        operation: method,
        readPreference: readPreference
      };
    });
    
    // 查询后记录性能指标
    schema.post(method, function(result, next) {
      if (this._queryStartTime && this._queryInfo) {
        const duration = Date.now() - this._queryStartTime;
        recordQueryPerformance(
          this._queryInfo.collection,
          this._queryInfo.operation,
          this._queryInfo.readPreference,
          duration
        );
        
        // 记录慢查询
        if (duration > (config.database.slowQueryThreshold || 500)) {
          logger.warn(`慢查询 [${duration}ms]: ${this._queryInfo.collection}.${this._queryInfo.operation}() with ${this._queryInfo.readPreference}`);
        }
      }
      next();
    });
  });
  
  // 为带有更新的查询操作强制使用主节点
  ['findOneAndUpdate', 'findOneAndDelete'].forEach(method => {
    schema.pre(method, function() {
      this._queryStartTime = Date.now();
      
      this.setOptions({ readPreference: READ_PREFERENCE_LEVELS.PRIMARY });
      
      // 在开发环境记录日志
      if (process.env.NODE_ENV === 'development' && config.debug && config.debug.logQueries) {
        logger.debug(`[DB Query] Collection: ${collectionName}, Method: ${method}, ReadPreference: primary (forced)`);
      }
      
      this._queryInfo = {
        collection: collectionName,
        operation: method,
        readPreference: READ_PREFERENCE_LEVELS.PRIMARY
      };
    });
    
    // 查询后记录性能指标
    schema.post(method, function(result, next) {
      if (this._queryStartTime && this._queryInfo) {
        const duration = Date.now() - this._queryStartTime;
        recordQueryPerformance(
          this._queryInfo.collection,
          this._queryInfo.operation,
          this._queryInfo.readPreference,
          duration
        );
      }
      next();
    });
  });

  // NOTE: 适应性读取偏好策略，根据操作频率与平均耗时自动调整优先节点
  
  return schema;
}

/**
 * 获取给定操作的最佳读取偏好
 * @param {string} operation - 数据库操作名称
 * @param {string} collectionName - 集合名称
 * @param {Object} options - 查询选项
 * @returns {string} 读取偏好
 */
// TODO: 可扩展为每用户 / 每租户级别的读取偏好定制（支持多租户架构）
function getBestReadPreference(operation, collectionName, options = {}) {
  // 如果选项中已指定读取偏好，使用它
  if (options.readPreference) {
    return options.readPreference;
  }
  
  // 如果是时间敏感集合，使用主节点
  if (TIME_SENSITIVE_COLLECTIONS.includes(collectionName)) {
    return READ_PREFERENCE_LEVELS.PRIMARY;
  }
  
  // 根据操作类型和性能统计动态调整读取偏好
  if (config.database.adaptiveReadPreference && readOperationStats.byOperation[operation]) {
    const opStats = readOperationStats.byOperation[operation];
    
    // 对于高频低延迟查询，优先使用副本节点减轻主库压力
    if (opStats.count > 1000 && opStats.avgDuration < 50) {
      return READ_PREFERENCE_LEVELS.SECONDARY_PREFERRED;
    }
    
    // 对于低频高延迟查询，优先使用主节点提高成功率
    if (opStats.count < 100 && opStats.avgDuration > 200) {
      return READ_PREFERENCE_LEVELS.PRIMARY_PREFERRED;
    }
  }
  
  // 返回操作的默认读取偏好
  return DEFAULT_READ_PREFERENCES[operation] || DEFAULT_READ_PREFERENCES.default;
}

/**
 * 获取当前读取性能统计信息
 * @returns {Object} 性能统计信息
 */
function getReadPreferenceStats() {
  return {
    ...readOperationStats,
    timestamp: new Date()
  };
}

module.exports = {
  handleReadPreference,
  getBestReadPreference,
  getReadPreferenceStats,
  READ_PREFERENCE_LEVELS
};