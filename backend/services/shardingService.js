/**
 * 数据分片服务
 * 提供数据分片策略和分片路由功能
 */

/**
 * 分片类型枚举
 * @enum {String}
 */
const ShardingStrategy = {
  RANGE: 'range',       // 范围分片
  HASH: 'hash',         // 哈希分片
  TIME: 'time',         // 时间分片
  GEOSPATIAL: 'geo',    // 地理位置分片
  USER: 'user',         // 用户标识分片
  TENANT: 'tenant'      // 租户分片
};

/**
 * 常用时间分片单位
 * @enum {String} 
 */
const TimeShardUnit = {
  DAY: 'day',
  WEEK: 'week',
  MONTH: 'month',
  QUARTER: 'quarter',
  YEAR: 'year'
};

/**
 * 数据分片服务类
 */
class ShardingService {
  constructor() {
    // 分片配置
    this.config = {
      enabled: false,
      strategies: {}
    };
    
    // 分片映射
    this.shardMaps = new Map();
  }
  
  /**
   * 初始化分片服务
   * @param {Object} config 分片配置
   */
  init(config = {}) {
    this.config = {
      enabled: config.enabled || false,
      strategies: config.strategies || {}
    };
    
    if (this.config.enabled) {
      console.log('分片服务已启用，配置策略：', Object.keys(this.config.strategies));
    }
  }
  
  /**
   * 根据分片键和集合名称确定分片名称
   * @param {String} collection 集合名称
   * @param {any} shardKey 分片键值
   * @returns {String} 分片集合名称
   */
  getShardName(collection, shardKey) {
    if (!this.config.enabled || !this.config.strategies[collection]) {
      return collection; // 未启用分片或无此集合策略，返回原集合名
    }
    
    const strategy = this.config.strategies[collection];
    
    switch (strategy.type) {
      case ShardingStrategy.RANGE:
        return this._getRangeShardName(collection, shardKey, strategy);
      
      case ShardingStrategy.HASH:
        return this._getHashShardName(collection, shardKey, strategy);
      
      case ShardingStrategy.TIME:
        return this._getTimeShardName(collection, shardKey, strategy);
      
      case ShardingStrategy.GEOSPATIAL:
        return this._getGeoShardName(collection, shardKey, strategy);
      
      case ShardingStrategy.USER:
        return this._getUserShardName(collection, shardKey, strategy);
      
      case ShardingStrategy.TENANT:
        return this._getTenantShardName(collection, shardKey, strategy);
      
      default:
        return collection;
    }
  }
  
  /**
   * 获取范围分片集合名称
   * @private
   */
  _getRangeShardName(collection, value, strategy) {
    const { ranges } = strategy;
    if (!ranges || !Array.isArray(ranges)) {
      return collection;
    }
    
    // 查找适用的范围
    for (const range of ranges) {
      if (value >= range.min && value <= range.max) {
        return `${collection}_${range.name || range.min}_${range.max}`;
      }
    }
    
    // 未匹配任何范围，使用默认分片
    return `${collection}_default`;
  }
  
  /**
   * 获取哈希分片集合名称
   * @private
   */
  _getHashShardName(collection, value, strategy) {
    const { shards = 4, shardPrefix = '' } = strategy;
    
    // 计算哈希值
    const hash = typeof value === 'string' 
      ? this._stringHash(value) 
      : this._numberHash(value);
    
    // 计算分片索引
    const shardIndex = hash % shards;
    
    return `${collection}_${shardPrefix}${shardIndex}`;
  }
  
  /**
   * 获取时间分片集合名称
   * @private
   */
  _getTimeShardName(collection, date, strategy) {
    const { unit = TimeShardUnit.MONTH, format = 'YYYY_MM' } = strategy;
    
    // 确保date是Date对象
    const dateObj = date instanceof Date ? date : new Date(date);
    
    if (isNaN(dateObj.getTime())) {
      return `${collection}_invalid_date`;
    }
    
    // 根据时间单位格式化分片名称
    const year = dateObj.getFullYear();
    const month = dateObj.getMonth() + 1;
    const day = dateObj.getDate();
    
    let formattedDate;
    
    switch (unit) {
      case TimeShardUnit.DAY:
        formattedDate = `${year}_${month.toString().padStart(2, '0')}_${day.toString().padStart(2, '0')}`;
        break;
      case TimeShardUnit.WEEK:
        const weekNumber = this._getWeekNumber(dateObj);
        formattedDate = `${year}_W${weekNumber.toString().padStart(2, '0')}`;
        break;
      case TimeShardUnit.MONTH:
        formattedDate = `${year}_${month.toString().padStart(2, '0')}`;
        break;
      case TimeShardUnit.QUARTER:
        const quarter = Math.ceil(month / 3);
        formattedDate = `${year}_Q${quarter}`;
        break;
      case TimeShardUnit.YEAR:
        formattedDate = `${year}`;
        break;
      default:
        formattedDate = `${year}_${month.toString().padStart(2, '0')}`;
    }
    
    return `${collection}_${formattedDate}`;
  }
  
  /**
   * 获取地理位置分片集合名称
   * @private
   */
  _getGeoShardName(collection, coordinates, strategy) {
    const { regions } = strategy;
    
    if (!coordinates || !Array.isArray(coordinates) || coordinates.length < 2) {
      return `${collection}_invalid_geo`;
    }
    
    const [longitude, latitude] = coordinates;
    
    // 查找点所在的区域
    if (regions && Array.isArray(regions)) {
      for (const region of regions) {
        if (this._isPointInRegion(longitude, latitude, region)) {
          return `${collection}_${region.name}`;
        }
      }
    }
    
    // 如果没有定义区域或点不在任何区域内，使用网格分片
    const { gridSize = 10 } = strategy;
    const latGrid = Math.floor((latitude + 90) / gridSize);
    const lngGrid = Math.floor((longitude + 180) / gridSize);
    
    return `${collection}_geo_${latGrid}_${lngGrid}`;
  }
  
  /**
   * 获取用户分片集合名称
   * @private
   */
  _getUserShardName(collection, userId, strategy) {
    const { userGroups } = strategy;
    
    // 首先检查用户是否在特定组中
    if (userGroups && typeof userGroups === 'object') {
      for (const [groupName, userIds] of Object.entries(userGroups)) {
        if (Array.isArray(userIds) && userIds.includes(userId.toString())) {
          return `${collection}_${groupName}`;
        }
      }
    }
    
    // 否则使用哈希分片
    return this._getHashShardName(collection, userId, strategy);
  }
  
  /**
   * 获取租户分片集合名称
   * @private
   */
  _getTenantShardName(collection, tenantId, strategy) {
    const { tenantPrefix = 't' } = strategy;
    return `${collection}_${tenantPrefix}${tenantId}`;
  }
  
  /**
   * 判断点是否在区域内
   * @private
   */
  _isPointInRegion(longitude, latitude, region) {
    // 简单的边界框检查
    if (region.bounds) {
      const { west, east, south, north } = region.bounds;
      return longitude >= west && longitude <= east && 
             latitude >= south && latitude <= north;
    }
    
    // 如果有多边形定义，可以用射线法判断点是否在多边形内
    // 此处简化处理
    return false;
  }
  
  /**
   * 根据分片策略获取指定集合的所有分片名称
   * @param {String} collection 集合名称
   * @returns {Array<String>} 分片集合名称列表
   */
  getAllShards(collection) {
    if (!this.config.enabled || !this.config.strategies[collection]) {
      return [collection];
    }
    
    // 从分片映射中获取已知分片
    if (this.shardMaps.has(collection)) {
      return this.shardMaps.get(collection);
    }
    
    const strategy = this.config.strategies[collection];
    let shards = [];
    
    switch (strategy.type) {
      case ShardingStrategy.RANGE:
        shards = (strategy.ranges || []).map(range => 
          `${collection}_${range.name || range.min}_${range.max}`
        );
        shards.push(`${collection}_default`);
        break;
      
      case ShardingStrategy.HASH:
        const { shards: shardCount = 4, shardPrefix = '' } = strategy;
        for (let i = 0; i < shardCount; i++) {
          shards.push(`${collection}_${shardPrefix}${i}`);
        }
        break;
      
      case ShardingStrategy.TIME:
        // 时间分片通常需要动态查询，这里返回空数组
        // 实际使用中应该查询数据库元数据或维护一个分片列表
        break;
      
      case ShardingStrategy.GEOSPATIAL:
        if (strategy.regions && Array.isArray(strategy.regions)) {
          shards = strategy.regions.map(region => `${collection}_${region.name}`);
        }
        break;
      
      case ShardingStrategy.USER:
        if (strategy.userGroups && typeof strategy.userGroups === 'object') {
          shards = Object.keys(strategy.userGroups).map(groupName => 
            `${collection}_${groupName}`
          );
        }
        break;
      
      case ShardingStrategy.TENANT:
        // 租户分片通常需要动态查询
        break;
    }
    
    // 缓存分片列表
    this.shardMaps.set(collection, shards);
    
    return shards.length > 0 ? shards : [collection];
  }
  
  /**
   * 将查询应用到所有分片并聚合结果
   * @param {Function} queryFn 查询函数
   * @param {String} collection 集合名称
   * @param {Function} aggregateFn 结果聚合函数
   * @returns {Promise<Array>} 聚合后的结果
   */
  async queryAllShards(queryFn, collection, aggregateFn = null) {
    const shards = this.getAllShards(collection);
    
    // 默认聚合函数，简单合并结果
    const defaultAggregateFn = results => {
      return results.reduce((all, current) => all.concat(current), []);
    };
    
    // 如果只有一个分片，直接查询
    if (shards.length === 1) {
      return await queryFn(shards[0]);
    }
    
    // 并行查询所有分片
    const shardResults = await Promise.all(
      shards.map(shard => queryFn(shard))
    );
    
    // 聚合结果
    return (aggregateFn || defaultAggregateFn)(shardResults);
  }
  
  /**
   * 字符串哈希函数
   * @private
   */
  _stringHash(str) {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      hash = ((hash << 5) - hash) + str.charCodeAt(i);
      hash = hash & hash; // 转换为32位整数
    }
    return Math.abs(hash);
  }
  
  /**
   * 数字哈希函数
   * @private
   */
  _numberHash(num) {
    return Math.abs(Math.floor(num));
  }
  
  /**
   * 获取日期所在的周数
   * @private
   */
  _getWeekNumber(date) {
    const firstDayOfYear = new Date(date.getFullYear(), 0, 1);
    const pastDaysOfYear = (date - firstDayOfYear) / 86400000;
    return Math.ceil((pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7);
  }
}

// 导出分片策略枚举
module.exports.ShardingStrategy = ShardingStrategy;
module.exports.TimeShardUnit = TimeShardUnit;

// 创建单例实例
const shardingService = new ShardingService();
module.exports.shardingService = shardingService; 