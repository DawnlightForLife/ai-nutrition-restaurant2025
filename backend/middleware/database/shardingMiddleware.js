/**
 * 数据库分片中间件
 * 提供对数据库集合进行分片的功能
 */

const config = require('../../config');
const mongoose = require('mongoose');

/**
 * 根据不同集合和文档类型计算合适的分片键
 * @param {String} collectionName 集合名称
 * @param {Object} document 文档对象
 * @returns {String} 分片键
 */
function getShardKey(collectionName, document) {
  // 如果配置中禁用了分片，返回null
  if (!config.database.useSharding) {
    return null;
  }

  // 根据不同集合类型返回合适的分片键
  switch(collectionName) {
    case 'users':
    case 'nutrition_profiles':
    case 'health_data':
      // 用户相关数据按用户ID分片
      return document.user_id ? document.user_id.toString() : 'default';
      
    case 'merchants':
    case 'dishes':
    case 'merchant_stats':
      // 商家相关数据按商家ID分片
      return document.merchant_id ? document.merchant_id.toString() : 'default';
      
    case 'orders':
      // 订单可以按用户ID或订单时间范围分片
      if (document.user_id) {
        return document.user_id.toString();
      } else if (document.created_at) {
        // 按月分片
        const date = new Date(document.created_at);
        return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
      }
      return 'default';
      
    case 'stores':
    case 'store_dishes':
      // 门店数据按地理位置分片
      if (document.location && document.location.coordinates) {
        // 使用地理网格划分（简化的地理哈希）
        const [lng, lat] = document.location.coordinates;
        // 将经纬度转换为网格坐标（粗略划分）
        return `geo:${Math.floor(lng)}:${Math.floor(lat)}`;
      }
      return 'default';
      
    case 'forum_posts':
    case 'forum_comments':
      // 论坛数据可以按主题分片
      if (document.category) {
        return `category:${document.category}`;
      } else if (document.post_id) {
        return `post:${document.post_id}`;
      } else if (document.author_id) {
        return `author:${document.author_id}`;
      }
      return 'default';
      
    default:
      // 默认使用配置中指定的分片策略
      if (config.database.shardingStrategy === 'hash' && document._id) {
        // 简单的哈希分片
        return document._id.toString();
      } else if (config.database.shardingStrategy === 'time' && document.created_at) {
        // 时间范围分片
        const date = new Date(document.created_at);
        return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
      }
      
      // 最终默认返回
      return 'default';
  }
}

/**
 * 应用分片键到模型中间件
 * @param {mongoose.Schema} schema Mongoose模式对象
 */
function applyShardingMiddleware(schema) {
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
      index: true
    }
  });
  
  // 在保存前计算分片键
  schema.pre('save', function(next) {
    if (!this._shardKey) {
      this._shardKey = getShardKey(collectionName, this);
    }
    next();
  });
  
  // 在更新操作前处理
  schema.pre(['updateOne', 'findOneAndUpdate'], function(next) {
    const document = this.getUpdate();
    if (document && !document._shardKey) {
      document._shardKey = getShardKey(collectionName, document);
    }
    next();
  });
  
  return schema;
}

module.exports = {
  getShardKey,
  applyShardingMiddleware
}; 