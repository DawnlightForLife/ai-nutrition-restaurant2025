/**
 * 分片访问服务
 * 提供统一的分片数据访问和管理功能
 */

const mongoose = require('mongoose');

// 分片配置
const SHARD_CONFIG = {
  user: {
    type: 'hash',
    shards: 3,
    prefix: 'user_shard_'
  },
  healthdata: {
    type: 'user',
    shards: 5,
    prefix: 'healthdata_user_'
  },
  order: {
    type: 'time',
    timeUnit: 'month',
    prefix: 'order_'
  },
  merchant: {
    type: 'geo',
    prefix: 'merchant_region_'
  },
  auditlog: {
    type: 'time',
    timeUnit: 'month',
    prefix: 'auditlog_'
  },
  airecommendation: {
    type: 'user',
    shards: 5,
    prefix: 'airecommendation_user_'
  },
  forumpost: {
    type: 'time',
    timeUnit: 'quarter',
    prefix: 'forumpost_'
  },
  dbmetric: {
    type: 'time',
    timeUnit: 'year',
    prefix: 'dbmetric_'
  }
};

class ShardAccessService {
  /**
   * 获取用户分片名称
   * @param {string} userId 用户ID
   * @returns {string} 分片名称
   */
  getUserShardName(userId) {
    return this._getHashBasedShardName(userId, SHARD_CONFIG.user);
  }
  
  /**
   * 获取健康数据分片名称
   * @param {string} userId 用户ID
   * @returns {string} 分片名称
   */
  getHealthDataShardName(userId) {
    return this._getUserBasedShardName(userId, SHARD_CONFIG.healthdata);
  }
  
  /**
   * 获取订单分片名称
   * @param {Date} date 日期
   * @returns {string} 分片名称
   */
  getOrderShardName(date) {
    return this._getTimeBasedShardName(date, SHARD_CONFIG.order);
  }
  
  /**
   * 获取商家分片名称
   * @param {Array} coordinates [经度, 纬度]
   * @returns {string} 分片名称
   */
  getMerchantShardName(coordinates) {
    return this._getGeoBasedShardName(coordinates, SHARD_CONFIG.merchant);
  }
  
  /**
   * 获取审计日志分片名称
   * @param {Date} date 日期
   * @returns {string} 分片名称
   */
  getAuditLogShardName(date) {
    return this._getTimeBasedShardName(date, SHARD_CONFIG.auditlog);
  }
  
  /**
   * 获取AI推荐分片名称
   * @param {string} userId 用户ID
   * @returns {string} 分片名称
   */
  getAiRecommendationShardName(userId) {
    return this._getUserBasedShardName(userId, SHARD_CONFIG.airecommendation);
  }
  
  /**
   * 获取论坛帖子分片名称
   * @param {Date} date 日期
   * @returns {string} 分片名称
   */
  getForumPostShardName(date) {
    return this._getTimeBasedShardName(date, SHARD_CONFIG.forumpost);
  }
  
  /**
   * 获取数据库指标分片名称
   * @param {Date} date 日期
   * @returns {string} 分片名称
   */
  getDbMetricShardName(date) {
    return this._getTimeBasedShardName(date, SHARD_CONFIG.dbmetric);
  }
  
  /**
   * 根据ID查找分片中的文档
   * @param {string} id 文档ID
   * @param {string} shardName 分片名称
   * @returns {Object} 文档
   */
  async findById(id, shardName) {
    if (!id || !shardName) return null;
    
    const db = mongoose.connection.db;
    try {
      const collection = db.collection(shardName);
      return await collection.findOne({ _id: mongoose.Types.ObjectId(id) });
    } catch (err) {
      console.error(`分片查询错误: ${err.message}`);
      return null;
    }
  }
  
  /**
   * 保存文档到分片
   * @param {Object} doc 文档
   * @param {string} shardName 分片名称
   * @returns {boolean} 是否成功
   */
  async saveToShard(doc, shardName) {
    if (!doc || !shardName) return false;
    
    const db = mongoose.connection.db;
    try {
      const collection = db.collection(shardName);
      await collection.updateOne(
        { _id: doc._id },
        { $set: doc },
        { upsert: true }
      );
      return true;
    } catch (err) {
      console.error(`保存到分片错误: ${err.message}`);
      return false;
    }
  }
  
  /**
   * 从分片中查询多个文档
   * @param {Object} query 查询条件
   * @param {string} shardName 分片名称
   * @param {Object} options 查询选项
   * @returns {Array} 文档数组
   */
  async find(query, shardName, options = {}) {
    if (!query || !shardName) return [];
    
    const db = mongoose.connection.db;
    try {
      const collection = db.collection(shardName);
      let cursor = collection.find(query);
      
      if (options.sort) cursor = cursor.sort(options.sort);
      if (options.limit) cursor = cursor.limit(options.limit);
      if (options.skip) cursor = cursor.skip(options.skip);
      
      return await cursor.toArray();
    } catch (err) {
      console.error(`分片查询错误: ${err.message}`);
      return [];
    }
  }
  
  /**
   * 从多个分片中聚合查询
   * @param {Array} shardNames 分片名称数组
   * @param {Object} query 查询条件
   * @param {Object} options 查询选项
   * @returns {Array} 文档数组
   */
  async findAcrossShards(shardNames, query, options = {}) {
    if (!shardNames || !shardNames.length || !query) return [];
    
    const db = mongoose.connection.db;
    const results = [];
    
    try {
      // 并行查询多个分片
      const promises = shardNames.map(async (shardName) => {
        try {
          const collection = db.collection(shardName);
          let cursor = collection.find(query);
          
          if (options.sort) cursor = cursor.sort(options.sort);
          // 不应用limit和skip，因为这些需要在合并后应用
          
          return await cursor.toArray();
        } catch (err) {
          console.error(`分片 ${shardName} 查询错误: ${err.message}`);
          return [];
        }
      });
      
      const resultsArrays = await Promise.all(promises);
      
      // 合并结果
      for (const arr of resultsArrays) {
        results.push(...arr);
      }
      
      // 如果需要排序
      if (options.sort) {
        const sortKeys = Object.keys(options.sort);
        results.sort((a, b) => {
          for (const key of sortKeys) {
            const direction = options.sort[key];
            if (a[key] < b[key]) return -1 * direction;
            if (a[key] > b[key]) return 1 * direction;
          }
          return 0;
        });
      }
      
      // 应用skip和limit
      let finalResults = results;
      if (options.skip) {
        finalResults = finalResults.slice(options.skip);
      }
      if (options.limit) {
        finalResults = finalResults.slice(0, options.limit);
      }
      
      return finalResults;
    } catch (err) {
      console.error(`跨分片查询错误: ${err.message}`);
      return [];
    }
  }
  
  // 私有方法: 根据hash计算分片名称
  _getHashBasedShardName(id, config) {
    const hash = id.toString();
    const hashCode = hash.split('').reduce((a, b) => {
      a = ((a << 5) - a) + b.charCodeAt(0);
      return a & a;
    }, 0);
    const shardIndex = Math.abs(hashCode) % config.shards;
    return `${config.prefix}${shardIndex}`;
  }
  
  // 私有方法: 根据用户ID计算分片名称
  _getUserBasedShardName(userId, config) {
    return this._getHashBasedShardName(userId, config);
  }
  
  // 私有方法: 根据时间计算分片名称
  _getTimeBasedShardName(date, config) {
    const dateObj = date instanceof Date ? date : new Date();
    const year = dateObj.getFullYear();
    
    if (config.timeUnit === 'month') {
      const month = (dateObj.getMonth() + 1).toString().padStart(2, '0');
      return `${config.prefix}${year}_${month}`;
    } else if (config.timeUnit === 'quarter') {
      const quarter = Math.floor(dateObj.getMonth() / 3) + 1;
      return `${config.prefix}${year}_q${quarter}`;
    } else if (config.timeUnit === 'year') {
      return `${config.prefix}${year}`;
    }
    
    // 默认按月
    const month = (dateObj.getMonth() + 1).toString().padStart(2, '0');
    return `${config.prefix}${year}_${month}`;
  }
  
  // 私有方法: 根据地理位置计算分片名称
  _getGeoBasedShardName(coordinates, config) {
    if (Array.isArray(coordinates) && coordinates.length === 2) {
      const [longitude, latitude] = coordinates;
      // 简化的地理区域划分
      const region = Math.floor((longitude + 180) / 90) * 4 + Math.floor((latitude + 90) / 45);
      return `${config.prefix}${region}`;
    }
    return `${config.prefix}default`;
  }
}

// 导出单例
module.exports = new ShardAccessService(); 