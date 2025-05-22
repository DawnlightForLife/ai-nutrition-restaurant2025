/**
 * ✅ 命名风格统一（camelCase）
 * ✅ 支持五种主流分片策略（用户 / 时间 / 地理 / 分类 / 哈希）
 * ✅ 每个策略配置字段名及分片键生成方法
 * ✅ 支持集合策略映射 + 默认兜底机制
 * ✅ 自动集成到 Mongoose schema 插件生命周期（save、update、find等）
 * ✅ 推荐 future：从配置中心动态下发分片策略与字段配置
 */

/**
 * 数据库分片中间件
 * 提供对数据库集合进行分片的功能，支持动态分片策略
 */

const config = require('../../config');
const mongoose = require('mongoose');
const crypto = require('crypto');
const logger = require('../../utils/logger/winstonLogger.js');

// 分片策略映射表

// 用户ID分片策略：用于用户绑定数据，如 userId / customerId / ownerId
const SHARDING_STRATEGIES = {
  USER_BASED: {
    fieldNames: ['userId', 'user_id', 'customerId', 'customer_id', 'ownerId', 'owner_id'],
    getShardKey: (doc, fieldName) => {
      const fieldValue = doc[fieldName] || 'default';
      return fieldValue.toString();
    }
  },
  
  // 时间分片策略：按月划分，适用于时间序列数据
  TIME_BASED: {
    fieldNames: ['createdAt', 'created_at', 'timestamp', 'date', 'orderDate', 'order_date'],
    getShardKey: (doc, fieldName) => {
      const date = new Date(doc[fieldName] || Date.now());
      // 按月分片
      return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
    }
  },
  
  // 地理分片策略：以坐标为基础构建地理网格（5度划分）
  GEO_BASED: {
    fieldNames: ['location', 'coordinates', 'position', 'address'],
    getShardKey: (doc, fieldName) => {
      if (doc[fieldName] && doc[fieldName].coordinates) {
        const [lng, lat] = doc[fieldName].coordinates;
        // 地理网格划分
        return `geo:${Math.floor(lng/5)*5}:${Math.floor(lat/5)*5}`;
      }
      return 'geo:default';
    }
  },
  
  // 分类分片策略：基于字段值直接作为分片键（如 category、type）
  CATEGORY_BASED: {
    fieldNames: ['category', 'type', 'status', 'role', 'group'],
    getShardKey: (doc, fieldName) => {
      return doc[fieldName] ? `${fieldName}:${doc[fieldName]}` : `${fieldName}:default`;
    }
  },
  
  // 哈希分片策略：通过MD5哈希值截取前8位，确保分布均匀性
  HASH_BASED: {
    fieldNames: ['_id', 'id', 'uuid', 'code', 'number'],
    getShardKey: (doc, fieldName) => {
      const value = doc[fieldName] ? doc[fieldName].toString() : 'default';
      // 使用MD5哈希保证分布均匀性
      const hash = crypto.createHash('md5').update(value).digest('hex');
      // 取哈希前8位作为分片键
      return `hash:${hash.substring(0, 8)}`;
    }
  }
};

// 集合与分片策略映射表
const COLLECTION_SHARDING_MAP = {
  'users': ['USER_BASED', 'HASH_BASED'],
  'nutrition_profiles': ['USER_BASED'],
  'nutrition_data': ['USER_BASED', 'TIME_BASED'],
  'merchants': ['HASH_BASED'],
  'dishes': ['CATEGORY_BASED', 'HASH_BASED'],
  'stores': ['GEO_BASED', 'HASH_BASED'],
  'orders': ['USER_BASED', 'TIME_BASED'],
  'forum_posts': ['CATEGORY_BASED', 'USER_BASED', 'TIME_BASED'],
  'forum_comments': ['USER_BASED', 'TIME_BASED'],
  // 默认策略
  'default': ['HASH_BASED', 'TIME_BASED']
};

/**
 * 根据不同集合和文档类型计算合适的分片键
 * @param {String} collectionName 集合名称
 * @param {Object} document 文档对象
 * @returns {String} 分片键
 */
function getShardKey(collectionName, document) {
  try {
    // 如果配置中禁用了分片，返回null
    if (!config.database.useSharding) {
      return null;
    }
    
    // 标准化集合名称
    const normalizedCollectionName = collectionName.toLowerCase().replace(/[_-]/g, '_');
    
    // 获取集合的分片策略
    const strategies = COLLECTION_SHARDING_MAP[normalizedCollectionName] || COLLECTION_SHARDING_MAP.default;
    
    // 尝试应用每个策略找到合适的分片键
    for (const strategyName of strategies) {
      const strategy = SHARDING_STRATEGIES[strategyName];
      
      if (!strategy) {
        logger.warn(`未知的分片策略: ${strategyName}`);
        continue;
      }
      
      // 尝试找到匹配的字段
      for (const fieldName of strategy.fieldNames) {
        if (document[fieldName] !== undefined) {
          const shardKey = strategy.getShardKey(document, fieldName);
          
          // 验证分片键格式
          if (shardKey && typeof shardKey === 'string') {
            // 记录分片键生成（调试模式）
            if (config.debug && config.debug.logSharding) {
              logger.debug(`分片键生成: [${collectionName}] 使用策略 ${strategyName}, 字段 ${fieldName}, 值: ${shardKey}`);
            }
            return shardKey;
          }
        }
      }
    }
    
    // 如果没有找到合适的分片键，使用哈希策略基于_id
    if (document._id) {
      const hash = crypto.createHash('md5').update(document._id.toString()).digest('hex');
      return `hash:${hash.substring(0, 8)}`;
    }
    
    // 最终兜底策略：时间戳哈希
    const timestamp = Date.now().toString();
    const hash = crypto.createHash('md5').update(timestamp).digest('hex');
    return `fallback:${hash.substring(0, 8)}`;
  } catch (error) {
    logger.error('分片键计算出错:', error);
    // 出错时返回预设值，避免整个操作失败
    return 'error';
  }
}

/**
 * 分片键中间件插件
 * @param {mongoose.Schema} schema Mongoose模式对象
 */
function getShardKey(schema) {
  // TODO: 支持模型级别开关，允许某些 schema 不启用分片
  if (!config.database.useSharding) {
    return schema; // 如果不使用分片，直接返回原始schema
  }
  
  // 获取集合名称
  const collectionName = schema.options.collection || 
                         schema.constructor.name.toLowerCase().replace('schema', '');
  
  // 添加分片键字段
  schema.add({
    _shardKey: {
      type: String,
      index: true,
      description: '分片键，用于数据库分片'
    }
  });
  
  // 在保存前计算分片键（save 钩子）
  schema.pre('save', function(next) {
    try {
      if (!this._shardKey) {
        this._shardKey = getShardKey(collectionName, this);
      }
      next();
    } catch (error) {
      logger.error('分片键计算出错:', error);
      next(error);
    }
  });
  
  // 在更新操作前处理（updateOne、findOneAndUpdate 钩子）
  schema.pre(['updateOne', 'findOneAndUpdate'], function(next) {
    try {
      const document = this.getUpdate();
      
      // 跳过系统操作（如$pull, $push等）或已有分片键的情况
      if (!document || document._shardKey || Object.keys(document).some(k => k.startsWith('$'))) {
        return next();
      }
      
      document._shardKey = getShardKey(collectionName, document);
      next();
    } catch (error) {
      logger.error('更新操作分片键计算出错:', error);
      next(error);
    }
  });
  
  // 批量操作前处理（insertMany 钩子）
  schema.pre('insertMany', function(next, docs) {
    try {
      if (!Array.isArray(docs)) {
        return next();
      }
      
      // 为每个文档计算分片键
      for (const doc of docs) {
        if (!doc._shardKey) {
          doc._shardKey = getShardKey(collectionName, doc);
        }
      }
      next();
    } catch (error) {
      logger.error('批量插入分片键计算出错:', error);
      next(error);
    }
  });
  
  // 在普通查询中使用分片键提高性能（find、findOne 钩子）
  schema.pre(['find', 'findOne'], function(next) {
    try {
      // 如果查询条件中有可以计算出分片键的字段，添加分片键条件
      const query = this.getQuery();
      
      // 对已有确定ID的查询不做处理
      if (query._id) {
        return next();
      }
      
      // 对特定集合，尝试根据查询条件计算分片键
      const strategies = COLLECTION_SHARDING_MAP[collectionName] || COLLECTION_SHARDING_MAP.default;
      
      for (const strategyName of strategies) {
        const strategy = SHARDING_STRATEGIES[strategyName];
        
        if (!strategy) continue;
        
        for (const fieldName of strategy.fieldNames) {
          if (query[fieldName]) {
            // 有匹配字段，可以计算分片键
            const mockDoc = { [fieldName]: query[fieldName] };
            const shardKey = strategy.getShardKey(mockDoc, fieldName);
            
            if (shardKey) {
              // 添加分片键条件，优化查询
              this.setQuery({ ...query, _shardKey: shardKey });
              
              // 记录分片键使用（调试模式）
              if (config.debug && config.debug.logSharding) {
                logger.debug(`分片键优化查询: [${collectionName}] 使用策略 ${strategyName}, 字段 ${fieldName}, 值: ${shardKey}`);
              }
              break;
            }
          }
        }
      }
      
      next();
    } catch (error) {
      logger.error('查询分片键优化出错:', error);
      next(); // 继续查询，忽略优化错误
    }
  });
  
  // TODO: 提供 admin API 动态查看分片键分布（用于诊断热点问题）
  
  return schema;
}

// 导出函数
module.exports = {
  getShardKey
}; 