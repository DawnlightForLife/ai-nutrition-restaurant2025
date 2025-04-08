/**
 * 数据分片配置
 * 定义各集合的分片策略
 */

const { ShardingStrategy, TimeShardUnit } = require('../services/core/shardingService');

/**
 * 分片配置
 */
const shardingConfig = {
  // 是否启用分片
  enabled: process.env.ENABLE_SHARDING === 'true',
  
  // 各集合的分片策略
  strategies: {
    // 审计日志按时间分片（月度）
    AuditLog: {
      type: ShardingStrategy.TIME,
      unit: TimeShardUnit.MONTH,
      description: '审计日志月度分片，解决大量日志存储问题'
    },
    
    // 健康数据按用户ID哈希分片
    HealthData: {
      type: ShardingStrategy.HASH,
      shards: 8,
      shardPrefix: 'u',
      description: '健康数据用户哈希分片，每个用户的数据集中存储'
    },
    
    // 订单数据按时间分片（季度）
    Order: {
      type: ShardingStrategy.TIME,
      unit: TimeShardUnit.QUARTER,
      description: '订单按季度分片，便于历史订单查询和归档'
    },
    
    // 商家按地理位置分片
    Merchant: {
      type: ShardingStrategy.GEOSPATIAL,
      gridSize: 5, // 5度网格
      regions: [
        {
          name: 'north',
          bounds: { west: -180, east: 180, south: 30, north: 90 }
        },
        {
          name: 'equator',
          bounds: { west: -180, east: 180, south: -30, north: 30 }
        },
        {
          name: 'south',
          bounds: { west: -180, east: 180, south: -90, north: -30 }
        }
      ],
      description: '商家按地理位置分片，优化附近商家查询'
    },
    
    // 用户按ID哈希分片
    User: {
      type: ShardingStrategy.HASH,
      shards: 8,
      shardPrefix: 'u',
      description: '用户按ID哈希分片，均匀分布用户数据'
    },
    
    // AI推荐按用户组分片（VIP用户独立分片）
    AiRecommendation: {
      type: ShardingStrategy.USER,
      userGroups: {
        vip: [], // 实际使用中应从配置获取VIP用户ID列表
        standard: [] // 普通用户ID列表
      },
      shards: 4, // 用于普通用户的哈希分片数
      description: 'AI推荐按用户组分片，VIP用户独立分片优化查询'
    },
    
    // 论坛帖子按时间+热度范围分片
    ForumPost: {
      type: ShardingStrategy.RANGE,
      field: 'popularity_score',
      ranges: [
        { min: 0, max: 10, name: 'low' },
        { min: 11, max: 50, name: 'medium' },
        { min: 51, max: 100, name: 'high' }
      ],
      description: '论坛帖子按热度范围分片，优化热门内容查询'
    },
    
    // 数据库指标按时间分片（月度）
    DbMetrics: {
      type: ShardingStrategy.TIME,
      unit: TimeShardUnit.MONTH,
      description: '数据库性能指标按月分片，便于历史性能分析'
    }
  }
};

// 创建分片服务实例
const shardingService = {
  config: shardingConfig,
  
  /**
   * 初始化分片服务
   * @param {Object} config - 分片配置
   */
  init(config) {
    this.config = config;
    console.log('分片服务已初始化');
  },
  
  /**
   * 根据指定key获取分片名称
   * @param {string} collection - 集合名称
   * @param {string|Object} key - 分片键
   * @returns {string} 分片集合名称
   */
  getShardName(collection, key) {
    if (!this.config.enabled || !this.config.strategies[collection]) {
      return collection; // 未启用分片或集合无分片策略
    }
    
    // 简单实现：返回原集合名称
    // 实际实现中，应根据策略计算分片
    return collection;
  }
};

module.exports = { shardingConfig, shardingService }; 