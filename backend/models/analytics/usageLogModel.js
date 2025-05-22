/**
 * 用户行为日志模型
 * 用于记录用户在应用中的各种操作和行为数据
 * @module models/analytics/usageLogModel
 */

const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');

// 定义用户行为日志模型
const usageLogSchema = new mongoose.Schema({
  // 基本用户信息
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    index: true,
    description: '用户ID，未登录用户为null'
  },
  sessionId: {
    type: String,
    required: true,
    index: true,
    description: '会话ID，用于关联同一会话内的行为'
  },
  anonymousId: {
    type: String,
    index: true,
    description: '匿名用户ID，用于跟踪未登录用户'
  },
  
  // 行为信息
  eventType: {
    type: String,
    required: true,
    enum: [
      'page_view',       // 页面访问
      'button_click',    // 按钮点击
      'form_submit',     // 表单提交
      'search',          // 搜索行为
      'filter',          // 筛选行为
      'feature_use',     // 功能使用
      'scroll',          // 页面滚动
      'hover',           // 悬停动作
      'navigation',      // 导航跳转
      'login',           // 登录行为
      'logout',          // 登出行为
      'registration',    // 注册行为
      'purchase',        // 购买行为
      'add_to_cart',     // 加入购物车
      'remove_from_cart',// 移除购物车商品
      'error',           // 错误事件
      'notification',    // 通知互动
      'recommendation',  // 推荐互动
      'share',           // 分享行为
      'custom'           // 自定义行为
    ],
    index: true,
    description: '事件类型'
  },
  eventName: {
    type: String,
    required: true,
    description: '事件名称，具体描述该行为'
  },
  eventCategory: {
    type: String,
    enum: [
      'user',            // 用户相关
      'merchant',        // 商家相关
      'order',           // 订单相关
      'nutrition',       // 营养相关
      'forum',           // 论坛相关
      'payment',         // 支付相关
      'system',          // 系统相关
      'navigation',      // 导航相关
      'search',          // 搜索相关
      'profile',         // 档案相关
      'notification',    // 通知相关
      'recommendation',  // 推荐相关
      'other'            // 其他类别
    ],
    default: 'other',
    index: true,
    description: '事件分类'
  },
  
  // 详细数据
  eventData: {
    type: mongoose.Schema.Types.Mixed,
    description: '事件附加数据，不同事件类型有不同数据结构'
  },
  
  // 上下文信息
  context: {
    page: {
      url: {
        type: String,
        description: '页面URL'
      },
      path: {
        type: String,
        description: '页面路径'
      },
      title: {
        type: String,
        description: '页面标题'
      },
      referrer: {
        type: String,
        description: '来源页面'
      }
    },
    app: {
      name: {
        type: String,
        description: '应用名称'
      },
      version: {
        type: String,
        description: '应用版本'
      },
      build: {
        type: String,
        description: '应用构建号'
      }
    },
    device: {
      type: {
        type: String,
        enum: ['mobile', 'tablet', 'desktop', 'wearable', 'other'],
        description: '设备类型'
      },
      model: {
        type: String,
        description: '设备型号'
      },
      manufacturer: {
        type: String,
        description: '设备制造商'
      },
      id: {
        type: String,
        description: '设备ID'
      }
    },
    os: {
      name: {
        type: String,
        description: '操作系统名称'
      },
      version: {
        type: String,
        description: '操作系统版本'
      }
    },
    browser: {
      name: {
        type: String,
        description: '浏览器名称'
      },
      version: {
        type: String,
        description: '浏览器版本'
      }
    },
    locale: {
      type: String,
      description: '用户语言设置'
    },
    userAgent: {
      type: String,
      description: '用户代理字符串'
    },
    ip: {
      type: String,
      description: '用户IP地址',
      sensitivityLevel: 2 // 中度敏感
    },
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
        latitude: {
          type: Number,
          description: '纬度'
        },
        longitude: {
          type: Number,
          description: '经度'
        }
      }
    }
  },
  
  // 性能数据
  performance: {
    loadTime: {
      type: Number,
      description: '页面加载时间(ms)'
    },
    responseTime: {
      type: Number,
      description: '服务器响应时间(ms)'
    },
    renderTime: {
      type: Number,
      description: '页面渲染时间(ms)'
    },
    totalTime: {
      type: Number,
      description: '总耗时(ms)'
    }
  },
  
  // 时间信息
  createdAt: {
    type: Date,
    default: Date.now,
    index: true,
    description: '事件发生时间'
  },
  
  // 分析标记
  isProcessed: {
    type: Boolean,
    default: false,
    description: '是否已被分析处理'
  },
  processedAt: {
    type: Date,
    description: '处理时间'
  }
}, {
  timestamps: true, // 创建createdAt和updatedAt字段
  collection: 'usageLogs',
  versionKey: false
});

// 索引设置 - 优化查询性能
usageLogSchema.index({ userId: 1, eventType: 1, createdAt: -1 });
usageLogSchema.index({ sessionId: 1, createdAt: -1 });
usageLogSchema.index({ eventCategory: 1, createdAt: -1 });
usageLogSchema.index({ 'context.page.path': 1, createdAt: -1 });
usageLogSchema.index({ createdAt: 1 }, { expireAfterSeconds: 15552000 }); // 自动删除180天前的日志

// 静态方法 - 批量记录行为日志
usageLogSchema.statics.logBatch = async function(logs) {
  if (!Array.isArray(logs) || logs.length === 0) {
    return { success: false, message: '没有提供日志数据' };
  }
  
  try {
    const result = await this.insertMany(logs);
    return { 
      success: true, 
      count: result.length,
      message: `成功记录${result.length}条行为日志`
    };
  } catch (error) {
    console.error('批量记录行为日志失败:', error);
    return { 
      success: false, 
      message: '批量记录行为日志失败',
      error: error.message
    };
  }
};

// 静态方法 - 获取用户行为摘要
usageLogSchema.statics.getUserActivitySummary = async function(userId, options = {}) {
  const { 
    startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 默认30天
    endDate = new Date(),
    categories = [] 
  } = options;
  
  const match = { 
    userId: mongoose.Types.ObjectId(userId),
    createdAt: { $gte: startDate, $lte: endDate }
  };
  
  if (categories.length > 0) {
    match.eventCategory = { $in: categories };
  }
  
  try {
    const summary = await this.aggregate([
      { $match: match },
      { $group: {
        _id: {
          eventType: '$eventType',
          eventCategory: '$eventCategory',
          day: { $dateToString: { format: '%Y-%m-%d', date: '$createdAt' } }
        },
        count: { $sum: 1 }
      }},
      { $group: {
        _id: {
          eventType: '$_id.eventType',
          eventCategory: '$_id.eventCategory'
        },
        dailyCounts: { 
          $push: { 
            date: '$_id.day', 
            count: '$count' 
          } 
        },
        totalCount: { $sum: '$count' }
      }},
      { $sort: { totalCount: -1 } }
    ]);
    
    return {
      success: true,
      userId,
      period: { startDate, endDate },
      data: summary
    };
  } catch (error) {
    console.error('获取用户行为摘要失败:', error);
    return {
      success: false,
      message: '获取用户行为摘要失败',
      error: error.message
    };
  }
};

// 静态方法 - 获取页面访问统计
usageLogSchema.statics.getPageViewStats = async function(options = {}) {
  const {
    startDate = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // 默认7天
    endDate = new Date(),
    limit = 10,
    paths = [] // 指定路径过滤
  } = options;
  
  const match = {
    eventType: 'page_view',
    createdAt: { $gte: startDate, $lte: endDate }
  };
  
  if (paths.length > 0) {
    match['context.page.path'] = { $in: paths };
  }
  
  try {
    const pageStats = await this.aggregate([
      { $match: match },
      { $group: {
        _id: '$context.page.path',
        views: { $sum: 1 },
        uniqueUsers: { $addToSet: '$userId' },
        uniqueSessions: { $addToSet: '$sessionId' },
        avgLoadTime: { $avg: '$performance.loadTime' }
      }},
      { $project: {
        path: '$_id',
        views: 1,
        uniqueUsers: { $size: '$uniqueUsers' },
        uniqueSessions: { $size: '$uniqueSessions' },
        avgLoadTime: 1,
        _id: 0
      }},
      { $sort: { views: -1 } },
      { $limit: limit }
    ]);
    
    return {
      success: true,
      period: { startDate, endDate },
      data: pageStats
    };
  } catch (error) {
    console.error('获取页面访问统计失败:', error);
    return {
      success: false,
      message: '获取页面访问统计失败',
      error: error.message
    };
  }
};

// 配置分片策略 - 按照时间分片存储
usageLogSchema.set('shardKey', {
  createdAt: 1
});

// 前置钩子 - 数据清洗与规范化
usageLogSchema.pre('save', function(next) {
  // 清除敏感信息
  if (this.eventData && this.eventData.password) {
    delete this.eventData.password;
  }
  
  // 确保匿名ID和用户ID至少一个有值
  if (!this.userId && !this.anonymousId) {
    this.anonymousId = 'unknown-' + Date.now() + '-' + Math.random().toString(36).substring(2, 10);
  }
  
  next();
});

// 使用ModelFactory创建支持分片的模型
const UsageLog = ModelFactory.createModel('UsageLog', usageLogSchema);

// 添加分片支持的保存方法
const originalSave = UsageLog.prototype.save;
UsageLog.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.UsageLog) {
    // 使用月份作为分片键
    const date = this.createdAt || new Date();
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    const shardKey = `${year}-${month.toString().padStart(2, '0')}`;
    
    const shardCollection = shardingService.getShardName('UsageLog', shardKey);
    console.log(`将行为日志存储到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = UsageLog; 