const logger = require('../../utils/logger/winstonLogger.js');
const mongoose = require('mongoose');
const modelRegistrar = require('../modelRegistrar');

/**
 * 数据库性能指标模型，用于监控和分析数据库性能
 */
const dbMetricsSchema = new mongoose.Schema({
  // 操作基本信息
  operation: {
    type: String,
    required: true,
    enum: ['find', 'findOne', 'findById', 'count', 'distinct', 'aggregate', 
           'save', 'create', 'update', 'updateOne', 'updateMany', 'delete', 
           'deleteOne', 'deleteMany', 'bulkWrite', 'other'],
    description: '执行的操作'
  },
  collection: {
    type: String,
    required: true,
    description: '操作的集合'
  },
  
  // 时间和性能数据
  timestamp: {
    type: Date,
    default: Date.now,
    description: '操作时间'
  },
  duration: {
    type: Number,
    required: true,
    min: 0,
    description: '操作持续时间(毫秒)'
  },
  slowQuery: {
    type: Boolean,
    default: false,
    description: '是否为慢查询'
  },
  
  // 查询详情
  query: {
    type: Object,
    description: '查询条件'
  },
  queryHash: {
    type: String,
    description: '查询哈希，用于识别相似查询'
  },
  documentsAffected: {
    type: Number,
    min: 0,
    description: '受影响的文档数'
  },
  resultSize: {
    type: Number,
    min: 0,
    description: '结果大小(字节)'
  },
  indexUsed: {
    type: String,
    description: '使用的索引'
  },
  
  // 系统上下文
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    description: '执行操作的用户'
  },
  apiRoute: {
    type: String,
    description: '触发操作的API路由'
  },
  serverInstance: {
    type: String,
    description: '服务器实例标识'
  },
  connectionType: {
    type: String,
    enum: ['primary', 'replica', 'direct'],
    default: 'primary',
    description: '使用的连接类型'
  },
  
  // 内存使用和系统负载
  memoryUsageMb: {
    type: Number,
    description: '操作期间的内存使用(MB)'
  },
  systemLoad: {
    type: Number,
    description: '系统负载'
  },
  
  // 分析信息
  explainData: {
    type: Object,
    description: 'MongoDB explain()结果数据'
  },
  indexingSuggestion: {
    type: String,
    description: '索引建议'
  },
  optimizationSuggestion: {
    type: String,
    description: '优化建议'
  }
}, { 
  timestamps: true 
});

// 添加索引
dbMetricsSchema.index({ timestamp: -1 });
dbMetricsSchema.index({ collection: 1, operation: 1, timestamp: -1 });
dbMetricsSchema.index({ slowQuery: 1, timestamp: -1 });
dbMetricsSchema.index({ queryHash: 1, timestamp: -1 });
dbMetricsSchema.index({ duration: -1, timestamp: -1 });

/**
 * 生成查询的哈希值，用于识别相似查询
 * @param {Object} query - 查询对象
 * @returns {String} 哈希值
 */
dbMetricsSchema.statics.generateQueryHash = function(query) {
  if (!query) return null;
  
  try {
    // 移除查询中的具体值，只保留结构
    const normalizedQuery = {};
    
    const normalizeObject = (obj) => {
      if (!obj || typeof obj !== 'object') return null;
      
      const result = {};
      
      Object.keys(obj).forEach(key => {
        if (key.startsWith('$')) {
          // 操作符保留
          if (Array.isArray(obj[key])) {
            result[key] = ['value'];
          } else if (typeof obj[key] === 'object') {
            result[key] = normalizeObject(obj[key]);
          } else {
            result[key] = 'value';
          }
        } else if (obj[key] && typeof obj[key] === 'object') {
          if (obj[key].$in) {
            result[key] = { $in: ['value'] };
          } else if (obj[key].$gt || obj[key].$gte || obj[key].$lt || obj[key].$lte) {
            result[key] = {};
            if (obj[key].$gt !== undefined) result[key].$gt = 'value';
            if (obj[key].$gte !== undefined) result[key].$gte = 'value';
            if (obj[key].$lt !== undefined) result[key].$lt = 'value';
            if (obj[key].$lte !== undefined) result[key].$lte = 'value';
          } else {
            result[key] = normalizeObject(obj[key]);
          }
        } else {
          result[key] = 'value';
        }
      });
      
      return result;
    };
    
    const normalized = normalizeObject(query);
    
    // 生成哈希
    const crypto = require('crypto');
    return crypto.createHash('md5').update(JSON.stringify(normalized)).digest('hex');
  } catch (error) {
    logger.error('生成查询哈希失败:', error);
    return null;
  }
};

/**
 * 获取集合的慢查询统计
 * @param {String} collection - 集合名
 * @param {Object} options - 查询选项
 * @returns {Promise<Object>} 统计结果
 */
dbMetricsSchema.statics.getSlowQueryStats = async function(collection, options = {}) {
  const { period = 24, limit = 10 } = options;
  
  const periodStart = new Date();
  periodStart.setHours(periodStart.getHours() - period);
  
  const pipeline = [
    {
      $match: {
        collection,
        timestamp: { $gte: periodStart },
        slowQuery: true
      }
    },
    {
      $group: {
        _id: '$queryHash',
        count: { $sum: 1 },
        avgDuration: { $avg: '$duration' },
        maxDuration: { $max: '$duration' },
        lastOccurrence: { $max: '$timestamp' },
        sampleQuery: { $first: '$query' }
      }
    },
    {
      $sort: { avgDuration: -1 }
    },
    {
      $limit: limit
    }
  ];
  
  return this.aggregate(pipeline);
};

/**
 * 获取索引使用情况统计
 * @param {String} collection - 集合名
 * @param {Object} options - 查询选项
 * @returns {Promise<Object>} 统计结果
 */
dbMetricsSchema.statics.getIndexUsageStats = async function(collection, options = {}) {
  const { period = 24 } = options;
  
  const periodStart = new Date();
  periodStart.setHours(periodStart.getHours() - period);
  
  const pipeline = [
    {
      $match: {
        collection,
        timestamp: { $gte: periodStart },
        indexUsed: { $exists: true, $ne: null }
      }
    },
    {
      $group: {
        _id: '$indexUsed',
        count: { $sum: 1 },
        avgDuration: { $avg: '$duration' },
        operations: { $addToSet: '$operation' }
      }
    },
    {
      $sort: { count: -1 }
    }
  ];
  
  return this.aggregate(pipeline);
};

/**
 * 分析集合性能并生成优化建议
 * @param {String} collection - 集合名
 * @returns {Promise<Object>} 优化建议
 */
dbMetricsSchema.statics.analyzeCollectionPerformance = async function(collection) {
  try {
    const periodStart = new Date();
    periodStart.setDate(periodStart.getDate() - 7);
    
    // 获取慢查询统计
    const slowQueries = await this.getSlowQueryStats(collection, { period: 168, limit: 5 });
    
    // 获取索引使用情况
    const indexUsage = await this.getIndexUsageStats(collection, { period: 168 });
    
    // 计算集合平均查询时间
    const avgQueryTime = await this.aggregate([
      {
        $match: {
          collection,
          timestamp: { $gte: periodStart }
        }
      },
      {
        $group: {
          _id: '$operation',
          avgDuration: { $avg: '$duration' },
          count: { $sum: 1 }
        }
      }
    ]);
    
    // 查询未使用索引的操作
    const nonIndexedQueries = await this.find({
      collection,
      timestamp: { $gte: periodStart },
      $or: [
        { indexUsed: null },
        { indexUsed: 'COLLSCAN' }
      ],
      duration: { $gt: 100 } // 超过100ms的查询
    }).limit(10).select('operation query duration timestamp');
    
    // 生成优化建议
    const suggestions = [];
    
    if (slowQueries.length > 0) {
      suggestions.push({
        type: 'slowQueries',
        message: `发现${slowQueries.length}个慢查询模式`,
        details: slowQueries.map(q => ({
          pattern: q.sampleQuery,
          count: q.count,
          avgDuration: q.avgDuration.toFixed(2) + 'ms'
        }))
      });
    }
    
    if (nonIndexedQueries.length > 0) {
      const indexSuggestions = nonIndexedQueries.map(q => {
        const fields = q.query ? Object.keys(q.query).filter(k => !k.startsWith('$')) : [];
        return {
          query: q.query,
          suggestedIndex: fields.length > 0 ? `{ ${fields.join(': 1, ')}: 1 }` : null,
          duration: q.duration
        };
      });
      
      suggestions.push({
        type: 'missingIndexes',
        message: `发现${nonIndexedQueries.length}个未使用索引的查询`,
        details: indexSuggestions
      });
    }
    
    // 返回分析结果
    return {
      collection,
      analyzeTime: new Date(),
      period: '7天',
      stats: {
        avgQueryTimes: avgQueryTime,
        slowQueriesCount: slowQueries.length,
        nonIndexedQueriesCount: nonIndexedQueries.length
      },
      indexUsage,
      suggestions
    };
  } catch (error) {
    logger.error(`分析集合 ${collection} 性能失败:`, error);
    return {
      collection,
      error: error.message,
      analyzeTime: new Date()
    };
  }
};

// 创建模型
const DbMetrics = modelRegistrar('DbMetrics', dbMetricsSchema, {
  timestamps: true,
  optimizedIndexes: {
    compound: [
      {
        fields: { collection: 1, operation: 1, slowQuery: 1, timestamp: -1 },
        name: 'perf_analysis_idx'
      }
    ],
    ttl: {
      field: 'timestamp',
      expireAfterSeconds: 30 * 24 * 60 * 60 // 30天后自动过期
    }
  }
});

module.exports = DbMetrics;