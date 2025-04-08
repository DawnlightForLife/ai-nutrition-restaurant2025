const mongoose = require('mongoose');
const { logger } = require('../core/loggingMiddleware');
const config = require('../../config');

/**
 * 数据库优化中间件集合
 * 提供MongoDB/Mongoose查询优化功能，包括：
 * - 查询监控和统计
 * - 查询参数优化
 * - 查询结果缓存
 * - 批量操作优化
 */

// 慢查询阈值（毫秒）
const SLOW_QUERY_THRESHOLD = config.debug?.slowQueryThreshold || 500;

// 查询监控类
class QueryMonitor {
    constructor() {
        this.queries = [];
        this.slowQueries = [];
        this.totalQueries = 0;
        this.totalTime = 0;
        this.maxQueries = 1000; // 最多保存1000条查询记录
    }

    addQuery(query) {
        this.queries.push(query);
        this.totalQueries++;
        this.totalTime += query.duration;

        // 如果查询时间超过阈值，记录为慢查询
        if (query.duration > 100) { // 100ms阈值
            this.slowQueries.push(query);
        }

        // 限制存储的查询数量
        if (this.queries.length > this.maxQueries) {
            this.queries.shift();
        }
    }

    getStats() {
        return {
            totalQueries: this.totalQueries,
            averageTime: this.totalTime / this.totalQueries,
            slowQueries: this.slowQueries.length,
            recentQueries: this.queries.slice(-10)
        };
    }

    clear() {
        this.queries = [];
        this.slowQueries = [];
        this.totalQueries = 0;
        this.totalTime = 0;
    }
}

// 查询优化器类
class QueryOptimizer {
    constructor(options = {}) {
        this.options = {
            maxLimit: options.maxLimit || 50,
            defaultLimit: options.defaultLimit || 10,
            allowedFields: options.allowedFields || [],
            defaultSort: options.defaultSort || { createdAt: -1 },
            maxDepth: options.maxDepth || 3,
            ...options
        };
    }

    optimizeQuery(query) {
        // 优化limit
        if (query.limit > this.options.maxLimit) {
            query.limit = this.options.maxLimit;
        }

        // 优化sort
        if (query.sort) {
            const sortFields = Object.keys(query.sort);
            const invalidFields = sortFields.filter(field => 
                !this.options.allowedFields.includes(field)
            );
            if (invalidFields.length > 0) {
                query.sort = this.options.defaultSort;
            }
        }

        // 优化select
        if (query.select) {
            const selectFields = query.select.split(' ');
            const validFields = selectFields.filter(field => 
                this.options.allowedFields.includes(field)
            );
            if (validFields.length > 0) {
                query.select = validFields.join(' ');
            }
        }

        // 优化populate
        if (query.populate) {
            query.populate = this.optimizePopulate(query.populate);
        }

        return query;
    }

    optimizePopulate(populate, depth = 0) {
        if (depth >= this.options.maxDepth) {
            return null;
        }

        if (Array.isArray(populate)) {
            return populate.map(p => this.optimizePopulate(p, depth + 1));
        }

        if (typeof populate === 'object') {
            const optimized = { ...populate };
            if (optimized.populate) {
                optimized.populate = this.optimizePopulate(optimized.populate, depth + 1);
            }
            return optimized;
        }

        return populate;
    }
}

// 查询缓存类
class QueryCache {
    constructor(redis, options = {}) {
        this.redis = redis;
        this.options = {
            ttl: options.ttl || 300, // 默认5分钟
            prefix: options.prefix || 'cache:',
            ...options
        };
    }

    async get(key) {
        try {
            const data = await this.redis.get(`${this.options.prefix}${key}`);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            logger.error('Cache get error:', error);
            return null;
        }
    }

    async set(key, value, ttl = this.options.ttl) {
        try {
            await this.redis.set(
                `${this.options.prefix}${key}`,
                JSON.stringify(value),
                'EX',
                ttl
            );
            return true;
        } catch (error) {
            logger.error('Cache set error:', error);
            return false;
        }
    }

    async delete(key) {
        try {
            await this.redis.del(`${this.options.prefix}${key}`);
            return true;
        } catch (error) {
            logger.error('Cache delete error:', error);
            return false;
        }
    }

    async clear(pattern) {
        try {
            const keys = await this.redis.keys(`${this.options.prefix}${pattern}`);
            if (keys.length > 0) {
                await this.redis.del(keys);
            }
            return true;
        } catch (error) {
            logger.error('Cache clear error:', error);
            return false;
        }
    }
}

// 批量操作优化器类
class BatchOptimizer {
    constructor(options = {}) {
        this.options = {
            maxBatchSize: options.maxBatchSize || 1000,
            chunkSize: options.chunkSize || 100,
            ...options
        };
    }

    async processBatch(operations, processor) {
        const chunks = this.chunkArray(operations, this.options.chunkSize);
        const results = [];

        for (const chunk of chunks) {
            const chunkResults = await Promise.all(
                chunk.map(operation => processor(operation))
            );
            results.push(...chunkResults);
        }

        return results;
    }

    chunkArray(array, size) {
        const chunks = [];
        for (let i = 0; i < array.length; i += size) {
            chunks.push(array.slice(i, i + size));
        }
        return chunks;
    }
}

// 创建实例
const queryMonitor = new QueryMonitor();
const queryCache = new QueryCache(require('../security/advancedRateLimitMiddleware').redis);
const batchOptimizer = new BatchOptimizer();

// 中间件函数
const queryMonitorMiddleware = () => {
    return (req, res, next) => {
        const start = Date.now();
        
        res.on('finish', () => {
            const duration = Date.now() - start;
            queryMonitor.addQuery({
                method: req.method,
                path: req.path,
                duration,
                timestamp: new Date()
            });
        });

        next();
    };
};

const queryOptimizerMiddleware = (options) => {
    const optimizer = new QueryOptimizer(options);
    
    return (req, res, next) => {
        if (req.query) {
            req.query = optimizer.optimizeQuery(req.query);
        }
        next();
    };
};

const queryCacheMiddleware = (options) => {
    return async (req, res, next) => {
        if (req.method !== 'GET') {
            return next();
        }

        const cacheKey = `db:${req.path}:${JSON.stringify(req.query)}`;
        const cached = await queryCache.get(cacheKey);

        if (cached) {
            return res.json(cached);
        }

        const originalJson = res.json;
        res.json = function(data) {
            queryCache.set(cacheKey, data, options?.ttl);
            return originalJson.call(this, data);
        };

        next();
    };
};

const batchOptimizerMiddleware = (options) => {
    const optimizer = new BatchOptimizer(options);
    
    return (req, res, next) => {
        req.batchOptimizer = optimizer;
        next();
    };
};

// 数据库统计中间件
const dbStatsMiddleware = (req, res, next) => {
    if (req.path === '/api/db/stats') {
        res.json(queryMonitor.getStats());
    } else {
        next();
    }
};

// 监控查询执行时间的中间件
function monitorQueryTime(schema) {
  // 需要监控的操作类型
  const methodsToMonitor = [
    'find', 'findOne', 'findById', 
    'count', 'countDocuments', 'distinct',
    'findOneAndUpdate', 'findOneAndDelete',
    'aggregate', 'update', 'updateOne', 'updateMany',
    'deleteOne', 'deleteMany'
  ];
  
  methodsToMonitor.forEach(method => {
    schema.pre(method, function() {
      this._startTime = Date.now();
    });
    
    schema.post(method, function(result, next) {
      if (!this._startTime) return next();
      
      const duration = Date.now() - this._startTime;
      const collectionName = this.model.collection.name;
      
      // 记录查询执行时间
      if (config.debug?.logQueries) {
        logger.db.debug(`查询 ${collectionName}.${method} 耗时 ${duration}ms`);
      }
      
      // 如果是慢查询，记录到日志
      if (duration >= SLOW_QUERY_THRESHOLD) {
        const query = this.getQuery ? this.getQuery() : {};
        logger.logSlowQuery(collectionName, method, query, duration);
        
        // 如果配置了收集慢查询指标，保存到数据库
        if (config.database.collectQueryMetrics) {
          saveQueryMetrics(collectionName, method, query, duration, true);
        }
      }
      
      next();
    });
  });
  
  return schema;
}

/**
 * 保存查询性能指标
 * @param {string} collection 集合名称
 * @param {string} operation 操作类型
 * @param {Object} query 查询条件
 * @param {number} duration 执行时间（毫秒）
 * @param {boolean} isSlowQuery 是否为慢查询
 */
async function saveQueryMetrics(collection, operation, query, duration, isSlowQuery) {
  try {
    // 动态导入DbMetrics模型，避免循环依赖
    const { DbMetrics } = require('../../models');
    
    await DbMetrics.create({
      operation,
      collection,
      query: JSON.stringify(query),
      duration,
      timestamp: new Date(),
      slow_query: isSlowQuery
    });
  } catch (error) {
    logger.error('保存查询指标失败', error);
  }
}

/**
 * 自动应用索引提示（index hints）
 * @param {Object} schema Mongoose Schema
 */
function applyIndexHints(schema) {
  // 获取索引信息
  const schemaIndexes = Object.keys(schema.obj).filter(key => 
    schema.obj[key].index === true || 
    (schema.obj[key].index && schema.obj[key].index.background === true)
  );
  
  // 查询前添加索引提示
  schema.pre('find', function() {
    // 获取查询条件中的字段
    const queryFields = Object.keys(this.getQuery());
    
    // 找到第一个匹配的索引字段
    const matchingIndex = schemaIndexes.find(index => queryFields.includes(index));
    
    // 如果找到匹配的索引，且查询没有显式指定hint
    if (matchingIndex && !this._hint) {
      this.hint({ [matchingIndex]: 1 });
    }
  });
  
  return schema;
}

/**
 * 自动应用查询限制
 * @param {Object} schema Mongoose Schema
 */
function applyQueryLimits(schema) {
  // 设置默认查询限制
  const DEFAULT_LIMIT = config.database.defaultLimit || 100;
  const MAX_LIMIT = config.database.maxLimit || 500;
  
  schema.pre('find', function() {
    // 如果没有设置限制，添加默认限制
    if (!this.options.limit) {
      this.limit(DEFAULT_LIMIT);
    } 
    // 如果限制超过最大值，调整为最大限制
    else if (this.options.limit > MAX_LIMIT) {
      this.limit(MAX_LIMIT);
    }
  });
  
  return schema;
}

/**
 * 应用查询超时设置
 * @param {Object} schema Mongoose Schema
 */
function applyQueryTimeout(schema) {
  // 默认查询超时时间（毫秒）
  const DEFAULT_TIMEOUT = config.database.queryTimeout || 30000;
  
  // 查询前设置maxTimeMS
  ['find', 'findOne', 'findById', 'aggregate', 'count', 'countDocuments'].forEach(method => {
    schema.pre(method, function() {
      if (!this.options.maxTimeMS) {
        this.maxTimeMS(DEFAULT_TIMEOUT);
      }
    });
  });
  
  return schema;
}

/**
 * 主中间件函数，应用所有优化
 * @param {Object} schema Mongoose Schema
 */
function dbOptimizationMiddleware(schema) {
  // 应用监控
  monitorQueryTime(schema);
  
  // 只在非生产环境或启用了调试功能时应用这些优化
  if (process.env.NODE_ENV !== 'production' || config.debug?.enabled) {
    // 应用索引提示
    applyIndexHints(schema);
  }
  
  // 应用查询限制
  applyQueryLimits(schema);
  
  // 应用查询超时
  applyQueryTimeout(schema);
  
  return schema;
}

// 导出中间件和实例
module.exports = {
    queryMonitorMiddleware,
    queryOptimizerMiddleware,
    queryCacheMiddleware,
    batchOptimizerMiddleware,
    dbStatsMiddleware,
    queryMonitor,
    queryCache,
    batchOptimizer,
    dbOptimizationMiddleware,
    monitorQueryTime,
    applyIndexHints,
    applyQueryLimits,
    applyQueryTimeout
}; 