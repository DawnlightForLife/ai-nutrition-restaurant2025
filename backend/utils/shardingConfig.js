const crypto = require('crypto');

// 分片配置
const shardingConfig = {
  // 用户分片配置
  user: {
    shardCount: 3,
    shardPrefix: 'user_shard_',
    strategy: 'hash' // 基于手机号的哈希分片
  },
  
  // 健康数据分片配置
  healthData: {
    shardPrefix: 'healthdata_user_',
    strategy: 'userId' // 基于用户ID分片
  },
  
  // 订单分片配置
  order: {
    shardPrefix: 'order_',
    strategy: 'time', // 基于时间的分片
    timeFormat: 'YYYY_MM' // 按月分片
  },
  
  // 商家分片配置
  merchant: {
    shardPrefix: 'merchant_region_',
    strategy: 'region' // 基于地区分片
  }
};

/**
 * 获取分片名称
 * @param {string} type - 数据类型 (user/healthData/order/merchant)
 * @param {object} data - 分片数据
 * @returns {string} 分片名称
 */
const getShardName = (type, data) => {
  const config = shardingConfig[type];
  if (!config) {
    throw new Error(`未知的分片类型: ${type}`);
  }

  switch (config.strategy) {
    case 'hash':
      // 对手机号进行哈希，然后取模确定分片
      if (!data.phone) {
        throw new Error('缺少手机号码');
      }
      const hash = crypto.createHash('md5').update(data.phone).digest('hex');
      const shardIndex = parseInt(hash.substring(0, 8), 16) % config.shardCount;
      return `${config.shardPrefix}${shardIndex}`;

    case 'userId':
      // 直接使用用户ID作为分片名称的一部分
      if (!data.userId) {
        throw new Error('缺少用户ID');
      }
      return `${config.shardPrefix}${data.userId}`;

    case 'time':
      // 使用当前时间创建分片名称
      const date = new Date();
      const year = date.getFullYear();
      const month = String(date.getMonth() + 1).padStart(2, '0');
      return `${config.shardPrefix}${year}_${month}`;

    case 'region':
      // 使用地区代码作为分片名称的一部分
      if (!data.region) {
        throw new Error('缺少地区信息');
      }
      return `${config.shardPrefix}${data.region}`;

    default:
      throw new Error(`未知的分片策略: ${config.strategy}`);
  }
};

module.exports = {
  shardingConfig,
  getShardName
}; 