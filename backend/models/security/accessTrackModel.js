/**
 * 访问轨迹数据模型 - 定义用户和资源访问记录结构
 * @module models/security/accessTrackModel
 */

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

/**
 * 访问轨迹Schema
 */
const accessTrackSchema = new Schema({
  // 用户信息
  userId: { 
    type: String, 
    sparse: true, 
    index: true,
    description: '用户ID（如果有）'
  },
  sessionId: { 
    type: String, 
    sparse: true, 
    index: true,
    description: '会话ID（如果有）'
  },
  
  // 网络信息
  ip: { 
    type: String, 
    required: true, 
    index: true,
    description: '客户端IP地址'
  },
  
  // 请求信息
  method: { 
    type: String, 
    required: true,
    enum: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS', 'HEAD'],
    description: 'HTTP请求方法'
  },
  path: { 
    type: String, 
    required: true,
    description: '请求路径'
  },
  query: { 
    type: Object,
    description: '查询参数'
  },
  
  // 资源信息
  resource: {
    type: { 
      type: String, 
      index: true,
      description: '资源类型（如user, dish等）'
    },
    id: { 
      type: String, 
      index: true,
      description: '资源ID'
    }
  },
  
  // 客户端信息
  userAgent: {
    browser: { 
      type: String,
      description: '浏览器名称和版本'
    },
    device: { 
      type: String,
      description: '设备类型'
    },
    os: { 
      type: String,
      description: '操作系统'
    }
  },
  
  // 地理位置信息
  location: {
    country: { 
      type: String,
      description: '国家'
    },
    region: { 
      type: String,
      description: '地区/省份'
    },
    city: { 
      type: String,
      description: '城市'
    },
    coordinates: {
      type: [Number],  // [经度, 纬度]
      index: '2dsphere',
      description: '地理坐标'
    }
  },

  // 新增字段
  sessionDuration: {
    type: Number,
    default: null,
    description: '本次会话持续时间（毫秒），退出后记录'
  },
  authenticationMethod: {
    type: String,
    enum: ['password', 'code', 'oauth', 'anonymous'],
    default: 'anonymous',
    description: '本次访问的认证方式'
  },
  
  // 时间信息
  timestamp: { 
    type: Date, 
    default: Date.now, 
    index: true,
    description: '访问时间戳'
  },
  
  // 响应信息
  responseStatus: { 
    type: Number,
    description: 'HTTP响应状态码'
  },
  responseTime: { 
    type: Number,
    description: '响应时间（毫秒）'
  },
  
  // 其他信息
  referrer: { 
    type: String,
    description: '引荐来源'
  },
  
  // 安全信息
  anomalyScore: { 
    type: Number, 
    default: 0,
    description: '异常分数（0-100）'
  },
  anomalyTypes: {
    type: [String],
    description: '检测到的异常类型'
  },
  flags: {
    type: [String],
    description: '特殊标记（如 suspicious, blocked, reviewed）'
  },
  
  // 元数据
  metadata: {
    type: Object,
    description: '额外元数据'
  }
}, {
  timestamps: true,
  collection: 'access_tracks'
});

// 创建复合索引
accessTrackSchema.index({ userId: 1, timestamp: -1 });
accessTrackSchema.index({ ip: 1, timestamp: -1 });
accessTrackSchema.index({ 'resource.type': 1, 'resource.id': 1, timestamp: -1 });
accessTrackSchema.index({ anomalyScore: -1, timestamp: -1 });

/**
 * 获取指定时间范围内的访问统计
 * @param {Date} startDate - 开始日期
 * @param {Date} endDate - 结束日期
 * @returns {Promise<Object>} 统计结果
 */
accessTrackSchema.statics.getAccessStats = async function(startDate, endDate) {
  const stats = await this.aggregate([
    {
      $match: {
        timestamp: {
          $gte: startDate,
          $lte: endDate
        }
      }
    },
    {
      $group: {
        _id: {
          resourceType: "$resource.type",
          method: "$method"
        },
        count: { $sum: 1 },
        uniqueUsers: { $addToSet: "$userId" },
        uniqueIPs: { $addToSet: "$ip" },
        avgResponseTime: { $avg: "$responseTime" },
        anomalyCount: {
          $sum: { $cond: [{ $gt: ["$anomalyScore", 30] }, 1, 0] }
        }
      }
    },
    {
      $project: {
        resourceType: "$_id.resourceType",
        method: "$_id.method",
        count: 1,
        uniqueUserCount: { $size: "$uniqueUsers" },
        uniqueIPCount: { $size: "$uniqueIPs" },
        avgResponseTime: 1,
        anomalyCount: 1,
        anomalyPercentage: {
          $multiply: [
            { $divide: ["$anomalyCount", "$count"] },
            100
          ]
        }
      }
    },
    {
      $sort: { count: -1 }
    }
  ]);
  
  return stats;
};

/**
 * 获取用户访问模式
 * @param {String} userId - 用户ID
 * @param {Number} days - 天数
 * @returns {Promise<Object>} 访问模式数据
 */
accessTrackSchema.statics.getUserAccessPattern = async function(userId, days = 30) {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);
  
  const pattern = await this.aggregate([
    {
      $match: {
        userId: userId,
        timestamp: { $gte: startDate }
      }
    },
    {
      $group: {
        _id: {
          hour: { $hour: "$timestamp" },
          dayOfWeek: { $dayOfWeek: "$timestamp" }
        },
        count: { $sum: 1 },
        resources: { $addToSet: "$resource.type" }
      }
    },
    {
      $project: {
        hour: "$_id.hour",
        dayOfWeek: "$_id.dayOfWeek",
        count: 1,
        uniqueResourceCount: { $size: "$resources" }
      }
    },
    {
      $sort: { dayOfWeek: 1, hour: 1 }
    }
  ]);
  
  return pattern;
};

/**
 * 标记异常轨迹
 * @param {String} trackId - 轨迹ID
 * @param {Number} score - 异常分数
 * @param {Array} types - 异常类型
 * @returns {Promise<Object>} 更新后的轨迹
 */
accessTrackSchema.statics.markAnomaly = async function(trackId, score, types = []) {
  return this.findByIdAndUpdate(
    trackId,
    {
      $set: {
        anomalyScore: score,
        anomalyTypes: types,
        flags: ['suspicious']
      }
    },
    { new: true }
  );
};

/**
 * 添加轨迹标记
 * @param {String} trackId - 轨迹ID
 * @param {String} flag - 标记
 * @returns {Promise<Object>} 更新后的轨迹
 */
accessTrackSchema.statics.addFlag = async function(trackId, flag) {
  return this.findByIdAndUpdate(
    trackId,
    {
      $addToSet: { flags: flag }
    },
    { new: true }
  );
};

// 创建模型
const AccessTrack = mongoose.model('AccessTrack', accessTrackSchema);

module.exports = AccessTrack; 