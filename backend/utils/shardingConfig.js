/**
 * 分片配置工具
 * 提供分片策略配置和分片名称计算功能
 * 
 * 该模块用于定义系统中不同数据类型的分片策略，
 * 并提供根据相应规则计算具体分片名称的功能
 */

const crypto = require('crypto');

/**
 * 分片配置对象
 * 定义各类数据的分片策略和参数
 * 
 * 每种数据类型可配置：
 * - shardCount: 分片数量
 * - shardPrefix: 分片集合名称前缀
 * - strategy: 使用的分片策略
 */
const shardingConfig = {
  // 用户分片配置
  user: {
    shardCount: 3,            // 3个分片
    shardPrefix: 'user_shard_', // 分片前缀
    strategy: 'hash'          // 基于手机号的哈希分片
  },
  
  // 健康数据分片配置
  healthData: {
    shardPrefix: 'healthdata_user_',
    strategy: 'userId'        // 基于用户ID分片
  },
  
  // 订单分片配置
  order: {
    shardPrefix: 'order_',
    strategy: 'time',         // 基于时间的分片
    timeFormat: 'YYYY_MM'     // 按月分片
  },
  
  // 商家分片配置
  merchant: {
    shardPrefix: 'merchant_region_',
    strategy: 'region'        // 基于地区分片
  }
};

/**
 * 获取分片名称
 * 根据数据类型和分片数据，计算应该使用的分片集合名称
 * 
 * @param {string} type - 数据类型 (user/healthData/order/merchant)
 * @param {object} data - 分片数据，包含根据strategy确定的字段
 * @returns {string} 分片名称，如"user_shard_0"
 * @throws {Error} 当提供的数据类型无效或缺少必要分片键时抛出错误
 */
const getShardName = (type, data) => {
  const config = shardingConfig[type];
  if (!config) {
    throw new Error(`未知的分片类型: ${type}`);
  }

  switch (config.strategy) {
    case 'hash':
      // 对手机号进行哈希，然后取模确定分片
      // 这种策略确保同一手机号总是存储在同一分片，但分布均匀
      if (!data.phone) {
        throw new Error('缺少手机号码');
      }
      // 使用MD5哈希计算，将手机号映射到一个数值，然后对分片数取模
      const hash = crypto.createHash('md5').update(data.phone).digest('hex');
      const shardIndex = parseInt(hash.substring(0, 8), 16) % config.shardCount;
      return `${config.shardPrefix}${shardIndex}`;

    case 'userId':
      // 直接使用用户ID作为分片名称的一部分
      // 当数据必须与特定用户关联时使用这种策略
      if (!data.userId) {
        throw new Error('缺少用户ID');
      }
      return `${config.shardPrefix}${data.userId}`;

    case 'time':
      // 使用当前时间创建分片名称
      // 适用于有时间属性的数据，如按月分片的订单
      const date = new Date();
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      return `${config.shardPrefix}${year}_${month}`;

    case 'region':
      // 使用地区代码作为分片名称的一部分
      // 适用于地理位置敏感的数据，如按地区分片的商家
      if (!data.region) {
        throw new Error('缺少地区信息');
      }
      return `${config.shardPrefix}${data.region}`;

    default:
      // 处理未知策略
      throw new Error(`未知的分片策略: ${config.strategy}`);
  }
};

module.exports = {
  shardingConfig,
  getShardName
}; 