/**
 * 分片配置工具
 * 提供分片策略配置和分片名称计算功能
 * 
 * 该模块用于定义系统中不同数据类型的分片策略，
 * 并提供根据相应规则计算具体分片名称的功能。
 * 
 * 适用于需要进行数据分区的中大型系统，如电商订单、健康档案、用户地域路由等场景。
 */

const crypto = require('crypto');

/**
 * 分片配置对象
 * 定义各类数据的分片策略和参数
 * 
 * 每种数据类型可配置：
 * - shardCount: 分片数量，指定分片的总数，适用于需要哈希分布的场景
 * - shardPrefix: 分片集合名称前缀，用于标识该类型的分片集合
 * - strategy: 使用的分片策略，决定如何计算分片名称
 */
const shardingConfig = {
  // 用户分片配置
  user: {
    shardCount: 3,               // 分片数量：3个分片，适合用户数据负载均衡
    shardPrefix: 'user_shard_',  // 分片前缀，分片名称形如"user_shard_0"
    strategy: 'hash'             // 分片策略：基于手机号的哈希分片，保证同一手机号数据落在同一分片
  },
  
  // 健康数据分片配置
  healthData: {
    shardPrefix: 'healthdata_user_', // 分片前缀，分片名称形如"healthdata_user_<userId>"
    strategy: 'userId'               // 分片策略：基于用户ID分片，确保用户健康数据聚合存储
  },
  
  // 订单分片配置
  order: {
    shardPrefix: 'order_',       // 分片前缀，分片名称形如"order_2025_05"
    strategy: 'time',            // 分片策略：基于时间分片，适合订单按月份归档
    timeFormat: 'YYYY_MM'        // 时间格式说明，当前实现按年月分片
  },
  
  // 商家分片配置
  merchant: {
    shardPrefix: 'merchant_region_', // 分片前缀，分片名称形如"merchant_region_<region>"
    strategy: 'region'                // 分片策略：基于地区分片，适合地域敏感的商家数据
  }
};

/**
 * @typedef {Object} ShardDataInput
 * @property {string} [phone] - 用于hash策略（如手机号）
 * @property {string} [userId] - 用于userId策略
 * @property {string} [region] - 用于region策略
 */

/**
 * 获取分片名称
 * 根据数据类型和分片数据，计算应该使用的分片集合名称
 * 
 * @param {string} type - 数据类型 (user / healthData / order / merchant)
 * @param {ShardDataInput} data - 分片数据对象，字段依据分片策略而定
 * @returns {string} 分片集合名称，如 "user_shard_0"、"order_2025_05"
 * @throws {Error} 当类型或必要字段缺失，或策略未知时抛出
 */
const getShardName = (type, data) => {
  const config = shardingConfig[type];
  if (!config) {
    throw new Error(`[ShardConfig] 未知的分片类型: ${type}`);
  }

  switch (config.strategy) {
    case 'hash':
      // hash策略：对手机号进行MD5哈希，取前8位16进制数转换为整数，再对分片数取模
      // 这样可以保证同一手机号始终映射到同一分片，且分布较均匀
      if (!data.phone) {
        throw new Error(`[ShardConfig] 缺少手机号字段(phone)用于hash分片，类型: ${type}`);
      }
      const hash = crypto.createHash('md5').update(data.phone).digest('hex');
      // 截取哈希值前8位，转成整数，避免数字过大导致精度问题
      const shardIndex = parseInt(hash.substring(0, 8), 16) % config.shardCount;
      return `${config.shardPrefix}${shardIndex}`;

    case 'userId':
      // userId策略：直接使用用户ID作为分片名称后缀
      // 适用于用户相关数据，保证数据按用户聚合
      if (!data.userId) {
        throw new Error(`[ShardConfig] 缺少用户ID字段(userId)用于userId分片，类型: ${type}`);
      }
      return `${config.shardPrefix}${data.userId}`;

    case 'time':
      // time策略：基于当前时间生成分片名称，格式为"prefix_YYYY_MM"
      // 适用于时间序列数据，如订单按月分片
      const date = new Date();
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      return `${config.shardPrefix}${year}_${month}`;

    case 'region':
      // region策略：基于地区代码生成分片名称
      // 适用于地域敏感数据，保证同一区域数据集中存储
      if (!data.region) {
        throw new Error(`[ShardConfig] 缺少地区字段(region)用于region分片，类型: ${type}`);
      }
      return `${config.shardPrefix}${data.region}`;

    default:
      // 未知策略抛出错误，方便调试定位
      throw new Error(`[ShardConfig] 未知的分片策略: ${config.strategy}，类型: ${type}`);
  }
};

module.exports = {
  shardingConfig,
  getShardName
};