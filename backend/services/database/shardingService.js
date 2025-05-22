/**
 * ShardingService（分片服务）
 * 提供数据分片策略、键路由计算、时间/范围/用户组分片支持
 * 支持五种分片策略：HASH、TIME、RANGE、GEOSPATIAL、USER
 * 提供 getShardName 接口供上层服务统一获取真实分片集合名
 * 内置 _simpleHash、_pad 等通用方法并支持 VIP 用户组分片
 * 保持与 shardingAdvisor、shardAccessService 的配置一致性
 * @module services/database/shardingService
 */

const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 分片策略枚举
 * @enum {number}
 */
const ShardingStrategy = {
  // 哈希分片：根据指定字段哈希值进行分片
  HASH: 1,
  
  // 时间分片：根据时间范围进行分片
  TIME: 2,
  
  // 范围分片：根据字段值范围进行分片
  RANGE: 3,
  
  // 地理位置分片：根据地理位置进行分片
  GEOSPATIAL: 4,
  
  // 用户分组分片：根据用户组特性进行分片
  USER: 5
};

/**
 * 时间分片单位枚举
 * @enum {number}
 */
const TimeShardUnit = {
  DAY: 1,
  WEEK: 2,
  MONTH: 3,
  QUARTER: 4,
  YEAR: 5
};

/**
 * 分片服务
 */
const shardingService = {
  config: null,
  
  /**
   * 初始化分片服务
   * @param {Object} config - 分片配置
   */
  init(config) {
    this.config = config;
    logger.info(`[ShardingService] 初始化完成，策略数量: ${Object.keys(config.strategies || {}).length}`);
  },
  
  /**
   * 根据指定key获取分片名称
   * @param {string} collection - 集合名称
   * @param {string|Object} key - 分片键
   * @returns {string} 分片集合名称
   */
  getShardName(collection, key) {
    if (!this.config || !this.config.enabled || !this.config.strategies || !this.config.strategies[collection]) {
      return collection; // 未启用分片或集合无分片策略
    }
    
    const strategy = this.config.strategies[collection];
    
    // 根据不同的分片策略计算分片名称
    switch (strategy.type) {
      case ShardingStrategy.HASH:
        return this._getHashShardName(collection, key, strategy);
        
      case ShardingStrategy.TIME:
        return this._getTimeShardName(collection, key, strategy);
        
      case ShardingStrategy.RANGE:
        return this._getRangeShardName(collection, key, strategy);
        
      case ShardingStrategy.GEOSPATIAL:
        return this._getGeoShardName(collection, key, strategy);
        
      case ShardingStrategy.USER:
        return this._getUserShardName(collection, key, strategy);
        
      default:
        return collection;
    }
  },
  
  /**
   * 获取哈希分片名称
   * @private
   */
  _getHashShardName(collection, key, strategy) {
    if (!key) return collection;
    
    // 将key转为字符串并计算简单哈希
    const keyStr = typeof key === 'object' ? JSON.stringify(key) : String(key);
    const hash = this._simpleHash(keyStr);
    
    // 使用模运算获取分片索引
    const shardIndex = hash % (strategy.shards || 4);
    
    // 构建分片名称
    return `${collection}_${strategy.shardPrefix || 'shard'}_${shardIndex}`;
  },
  
  /**
   * 获取时间分片名称
   * @private
   */
  _getTimeShardName(collection, key, strategy) {
    // 默认使用当前时间
    const date = key instanceof Date ? key : (key?.date instanceof Date ? key.date : new Date());
    
    let format = '';
    switch (strategy.unit) {
      case TimeShardUnit.DAY:
        format = `${date.getFullYear()}${this._pad(date.getMonth() + 1)}${this._pad(date.getDate())}`;
        break;
      case TimeShardUnit.WEEK:
        // 简单周分片，可以优化为ISO周
        format = `${date.getFullYear()}W${this._getWeekNumber(date)}`;
        break;
      case TimeShardUnit.MONTH:
        format = `${date.getFullYear()}${this._pad(date.getMonth() + 1)}`;
        break;
      case TimeShardUnit.QUARTER:
        const quarter = Math.floor(date.getMonth() / 3) + 1;
        format = `${date.getFullYear()}Q${quarter}`;
        break;
      case TimeShardUnit.YEAR:
        format = `${date.getFullYear()}`;
        break;
      default:
        format = `${date.getFullYear()}${this._pad(date.getMonth() + 1)}`;
    }
    
    return `${collection}_${format}`;
  },
  
  /**
   * 获取范围分片名称
   * @private
   */
  _getRangeShardName(collection, key, strategy) {
    if (!key || typeof key !== 'object' || strategy.field === undefined) {
      return collection;
    }
    
    // 获取字段值
    const value = key[strategy.field];
    if (value === undefined) return collection;
    
    // 查找匹配的范围
    for (const range of strategy.ranges || []) {
      if (value >= range.min && value <= range.max) {
        return `${collection}_${range.name}`;
      }
    }
    
    return collection;
  },
  
  /**
   * 获取地理位置分片名称
   * @private
   */
  _getGeoShardName(collection, key, strategy) {
    // 简单实现，仅返回原集合名称
    // 实际实现需要根据经纬度计算区域
    return collection;
  },
  
  /**
   * 获取用户分组分片名称
   * @private
   */
  _getUserShardName(collection, key, strategy) {
    if (!key) return collection;
    
    // 支持新的camelCase命名（userId）和旧的snake_case命名（user_id）以保持兼容性
    const userId = typeof key === 'object' ? key.userId || key.user_id : key;
    
    // 检查是否在VIP用户组
    if (strategy.userGroups?.vip?.includes(userId)) {
      return `${collection}_vip`;
    }
    
    // 默认使用哈希分片
    return this._getHashShardName(collection, userId, {
      shards: strategy.shards || 4,
      shardPrefix: 'std'
    });
  },
  
  /**
   * 简单的字符串哈希函数
   * @private
   */
  _simpleHash(str) {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash; // Convert to 32bit integer
    }
    return Math.abs(hash);
  },
  
  /**
   * 获取日期的ISO周号
   * @private
   */
  _getWeekNumber(date) {
    const d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
    const dayNum = d.getUTCDay() || 7;
    d.setUTCDate(d.getUTCDate() + 4 - dayNum);
    const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
    return Math.ceil((((d - yearStart) / 86400000) + 1) / 7);
  },
  
  /**
   * 数字补零
   * @private
   */
  _pad(num) {
    return num.toString().padStart(2, '0');
  },

  /**
   * 分片数据迁移
   * 
   * @param {string} sourceShardName - 源分片名称
   * @param {string} targetShardName - 目标分片名称
   * @param {Object} query - 迁移数据查询条件
   * @return {Promise<Object>} 迁移结果统计
   */
  async migrateData(sourceShardName, targetShardName, query) {
    // TODO: 实现分片数据迁移逻辑
    return { migrated: 0, failed: 0 };
  }
};

module.exports = {
  ShardingStrategy,
  TimeShardUnit,
  shardingService
}; 