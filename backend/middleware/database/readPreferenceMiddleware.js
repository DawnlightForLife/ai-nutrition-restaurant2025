/**
 * 数据库读取偏好中间件
 * 用于控制MongoDB查询从主节点还是从副本节点读取数据
 */

const config = require('../../config');
const mongoose = require('mongoose');
const logger = require('../../utils/logger');

/**
 * 不同操作的默认读取偏好
 */
const DEFAULT_READ_PREFERENCES = {
  // 聚合操作默认从副本读取
  aggregate: 'secondaryPreferred',
  // 查找操作默认从副本读取
  find: 'secondaryPreferred',
  findOne: 'secondaryPreferred',
  findById: 'secondaryPreferred',
  // 统计操作默认从副本读取
  count: 'secondaryPreferred',
  countDocuments: 'secondaryPreferred',
  estimatedDocumentCount: 'secondaryPreferred',
  // 特定查询从主节点读取，确保最新数据
  findOneAndUpdate: 'primary',
  findOneAndDelete: 'primary',
  // 默认读取偏好
  default: 'secondaryPreferred'
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
  'active_sessions'
];

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
      // 获取默认的读取偏好
      let readPreference = DEFAULT_READ_PREFERENCES[method] || DEFAULT_READ_PREFERENCES.default;
      
      // 如果是时间敏感集合，始终从主节点读取
      if (isTimeSensitive) {
        readPreference = 'primary';
      }
      
      // 如果查询选项中有特定的读取偏好，优先使用
      if (this.options && this.options.readPreference) {
        readPreference = this.options.readPreference;
      }
      
      // 设置读取偏好
      this.setOptions({ readPreference });
      
      // 在开发环境记录日志
      if (process.env.NODE_ENV === 'development' && config.debug && config.debug.logQueries) {
        logger.debug(`[DB Query] Collection: ${collectionName}, Method: ${method}, ReadPreference: ${readPreference}`);
      }
    });
  });
  
  // 为带有更新的查询操作强制使用主节点
  ['findOneAndUpdate', 'findOneAndDelete'].forEach(method => {
    schema.pre(method, function() {
      this.setOptions({ readPreference: 'primary' });
      
      // 在开发环境记录日志
      if (process.env.NODE_ENV === 'development' && config.debug && config.debug.logQueries) {
        logger.debug(`[DB Query] Collection: ${collectionName}, Method: ${method}, ReadPreference: primary (forced)`);
      }
    });
  });
  
  return schema;
}

/**
 * 获取给定操作的最佳读取偏好
 * @param {string} operation - 数据库操作名称
 * @param {string} collectionName - 集合名称
 * @param {Object} options - 查询选项
 * @returns {string} 读取偏好
 */
function getBestReadPreference(operation, collectionName, options = {}) {
  // 如果选项中已指定读取偏好，使用它
  if (options.readPreference) {
    return options.readPreference;
  }
  
  // 如果是时间敏感集合，使用主节点
  if (TIME_SENSITIVE_COLLECTIONS.includes(collectionName)) {
    return 'primary';
  }
  
  // 返回操作的默认读取偏好
  return DEFAULT_READ_PREFERENCES[operation] || DEFAULT_READ_PREFERENCES.default;
}

module.exports = {
  handleReadPreference,
  getBestReadPreference
}; 